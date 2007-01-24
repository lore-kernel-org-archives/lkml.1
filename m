Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbXAXJV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbXAXJV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 04:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXAXJV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 04:21:57 -0500
Received: from brick.kernel.dk ([62.242.22.158]:16474 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXAXJV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 04:21:56 -0500
Date: Wed, 24 Jan 2007 10:23:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, KudOS <kudos@lists.ucla.edu>
Subject: Re: block_device usage and incorrect block writes
Message-ID: <20070124092333.GE12718@kernel.dk>
References: <20070118010851.GA28129@pooh.cs.ucla.edu> <20070118021306.GA22842@kernel.dk> <20070124082115.GA12538@pooh.cs.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124082115.GA12538@pooh.cs.ucla.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24 2007, Chris Frost wrote:
> On Thu, Jan 18, 2007 at 01:13:06PM +1100, Jens Axboe wrote:
> > noop doesn't guarentee that IO will be queued with the device in the
> > order in which they are submitted, and it definitely doesn't guarentee
> > that the device will process them in the order in which they are
> > dispatched. noop being FIFO basically means that it will not sort
> > requests. You can still have reordering if one request gets merged with
> > another, for instance.
> > 
> > The block layer in general provides no guarentees about ordering of
> > requests, unless you use barriers. So if you require ordering across a
> > given write request, it needs to be a write barrier.
> 
> Thank your explaining this aspect of the linux block device layer design.
> Earlier, we tried bio barriers (hard barriers) and found the slow down
> to be too great. After my previous email we looked further down the stack and
> noticed that struct request also has a soft barrier option. For our tests,
> soft barriers perform almost as well as no barriers, and our system
> is ok (for now, at least) with the write reordering that devices can do.
> 
> As our code calls generic_make_request(), it does not have access to the
> created struct request. We have modified block/ll_rw_blk.c:__make_request()
> to 1) not merge requests and to 2) add the REQ_SOFTBARRIER flag to the new
> request's cmd_flags field. Is there a more modular way for a function to
> create a new request with a soft barrier?

It would not be a problem to expose the soft/hard barrier difference at
the bio level as well, so you have direct access to it. I think it would
be quite useful in general.

-- 
Jens Axboe

