Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXLJMTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXLJMTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLJMTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:19:34 -0500
Received: from brick.kernel.dk ([87.55.233.238]:27478 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXLJMTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:19:33 -0500
Date: Mon, 10 Dec 2007 13:16:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071210121627.GF5008@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <200712100323.48535.phillips@phunq.net> <20071210114123.GE5008@kernel.dk> <200712100413.38077.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712100413.38077.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, Daniel Phillips wrote:
> On Monday 10 December 2007 03:41, Jens Axboe wrote:
> > On Mon, Dec 10 2007, Daniel Phillips wrote:
> > > +       if (q && q->metric && !bio->bi_queue) {
> > >
> > > This prevents any reference to bi_bdev after the intial call to
> > > generic_make_request.  Thanks to Evgeniy for pointing out the need
> > > for this measure on the last go round.
> >
> > Which saves the initial target, for ease of accounting at end io time
> > - that's not the point. What happens when ->make_request_fn() changes
> > bio->bi_bdev and returns 1, causing another iteration of the
> > __generic_make_request() loop? 'q' is no longer the valid target,
> > bdev_get_queue(bio->bi_bdev) is.
> 
> What happens on the second iteration of a recursive submission loop is 
> exactly nothing, as is right and proper.  The throttling has already 
> been done, and all the state necessary to perform the unthrottle was 
> recorded in the bio.  Everything seems to be in order there, and the 
> algorithm does indeed perform its function as designed, though to be 
> sure we have not tested it on -mm branch, only on mainline.

OK, let me get the neon out then. This has nothing to do with
throttling, I thought I made it clear that I get why you store the
origin queue in ->bi_queue. I'm concerned with the workings of
redirecting a bio. Previously we looked up the queue associated with
bio->bi_bdev inside the loop in __generic_make_request(), as is REQUIRED
to correctly locate a DIFFERENT queue if bio->bi_bdev has been changed
to point somewhere else.

Clear?

-- 
Jens Axboe

