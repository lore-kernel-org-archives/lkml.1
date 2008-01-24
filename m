Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYAXRCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYAXRCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYAXQ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280AbYAXQ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:39 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/19] dlm: another call to confirm_master in receive_request_reply
Date: Thu, 24 Jan 2008 10:50:34 -0600
Message-Id: <1201193442-8260-12-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a failed request (EBADR or ENOTBLK) is unlocked/canceled instead of
retried, there may be other lkb's waiting on the rsb_lookup list for it
to complete.  A call to confirm_master() is needed to move on to the next
waiting lkb since the current one won't be retried.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index a758f1b..d5e8ea1 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1940,8 +1940,11 @@ static void confirm_master(struct dlm_rsb *r, int error)
 		break;
 
 	case -EAGAIN:
-		/* the remote master didn't queue our NOQUEUE request;
-		   make a waiting lkb the first_lkid */
+	case -EBADR:
+	case -ENOTBLK:
+		/* the remote request failed and won't be retried (it was
+		   a NOQUEUE, or has been canceled/unlocked); make a waiting
+		   lkb the first_lkid */
 
 		r->res_first_lkid = 0;
 
@@ -3382,6 +3385,7 @@ static void receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
 		if (is_overlap(lkb)) {
 			/* we'll ignore error in cancel/unlock reply */
 			queue_cast_overlap(r, lkb);
+			confirm_master(r, result);
 			unhold_lkb(lkb); /* undoes create_lkb() */
 		} else
 			_request_lock(r, lkb);
-- 
1.5.3.3

