Return-Path: <linux-kernel-owner+w=401wt.eu-S1763723AbXILHnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763723AbXILHnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXILHnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:41 -0400
Received: from ozlabs.org ([203.10.76.45]:46298 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbXILHnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:40 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 01/15] Extract the file descriptor search logic in SPU coredump code
Date: Wed, 12 Sep 2007 17:43:39 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the logic for searching through the file descriptors for spu contexts
into a separate routine, coredump_next_context(), so we can use it elsewhere
in future. In the process we flatten the for loop, and move the NOSCHED test
into coredump_next_context().

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |   58 +++++++++++++++++---------
 1 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 5e31799..99f8e0b 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -109,16 +109,11 @@ static int spufs_ctx_note_size(struct spufs_ctx_info *ctx_info)
 	return total;
 }
 
-static int spufs_add_one_context(struct file *file, int dfd)
+static int spufs_add_one_context(struct spu_context *ctx, int dfd)
 {
-	struct spu_context *ctx;
 	struct spufs_ctx_info *ctx_info;
 	int size;
 
-	ctx = SPUFS_I(file->f_dentry->d_inode)->i_ctx;
-	if (ctx->flags & SPU_CREATE_NOSCHED)
-		return 0;
-
 	ctx_info = kzalloc(sizeof(*ctx_info), GFP_KERNEL);
 	if (unlikely(!ctx_info))
 		return -ENOMEM;
@@ -142,22 +137,45 @@ static int spufs_add_one_context(struct file *file, int dfd)
  * internal functionality to dump them without needing to actually
  * open the files.
  */
-static int spufs_arch_notes_size(void)
+static struct spu_context *coredump_next_context(int *fd)
 {
 	struct fdtable *fdt = files_fdtable(current->files);
-	int size = 0, fd;
-
-	for (fd = 0; fd < fdt->max_fds; fd++) {
-		if (FD_ISSET(fd, fdt->open_fds)) {
-			struct file *file = fcheck(fd);
-
-			if (file && file->f_op == &spufs_context_fops) {
-				int rval = spufs_add_one_context(file, fd);
-				if (rval < 0)
-					break;
-				size += rval;
-			}
-		}
+	struct file *file;
+	struct spu_context *ctx = NULL;
+
+	for (; *fd < fdt->max_fds; (*fd)++) {
+		if (!FD_ISSET(*fd, fdt->open_fds))
+			continue;
+
+		file = fcheck(*fd);
+
+		if (!file || file->f_op != &spufs_context_fops)
+			continue;
+
+		ctx = SPUFS_I(file->f_dentry->d_inode)->i_ctx;
+		if (ctx->flags & SPU_CREATE_NOSCHED)
+			continue;
+
+		/* start searching the next fd next time we're called */
+		(*fd)++;
+		break;
+	}
+
+	return ctx;
+}
+
+static int spufs_arch_notes_size(void)
+{
+	struct spu_context *ctx;
+	int size = 0, rc, fd;
+
+	fd = 0;
+	while ((ctx = coredump_next_context(&fd)) != NULL) {
+		rc = spufs_add_one_context(ctx, fd);
+		if (rc < 0)
+			break;
+
+		size += rc;
 	}
 
 	return size;
-- 
1.5.1.3.g7a33b

