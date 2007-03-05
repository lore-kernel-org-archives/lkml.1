Return-Path: <linux-kernel-owner+w=401wt.eu-S1752236AbXCEXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752236AbXCEXl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXCEXl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:41:56 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37907 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXCEXlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:41:55 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 15:41:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: [patch v2] epoll use a single inode ...
Message-ID: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ChangeLog:

- v2) Properly size the buffer. Avoid extra strlen() (Eric Dumazet)

Epoll does not keep any private data attached to its inode, so there'd be 
no need to allocate one inode per fd. For epoll, the inode is just a 
placeholder for the file operations and could be shared by all instances.
I'd like to use the same optimization even for the upcoming file-based 
objects, so if you see problems let me know.
One that Al was pointing out was that an fstat(2) over an epoll fd would 
show the same st_ino. IMO that should be fine since an fstat(2) over an 
epoll fd is not something you want to do in any case and expecting 
meaningfull results.
This patch also avoids the dentry associated with the file* to be hashed
inside the global dentry hash.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



eventpoll.c |   39 +++++++++++++++++++++++++++++++++------
1 file changed, 33 insertions(+), 6 deletions(-)



Index: linux-2.6.20.ep2/fs/eventpoll.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/eventpoll.c	2007-03-04 14:40:01.000000000 -0800
+++ linux-2.6.20.ep2/fs/eventpoll.c	2007-03-05 15:26:16.000000000 -0800
@@ -258,6 +258,7 @@
 		   int maxevents, long timeout);
 static int eventpollfs_delete_dentry(struct dentry *dentry);
 static struct inode *ep_eventpoll_inode(void);
+static struct inode *ep_create_inode(void);
 static int eventpollfs_get_sb(struct file_system_type *fs_type,
 			      int flags, const char *dev_name,
 			      void *data, struct vfsmount *mnt);
@@ -279,6 +280,9 @@
 /* Virtual fs used to allocate inodes for eventpoll files */
 static struct vfsmount *eventpoll_mnt __read_mostly;
 
+/* Placeholder inode for eventpoll fds */
+static struct inode *eventpoll_inode;
+
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
 	.release	= ep_eventpoll_close,
@@ -733,7 +737,7 @@
 		    struct eventpoll *ep)
 {
 	struct qstr this;
-	char name[32];
+	char name[2 * sizeof(void *) + 8];
 	struct dentry *dentry;
 	struct inode *inode;
 	struct file *file;
@@ -763,15 +767,17 @@
 	 * using the inode number.
 	 */
 	error = -ENOMEM;
-	sprintf(name, "[%lu]", inode->i_ino);
 	this.name = name;
-	this.len = strlen(name);
-	this.hash = inode->i_ino;
+	this.len = sprintf(name, "[%p]", ep);
+	this.hash = 0;
 	dentry = d_alloc(eventpoll_mnt->mnt_sb->s_root, &this);
 	if (!dentry)
 		goto eexit_4;
 	dentry->d_op = &eventpollfs_dentry_operations;
-	d_add(dentry, inode);
+	/* Do not publish this dentry inside the global dentry hash table */
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, inode);
+
 	file->f_path.mnt = mntget(eventpoll_mnt);
 	file->f_path.dentry = dentry;
 	file->f_mapping = inode->i_mapping;
@@ -1555,6 +1561,11 @@
 
 static int eventpollfs_delete_dentry(struct dentry *dentry)
 {
+	/*
+	 * We faked vfs to believe the dentry was hashed when we created it.
+	 * Now we restore the flag so that dput() will work correctly.
+	 */
+	dentry->d_flags |= DCACHE_UNHASHED;
 
 	return 1;
 }
@@ -1562,6 +1573,17 @@
 
 static struct inode *ep_eventpoll_inode(void)
 {
+
+	return igrab(eventpoll_inode);
+}
+
+/*
+ * A single inode exist for all eventpoll files. On the contrary of pipes,
+ * eventpoll inodes has no per-instance data associated, so we can avoid
+ * the allocation of multiple of them.
+ */
+static struct inode *ep_create_inode(void)
+{
 	int error = -ENOMEM;
 	struct inode *inode = new_inode(eventpoll_mnt->mnt_sb);
 
@@ -1626,10 +1648,14 @@
 
 	/* Mount the above commented virtual file system */
 	eventpoll_mnt = kern_mount(&eventpoll_fs_type);
-	error = PTR_ERR(eventpoll_mnt);
 	if (IS_ERR(eventpoll_mnt))
 		goto epanic;
 
+	/* Create the single instance of inode for all eventpoll fds */
+	eventpoll_inode = ep_create_inode();
+	if (IS_ERR(eventpoll_inode))
+		goto epanic;
+
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: successfully initialized.\n",
 			current));
 	return 0;
@@ -1642,6 +1668,7 @@
 static void __exit eventpoll_exit(void)
 {
 	/* Undo all operations done inside eventpoll_init() */
+	iput(eventpoll_inode);
 	unregister_filesystem(&eventpoll_fs_type);
 	mntput(eventpoll_mnt);
 	kmem_cache_destroy(pwq_cache);
