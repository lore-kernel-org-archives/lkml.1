Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbXH1Jh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbXH1Jh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbXH1JhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:37:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37147 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbXH1JhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:37:04 -0400
Date: Tue, 28 Aug 2007 13:35:40 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [1/1] Block device throttling [Re: Distributed storage.]
Message-ID: <20070828093540.GB20534@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <20070808095448.GA3440@2ka.mipt.ru> <20070808101708.GA23815@2ka.mipt.ru> <200708271457.38100.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708271457.38100.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 02:57:37PM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> Say Evgeniy, something I was curious about but forgot to ask you 
> earlier...
> 
> On Wednesday 08 August 2007 03:17, Evgeniy Polyakov wrote:
> > ...All oerations are not atomic, since we do not care about precise
> > number of bios, but a fact, that we are close or close enough to the
> > limit. 
> > ... in bio->endio
> > +			q->bio_queued--;
> 
> In your proposed patch, what prevents the race:
> 
> 			cpu1						cpu2
> 
> 	read q->bio_queued
> 									q->bio_queued--
> 	write q->bio_queued - 1
> 	Whoops! We leaked a throttle count.

We do not care about one cpu being able to increase its counter higher
than the limit, such inaccuracy (maximum bios in flight thus can be more
than limit, difference is equal to the number of CPUs - 1) is a price
for removing atomic operation. I thought I pointed it in the original
description, but might forget, that if it will be an issue, that atomic
operations can be introduced there. Any uber-precise measurements in the
case when we are close to the edge will not give us any benefit at all,
since were are already in the grey area.

Another possibility is to create a queue/device pointer in the bio
structure to hold original device and then in its backing dev structure
add a callback to recalculate the limit, but it increases the size of
the bio. Do we need this?

> Regards,
> 
> Daniel

-- 
	Evgeniy Polyakov
