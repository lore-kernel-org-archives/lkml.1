Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYF1QJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYF1QJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYF1QI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:08:56 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:50281 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYF1QIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:08:54 -0400
Date: Sat, 28 Jun 2008 18:08:58 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Greg KH <greg@kroah.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628180858.4bb1cd5b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628153309.GC11018@kroah.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153403.0870e96c@mjolnir.drzeus.cx>
	<20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com>
	<20080628155913.2bba34a9@mjolnir.drzeus.cx>
	<20080628160752.0fe19753@hskinnemo-gx745.norway.atmel.com>
	<20080628153309.GC11018@kroah.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Jun 2008 16:08:46.0634 (UTC) FILETIME=[3E9478A0:01C8D939]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote:
> Someone can add a "debugfs_rm_dentry_and_children" function if they so
> desire to handle this kind of thing if they want to :)

Ok, I'll try. I'm not an FS developer, so I'm sure the below patch is
horribly broken in some subtle way, but it does appear to work at least
the few times I tried it...

Lockdep indeed confirms that something is broken:

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc8 #34
---------------------------------------------
rmmod/396 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#2){--..}, at: [<900a4ab6>] debugfs_remove_recursive+0x2e/0xc0

but task is already holding lock:
 (&sb->s_type->i_mutex_key#2){--..}, at: [<900a4aa8>] debugfs_remove_recursive+0x20/0xc0

other info that might help us debug this:
1 lock held by rmmod/396:
 #0:  (&sb->s_type->i_mutex_key#2){--..}, at: [<900a4aa8>] debugfs_remove_recursive+0x20/0xc0

stack backtrace:
Call trace:
 [<90017018>] dump_stack+0x18/0x20
 [<900327ac>] __lock_acquire+0x6a0/0x964
 [<9003306c>] lock_acquire+0x38/0x4c
 [<90170130>] mutex_lock_nested+0x7c/0x18c
 [<900a4ab6>] debugfs_remove_recursive+0x2e/0xc0
 [<c0861c26>] mmc_remove_host+0x12/0x34 [mmc_core]
 [<c0857222>] atmci_remove+0x4a/0xd4 [atmel_mci]
 [<900d478a>] platform_drv_remove+0x10/0x12
 [<900d3cfc>] __device_release_driver+0x48/0x64
 [<900d3d74>] driver_detach+0x5c/0x7c
 [<900d34be>] bus_remove_driver+0x5a/0x70
 [<900d4054>] driver_unregister+0x24/0x28
 [<900d488e>] platform_driver_unregister+0xa/0xc
 [<c08571ce>] atmci_exit+0xa/0x14 [atmel_mci]
 [<90038086>] sys_delete_module+0x116/0x15c
 [<90013132>] syscall_return+0x0/0x12

But I don't know exactly what. Isn't it ok to take the inode lock in
parent -> child order?

Haavard

>From 5b8c84b71456de1cfc37910c40c974e3459f39cf Mon Sep 17 00:00:00 2001
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Date: Sat, 28 Jun 2008 17:54:15 +0200
Subject: [PATCH] debugfs: Implement debugfs_remove_recursive()

debugfs_remove_recursive() will remove a dentry and all its children.
Drivers can use this to zap their whole debugfs tree so that they don't
need to keep track of every single debugfs dentry they created.

It may fail to remove the whole tree in certain cases:

sh-3.2# rmmod atmel-mci < /sys/kernel/debug/mmc0/ios/clock
mmc0: card b368 removed
atmel_mci atmel_mci.0: Lost dma0chan1, falling back to PIO
sh-3.2# ls /sys/kernel/debug/mmc0/
ios

But I'm not sure if that case can be handled in any sane manner.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 fs/debugfs/inode.c      |  114 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/debugfs.h |    4 ++
 2 files changed, 101 insertions(+), 17 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index e9602d8..6234322 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -309,6 +309,31 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
+static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
+{
+	int ret = 0;
+
+	if (debugfs_positive(dentry)) {
+		if (dentry->d_inode) {
+			dget(dentry);
+			switch (dentry->d_inode->i_mode & S_IFMT) {
+			case S_IFDIR:
+				ret = simple_rmdir(parent->d_inode, dentry);
+				break;
+			case S_IFLNK:
+				kfree(dentry->d_inode->i_private);
+				/* fall through */
+			default:
+				simple_unlink(parent->d_inode, dentry);
+				break;
+			}
+			if (!ret)
+				d_delete(dentry);
+			dput(dentry);
+		}
+	}
+}
+
 /**
  * debugfs_remove - removes a file or directory from the debugfs filesystem
  * @dentry: a pointer to a the dentry of the file or directory to be
@@ -325,7 +350,6 @@ EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 void debugfs_remove(struct dentry *dentry)
 {
 	struct dentry *parent;
-	int ret = 0;
 	
 	if (!dentry)
 		return;
@@ -335,29 +359,85 @@ void debugfs_remove(struct dentry *dentry)
 		return;
 
 	mutex_lock(&parent->d_inode->i_mutex);
-	if (debugfs_positive(dentry)) {
-		if (dentry->d_inode) {
-			dget(dentry);
-			switch (dentry->d_inode->i_mode & S_IFMT) {
-			case S_IFDIR:
-				ret = simple_rmdir(parent->d_inode, dentry);
-				break;
-			case S_IFLNK:
-				kfree(dentry->d_inode->i_private);
-				/* fall through */
-			default:
-				simple_unlink(parent->d_inode, dentry);
+	__debugfs_remove(dentry, parent);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+}
+EXPORT_SYMBOL_GPL(debugfs_remove);
+
+/**
+ * debugfs_remove_recursive - recursively removes a directory
+ * @dentry: a pointer to a the dentry of the directory to be removed.
+ *
+ * This function recursively removes a directory tree in debugfs that
+ * was previously created with a call to another debugfs function
+ * (like debugfs_create_file() or variants thereof.)
+ *
+ * This function is required to be called in order for the file to be
+ * removed, no automatic cleanup of files will happen when a module is
+ * removed, you are responsible here.
+ */
+void debugfs_remove_recursive(struct dentry *dentry)
+{
+	struct dentry *child;
+	struct dentry *parent;
+
+	if (!dentry)
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	mutex_lock(&dentry->d_inode->i_mutex);
+	parent = dentry;
+
+	while (1) {
+		/*
+		 * When all dentries under "parent" has been removed,
+		 * walk up the tree until we reach our starting point.
+		 */
+		if (list_empty(&parent->d_subdirs)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			if (parent == dentry)
 				break;
+			parent = parent->d_parent;
+		}
+		child = list_entry(parent->d_subdirs.next, struct dentry,
+				d_u.d_child);
+
+		/*
+		 * If "child" isn't empty, walk down the tree and
+		 * remove all its descendants first.
+		 */
+		if (!list_empty(&child->d_subdirs)) {
+			parent = child;
+			mutex_lock(&parent->d_inode->i_mutex);
+			continue;
+		}
+		__debugfs_remove(child, parent);
+		if (parent->d_subdirs.next == &child->d_u.d_child) {
+			/*
+			 * Avoid infinite loop if we fail to remove
+			 * one dentry.
+			 */
+			while (parent != dentry) {
+				mutex_unlock(&parent->d_inode->i_mutex);
+				parent = parent->d_parent;
 			}
-			if (!ret)
-				d_delete(dentry);
-			dput(dentry);
+			mutex_unlock(&parent->d_inode->i_mutex);
+			break;
 		}
+		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	}
+
+	parent = dentry->d_parent;
+	__debugfs_remove(dentry, parent);
 	mutex_unlock(&parent->d_inode->i_mutex);
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 }
-EXPORT_SYMBOL_GPL(debugfs_remove);
+EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 
 /**
  * debugfs_rename - rename a file/directory in the debugfs filesystem
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 7266124..b67b375 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -42,6 +42,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *dest);
 
 void debugfs_remove(struct dentry *dentry);
+void debugfs_remove_recursive(struct dentry *dentry);
 
 struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, const char *new_name);
@@ -99,6 +100,9 @@ static inline struct dentry *debugfs_create_symlink(const char *name,
 static inline void debugfs_remove(struct dentry *dentry)
 { }
 
+static inline void debugfs_remove_recursive(struct dentry *dentry)
+{ }
+
 static inline struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, char *new_name)
 {
-- 
1.5.5.4

