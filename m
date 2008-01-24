Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYAXRCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYAXRCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbYAXQ6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbYAXQ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:39 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] dlm: recover locks waiting for overlap replies
Date: Thu, 24 Jan 2008 10:50:33 -0600
Message-Id: <1201193442-8260-11-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When recovery looks at locks waiting for replies, it fails to consider
locks that have already received a reply for their first remote operation,
but not received a reply for secondary, overlapping unlock/cancel.  The
appropriate stub reply needs to be called for these waiters.

Appears when we start doing recovery in the presence of a many overlapping
unlock/cancel ops.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |   37 ++++++++++++++++++++++++++++++++-----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 43ca2a3..a758f1b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3846,6 +3846,7 @@ static int waiter_needs_recovery(struct dlm_ls *ls, struct dlm_lkb *lkb)
 void dlm_recover_waiters_pre(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb, *safe;
+	int wait_type, stub_unlock_result, stub_cancel_result;
 
 	mutex_lock(&ls->ls_waiters_mutex);
 
@@ -3864,7 +3865,33 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 		if (!waiter_needs_recovery(ls, lkb))
 			continue;
 
-		switch (lkb->lkb_wait_type) {
+		wait_type = lkb->lkb_wait_type;
+		stub_unlock_result = -DLM_EUNLOCK;
+		stub_cancel_result = -DLM_ECANCEL;
+
+		/* Main reply may have been received leaving a zero wait_type,
+		   but a reply for the overlapping op may not have been
+		   received.  In that case we need to fake the appropriate
+		   reply for the overlap op. */
+
+		if (!wait_type) {
+			if (is_overlap_cancel(lkb)) {
+				wait_type = DLM_MSG_CANCEL;
+				if (lkb->lkb_grmode == DLM_LOCK_IV)
+					stub_cancel_result = 0;
+			}
+			if (is_overlap_unlock(lkb)) {
+				wait_type = DLM_MSG_UNLOCK;
+				if (lkb->lkb_grmode == DLM_LOCK_IV)
+					stub_unlock_result = -ENOENT;
+			}
+
+			log_debug(ls, "rwpre overlap %x %x %d %d %d",
+				  lkb->lkb_id, lkb->lkb_flags, wait_type,
+				  stub_cancel_result, stub_unlock_result);
+		}
+
+		switch (wait_type) {
 
 		case DLM_MSG_REQUEST:
 			lkb->lkb_flags |= DLM_IFL_RESEND;
@@ -3877,7 +3904,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 		case DLM_MSG_UNLOCK:
 			hold_lkb(lkb);
 			ls->ls_stub_ms.m_type = DLM_MSG_UNLOCK_REPLY;
-			ls->ls_stub_ms.m_result = -DLM_EUNLOCK;
+			ls->ls_stub_ms.m_result = stub_unlock_result;
 			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
 			_receive_unlock_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
@@ -3886,15 +3913,15 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 		case DLM_MSG_CANCEL:
 			hold_lkb(lkb);
 			ls->ls_stub_ms.m_type = DLM_MSG_CANCEL_REPLY;
-			ls->ls_stub_ms.m_result = -DLM_ECANCEL;
+			ls->ls_stub_ms.m_result = stub_cancel_result;
 			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
 			_receive_cancel_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
 			break;
 
 		default:
-			log_error(ls, "invalid lkb wait_type %d",
-				  lkb->lkb_wait_type);
+			log_error(ls, "invalid lkb wait_type %d %d",
+				  lkb->lkb_wait_type, wait_type);
 		}
 		schedule();
 	}
-- 
1.5.3.3

