Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYIPScy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYIPScy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYIPScp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:32:45 -0400
Received: from smtp02.zero.jp ([210.157.5.232]:36447 "EHLO smtp.zero.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729AbYIPSco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:32:44 -0400
X-Greylist: delayed 1048 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 14:32:44 EDT
X-Spam-Flag: NO
X-Spam-Score: 2.617
Date: Tue, 16 Sep 2008 14:12:48 -0400 (EDT)
Message-Id: <20080916.141248.74754047.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: bharrosh@panasas.com, agk@redhat.com,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 02/13] block: add request submission interface
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080916170219.GW20055@kernel.dk>
References: <48CD0D62.4020303@panasas.com>
	<20080916.120656.78704115.k-ueda@ct.jp.nec.com>
	<20080916170219.GW20055@kernel.dk>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Tue, 16 Sep 2008 19:02:20 +0200, Jens Axboe wrote:
> On Tue, Sep 16 2008, Kiyoshi Ueda wrote:
> > Hi Boaz, Jens,
> > 
> > On Sun, 14 Sep 2008 16:10:58 +0300, Boaz Harrosh wrote:
> > > Kiyoshi Ueda wrote:
> > > > This patch adds blk_submit_request(), a generic request submission
> > > > interface for request stacking drivers.
> > > > Request-based dm will use it to submit their clones to underlying
> > > > devices.
> > > > 
> > > > blk_rq_check_limits() is also added because it is possible that
> > > > the lower queue has stronger limitations than the upper queue
> > > > if multiple drivers are stacking at request-level.
> > > > Not only for blk_submit_request()'s internal use, the function
> > > > will be used by request-based dm when the queue limitation is
> > > > modified (e.g. by replacing dm's table).
> > > > 
> > > > 
> > > > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > > > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > > > Cc: Jens Axboe <jens.axboe@oracle.com>
> > > > ---
> > > >  block/blk-core.c       |   81 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  include/linux/blkdev.h |    2 +
> > > >  2 files changed, 83 insertions(+)
> > > > 
> > > > Index: 2.6.27-rc6/block/blk-core.c
> > > > ===================================================================
> > > > --- 2.6.27-rc6.orig/block/blk-core.c
> > > > +++ 2.6.27-rc6/block/blk-core.c
> > > > @@ -1517,6 +1517,87 @@ void submit_bio(int rw, struct bio *bio)
> > > >  EXPORT_SYMBOL(submit_bio);
> > > >  
> > > >  /**
> > > > + * blk_rq_check_limits - Helper function to check a request for the queue limit
> > > > + * @q:  the queue
> > > > + * @rq: the request being checked
> > > > + *
> > > > + * Description:
> > > > + *    @rq may have been made based on weaker limitations of upper-level queues
> > > > + *    in request stacking drivers, and it may violate the limitation of @q.
> > > > + *    Since the block layer and the underlying device driver trust @rq
> > > > + *    after it is inserted to @q, it should be checked against @q before
> > > > + *    the insertion using this generic function.
> > > > + *
> > > > + *    This function should also be useful for request stacking drivers
> > > > + *    in some cases below, so export this fuction.
> > > > + *    Request stacking drivers like request-based dm may change the queue
> > > > + *    limits while requests are in the queue (e.g. dm's table swapping).
> > > > + *    Such request stacking drivers should check those requests agaist
> > > > + *    the new queue limits again when they dispatch those requests,
> > > > + *    although such checkings are also done against the old queue limits
> > > > + *    when submitting requests.
> > > > + */
> > > > +int blk_rq_check_limits(struct request_queue *q, struct request *rq)
> > > > +{
> > > > +	if (rq->nr_sectors > q->max_sectors ||
> > > > +	    rq->data_len > q->max_hw_sectors << 9) {
> > > > +		printk(KERN_ERR "%s: over max size limit.\n", __func__);
> > > > +		return -EIO;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * queue's settings related to segment counting like q->bounce_pfn
> > > > +	 * may differ from that of other stacking queues.
> > > > +	 * Recalculate it to check the request correctly on this queue's
> > > > +	 * limitation.
> > > > +	 */
> > > > +	blk_recalc_rq_segments(rq);
> > > > +	if (rq->nr_phys_segments > q->max_phys_segments ||
> > > > +	    rq->nr_hw_segments > q->max_hw_segments) {
> > > > +		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
> > > > +		return -EIO;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(blk_rq_check_limits);
> > > > +
> > > > +/**
> > > > + * blk_submit_request - Helper for stacking drivers to submit a request
> > > > + * @q:  the queue to submit the request
> > > > + * @rq: the request being queued
> > > > + */
> > > > +int blk_submit_request(struct request_queue *q, struct request *rq)
> > > > +{
> > > > +	unsigned long flags;
> > > > +
> > > > +	if (blk_rq_check_limits(q, rq))
> > > > +		return -EIO;
> > > > +
> > > > +#ifdef CONFIG_FAIL_MAKE_REQUEST
> > > > +	if (rq->rq_disk && rq->rq_disk->flags & GENHD_FL_FAIL &&
> > > > +	    should_fail(&fail_make_request, blk_rq_bytes(rq)))
> > > > +		return -EIO;
> > > > +#endif
> > > > +
> > > > +	spin_lock_irqsave(q->queue_lock, flags);
> > > > +
> > > > +	/*
> > > > +	 * Submitting request must be dequeued before calling this function
> > > > +	 * because it will be linked to another request_queue
> > > > +	 */
> > > > +	BUG_ON(blk_queued_rq(rq));
> > > > +
> > > > +	drive_stat_acct(rq, 1);
> > > > +	__elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 0);
> > > > +
> > > > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(blk_submit_request);
> > > > +
> > > 
> > > This looks awfully similar to blk_execute_rq_nowait With an Added 
> > > blk_rq_check_limits, minus the __generic_unplug_device() and
> > > q->request_fn(q) calls. Perhaps the common code could be re factored
> > > out?
> > 
> > They might look simlar but don't have much in common actually.
> > I could refactor them like the attached patch, but I'm not sure
> > this is a correct way and this is cleaner than the current code.
> > (e.g. blk_execute_rq_nowait() can't be called with irqs-disabled,
> >  but blk_insert_request() and my blk_submit_request() can be called
> >  with irqs-disabled.)
> > 
> > So I'd leave them as it is unless you or others strongly prefer
> > the attached patch...
> > Anyway, I would like to leave the refactoring as a separate patch,
> > since it's not so straightforward.
> 
> If it wasn't for the _irq vs _irqsave, I would apply it. But I agree,
> your current approach is fine.

OK, I'll rebase my patches for for-2.6.28 of your block git and
repost the block bits.  Maybe I need a time to confirm whether
the diffrences between 2.6.27-rc6 and the block git affect my patches.
(Hopefully, I'd like to repost this week.)

Thanks,
Kiyoshi Ueda
