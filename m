Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYFQRiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYFQRiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYFQRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:37:29 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:60135 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbYFQRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:37:28 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [BUGFIX][PATCH 3/3] configfs: Fix failing symlink() making rmdir() fail
Date: Tue, 17 Jun 2008 19:37:23 +0200
Message-Id: <1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a similar pattern as mkdir() vs rmdir(), a failing symlink() may make rmdir()
fail for the symlink's parent and the symlink's target as well.

failing symlink() making target's rmdir() fail:

	process 1:				process 2:
	symlink("A/S" -> "B")
	  allow_link()
	  create_link()
	    attach to "B" links list
						rmdir("B")
						  detach_prep("B")
						    error because of new link
	    configfs_create_link("A", "S")
	      error (eg -ENOMEM)

failing symlink() making parent's rmdir() fail:

	process 1:				process 2:
	symlink("A/D/S" -> "B")
	  allow_link()
	  create_link()
	    attach to "B" links list
	    configfs_create_link("A/D", "S")
	      make_dirent("A/D", "S")
						rmdir("A")
						  detach_prep("A")
						    detach_prep("A/D")
						      error because of "S"
	      create("S")
	        error (eg -ENOMEM)

For the parent's rmdir() case, we can use the same solution as with mkdir() vs
rmdir(). For the target's rmdir() case, we cannot, since we do not and cannot
lock the target's inode while in symlink(). Fortunately, once create_link()
terminates, no further operation can fail in symlink(). So we first reorder the
operations in create_link() to attach the new symlink to its target in last
place, and second handle symlink creation failure the same way as a new item
creation failure.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/symlink.c |   39 +++++++++++++++++++++++++++++----------
 1 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 58722a9..0c5e650 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -69,6 +69,7 @@ static int create_link(struct config_item *parent_item,
 		       struct config_item *item,
 		       struct dentry *dentry)
 {
+	struct configfs_dirent *parent_sd = parent_item->ci_dentry->d_fsdata;
 	struct configfs_dirent *target_sd = item->ci_dentry->d_fsdata;
 	struct configfs_symlink *sl;
 	int ret;
@@ -77,24 +78,42 @@ static int create_link(struct config_item *parent_item,
 	sl = kmalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
 	if (sl) {
 		sl->sl_target = config_item_get(item);
+
 		spin_lock(&configfs_dirent_lock);
-		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
-			spin_unlock(&configfs_dirent_lock);
-			config_item_put(item);
-			kfree(sl);
-			return -EPERM;
-		}
-		list_add(&sl->sl_list, &target_sd->s_links);
+		/*
+		 * Force rmdir() of parent_item to wait until we know if we
+		 * succeed.
+		 */
+		parent_sd->s_type |= CONFIGFS_USET_ATTACHING;
 		spin_unlock(&configfs_dirent_lock);
+
 		ret = configfs_create_link(sl, parent_item->ci_dentry,
 					   dentry);
-		if (ret) {
-			spin_lock(&configfs_dirent_lock);
-			list_del_init(&sl->sl_list);
+
+		spin_lock(&configfs_dirent_lock);
+		parent_sd->s_type &= ~CONFIGFS_USET_ATTACHING;
+
+		if (ret || target_sd->s_type & CONFIGFS_USET_DROPPING) {
+			struct configfs_dirent *sd = NULL;
+
+			if (!ret) {
+				sd = dentry->d_fsdata;
+				list_del_init(&sd->s_sibling);
+			}
 			spin_unlock(&configfs_dirent_lock);
+
+			if (!ret) {
+				configfs_drop_dentry(sd, dentry->d_parent);
+				d_delete(dentry);
+				configfs_put(sd);
+			}
 			config_item_put(item);
 			kfree(sl);
+			return ret ? ret : -EPERM;
 		}
+
+		list_add(&sl->sl_list, &target_sd->s_links);
+		spin_unlock(&configfs_dirent_lock);
 	}
 
 	return ret;
-- 
1.5.5.3

