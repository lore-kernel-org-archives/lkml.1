Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXCHIhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXCHIhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030293AbXCHIhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:37:25 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:12427 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278AbXCHIhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h4JEC/SI6bjQvtWLRQi/xkTsFBzpmteE8R7Lh7NXf2aVMSJIgQzEntI11otgsbMGslW53xPLhyGqV1R79n21fWvn9ANhlWnG+N1WahImYgbfGoVbYIqJyKuhH08s/loJrHhnEp1ggPNAhBBQSO4jEZKDQ79+k7lXVs8HBH9cGgs=
Message-ID: <f2b55d220703080037m23f39e47ue0c194880f5a764a@mail.gmail.com>
Date: Thu, 8 Mar 2007 00:37:22 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch] epoll use a single inode ...
Cc: "Anton Blanchard" <anton@samba.org>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Avi Kivity" <avi@argo.co.il>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703071911330.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED1A3C.6030707@argo.co.il>
	 <200703071906.58405.dada1@cosmosbay.com>
	 <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org>
	 <200703071952.13219.dada1@cosmosbay.com>
	 <20070307221401.GA16938@kryten>
	 <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org>
	 <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com>
	 <Pine.LNX.4.64.0703071911330.10832@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> No, I just checked, and Intel's own optimization manual makes it clear
> that you should be careful. They talk about performance penalties due to
> resource constraints - which makes tons of sense with a core that is good
> at handling its own resources and could quite possibly use those resources
> better to actually execute the loads and stores deeper down the
> instruction pipeline.

Certainly you should be careful -- and that usually means leaving it
up to the compiler.  But hinting to the compiler can help; there may
be an analogue of the (un)likely macros waiting to be implemented for
loop prefetch.  And while out-of-order execution and fancy hardware
prefetch streams greatly reduce the need for explicit prefetch in
general code, there's no substitute for the cache _bypassing_
instructions when trying to avoid excessive cache eviction in DDoS
situations.

For instance, if I wind up working on a splay-tree variant of Robert
Olsson's trie/hash work, I'll try to measure the effect of using SSE2
non-temporal stores to write half-open connections to the leaves of
the tree.  That may give some additional improvement in the ability to
keep servicing real load during a SYN flood.

> So it's not just 3DNow! making AMD look bad, or Intel would obviously
> suggest people use it out of the wazoo ;)

Intel puts a lot of effort into educating compiler writers about the
optimal prefetch insertion strategies for particular cache
architectures.  At the same time, they put out the orange cones to
warn people off of hand-tuning prefetch placement using
micro-benchmarks.  People did that when 3DNow! first came out, with
predictable consequences.

> > XScale gets it right.
>
> Blah. XScale isn't even an OoO CPU, *of*course* it needs prefetching.
> Calling that "getting it right" is ludicrous. If anything, it gets things
> so wrong that prefetching is *required* for good performance.

That's not an accident.  Hardware prefetch units cost a lot in power
consumption.  Omitting the hardware prefetch unit and drastically
simplifying the pipeline is how they got a design whose clock they
could crank into the stratosphere and still run on battery power.  And
in the network processor space, they can bolt a myriad of on-chip
microengines and still have some prayer of accurately simulating the
patterns of internal bus cycles.  Errors in simulation can still be
fixed up with prefetch instruction placement to put memory accesses
from the XScale core into phases where the data path processors aren't
working so hard.

Moreover, because they're embedded targets and rarely have to run
third-party binaries originally compiled for older cores, it didn't
really cost them anything to say, "Sorry, this chip's performance is
going to suck if your compiler's prefetch insertion isn't properly
tuned."  The _only_ cost is a slightly less dense instruction stream.
That's not trivial but it's manageable; you budget for it, and the
increase in I-cache power consumption is more than made up for by the
reduction in erroneous data prefetches (hardware prefetch gets it
wrong a substantial fraction of the time).

> I'm talking about real CPU's with real memory pipelines that already do
> prefetching in hardware. The better the core is, the less the prefetch
> helps (and often the more it hurts in comparison to how much it helps).

The more sophisticated the core is, the less software prefetch
instructions help.  But more sophisticated isn't always better; it
depends on your target applications.

> But if you mean "doesn't try to fill the TLB on data prefetches", then
> yes, that's generally the right thing to do.

AOL.

> > (Oddly, Prescott seems to have initiated a page table walk on DTLB miss
> > during software prefetch -- just one of many weird Prescott flaws.)
>
> Netburst in general is *very* happy to do speculative TLB fills, I think.

Design by micro-benchmark.  :-)  They set out to push the headline MHz
and the real memory bandwidth to the limit in Prescott, and they
succeeded (data at
http://www.digit-life.com/articles2/rmma/rmma-p4.html).  At a horrible
cost in power per clock, and no gain in real application performance.
So NetBurst died a horrible death, and now we have "Intel Core" -- P6
warmed over, with caches sized such that for most applications the
second core ought to be used solely to soak up control path overheads.

Windows runs better on dual-core machines because the NT kernel will
happily eat an entire core doing memory bookkeeping.  Linux could take
a hint here and use the second core largely for interrupt handling and
force-priming the L2 cache on task switch.  (Prefetch instructions
aren't much use here, precisely because they give up on DTLB miss.)
Any kernel code paths that are known to stall a lot because of
usually-cold-cache access patterns (TCP connection establishment, for
instance) can also be punted over to the second core.  If you're
feeling industrious, use non-temporal memory accesses judiciously in
these code paths to reduce cache pollution; that core's CPU cycles are
going to be undersubscribed and you can afford to let it stall.

> > I'm guessing Pentium M and its descendants (Core Solo and Duo) get it
> > right but I'm having a hell of a time finding out for sure.  Can any of
> > the x86 experts answer this?
>
> I just suspect that the upside for Core 2 Due is likely fairly low. The L2
> cache is good, the memory re-ordering is working.. I doubt "prefetch"
> helps in generic code that much for things like linked list following, you
> should probably limit it to code that has *known* access patterns and you
> know it's not going to be in the cache.
>
> (In other words, I bet prefetching can help a lot with MMX/media kind of
> code, I doubt it's a huge win for "for_each_entry()")

If I understand the Intel Core microarchitecture correctly, it's more
accurate to say that for pointer-chasing code, the instruction decoder
is so good at injecting prefetch instructions into the micro-op stream
during I-Cache prefetch that additional hinting from the compiler
isn't needed.  For array-traversing code, the hardware stride prefetch
kicks in, which saves you from having to inject prefetch instructions
into hand-coded assembly (and tight into inner loops in general).

This leaves one important role for in-line software prefetch
instructions:  improving worst-case latency bounds when handling data
structures that may bloat under DDoS or other unusual loads.  It's the
next best thing to having multiple memory windows with different
hardware cache eviction strategies.  But that's another discussion,
over on netdev.

Cheers,
- Michael
