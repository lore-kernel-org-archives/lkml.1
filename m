Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZEWUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZEWUEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEWUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:04:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42449 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbZEWUEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:04:25 -0400
Date: Sat, 23 May 2009 22:04:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 02/18] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090523200425.GY11363@kernel.dk>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-3-git-send-email-vgoyal@redhat.com> <4A164978.1020604@cn.fujitsu.com> <20090522123231.GA14972@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522123231.GA14972@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22 2009, Vivek Goyal wrote:
> On Fri, May 22, 2009 at 02:43:04PM +0800, Gui Jianfeng wrote:
> > Vivek Goyal wrote:
> > ...
> > > +/* A request got completed from io_queue. Do the accounting. */
> > > +void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
> > > +{
> > > +	const int sync = rq_is_sync(rq);
> > > +	struct io_queue *ioq = rq->ioq;
> > > +	struct elv_fq_data *efqd = &q->elevator->efqd;
> > > +
> > > +	if (!elv_iosched_fair_queuing_enabled(q->elevator))
> > > +		return;
> > > +
> > > +	elv_log_ioq(efqd, ioq, "complete");
> > > +
> > > +	elv_update_hw_tag(efqd);
> > > +
> > > +	WARN_ON(!efqd->rq_in_driver);
> > > +	WARN_ON(!ioq->dispatched);
> > > +	efqd->rq_in_driver--;
> > > +	ioq->dispatched--;
> > > +
> > > +	if (sync)
> > > +		ioq->last_end_request = jiffies;
> > > +
> > > +	/*
> > > +	 * If this is the active queue, check if it needs to be expired,
> > > +	 * or if we want to idle in case it has no pending requests.
> > > +	 */
> > > +
> > > +	if (elv_active_ioq(q->elevator) == ioq) {
> > > +		if (elv_ioq_slice_new(ioq)) {
> > > +			elv_ioq_set_prio_slice(q, ioq);
> > 
> >   Hi Vivek,
> > 
> >   Would you explain a bit why slice_end should be set when first request completes.
> >   Why not set it just when an ioq gets active?
> >   
> 
> Hi Gui,
> 
> I have kept the behavior same as CFQ. I guess reason behind this is that
> when a new queue is scheduled in, first request completion might take more
> time as head of the disk might be quite a distance away (due to previous
> queue) and one probably does not want to charge the new queue for that
> first seek time. That's the reason we start the queue slice when first
> request has completed.

That's exactly why CFQ does it that way. And not just for the seek
itself, but if have eg writes issued before the switch to a new queue,
it's not fair to charge the potential cache writeout happening ahead of
the read to that new queue. So I'd definitely recommend keeping this
behaviour, as you have.

-- 
Jens Axboe

