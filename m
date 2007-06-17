Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbXFQTKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbXFQTKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760796AbXFQTJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:09:46 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36829 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760718AbXFQTJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:09:44 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 12/16] Unionfs: Cleanup new_dentry_private_data
Date: Sun, 17 Jun 2007 15:09:19 -0400
Message-Id: <11821073643856-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |   96 +++++++++++++++++++++++++++++++-------------------
 fs/unionfs/union.h  |    1 +
 2 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 758c813..246a67a 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -106,11 +106,22 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		BUG_ON(UNIONFS_D(dentry) != NULL);
 		locked_child = 1;
 	}
-	if (lookupmode != INTERPOSE_PARTIAL) {
-		if ((err = new_dentry_private_data(dentry)))
-			goto out;
-		allocated_new_info = 1;
+
+	switch(lookupmode) {
+		case INTERPOSE_PARTIAL:
+			break;
+		case INTERPOSE_LOOKUP:
+			if ((err = new_dentry_private_data(dentry)))
+				goto out;
+			allocated_new_info = 1;
+			break;
+		default:
+			if ((err = realloc_dentry_private_data(dentry)))
+				goto out;
+			allocated_new_info = 1;
+			break;
 	}
+
 	/* must initialize dentry operations */
 	dentry->d_op = &unionfs_dops;
 
@@ -448,58 +459,69 @@ void free_dentry_private_data(struct unionfs_dentry_info *udi)
 	kmem_cache_free(unionfs_dentry_cachep, udi);
 }
 
-/* allocate new dentry private data, free old one if necessary */
-int new_dentry_private_data(struct dentry *dentry)
+static inline int __realloc_dentry_private_data(struct dentry *dentry)
 {
-	int size;
 	struct unionfs_dentry_info *info = UNIONFS_D(dentry);
 	void *p;
-	int unlock_on_err = 0;
-
-	spin_lock(&dentry->d_lock);
-	if (!info) {
-		dentry->d_fsdata = kmem_cache_alloc(unionfs_dentry_cachep,
-						    GFP_ATOMIC);
-		
-		info = UNIONFS_D(dentry);
-		if (!info)
-			goto out;
+	int size;
 
-		mutex_init(&info->lock);
-		mutex_lock(&info->lock);
-		unlock_on_err = 1;
+	BUG_ON(!info);
 
-		info->lower_paths = NULL;
-	}
+	size = sizeof(struct path) * sbmax(dentry->d_sb);
+	p = krealloc(info->lower_paths, size, GFP_ATOMIC);
+	if (!p)
+		return -ENOMEM;
+
+	info->lower_paths = p;
 
 	info->bstart = -1;
 	info->bend = -1;
 	info->bopaque = -1;
 	info->bcount = sbmax(dentry->d_sb);
 	atomic_set(&info->generation,
-		   atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
-
-	size = sizeof(struct path) * sbmax(dentry->d_sb);
-
-	p = krealloc(info->lower_paths, size, GFP_ATOMIC);
-	if (!p)
-		goto out_free;
+			atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
 
-	info->lower_paths = p;
 	memset(info->lower_paths, 0, size);
 
-	spin_unlock(&dentry->d_lock);
 	return 0;
+}
 
-out_free:
-	kfree(info->lower_paths);
-	if (unlock_on_err)
-		mutex_unlock(&info->lock);
+/* UNIONFS_D(dentry)->lock must be locked */
+int realloc_dentry_private_data(struct dentry *dentry)
+{
+	if (!__realloc_dentry_private_data(dentry))
+		return 0;
 
-out:
+	kfree(UNIONFS_D(dentry)->lower_paths);
+	free_dentry_private_data(UNIONFS_D(dentry));
+	dentry->d_fsdata = NULL;
+	return -ENOMEM;
+}
+
+/* allocate new dentry private data */
+int new_dentry_private_data(struct dentry *dentry)
+{
+	struct unionfs_dentry_info *info = UNIONFS_D(dentry);
+
+	BUG_ON(info);
+
+	info = kmem_cache_alloc(unionfs_dentry_cachep, GFP_ATOMIC);
+	if (!info)
+		return -ENOMEM;
+
+	mutex_init(&info->lock);
+	mutex_lock(&info->lock);
+
+	info->lower_paths = NULL;
+
+	dentry->d_fsdata = info;
+
+	if (!__realloc_dentry_private_data(dentry))
+		return 0;
+
+	mutex_unlock(&info->lock);
 	free_dentry_private_data(info);
 	dentry->d_fsdata = NULL;
-	spin_unlock(&dentry->d_lock);
 	return -ENOMEM;
 }
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 28eb622..7e0c318 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -233,6 +233,7 @@ static inline void unionfs_double_lock_dentry(struct dentry *d1,
 	unionfs_lock_dentry(d2);
 }
 
+extern int realloc_dentry_private_data(struct dentry *dentry);
 extern int new_dentry_private_data(struct dentry *dentry);
 extern void free_dentry_private_data(struct unionfs_dentry_info *udi);
 extern void update_bstart(struct dentry *dentry);
-- 
1.5.2.rc1.165.gaf9b

