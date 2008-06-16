Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYFPRXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYFPRXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbYFPRVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:21:38 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:50842 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbYFPRVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:21:37 -0400
Message-Id: <20080616171059.165015234@kerlabs.com>
References: <20080616170057.399713501@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 19:01:02 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 5/5][BUGFIX] configfs: Fix failing mkdir() making racing rmdir() fail
Content-Disposition: inline; filename=configfs-fix-failing-mkdir-making-rmdir-fail.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When fixing the rename() vs rmdir() deadlock, we stopped locking default groups'
inodes in configfs_detach_prep(), letting racing mkdir() in default groups
proceed concurrently. This enables races like below happen, which leads to a
failing mkdir() making rmdir() fail, despite the group to remove having no
user-created directory under it in the end.

	process A: 			process B:
	/* PWD=A/B */
	mkdir("C")
	  make_item("C")
	  attach_group("C")
					rmdir("A")
					  detach_prep("A")
					    detach_prep("B")
					      error because of "C"
					  return -ENOTEMPTY
	    attach_group("C/D")
	      error (eg -ENOMEM)
	  return -ENOMEM

This patch prevents such scenarii by making rmdir() wait as long as
detach_prep() fails because a racing mkdir() is in the middle of attach_group().
To achieve this, mkdir() sets a flag CONFIGFS_USET_IN_MKDIR in parent's
configfs_dirent before calling attach_group(), and clears the flag once
attach_group() is done. detach_prep() fails with -EAGAIN whenever the flag is
hit and returns the guilty inode's mutex so that rmdir() can wait on it.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    1 
 fs/configfs/dir.c               |   53 ++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 10 deletions(-)

Index: b/fs/configfs/configfs_internal.h
===================================================================
--- a/fs/configfs/configfs_internal.h	2008-06-16 18:06:27.000000000 +0200
+++ b/fs/configfs/configfs_internal.h	2008-06-16 18:06:54.000000000 +0200
@@ -48,6 +48,7 @@ struct configfs_dirent {
 #define CONFIGFS_USET_DIR	0x0040
 #define CONFIGFS_USET_DEFAULT	0x0080
 #define CONFIGFS_USET_DROPPING	0x0100
+#define CONFIGFS_USET_IN_MKDIR	0x0200
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
 extern spinlock_t configfs_dirent_lock;
Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-06-16 18:06:50.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-16 18:52:50.000000000 +0200
@@ -364,7 +364,7 @@ static struct dentry * configfs_lookup(s
  * If there is an error, the caller will reset the flags via
  * configfs_detach_rollback().
  */
-static int configfs_detach_prep(struct dentry *dentry)
+static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex)
 {
 	struct configfs_dirent *parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *sd;
@@ -379,6 +379,12 @@ static int configfs_detach_prep(struct d
 		if (sd->s_type & CONFIGFS_NOT_PINNED)
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
+			/* Abort if racing with mkdir() */
+			if (sd->s_type & CONFIGFS_USET_IN_MKDIR) {
+				if (wait_mutex)
+					*wait_mutex = &sd->s_dentry->d_inode->i_mutex;
+				return -EAGAIN;
+			}
 			/* Mark that we're trying to drop the group */
 			sd->s_type |= CONFIGFS_USET_DROPPING;
 
@@ -386,7 +392,7 @@ static int configfs_detach_prep(struct d
 			 * Yup, recursive.  If there's a problem, blame
 			 * deep nesting of default_groups
 			 */
-			ret = configfs_detach_prep(sd->s_dentry);
+			ret = configfs_detach_prep(sd->s_dentry, wait_mutex);
 			if (!ret)
 				continue;
 		} else
@@ -1113,11 +1119,26 @@ static int configfs_mkdir(struct inode *
 	 */
 	module_got = 1;
 
+	/*
+	 * Make racing rmdir() fail if it did not tag parent with
+	 * CONFIGFS_USET_DROPPING
+	 * Note: if CONFIGFS_USET_DROPPING is already set, attach_group() will
+	 * fail and let rmdir() terminate correctly
+	 */
+	spin_lock(&configfs_dirent_lock);
+	/* This will make configfs_detach_prep() fail */
+	sd->s_type |= CONFIGFS_USET_IN_MKDIR;
+	spin_unlock(&configfs_dirent_lock);
+
 	if (group)
 		ret = configfs_attach_group(parent_item, item, dentry);
 	else
 		ret = configfs_attach_item(parent_item, item, dentry);
 
+	spin_lock(&configfs_dirent_lock);
+	sd->s_type &= ~CONFIGFS_USET_IN_MKDIR;
+	spin_unlock(&configfs_dirent_lock);
+
 out_unlink:
 	if (ret) {
 		/* Tear down everything we built up */
@@ -1182,13 +1203,25 @@ static int configfs_rmdir(struct inode *
 	}
 
 	spin_lock(&configfs_dirent_lock);
-	ret = configfs_detach_prep(dentry);
-	if (ret) {
-		configfs_detach_rollback(dentry);
-		spin_unlock(&configfs_dirent_lock);
-		config_item_put(parent_item);
-		return ret;
-	}
+	do {
+		struct mutex *wait_mutex;
+
+		ret = configfs_detach_prep(dentry, &wait_mutex);
+		if (ret) {
+			configfs_detach_rollback(dentry);
+			spin_unlock(&configfs_dirent_lock);
+			if (ret != -EAGAIN) {
+				config_item_put(parent_item);
+				return ret;
+			}
+
+			/* Wait until the racing operation terminates */
+			mutex_lock(wait_mutex);
+			mutex_unlock(wait_mutex);
+
+			spin_lock(&configfs_dirent_lock);
+		}
+	} while (ret == -EAGAIN);
 	spin_unlock(&configfs_dirent_lock);
 
 	/* Get a working ref for the duration of this function */
@@ -1480,7 +1513,7 @@ void configfs_unregister_subsystem(struc
 			  I_MUTEX_PARENT);
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 	spin_lock(&configfs_dirent_lock);
-	if (configfs_detach_prep(dentry)) {
+	if (configfs_detach_prep(dentry, NULL)) {
 		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
 	}
 	spin_unlock(&configfs_dirent_lock);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

