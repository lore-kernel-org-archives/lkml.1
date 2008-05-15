Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYEOHBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYEOHBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYEOHBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:01:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17443 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbYEOHBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:01:31 -0400
Date: Thu, 15 May 2008 09:01:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew <jackdachef@gmail.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080515070127.GH16217@kernel.dk>
References: <20080513122021.GP16217@kernel.dk> <e85b9d30805130558l502addbcq21996b92fdbfdc5b@mail.gmail.com> <20080513130508.GQ16217@kernel.dk> <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com> <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk> <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com> <20080514082622.GA16217@kernel.dk> <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com> <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14 2008, Matthew wrote:
> On Wed, May 14, 2008 at 10:52 PM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
> > On Wed, May 14, 2008 at 9:26 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> On Wed, May 14 2008, Daniel J Blueman wrote:
> >>> >  > > >  > >  > On Sun, 2008-05-11 at 14:14 +0100, Daniel J Blueman wrote:
> >>> >  > > >  > >  > > I've been experiencing this for a while also; an almost 50% regression
> >>> >  > > >  > >  > > is seen for single-process reads (ie sync) if slice_idle is 1ms or
> >>> >  > > >  > >  > > more (eg default of 8) [1], which seems phenomenal.
> >>> >  > > >  > >  > >
> >>> >  > > >  > >  > > Jens, is this the expected price to pay for optimal busy-spindle
> >>> >  > > >  > >  > > scheduling, a design issue, bug or am I missing something totally?
> >>> [snip]
> >>> >  > They seem to start out the same, but then CFQ gets interrupted by a
> >>> >  > timer unplug (which is also odd) and after that the request size drops.
> >>> >  > On most devices you don't notice, but some are fairly picky about
> >>> >  > request sizes. The end result is that CFQ has an average dispatch
> >>> >  > request size of 142kb, where AS is more than double that at 306kb. I'll
> >>> >  > need to analyze the data and look at the code a bit more to see WHY this
> >>> >  > happens.
> >>> >
> >>> >  Here's a test patch, I think we get into this situation due to CFQ being
> >>> >  a bit too eager to start queuing again. Not tested, I'll need to spend
> >>> >  some testing time on this. But I'd appreciate some feedback on whether
> >>> >  this changes the situation! The final patch will be a little more
> >>> >  involved.
> >>> >
> >>> >  diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >>> >  index b399c62..ebd8ce2 100644
> >>> >  --- a/block/cfq-iosched.c
> >>> >  +++ b/block/cfq-iosched.c
> >>> >  @@ -1775,18 +1775,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >>> >
> >>> >         cic->last_request_pos = rq->sector + rq->nr_sectors;
> >>> >
> >>> >  -       if (cfqq == cfqd->active_queue) {
> >>> >  -               /*
> >>> >  -                * if we are waiting for a request for this queue, let it rip
> >>> >  -                * immediately and flag that we must not expire this queue
> >>> >  -                * just now
> >>> >  -                */
> >>> >  -               if (cfq_cfqq_wait_request(cfqq)) {
> >>> >  -                       cfq_mark_cfqq_must_dispatch(cfqq);
> >>> >  -                       del_timer(&cfqd->idle_slice_timer);
> >>> >  -                       blk_start_queueing(cfqd->queue);
> >>> >  -               }
> >>> >  -       } else if (cfq_should_preempt(cfqd, cfqq, rq)) {
> >>> >  +       if ((cfqq != cfqd->active_queue) &&
> >>> >  +                  cfq_should_preempt(cfqd, cfqq, rq)) {
> >>> >                 /*
> >>> >                  * not the active queue - expire current slice if it is
> >>> >                  * idle and has expired it's mean thinktime or this new queue
> >>>
> >>> I find this does address the issue (both with 64KB stride dd and
> >>> hdparm -t; presumably the requests getting merged). Tested on
> >>> 2.6.26-rc2 on Ubuntu HH 804 x86-64, with slice_idle defaulting to 8
> >>> and AHCI on ICH9; disk is ST3320613AS.
> >>>
> >>> Blktrace profiles from 'dd if=/dev/sda of=/dev/null bs=64k count=1000' are at:
> >>>
> >>> http://quora.org/blktrace-profiles.tar.bz2
> >>
> >> Goodie! I think the below patch is better - we do want to schedule the
> >> queue immediately, but we do not want to interrupt the queuer. So just
> >> kick the workqueue handling of the queue instead of entering the
> >> dispatcher directly. Can you test this one as well? Thanks!
> >>
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index f4e1006..e8c1941 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -1107,7 +1107,6 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
> >>
> >>                cfq_clear_cfqq_must_dispatch(cfqq);
> >>                cfq_clear_cfqq_wait_request(cfqq);
> >> -               del_timer(&cfqd->idle_slice_timer);
> >>
> >>                dispatched += __cfq_dispatch_requests(cfqd, cfqq, max_dispatch);
> >>        }
> >> @@ -1769,15 +1768,9 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >>        cic->last_request_pos = rq->sector + rq->nr_sectors;
> >>
> >>        if (cfqq == cfqd->active_queue) {
> >> -               /*
> >> -                * if we are waiting for a request for this queue, let it rip
> >> -                * immediately and flag that we must not expire this queue
> >> -                * just now
> >> -                */
> >>                if (cfq_cfqq_wait_request(cfqq)) {
> >> -                       cfq_mark_cfqq_must_dispatch(cfqq);
> >>                        del_timer(&cfqd->idle_slice_timer);
> >> -                       blk_start_queueing(cfqd->queue);
> >> +                       kblockd_schedule_work(&cfqd->unplug_work);
> >>                }
> >>        } else if (cfq_should_preempt(cfqd, cfqq, rq)) {
> >>                /*
> >> @@ -1787,7 +1780,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >>                 */
> >>                cfq_preempt_queue(cfqd, cfqq);
> >>                cfq_mark_cfqq_must_dispatch(cfqq);
> >> -               blk_start_queueing(cfqd->queue);
> >> +               kblockd_schedule_work(&cfqd->unplug_work);
> >>        }
> >>  }
> >
> > Applied on top of 2.6.26-rc2, I get platter-speed (118MB/s) with 'dd
> > if=/dev/sda of=/dev/null bs=64k' and 'hdparm -t', so looks good.
> > Identical testing without the patch (ie pure mainline) consistently
> > yields 65MB/s.
> >
> > Blktrace profile at:
> >
> > http://quora.org/blktrace-profiles-2.tar.bz2
> >
> > I'll check for performance regressions with postmark on XFS; anything
> > else worth running while I've got this in hand?
> >
> > Daniel
> > --
> > Daniel J Blueman
> >
> 
> so it seems something specific to >=2.6.26-rc2 + the patch fixed it for you ?
> 
> were there any notable changes from 2.6.25 -> 2.6.26 in cfq or the VFS
> in general ?
> 
> I'm curious if this also works with 2.6.25, could you please test that too ?
> 
> I'll give .26-rc2 a test-ride later

I don't think it's 2.6.25 vs 2.6.26-rc2, I can still reproduce some
request size offsets with the patch. So still fumbling around with this,
I'll be sending out another test patch when I'm confident it's solved
the size issue.

-- 
Jens Axboe

