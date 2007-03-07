Return-Path: <linux-kernel-owner+w=401wt.eu-S1161038AbXCGAen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161038AbXCGAen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161034AbXCGAen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:34:43 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42286 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161033AbXCGAej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:34:39 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 16:34:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 3/3] epoll optimizations and cleanups  ...
Message-ID: <Pine.LNX.4.64.0703061628470.3661@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch cuts out lots of code from epoll, by reusing the anonymous 
inode source of patch 2/3.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



eventpoll.c |  174 +-----------------------------------------------------------
1 file changed, 3 insertions(+), 171 deletions(-)



Index: linux-2.6.20.ep2/fs/eventpoll.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/eventpoll.c	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/fs/eventpoll.c	2007-03-06 11:12:43.000000000 -0800
@@ -35,6 +35,7 @@
 #include <linux/mount.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <linux/anon_inodes.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/io.h>
@@ -76,8 +77,6 @@
  */
 
 
-#define EVENTPOLLFS_MAGIC 0x03111965 /* My birthday should work for this :) */
-
 #define DEBUG_EPOLL 0
 
 #if DEBUG_EPOLL > 0
@@ -229,8 +228,6 @@
 
 static void ep_poll_safewake_init(struct poll_safewake *psw);
 static void ep_poll_safewake(struct poll_safewake *psw, wait_queue_head_t *wq);
-static int ep_getfd(int *efd, struct inode **einode, struct file **efile,
-		    struct eventpoll *ep);
 static int ep_alloc(struct eventpoll **pep);
 static void ep_free(struct eventpoll *ep);
 static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd);
@@ -256,11 +253,6 @@
 			      int maxevents);
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout);
-static int eventpollfs_delete_dentry(struct dentry *dentry);
-static struct inode *ep_eventpoll_inode(void);
-static int eventpollfs_get_sb(struct file_system_type *fs_type,
-			      int flags, const char *dev_name,
-			      void *data, struct vfsmount *mnt);
 
 /*
  * This semaphore is used to serialize ep_free() and eventpoll_release_file().
@@ -276,30 +268,12 @@
 /* Slab cache used to allocate "struct eppoll_entry" */
 static struct kmem_cache *pwq_cache __read_mostly;
 
-/* Virtual fs used to allocate inodes for eventpoll files */
-static struct vfsmount *eventpoll_mnt __read_mostly;
-
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
 	.release	= ep_eventpoll_close,
 	.poll		= ep_eventpoll_poll
 };
 
-/*
- * This is used to register the virtual file system from where
- * eventpoll inodes are allocated.
- */
-static struct file_system_type eventpoll_fs_type = {
-	.name		= "eventpollfs",
-	.get_sb		= eventpollfs_get_sb,
-	.kill_sb	= kill_anon_super,
-};
-
-/* Very basic directory entry operations for the eventpoll virtual file system */
-static struct dentry_operations eventpollfs_dentry_operations = {
-	.d_delete	= eventpollfs_delete_dentry,
-};
-
 
 
 /* Fast test to see if the file is an evenpoll file */
@@ -496,7 +470,8 @@
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure, and inode and a free file descriptor.
 	 */
-	error = ep_getfd(&fd, &inode, &file, ep);
+	error = aino_getfd(&fd, &inode, &file, "[eventpoll]",
+			   &eventpoll_fops, ep);
 	if (error)
 		goto eexit_2;
 
@@ -726,82 +701,6 @@
 #endif /* #ifdef TIF_RESTORE_SIGMASK */
 
 
-/*
- * Creates the file descriptor to be used by the epoll interface.
- */
-static int ep_getfd(int *efd, struct inode **einode, struct file **efile,
-		    struct eventpoll *ep)
-{
-	struct qstr this;
-	char name[32];
-	struct dentry *dentry;
-	struct inode *inode;
-	struct file *file;
-	int error, fd;
-
-	/* Get an ready to use file */
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto eexit_1;
-
-	/* Allocates an inode from the eventpoll file system */
-	inode = ep_eventpoll_inode();
-	if (IS_ERR(inode)) {
-		error = PTR_ERR(inode);
-		goto eexit_2;
-	}
-
-	/* Allocates a free descriptor to plug the file onto */
-	error = get_unused_fd();
-	if (error < 0)
-		goto eexit_3;
-	fd = error;
-
-	/*
-	 * Link the inode to a directory entry by creating a unique name
-	 * using the inode number.
-	 */
-	error = -ENOMEM;
-	sprintf(name, "[%lu]", inode->i_ino);
-	this.name = name;
-	this.len = strlen(name);
-	this.hash = inode->i_ino;
-	dentry = d_alloc(eventpoll_mnt->mnt_sb->s_root, &this);
-	if (!dentry)
-		goto eexit_4;
-	dentry->d_op = &eventpollfs_dentry_operations;
-	d_add(dentry, inode);
-	file->f_path.mnt = mntget(eventpoll_mnt);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-
-	file->f_pos = 0;
-	file->f_flags = O_RDONLY;
-	file->f_op = &eventpoll_fops;
-	file->f_mode = FMODE_READ;
-	file->f_version = 0;
-	file->private_data = ep;
-
-	/* Install the new setup file into the allocated fd. */
-	fd_install(fd, file);
-
-	*efd = fd;
-	*einode = inode;
-	*efile = file;
-	return 0;
-
-eexit_4:
-	put_unused_fd(fd);
-eexit_3:
-	iput(inode);
-eexit_2:
-	put_filp(file);
-eexit_1:
-	return error;
-}
-
-
 static int ep_alloc(struct eventpoll **pep)
 {
 	struct eventpoll *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
@@ -1553,54 +1452,8 @@
 }
 
 
-static int eventpollfs_delete_dentry(struct dentry *dentry)
-{
-
-	return 1;
-}
-
-
-static struct inode *ep_eventpoll_inode(void)
-{
-	int error = -ENOMEM;
-	struct inode *inode = new_inode(eventpoll_mnt->mnt_sb);
-
-	if (!inode)
-		goto eexit_1;
-
-	inode->i_fop = &eventpoll_fops;
-
-	/*
-	 * Mark the inode dirty from the very beginning,
-	 * that way it will never be moved to the dirty
-	 * list because mark_inode_dirty() will think
-	 * that it already _is_ on the dirty list.
-	 */
-	inode->i_state = I_DIRTY;
-	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	return inode;
-
-eexit_1:
-	return ERR_PTR(error);
-}
-
-
-static int
-eventpollfs_get_sb(struct file_system_type *fs_type, int flags,
-		   const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	return get_sb_pseudo(fs_type, "eventpoll:", NULL, EVENTPOLLFS_MAGIC,
-			     mnt);
-}
-
-
 static int __init eventpoll_init(void)
 {
-	int error;
-
 	mutex_init(&epmutex);
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
@@ -1616,34 +1469,13 @@
 			sizeof(struct eppoll_entry), 0,
 			EPI_SLAB_DEBUG|SLAB_PANIC, NULL, NULL);
 
-	/*
-	 * Register the virtual file system that will be the source of inodes
-	 * for the eventpoll files
-	 */
-	error = register_filesystem(&eventpoll_fs_type);
-	if (error)
-		goto epanic;
-
-	/* Mount the above commented virtual file system */
-	eventpoll_mnt = kern_mount(&eventpoll_fs_type);
-	error = PTR_ERR(eventpoll_mnt);
-	if (IS_ERR(eventpoll_mnt))
-		goto epanic;
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: successfully initialized.\n",
-			current));
 	return 0;
-
-epanic:
-	panic("eventpoll_init() failed\n");
 }
 
 
 static void __exit eventpoll_exit(void)
 {
 	/* Undo all operations done inside eventpoll_init() */
-	unregister_filesystem(&eventpoll_fs_type);
-	mntput(eventpoll_mnt);
 	kmem_cache_destroy(pwq_cache);
 	kmem_cache_destroy(epi_cache);
 }
