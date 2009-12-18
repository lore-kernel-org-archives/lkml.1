Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbZLRMtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbZLRMtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZLRMtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:49:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:54079 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751217AbZLRMtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:49:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18UXzVxYosU91RIEHm3/BKVi7huNqkE6NgyZ/GJAx
	cFBDvVCcFft/st
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Jason Garrett-Glaser <darkshikari@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <28f2fcbc0912180211we599252v39cb94d113537eb5@mail.gmail.com>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
	 <20091218052344.GD417@elte.hu> <1261121405.30469.8.camel@marge.simson.net>
	 <28f2fcbc0912180211we599252v39cb94d113537eb5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 13:49:06 +0100
Message-Id: <1261140546.15591.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 02:11 -0800, Jason Garrett-Glaser wrote:

> Two more thoughts here:
> 
> 1) We're considering moving to a thread pool soon; we already have a
> working patch for it and if anything it'll save a few clocks spent on
> nice()ing threads and other such things.  Will this improve
> START_DEBIT at all?

Yeah, START_DEBIT only affects a thread once.

>   I've attached the beta patch if you want to try
> it.  Note this also works with 2) as well, so it adds yet another
> dimension to what's mentioned below.
> 
> 2) We recently implemented a new threading model which may be
> interesting to test as well.  This threading model gives worse
> compression *and* performance, but has one benefit: it adds zero
> latency, whereas normal threading adds a full frame of latency per
> thread.  This was paid for by a company interested in
> ultra-low-latency streaming applications, where 1 millisecond is a
> huge deal.  I've been thinking this might be interesting to bench from
> a kernel perspective as well, as when you're spawning a half-dozen
> threads and need them all done within 6 milliseconds, you start
> getting down to serious scheduler issues.
> 
> The new threading model is much less complex than the regular one and
> works as follows.  The frame is split into X slices, and each slice
> encoded with one thread.  Specifically, it works via the following
> process:
> 
> 1.  Preprocess input frame, perform lookahead analysis on input frame
> (all singlethreaded)
> 2.  Split up a ton of threads to do the main encode, one per slice.
> 3.  Join all the threads.
> 4.  Do post-filtering on the output frame, return.
> 
> Clearly this is an utter disaster, since it spawns N times as many
> threads as the old threading model *and* they last far shorter, *and*
> only part of the application is multithreaded.  But there's not really
> a better way to do low-latency threading, and it's an interesting
> challenge to boot.  IIRC, it's also the way ffmpeg's encoder threading
> works.  It's widely considered an inferior model, but as mentioned
> before, in this particular use-case there's no choice.
> 
> To enable this, use --sliced-threads.  I'd recommend using a
> higher-resolution clip for this, as it performs atrociously bad on
> very low resolution videos for reasons you might be able to guess.  If
> you need a higher-res clip, check the SD or HD ones here:
> http://media.xiph.org/video/derf/ .

In another 8 hrs 24 min, I'll have a sunflower to stare at.

> I'm personally curious as to what kind of scheduler issues this
> results in--I haven't done any BFS vs CFS tests with this option
> enabled yet.

I'll look for x264 source, and patch/piddle.

	-Mike

