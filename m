Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZDNRuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZDNRuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbZDNRt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:49:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56529 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789AbZDNRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:49:21 -0400
Message-Id: <20090414174901.046903274@szeredi.hu>
References: <20090414174835.487031939@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 14 Apr 2009 19:48:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com, mfasheh@suse.com
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 6/6] splice: add helpers for locking pipe inode
Content-Disposition: inline; filename=pipe_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are lots of sequences like this, especially in splice code:

	if (pipe->inode)
		mutex_lock(&pipe->inode->i_mutex);
	/* do something */
	if (pipe->inode)
		mutex_unlock(&pipe->inode->i_mutex);

so introduce helpers which do the conditional locking and unlocking.
Also replace the inode_double_lock() call with a pipe_double_lock()
helper to avoid spreading the use of this functionality beyond the
pipe code.

This patch is just a cleanup, and should cause no behavioral changes.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/inode.c                |   36 ---------------------------------
 fs/pipe.c                 |   42 ++++++++++++++++++++++++++++++++++----
 fs/splice.c               |   50 +++++++++++++++++++---------------------------
 include/linux/fs.h        |    3 --
 include/linux/pipe_fs_i.h |    5 ++++
 5 files changed, 64 insertions(+), 72 deletions(-)

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2009-04-14 16:35:15.000000000 +0200
+++ linux-2.6/fs/pipe.c	2009-04-14 19:09:01.000000000 +0200
@@ -37,6 +37,42 @@
  * -- Manfred Spraul <manfred@colorfullife.com> 2002-05-09
  */
 
+static void pipe_lock_nested(struct pipe_inode_info *pipe, int subclass)
+{
+	if (pipe->inode)
+		mutex_lock_nested(&pipe->inode->i_mutex, subclass);
+}
+
+void pipe_lock(struct pipe_inode_info *pipe)
+{
+	/*
+	 * pipe_lock() nests non-pipe inode locks (for writing to a file)
+	 */
+	pipe_lock_nested(pipe, I_MUTEX_PARENT);
+}
+EXPORT_SYMBOL(pipe_lock);
+
+void pipe_unlock(struct pipe_inode_info *pipe)
+{
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+}
+EXPORT_SYMBOL(pipe_unlock);
+
+void pipe_double_lock(struct pipe_inode_info *pipe1,
+		      struct pipe_inode_info *pipe2)
+{
+	BUG_ON(pipe1 == pipe2);
+
+	if (pipe1 < pipe2) {
+		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
+		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
+	} else {
+		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
+		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
+	}
+}
+
 /* Drop the inode semaphore and wait for a pipe event, atomically */
 void pipe_wait(struct pipe_inode_info *pipe)
 {
@@ -47,12 +83,10 @@ void pipe_wait(struct pipe_inode_info *p
 	 * is considered a noninteractive wait:
 	 */
 	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 	schedule();
 	finish_wait(&pipe->wait, &wait);
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 }
 
 static int
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-04-14 19:01:16.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-04-14 19:09:01.000000000 +0200
@@ -182,8 +182,7 @@ ssize_t splice_to_pipe(struct pipe_inode
 	do_wakeup = 0;
 	page_nr = 0;
 
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	for (;;) {
 		if (!pipe->readers) {
@@ -245,15 +244,13 @@ ssize_t splice_to_pipe(struct pipe_inode
 		pipe->waiting_writers--;
 	}
 
-	if (pipe->inode) {
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 
-		if (do_wakeup) {
-			smp_mb();
-			if (waitqueue_active(&pipe->wait))
-				wake_up_interruptible(&pipe->wait);
-			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-		}
+	if (do_wakeup) {
+		smp_mb();
+		if (waitqueue_active(&pipe->wait))
+			wake_up_interruptible(&pipe->wait);
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
 
 	while (page_nr < spd_pages)
@@ -801,11 +798,9 @@ ssize_t splice_from_pipe(struct pipe_ino
 		.u.file = out,
 	};
 
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 	ret = __splice_from_pipe(pipe, &sd, actor);
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 
 	return ret;
 }
@@ -837,8 +832,7 @@ generic_file_splice_write(struct pipe_in
 	};
 	ssize_t ret;
 
-	if (pipe->inode)
-		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
+	pipe_lock(pipe);
 
 	splice_from_pipe_begin(&sd);
 	do {
@@ -854,8 +848,7 @@ generic_file_splice_write(struct pipe_in
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
 
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 
 	if (sd.num_spliced)
 		ret = sd.num_spliced;
@@ -1348,8 +1341,7 @@ static long vmsplice_to_user(struct file
 	if (!pipe)
 		return -EBADF;
 
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	error = ret = 0;
 	while (nr_segs) {
@@ -1404,8 +1396,7 @@ static long vmsplice_to_user(struct file
 		iov++;
 	}
 
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 
 	if (!ret)
 		ret = error;
@@ -1533,7 +1524,7 @@ static int link_ipipe_prep(struct pipe_i
 		return 0;
 
 	ret = 0;
-	mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	while (!pipe->nrbufs) {
 		if (signal_pending(current)) {
@@ -1551,7 +1542,7 @@ static int link_ipipe_prep(struct pipe_i
 		pipe_wait(pipe);
 	}
 
-	mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 	return ret;
 }
 
@@ -1571,7 +1562,7 @@ static int link_opipe_prep(struct pipe_i
 		return 0;
 
 	ret = 0;
-	mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	while (pipe->nrbufs >= PIPE_BUFFERS) {
 		if (!pipe->readers) {
@@ -1592,7 +1583,7 @@ static int link_opipe_prep(struct pipe_i
 		pipe->waiting_writers--;
 	}
 
-	mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 	return ret;
 }
 
@@ -1608,10 +1599,10 @@ static int link_pipe(struct pipe_inode_i
 
 	/*
 	 * Potential ABBA deadlock, work around it by ordering lock
-	 * grabbing by inode address. Otherwise two different processes
+	 * grabbing by pipe info address. Otherwise two different processes
 	 * could deadlock (one doing tee from A -> B, the other from B -> A).
 	 */
-	inode_double_lock(ipipe->inode, opipe->inode);
+	pipe_double_lock(ipipe, opipe);
 
 	do {
 		if (!opipe->readers) {
@@ -1662,7 +1653,8 @@ static int link_pipe(struct pipe_inode_i
 	if (!ret && ipipe->waiting_writers && (flags & SPLICE_F_NONBLOCK))
 		ret = -EAGAIN;
 
-	inode_double_unlock(ipipe->inode, opipe->inode);
+	pipe_unlock(ipipe);
+	pipe_unlock(opipe);
 
 	/*
 	 * If we put data in the output pipe, wakeup any potential readers.
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-04-14 19:01:16.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-04-14 19:09:01.000000000 +0200
@@ -738,9 +738,6 @@ enum inode_i_mutex_lock_class
 	I_MUTEX_QUOTA
 };
 
-extern void inode_double_lock(struct inode *inode1, struct inode *inode2);
-extern void inode_double_unlock(struct inode *inode1, struct inode *inode2);
-
 /*
  * NOTE: in a 32bit arch with a preemptable kernel and
  * an UP compile the i_size_read/write must be atomic
Index: linux-2.6/include/linux/pipe_fs_i.h
===================================================================
--- linux-2.6.orig/include/linux/pipe_fs_i.h	2009-04-14 16:35:15.000000000 +0200
+++ linux-2.6/include/linux/pipe_fs_i.h	2009-04-14 19:09:01.000000000 +0200
@@ -134,6 +134,11 @@ struct pipe_buf_operations {
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
 
+/* Pipe lock and unlock operations */
+void pipe_lock(struct pipe_inode_info *);
+void pipe_unlock(struct pipe_inode_info *);
+void pipe_double_lock(struct pipe_inode_info *, struct pipe_inode_info *);
+
 /* Drop the inode semaphore and wait for a pipe event, atomically */
 void pipe_wait(struct pipe_inode_info *pipe);
 
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2009-04-14 16:35:15.000000000 +0200
+++ linux-2.6/fs/inode.c	2009-04-14 19:09:01.000000000 +0200
@@ -1470,42 +1470,6 @@ static void __wait_on_freeing_inode(stru
 	spin_lock(&inode_lock);
 }
 
-/*
- * We rarely want to lock two inodes that do not have a parent/child
- * relationship (such as directory, child inode) simultaneously. The
- * vast majority of file systems should be able to get along fine
- * without this. Do not use these functions except as a last resort.
- */
-void inode_double_lock(struct inode *inode1, struct inode *inode2)
-{
-	if (inode1 == NULL || inode2 == NULL || inode1 == inode2) {
-		if (inode1)
-			mutex_lock(&inode1->i_mutex);
-		else if (inode2)
-			mutex_lock(&inode2->i_mutex);
-		return;
-	}
-
-	if (inode1 < inode2) {
-		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
-	} else {
-		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
-	}
-}
-EXPORT_SYMBOL(inode_double_lock);
-
-void inode_double_unlock(struct inode *inode1, struct inode *inode2)
-{
-	if (inode1)
-		mutex_unlock(&inode1->i_mutex);
-
-	if (inode2 && inode2 != inode1)
-		mutex_unlock(&inode2->i_mutex);
-}
-EXPORT_SYMBOL(inode_double_unlock);
-
 static __initdata unsigned long ihash_entries;
 static int __init set_ihash_entries(char *str)
 {

--
