Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbXILHsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbXILHsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763556AbXILHnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:53 -0400
Received: from ozlabs.org ([203.10.76.45]:46507 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761542AbXILHnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:51 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <b0146801accdbfb9453b8ba2f6d8dc2a988659c7.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 13/15] Handle errors in SPU coredump code, and support coredump to a pipe
Date: Wed, 12 Sep 2007 17:43:50 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rework spufs_coredump_extra_notes_write() to check for and return errors.

If we're coredumping to a pipe we can't trust file->f_pos, we need to
maintain the foffset value passed to us. The cleanest way to do this is
to have the low level write routine increment foffset when we've
successfully written.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spu_syscalls.c   |    8 +--
 arch/powerpc/platforms/cell/spufs/coredump.c |   89 ++++++++++++++++++--------
 arch/powerpc/platforms/cell/spufs/spufs.h    |    2 +-
 include/asm-powerpc/spu.h                    |    2 +-
 4 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index d9b2fd2..0b69107 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -129,19 +129,17 @@ int elf_coredump_extra_notes_size(void)
 int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset)
 {
 	struct spufs_calls *calls;
+	int ret;
 
 	calls = spufs_calls_get();
 	if (!calls)
 		return 0;
 
-	calls->coredump_extra_notes_write(file);
+	ret = calls->coredump_extra_notes_write(file, foffset);
 
 	spufs_calls_put(calls);
 
-	/* Fudge foffset for now */
-	*foffset = file->f_pos;
-
-	return 0;
+	return ret;
 }
 
 int register_spu_syscalls(struct spufs_calls *calls)
diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 7395350..c3b5cd5 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -51,19 +51,34 @@ static ssize_t do_coredump_read(int num, struct spu_context *ctx, void *buffer,
  * These are the only things you should do on a core-file: use only these
  * functions to write out all the necessary info.
  */
-static int spufs_dump_write(struct file *file, const void *addr, int nr)
+static int spufs_dump_write(struct file *file, const void *addr, int nr, loff_t *foffset)
 {
-	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+	ssize_t written;
+
+	written = file->f_op->write(file, addr, nr, &file->f_pos);
+	*foffset += written;
+
+	if (written != nr)
+		return -EIO;
+
+	return 0;
 }
 
-static int spufs_dump_seek(struct file *file, loff_t off)
+static int spufs_dump_align(struct file *file, char *buf, loff_t new_off,
+			    loff_t *foffset)
 {
-	if (file->f_op->llseek) {
-		if (file->f_op->llseek(file, off, 0) != off)
-			return 0;
-	} else
-		file->f_pos = off;
-	return 1;
+	int rc, size;
+
+	size = min((loff_t)PAGE_SIZE, new_off - *foffset);
+	memset(buf, 0, size);
+
+	rc = 0;
+	while (rc == 0 && new_off > *foffset) {
+		size = min((loff_t)PAGE_SIZE, new_off - *foffset);
+		rc = spufs_dump_write(file, buf, size, foffset);
+	}
+
+	return rc;
 }
 
 static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
@@ -141,11 +156,11 @@ int spufs_coredump_extra_notes_size(void)
 	return size;
 }
 
-static void spufs_arch_write_note(struct spu_context *ctx, int i,
-				struct file *file, int dfd)
+static int spufs_arch_write_note(struct spu_context *ctx, int i,
+				  struct file *file, int dfd, loff_t *foffset)
 {
 	loff_t pos = 0;
-	int sz, rc, total = 0;
+	int sz, rc, nread, total = 0;
 	const int bufsz = PAGE_SIZE;
 	char *name;
 	char fullname[80], *buf;
@@ -153,7 +168,7 @@ static void spufs_arch_write_note(struct spu_context *ctx, int i,
 
 	buf = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!buf)
-		return;
+		return -ENOMEM;
 
 	name = spufs_coredump_read[i].name;
 	sz = spufs_coredump_read[i].size;
@@ -163,40 +178,60 @@ static void spufs_arch_write_note(struct spu_context *ctx, int i,
 	en.n_descsz = sz;
 	en.n_type = NT_SPU;
 
-	if (!spufs_dump_write(file, &en, sizeof(en)))
+	rc = spufs_dump_write(file, &en, sizeof(en), foffset);
+	if (rc)
 		goto out;
-	if (!spufs_dump_write(file, fullname, en.n_namesz))
+
+	rc = spufs_dump_write(file, fullname, en.n_namesz, foffset);
+	if (rc)
 		goto out;
-	if (!spufs_dump_seek(file, roundup((unsigned long)file->f_pos, 4)))
+
+	rc = spufs_dump_align(file, buf, roundup(*foffset, 4), foffset);
+	if (rc)
 		goto out;
 
 	do {
-		rc = do_coredump_read(i, ctx, buf, bufsz, &pos);
-		if (rc > 0) {
-			if (!spufs_dump_write(file, buf, rc))
+		nread = do_coredump_read(i, ctx, buf, bufsz, &pos);
+		if (nread > 0) {
+			rc = spufs_dump_write(file, buf, nread, foffset);
+			if (rc)
 				goto out;
-			total += rc;
+			total += nread;
 		}
-	} while (rc == bufsz && total < sz);
+	} while (nread == bufsz && total < sz);
+
+	if (nread < 0) {
+		rc = nread;
+		goto out;
+	}
+
+	rc = spufs_dump_align(file, buf, roundup(*foffset - total + sz, 4),
+			      foffset);
 
-	spufs_dump_seek(file, roundup((unsigned long)file->f_pos
-						- total + sz, 4));
 out:
 	free_page((unsigned long)buf);
+	return rc;
 }
 
-void spufs_coredump_extra_notes_write(struct file *file)
+int spufs_coredump_extra_notes_write(struct file *file, loff_t *foffset)
 {
 	struct spu_context *ctx;
-	int fd, j;
+	int fd, j, rc;
 
 	fd = 0;
 	while ((ctx = coredump_next_context(&fd)) != NULL) {
 		spu_acquire_saved(ctx);
 
-		for (j = 0; j < spufs_coredump_num_notes; j++)
-			spufs_arch_write_note(ctx, j, file, fd);
+		for (j = 0; j < spufs_coredump_num_notes; j++) {
+			rc = spufs_arch_write_note(ctx, j, file, fd, foffset);
+			if (rc) {
+				spu_release_saved(ctx);
+				return rc;
+			}
+		}
 
 		spu_release_saved(ctx);
 	}
+
+	return 0;
 }
diff --git a/arch/powerpc/platforms/cell/spufs/spufs.h b/arch/powerpc/platforms/cell/spufs/spufs.h
index c7b4e03..ca47b99 100644
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -206,7 +206,7 @@ long spufs_create(struct nameidata *nd, unsigned int flags,
 			mode_t mode, struct file *filp);
 /* ELF coredump callbacks for writing SPU ELF notes */
 extern int spufs_coredump_extra_notes_size(void);
-extern void spufs_coredump_extra_notes_write(struct file *file);
+extern int spufs_coredump_extra_notes_write(struct file *file, loff_t *foffset);
 
 extern const struct file_operations spufs_context_fops;
 
diff --git a/include/asm-powerpc/spu.h b/include/asm-powerpc/spu.h
index 10c40cd..eed63dd 100644
--- a/include/asm-powerpc/spu.h
+++ b/include/asm-powerpc/spu.h
@@ -245,7 +245,7 @@ struct spufs_calls {
 	long (*spu_run)(struct file *filp, __u32 __user *unpc,
 						__u32 __user *ustatus);
 	int (*coredump_extra_notes_size)(void);
-	void (*coredump_extra_notes_write)(struct file *file);
+	int (*coredump_extra_notes_write)(struct file *file, loff_t *foffset);
 	struct module *owner;
 };
 
-- 
1.5.1.3.g7a33b

