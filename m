Return-Path: <linux-kernel-owner+w=401wt.eu-S1764036AbYEOTx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764036AbYEOTx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbYEOTv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57972 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbYEOTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:26 -0400
Message-Id: <20080515195105.348960617@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:21 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       David Teigland <teigland@redhat.com>
Subject: [patch 2/9] locks: add special return value for asynchronous locks
Content-Disposition: inline; filename=locking_api_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use a special error value FILE_LOCK_DEFERRED to mean that a locking
operation returned asynchronously.  This is returned by

  posix_lock_file() for sleeping locks to mean that the lock has been
  queued on the block list, and will be woken up when it might become
  available and needs to be retried (either fl_lmops->fl_notify() is
  called or fl_wait is woken up).

  f_op->lock() to mean either the above, or that the filesystem will
  call back with fl_lmops->fl_grant() when the result of the locking
  operation is known.  The filesystem can do this for sleeping as well
  as non-sleeping locks.

This is to make sure, that return values of -EAGAIN and -EINPROGRESS
by filesystems are not mistaken to mean an asynchronous locking.

This also makes error handling in fs/locks.c and lockd/svclock.c
slightly cleaner.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Matthew Wilcox <matthew@wil.cx>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: David Teigland <teigland@redhat.com>
---
 fs/dlm/plock.c     |    2 +-
 fs/lockd/svclock.c |   13 ++++---------
 fs/locks.c         |   28 ++++++++++++++--------------
 include/linux/fs.h |    6 ++++++
 4 files changed, 25 insertions(+), 24 deletions(-)

Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2008-05-09 14:04:16.000000000 +0200
+++ linux-2.6/fs/locks.c	2008-05-09 14:04:46.000000000 +0200
@@ -785,8 +785,10 @@ find_conflict:
 		if (!flock_locks_conflict(request, fl))
 			continue;
 		error = -EAGAIN;
-		if (request->fl_flags & FL_SLEEP)
-			locks_insert_block(fl, request);
+		if (!(request->fl_flags & FL_SLEEP))
+			goto out;
+		error = FILE_LOCK_DEFERRED;
+		locks_insert_block(fl, request);
 		goto out;
 	}
 	if (request->fl_flags & FL_ACCESS)
@@ -842,7 +844,7 @@ static int __posix_lock_file(struct inod
 			error = -EDEADLK;
 			if (posix_locks_deadlock(request, fl))
 				goto out;
-			error = -EAGAIN;
+			error = FILE_LOCK_DEFERRED;
 			locks_insert_block(fl, request);
 			goto out;
   		}
@@ -1041,7 +1043,7 @@ int posix_lock_file_wait(struct file *fi
 	might_sleep ();
 	for (;;) {
 		error = posix_lock_file(filp, fl, NULL);
-		if ((error != -EAGAIN) || !(fl->fl_flags & FL_SLEEP))
+		if (error != FILE_LOCK_DEFERRED)
 			break;
 		error = wait_event_interruptible(fl->fl_wait, !fl->fl_next);
 		if (!error)
@@ -1113,9 +1115,7 @@ int locks_mandatory_area(int read_write,
 
 	for (;;) {
 		error = __posix_lock_file(inode, &fl, NULL);
-		if (error != -EAGAIN)
-			break;
-		if (!(fl.fl_flags & FL_SLEEP))
+		if (error != FILE_LOCK_DEFERRED)
 			break;
 		error = wait_event_interruptible(fl.fl_wait, !fl.fl_next);
 		if (!error) {
@@ -1537,7 +1537,7 @@ int flock_lock_file_wait(struct file *fi
 	might_sleep();
 	for (;;) {
 		error = flock_lock_file(filp, fl);
-		if ((error != -EAGAIN) || !(fl->fl_flags & FL_SLEEP))
+		if (error != FILE_LOCK_DEFERRED)
 			break;
 		error = wait_event_interruptible(fl->fl_wait, !fl->fl_next);
 		if (!error)
@@ -1722,17 +1722,17 @@ out:
  * fl_grant is set. Callers expecting ->lock() to return asynchronously
  * will only use F_SETLK, not F_SETLKW; they will set FL_SLEEP if (and only if)
  * the request is for a blocking lock. When ->lock() does return asynchronously,
- * it must return -EINPROGRESS, and call ->fl_grant() when the lock
+ * it must return FILE_LOCK_DEFERRED, and call ->fl_grant() when the lock
  * request completes.
  * If the request is for non-blocking lock the file system should return
- * -EINPROGRESS then try to get the lock and call the callback routine with
- * the result. If the request timed out the callback routine will return a
+ * FILE_LOCK_DEFERRED then try to get the lock and call the callback routine
+ * with the result. If the request timed out the callback routine will return a
  * nonzero return code and the file system should release the lock. The file
  * system is also responsible to keep a corresponding posix lock when it
  * grants a lock so the VFS can find out which locks are locally held and do
  * the correct lock cleanup when required.
  * The underlying filesystem must not drop the kernel lock or call
- * ->fl_grant() before returning to the caller with a -EINPROGRESS
+ * ->fl_grant() before returning to the caller with a FILE_LOCK_DEFERRED
  * return code.
  */
 int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl, struct file_lock *conf)
@@ -1810,7 +1810,7 @@ again:
 	else {
 		for (;;) {
 			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != -EAGAIN || cmd == F_SETLK)
+			if (error != FILE_LOCK_DEFERRED)
 				break;
 			error = wait_event_interruptible(file_lock->fl_wait,
 					!file_lock->fl_next);
@@ -1947,7 +1947,7 @@ again:
 	else {
 		for (;;) {
 			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != -EAGAIN || cmd == F_SETLK64)
+			if (error != FILE_LOCK_DEFERRED)
 				break;
 			error = wait_event_interruptible(file_lock->fl_wait,
 					!file_lock->fl_next);
Index: linux-2.6/fs/lockd/svclock.c
===================================================================
--- linux-2.6.orig/fs/lockd/svclock.c	2008-05-09 14:04:16.000000000 +0200
+++ linux-2.6/fs/lockd/svclock.c	2008-05-09 14:04:46.000000000 +0200
@@ -423,8 +423,8 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 			goto out;
 		case -EAGAIN:
 			ret = nlm_lck_denied;
-			break;
-		case -EINPROGRESS:
+			goto out;
+		case FILE_LOCK_DEFERRED:
 			if (wait)
 				break;
 			/* Filesystem lock operation is in progress
@@ -439,10 +439,6 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 			goto out;
 	}
 
-	ret = nlm_lck_denied;
-	if (!wait)
-		goto out;
-
 	ret = nlm_lck_blocked;
 
 	/* Append to list of blocked */
@@ -520,7 +516,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
 	}
 
 	error = vfs_test_lock(file->f_file, &lock->fl);
-	if (error == -EINPROGRESS) {
+	if (error == FILE_LOCK_DEFERRED) {
 		ret = nlmsvc_defer_lock_rqst(rqstp, block);
 		goto out;
 	}
@@ -744,8 +740,7 @@ nlmsvc_grant_blocked(struct nlm_block *b
 	switch (error) {
 	case 0:
 		break;
-	case -EAGAIN:
-	case -EINPROGRESS:
+	case FILE_LOCK_DEFERRED:
 		dprintk("lockd: lock still blocked error %d\n", error);
 		nlmsvc_insert_block(block, NLM_NEVER);
 		nlmsvc_release_block(block);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-09 14:04:16.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-09 14:04:46.000000000 +0200
@@ -885,6 +885,12 @@ static inline int file_check_writeable(s
 #define FL_SLEEP	128	/* A blocking lock */
 
 /*
+ * Special return value from posix_lock_file() and vfs_lock_file() for
+ * asynchronous locking.
+ */
+#define FILE_LOCK_DEFERRED 1
+
+/*
  * The POSIX file lock owner is determined by
  * the "struct files_struct" in the thread group
  * (or NULL for no owner - BSD locks).
Index: linux-2.6/fs/dlm/plock.c
===================================================================
--- linux-2.6.orig/fs/dlm/plock.c	2008-05-09 14:04:16.000000000 +0200
+++ linux-2.6/fs/dlm/plock.c	2008-05-09 14:04:46.000000000 +0200
@@ -116,7 +116,7 @@ int dlm_posix_lock(dlm_lockspace_t *lock
 	if (xop->callback == NULL)
 		wait_event(recv_wq, (op->done != 0));
 	else {
-		rv = -EINPROGRESS;
+		rv = FILE_LOCK_DEFERRED;
 		goto out;
 	}
 

--
