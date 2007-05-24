Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbXEXAiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbXEXAiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760922AbXEXAgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:32 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40227 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482AbXEXAgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:24 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 15/21] Unionfs: Use krealloc instead of open-coding the functionality
Date: Wed, 23 May 2007 20:36:05 -0400
Message-Id: <11799669732333-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the branch management code to use krealloc instead of playing tricks
with kmalloc/memcpy/kfree.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |   56 +++++++++++++---------------------------------------
 1 files changed, 14 insertions(+), 42 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index b7f0b45..3dee863 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -427,6 +427,7 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	struct unionfs_data *new_data = NULL, *tmp_data = NULL;
 	struct path *new_lower_paths = NULL, *tmp_lower_paths = NULL;
 	int new_high_branch_id;	/* new high branch ID */
+	int size;		/* memory allocation size, temp var */
 
 	unionfs_write_lock(sb);
 
@@ -634,49 +635,20 @@ out_no_change:
 	 * Also handle invalidating any pages that will have to be re-read.
 	 *******************************************************************/
 
-	/*
-	 * Allocate space for actual pointers, if needed.  By the time we
-	 * finish this block of code, new_branches and new_lower_paths will
-	 * have the correct size.  None of this code below would be needed
-	 * if the kernel had a realloc() function, at least one capable of
-	 * shrinking/truncating an allocation's size (hint, hint).
-	 */
-	if (new_branches < max_branches) {
+	/* (re)allocate space for new pointers to hidden dentry */
+	size = new_branches * sizeof(struct unionfs_data);
+	new_data = krealloc(tmp_data, size, GFP_KERNEL);
+	if (!new_data) {
+		err = -ENOMEM;
+		goto out_release;
+	}
 
-		/* allocate space for new pointers to hidden dentry */
-		new_data = kcalloc(new_branches,
-				   sizeof(struct unionfs_data), GFP_KERNEL);
-		if (!new_data) {
-			err = -ENOMEM;
-			goto out_release;
-		}
-		/* allocate space for new pointers to lower paths */
-		new_lower_paths = kcalloc(new_branches,
-					  sizeof(struct path), GFP_KERNEL);
-		if (!new_lower_paths) {
-			err = -ENOMEM;
-			goto out_release;
-		}
-		/*
-		 * copy current info into new placeholders, incrementing
-		 * refcounts.
-		 */
-		memcpy(new_data, tmp_data,
-		       new_branches * sizeof(struct unionfs_data));
-		memcpy(new_lower_paths, tmp_lower_paths,
-		       new_branches * sizeof(struct path));
-		/*
-		 * Since we already hold various refcnts on the objects, we
-		 * don't need to redo it here.  Just free the older memory
-		 * and re-point the pointers.
-		 */
-		kfree(tmp_data);
-		kfree(tmp_lower_paths);
-		/* no need to nullify pointers here */
-	} else {
-		/* number of branches didn't change, no need to re-alloc */
-		new_data = tmp_data;
-		new_lower_paths = tmp_lower_paths;
+	/* allocate space for new pointers to lower paths */
+	size = new_branches * sizeof(struct path);
+	new_lower_paths = krealloc(tmp_lower_paths, size, GFP_KERNEL);
+	if (!new_lower_paths) {
+		err = -ENOMEM;
+		goto out_release;
 	}
 
 	/*
-- 
1.5.2.rc1.165.gaf9b

