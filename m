Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZGIUta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZGIUta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZGIUtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:49:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbZGIUtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:49:22 -0400
Date: Thu, 9 Jul 2009 16:47:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Divyesh Shah <dpshah@google.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: cfq-iosched: no need to keep track of busy_rt_queues
Message-ID: <20090709204759.GF30832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Get rid of busy_rt_queues infrastructure. Looks like it is redundant.

o Once an RT queue gets request it will preempt any of the BE or IDLE queues
  immediately. Otherwise this queue will be put on service tree and scheduler
  will anyway select this queue before any of the BE or IDLE queue. Hence
  looks like there is no need to keep track of how many busy RT queues are
  currently on service tree. 

o I ran one RT reader and two BE readers. Can't see preemption due to
  busy_rt_queues kicking in.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   24 ------------------------
 1 file changed, 24 deletions(-)

Index: linux5/block/cfq-iosched.c
===================================================================
--- linux5.orig/block/cfq-iosched.c	2009-07-09 16:30:46.000000000 -0400
+++ linux5/block/cfq-iosched.c	2009-07-09 16:31:48.000000000 -0400
@@ -134,11 +134,6 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
-	/*
-	 * Used to track any pending rt requests so we can pre-empt current
-	 * non-RT cfqq in service when this value is non-zero.
-	 */
-	unsigned int busy_rt_queues;
 
 	int rq_in_driver;
 	int sync_flight;
@@ -648,9 +643,6 @@ static void cfq_add_cfqq_rr(struct cfq_d
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
-	if (cfq_class_rt(cfqq))
-		cfqd->busy_rt_queues++;
-
 	cfq_resort_rr_list(cfqd, cfqq);
 }
 
@@ -673,8 +665,6 @@ static void cfq_del_cfqq_rr(struct cfq_d
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
-	if (cfq_class_rt(cfqq))
-		cfqd->busy_rt_queues--;
 }
 
 /*
@@ -1179,20 +1169,6 @@ static struct cfq_queue *cfq_select_queu
 		goto expire;
 
 	/*
-	 * If we have a RT cfqq waiting, then we pre-empt the current non-rt
-	 * cfqq.
-	 */
-	if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues) {
-		/*
-		 * We simulate this as cfqq timed out so that it gets to bank
-		 * the remaining of its time slice.
-		 */
-		cfq_log_cfqq(cfqd, cfqq, "preempt");
-		cfq_slice_expired(cfqd, 1);
-		goto new_queue;
-	}
-
-	/*
 	 * The active queue has requests and isn't expired, allow it to
 	 * dispatch.
 	 */
