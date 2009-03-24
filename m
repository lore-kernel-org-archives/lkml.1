Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbZCXOUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbZCXOUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbZCXOLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:11:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760828AbZCXOLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:47 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] dlm: clear defunct cancel state
Date: Tue, 24 Mar 2009 09:07:50 -0500
Message-Id: <1237903672-18913-6-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a conversion completes successfully and finds that a cancel
of the convert is still in progress (which is now a moot point),
preemptively clear the state associated with outstanding cancel.
That state could cause a subsequent conversion to be ignored.

Also, improve the consistency and content of error and debug
messages in this area.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |   53 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 01e7d39..8cb9204 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -835,7 +835,7 @@ static int add_to_waiters(struct dlm_lkb *lkb, int mstype)
 		lkb->lkb_wait_count++;
 		hold_lkb(lkb);
 
-		log_debug(ls, "add overlap %x cur %d new %d count %d flags %x",
+		log_debug(ls, "addwait %x cur %d overlap %d count %d f %x",
 			  lkb->lkb_id, lkb->lkb_wait_type, mstype,
 			  lkb->lkb_wait_count, lkb->lkb_flags);
 		goto out;
@@ -851,7 +851,7 @@ static int add_to_waiters(struct dlm_lkb *lkb, int mstype)
 	list_add(&lkb->lkb_wait_reply, &ls->ls_waiters);
  out:
 	if (error)
-		log_error(ls, "add_to_waiters %x error %d flags %x %d %d %s",
+		log_error(ls, "addwait error %x %d flags %x %d %d %s",
 			  lkb->lkb_id, error, lkb->lkb_flags, mstype,
 			  lkb->lkb_wait_type, lkb->lkb_resource->res_name);
 	mutex_unlock(&ls->ls_waiters_mutex);
@@ -863,23 +863,55 @@ static int add_to_waiters(struct dlm_lkb *lkb, int mstype)
    request reply on the requestqueue) between dlm_recover_waiters_pre() which
    set RESEND and dlm_recover_waiters_post() */
 
-static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype)
+static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype,
+				struct dlm_message *ms)
 {
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 	int overlap_done = 0;
 
 	if (is_overlap_unlock(lkb) && (mstype == DLM_MSG_UNLOCK_REPLY)) {
+		log_debug(ls, "remwait %x unlock_reply overlap", lkb->lkb_id);
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
 		overlap_done = 1;
 		goto out_del;
 	}
 
 	if (is_overlap_cancel(lkb) && (mstype == DLM_MSG_CANCEL_REPLY)) {
+		log_debug(ls, "remwait %x cancel_reply overlap", lkb->lkb_id);
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
 		overlap_done = 1;
 		goto out_del;
 	}
 
+	/* Cancel state was preemptively cleared by a successful convert,
+	   see next comment, nothing to do. */
+
+	if ((mstype == DLM_MSG_CANCEL_REPLY) &&
+	    (lkb->lkb_wait_type != DLM_MSG_CANCEL)) {
+		log_debug(ls, "remwait %x cancel_reply wait_type %d",
+			  lkb->lkb_id, lkb->lkb_wait_type);
+		return -1;
+	}
+
+	/* Remove for the convert reply, and premptively remove for the
+	   cancel reply.  A convert has been granted while there's still
+	   an outstanding cancel on it (the cancel is moot and the result
+	   in the cancel reply should be 0).  We preempt the cancel reply
+	   because the app gets the convert result and then can follow up
+	   with another op, like convert.  This subsequent op would see the
+	   lingering state of the cancel and fail with -EBUSY. */
+
+	if ((mstype == DLM_MSG_CONVERT_REPLY) &&
+	    (lkb->lkb_wait_type == DLM_MSG_CONVERT) &&
+	    is_overlap_cancel(lkb) && ms && !ms->m_result) {
+		log_debug(ls, "remwait %x convert_reply zap overlap_cancel",
+			  lkb->lkb_id);
+		lkb->lkb_wait_type = 0;
+		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
+		lkb->lkb_wait_count--;
+		goto out_del;
+	}
+
 	/* N.B. type of reply may not always correspond to type of original
 	   msg due to lookup->request optimization, verify others? */
 
@@ -888,8 +920,8 @@ static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype)
 		goto out_del;
 	}
 
-	log_error(ls, "remove_from_waiters lkid %x flags %x types %d %d",
-		  lkb->lkb_id, lkb->lkb_flags, mstype, lkb->lkb_wait_type);
+	log_error(ls, "remwait error %x reply %d flags %x no wait_type",
+		  lkb->lkb_id, mstype, lkb->lkb_flags);
 	return -1;
 
  out_del:
@@ -899,7 +931,7 @@ static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype)
 	   this would happen */
 
 	if (overlap_done && lkb->lkb_wait_type) {
-		log_error(ls, "remove_from_waiters %x reply %d give up on %d",
+		log_error(ls, "remwait error %x reply %d wait_type %d overlap",
 			  lkb->lkb_id, mstype, lkb->lkb_wait_type);
 		lkb->lkb_wait_count--;
 		lkb->lkb_wait_type = 0;
@@ -921,7 +953,7 @@ static int remove_from_waiters(struct dlm_lkb *lkb, int mstype)
 	int error;
 
 	mutex_lock(&ls->ls_waiters_mutex);
-	error = _remove_from_waiters(lkb, mstype);
+	error = _remove_from_waiters(lkb, mstype, NULL);
 	mutex_unlock(&ls->ls_waiters_mutex);
 	return error;
 }
@@ -936,7 +968,7 @@ static int remove_from_waiters_ms(struct dlm_lkb *lkb, struct dlm_message *ms)
 
 	if (ms != &ls->ls_stub_ms)
 		mutex_lock(&ls->ls_waiters_mutex);
-	error = _remove_from_waiters(lkb, ms->m_type);
+	error = _remove_from_waiters(lkb, ms->m_type, ms);
 	if (ms != &ls->ls_stub_ms)
 		mutex_unlock(&ls->ls_waiters_mutex);
 	return error;
@@ -2083,6 +2115,11 @@ static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_timeout_cs = args->timeout;
 	rv = 0;
  out:
+	if (rv)
+		log_debug(ls, "validate_lock_args %d %x %x %x %d %d %s",
+			  rv, lkb->lkb_id, lkb->lkb_flags, args->flags,
+			  lkb->lkb_status, lkb->lkb_wait_type,
+			  lkb->lkb_resource->res_name);
 	return rv;
 }
 
-- 
1.5.5.6

