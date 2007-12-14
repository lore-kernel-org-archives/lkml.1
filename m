Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXLNPQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXLNPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXLNPQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:16:19 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59122 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbXLNPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:16:18 -0500
Date: Fri, 14 Dec 2007 17:16:17 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [RFC/PATCH 2/8] revoke: inode revoke lock V7
Message-ID: <Pine.LNX.4.64.0712141715440.28689@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The revoke operation cannibalizes the revoked struct inode and removes it from
the inode cache thus forcing subsequent callers to look up the real inode.
Therefore we must make sure that while the revoke operation is in progress
(e.g. flushing dirty pages to disk) no one takes a new reference to the inode
and starts I/O on it.

Cc: Alan Cox <alan@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/inode.c         |    1 +
 fs/namei.c         |   15 ++++++++++++++-
 include/linux/fs.h |    3 +++
 3 files changed, 18 insertions(+), 1 deletion(-)

Index: 2.6/include/linux/fs.h
===================================================================
--- 2.6.orig/include/linux/fs.h	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/include/linux/fs.h	2007-12-14 16:40:50.000000000 +0200
@@ -150,6 +150,7 @@ #define MS_MGC_MSK 0xffff0000
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_REVOKE_LOCK	1024	/* Inode is being revoked */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -183,6 +184,7 @@ #define MS_MGC_MSK 0xffff0000
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_REVOKE_LOCKED(inode)	((inode)->i_flags & S_REVOKE_LOCK)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
@@ -642,6 +644,7 @@ struct inode {
 	struct list_head	inotify_watches; /* watches on this inode */
 	struct mutex		inotify_mutex;	/* protects the watches list */
 #endif
+	wait_queue_head_t	i_revoke_wait;
 
 	unsigned long		i_state;
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
Index: 2.6/fs/inode.c
===================================================================
--- 2.6.orig/fs/inode.c	2007-10-26 09:36:45.000000000 +0300
+++ 2.6/fs/inode.c	2007-12-14 16:40:50.000000000 +0200
@@ -216,6 +216,7 @@ 	memset(inode, 0, sizeof(*inode));
 	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
 	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
 	i_size_ordered_init(inode);
+	init_waitqueue_head(&inode->i_revoke_wait);
 #ifdef CONFIG_INOTIFY
 	INIT_LIST_HEAD(&inode->inotify_watches);
 	mutex_init(&inode->inotify_mutex);
Index: 2.6/fs/namei.c
===================================================================
--- 2.6.orig/fs/namei.c	2007-10-26 09:36:48.000000000 +0300
+++ 2.6/fs/namei.c	2007-12-14 16:40:50.000000000 +0200
@@ -785,10 +785,23 @@ static int do_lookup(struct nameidata *n
 		     struct path *path)
 {
 	struct vfsmount *mnt = nd->mnt;
-	struct dentry *dentry = __d_lookup(nd->dentry, name);
+	struct dentry *dentry;
 
+again:
+	dentry  = __d_lookup(nd->dentry, name);
 	if (!dentry)
 		goto need_lookup;
+
+	if (dentry->d_inode && IS_REVOKE_LOCKED(dentry->d_inode)) {
+		int err;
+
+		err = wait_event_interruptible(dentry->d_inode->i_revoke_wait,
+			!IS_REVOKE_LOCKED(dentry->d_inode));
+		if (err)
+			return err;
+		goto again;
+	}
+
 	if (dentry->d_op && dentry->d_op->d_revalidate)
 		goto need_revalidate;
 done:
