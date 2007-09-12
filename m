Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXILHpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXILHpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbXILHnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:45 -0400
Received: from ozlabs.org ([203.10.76.45]:46392 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439AbXILHno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:44 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <895526252184eee5548e553d1cfec642b7fc68b8.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 06/15] Correctly calculate the size of the local-store to dump
Date: Wed, 12 Sep 2007 17:43:43 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The routine to dump the local store, __spufs_mem_read(), does not take the
spu_lslr_RW value into account - so we shouldn't check it when we're
calculating the size either.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index c65b717..52d6219 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -66,11 +66,6 @@ static int spufs_dump_seek(struct file *file, loff_t off)
 	return 1;
 }
 
-static u64 ctx_ls_size(struct spu_context *ctx)
-{
-	return ctx->csa.priv2.spu_lslr_RW + 1;
-}
-
 static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
 {
 	int i, sz, total = 0;
@@ -85,10 +80,7 @@ static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
 
 		total += sizeof(struct elf_note);
 		total += roundup(strlen(fullname) + 1, 4);
-		if (!strcmp(name, "mem"))
-			total += roundup(ctx_ls_size(ctx), 4);
-		else
-			total += roundup(sz, 4);
+		total += roundup(sz, 4);
 	}
 
 	return total;
@@ -164,11 +156,7 @@ static void spufs_arch_write_note(struct spu_context *ctx, int i,
 		return;
 
 	name = spufs_coredump_read[i].name;
-
-	if (!strcmp(name, "mem"))
-		sz = ctx_ls_size(ctx);
-	else
-		sz = spufs_coredump_read[i].size;
+	sz = spufs_coredump_read[i].size;
 
 	sprintf(fullname, "SPU/%d/%s", dfd, name);
 	en.n_namesz = strlen(fullname) + 1;
-- 
1.5.1.3.g7a33b

