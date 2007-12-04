Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXLDVlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXLDVlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXLDVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:40:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbXLDVkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:40:46 -0500
Date: Tue, 04 Dec 2007 16:38:52 -0500 (EST)
Message-Id: <20071204.163852.59650214.k-ueda@ct.jp.nec.com>
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 01/28] blk_end_request: add new request completion
 interface (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <47555C90.2080609@panasas.com>
References: <20071130.182422.18574732.k-ueda@ct.jp.nec.com>
	<47555C90.2080609@panasas.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz,

On Tue, 04 Dec 2007 15:56:32 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> > +{
> > +	struct request_queue *q = rq->q;
> > +	unsigned long flags = 0UL;
> > +
> > +	if (blk_fs_request(rq) || blk_pc_request(rq)) {
> > +		if (__end_that_request_first(rq, uptodate, nr_bytes))
> > +			return 1;
> > +	}
> > +
> > +	add_disk_randomness(rq->rq_disk);
> > +
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +	complete_request(rq, uptodate);
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(blk_end_request);
> > +
> > +/**
> > + * __blk_end_request - Helper function for drivers to complete the request.
> > + *
> > + * Description:
> > + *     Must be called with queue lock held unlike blk_end_request().
> > + **/
> > +int __blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> > +{
> > +	if (blk_fs_request(rq) || blk_pc_request(rq)) {
> > +		if (__end_that_request_first(rq, uptodate, nr_bytes))
> > +			return 1;
> > +	}
> > +
> > +	add_disk_randomness(rq->rq_disk);
> > +
> > +	complete_request(rq, uptodate);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(__blk_end_request);
> 
> I don't like it that you have two Identical but slightly different
> implementations  I wish you would do an internal-with-flags
> implementation and then API ones can call the internal one. Or maybe
> just hold the spin_lock just a bit longer and have one call the other.
> To prove my case see how hard it is to add new code like with
> the bidi patch, where you need to add exact same code in 3 places.
> (OK only 2 places actually, if _callback is gone)

As for the internal-with-flags implementation, I once proposed
something like below but it was rejected by Jens.
(http://marc.info/?l=linux-kernel&m=118880584720600&w=2)
----------------------------------------------------------------------
static int internal_function(rq, needlock)
{
	end_that_request_chunk(rq);

	if (needlock)
		spin_lock_irqsave();
	end_that_request_last(rq);
	if (needlock)
		spin_unlock_irqrestore();
}

int blk_end_request(rq)
{
	return internal_function(rq, 1);
}

int __blk_end_request(rq)
{
	return internal_function(rq, 0);
}
----------------------------------------------------------------------


As for the holding-queue-lock-longer implementation,
end_that_request_chunk() completes bios in the request and it can
reaches filesystem layer and may take time.
I guess many drivers like scsi are calling end_that_request_chunk()
without queue's lock because of the reason above.

I'll try to remove the duplication again by another patch-set
after blk_end_request interfaces are merged.
So I would like to leave the duplication for now.
Is it acceptable for you?

Thanks,
Kiyoshi Ueda
