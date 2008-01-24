Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbYAXRDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbYAXRDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbYAXQ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278AbYAXQ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:39 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/19] dlm: validate messages before processing
Date: Thu, 24 Jan 2008 10:50:36 -0600
Message-Id: <1201193442-8260-14-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was some hit and miss validation of messages that has now been
cleaned up and unified.  Before processing a message, the new
validate_message() function checks that the lkb is the appropriate type,
process-copy or master-copy, and that the message is from the correct
nodeid for the the given lkb.  Other checks and assertions on the
lkb type and nodeid have been removed.  The assertions were particularly
bad since they would panic the machine instead of just ignoring the bad
message.

Although other recent patches have made processing old message unlikely,
it still may be possible for an old message to be processed and caught
by these checks.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |  139 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 104 insertions(+), 35 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index c3b9fca..c2890ef 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3008,8 +3008,6 @@ static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_bastaddr = (void *) (long) (ms->m_asts & AST_BAST);
 	lkb->lkb_astaddr = (void *) (long) (ms->m_asts & AST_COMP);
 
-	DLM_ASSERT(is_master_copy(lkb), dlm_print_lkb(lkb););
-
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
 		/* lkb was just created so there won't be an lvb yet */
 		lkb->lkb_lvbptr = dlm_allocate_lvb(ls);
@@ -3023,16 +3021,6 @@ static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 static int receive_convert_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				struct dlm_message *ms)
 {
-	if (lkb->lkb_nodeid != ms->m_header.h_nodeid) {
-		log_error(ls, "convert_args nodeid %d %d lkid %x %x",
-			  lkb->lkb_nodeid, ms->m_header.h_nodeid,
-			  lkb->lkb_id, lkb->lkb_remid);
-		return -EINVAL;
-	}
-
-	if (!is_master_copy(lkb))
-		return -EINVAL;
-
 	if (lkb->lkb_status != DLM_LKSTS_GRANTED)
 		return -EBUSY;
 
@@ -3048,8 +3036,6 @@ static int receive_convert_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 static int receive_unlock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 			       struct dlm_message *ms)
 {
-	if (!is_master_copy(lkb))
-		return -EINVAL;
 	if (receive_lvb(ls, lkb, ms))
 		return -ENOMEM;
 	return 0;
@@ -3065,6 +3051,50 @@ static void setup_stub_lkb(struct dlm_ls *ls, struct dlm_message *ms)
 	lkb->lkb_remid = ms->m_lkid;
 }
 
+/* This is called after the rsb is locked so that we can safely inspect
+   fields in the lkb. */
+
+static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
+{
+	int from = ms->m_header.h_nodeid;
+	int error = 0;
+
+	switch (ms->m_type) {
+	case DLM_MSG_CONVERT:
+	case DLM_MSG_UNLOCK:
+	case DLM_MSG_CANCEL:
+		if (!is_master_copy(lkb) || lkb->lkb_nodeid != from)
+			error = -EINVAL;
+		break;
+
+	case DLM_MSG_CONVERT_REPLY:
+	case DLM_MSG_UNLOCK_REPLY:
+	case DLM_MSG_CANCEL_REPLY:
+	case DLM_MSG_GRANT:
+	case DLM_MSG_BAST:
+		if (!is_process_copy(lkb) || lkb->lkb_nodeid != from)
+			error = -EINVAL;
+		break;
+
+	case DLM_MSG_REQUEST_REPLY:
+		if (!is_process_copy(lkb))
+			error = -EINVAL;
+		else if (lkb->lkb_nodeid != -1 && lkb->lkb_nodeid != from)
+			error = -EINVAL;
+		break;
+
+	default:
+		error = -EINVAL;
+	}
+
+	if (error)
+		log_error(lkb->lkb_resource->res_ls,
+			  "ignore invalid message %d from %d %x %x %x %d",
+			  ms->m_type, from, lkb->lkb_id, lkb->lkb_remid,
+			  lkb->lkb_flags, lkb->lkb_nodeid);
+	return error;
+}
+
 static void receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
@@ -3126,17 +3156,21 @@ static void receive_convert(struct dlm_ls *ls, struct dlm_message *ms)
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	receive_flags(lkb, ms);
 	error = receive_convert_args(ls, lkb, ms);
 	if (error)
-		goto out;
+		goto out_reply;
 	reply = !down_conversion(lkb);
 
 	error = do_convert(r, lkb);
- out:
+ out_reply:
 	if (reply)
 		send_convert_reply(r, lkb, error);
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
@@ -3162,15 +3196,19 @@ static void receive_unlock(struct dlm_ls *ls, struct dlm_message *ms)
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	receive_flags(lkb, ms);
 	error = receive_unlock_args(ls, lkb, ms);
 	if (error)
-		goto out;
+		goto out_reply;
 
 	error = do_unlock(r, lkb);
- out:
+ out_reply:
 	send_unlock_reply(r, lkb, error);
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
@@ -3198,9 +3236,13 @@ static void receive_cancel(struct dlm_ls *ls, struct dlm_message *ms)
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	error = do_cancel(r, lkb);
 	send_cancel_reply(r, lkb, error);
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
@@ -3219,22 +3261,26 @@ static void receive_grant(struct dlm_ls *ls, struct dlm_message *ms)
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
 	if (error) {
-		log_error(ls, "receive_grant no lkb");
+		log_debug(ls, "receive_grant from %d no lkb %x",
+			  ms->m_header.h_nodeid, ms->m_remid);
 		return;
 	}
-	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
 	r = lkb->lkb_resource;
 
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	receive_flags_reply(lkb, ms);
 	if (is_altmode(lkb))
 		munge_altmode(lkb, ms);
 	grant_lock_pc(r, lkb, ms);
 	queue_cast(r, lkb, 0);
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
@@ -3248,18 +3294,22 @@ static void receive_bast(struct dlm_ls *ls, struct dlm_message *ms)
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
 	if (error) {
-		log_error(ls, "receive_bast no lkb");
+		log_debug(ls, "receive_bast from %d no lkb %x",
+			  ms->m_header.h_nodeid, ms->m_remid);
 		return;
 	}
-	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
 	r = lkb->lkb_resource;
 
 	hold_rsb(r);
 	lock_rsb(r);
 
-	queue_bast(r, lkb, ms->m_bastmode);
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
 
+	queue_bast(r, lkb, ms->m_bastmode);
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
@@ -3325,15 +3375,19 @@ static void receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
 	if (error) {
-		log_error(ls, "receive_request_reply no lkb");
+		log_debug(ls, "receive_request_reply from %d no lkb %x",
+			  ms->m_header.h_nodeid, ms->m_remid);
 		return;
 	}
-	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
 	r = lkb->lkb_resource;
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	mstype = lkb->lkb_wait_type;
 	error = remove_from_waiters(lkb, DLM_MSG_REQUEST_REPLY);
 	if (error)
@@ -3466,6 +3520,10 @@ static void _receive_convert_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	/* stub reply can happen with waiters_mutex held */
 	error = remove_from_waiters_ms(lkb, ms);
 	if (error)
@@ -3484,10 +3542,10 @@ static void receive_convert_reply(struct dlm_ls *ls, struct dlm_message *ms)
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
 	if (error) {
-		log_error(ls, "receive_convert_reply no lkb");
+		log_debug(ls, "receive_convert_reply from %d no lkb %x",
+			  ms->m_header.h_nodeid, ms->m_remid);
 		return;
 	}
-	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
 	_receive_convert_reply(lkb, ms);
 	dlm_put_lkb(lkb);
@@ -3501,6 +3559,10 @@ static void _receive_unlock_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	/* stub reply can happen with waiters_mutex held */
 	error = remove_from_waiters_ms(lkb, ms);
 	if (error)
@@ -3532,10 +3594,10 @@ static void receive_unlock_reply(struct dlm_ls *ls, struct dlm_message *ms)
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
 	if (error) {
-		log_error(ls, "receive_unlock_reply no lkb");
+		log_debug(ls, "receive_unlock_reply from %d no lkb %x",
+			  ms->m_header.h_nodeid, ms->m_remid);
 		return;
 	}
-	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
 	_receive_unlock_reply(lkb, ms);
 	dlm_put_lkb(lkb);
@@ -3549,6 +3611,10 @@ static void _receive_cancel_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
 	hold_rsb(r);
 	lock_rsb(r);
 
+	error = validate_message(lkb, ms);
+	if (error)
+		goto out;
+
 	/* stub reply can happen with waiters_mutex held */
 	error = remove_from_waiters_ms(lkb, ms);
 	if (error)
@@ -3580,10 +3646,10 @@ static void receive_cancel_reply(struct dlm_ls *ls, struct dlm_message *ms)
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
 	if (error) {
-		log_error(ls, "receive_cancel_reply no lkb");
+		log_debug(ls, "receive_cancel_reply from %d no lkb %x",
+			  ms->m_header.h_nodeid, ms->m_remid);
 		return;
 	}
-	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
 	_receive_cancel_reply(lkb, ms);
 	dlm_put_lkb(lkb);
@@ -3816,6 +3882,7 @@ static void recover_convert_waiter(struct dlm_ls *ls, struct dlm_lkb *lkb)
 		ls->ls_stub_ms.m_type = DLM_MSG_CONVERT_REPLY;
 		ls->ls_stub_ms.m_result = -EINPROGRESS;
 		ls->ls_stub_ms.m_flags = lkb->lkb_flags;
+		ls->ls_stub_ms.m_header.h_nodeid = lkb->lkb_nodeid;
 		_receive_convert_reply(lkb, &ls->ls_stub_ms);
 
 		/* Same special case as in receive_rcom_lock_args() */
@@ -3917,6 +3984,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 			ls->ls_stub_ms.m_type = DLM_MSG_UNLOCK_REPLY;
 			ls->ls_stub_ms.m_result = stub_unlock_result;
 			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
+			ls->ls_stub_ms.m_header.h_nodeid = lkb->lkb_nodeid;
 			_receive_unlock_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
 			break;
@@ -3926,6 +3994,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 			ls->ls_stub_ms.m_type = DLM_MSG_CANCEL_REPLY;
 			ls->ls_stub_ms.m_result = stub_cancel_result;
 			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
+			ls->ls_stub_ms.m_header.h_nodeid = lkb->lkb_nodeid;
 			_receive_cancel_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
 			break;
-- 
1.5.3.3

