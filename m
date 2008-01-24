Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYAXRFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYAXRFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYAXQ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbYAXQ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:39 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/19] dlm: reject normal unlock when lock is waiting for lookup
Date: Thu, 24 Jan 2008 10:50:37 -0600
Message-Id: <1201193442-8260-15-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-forced unlocks should be rejected if the lock is waiting on the
rsb_lookup list for another lock to establish the master node.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index c2890ef..fa68e9b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2110,17 +2110,18 @@ static int validate_unlock_args(struct dlm_lkb *lkb, struct dlm_args *args)
 	/* an lkb may be waiting for an rsb lookup to complete where the
 	   lookup was initiated by another lock */
 
-	if (args->flags & (DLM_LKF_CANCEL | DLM_LKF_FORCEUNLOCK)) {
-		if (!list_empty(&lkb->lkb_rsb_lookup)) {
+	if (!list_empty(&lkb->lkb_rsb_lookup)) {
+		if (args->flags & (DLM_LKF_CANCEL | DLM_LKF_FORCEUNLOCK)) {
 			log_debug(ls, "unlock on rsb_lookup %x", lkb->lkb_id);
 			list_del_init(&lkb->lkb_rsb_lookup);
 			queue_cast(lkb->lkb_resource, lkb,
 				   args->flags & DLM_LKF_CANCEL ?
 				   -DLM_ECANCEL : -DLM_EUNLOCK);
 			unhold_lkb(lkb); /* undoes create_lkb() */
-			rv = -EBUSY;
-			goto out;
 		}
+		/* caller changes -EBUSY to 0 for CANCEL and FORCEUNLOCK */
+		rv = -EBUSY;
+		goto out;
 	}
 
 	/* cancel not allowed with another cancel/unlock in progress */
-- 
1.5.3.3

