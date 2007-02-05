Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbXBEOU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbXBEOU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbXBEOU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:20:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795AbXBEOU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:20:57 -0500
Subject: [DLM] fix user unlocking [24/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:29:01 +0000
Message-Id: <1170685741.11001.319.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 53c5a8421b306277af764de28a59a8da601c4d99 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Mon, 15 Jan 2007 10:34:52 -0600
Subject: [PATCH] [DLM] fix user unlocking

When a user process exits, we clear all the locks it holds.  There is a
problem, though, with locks that the process had begun unlocking before it
exited.  We couldn't find the lkb's that were in the process of being
unlocked remotely, to flag that they are DEAD.  To solve this, we move
lkb's being unlocked onto a new list in the per-process structure that
tracks what locks the process is holding.  We can then go through this
list to flag the necessary lkb's when clearing locks for a process when it
exits.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index ee993c5..61d9320 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -526,6 +526,7 @@ struct dlm_user_proc {
 	spinlock_t		asts_spin;
 	struct list_head	locks;
 	spinlock_t		locks_spin;
+	struct list_head	unlocking;
 	wait_queue_head_t	wait;
 };
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 5bac982..6ad2b8e 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3772,12 +3772,10 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 		goto out_put;
 
 	spin_lock(&ua->proc->locks_spin);
-	list_del_init(&lkb->lkb_ownqueue);
+	/* dlm_user_add_ast() may have already taken lkb off the proc list */
+	if (!list_empty(&lkb->lkb_ownqueue))
+		list_move(&lkb->lkb_ownqueue, &ua->proc->unlocking);
 	spin_unlock(&ua->proc->locks_spin);
-
-	/* this removes the reference for the proc->locks list added by
-	   dlm_user_request */
-	unhold_lkb(lkb);
  out_put:
 	dlm_put_lkb(lkb);
  out:
@@ -3817,9 +3815,8 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	/* this lkb was removed from the WAITING queue */
 	if (lkb->lkb_grmode == DLM_LOCK_IV) {
 		spin_lock(&ua->proc->locks_spin);
-		list_del_init(&lkb->lkb_ownqueue);
+		list_move(&lkb->lkb_ownqueue, &ua->proc->unlocking);
 		spin_unlock(&ua->proc->locks_spin);
-		unhold_lkb(lkb);
 	}
  out_put:
 	dlm_put_lkb(lkb);
@@ -3880,11 +3877,6 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 	mutex_lock(&ls->ls_clear_proc_locks);
 
 	list_for_each_entry_safe(lkb, safe, &proc->locks, lkb_ownqueue) {
-		if (lkb->lkb_ast_type) {
-			list_del(&lkb->lkb_astqueue);
-			unhold_lkb(lkb);
-		}
-
 		list_del_init(&lkb->lkb_ownqueue);
 
 		if (lkb->lkb_exflags & DLM_LKF_PERSISTENT) {
@@ -3901,6 +3893,20 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 
 		dlm_put_lkb(lkb);
 	}
+
+	/* in-progress unlocks */
+	list_for_each_entry_safe(lkb, safe, &proc->unlocking, lkb_ownqueue) {
+		list_del_init(&lkb->lkb_ownqueue);
+		lkb->lkb_flags |= DLM_IFL_DEAD;
+		dlm_put_lkb(lkb);
+	}
+
+	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_astqueue) {
+		list_del(&lkb->lkb_astqueue);
+		dlm_put_lkb(lkb);
+	}
+
 	mutex_unlock(&ls->ls_clear_proc_locks);
 	unlock_recovery(ls);
 }
+
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index c37e93e..d378b7f 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -180,6 +180,14 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type)
 	    ua->lksb.sb_status == -EAGAIN && !list_empty(&lkb->lkb_ownqueue))
 		remove_ownqueue = 1;
 
+	/* unlocks or cancels of waiting requests need to be removed from the
+	   proc's unlocking list, again there must be a better way...  */
+
+	if (ua->lksb.sb_status == -DLM_EUNLOCK ||
+	    (ua->lksb.sb_status == -DLM_ECANCEL &&
+	     lkb->lkb_grmode == DLM_LOCK_IV))
+		remove_ownqueue = 1;
+
 	/* We want to copy the lvb to userspace when the completion
 	   ast is read if the status is 0, the lock has an lvb and
 	   lvb_ops says we should.  We could probably have set_lvb_lock()
@@ -523,6 +531,7 @@ static int device_open(struct inode *inode, struct file *file)
 	proc->lockspace = ls->ls_local_handle;
 	INIT_LIST_HEAD(&proc->asts);
 	INIT_LIST_HEAD(&proc->locks);
+	INIT_LIST_HEAD(&proc->unlocking);
 	spin_lock_init(&proc->asts_spin);
 	spin_lock_init(&proc->locks_spin);
 	init_waitqueue_head(&proc->wait);
-- 
1.4.4.2



