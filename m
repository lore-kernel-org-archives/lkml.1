Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXEXAjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXEXAjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXEXAgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40228 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809AbXEXAgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:25 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 14/21] Unionfs: Call realloc unconditionally
Date: Wed, 23 May 2007 20:36:04 -0400
Message-Id: <11799669733164-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

krealloc already checks if the new size is greater than the old size.
Therefore, we can call realloc unconditionally - making the code simpler and
cleaner.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index cf78c46..758c813 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -451,17 +451,17 @@ void free_dentry_private_data(struct unionfs_dentry_info *udi)
 /* allocate new dentry private data, free old one if necessary */
 int new_dentry_private_data(struct dentry *dentry)
 {
-	int new_size;
 	int size;
 	struct unionfs_dentry_info *info = UNIONFS_D(dentry);
+	void *p;
 	int unlock_on_err = 0;
 
 	spin_lock(&dentry->d_lock);
 	if (!info) {
 		dentry->d_fsdata = kmem_cache_alloc(unionfs_dentry_cachep,
 						    GFP_ATOMIC);
+		
 		info = UNIONFS_D(dentry);
-
 		if (!info)
 			goto out;
 
@@ -470,9 +470,7 @@ int new_dentry_private_data(struct dentry *dentry)
 		unlock_on_err = 1;
 
 		info->lower_paths = NULL;
-		size = 0;
-	} else
-		size = sizeof(struct path) * info->bcount;
+	}
 
 	info->bstart = -1;
 	info->bend = -1;
@@ -481,21 +479,13 @@ int new_dentry_private_data(struct dentry *dentry)
 	atomic_set(&info->generation,
 		   atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
 
-	new_size = sizeof(struct path) * sbmax(dentry->d_sb);
-
-	/*
-	 * Don't reallocate when we already have enough space.
-	 */
-	if (new_size > size) {
-		void *p;
+	size = sizeof(struct path) * sbmax(dentry->d_sb);
 
-		p = krealloc(info->lower_paths, new_size, GFP_ATOMIC);
-		if (!p)
-			goto out_free;
+	p = krealloc(info->lower_paths, size, GFP_ATOMIC);
+	if (!p)
+		goto out_free;
 
-		info->lower_paths = p;
-		size = new_size;
-	}
+	info->lower_paths = p;
 	memset(info->lower_paths, 0, size);
 
 	spin_unlock(&dentry->d_lock);
-- 
1.5.2.rc1.165.gaf9b

