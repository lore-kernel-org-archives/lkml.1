Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYG3L1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYG3L1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYG3L1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:27:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYG3L1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:27:02 -0400
Subject: [PATCH] lockdep: change scheduler annotation
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080729.214503.126934382.davem@davemloft.net>
References: <20080728.161318.38361710.davem@davemloft.net>
	 <20080728235133.GA7956@elte.hu>
	 <20080728.174415.154327359.davem@davemloft.net>
	 <20080729.214503.126934382.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 13:26:57 +0200
Message-Id: <1217417217.8157.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While thinking about David's patch it _finally_ dawned on me that there
is no reason we have a lock class per cpu..

Sorry for being dense :-/

The below changes the annotation from a lock class per cpu, to a single
nested lock, as the scheduler never holds more that 2 rq locks at a time
anyway.

If there was code requiring holding all rq locks this would not work and
the original annotation would be the only option, but that not being the
case, this is a much lighter one.

Compiles and boots on a 2-way x86_64.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -600,7 +600,6 @@ struct rq {
 	/* BKL stats */
 	unsigned int bkl_count;
 #endif
-	struct lock_class_key rq_lock_key;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -2759,10 +2758,10 @@ static void double_rq_lock(struct rq *rq
 	} else {
 		if (rq1 < rq2) {
 			spin_lock(&rq1->lock);
-			spin_lock(&rq2->lock);
+			spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
 		} else {
 			spin_lock(&rq2->lock);
-			spin_lock(&rq1->lock);
+			spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
 	update_rq_clock(rq1);
@@ -2805,10 +2804,10 @@ static int double_lock_balance(struct rq
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
 			spin_lock(&busiest->lock);
-			spin_lock(&this_rq->lock);
+			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
 			ret = 1;
 		} else
-			spin_lock(&busiest->lock);
+			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
 	}
 	return ret;
 }
@@ -8000,7 +7999,6 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
-		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);


