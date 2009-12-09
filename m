Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZLIPRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZLIPRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZLIPRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:17:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbZLIPRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:17:21 -0500
Date: Wed, 9 Dec 2009 10:17:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: jmoyer@redhat.com, linux-kernel@vger.kernel.org,
       guijianfeng@cn.fujitsu.com
Subject: Re: [PATCH 2/2] cfq-iosched: Take care of corner cases of group
	losing share due to deletion
Message-ID: <20091209151723.GA8452@redhat.com>
References: <1260312778-4725-1-git-send-email-vgoyal@redhat.com> <1260312778-4725-2-git-send-email-vgoyal@redhat.com> <20091209135639.GW8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209135639.GW8742@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 02:56:39PM +0100, Jens Axboe wrote:
> On Tue, Dec 08 2009, Vivek Goyal wrote:
> > If there is a sequential reader running in a group, we wait for next request
> > to come in that group after slice expiry and once new request is in, we expire
> > the queue. Otherwise we delete the group from service tree and group looses
> > its fair share.
> > 
> > So far I was marking a queue as wait_busy if it had consumed its slice and
> > it was last queue in the group. But this condition did not cover following
> > two cases.
> > 
> > 1.If a request completed and slice has not expired yet. Next request comes
> >   in and is dispatched to disk. Now select_queue() hits and slice has expired.
> >   This group will be deleted. Because request is still in the disk, this queue
> >   will never get a chance to wait_busy.
> > 
> > 2.If request completed and slice has not expired yet. Before next request
> >   comes in (delay due to think time), select_queue() hits and expires the
> >   queue hence group. This queue never got a chance to wait busy.
> > 
> > Gui was hitting the boundary condition 1 and not getting fairness numbers
> > proportional to weight.
> > 
> > This patch puts the checks for above two conditions and improves the fairness
> > numbers for sequential workload on rotational media. Check in select_queue()
> > takes care of case 1 and additional check in should_wait_busy() takes care
> > of case 2.
> 
> I think this (and 1/2) look fine, just one minor comment:
> 
> > @@ -3250,6 +3264,36 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
> >  		cfqd->hw_tag = 0;
> >  }
> >  
> > +static inline bool
> > +cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > +{
> 
> That's too large to inline.

Hi Jens,

Please find below the new version of patch. I have removed inline from
cfq_should_wait_busy().

Please let me know if you prefer a seprate posting in new mail thread.

Thanks
Vivek


DESC
cfq-iosched: Take care of corner cases of group losing share due to deletion
EDESC

If there is a sequential reader running in a group, we wait for next request
to come in that group after slice expiry and once new request is in, we expire
the queue. Otherwise we delete the group from service tree and group looses
its fair share.

So far I was marking a queue as wait_busy if it had consumed its slice and
it was last queue in the group. But this condition did not cover following
two cases.

1.If a request completed and slice has not expired yet. Next request comes
  in and is dispatched to disk. Now select_queue() hits and slice has expired.
  This group will be deleted. Because request is still in the disk, this queue
  will never get a chance to wait_busy.

2.If request completed and slice has not expired yet. Before next request
  comes in (delay due to think time), select_queue() hits and expires the
  queue hence group. This queue never got a chance to wait busy.

Gui was hitting the boundary condition 1 and not getting fairness numbers
proportional to weight.

This patch puts the checks for above two conditions and improves the fairness
numbers for sequential workload on rotational media. Check in select_queue()
takes care of case 1 and additional check in should_wait_busy() takes care
of case 2.

Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com> 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 6 deletions(-)

Index: linux2/block/cfq-iosched.c
===================================================================
--- linux2.orig/block/cfq-iosched.c	2009-12-08 17:44:32.000000000 -0500
+++ linux2/block/cfq-iosched.c	2009-12-09 09:54:08.000000000 -0500
@@ -2135,8 +2135,22 @@ static struct cfq_queue *cfq_select_queu
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
-	if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq))
-		goto expire;
+	if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq)) {
+		/*
+		 * If slice had not expired at the completion of last request
+		 * we might not have turned on wait_busy flag. Don't expire
+		 * the queue yet. Allow the group to get backlogged.
+		 *
+		 * The very fact that we have used the slice, that means we
+		 * have been idling all along on this queue and it should be
+		 * ok to wait for this request to complete.
+		 */
+		if (cfqq->cfqg->nr_cfqq == 1 && cfqq->dispatched
+		    && cfq_should_idle(cfqd, cfqq))
+			goto keep_queue;
+		else
+			goto expire;
+	}
 
 	/*
 	 * The active queue has requests and isn't expired, allow it to
@@ -3250,6 +3264,35 @@ static void cfq_update_hw_tag(struct cfq
 		cfqd->hw_tag = 0;
 }
 
+static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	struct cfq_io_context *cic = cfqd->active_cic;
+
+	/* If there are other queues in the group, don't wait */
+	if (cfqq->cfqg->nr_cfqq > 1)
+		return false;
+
+	if (cfq_slice_used(cfqq))
+		return true;
+
+	/* if slice left is less than think time, wait busy */
+	if (cic && sample_valid(cic->ttime_samples)
+	    && (cfqq->slice_end - jiffies < cic->ttime_mean))
+		return true;
+
+	/*
+	 * If think times is less than a jiffy than ttime_mean=0 and above
+	 * will not be true. It might happen that slice has not expired yet
+	 * but will expire soon (4-5 ns) during select_queue(). To cover the
+	 * case where think time is less than a jiffy, mark the queue wait
+	 * busy if only 1 jiffy is left in the slice.
+	 */
+	if (cfqq->slice_end - jiffies == 1)
+		return true;
+
+	return false;
+}
+
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -3288,11 +3331,10 @@ static void cfq_completed_request(struct
 		}
 
 		/*
-		 * If this queue consumed its slice and this is last queue
-		 * in the group, wait for next request before we expire
-		 * the queue
+		 * Should we wait for next request to come in before we expire
+		 * the queue.
 		 */
-		if (cfq_slice_used(cfqq) && cfqq->cfqg->nr_cfqq == 1) {
+		if (cfq_should_wait_busy(cfqd, cfqq)) {
 			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
 			cfq_mark_cfqq_wait_busy(cfqq);
 		}
