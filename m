Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbXH1R2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbXH1R2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbXH1R2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:28:31 -0400
Received: from phunq.net ([64.81.85.152]:37025 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759183AbXH1R23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:28:29 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] Block device throttling [Re: Distributed storage.]
Date: Tue, 28 Aug 2007 10:27:59 -0700
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708271457.38100.phillips@phunq.net> <20070828093540.GB20534@2ka.mipt.ru>
In-Reply-To: <20070828093540.GB20534@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281027.59528.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 02:35, Evgeniy Polyakov wrote:
> On Mon, Aug 27, 2007 at 02:57:37PM -0700, Daniel Phillips 
(phillips@phunq.net) wrote:
> > Say Evgeniy, something I was curious about but forgot to ask you
> > earlier...
> >
> > On Wednesday 08 August 2007 03:17, Evgeniy Polyakov wrote:
> > > ...All oerations are not atomic, since we do not care about
> > > precise number of bios, but a fact, that we are close or close
> > > enough to the limit.
> > > ... in bio->endio
> > > +			q->bio_queued--;
> >
> > In your proposed patch, what prevents the race:
> >
> > 			cpu1						cpu2
> >
> > 	read q->bio_queued
> > 									q->bio_queued--
> > 	write q->bio_queued - 1
> > 	Whoops! We leaked a throttle count.
>
> We do not care about one cpu being able to increase its counter
> higher than the limit, such inaccuracy (maximum bios in flight thus
> can be more than limit, difference is equal to the number of CPUs -
> 1) is a price for removing atomic operation. I thought I pointed it
> in the original description, but might forget, that if it will be an
> issue, that atomic operations can be introduced there. Any
> uber-precise measurements in the case when we are close to the edge
> will not give us any benefit at all, since were are already in the
> grey area.

This is not just inaccurate, it is suicide.  Keep leaking throttle 
counts and eventually all of them will be gone.  No more IO
on that block device!

> Another possibility is to create a queue/device pointer in the bio
> structure to hold original device and then in its backing dev
> structure add a callback to recalculate the limit, but it increases
> the size of the bio. Do we need this?

Different issue.  Yes, I think we need a nice simple approach like
that, and prove it is stable before worrying about the size cost.

Regards,

Daniel
