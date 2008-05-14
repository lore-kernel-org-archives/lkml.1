Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbYENIGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbYENIGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbYENIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:05:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:6767 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760239AbYENIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pTj2fOw0YO1i1jpuO7Ea8JKdzMuFcxLTszXLUqE2FJAHXUdl+tgJFsXioj1U9hhId2VfDd98dNQoqsYxIVXMN/yTuAsuRaErS3pcLyg1zHELSkAguosYCoiykj4NH9Wx/EhbsMn+xHm+0np4FpkRci4l5BlqwDYLXV3c5+yPNyk=
Message-ID: <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com>
Date: Wed, 14 May 2008 09:05:46 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: Matthew <jackdachef@gmail.com>, "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080513184057.GU16217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com>
	 <1210514567.7827.62.camel@localhost>
	 <20080513122021.GP16217@kernel.dk>
	 <e85b9d30805130558l502addbcq21996b92fdbfdc5b@mail.gmail.com>
	 <20080513130508.GQ16217@kernel.dk>
	 <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com>
	 <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > > >  > >  > On Sun, 2008-05-11 at 14:14 +0100, Daniel J Blueman wrote:
>  > > >  > >  > > I've been experiencing this for a while also; an almost 50% regression
>  > > >  > >  > > is seen for single-process reads (ie sync) if slice_idle is 1ms or
>  > > >  > >  > > more (eg default of 8) [1], which seems phenomenal.
>  > > >  > >  > >
>  > > >  > >  > > Jens, is this the expected price to pay for optimal busy-spindle
>  > > >  > >  > > scheduling, a design issue, bug or am I missing something totally?
[snip]
>  > They seem to start out the same, but then CFQ gets interrupted by a
>  > timer unplug (which is also odd) and after that the request size drops.
>  > On most devices you don't notice, but some are fairly picky about
>  > request sizes. The end result is that CFQ has an average dispatch
>  > request size of 142kb, where AS is more than double that at 306kb. I'll
>  > need to analyze the data and look at the code a bit more to see WHY this
>  > happens.
>
>  Here's a test patch, I think we get into this situation due to CFQ being
>  a bit too eager to start queuing again. Not tested, I'll need to spend
>  some testing time on this. But I'd appreciate some feedback on whether
>  this changes the situation! The final patch will be a little more
>  involved.
>
>  diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>  index b399c62..ebd8ce2 100644
>  --- a/block/cfq-iosched.c
>  +++ b/block/cfq-iosched.c
>  @@ -1775,18 +1775,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>
>         cic->last_request_pos = rq->sector + rq->nr_sectors;
>
>  -       if (cfqq == cfqd->active_queue) {
>  -               /*
>  -                * if we are waiting for a request for this queue, let it rip
>  -                * immediately and flag that we must not expire this queue
>  -                * just now
>  -                */
>  -               if (cfq_cfqq_wait_request(cfqq)) {
>  -                       cfq_mark_cfqq_must_dispatch(cfqq);
>  -                       del_timer(&cfqd->idle_slice_timer);
>  -                       blk_start_queueing(cfqd->queue);
>  -               }
>  -       } else if (cfq_should_preempt(cfqd, cfqq, rq)) {
>  +       if ((cfqq != cfqd->active_queue) &&
>  +                  cfq_should_preempt(cfqd, cfqq, rq)) {
>                 /*
>                  * not the active queue - expire current slice if it is
>                  * idle and has expired it's mean thinktime or this new queue

I find this does address the issue (both with 64KB stride dd and
hdparm -t; presumably the requests getting merged). Tested on
2.6.26-rc2 on Ubuntu HH 804 x86-64, with slice_idle defaulting to 8
and AHCI on ICH9; disk is ST3320613AS.

Blktrace profiles from 'dd if=/dev/sda of=/dev/null bs=64k count=1000' are at:

http://quora.org/blktrace-profiles.tar.bz2

Let me know when you have an updated patch to test,
  Daniel
-- 
Daniel J Blueman
