Return-Path: <linux-kernel-owner+w=401wt.eu-S934928AbYEVLy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928AbYEVLy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764471AbYEVLw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:52:59 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:49744 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760163AbYEVLwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:52:30 -0400
Message-Id: <20080522114947.927196541@kerlabs.com>
References: <20080522114048.265996107@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 13:40:52 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: [RFC][PATCH 4/4] configfs: Make multiple default_group destructions lockdep friendly
Content-Disposition: inline; filename=configfs-make-default-group-destruction-lockdep-friendly-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When destroying a config_group having multiple (nested or not) default groups,
lockdep raises a warning because multiple locks of class I_MUTEX_NORMAL are
taken in configfs_detach_prep().

This patch makes such default group destructions lockdep-friendly by increasing
the i_mutex sub-class from I_MUTEX_CHILD + 1 onwards for each default group
locked under a being-destroyed config_group.

With this patch and lockdep compiled-in, the number of default groups (whatever
their depth in the tree) under a user-created config_group (resp. registered
subsystem) is limited to MAX_LOCKDEP_SUBCLASSES - I_MUTEX_CHILD - 1 == 3. This
limit is removed when not compiling lockdep.

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc3 #5
---------------------------------------------
rmdir/1499 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89

but task is already holding lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296513>] vfs_rmdir+0x49/0xac

other info that might help us debug this:
2 locks held by rmdir/1499:
 #0:  (&sb->s_type->i_mutex_key#3/1){--..}, at: [<ffffffff80298138>] do_rmdir+0x82/0x108
 #1:  (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296513>] vfs_rmdir+0x49/0xac

stack backtrace:
Pid: 1499, comm: rmdir Not tainted 2.6.26-rc3 #5

Call Trace:
 [<ffffffff8024afe9>] __lock_acquire+0x8d2/0xc78
 [<ffffffff80266399>] filemap_fault+0x1cf/0x332
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff8024b762>] lock_acquire+0x51/0x6c
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff80248331>] debug_mutex_lock_common+0x16/0x23
 [<ffffffff805d6244>] mutex_lock_nested+0xcd/0x23b
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff802d3656>] configfs_rmdir+0xb8/0x1c3
 [<ffffffff80296535>] vfs_rmdir+0x6b/0xac
 [<ffffffff8029816d>] do_rmdir+0xb7/0x108
 [<ffffffff8024a2a2>] trace_hardirqs_on+0xef/0x113
 [<ffffffff805d7364>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b0cb>] system_call_after_swapgs+0x7b/0x80


Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-05-22 12:38:02.000000000 +0200
+++ b/fs/configfs/dir.c	2008-05-22 12:49:08.000000000 +0200
@@ -49,6 +49,12 @@ static inline int set_dirent_lock_level(
 	return -ELOOP;
 }
 
+static inline void copy_dirent_lock_level(struct configfs_dirent *from,
+					  struct configfs_dirent *to)
+{
+	to->s_lock_level = from->s_lock_level;
+}
+
 static inline void reset_dirent_lock_level(struct configfs_dirent *sd)
 {
 	sd->s_lock_level = -1;
@@ -62,6 +68,11 @@ static inline int set_dirent_lock_level(
 	return 0;
 }
 
+static inline void copy_dirent_lock_level(struct configfs_dirent *from,
+					  struct configfs_dirent *to)
+{
+}
+
 static inline void reset_dirent_lock_level(struct configfs_dirent *sd)
 {
 }
@@ -372,6 +383,7 @@ static int configfs_detach_prep(struct d
 {
 	struct configfs_dirent *parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *sd;
+	int lock_level;
 	int ret;
 
 	ret = -EBUSY;
@@ -383,7 +395,15 @@ static int configfs_detach_prep(struct d
 		if (sd->s_type & CONFIGFS_NOT_PINNED)
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
-			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
+			lock_level = set_dirent_lock_level(parent_sd, sd);
+			if (lock_level < 0) {
+				/* Bad bad bad! We cannot remove a directory
+				 * that we let be created! */
+				ret = -ELOOP;
+				break;
+			}
+			mutex_lock_nested(&sd->s_dentry->d_inode->i_mutex,
+					  I_MUTEX_CHILD + lock_level);
 			/* Mark that we've taken i_mutex */
 			sd->s_type |= CONFIGFS_USET_DROPPING;
 
@@ -392,6 +412,10 @@ static int configfs_detach_prep(struct d
 			 * deep nesting of default_groups
 			 */
 			ret = configfs_detach_prep(sd->s_dentry);
+			/* Update parent's lock_level so that remaining
+			 * sibling children keep on globally increasing
+			 * lock_level */
+			copy_dirent_lock_level(sd, parent_sd);
 			if (!ret)
 				continue;
 		} else
@@ -1206,7 +1230,11 @@ static int configfs_rmdir(struct inode *
 		return -EINVAL;
 	}
 
+	/* The inode of the config_item being removed is already locked by
+	 * vfs_rmdir() with subclass I_MUTEX_CHILD. Account for it. */
+	set_dirent_lock_level(parent_item->ci_dentry->d_fsdata, sd);
 	ret = configfs_detach_prep(dentry);
+	reset_dirent_lock_level(sd);
 	if (ret) {
 		configfs_detach_rollback(dentry);
 		config_item_put(parent_item);
@@ -1492,10 +1520,13 @@ void configfs_unregister_subsystem(struc
 
 	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
 			  I_MUTEX_PARENT);
+	/* Sets subsys's configfs_dirent lock_level to 0 */
+	set_dirent_lock_level(configfs_sb->s_root->d_fsdata, dentry->d_fsdata);
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 	if (configfs_detach_prep(dentry)) {
 		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
 	}
+	reset_dirent_lock_level(dentry->d_fsdata);
 	configfs_detach_group(&group->cg_item);
 	dentry->d_inode->i_flags |= S_DEAD;
 	mutex_unlock(&dentry->d_inode->i_mutex);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

