Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbZKXNNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbZKXNNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbZKXNNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:13:41 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:45940 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbZKXNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:13:40 -0500
Subject: [PATCH 1/1] Correct sorting problem in cfq_service_tree_add
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1259068293.3019.15.camel@cail>
References: <1259068293.3019.15.camel@cail>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 08:13:45 -0500
Message-ID: <1259068425.3019.19.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort order was being incorrectly calculated using just the class, this
patch includes the priority within the classes when deciding sort order.

Note: IOPRIO_CLASS_NONE classes are converted to IOPRIO_CLASS_BE before
getting to this function, hence the WARN_ON in the added function
cfq_class_prio.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index aa1e953..7b9ca4d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -226,6 +226,12 @@ CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(coop_preempt);
 #undef CFQ_CFQQ_FNS
 
+static inline int cfq_class_prio(struct cfq_queue *cfqq)
+{
+	WARN_ON(cfqq->ioprio_class == IOPRIO_CLASS_NONE);
+	return IOPRIO_PRIO_VALUE(cfqq->ioprio_class, cfqq->ioprio);
+}
+
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
 #define cfq_log(cfqd, fmt, args...)	\
@@ -536,30 +542,29 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	p = &cfqd->service_tree.rb.rb_node;
 	while (*p) {
 		struct rb_node **n;
+		int cfqq_prio, __cfqq_prio;
 
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
+		cfqq_prio = cfq_class_prio(cfqq);
+		__cfqq_prio = cfq_class_prio(__cfqq);
+
 		/*
 		 * sort RT queues first, we always want to give
 		 * preference to them. IDLE queues goes to the back.
 		 * after that, sort on the next service time.
+		 * (Lower priority values represent higher priorities.)
 		 */
-		if (cfq_class_rt(cfqq) > cfq_class_rt(__cfqq))
+		if (cfqq_prio < __cfqq_prio)
 			n = &(*p)->rb_left;
-		else if (cfq_class_rt(cfqq) < cfq_class_rt(__cfqq))
-			n = &(*p)->rb_right;
-		else if (cfq_class_idle(cfqq) < cfq_class_idle(__cfqq))
+		else if (cfqq_prio == __cfqq_prio &&
+			 time_before(rb_key, __cfqq->rb_key))
 			n = &(*p)->rb_left;
-		else if (cfq_class_idle(cfqq) > cfq_class_idle(__cfqq))
-			n = &(*p)->rb_right;
-		else if (time_before(rb_key, __cfqq->rb_key))
-			n = &(*p)->rb_left;
-		else
+		else {
 			n = &(*p)->rb_right;
-
-		if (n == &(*p)->rb_right)
 			left = 0;
+		}
 
 		p = n;
 	}
-- 
1.6.3.3



