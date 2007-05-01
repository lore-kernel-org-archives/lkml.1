Return-Path: <linux-kernel-owner+w=401wt.eu-S1031662AbXEAKNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031662AbXEAKNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031660AbXEAKNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:13:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031649AbXEAKNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:13:47 -0400
Subject: [DLM] overlapping cancel and unlock [13/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:09:12 +0100
Message-Id: <1178014152.5462.153.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From ef0c2bb05f40f9a0cd2deae63e199bfa62faa7fa Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 28 Mar 2007 09:56:46 -0500
Subject: [PATCH] [DLM] overlapping cancel and unlock

Full cancel and force-unlock support.  In the past, cancel and
force-unlock
wouldn't work if there was another operation in progress on the lock.
Now,
both cancel and unlock-force can overlap an operation on a lock, meaning
there
may be 2 or 3 operations in progress on a lock in parallel.  This
support is
important not only because cancel and force-unlock are explicit
operations
that an app can use, but both are used implicitly when a process exits
while
holding locks.

Summary of changes:

- add-to and remove-from waiters functions were rewritten to handle
situations
  with more than one remote operation outstanding on a lock

- validate_unlock_args detects when an overlapping cancel/unlock-force
  can be sent and when it needs to be delayed until a request/lookup
  reply is received

- processing request/lookup replies detects when cancel/unlock-force
  occured during the op, and carries out the delayed cancel/unlock-force

- manipulation of the "waiters" (remote operation) state of a lock moved
under
  the standard rsb mutex that protects all the other lock state

- the two recovery routines related to locks on the waiters list changed
  according to the way lkb's are now locked before accessing waiters
state

- waiters recovery detects when lkb's being recovered have overlapping
  cancel/unlock-force, and may not recover such locks

- revert_lock (cancel) returns a value to distinguish cases where it did
  nothing vs cases where it actually did a cancel; the cancel completion
ast
  should only be done when cancel did something

- orphaned locks put on new list so they can be found later for purging

- cancel must be called on a lock when making it an orphan

- flag user locks (ENDOFLIFE) at the end of their useful life (to the
  application) so we can return an error for any further
cancel/unlock-force

- we weren't setting COMP/BAST ast flags if one was already set, so we'd
lose
  either a completion or blocking ast

- clear an unread bast on a lock that's become unlocked

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 61d9320..178931c 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -2,7 +2,7 @@

*******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights
reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to
use,
 **  modify, copy, or redistribute it subject to the terms and
conditions
@@ -210,6 +210,9 @@ struct dlm_args {
 #define DLM_IFL_MSTCPY		0x00010000
 #define DLM_IFL_RESEND		0x00020000
 #define DLM_IFL_DEAD		0x00040000
+#define DLM_IFL_OVERLAP_UNLOCK  0x00080000
+#define DLM_IFL_OVERLAP_CANCEL  0x00100000
+#define DLM_IFL_ENDOFLIFE	0x00200000
 #define DLM_IFL_USER		0x00000001
 #define DLM_IFL_ORPHAN		0x00000002
 
@@ -230,8 +233,8 @@ struct dlm_lkb {
 	int8_t			lkb_grmode;	/* granted lock mode */
 	int8_t			lkb_bastmode;	/* requested mode */
 	int8_t			lkb_highbast;	/* highest mode bast sent for */
-
 	int8_t			lkb_wait_type;	/* type of reply waiting for */
+	int8_t			lkb_wait_count;
 	int8_t			lkb_ast_type;	/* type of ast queued for */
 
 	struct list_head	lkb_idtbl_list;	/* lockspace lkbtbl */
@@ -440,6 +443,9 @@ struct dlm_ls {
 	struct mutex		ls_waiters_mutex;
 	struct list_head	ls_waiters;	/* lkbs needing a reply */
 
+	struct mutex		ls_orphans_mutex;
+	struct list_head	ls_orphans;
+
 	struct list_head	ls_nodes;	/* current nodes in ls */
 	struct list_head	ls_nodes_gone;	/* dead node list, recovery */
 	int			ls_num_nodes;	/* number of nodes in ls */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index e725005..b865a46 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1,7 +1,7 @@
 /******************************************************************************

*******************************************************************************
 **
-**  Copyright (C) 2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to
use,
 **  modify, copy, or redistribute it subject to the terms and
conditions
@@ -254,6 +254,22 @@ static inline int down_conversion(struct dlm_lkb
*lkb)
 	return (!middle_conversion(lkb) && lkb->lkb_rqmode < lkb->lkb_grmode);
 }
 
+static inline int is_overlap_unlock(struct dlm_lkb *lkb)
+{
+	return lkb->lkb_flags & DLM_IFL_OVERLAP_UNLOCK;
+}
+
+static inline int is_overlap_cancel(struct dlm_lkb *lkb)
+{
+	return lkb->lkb_flags & DLM_IFL_OVERLAP_CANCEL;
+}
+
+static inline int is_overlap(struct dlm_lkb *lkb)
+{
+	return (lkb->lkb_flags & (DLM_IFL_OVERLAP_UNLOCK |
+				  DLM_IFL_OVERLAP_CANCEL));
+}
+
 static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 {
 	if (is_master_copy(lkb))
@@ -267,6 +283,12 @@ static void queue_cast(struct dlm_rsb *r, struct
dlm_lkb *lkb, int rv)
 	dlm_add_ast(lkb, AST_COMP);
 }
 
+static inline void queue_cast_overlap(struct dlm_rsb *r, struct dlm_lkb
*lkb)
+{
+	queue_cast(r, lkb,
+		   is_overlap_unlock(lkb) ? -DLM_EUNLOCK : -DLM_ECANCEL);
+}
+
 static void queue_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int
rqmode)
 {
 	if (is_master_copy(lkb))
@@ -547,6 +569,7 @@ static int create_lkb(struct dlm_ls *ls, struct
dlm_lkb **lkb_ret)
 	lkb->lkb_grmode = DLM_LOCK_IV;
 	kref_init(&lkb->lkb_ref);
 	INIT_LIST_HEAD(&lkb->lkb_ownqueue);
+	INIT_LIST_HEAD(&lkb->lkb_rsb_lookup);
 
 	get_random_bytes(&bucket, sizeof(bucket));
 	bucket &= (ls->ls_lkbtbl_size - 1);
@@ -735,23 +758,75 @@ static void move_lkb(struct dlm_rsb *r, struct
dlm_lkb *lkb, int sts)
 	unhold_lkb(lkb);
 }
 
+static int msg_reply_type(int mstype)
+{
+	switch (mstype) {
+	case DLM_MSG_REQUEST:
+		return DLM_MSG_REQUEST_REPLY;
+	case DLM_MSG_CONVERT:
+		return DLM_MSG_CONVERT_REPLY;
+	case DLM_MSG_UNLOCK:
+		return DLM_MSG_UNLOCK_REPLY;
+	case DLM_MSG_CANCEL:
+		return DLM_MSG_CANCEL_REPLY;
+	case DLM_MSG_LOOKUP:
+		return DLM_MSG_LOOKUP_REPLY;
+	}
+	return -1;
+}
+
 /* add/remove lkb from global waiters list of lkb's waiting for
    a reply from a remote node */
 
-static void add_to_waiters(struct dlm_lkb *lkb, int mstype)
+static int add_to_waiters(struct dlm_lkb *lkb, int mstype)
 {
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+	int error = 0;
 
 	mutex_lock(&ls->ls_waiters_mutex);
-	if (lkb->lkb_wait_type) {
-		log_print("add_to_waiters error %d", lkb->lkb_wait_type);
+
+	if (is_overlap_unlock(lkb) ||
+	    (is_overlap_cancel(lkb) && (mstype == DLM_MSG_CANCEL))) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (lkb->lkb_wait_type || is_overlap_cancel(lkb)) {
+		switch (mstype) {
+		case DLM_MSG_UNLOCK:
+			lkb->lkb_flags |= DLM_IFL_OVERLAP_UNLOCK;
+			break;
+		case DLM_MSG_CANCEL:
+			lkb->lkb_flags |= DLM_IFL_OVERLAP_CANCEL;
+			break;
+		default:
+			error = -EBUSY;
+			goto out;
+		}
+		lkb->lkb_wait_count++;
+		hold_lkb(lkb);
+
+		log_debug(ls, "add overlap %x cur %d new %d count %d flags %x",
+			  lkb->lkb_id, lkb->lkb_wait_type, mstype,
+			  lkb->lkb_wait_count, lkb->lkb_flags);
 		goto out;
 	}
+
+	DLM_ASSERT(!lkb->lkb_wait_count,
+		   dlm_print_lkb(lkb);
+		   printk("wait_count %d\n", lkb->lkb_wait_count););
+
+	lkb->lkb_wait_count++;
 	lkb->lkb_wait_type = mstype;
-	kref_get(&lkb->lkb_ref);
+	hold_lkb(lkb);
 	list_add(&lkb->lkb_wait_reply, &ls->ls_waiters);
  out:
+	if (error)
+		log_error(ls, "add_to_waiters %x error %d flags %x %d %d %s",
+			  lkb->lkb_id, error, lkb->lkb_flags, mstype,
+			  lkb->lkb_wait_type, lkb->lkb_resource->res_name);
 	mutex_unlock(&ls->ls_waiters_mutex);
+	return error;
 }
 
 /* We clear the RESEND flag because we might be taking an lkb off the
waiters
@@ -759,34 +834,85 @@ static void add_to_waiters(struct dlm_lkb *lkb,
int mstype)
    request reply on the requestqueue) between dlm_recover_waiters_pre()
which
    set RESEND and dlm_recover_waiters_post() */
 
-static int _remove_from_waiters(struct dlm_lkb *lkb)
+static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype)
 {
-	int error = 0;
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+	int overlap_done = 0;
 
-	if (!lkb->lkb_wait_type) {
-		log_print("remove_from_waiters error");
-		error = -EINVAL;
-		goto out;
+	if (is_overlap_unlock(lkb) && (mstype == DLM_MSG_UNLOCK_REPLY)) {
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
+		overlap_done = 1;
+		goto out_del;
 	}
-	lkb->lkb_wait_type = 0;
+
+	if (is_overlap_cancel(lkb) && (mstype == DLM_MSG_CANCEL_REPLY)) {
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
+		overlap_done = 1;
+		goto out_del;
+	}
+
+	/* N.B. type of reply may not always correspond to type of original
+	   msg due to lookup->request optimization, verify others? */
+
+	if (lkb->lkb_wait_type) {
+		lkb->lkb_wait_type = 0;
+		goto out_del;
+	}
+
+	log_error(ls, "remove_from_waiters lkid %x flags %x types %d %d",
+		  lkb->lkb_id, lkb->lkb_flags, mstype, lkb->lkb_wait_type);
+	return -1;
+
+ out_del:
+	/* the force-unlock/cancel has completed and we haven't recvd a reply
+	   to the op that was in progress prior to the unlock/cancel; we
+	   give up on any reply to the earlier op.  FIXME: not sure when/how
+	   this would happen */
+
+	if (overlap_done && lkb->lkb_wait_type) {
+		log_error(ls, "remove_from_waiters %x reply %d give up on %d",
+			  lkb->lkb_id, mstype, lkb->lkb_wait_type);
+		lkb->lkb_wait_count--;
+		lkb->lkb_wait_type = 0;
+	}
+
+	DLM_ASSERT(lkb->lkb_wait_count, dlm_print_lkb(lkb););
+
 	lkb->lkb_flags &= ~DLM_IFL_RESEND;
-	list_del(&lkb->lkb_wait_reply);
+	lkb->lkb_wait_count--;
+	if (!lkb->lkb_wait_count)
+		list_del_init(&lkb->lkb_wait_reply);
 	unhold_lkb(lkb);
- out:
-	return error;
+	return 0;
 }
 
-static int remove_from_waiters(struct dlm_lkb *lkb)
+static int remove_from_waiters(struct dlm_lkb *lkb, int mstype)
 {
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 	int error;
 
 	mutex_lock(&ls->ls_waiters_mutex);
-	error = _remove_from_waiters(lkb);
+	error = _remove_from_waiters(lkb, mstype);
 	mutex_unlock(&ls->ls_waiters_mutex);
 	return error;
 }
 
+/* Handles situations where we might be processing a "fake" or "stub"
reply in
+   which we can't try to take waiters_mutex again. */
+
+static int remove_from_waiters_ms(struct dlm_lkb *lkb, struct
dlm_message *ms)
+{
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+	int error;
+
+	if (ms != &ls->ls_stub_ms)
+		mutex_lock(&ls->ls_waiters_mutex);
+	error = _remove_from_waiters(lkb, ms->m_type);
+	if (ms != &ls->ls_stub_ms)
+		mutex_unlock(&ls->ls_waiters_mutex);
+	return error;
+}
+
 static void dir_remove(struct dlm_rsb *r)
 {
 	int to_nodeid;
@@ -988,8 +1114,14 @@ static void remove_lock_pc(struct dlm_rsb *r,
struct dlm_lkb *lkb)
 	_remove_lock(r, lkb);
 }
 
-static void revert_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
+/* returns: 0 did nothing
+	    1 moved lock to granted
+	   -1 removed lock */
+
+static int revert_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
+	int rv = 0;
+
 	lkb->lkb_rqmode = DLM_LOCK_IV;
 
 	switch (lkb->lkb_status) {
@@ -997,6 +1129,7 @@ static void revert_lock(struct dlm_rsb *r, struct
dlm_lkb *lkb)
 		break;
 	case DLM_LKSTS_CONVERT:
 		move_lkb(r, lkb, DLM_LKSTS_GRANTED);
+		rv = 1;
 		break;
 	case DLM_LKSTS_WAITING:
 		del_lkb(r, lkb);
@@ -1004,15 +1137,17 @@ static void revert_lock(struct dlm_rsb *r,
struct dlm_lkb *lkb)
 		/* this unhold undoes the original ref from create_lkb()
 		   so this leads to the lkb being freed */
 		unhold_lkb(lkb);
+		rv = -1;
 		break;
 	default:
 		log_print("invalid status for revert %d", lkb->lkb_status);
 	}
+	return rv;
 }
 
-static void revert_lock_pc(struct dlm_rsb *r, struct dlm_lkb *lkb)
+static int revert_lock_pc(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
-	revert_lock(r, lkb);
+	return revert_lock(r, lkb);
 }
 
 static void _grant_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
@@ -1499,7 +1634,7 @@ static void process_lookup_list(struct dlm_rsb *r)
 	struct dlm_lkb *lkb, *safe;
 
 	list_for_each_entry_safe(lkb, safe, &r->res_lookup, lkb_rsb_lookup) {
-		list_del(&lkb->lkb_rsb_lookup);
+		list_del_init(&lkb->lkb_rsb_lookup);
 		_request_lock(r, lkb);
 		schedule();
 	}
@@ -1530,7 +1665,7 @@ static void confirm_master(struct dlm_rsb *r, int
error)
 		if (!list_empty(&r->res_lookup)) {
 			lkb = list_entry(r->res_lookup.next, struct dlm_lkb,
 					 lkb_rsb_lookup);
-			list_del(&lkb->lkb_rsb_lookup);
+			list_del_init(&lkb->lkb_rsb_lookup);
 			r->res_first_lkid = lkb->lkb_id;
 			_request_lock(r, lkb);
 		} else
@@ -1614,6 +1749,9 @@ static int set_unlock_args(uint32_t flags, void
*astarg, struct dlm_args *args)
  		      DLM_LKF_FORCEUNLOCK))
 		return -EINVAL;
 
+	if (flags & DLM_LKF_CANCEL && flags & DLM_LKF_FORCEUNLOCK)
+		return -EINVAL;
+
 	args->flags = flags;
 	args->astparam = (long) astarg;
 	return 0;
@@ -1638,6 +1776,9 @@ static int validate_lock_args(struct dlm_ls *ls,
struct dlm_lkb *lkb,
 
 		if (lkb->lkb_wait_type)
 			goto out;
+
+		if (is_overlap(lkb))
+			goto out;
 	}
 
 	lkb->lkb_exflags = args->flags;
@@ -1654,35 +1795,126 @@ static int validate_lock_args(struct dlm_ls
*ls, struct dlm_lkb *lkb,
 	return rv;
 }
 
+/* when dlm_unlock() sees -EBUSY with CANCEL/FORCEUNLOCK it returns 0
+   for success */
+
+/* note: it's valid for lkb_nodeid/res_nodeid to be -1 when we get here
+   because there may be a lookup in progress and it's valid to do
+   cancel/unlockf on it */
+
 static int validate_unlock_args(struct dlm_lkb *lkb, struct dlm_args
*args)
 {
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 	int rv = -EINVAL;
 
-	if (lkb->lkb_flags & DLM_IFL_MSTCPY)
+	if (lkb->lkb_flags & DLM_IFL_MSTCPY) {
+		log_error(ls, "unlock on MSTCPY %x", lkb->lkb_id);
+		dlm_print_lkb(lkb);
 		goto out;
+	}
 
-	if (args->flags & DLM_LKF_FORCEUNLOCK)
-		goto out_ok;
+	/* an lkb may still exist even though the lock is EOL'ed due to a
+	   cancel, unlock or failed noqueue request; an app can't use these
+	   locks; return same error as if the lkid had not been found at all
*/
 
-	if (args->flags & DLM_LKF_CANCEL &&
-	    lkb->lkb_status == DLM_LKSTS_GRANTED)
+	if (lkb->lkb_flags & DLM_IFL_ENDOFLIFE) {
+		log_debug(ls, "unlock on ENDOFLIFE %x", lkb->lkb_id);
+		rv = -ENOENT;
 		goto out;
+	}
 
-	if (!(args->flags & DLM_LKF_CANCEL) &&
-	    lkb->lkb_status != DLM_LKSTS_GRANTED)
-		goto out;
+	/* an lkb may be waiting for an rsb lookup to complete where the
+	   lookup was initiated by another lock */
+
+	if (args->flags & (DLM_LKF_CANCEL | DLM_LKF_FORCEUNLOCK)) {
+		if (!list_empty(&lkb->lkb_rsb_lookup)) {
+			log_debug(ls, "unlock on rsb_lookup %x", lkb->lkb_id);
+			list_del_init(&lkb->lkb_rsb_lookup);
+			queue_cast(lkb->lkb_resource, lkb,
+				   args->flags & DLM_LKF_CANCEL ?
+				   -DLM_ECANCEL : -DLM_EUNLOCK);
+			unhold_lkb(lkb); /* undoes create_lkb() */
+			rv = -EBUSY;
+			goto out;
+		}
+	}
+
+	/* cancel not allowed with another cancel/unlock in progress */
+
+	if (args->flags & DLM_LKF_CANCEL) {
+		if (lkb->lkb_exflags & DLM_LKF_CANCEL)
+			goto out;
+
+		if (is_overlap(lkb))
+			goto out;
+
+		if (lkb->lkb_flags & DLM_IFL_RESEND) {
+			lkb->lkb_flags |= DLM_IFL_OVERLAP_CANCEL;
+			rv = -EBUSY;
+			goto out;
+		}
+
+		switch (lkb->lkb_wait_type) {
+		case DLM_MSG_LOOKUP:
+		case DLM_MSG_REQUEST:
+			lkb->lkb_flags |= DLM_IFL_OVERLAP_CANCEL;
+			rv = -EBUSY;
+			goto out;
+		case DLM_MSG_UNLOCK:
+		case DLM_MSG_CANCEL:
+			goto out;
+		}
+		/* add_to_waiters() will set OVERLAP_CANCEL */
+		goto out_ok;
+	}
+
+	/* do we need to allow a force-unlock if there's a normal unlock
+	   already in progress?  in what conditions could the normal unlock
+	   fail such that we'd want to send a force-unlock to be sure? */
+
+	if (args->flags & DLM_LKF_FORCEUNLOCK) {
+		if (lkb->lkb_exflags & DLM_LKF_FORCEUNLOCK)
+			goto out;
+
+		if (is_overlap_unlock(lkb))
+			goto out;
 
+		if (lkb->lkb_flags & DLM_IFL_RESEND) {
+			lkb->lkb_flags |= DLM_IFL_OVERLAP_UNLOCK;
+			rv = -EBUSY;
+			goto out;
+		}
+
+		switch (lkb->lkb_wait_type) {
+		case DLM_MSG_LOOKUP:
+		case DLM_MSG_REQUEST:
+			lkb->lkb_flags |= DLM_IFL_OVERLAP_UNLOCK;
+			rv = -EBUSY;
+			goto out;
+		case DLM_MSG_UNLOCK:
+			goto out;
+		}
+		/* add_to_waiters() will set OVERLAP_UNLOCK */
+		goto out_ok;
+	}
+
+	/* normal unlock not allowed if there's any op in progress */
 	rv = -EBUSY;
-	if (lkb->lkb_wait_type)
+	if (lkb->lkb_wait_type || lkb->lkb_wait_count)
 		goto out;
 
  out_ok:
-	lkb->lkb_exflags = args->flags;
+	/* an overlapping op shouldn't blow away exflags from other op */
+	lkb->lkb_exflags |= args->flags;
 	lkb->lkb_sbflags = 0;
 	lkb->lkb_astparam = args->astparam;
-
 	rv = 0;
  out:
+	if (rv)
+		log_debug(ls, "validate_unlock_args %d %x %x %x %x %d %s", rv,
+			  lkb->lkb_id, lkb->lkb_flags, lkb->lkb_exflags,
+			  args->flags, lkb->lkb_wait_type,
+			  lkb->lkb_resource->res_name);
 	return rv;
 }
 
@@ -1759,17 +1991,19 @@ static int do_unlock(struct dlm_rsb *r, struct
dlm_lkb *lkb)
 	return -DLM_EUNLOCK;
 }
 
-/* FIXME: if revert_lock() finds that the lkb is granted, we should
-   skip the queue_cast(ECANCEL).  It indicates that the request/convert
-   completed (and queued a normal ast) just before the cancel; we don't
-   want to clobber the sb_result for the normal ast with ECANCEL. */
+/* returns: 0 did nothing, -DLM_ECANCEL canceled lock */
  
 static int do_cancel(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
-	revert_lock(r, lkb);
-	queue_cast(r, lkb, -DLM_ECANCEL);
-	grant_pending_locks(r);
-	return -DLM_ECANCEL;
+	int error;
+
+	error = revert_lock(r, lkb);
+	if (error) {
+		queue_cast(r, lkb, -DLM_ECANCEL);
+		grant_pending_locks(r);
+		return -DLM_ECANCEL;
+	}
+	return 0;
 }
 
 /*
@@ -2035,6 +2269,8 @@ int dlm_unlock(dlm_lockspace_t *lockspace,
 
 	if (error == -DLM_EUNLOCK || error == -DLM_ECANCEL)
 		error = 0;
+	if (error == -EBUSY && (flags & (DLM_LKF_CANCEL |
DLM_LKF_FORCEUNLOCK)))
+		error = 0;
  out_put:
 	dlm_put_lkb(lkb);
  out:
@@ -2176,7 +2412,9 @@ static int send_common(struct dlm_rsb *r, struct
dlm_lkb *lkb, int mstype)
 	struct dlm_mhandle *mh;
 	int to_nodeid, error;
 
-	add_to_waiters(lkb, mstype);
+	error = add_to_waiters(lkb, mstype);
+	if (error)
+		return error;
 
 	to_nodeid = r->res_nodeid;
 
@@ -2192,7 +2430,7 @@ static int send_common(struct dlm_rsb *r, struct
dlm_lkb *lkb, int mstype)
 	return 0;
 
  fail:
-	remove_from_waiters(lkb);
+	remove_from_waiters(lkb, msg_reply_type(mstype));
 	return error;
 }
 
@@ -2209,7 +2447,8 @@ static int send_convert(struct dlm_rsb *r, struct
dlm_lkb *lkb)
 
 	/* down conversions go without a reply from the master */
 	if (!error && down_conversion(lkb)) {
-		remove_from_waiters(lkb);
+		remove_from_waiters(lkb, DLM_MSG_CONVERT_REPLY);
+		r->res_ls->ls_stub_ms.m_type = DLM_MSG_CONVERT_REPLY;
 		r->res_ls->ls_stub_ms.m_result = 0;
 		r->res_ls->ls_stub_ms.m_flags = lkb->lkb_flags;
 		__receive_convert_reply(r, lkb, &r->res_ls->ls_stub_ms);
@@ -2280,7 +2519,9 @@ static int send_lookup(struct dlm_rsb *r, struct
dlm_lkb *lkb)
 	struct dlm_mhandle *mh;
 	int to_nodeid, error;
 
-	add_to_waiters(lkb, DLM_MSG_LOOKUP);
+	error = add_to_waiters(lkb, DLM_MSG_LOOKUP);
+	if (error)
+		return error;
 
 	to_nodeid = dlm_dir_nodeid(r);
 
@@ -2296,7 +2537,7 @@ static int send_lookup(struct dlm_rsb *r, struct
dlm_lkb *lkb)
 	return 0;
 
  fail:
-	remove_from_waiters(lkb);
+	remove_from_waiters(lkb, DLM_MSG_LOOKUP_REPLY);
 	return error;
 }
 
@@ -2740,7 +2981,7 @@ static void receive_request_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
-	int error, mstype;
+	int error, mstype, result;
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
 	if (error) {
@@ -2749,20 +2990,15 @@ static void receive_request_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 	}
 	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
-	mstype = lkb->lkb_wait_type;
-	error = remove_from_waiters(lkb);
-	if (error) {
-		log_error(ls, "receive_request_reply not on waiters");
-		goto out;
-	}
-
-	/* this is the value returned from do_request() on the master */
-	error = ms->m_result;
-
 	r = lkb->lkb_resource;
 	hold_rsb(r);
 	lock_rsb(r);
 
+	mstype = lkb->lkb_wait_type;
+	error = remove_from_waiters(lkb, DLM_MSG_REQUEST_REPLY);
+	if (error)
+		goto out;
+
 	/* Optimization: the dir node was also the master, so it took our
 	   lookup as a request and sent request reply instead of lookup reply
*/
 	if (mstype == DLM_MSG_LOOKUP) {
@@ -2770,14 +3006,15 @@ static void receive_request_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 		lkb->lkb_nodeid = r->res_nodeid;
 	}
 
-	switch (error) {
+	/* this is the value returned from do_request() on the master */
+	result = ms->m_result;
+
+	switch (result) {
 	case -EAGAIN:
-		/* request would block (be queued) on remote master;
-		   the unhold undoes the original ref from create_lkb()
-		   so it leads to the lkb being freed */
+		/* request would block (be queued) on remote master */
 		queue_cast(r, lkb, -EAGAIN);
 		confirm_master(r, -EAGAIN);
-		unhold_lkb(lkb);
+		unhold_lkb(lkb); /* undoes create_lkb() */
 		break;
 
 	case -EINPROGRESS:
@@ -2785,41 +3022,62 @@ static void receive_request_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 		/* request was queued or granted on remote master */
 		receive_flags_reply(lkb, ms);
 		lkb->lkb_remid = ms->m_lkid;
-		if (error)
+		if (result)
 			add_lkb(r, lkb, DLM_LKSTS_WAITING);
 		else {
 			grant_lock_pc(r, lkb, ms);
 			queue_cast(r, lkb, 0);
 		}
-		confirm_master(r, error);
+		confirm_master(r, result);
 		break;
 
 	case -EBADR:
 	case -ENOTBLK:
 		/* find_rsb failed to find rsb or rsb wasn't master */
+		log_debug(ls, "receive_request_reply %x %x master diff %d %d",
+			  lkb->lkb_id, lkb->lkb_flags, r->res_nodeid, result);
 		r->res_nodeid = -1;
 		lkb->lkb_nodeid = -1;
-		_request_lock(r, lkb);
+
+		if (is_overlap(lkb)) {
+			/* we'll ignore error in cancel/unlock reply */
+			queue_cast_overlap(r, lkb);
+			unhold_lkb(lkb); /* undoes create_lkb() */
+		} else
+			_request_lock(r, lkb);
 		break;
 
 	default:
-		log_error(ls, "receive_request_reply error %d", error);
+		log_error(ls, "receive_request_reply %x error %d",
+			  lkb->lkb_id, result);
 	}
 
+	if (is_overlap_unlock(lkb) && (result == 0 || result == -EINPROGRESS))
{
+		log_debug(ls, "receive_request_reply %x result %d unlock",
+			  lkb->lkb_id, result);
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
+		send_unlock(r, lkb);
+	} else if (is_overlap_cancel(lkb) && (result == -EINPROGRESS)) {
+		log_debug(ls, "receive_request_reply %x cancel", lkb->lkb_id);
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
+		send_cancel(r, lkb);
+	} else {
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
+	}
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
- out:
 	dlm_put_lkb(lkb);
 }
 
 static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb
*lkb,
 				    struct dlm_message *ms)
 {
-	int error = ms->m_result;
-
 	/* this is the value returned from do_convert() on the master */
-
-	switch (error) {
+	switch (ms->m_result) {
 	case -EAGAIN:
 		/* convert would block (be queued) on remote master */
 		queue_cast(r, lkb, -EAGAIN);
@@ -2839,19 +3097,26 @@ static void __receive_convert_reply(struct
dlm_rsb *r, struct dlm_lkb *lkb,
 		break;
 
 	default:
-		log_error(r->res_ls, "receive_convert_reply error %d", error);
+		log_error(r->res_ls, "receive_convert_reply %x error %d",
+			  lkb->lkb_id, ms->m_result);
 	}
 }
 
 static void _receive_convert_reply(struct dlm_lkb *lkb, struct
dlm_message *ms)
 {
 	struct dlm_rsb *r = lkb->lkb_resource;
+	int error;
 
 	hold_rsb(r);
 	lock_rsb(r);
 
-	__receive_convert_reply(r, lkb, ms);
+	/* stub reply can happen with waiters_mutex held */
+	error = remove_from_waiters_ms(lkb, ms);
+	if (error)
+		goto out;
 
+	__receive_convert_reply(r, lkb, ms);
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 }
@@ -2868,37 +3133,38 @@ static void receive_convert_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 	}
 	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
-	error = remove_from_waiters(lkb);
-	if (error) {
-		log_error(ls, "receive_convert_reply not on waiters");
-		goto out;
-	}
-
 	_receive_convert_reply(lkb, ms);
- out:
 	dlm_put_lkb(lkb);
 }
 
 static void _receive_unlock_reply(struct dlm_lkb *lkb, struct
dlm_message *ms)
 {
 	struct dlm_rsb *r = lkb->lkb_resource;
-	int error = ms->m_result;
+	int error;
 
 	hold_rsb(r);
 	lock_rsb(r);
 
+	/* stub reply can happen with waiters_mutex held */
+	error = remove_from_waiters_ms(lkb, ms);
+	if (error)
+		goto out;
+
 	/* this is the value returned from do_unlock() on the master */
 
-	switch (error) {
+	switch (ms->m_result) {
 	case -DLM_EUNLOCK:
 		receive_flags_reply(lkb, ms);
 		remove_lock_pc(r, lkb);
 		queue_cast(r, lkb, -DLM_EUNLOCK);
 		break;
+	case -ENOENT:
+		break;
 	default:
-		log_error(r->res_ls, "receive_unlock_reply error %d", error);
+		log_error(r->res_ls, "receive_unlock_reply %x error %d",
+			  lkb->lkb_id, ms->m_result);
 	}
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 }
@@ -2915,37 +3181,39 @@ static void receive_unlock_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 	}
 	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
-	error = remove_from_waiters(lkb);
-	if (error) {
-		log_error(ls, "receive_unlock_reply not on waiters");
-		goto out;
-	}
-
 	_receive_unlock_reply(lkb, ms);
- out:
 	dlm_put_lkb(lkb);
 }
 
 static void _receive_cancel_reply(struct dlm_lkb *lkb, struct
dlm_message *ms)
 {
 	struct dlm_rsb *r = lkb->lkb_resource;
-	int error = ms->m_result;
+	int error;
 
 	hold_rsb(r);
 	lock_rsb(r);
 
+	/* stub reply can happen with waiters_mutex held */
+	error = remove_from_waiters_ms(lkb, ms);
+	if (error)
+		goto out;
+
 	/* this is the value returned from do_cancel() on the master */
 
-	switch (error) {
+	switch (ms->m_result) {
 	case -DLM_ECANCEL:
 		receive_flags_reply(lkb, ms);
 		revert_lock_pc(r, lkb);
-		queue_cast(r, lkb, -DLM_ECANCEL);
+		if (ms->m_result)
+			queue_cast(r, lkb, -DLM_ECANCEL);
+		break;
+	case 0:
 		break;
 	default:
-		log_error(r->res_ls, "receive_cancel_reply error %d", error);
+		log_error(r->res_ls, "receive_cancel_reply %x error %d",
+			  lkb->lkb_id, ms->m_result);
 	}
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 }
@@ -2962,14 +3230,7 @@ static void receive_cancel_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 	}
 	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
-	error = remove_from_waiters(lkb);
-	if (error) {
-		log_error(ls, "receive_cancel_reply not on waiters");
-		goto out;
-	}
-
 	_receive_cancel_reply(lkb, ms);
- out:
 	dlm_put_lkb(lkb);
 }
 
@@ -2985,20 +3246,17 @@ static void receive_lookup_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 		return;
 	}
 
-	error = remove_from_waiters(lkb);
-	if (error) {
-		log_error(ls, "receive_lookup_reply not on waiters");
-		goto out;
-	}
-
-	/* this is the value returned by dlm_dir_lookup on dir node
+	/* ms->m_result is the value returned by dlm_dir_lookup on dir node
 	   FIXME: will a non-zero error ever be returned? */
-	error = ms->m_result;
 
 	r = lkb->lkb_resource;
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = remove_from_waiters(lkb, DLM_MSG_LOOKUP_REPLY);
+	if (error)
+		goto out;
+
 	ret_nodeid = ms->m_nodeid;
 	if (ret_nodeid == dlm_our_nodeid()) {
 		r->res_nodeid = 0;
@@ -3009,14 +3267,22 @@ static void receive_lookup_reply(struct dlm_ls
*ls, struct dlm_message *ms)
 		r->res_nodeid = ret_nodeid;
 	}
 
+	if (is_overlap(lkb)) {
+		log_debug(ls, "receive_lookup_reply %x unlock %x",
+			  lkb->lkb_id, lkb->lkb_flags);
+		queue_cast_overlap(r, lkb);
+		unhold_lkb(lkb); /* undoes create_lkb() */
+		goto out_list;
+	}
+
 	_request_lock(r, lkb);
 
+ out_list:
 	if (!ret_nodeid)
 		process_lookup_list(r);
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
- out:
 	dlm_put_lkb(lkb);
 }
 
@@ -3153,9 +3419,9 @@ static void recover_convert_waiter(struct dlm_ls
*ls, struct dlm_lkb *lkb)
 {
 	if (middle_conversion(lkb)) {
 		hold_lkb(lkb);
+		ls->ls_stub_ms.m_type = DLM_MSG_CONVERT_REPLY;
 		ls->ls_stub_ms.m_result = -EINPROGRESS;
 		ls->ls_stub_ms.m_flags = lkb->lkb_flags;
-		_remove_from_waiters(lkb);
 		_receive_convert_reply(lkb, &ls->ls_stub_ms);
 
 		/* Same special case as in receive_rcom_lock_args() */
@@ -3227,18 +3493,18 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 
 		case DLM_MSG_UNLOCK:
 			hold_lkb(lkb);
+			ls->ls_stub_ms.m_type = DLM_MSG_UNLOCK_REPLY;
 			ls->ls_stub_ms.m_result = -DLM_EUNLOCK;
 			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
-			_remove_from_waiters(lkb);
 			_receive_unlock_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
 			break;
 
 		case DLM_MSG_CANCEL:
 			hold_lkb(lkb);
+			ls->ls_stub_ms.m_type = DLM_MSG_CANCEL_REPLY;
 			ls->ls_stub_ms.m_result = -DLM_ECANCEL;
 			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
-			_remove_from_waiters(lkb);
 			_receive_cancel_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
 			break;
@@ -3252,37 +3518,47 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 	mutex_unlock(&ls->ls_waiters_mutex);
 }
 
-static int remove_resend_waiter(struct dlm_ls *ls, struct dlm_lkb
**lkb_ret)
+static struct dlm_lkb *find_resend_waiter(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb;
-	int rv = 0;
+	int found = 0;
 
 	mutex_lock(&ls->ls_waiters_mutex);
 	list_for_each_entry(lkb, &ls->ls_waiters, lkb_wait_reply) {
 		if (lkb->lkb_flags & DLM_IFL_RESEND) {
-			rv = lkb->lkb_wait_type;
-			_remove_from_waiters(lkb);
-			lkb->lkb_flags &= ~DLM_IFL_RESEND;
+			hold_lkb(lkb);
+			found = 1;
 			break;
 		}
 	}
 	mutex_unlock(&ls->ls_waiters_mutex);
 
-	if (!rv)
+	if (!found)
 		lkb = NULL;
-	*lkb_ret = lkb;
-	return rv;
+	return lkb;
 }
 
 /* Deal with lookups and lkb's marked RESEND from _pre.  We may now be
the
    master or dir-node for r.  Processing the lkb may result in it being
placed
    back on waiters. */
 
+/* We do this after normal locking has been enabled and any saved
messages
+   (in requestqueue) have been processed.  We should be confident that
at
+   this point we won't get or process a reply to any of these waiting
+   operations.  But, new ops may be coming in on the rsbs/locks here
from
+   userspace or remotely. */
+
+/* there may have been an overlap unlock/cancel prior to recovery or
after
+   recovery.  if before, the lkb may still have a pos wait_count; if
after, the
+   overlap flag would just have been set and nothing new sent.  we can
be
+   confident here than any replies to either the initial op or overlap
ops
+   prior to recovery have been received. */
+
 int dlm_recover_waiters_post(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
-	int error = 0, mstype;
+	int error = 0, mstype, err, oc, ou;
 
 	while (1) {
 		if (dlm_locking_stopped(ls)) {
@@ -3291,48 +3567,78 @@ int dlm_recover_waiters_post(struct dlm_ls *ls)
 			break;
 		}
 
-		mstype = remove_resend_waiter(ls, &lkb);
-		if (!mstype)
+		lkb = find_resend_waiter(ls);
+		if (!lkb)
 			break;
 
 		r = lkb->lkb_resource;
+		hold_rsb(r);
+		lock_rsb(r);
+
+		mstype = lkb->lkb_wait_type;
+		oc = is_overlap_cancel(lkb);
+		ou = is_overlap_unlock(lkb);
+		err = 0;
 
 		log_debug(ls, "recover_waiters_post %x type %d flags %x %s",
 			  lkb->lkb_id, mstype, lkb->lkb_flags, r->res_name);
 
-		switch (mstype) {
-
-		case DLM_MSG_LOOKUP:
-			hold_rsb(r);
-			lock_rsb(r);
-			_request_lock(r, lkb);
-			if (is_master(r))
-				confirm_master(r, 0);
-			unlock_rsb(r);
-			put_rsb(r);
-			break;
-
-		case DLM_MSG_REQUEST:
-			hold_rsb(r);
-			lock_rsb(r);
-			_request_lock(r, lkb);
-			if (is_master(r))
-				confirm_master(r, 0);
-			unlock_rsb(r);
-			put_rsb(r);
-			break;
-
-		case DLM_MSG_CONVERT:
-			hold_rsb(r);
-			lock_rsb(r);
-			_convert_lock(r, lkb);
-			unlock_rsb(r);
-			put_rsb(r);
-			break;
-
-		default:
-			log_error(ls, "recover_waiters_post type %d", mstype);
+		/* At this point we assume that we won't get a reply to any
+		   previous op or overlap op on this lock.  First, do a big
+		   remove_from_waiters() for all previous ops. */
+
+		lkb->lkb_flags &= ~DLM_IFL_RESEND;
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
+		lkb->lkb_wait_type = 0;
+		lkb->lkb_wait_count = 0;
+		mutex_lock(&ls->ls_waiters_mutex);
+		list_del_init(&lkb->lkb_wait_reply);
+		mutex_unlock(&ls->ls_waiters_mutex);
+		unhold_lkb(lkb); /* for waiters list */
+
+		if (oc || ou) {
+			/* do an unlock or cancel instead of resending */
+			switch (mstype) {
+			case DLM_MSG_LOOKUP:
+			case DLM_MSG_REQUEST:
+				queue_cast(r, lkb, ou ? -DLM_EUNLOCK :
+							-DLM_ECANCEL);
+				unhold_lkb(lkb); /* undoes create_lkb() */
+				break;
+			case DLM_MSG_CONVERT:
+				if (oc) {
+					queue_cast(r, lkb, -DLM_ECANCEL);
+				} else {
+					lkb->lkb_exflags |= DLM_LKF_FORCEUNLOCK;
+					_unlock_lock(r, lkb);
+				}
+				break;
+			default:
+				err = 1;
+			}
+		} else {
+			switch (mstype) {
+			case DLM_MSG_LOOKUP:
+			case DLM_MSG_REQUEST:
+				_request_lock(r, lkb);
+				if (is_master(r))
+					confirm_master(r, 0);
+				break;
+			case DLM_MSG_CONVERT:
+				_convert_lock(r, lkb);
+				break;
+			default:
+				err = 1;
+			}
 		}
+
+		if (err)
+			log_error(ls, "recover_waiters_post %x %d %x %d %d",
+			  	  lkb->lkb_id, mstype, lkb->lkb_flags, oc, ou);
+		unlock_rsb(r);
+		put_rsb(r);
+		dlm_put_lkb(lkb);
 	}
 
 	return error;
@@ -3684,7 +3990,7 @@ int dlm_user_request(struct dlm_ls *ls, struct
dlm_user_args *ua,
 
 	/* add this new lkb to the per-process list of locks */
 	spin_lock(&ua->proc->locks_spin);
-	kref_get(&lkb->lkb_ref);
+	hold_lkb(lkb);
 	list_add_tail(&lkb->lkb_ownqueue, &ua->proc->locks);
 	spin_unlock(&ua->proc->locks_spin);
  out:
@@ -3774,6 +4080,9 @@ int dlm_user_unlock(struct dlm_ls *ls, struct
dlm_user_args *ua_tmp,
 
 	if (error == -DLM_EUNLOCK)
 		error = 0;
+	/* from validate_unlock_args() */
+	if (error == -EBUSY && (flags & DLM_LKF_FORCEUNLOCK))
+		error = 0;
 	if (error)
 		goto out_put;
 
@@ -3786,6 +4095,7 @@ int dlm_user_unlock(struct dlm_ls *ls, struct
dlm_user_args *ua_tmp,
 	dlm_put_lkb(lkb);
  out:
 	unlock_recovery(ls);
+	kfree(ua_tmp);
 	return error;
 }
 
@@ -3815,33 +4125,37 @@ int dlm_user_cancel(struct dlm_ls *ls, struct
dlm_user_args *ua_tmp,
 
 	if (error == -DLM_ECANCEL)
 		error = 0;
-	if (error)
-		goto out_put;
-
-	/* this lkb was removed from the WAITING queue */
-	if (lkb->lkb_grmode == DLM_LOCK_IV) {
-		spin_lock(&ua->proc->locks_spin);
-		list_move(&lkb->lkb_ownqueue, &ua->proc->unlocking);
-		spin_unlock(&ua->proc->locks_spin);
-	}
+	/* from validate_unlock_args() */
+	if (error == -EBUSY)
+		error = 0;
  out_put:
 	dlm_put_lkb(lkb);
  out:
 	unlock_recovery(ls);
+	kfree(ua_tmp);
 	return error;
 }
 
+/* lkb's that are removed from the waiters list by revert are just left
on the
+   orphans list with the granted orphan locks, to be freed by purge */
+
 static int orphan_proc_lock(struct dlm_ls *ls, struct dlm_lkb *lkb)
 {
 	struct dlm_user_args *ua = (struct dlm_user_args *)lkb->lkb_astparam;
+	struct dlm_args args;
+	int error;
 
-	if (ua->lksb.sb_lvbptr)
-		kfree(ua->lksb.sb_lvbptr);
-	kfree(ua);
-	lkb->lkb_astparam = (long)NULL;
+	hold_lkb(lkb);
+	mutex_lock(&ls->ls_orphans_mutex);
+	list_add_tail(&lkb->lkb_ownqueue, &ls->ls_orphans);
+	mutex_unlock(&ls->ls_orphans_mutex);
 
-	/* TODO: propogate to master if needed */
-	return 0;
+	set_unlock_args(0, ua, &args);
+
+	error = cancel_lock(ls, lkb, &args);
+	if (error == -DLM_ECANCEL)
+		error = 0;
+	return error;
 }
 
 /* The force flag allows the unlock to go ahead even if the lkb isn't
granted.
@@ -3853,10 +4167,6 @@ static int unlock_proc_lock(struct dlm_ls *ls,
struct dlm_lkb *lkb)
 	struct dlm_args args;
 	int error;
 
-	/* FIXME: we need to handle the case where the lkb is in limbo
-	   while the rsb is being looked up, currently we assert in
-	   _unlock_lock/is_remote because rsb nodeid is -1. */
-
 	set_unlock_args(DLM_LKF_FORCEUNLOCK, ua, &args);
 
 	error = unlock_lock(ls, lkb, &args);
@@ -3865,6 +4175,31 @@ static int unlock_proc_lock(struct dlm_ls *ls,
struct dlm_lkb *lkb)
 	return error;
 }
 
+/* We have to release clear_proc_locks mutex before calling
unlock_proc_lock()
+   (which does lock_rsb) due to deadlock with receiving a message that
does
+   lock_rsb followed by dlm_user_add_ast() */
+
+static struct dlm_lkb *del_proc_lock(struct dlm_ls *ls,
+				     struct dlm_user_proc *proc)
+{
+	struct dlm_lkb *lkb = NULL;
+
+	mutex_lock(&ls->ls_clear_proc_locks);
+	if (list_empty(&proc->locks))
+		goto out;
+
+	lkb = list_entry(proc->locks.next, struct dlm_lkb, lkb_ownqueue);
+	list_del_init(&lkb->lkb_ownqueue);
+
+	if (lkb->lkb_exflags & DLM_LKF_PERSISTENT)
+		lkb->lkb_flags |= DLM_IFL_ORPHAN;
+	else
+		lkb->lkb_flags |= DLM_IFL_DEAD;
+ out:
+	mutex_unlock(&ls->ls_clear_proc_locks);
+	return lkb;
+}
+
 /* The ls_clear_proc_locks mutex protects against dlm_user_add_asts()
which
    1) references lkb->ua which we free here and 2) adds lkbs to
proc->asts,
    which we clear here. */
@@ -3880,18 +4215,15 @@ void dlm_clear_proc_locks(struct dlm_ls *ls,
struct dlm_user_proc *proc)
 	struct dlm_lkb *lkb, *safe;
 
 	lock_recovery(ls);
-	mutex_lock(&ls->ls_clear_proc_locks);
 
-	list_for_each_entry_safe(lkb, safe, &proc->locks, lkb_ownqueue) {
-		list_del_init(&lkb->lkb_ownqueue);
-
-		if (lkb->lkb_exflags & DLM_LKF_PERSISTENT) {
-			lkb->lkb_flags |= DLM_IFL_ORPHAN;
+	while (1) {
+		lkb = del_proc_lock(ls, proc);
+		if (!lkb)
+			break;
+		if (lkb->lkb_exflags & DLM_LKF_PERSISTENT)
 			orphan_proc_lock(ls, lkb);
-		} else {
-			lkb->lkb_flags |= DLM_IFL_DEAD;
+		else
 			unlock_proc_lock(ls, lkb);
-		}
 
 		/* this removes the reference for the proc->locks list
 		   added by dlm_user_request, it may result in the lkb
@@ -3900,6 +4232,8 @@ void dlm_clear_proc_locks(struct dlm_ls *ls,
struct dlm_user_proc *proc)
 		dlm_put_lkb(lkb);
 	}
 
+	mutex_lock(&ls->ls_clear_proc_locks);
+
 	/* in-progress unlocks */
 	list_for_each_entry_safe(lkb, safe, &proc->unlocking, lkb_ownqueue) {
 		list_del_init(&lkb->lkb_ownqueue);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index f40817b..f607ca2 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -2,7 +2,7 @@

*******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights
reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to
use,
 **  modify, copy, or redistribute it subject to the terms and
conditions
@@ -459,6 +459,8 @@ static int new_lockspace(char *name, int namelen,
void **lockspace,
 
 	INIT_LIST_HEAD(&ls->ls_waiters);
 	mutex_init(&ls->ls_waiters_mutex);
+	INIT_LIST_HEAD(&ls->ls_orphans);
+	mutex_init(&ls->ls_orphans_mutex);
 
 	INIT_LIST_HEAD(&ls->ls_nodes);
 	INIT_LIST_HEAD(&ls->ls_nodes_gone);
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 27a75ce..c978c67 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2006-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to
use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -128,35 +128,30 @@ static void compat_output(struct dlm_lock_result
*res,
 }
 #endif
 
+/* we could possibly check if the cancel of an orphan has resulted in
the lkb
+   being removed and then remove that lkb from the orphans list and
free it */
 
 void dlm_user_add_ast(struct dlm_lkb *lkb, int type)
 {
 	struct dlm_ls *ls;
 	struct dlm_user_args *ua;
 	struct dlm_user_proc *proc;
-	int remove_ownqueue = 0;
+	int eol = 0, ast_type;
 
-	/* dlm_clear_proc_locks() sets ORPHAN/DEAD flag on each
-	   lkb before dealing with it.  We need to check this
-	   flag before taking ls_clear_proc_locks mutex because if
-	   it's set, dlm_clear_proc_locks() holds the mutex. */
-
-	if (lkb->lkb_flags & (DLM_IFL_ORPHAN | DLM_IFL_DEAD)) {
-		/* log_print("user_add_ast skip1 %x", lkb->lkb_flags); */
+	if (lkb->lkb_flags & (DLM_IFL_ORPHAN | DLM_IFL_DEAD))
 		return;
-	}
 
 	ls = lkb->lkb_resource->res_ls;
 	mutex_lock(&ls->ls_clear_proc_locks);
 
 	/* If ORPHAN/DEAD flag is set, it means the process is dead so an ast
 	   can't be delivered.  For ORPHAN's, dlm_clear_proc_locks() freed
-	   lkb->ua so we can't try to use it. */
+	   lkb->ua so we can't try to use it.  This second check is necessary
+	   for cases where a completion ast is received for an operation that
+	   began before clear_proc_locks did its cancel/unlock. */
 
-	if (lkb->lkb_flags & (DLM_IFL_ORPHAN | DLM_IFL_DEAD)) {
-		/* log_print("user_add_ast skip2 %x", lkb->lkb_flags); */
+	if (lkb->lkb_flags & (DLM_IFL_ORPHAN | DLM_IFL_DEAD))
 		goto out;
-	}
 
 	DLM_ASSERT(lkb->lkb_astparam, dlm_print_lkb(lkb););
 	ua = (struct dlm_user_args *)lkb->lkb_astparam;
@@ -166,28 +161,42 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int
type)
 		goto out;
 
 	spin_lock(&proc->asts_spin);
-	if (!(lkb->lkb_ast_type & (AST_COMP | AST_BAST))) {
+
+	ast_type = lkb->lkb_ast_type;
+	lkb->lkb_ast_type |= type;
+
+	if (!ast_type) {
 		kref_get(&lkb->lkb_ref);
 		list_add_tail(&lkb->lkb_astqueue, &proc->asts);
-		lkb->lkb_ast_type |= type;
 		wake_up_interruptible(&proc->wait);
 	}
-
-	/* noqueue requests that fail may need to be removed from the
-	   proc's locks list, there should be a better way of detecting
-	   this situation than checking all these things... */
-
-	if (type == AST_COMP && lkb->lkb_grmode == DLM_LOCK_IV &&
-	    ua->lksb.sb_status == -EAGAIN && !list_empty(&lkb->lkb_ownqueue))
-		remove_ownqueue = 1;
-
-	/* unlocks or cancels of waiting requests need to be removed from the
-	   proc's unlocking list, again there must be a better way...  */
-
-	if (ua->lksb.sb_status == -DLM_EUNLOCK ||
+	if (type == AST_COMP && (ast_type & AST_COMP))
+		log_debug(ls, "ast overlap %x status %x %x",
+			  lkb->lkb_id, ua->lksb.sb_status, lkb->lkb_flags);
+
+	/* Figure out if this lock is at the end of its life and no longer
+	   available for the application to use.  The lkb still exists until
+	   the final ast is read.  A lock becomes EOL in three situations:
+	     1. a noqueue request fails with EAGAIN
+	     2. an unlock completes with EUNLOCK
+	     3. a cancel of a waiting request completes with ECANCEL
+	   An EOL lock needs to be removed from the process's list of locks.
+	   And we can't allow any new operation on an EOL lock.  This is
+	   not related to the lifetime of the lkb struct which is managed
+	   entirely by refcount. */
+
+	if (type == AST_COMP &&
+	    lkb->lkb_grmode == DLM_LOCK_IV &&
+	    ua->lksb.sb_status == -EAGAIN)
+		eol = 1;
+	else if (ua->lksb.sb_status == -DLM_EUNLOCK ||
 	    (ua->lksb.sb_status == -DLM_ECANCEL &&
 	     lkb->lkb_grmode == DLM_LOCK_IV))
-		remove_ownqueue = 1;
+		eol = 1;
+	if (eol) {
+		lkb->lkb_ast_type &= ~AST_BAST;
+		lkb->lkb_flags |= DLM_IFL_ENDOFLIFE;
+	}
 
 	/* We want to copy the lvb to userspace when the completion
 	   ast is read if the status is 0, the lock has an lvb and
@@ -204,11 +213,13 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int
type)
 
 	spin_unlock(&proc->asts_spin);
 
-	if (remove_ownqueue) {
+	if (eol) {
 		spin_lock(&ua->proc->locks_spin);
-		list_del_init(&lkb->lkb_ownqueue);
+		if (!list_empty(&lkb->lkb_ownqueue)) {
+			list_del_init(&lkb->lkb_ownqueue);
+			dlm_put_lkb(lkb);
+		}
 		spin_unlock(&ua->proc->locks_spin);
-		dlm_put_lkb(lkb);
 	}
  out:
 	mutex_unlock(&ls->ls_clear_proc_locks);
-- 
1.5.1.2



