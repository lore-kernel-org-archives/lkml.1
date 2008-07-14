Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYGNWGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYGNWGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbYGNWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:18 -0400
Received: from mail.suse.de ([195.135.220.2]:49955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbYGNWCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:15 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: [PATCH 11/17] configfs: Protect configfs_dirent s_links list mutations
Date: Mon, 14 Jul 2008 15:01:44 -0700
Message-Id: <1216072910-27226-12-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Louis Rilling <Louis.Rilling@kerlabs.com>

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
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/dir.c     |    5 +++--
 fs/configfs/symlink.c |    8 ++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 2619f48..a08e5c2 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
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
 
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 676c84c..faeb441 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -77,12 +77,15 @@ static int create_link(struct config_item *parent_item,
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
@@ -186,8 +189,9 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 		type->ct_item_ops->drop_link(parent_item,
 					       sl->sl_target);
 
-	/* FIXME: Needs lock */
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sl->sl_list);
+	spin_unlock(&configfs_dirent_lock);
 
 	/* Put reference from create_link() */
 	config_item_put(sl->sl_target);
-- 
1.5.4.1

