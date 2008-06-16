Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbYFPRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbYFPRWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYFPRVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:21:33 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:50842 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbYFPRVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:21:32 -0400
Message-Id: <20080616171058.722251454@kerlabs.com>
References: <20080616170057.399713501@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 19:00:59 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 2/5][BUGFIX] configfs: Protect configfs_dirent s_links list mutations
Content-Disposition: inline; filename=configfs-fix-symlink-dirent-linkage-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symlinks to a config_item are listed under its configfs_dirent s_links, but the
list mutations are not protected by any common lock.

This patch uses the configfs_dirent_lock spinlock to add the necessary
protection.

Note: we should also protect the list_empty() test in configfs_detach_prep() but
1/ the lock should not be released immediately because nothing would prevent the
list from being filled after a successful list_empty() test, making the problem
tricky,
2/ this will be solved by the rmdir() vs rename() deadlock bugfix.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c     |    5 +++--
 fs/configfs/symlink.c |    8 ++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

Index: b/fs/configfs/symlink.c
===================================================================
--- a/fs/configfs/symlink.c	2008-06-16 17:42:31.000000000 +0200
+++ b/fs/configfs/symlink.c	2008-06-16 17:42:43.000000000 +0200
@@ -77,12 +77,15 @@ static int create_link(struct config_ite
 	sl = kmalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
 	if (sl) {
 		sl->sl_target = config_item_get(item);
-		/* FIXME: needs a lock, I'd bet */
+		spin_lock(&configfs_dirent_lock);
 		list_add(&sl->sl_list, &target_sd->s_links);
+		spin_unlock(&configfs_dirent_lock);
 		ret = configfs_create_link(sl, parent_item->ci_dentry,
 					   dentry);
 		if (ret) {
+			spin_lock(&configfs_dirent_lock);
 			list_del_init(&sl->sl_list);
+			spin_unlock(&configfs_dirent_lock);
 			config_item_put(item);
 			kfree(sl);
 		}
@@ -186,8 +189,9 @@ int configfs_unlink(struct inode *dir, s
 		type->ct_item_ops->drop_link(parent_item,
 					       sl->sl_target);
 
-	/* FIXME: Needs lock */
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sl->sl_list);
+	spin_unlock(&configfs_dirent_lock);
 
 	/* Put reference from create_link() */
 	config_item_put(sl->sl_target);
Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-06-16 17:42:31.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-16 18:54:20.000000000 +0200
@@ -37,10 +37,11 @@
 DECLARE_RWSEM(configfs_rename_sem);
 /*
  * Protects mutations of configfs_dirent linkage together with proper i_mutex
+ * Also protects mutations of symlinks linkage to target configfs_dirent
  * Mutators of configfs_dirent linkage must *both* have the proper inode locked
  * and configfs_dirent_lock locked, in that order.
- * This allows one to safely traverse configfs_dirent trees without having to
- * lock inodes.
+ * This allows one to safely traverse configfs_dirent trees and symlinks without
+ * having to lock inodes.
  */
 DEFINE_SPINLOCK(configfs_dirent_lock);
 

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

