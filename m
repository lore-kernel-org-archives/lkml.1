Return-Path: <linux-kernel-owner+w=401wt.eu-S1762376AbYFLNo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762376AbYFLNo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762026AbYFLNnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:43:49 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:56324 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761731AbYFLNno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:43:44 -0400
Message-Id: <20080612134203.763166823@kerlabs.com>
References: <20080612133126.335618468@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 15:31:27 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 1/3][BUGFIX] configfs: Introduce configfs_dirent_lock
Content-Disposition: inline; filename=configfs-introduce-configfs_dirent_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces configfs_dirent_lock spinlock to protect configfs_dirent
traversals against linkage mutations (add/del/move). This will allow
configfs_detach_prep() to avoid locking i_mutexes. 

Locking rules for configfs_dirent linkage mutations are the same plus the
requirement of taking configfs_dirent_lock. For configfs_dirent walking, one can
either take appropriate i_mutex as before, or take configfs_dirent_lock.

The spinlock could actually be a mutex, but the critical sections are either
O(1) or should not be too long (default groups walking in last patch).

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    3 +++
 fs/configfs/dir.c               |   25 +++++++++++++++++++++++++
 fs/configfs/inode.c             |    2 ++
 fs/configfs/symlink.c           |    2 ++
 4 files changed, 32 insertions(+)

Index: b/fs/configfs/configfs_internal.h
===================================================================
--- a/fs/configfs/configfs_internal.h	2008-06-12 13:44:27.000000000 +0200
+++ b/fs/configfs/configfs_internal.h	2008-06-12 13:44:34.000000000 +0200
@@ -26,6 +26,7 @@
 
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/spinlock.h>
 
 struct configfs_dirent {
 	atomic_t		s_count;
@@ -49,6 +50,8 @@ struct configfs_dirent {
 #define CONFIGFS_USET_DROPPING	0x0100
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
+extern spinlock_t configfs_dirent_lock;
+
 extern struct vfsmount * configfs_mount;
 extern struct kmem_cache *configfs_dir_cachep;
 
Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-06-12 13:44:27.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-12 15:20:26.000000000 +0200
@@ -35,6 +35,11 @@
 #include "configfs_internal.h"
 
 DECLARE_RWSEM(configfs_rename_sem);
+/*
+ * Protects configfs_dirent traversals against linkage mutations
+ * Can be used as an alternative to taking the concerned i_mutex
+ */
+DEFINE_SPINLOCK(configfs_dirent_lock);
 
 static void configfs_d_iput(struct dentry * dentry,
 			    struct inode * inode)
@@ -79,7 +84,9 @@ static struct configfs_dirent *configfs_
 	atomic_set(&sd->s_count, 1);
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
+	spin_lock(&configfs_dirent_lock);
 	list_add(&sd->s_sibling, &parent_sd->s_children);
+	spin_unlock(&configfs_dirent_lock);
 	sd->s_element = element;
 
 	return sd;
@@ -173,7 +180,9 @@ static int create_dir(struct config_item
 		} else {
 			struct configfs_dirent *sd = d->d_fsdata;
 			if (sd) {
+				spin_lock(&configfs_dirent_lock);
 				list_del_init(&sd->s_sibling);
+				spin_unlock(&configfs_dirent_lock);
 				configfs_put(sd);
 			}
 		}
@@ -224,7 +233,9 @@ int configfs_create_link(struct configfs
 		else {
 			struct configfs_dirent *sd = dentry->d_fsdata;
 			if (sd) {
+				spin_lock(&configfs_dirent_lock);
 				list_del_init(&sd->s_sibling);
+				spin_unlock(&configfs_dirent_lock);
 				configfs_put(sd);
 			}
 		}
@@ -238,7 +249,9 @@ static void remove_dir(struct dentry * d
 	struct configfs_dirent * sd;
 
 	sd = d->d_fsdata;
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sd->s_sibling);
+	spin_unlock(&configfs_dirent_lock);
 	configfs_put(sd);
 	if (d->d_inode)
 		simple_rmdir(parent->d_inode,d);
@@ -410,7 +423,9 @@ static void detach_attrs(struct config_i
 	list_for_each_entry_safe(sd, tmp, &parent_sd->s_children, s_sibling) {
 		if (!sd->s_element || !(sd->s_type & CONFIGFS_NOT_PINNED))
 			continue;
+		spin_lock(&configfs_dirent_lock);
 		list_del_init(&sd->s_sibling);
+		spin_unlock(&configfs_dirent_lock);
 		configfs_drop_dentry(sd, dentry);
 		configfs_put(sd);
 	}
@@ -1268,7 +1283,9 @@ static int configfs_dir_close(struct ino
 	struct configfs_dirent * cursor = file->private_data;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&cursor->s_sibling);
+	spin_unlock(&configfs_dirent_lock);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
 	release_configfs_dirent(cursor);
@@ -1308,7 +1325,9 @@ static int configfs_readdir(struct file 
 			/* fallthrough */
 		default:
 			if (filp->f_pos == 2) {
+				spin_lock(&configfs_dirent_lock);
 				list_move(q, &parent_sd->s_children);
+				spin_unlock(&configfs_dirent_lock);
 			}
 			for (p=q->next; p!= &parent_sd->s_children; p=p->next) {
 				struct configfs_dirent *next;
@@ -1331,7 +1350,9 @@ static int configfs_readdir(struct file 
 						 dt_type(next)) < 0)
 					return 0;
 
+				spin_lock(&configfs_dirent_lock);
 				list_move(q, p);
+				spin_unlock(&configfs_dirent_lock);
 				p = q;
 				filp->f_pos++;
 			}
@@ -1362,7 +1383,9 @@ static loff_t configfs_dir_lseek(struct 
 			struct list_head *p;
 			loff_t n = file->f_pos - 2;
 
+			spin_lock(&configfs_dirent_lock);
 			list_del(&cursor->s_sibling);
+			spin_unlock(&configfs_dirent_lock);
 			p = sd->s_children.next;
 			while (n && p != &sd->s_children) {
 				struct configfs_dirent *next;
@@ -1372,7 +1395,9 @@ static loff_t configfs_dir_lseek(struct 
 					n--;
 				p = p->next;
 			}
+			spin_lock(&configfs_dirent_lock);
 			list_add_tail(&cursor->s_sibling, p);
+			spin_unlock(&configfs_dirent_lock);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
Index: b/fs/configfs/inode.c
===================================================================
--- a/fs/configfs/inode.c	2008-06-12 13:44:27.000000000 +0200
+++ b/fs/configfs/inode.c	2008-06-12 13:44:34.000000000 +0200
@@ -247,7 +247,9 @@ void configfs_hash_and_remove(struct den
 		if (!sd->s_element)
 			continue;
 		if (!strcmp(configfs_get_name(sd), name)) {
+			spin_lock(&configfs_dirent_lock);
 			list_del_init(&sd->s_sibling);
+			spin_unlock(&configfs_dirent_lock);
 			configfs_drop_dentry(sd, dir);
 			configfs_put(sd);
 			break;
Index: b/fs/configfs/symlink.c
===================================================================
--- a/fs/configfs/symlink.c	2008-06-12 13:44:27.000000000 +0200
+++ b/fs/configfs/symlink.c	2008-06-12 13:44:34.000000000 +0200
@@ -169,7 +169,9 @@ int configfs_unlink(struct inode *dir, s
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	type = parent_item->ci_type;
 
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sd->s_sibling);
+	spin_unlock(&configfs_dirent_lock);
 	configfs_drop_dentry(sd, dentry->d_parent);
 	dput(dentry);
 	configfs_put(sd);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

