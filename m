Return-Path: <linux-kernel-owner+w=401wt.eu-S1423301AbXDYIrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423301AbXDYIrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423310AbXDYIrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:47:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31625 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423301AbXDYIrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:47:23 -0400
Date: Wed, 25 Apr 2007 10:46:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Brad Campbell <brad@wasp.net.au>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070425084607.GM9715@kernel.dk>
References: <46220339.9080205@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown> <20070418123757.GC3796@kernel.dk> <46261ACE.1050407@wasp.net.au> <20070418132157.GC3720@kernel.dk> <462B10C3.1030906@wasp.net.au> <20070423073543.GE5311@kernel.dk> <462E5D38.5000801@wasp.net.au> <17967.4734.783140.512857@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17967.4734.783140.512857@notabene.brown>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Neil Brown wrote:
> On Tuesday April 24, brad@wasp.net.au wrote:
> > [105449.653682] cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report the issue to 
> > lkml@vger.kernel.org
> > [105449.683646] cfq: busy=1,drv=0,timer=0
> > [105449.694871] cfq rr_list:
> > [105449.702715]   3108: sort=0,next=00000000,q=0/1,a=1/0,d=0/0,f=69
> > [105449.720693] cfq busy_list:
> > [105449.729054] cfq idle_list:
> > [105449.737418] cfq cur_rr:
> 
> Ok, I have a theory.
> 
> An ELEVATOR_FRONT_MERGE occurs which changes req->sector and calls
> ->elevator_merged_fn which is cfq_merged_request.
> 
> At this time there is already a request in cfq with the same sector
> number, and that request is the only other request on the queue.
> 
> cfq_merged_request calls cfq_reposition_rq_rb which removes the
> req from ->sortlist and then calls cfq_add_rq_rb to add it back (at
> the new location because ->sector has changed).
> 
> cfq_add_rq_rb finds there is already a request with the same sector
> number and so elv_rb_add returns an __alias which is passed to
> cfq_dispatch_insert. 
> This calls cfq_remove_request and as that is the only request present,
> ->next_rq gets set to NULL.
> The old request with the new sector number is then added to the
> ->sortlist, but ->next_rq is never set - it remains NULL.
> 
> How likely it would be to get two requests with the same sector number
> I don't know.  I wouldn't expect it to ever happen - I have seen it
> before, but it was due to a bug in ext3.  Maybe XFS does it
> intentionally some times?
> 
> You could test this theory by putting a
>    WARN_ON(cfqq->next_rq == NULL);
> at the end of cfq_reposition_rq_rb, just after the cfq_add_rq_rb call.
> 
> I will leave the development of a suitable fix up to Jens if he agrees
> that this is possible.

That's pretty close to where I think the problem is (the front merging
and cfq_reposition_rq_rb()). The issue with that is that you'd only get
aliases for O_DIRECT and/or raw IO, and that doesn't seem to be the case
here. Given that front merges are equally not very likely, I'd be
surprised is something like that has ever happened.

BUT... That may explain while we are only seeing it on md. Would md
ever be issuing such requests that trigger this condition?

I'll try and concoct a test case.

-- 
Jens Axboe

