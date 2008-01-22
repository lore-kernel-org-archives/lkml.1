Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYAVJ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYAVJ4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758223AbYAVJyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:54:37 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8789 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbYAVJy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:54:29 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: knikanth@novell.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/6] io_context sharing - anticipatory changes
Date: Tue, 22 Jan 2008 10:49:20 +0100
Message-Id: <1200995361-24001-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.rc2.84.gf85fd
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes to anticipatory io scheduler for io_context sharing

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/as-iosched.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index cb5e53b..b201d16 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -170,9 +170,11 @@ static void free_as_io_context(struct as_io_context *aic)
 
 static void as_trim(struct io_context *ioc)
 {
+	spin_lock(&ioc->lock);
 	if (ioc->aic)
 		free_as_io_context(ioc->aic);
 	ioc->aic = NULL;
+	spin_unlock(&ioc->lock);
 }
 
 /* Called when the task exits */
@@ -462,7 +464,9 @@ static void as_antic_timeout(unsigned long data)
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (ad->antic_status == ANTIC_WAIT_REQ
 			|| ad->antic_status == ANTIC_WAIT_NEXT) {
-		struct as_io_context *aic = ad->io_context->aic;
+		struct as_io_context *aic;
+		spin_lock(&ad->io_context->lock);
+		aic = ad->io_context->aic;
 
 		ad->antic_status = ANTIC_FINISHED;
 		kblockd_schedule_work(&ad->antic_work);
@@ -475,6 +479,7 @@ static void as_antic_timeout(unsigned long data)
 			/* process not "saved" by a cooperating request */
 			ad->exit_no_coop = (7*ad->exit_no_coop + 256)/8;
 		}
+		spin_unlock(&ad->io_context->lock);
 	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
@@ -635,9 +640,11 @@ static int as_can_break_anticipation(struct as_data *ad, struct request *rq)
 
 	ioc = ad->io_context;
 	BUG_ON(!ioc);
+	spin_lock(&ioc->lock);
 
 	if (rq && ioc == RQ_IOC(rq)) {
 		/* request from same process */
+		spin_unlock(&ioc->lock);
 		return 1;
 	}
 
@@ -646,20 +653,25 @@ static int as_can_break_anticipation(struct as_data *ad, struct request *rq)
 		 * In this situation status should really be FINISHED,
 		 * however the timer hasn't had the chance to run yet.
 		 */
+		spin_unlock(&ioc->lock);
 		return 1;
 	}
 
 	aic = ioc->aic;
-	if (!aic)
+	if (!aic) {
+		spin_unlock(&ioc->lock);
 		return 0;
+	}
 
 	if (atomic_read(&aic->nr_queued) > 0) {
 		/* process has more requests queued */
+		spin_unlock(&ioc->lock);
 		return 1;
 	}
 
 	if (atomic_read(&aic->nr_dispatched) > 0) {
 		/* process has more requests dispatched */
+		spin_unlock(&ioc->lock);
 		return 1;
 	}
 
@@ -680,6 +692,7 @@ static int as_can_break_anticipation(struct as_data *ad, struct request *rq)
 		}
 
 		as_update_iohist(ad, aic, rq);
+		spin_unlock(&ioc->lock);
 		return 1;
 	}
 
@@ -688,20 +701,27 @@ static int as_can_break_anticipation(struct as_data *ad, struct request *rq)
 		if (aic->ttime_samples == 0)
 			ad->exit_prob = (7*ad->exit_prob + 256)/8;
 
-		if (ad->exit_no_coop > 128)
+		if (ad->exit_no_coop > 128) {
+			spin_unlock(&ioc->lock);
 			return 1;
+		}
 	}
 
 	if (aic->ttime_samples == 0) {
-		if (ad->new_ttime_mean > ad->antic_expire)
+		if (ad->new_ttime_mean > ad->antic_expire) {
+			spin_unlock(&ioc->lock);
 			return 1;
-		if (ad->exit_prob * ad->exit_no_coop > 128*256)
+		}
+		if (ad->exit_prob * ad->exit_no_coop > 128*256) {
+			spin_unlock(&ioc->lock);
 			return 1;
+		}
 	} else if (aic->ttime_mean > ad->antic_expire) {
 		/* the process thinks too much between requests */
+		spin_unlock(&ioc->lock);
 		return 1;
 	}
-
+	spin_unlock(&ioc->lock);
 	return 0;
 }
 
@@ -1255,7 +1275,9 @@ static void as_merged_requests(struct request_queue *q, struct request *req,
 			 * Don't copy here but swap, because when anext is
 			 * removed below, it must contain the unused context
 			 */
+			double_spin_lock(&rioc->lock, &nioc->lock, rioc < nioc);
 			swap_io_context(&rioc, &nioc);
+			double_spin_unlock(&rioc->lock, &nioc->lock, rioc < nioc);
 		}
 	}
 
-- 
1.5.4.rc2.84.gf85fd

