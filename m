Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbXFQTJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbXFQTJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbXFQTJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:09:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36819 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbXFQTJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:09:36 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 13/16] Unionfs: Change free_dentry_private_info to take a struct dentry
Date: Sun, 17 Jun 2007 15:09:20 -0400
Message-Id: <11821073642904-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it more symmetric with new_dentry_private_info.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    3 +--
 fs/unionfs/lookup.c |   13 ++++++-------
 fs/unionfs/main.c   |    2 +-
 fs/unionfs/union.h  |    2 +-
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index db0ef43..9bd521b 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -334,8 +334,7 @@ static void unionfs_d_release(struct dentry *dentry)
 
 out_free:
 	/* No need to unlock it, because it is disappeared. */
-	free_dentry_private_data(UNIONFS_D(dentry));
-	dentry->d_fsdata = NULL;	/* just to be safe */
+	free_dentry_private_data(dentry);
 
 out:
 	return;
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 246a67a..8a09540 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -452,11 +452,12 @@ void unionfs_destroy_dentry_cache(void)
 		kmem_cache_destroy(unionfs_dentry_cachep);
 }
 
-void free_dentry_private_data(struct unionfs_dentry_info *udi)
+void free_dentry_private_data(struct dentry *dentry)
 {
-	if (!udi)
+	if (!dentry || !dentry->d_fsdata)
 		return;
-	kmem_cache_free(unionfs_dentry_cachep, udi);
+	kmem_cache_free(unionfs_dentry_cachep, dentry->d_fsdata);
+	dentry->d_fsdata = NULL;
 }
 
 static inline int __realloc_dentry_private_data(struct dentry *dentry)
@@ -493,8 +494,7 @@ int realloc_dentry_private_data(struct dentry *dentry)
 		return 0;
 
 	kfree(UNIONFS_D(dentry)->lower_paths);
-	free_dentry_private_data(UNIONFS_D(dentry));
-	dentry->d_fsdata = NULL;
+	free_dentry_private_data(dentry);
 	return -ENOMEM;
 }
 
@@ -520,8 +520,7 @@ int new_dentry_private_data(struct dentry *dentry)
 		return 0;
 
 	mutex_unlock(&info->lock);
-	free_dentry_private_data(info);
-	dentry->d_fsdata = NULL;
+	free_dentry_private_data(dentry);
 	return -ENOMEM;
 }
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 2bcc84c..b9fe431 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -632,7 +632,7 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 out_freedpd:
 	if (UNIONFS_D(sb->s_root)) {
 		kfree(UNIONFS_D(sb->s_root)->lower_paths);
-		free_dentry_private_data(UNIONFS_D(sb->s_root));
+		free_dentry_private_data(sb->s_root);
 	}
 	dput(sb->s_root);
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 7e0c318..6eb151e 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -235,7 +235,7 @@ static inline void unionfs_double_lock_dentry(struct dentry *d1,
 
 extern int realloc_dentry_private_data(struct dentry *dentry);
 extern int new_dentry_private_data(struct dentry *dentry);
-extern void free_dentry_private_data(struct unionfs_dentry_info *udi);
+extern void free_dentry_private_data(struct dentry *dentry);
 extern void update_bstart(struct dentry *dentry);
 
 /*
-- 
1.5.2.rc1.165.gaf9b

