Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbXGIQ2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbXGIQ2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbXGIQXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634AbXGIQXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:35 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] cancel in conversion deadlock [4/6]
Date: Mon,  9 Jul 2007 17:02:20 +0100
Message-Id: <11839970182635-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970162125-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

When conversion deadlock is detected, cancel the conversion and return
EDEADLK to the application.  This is a new default behavior where before
the dlm would allow the deadlock to exist indefinately.

The DLM_LKF_NODLCKWT flag can now be used in a conversion to prevent the
dlm from performing conversion deadlock detection/cancelation on it.
The DLM_LKF_CONVDEADLK flag can continue to be used as before to tell the
dlm to demote the granted mode of the lock being converted if it gets into
a conversion deadlock.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ad3797a..3c4d570 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1408,10 +1408,8 @@ static int queue_conflict(struct list_head *head, struct dlm_lkb *lkb)
  * queue for one resource.  The granted mode of each lock blocks the requested
  * mode of the other lock."
  *
- * Part 2: if the granted mode of lkb is preventing the first lkb in the
- * convert queue from being granted, then demote lkb (set grmode to NL).
- * This second form requires that we check for conv-deadlk even when
- * now == 0 in _can_be_granted().
+ * Part 2: if the granted mode of lkb is preventing an earlier lkb in the
+ * convert queue from being granted, then deadlk/demote lkb.
  *
  * Example:
  * Granted Queue: empty
@@ -1420,41 +1418,52 @@ static int queue_conflict(struct list_head *head, struct dlm_lkb *lkb)
  *
  * The first lock can't be granted because of the granted mode of the second
  * lock and the second lock can't be granted because it's not first in the
- * list.  We demote the granted mode of the second lock (the lkb passed to this
- * function).
+ * list.  We either cancel lkb's conversion (PR->EX) and return EDEADLK, or we
+ * demote the granted mode of lkb (from PR to NL) if it has the CONVDEADLK
+ * flag set and return DEMOTED in the lksb flags.
  *
- * After the resolution, the "grant pending" function needs to go back and try
- * to grant locks on the convert queue again since the first lock can now be
- * granted.
+ * Originally, this function detected conv-deadlk in a more limited scope:
+ * - if !modes_compat(lkb1, lkb2) && !modes_compat(lkb2, lkb1), or
+ * - if lkb1 was the first entry in the queue (not just earlier), and was
+ *   blocked by the granted mode of lkb2, and there was nothing on the
+ *   granted queue preventing lkb1 from being granted immediately, i.e.
+ *   lkb2 was the only thing preventing lkb1 from being granted.
+ *
+ * That second condition meant we'd only say there was conv-deadlk if
+ * resolving it (by demotion) would lead to the first lock on the convert
+ * queue being granted right away.  It allowed conversion deadlocks to exist
+ * between locks on the convert queue while they couldn't be granted anyway.
+ *
+ * Now, we detect and take action on conversion deadlocks immediately when
+ * they're created, even if they may not be immediately consequential.  If
+ * lkb1 exists anywhere in the convert queue and lkb2 comes in with a granted
+ * mode that would prevent lkb1's conversion from being granted, we do a
+ * deadlk/demote on lkb2 right away and don't let it onto the convert queue.
+ * I think this means that the lkb_is_ahead condition below should always
+ * be zero, i.e. there will never be conv-deadlk between two locks that are
+ * both already on the convert queue.
  */
 
-static int conversion_deadlock_detect(struct dlm_rsb *rsb, struct dlm_lkb *lkb)
+static int conversion_deadlock_detect(struct dlm_rsb *r, struct dlm_lkb *lkb2)
 {
-	struct dlm_lkb *this, *first = NULL, *self = NULL;
+	struct dlm_lkb *lkb1;
+	int lkb_is_ahead = 0;
 
-	list_for_each_entry(this, &rsb->res_convertqueue, lkb_statequeue) {
-		if (!first)
-			first = this;
-		if (this == lkb) {
-			self = lkb;
+	list_for_each_entry(lkb1, &r->res_convertqueue, lkb_statequeue) {
+		if (lkb1 == lkb2) {
+			lkb_is_ahead = 1;
 			continue;
 		}
 
-		if (!modes_compat(this, lkb) && !modes_compat(lkb, this))
-			return 1;
-	}
-
-	/* if lkb is on the convert queue and is preventing the first
-	   from being granted, then there's deadlock and we demote lkb.
-	   multiple converting locks may need to do this before the first
-	   converting lock can be granted. */
-
-	if (self && self != first) {
-		if (!modes_compat(lkb, first) &&
-		    !queue_conflict(&rsb->res_grantqueue, first))
-			return 1;
+		if (!lkb_is_ahead) {
+			if (!modes_compat(lkb2, lkb1))
+				return 1;
+		} else {
+			if (!modes_compat(lkb2, lkb1) &&
+			    !modes_compat(lkb1, lkb2))
+				return 1;
+		}
 	}
-
 	return 0;
 }
 
@@ -1583,42 +1592,57 @@ static int _can_be_granted(struct dlm_rsb *r, struct dlm_lkb *lkb, int now)
 	if (!now && !conv && list_empty(&r->res_convertqueue) &&
 	    first_in_list(lkb, &r->res_waitqueue))
 		return 1;
-
  out:
-	/*
-	 * The following, enabled by CONVDEADLK, departs from VMS.
-	 */
-
-	if (conv && (lkb->lkb_exflags & DLM_LKF_CONVDEADLK) &&
-	    conversion_deadlock_detect(r, lkb)) {
-		lkb->lkb_grmode = DLM_LOCK_NL;
-		lkb->lkb_sbflags |= DLM_SBF_DEMOTED;
-	}
-
 	return 0;
 }
 
-/*
- * The ALTPR and ALTCW flags aren't traditional lock manager flags, but are a
- * simple way to provide a big optimization to applications that can use them.
- */
-
-static int can_be_granted(struct dlm_rsb *r, struct dlm_lkb *lkb, int now)
+static int can_be_granted(struct dlm_rsb *r, struct dlm_lkb *lkb, int now,
+			  int *err)
 {
-	uint32_t flags = lkb->lkb_exflags;
 	int rv;
 	int8_t alt = 0, rqmode = lkb->lkb_rqmode;
+	int8_t is_convert = (lkb->lkb_grmode != DLM_LOCK_IV);
+
+	if (err)
+		*err = 0;
 
 	rv = _can_be_granted(r, lkb, now);
 	if (rv)
 		goto out;
 
-	if (lkb->lkb_sbflags & DLM_SBF_DEMOTED)
+	/*
+	 * The CONVDEADLK flag is non-standard and tells the dlm to resolve
+	 * conversion deadlocks by demoting grmode to NL, otherwise the dlm
+	 * cancels one of the locks.
+	 */
+
+	if (is_convert && can_be_queued(lkb) &&
+	    conversion_deadlock_detect(r, lkb)) {
+		if (lkb->lkb_exflags & DLM_LKF_CONVDEADLK) {
+			lkb->lkb_grmode = DLM_LOCK_NL;
+			lkb->lkb_sbflags |= DLM_SBF_DEMOTED;
+		} else if (!(lkb->lkb_exflags & DLM_LKF_NODLCKWT)) {
+			if (err)
+				*err = -EDEADLK;
+			else {
+				log_print("can_be_granted deadlock %x now %d",
+					  lkb->lkb_id, now);
+				dlm_dump_rsb(r);
+			}
+		}
 		goto out;
+	}
 
-	if (rqmode != DLM_LOCK_PR && flags & DLM_LKF_ALTPR)
+	/*
+	 * The ALTPR and ALTCW flags are non-standard and tell the dlm to try
+	 * to grant a request in a mode other than the normal rqmode.  It's a
+	 * simple way to provide a big optimization to applications that can
+	 * use them.
+	 */
+
+	if (rqmode != DLM_LOCK_PR && (lkb->lkb_exflags & DLM_LKF_ALTPR))
 		alt = DLM_LOCK_PR;
-	else if (rqmode != DLM_LOCK_CW && flags & DLM_LKF_ALTCW)
+	else if (rqmode != DLM_LOCK_CW && (lkb->lkb_exflags & DLM_LKF_ALTCW))
 		alt = DLM_LOCK_CW;
 
 	if (alt) {
@@ -1633,10 +1657,20 @@ static int can_be_granted(struct dlm_rsb *r, struct dlm_lkb *lkb, int now)
 	return rv;
 }
 
+/* FIXME: I don't think that can_be_granted() can/will demote or find deadlock
+   for locks pending on the convert list.  Once verified (watch for these
+   log_prints), we should be able to just call _can_be_granted() and not
+   bother with the demote/deadlk cases here (and there's no easy way to deal
+   with a deadlk here, we'd have to generate something like grant_lock with
+   the deadlk error.) */
+
+/* returns the highest requested mode of all blocked conversions */
+
 static int grant_pending_convert(struct dlm_rsb *r, int high)
 {
 	struct dlm_lkb *lkb, *s;
 	int hi, demoted, quit, grant_restart, demote_restart;
+	int deadlk;
 
 	quit = 0;
  restart:
@@ -1646,14 +1680,29 @@ static int grant_pending_convert(struct dlm_rsb *r, int high)
 
 	list_for_each_entry_safe(lkb, s, &r->res_convertqueue, lkb_statequeue) {
 		demoted = is_demoted(lkb);
-		if (can_be_granted(r, lkb, 0)) {
+		deadlk = 0;
+
+		if (can_be_granted(r, lkb, 0, &deadlk)) {
 			grant_lock_pending(r, lkb);
 			grant_restart = 1;
-		} else {
-			hi = max_t(int, lkb->lkb_rqmode, hi);
-			if (!demoted && is_demoted(lkb))
-				demote_restart = 1;
+			continue;
 		}
+
+		if (!demoted && is_demoted(lkb)) {
+			log_print("WARN: pending demoted %x node %d %s",
+				  lkb->lkb_id, lkb->lkb_nodeid, r->res_name);
+			demote_restart = 1;
+			continue;
+		}
+
+		if (deadlk) {
+			log_print("WARN: pending deadlock %x node %d %s",
+				  lkb->lkb_id, lkb->lkb_nodeid, r->res_name);
+			dlm_dump_rsb(r);
+			continue;
+		}
+
+		hi = max_t(int, lkb->lkb_rqmode, hi);
 	}
 
 	if (grant_restart)
@@ -1671,7 +1720,7 @@ static int grant_pending_wait(struct dlm_rsb *r, int high)
 	struct dlm_lkb *lkb, *s;
 
 	list_for_each_entry_safe(lkb, s, &r->res_waitqueue, lkb_statequeue) {
-		if (can_be_granted(r, lkb, 0))
+		if (can_be_granted(r, lkb, 0, NULL))
 			grant_lock_pending(r, lkb);
                 else
 			high = max_t(int, lkb->lkb_rqmode, high);
@@ -2121,7 +2170,7 @@ static int do_request(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	int error = 0;
 
-	if (can_be_granted(r, lkb, 1)) {
+	if (can_be_granted(r, lkb, 1, NULL)) {
 		grant_lock(r, lkb);
 		queue_cast(r, lkb, 0);
 		goto out;
@@ -2147,16 +2196,32 @@ static int do_request(struct dlm_rsb *r, struct dlm_lkb *lkb)
 static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	int error = 0;
+	int deadlk = 0;
 
 	/* changing an existing lock may allow others to be granted */
 
-	if (can_be_granted(r, lkb, 1)) {
+	if (can_be_granted(r, lkb, 1, &deadlk)) {
 		grant_lock(r, lkb);
 		queue_cast(r, lkb, 0);
 		grant_pending_locks(r);
 		goto out;
 	}
 
+	/* can_be_granted() detected that this lock would block in a conversion
+	   deadlock, so we leave it on the granted queue and return EDEADLK in
+	   the ast for the convert. */
+
+	if (deadlk) {
+		/* it's left on the granted queue */
+		log_debug(r->res_ls, "deadlock %x node %d sts%d g%d r%d %s",
+			  lkb->lkb_id, lkb->lkb_nodeid, lkb->lkb_status,
+			  lkb->lkb_grmode, lkb->lkb_rqmode, r->res_name);
+		revert_lock(r, lkb);
+		queue_cast(r, lkb, -EDEADLK);
+		error = -EDEADLK;
+		goto out;
+	}
+
 	/* is_demoted() means the can_be_granted() above set the grmode
 	   to NL, and left us on the granted queue.  This auto-demotion
 	   (due to CONVDEADLK) might mean other locks, and/or this lock, are
@@ -2438,7 +2503,7 @@ int dlm_lock(dlm_lockspace_t *lockspace,
  out_put:
 	if (convert || error)
 		__put_lkb(ls, lkb);
-	if (error == -EAGAIN)
+	if (error == -EAGAIN || error == -EDEADLK)
 		error = 0;
  out:
 	dlm_unlock_recovery(ls);
@@ -3312,6 +3377,12 @@ static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 		queue_cast(r, lkb, -EAGAIN);
 		break;
 
+	case -EDEADLK:
+		receive_flags_reply(lkb, ms);
+		revert_lock_pc(r, lkb);
+		queue_cast(r, lkb, -EDEADLK);
+		break;
+
 	case -EINPROGRESS:
 		/* convert was queued on remote master */
 		receive_flags_reply(lkb, ms);
@@ -4284,7 +4355,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 
 	error = convert_lock(ls, lkb, &args);
 
-	if (error == -EINPROGRESS || error == -EAGAIN)
+	if (error == -EINPROGRESS || error == -EAGAIN || error == -EDEADLK)
 		error = 0;
  out_put:
 	dlm_put_lkb(lkb);
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index 975f17d..5227a95 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -85,7 +85,11 @@
  * Only relevant to locks originating in userspace.  A persistent lock will not
  * be removed if the process holding the lock exits.
  *
- * DLM_LKF_NODLKWT
+ * DLM_LKF_NODLCKWT
+ *
+ * Do not cancel the lock if it gets into conversion deadlock.
+ * Exclude this lock from being monitored due to DLM_LSFL_TIMEWARN.
+ *
  * DLM_LKF_NODLCKBLK
  *
  * net yet implemented
-- 
1.5.1.2

