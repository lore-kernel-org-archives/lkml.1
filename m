Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYFLPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYFLPbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYFLPau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:30:50 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54020 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbYFLPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:30:49 -0400
Message-Id: <20080612152953.765122857@kerlabs.com>
References: <20080612152645.445504681@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 17:26:48 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 3/3] configfs: Protect configfs_dirent s_links list mutations
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
 fs/configfs/symlink.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/fs/configfs/symlink.c
===================================================================
--- a/fs/configfs/symlink.c	2008-06-12 16:50:40.000000000 +0200
+++ b/fs/configfs/symlink.c	2008-06-12 16:52:43.000000000 +0200
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
@@ -190,8 +193,9 @@ int configfs_unlink(struct inode *dir, s
 		type->ct_item_ops->drop_link(parent_item,
 					       sl->sl_target);
 
-	/* FIXME: Needs lock */
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sl->sl_list);
+	spin_unlock(&configfs_dirent_lock);
 
 	/* Put reference from create_link() */
 	config_item_put(sl->sl_target);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

