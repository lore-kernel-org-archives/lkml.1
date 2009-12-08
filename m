Return-Path: <linux-kernel-owner+w=401wt.eu-S966829AbZLHWvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966829AbZLHWvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966820AbZLHWu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966765AbZLHWu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:50:56 -0500
Date: Tue, 8 Dec 2009 17:50:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: Wait for next request if we are about to
	expire the queue
Message-ID: <20091208225055.GE28615@redhat.com>
References: <20091208150412.GC28615@redhat.com> <x49zl5tfj4f.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zl5tfj4f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 12:52:48PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > If there is a sequential reader running in a group, we wait for next request
> > to come in that group after slice expiry and once new request is in, we expire
> > the queue. Otherwise we delete the group from service tree and group looses
> > its fair share.
> >
> > So far I was marking a queue as wait_busy if it had consumed its slice and
> > it was last queue in the group. But this condition did not cover following
> > two cases.
> >
> > - If think time of process is more than slice left, we will not arm the timer
> >   and queue will be expired. 
> >
> > - If we hit the boundary condition where slice has not expired after request
> >   completion but almost immediately after (4-5 ns), select_queue() hits and
> >   by that time slice has expired because jiffies has incremented by one.
> >
> > Gui was hitting the boundary condition and not getting fairness numbers
> > proportional to weight.
> >
> > This patch puts the checks for above two conditions and improves the fairness
> > numbers for sequential workload on rotational media.
> >
> > Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com> 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Acked-by: Gui Jianfeng <guijiafneng@cn.fujitsu.com>
> > ---
> >  block/cfq-iosched.c |   30 ++++++++++++++++++++++++++----
> >  1 file changed, 26 insertions(+), 4 deletions(-)
> >
> > Index: linux1/block/cfq-iosched.c
> > ===================================================================
> > --- linux1.orig/block/cfq-iosched.c	2009-12-07 14:40:03.000000000 -0500
> > +++ linux1/block/cfq-iosched.c	2009-12-07 14:40:04.000000000 -0500
> > @@ -3251,6 +3251,29 @@ static void cfq_update_hw_tag(struct cfq
> >  		cfqd->hw_tag = 0;
> >  }
> >  
> > +static inline bool
> > +cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > +{
> > +	struct cfq_io_context *cic = cfqd->active_cic;
> > +
> > +	/* If there are other queues in the group, don't wait */
> > +	if (cfqq->cfqg->nr_cfqq > 1)
> > +		return false;
> > +
> > +	if (cfq_slice_used(cfqq))
> > +		return true;
> > +
> > +	if (cfqq->slice_end - jiffies == 1)
> > +		return true;
> 
> This really looks like a hack.  At the very least, it requires a big
> comment above it explaining why it's there.  Would it be possible to
> detect such a condition in select_queue and handle it there?

Hi Jeff,

We have to wait for next request in the queue somewhere to make sure group
does not get deleted otherwise it loses share.  We can wait for next request
either in request completed_request() or in select_queue().

Initially I had put wait_busy() call in select_queue() and after taking
care of all the cases, it was looking more ugly as compared to current
solution. I had to modify arm_slice_timer() routine to specify special
case that we are doing wait busy and also call arm_slice_timer() in
select_queue() to make sure we don't stall the queue in case there is
nothing in the dispatch queue and we still need to wait for group to
get busy. We want to make sure atleast idle timer is armed.

So to avoid the modifications in arm_slice_timer() and to avoid calling
it in select(), we chose to implement wait_busy mechanism in
completed_request(). It is consistent with CFQ theme of arming the timer
in completed_request(), if need be and select_queue() will honor that.

Now there are couple of corner cases left.

1.If a request completed and slice has not expired yet. Next request comes
  in and is dispatched to disk. Now select_queue() hits and slice has
  expired. This group will be deleted. Because request is still in the
  disk, this queue will never get a chance to wait_busy.

2.If request completed and slice has not expired yet. Before next request
  comes in (delay due to think time), select_queue() hits and expires the
  queue hence group. This queue never got a chance to wait busy.

Now I have modified the patch to take care of case 1 in select_queue()
and to take care of case 2 in completed_request().

It is a two patch series I will post soon to lkml. Please have a look and
see if you like that better.

Thanks
Vivek
