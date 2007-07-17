Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXGQMrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXGQMrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbXGQMrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:47:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbXGQMrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:47:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Fix file locking
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 17 Jul 2007 13:47:32 +0100
Message-ID: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix file locking for AFS:

 (*) Start the lock manager thread under a mutex to avoid a race.

 (*) Made the locking non-fair: New readlocks will jump pending writelocks if
     there's a readlock currently granted on a file.  This makes the behaviour
     similar to Linux's VFS locking.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/flock.c |  126 +++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 79 insertions(+), 47 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index 8f07f8d..bb97105 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -19,6 +19,7 @@ static void afs_fl_copy_lock(struct file_lock *new, struct file_lock *fl);
 static void afs_fl_release_private(struct file_lock *fl);
 
 static struct workqueue_struct *afs_lock_manager;
+static DEFINE_MUTEX(afs_lock_manager_mutex);
 
 static struct file_lock_operations afs_lock_ops = {
 	.fl_copy_lock		= afs_fl_copy_lock,
@@ -30,12 +31,20 @@ static struct file_lock_operations afs_lock_ops = {
  */
 static int afs_init_lock_manager(void)
 {
+	int ret;
+
+	ret = 0;
 	if (!afs_lock_manager) {
-		afs_lock_manager = create_singlethread_workqueue("kafs_lockd");
-		if (!afs_lock_manager)
-			return -ENOMEM;
+		mutex_lock(&afs_lock_manager_mutex);
+		if (!afs_lock_manager) {
+			afs_lock_manager =
+				create_singlethread_workqueue("kafs_lockd");
+			if (!afs_lock_manager)
+				ret = -ENOMEM;
+		}
+		mutex_unlock(&afs_lock_manager_mutex);
 	}
-	return 0;
+	return ret;
 }
 
 /*
@@ -68,6 +77,29 @@ static void afs_schedule_lock_extension(struct afs_vnode *vnode)
 }
 
 /*
+ * grant one or more locks (readlocks are allowed to jump the queue if the
+ * first lock in the queue is itself a readlock)
+ * - the caller must hold the vnode lock
+ */
+static void afs_grant_locks(struct afs_vnode *vnode, struct file_lock *fl)
+{
+	struct file_lock *p, *_p;
+
+	list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
+	if (fl->fl_type == F_RDLCK) {
+		list_for_each_entry_safe(p, _p, &vnode->pending_locks,
+					 fl_u.afs.link) {
+			if (p->fl_type == F_RDLCK) {
+				p->fl_u.afs.state = AFS_LOCK_GRANTED;
+				list_move_tail(&p->fl_u.afs.link,
+					       &vnode->granted_locks);
+				wake_up(&p->fl_wait);
+			}
+		}
+	}
+}
+
+/*
  * do work for a lock, including:
  * - probing for a lock we're waiting on but didn't get immediately
  * - extending a lock that's close to timing out
@@ -172,8 +204,7 @@ void afs_lock_work(struct work_struct *work)
 				       struct file_lock, fl_u.afs.link) == fl) {
 				fl->fl_u.afs.state = ret;
 				if (ret == AFS_LOCK_GRANTED)
-					list_move_tail(&fl->fl_u.afs.link,
-						       &vnode->granted_locks);
+					afs_grant_locks(vnode, fl);
 				else
 					list_del_init(&fl->fl_u.afs.link);
 				wake_up(&fl->fl_wait);
@@ -258,49 +289,50 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
 
 	spin_lock(&vnode->lock);
 
-	if (list_empty(&vnode->pending_locks)) {
-		/* if there's no-one else with a lock on this vnode, then we
-		 * need to ask the server for a lock */
-		if (list_empty(&vnode->granted_locks)) {
-			_debug("not locked");
-			ASSERTCMP(vnode->flags &
-				  ((1 << AFS_VNODE_LOCKING) |
-				   (1 << AFS_VNODE_READLOCKED) |
-				   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
-			list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
-			set_bit(AFS_VNODE_LOCKING, &vnode->flags);
-			spin_unlock(&vnode->lock);
+	/* if we've already got a readlock on the server then we can instantly
+	 * grant another readlock, irrespective of whether there are any
+	 * pending writelocks */
+	if (type == AFS_LOCK_READ &&
+	    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
+		_debug("instant readlock");
+		ASSERTCMP(vnode->flags &
+			  ((1 << AFS_VNODE_LOCKING) |
+			   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
+		ASSERT(!list_empty(&vnode->granted_locks));
+		goto sharing_existing_lock;
+	}
 
-			ret = afs_vnode_set_lock(vnode, key, type);
-			clear_bit(AFS_VNODE_LOCKING, &vnode->flags);
-			switch (ret) {
-			case 0:
-				goto acquired_server_lock;
-			case -EWOULDBLOCK:
-				spin_lock(&vnode->lock);
-				ASSERT(list_empty(&vnode->granted_locks));
-				ASSERTCMP(vnode->pending_locks.next, ==,
-					  &fl->fl_u.afs.link);
-				goto wait;
-			default:
-				spin_lock(&vnode->lock);
-				list_del_init(&fl->fl_u.afs.link);
-				spin_unlock(&vnode->lock);
-				goto error;
-			}
-		}
+	/* if there's no-one else with a lock on this vnode, then we need to
+	 * ask the server for a lock */
+	if (list_empty(&vnode->pending_locks) &&
+	    list_empty(&vnode->granted_locks)) {
+		_debug("not locked");
+		ASSERTCMP(vnode->flags &
+			  ((1 << AFS_VNODE_LOCKING) |
+			   (1 << AFS_VNODE_READLOCKED) |
+			   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
+		list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
+		set_bit(AFS_VNODE_LOCKING, &vnode->flags);
+		spin_unlock(&vnode->lock);
 
-		/* if we've already got a readlock on the server and no waiting
-		 * writelocks, then we might be able to instantly grant another
-		 * readlock */
-		if (type == AFS_LOCK_READ &&
-		    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
-			_debug("instant readlock");
-			ASSERTCMP(vnode->flags &
-				  ((1 << AFS_VNODE_LOCKING) |
-				   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
-			ASSERT(!list_empty(&vnode->granted_locks));
-			goto sharing_existing_lock;
+		ret = afs_vnode_set_lock(vnode, key, type);
+		clear_bit(AFS_VNODE_LOCKING, &vnode->flags);
+		switch (ret) {
+		case 0:
+			_debug("acquired");
+			goto acquired_server_lock;
+		case -EWOULDBLOCK:
+			_debug("would block");
+			spin_lock(&vnode->lock);
+			ASSERT(list_empty(&vnode->granted_locks));
+			ASSERTCMP(vnode->pending_locks.next, ==,
+				  &fl->fl_u.afs.link);
+			goto wait;
+		default:
+			spin_lock(&vnode->lock);
+			list_del_init(&fl->fl_u.afs.link);
+			spin_unlock(&vnode->lock);
+			goto error;
 		}
 	}
 

