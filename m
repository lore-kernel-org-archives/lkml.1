Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZJWVPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZJWVPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZJWVPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZJWVOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:14:54 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jens.axboe@oracle.com
Cc: czoccolo@gmail.com, linux-kernel@vger.kernel.org,
       Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/4] cfq: change the meaning of the cfqq_coop flag
Date: Fri, 23 Oct 2009 17:14:51 -0400
Message-Id: <1256332492-24566-4-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flag used to indicate that a cfqq was allowed to jump ahead in the
scheduling order due to submitting a request close to the queue that
just executed.  Since closely cooperating queues are now merged, the flag
holds little meaning.  Change it to indicate that multiple queues were
merged.  This will later be used to allow the breaking up of merged queues
when they are no longer cooperating.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/cfq-iosched.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f0994ae..5e01a0a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -202,7 +202,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_prio_changed,	/* task priority has changed */
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
-	CFQ_CFQQ_FLAG_coop,		/* has done a coop jump of the queue */
+	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -950,11 +950,8 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
 					      struct cfq_queue *cfqq)
 {
-	if (!cfqq) {
+	if (!cfqq)
 		cfqq = cfq_get_next_queue(cfqd);
-		if (cfqq)
-			cfq_clear_cfqq_coop(cfqq);
-	}
 
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
@@ -1035,8 +1032,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
  * assumption.
  */
 static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
-					      struct cfq_queue *cur_cfqq,
-					      bool probe)
+					      struct cfq_queue *cur_cfqq)
 {
 	struct cfq_queue *cfqq;
 
@@ -1055,11 +1051,6 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	if (!cfq_cfqq_sync(cfqq))
 		return NULL;
 
-	if (cfq_cfqq_coop(cfqq))
-		return NULL;
-
-	if (!probe)
-		cfq_mark_cfqq_coop(cfqq);
 	return cfqq;
 }
 
@@ -1243,7 +1234,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 * cooperators and put the close queue at the front of the service
 	 * tree.  If possible, merge the expiring queue with the new cfqq.
 	 */
-	new_cfqq = cfq_close_cooperator(cfqd, cfqq, 0);
+	new_cfqq = cfq_close_cooperator(cfqd, cfqq);
 	if (new_cfqq) {
 		if (!cfqq->new_cfqq)
 			cfq_setup_merge(cfqq, new_cfqq);
@@ -2294,7 +2285,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
-		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
+		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq) &&
 			 sync && !rq_noidle(rq))
 			cfq_arm_slice_timer(cfqd);
 	}
@@ -2395,6 +2386,7 @@ cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
 {
 	cfq_log_cfqq(cfqd, cfqq, "merging with queue %p", cfqq->new_cfqq);
 	cic_set_cfqq(cic, cfqq->new_cfqq, 1);
+	cfq_mark_cfqq_coop(cfqq->new_cfqq);
 	cfq_put_queue(cfqq);
 	return cic_to_cfqq(cic, 1);
 }
-- 
1.6.2.5

