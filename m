Return-Path: <linux-kernel-owner+w=401wt.eu-S2992438AbXDRNUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992438AbXDRNUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992442AbXDRNUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:20:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25573 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992438AbXDRNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:20:50 -0400
Date: Wed, 18 Apr 2007 15:19:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Brad Campbell <brad@wasp.net.au>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070418131943.GB3720@kernel.dk>
References: <4621FAF0.7000705@wasp.net.au> <46220339.9080205@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown> <20070418123757.GC3796@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418123757.GC3796@kernel.dk>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18 2007, Jens Axboe wrote:
> I had something similar for generic_unplug_request() as well, but didn't
> see/hear any reports of it being tried out. Here's a complete debugging
> patch for this and other potential dangers.

Which had a bug (do the check _after_ deleting from the rbtree,
otherwise it'll go rightfully BUG() the first time).

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6853fb7..9aa7bf7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -644,12 +644,15 @@ static void cfq_remove_request(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
+	BUG_ON(!irqs_disabled());
 	if (cfqq->next_rq == rq)
 		cfqq->next_rq = cfq_find_next_rq(cfqq->cfqd, cfqq, rq);
 
 	list_del_init(&rq->queuelist);
 	cfq_del_rq_rb(rq);
 
+	BUG_ON(!cfqq->next_rq && !RB_EMPTY_ROOT(&cfqq->sort_list));
+
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1231,6 +1234,8 @@ static void cfq_exit_single_io_context(struct cfq_io_context *cic)
 {
 	struct cfq_data *cfqd = cic->key;
 
+	BUG_ON(irqs_disabled());
+
 	if (cfqd) {
 		request_queue_t *q = cfqd->queue;
 
@@ -1699,6 +1704,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	/*
 	 * check if this request is a better next-serve candidate)) {
 	 */
+	BUG_ON(!irqs_disabled());
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
 	BUG_ON(!cfqq->next_rq);
 
@@ -2014,6 +2020,7 @@ static void cfq_exit_queue(elevator_t *e)
 
 	cfq_shutdown_timer_wq(cfqd);
 
+	BUG_ON(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3de0695..c16863e 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1602,6 +1602,8 @@ EXPORT_SYMBOL(__generic_unplug_device);
  **/
 void generic_unplug_device(request_queue_t *q)
 {
+	BUG_ON(irqs_disabled());
+
 	spin_lock_irq(q->queue_lock);
 	__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);

-- 
Jens Axboe

