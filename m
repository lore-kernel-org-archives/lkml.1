Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXBLSbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXBLSbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXBLSbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:31:11 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34236 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275AbXBLSbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:31:06 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/3] fs/unionfs/: Use __roundup_pow_of_two instead of custom rounding code
Date: Mon, 12 Feb 2007 13:30:50 -0500
Message-Id: <11713050522466-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.rc3.g5057
In-Reply-To: <11713050521708-git-send-email-jsipek@cs.sunysb.edu>
References: <11713050521708-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/rdstate.c |   11 ++---------
 fs/unionfs/union.h   |    1 +
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index 16ce1bf..e240285 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -115,19 +115,12 @@ struct unionfs_dir_state *alloc_rdstate(struct inode *inode, int bindex)
 {
 	int i = 0;
 	int hashsize;
-	int mallocsize = sizeof(struct unionfs_dir_state);
+	unsigned long mallocsize = sizeof(struct unionfs_dir_state);
 	struct unionfs_dir_state *rdstate;
 
 	hashsize = guesstimate_hash_size(inode);
 	mallocsize += hashsize * sizeof(struct list_head);
-	/* Round it up to the next highest power of two. */
-	mallocsize--;
-	mallocsize |= mallocsize >> 1;
-	mallocsize |= mallocsize >> 2;
-	mallocsize |= mallocsize >> 4;
-	mallocsize |= mallocsize >> 8;
-	mallocsize |= mallocsize >> 16;
-	mallocsize++;
+	mallocsize = __roundup_pow_of_two(mallocsize);
 
 	/* This should give us about 500 entries anyway. */
 	if (mallocsize > PAGE_SIZE)
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 8e9a1cc..fc87b03 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -41,6 +41,7 @@
 #include <linux/xattr.h>
 #include <linux/fs_stack.h>
 #include <linux/magic.h>
+#include <linux/log2.h>
 
 #include <asm/mman.h>
 #include <asm/system.h>
-- 
1.5.0.rc3.g5057

