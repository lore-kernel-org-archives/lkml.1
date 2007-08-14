Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbXHNKOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbXHNKOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbXHNKKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbXHNKKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:47 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] fix basts for granted PR waiting CW
Date: Tue, 14 Aug 2007 10:47:10 +0100
Message-Id: <11870848521962-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Fix a long standing bug where a blocking callback would be missed
when there's a granted lock in PR mode and waiting locks in both
PR and CW modes (and the PR lock was added to the waiting queue
before the CW lock).  The logic simply compared the numerical values
of the modes to determine if a blocking callback was required, but in
the one case of PR and CW, the lower valued CW mode blocks the higher
valued PR mode.  We just need to add a special check for this PR/CW
case in the tests that decide when a blocking callback is needed.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index b455919..2082daf 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1670,9 +1670,10 @@ static int can_be_granted(struct dlm_rsb *r, struct dlm_lkb *lkb, int now,
    with a deadlk here, we'd have to generate something like grant_lock with
    the deadlk error.) */
 
-/* returns the highest requested mode of all blocked conversions */
+/* Returns the highest requested mode of all blocked conversions; sets
+   cw if there's a blocked conversion to DLM_LOCK_CW. */
 
-static int grant_pending_convert(struct dlm_rsb *r, int high)
+static int grant_pending_convert(struct dlm_rsb *r, int high, int *cw)
 {
 	struct dlm_lkb *lkb, *s;
 	int hi, demoted, quit, grant_restart, demote_restart;
@@ -1709,6 +1710,9 @@ static int grant_pending_convert(struct dlm_rsb *r, int high)
 		}
 
 		hi = max_t(int, lkb->lkb_rqmode, hi);
+
+		if (cw && lkb->lkb_rqmode == DLM_LOCK_CW)
+			*cw = 1;
 	}
 
 	if (grant_restart)
@@ -1721,29 +1725,52 @@ static int grant_pending_convert(struct dlm_rsb *r, int high)
 	return max_t(int, high, hi);
 }
 
-static int grant_pending_wait(struct dlm_rsb *r, int high)
+static int grant_pending_wait(struct dlm_rsb *r, int high, int *cw)
 {
 	struct dlm_lkb *lkb, *s;
 
 	list_for_each_entry_safe(lkb, s, &r->res_waitqueue, lkb_statequeue) {
 		if (can_be_granted(r, lkb, 0, NULL))
 			grant_lock_pending(r, lkb);
-                else
+                else {
 			high = max_t(int, lkb->lkb_rqmode, high);
+			if (lkb->lkb_rqmode == DLM_LOCK_CW)
+				*cw = 1;
+		}
 	}
 
 	return high;
 }
 
+/* cw of 1 means there's a lock with a rqmode of DLM_LOCK_CW that's blocked
+   on either the convert or waiting queue.
+   high is the largest rqmode of all locks blocked on the convert or
+   waiting queue. */
+
+static int lock_requires_bast(struct dlm_lkb *gr, int high, int cw)
+{
+	if (gr->lkb_grmode == DLM_LOCK_PR && cw) {
+		if (gr->lkb_highbast < DLM_LOCK_EX)
+			return 1;
+		return 0;
+	}
+
+	if (gr->lkb_highbast < high &&
+	    !__dlm_compat_matrix[gr->lkb_grmode+1][high+1])
+		return 1;
+	return 0;
+}
+
 static void grant_pending_locks(struct dlm_rsb *r)
 {
 	struct dlm_lkb *lkb, *s;
 	int high = DLM_LOCK_IV;
+	int cw = 0;
 
 	DLM_ASSERT(is_master(r), dlm_dump_rsb(r););
 
-	high = grant_pending_convert(r, high);
-	high = grant_pending_wait(r, high);
+	high = grant_pending_convert(r, high, &cw);
+	high = grant_pending_wait(r, high, &cw);
 
 	if (high == DLM_LOCK_IV)
 		return;
@@ -1751,27 +1778,41 @@ static void grant_pending_locks(struct dlm_rsb *r)
 	/*
 	 * If there are locks left on the wait/convert queue then send blocking
 	 * ASTs to granted locks based on the largest requested mode (high)
-	 * found above. FIXME: highbast < high comparison not valid for PR/CW.
+	 * found above.
 	 */
 
 	list_for_each_entry_safe(lkb, s, &r->res_grantqueue, lkb_statequeue) {
-		if (lkb->lkb_bastaddr && (lkb->lkb_highbast < high) &&
-		    !__dlm_compat_matrix[lkb->lkb_grmode+1][high+1]) {
-			queue_bast(r, lkb, high);
+		if (lkb->lkb_bastaddr && lock_requires_bast(lkb, high, cw)) {
+			if (cw && high == DLM_LOCK_PR)
+				queue_bast(r, lkb, DLM_LOCK_CW);
+			else
+				queue_bast(r, lkb, high);
 			lkb->lkb_highbast = high;
 		}
 	}
 }
 
+static int modes_require_bast(struct dlm_lkb *gr, struct dlm_lkb *rq)
+{
+	if ((gr->lkb_grmode == DLM_LOCK_PR && rq->lkb_rqmode == DLM_LOCK_CW) ||
+	    (gr->lkb_grmode == DLM_LOCK_CW && rq->lkb_rqmode == DLM_LOCK_PR)) {
+		if (gr->lkb_highbast < DLM_LOCK_EX)
+			return 1;
+		return 0;
+	}
+
+	if (gr->lkb_highbast < rq->lkb_rqmode && !modes_compat(gr, rq))
+		return 1;
+	return 0;
+}
+
 static void send_bast_queue(struct dlm_rsb *r, struct list_head *head,
 			    struct dlm_lkb *lkb)
 {
 	struct dlm_lkb *gr;
 
 	list_for_each_entry(gr, head, lkb_statequeue) {
-		if (gr->lkb_bastaddr &&
-		    gr->lkb_highbast < lkb->lkb_rqmode &&
-		    !modes_compat(gr, lkb)) {
+		if (gr->lkb_bastaddr && modes_require_bast(gr, lkb)) {
 			queue_bast(r, gr, lkb->lkb_rqmode);
 			gr->lkb_highbast = lkb->lkb_rqmode;
 		}
@@ -2235,7 +2276,7 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	   before we try again to grant this one. */
 
 	if (is_demoted(lkb)) {
-		grant_pending_convert(r, DLM_LOCK_IV);
+		grant_pending_convert(r, DLM_LOCK_IV, NULL);
 		if (_can_be_granted(r, lkb, 1)) {
 			grant_lock(r, lkb);
 			queue_cast(r, lkb, 0);
-- 
1.5.1.2

