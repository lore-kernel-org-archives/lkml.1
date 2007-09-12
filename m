Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbXILHoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbXILHoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXILHnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:42 -0400
Received: from ozlabs.org ([203.10.76.45]:46302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbXILHnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:41 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <b6dfd1df766cf45484209405cb522039b4259f71.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 02/15] Remove ctx_info and ctx_info_list
Date: Wed, 12 Sep 2007 17:43:40 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the ctx_info struct entirely, and also the ctx_info_list. This fixes
a race where two processes can clobber each other's ctx_info structs.

Instead of using the list, we just repeat the search through the file
descriptor table.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |   79 ++++++-------------------
 1 files changed, 19 insertions(+), 60 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 99f8e0b..6663669 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -31,15 +31,6 @@
 
 #include "spufs.h"
 
-struct spufs_ctx_info {
-	struct list_head list;
-	int dfd;
-	int memsize; /* in bytes */
-	struct spu_context *ctx;
-};
-
-static LIST_HEAD(ctx_info_list);
-
 static ssize_t do_coredump_read(int num, struct spu_context *ctx, void __user *buffer,
 				size_t size, loff_t *off)
 {
@@ -73,25 +64,17 @@ static int spufs_dump_seek(struct file *file, loff_t off)
 	return 1;
 }
 
-static void spufs_fill_memsize(struct spufs_ctx_info *ctx_info)
+static u64 ctx_ls_size(struct spu_context *ctx)
 {
-	struct spu_context *ctx;
-	unsigned long long lslr;
-
-	ctx = ctx_info->ctx;
-	lslr = ctx->csa.priv2.spu_lslr_RW;
-	ctx_info->memsize = lslr + 1;
+	return ctx->csa.priv2.spu_lslr_RW + 1;
 }
 
-static int spufs_ctx_note_size(struct spufs_ctx_info *ctx_info)
+static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
 {
-	int dfd, memsize, i, sz, total = 0;
+	int i, sz, total = 0;
 	char *name;
 	char fullname[80];
 
-	dfd = ctx_info->dfd;
-	memsize = ctx_info->memsize;
-
 	for (i = 0; spufs_coredump_read[i].name; i++) {
 		name = spufs_coredump_read[i].name;
 		sz = spufs_coredump_read[i].size;
@@ -101,7 +84,7 @@ static int spufs_ctx_note_size(struct spufs_ctx_info *ctx_info)
 		total += sizeof(struct elf_note);
 		total += roundup(strlen(fullname) + 1, 4);
 		if (!strcmp(name, "mem"))
-			total += roundup(memsize, 4);
+			total += roundup(ctx_ls_size(ctx), 4);
 		else
 			total += roundup(sz, 4);
 	}
@@ -109,25 +92,6 @@ static int spufs_ctx_note_size(struct spufs_ctx_info *ctx_info)
 	return total;
 }
 
-static int spufs_add_one_context(struct spu_context *ctx, int dfd)
-{
-	struct spufs_ctx_info *ctx_info;
-	int size;
-
-	ctx_info = kzalloc(sizeof(*ctx_info), GFP_KERNEL);
-	if (unlikely(!ctx_info))
-		return -ENOMEM;
-
-	ctx_info->dfd = dfd;
-	ctx_info->ctx = ctx;
-
-	spufs_fill_memsize(ctx_info);
-
-	size = spufs_ctx_note_size(ctx_info);
-	list_add(&ctx_info->list, &ctx_info_list);
-	return size;
-}
-
 /*
  * The additional architecture-specific notes for Cell are various
  * context files in the spu context.
@@ -171,7 +135,7 @@ static int spufs_arch_notes_size(void)
 
 	fd = 0;
 	while ((ctx = coredump_next_context(&fd)) != NULL) {
-		rc = spufs_add_one_context(ctx, fd);
+		rc = spufs_ctx_note_size(ctx, fd);
 		if (rc < 0)
 			break;
 
@@ -181,12 +145,11 @@ static int spufs_arch_notes_size(void)
 	return size;
 }
 
-static void spufs_arch_write_note(struct spufs_ctx_info *ctx_info, int i,
-				struct file *file)
+static void spufs_arch_write_note(struct spu_context *ctx, int i,
+				struct file *file, int dfd)
 {
-	struct spu_context *ctx;
 	loff_t pos = 0;
-	int sz, dfd, rc, total = 0;
+	int sz, rc, total = 0;
 	const int bufsz = PAGE_SIZE;
 	char *name;
 	char fullname[80], *buf;
@@ -196,18 +159,13 @@ static void spufs_arch_write_note(struct spufs_ctx_info *ctx_info, int i,
 	if (!buf)
 		return;
 
-	dfd = ctx_info->dfd;
 	name = spufs_coredump_read[i].name;
 
 	if (!strcmp(name, "mem"))
-		sz = ctx_info->memsize;
+		sz = ctx_ls_size(ctx);
 	else
 		sz = spufs_coredump_read[i].size;
 
-	ctx = ctx_info->ctx;
-	if (!ctx)
-		goto out;
-
 	sprintf(fullname, "SPU/%d/%s", dfd, name);
 	en.n_namesz = strlen(fullname) + 1;
 	en.n_descsz = sz;
@@ -237,16 +195,17 @@ out:
 
 static void spufs_arch_write_notes(struct file *file)
 {
-	int j;
-	struct spufs_ctx_info *ctx_info, *next;
+	struct spu_context *ctx;
+	int fd, j;
+
+	fd = 0;
+	while ((ctx = coredump_next_context(&fd)) != NULL) {
+		spu_acquire_saved(ctx);
 
-	list_for_each_entry_safe(ctx_info, next, &ctx_info_list, list) {
-		spu_acquire_saved(ctx_info->ctx);
 		for (j = 0; j < spufs_coredump_num_notes; j++)
-			spufs_arch_write_note(ctx_info, j, file);
-		spu_release_saved(ctx_info->ctx);
-		list_del(&ctx_info->list);
-		kfree(ctx_info);
+			spufs_arch_write_note(ctx, j, file, fd);
+
+		spu_release_saved(ctx);
 	}
 }
 
-- 
1.5.1.3.g7a33b

