Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbXLCVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbXLCVO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXLCVOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:14:19 -0500
Received: from 1wt.eu ([62.212.114.60]:2531 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXLCVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:14:17 -0500
Date: Mon, 3 Dec 2007 22:13:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: Avi Kivity <avi@argo.co.il>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071203211353.GA4009@1wt.eu>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de> <47539030.10600@argo.co.il> <20071203095022.GA28560@one.firstfloor.org> <4753ECA5.2010604@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4753ECA5.2010604@argo.co.il>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 01:46:45PM +0200, Avi Kivity wrote:
> Andi Kleen wrote:
> >>Even these (with the exception of the page fault path) are hardly "we 
> >>care about a single instruction" material suggested above.  Even with a 
> >>    
> >
> >With 10Gbit/s ethernet working you start to care about every cycle.
> >  
> 
> If you have 10M packets/sec no amount of cycle-saving will help you.  
> You need high level optimizations like TSO.  I'm not saying we should 
> sacrifice cycles like there's no tomorrow, but the big wins are elsewhere.

Huh? At 4 GHz, you have 400 cycles to process each packet. If you need to
route those packets, those cycles may just be what you need to lookup a
forwarding table and perform a few MMIO on an accelerated chip which will
take care of the transfer. But you need those cycles. If you start to waste
them 30 by 30, the performance can drop by a critical factor.

> >Similar with highend routing or in some latency sensitive network
> >applications (e.g. in HPC). 
> 
> True.  And here, the hardware can cut hundreds of cycles by avoiding the 
> kernel completely for the fast path.
> 
> >Another simple noticeable case is Unix
> >sockets and your X server communication.
> 
> Your reflexes are *much* better than mine if you can measure half a 
> nanosecond on X.

It just depends how many times a second it happens. For instance, consider
this trivial loop (fct is a two-function array which just return 1 or 2) :

        i = 0;
        for (j = 0; j < (1 << 28); j++) {
                k = (j >> 8) & 1;
                i += fct[k]();
        }

It takes 1.6 seconds to execute on my athlon-xp 1.5 GHz. If, instead of
changing the function once every 256 calls, you change it to every call :

        i = 0;
        for (j = 0; j < (1 << 28); j++) {
                k = (j >> 0) & 1;
                i += fct[k]();
        }

Then it only takes 4.3 seconds, which is about 3 times slower. The number
of calls per function remains the same (128M calls each), it's just the
branch prediction which is wrong every time. The very few nanoseconds added
at each call are enough to slow down a program from 1.6 to 4.3 seconds while
it executes the exact same code (it may even save one shift). If you have
such stupid code, say, to compute the color or alpha of each pixel in an
image, you will certainly notice the difference.

And such poorly efficient code may happen very often when you blindly rely
on function pointers instead of explicit calls.

> Here, it's scheduling that matters, avoiding large transfers, and 
> avoiding ping-pongs, not some cycles on the unix domain socket.  You 
> already paid 150 cycles or so by issuing the syscall and thousands for 
> copying the data, 50 more won't be noticeable except in nanobenchmarks.

You are forgetting something very important : once you start stacking
functions to perform the dirty work for you, you end up with so much
abstraction that even new stupid code cannot be written at all without
relying on them, and it's where the problem takes its roots, because
when you need to write a fast function and you notice that you cannot
touch a variable without passing through a slow pinhole, your fast
function will remain slow whatever you do, and the worst of all is that
you will think that it is normally fast and that it cannot be written
faster.

> >And there are some special cases where block IO is also pretty critical.
> >A popular one is TPC-* benchmarking, but there are also others and it 
> >looks likely in the future that this will become more critical
> >as block devices become faster (e.g. highend SSDs) 
> >  
> 
> And again the key is batching, improving cpu affinity, and caching, not 
> looking for a faster instruction sequence.

Every cycle burned is definitely lost. The time cannot go backwards. So
for each cycle that you lose to laziness, you have to become more and more
clever to find out how to write an alternative. Lazy people simply put
caches everywhere and after that they find normal that "hello world" requires
2 Gigs of RAM to be displayed. The only true solution is to create better
algorithms, but you will find even less people capable of creating efficient
algorithms than you will find capable of coding correctly.

> >For example there are some CPUs who are relatively slow at indirect
> >function calls and there are actually cases where this can be measured.
> 
> That is true.  But any self-respecting systems language will let you 
> choose between direct and indirect calls.
> 
> If adding an indirect call allows you to avoid even 1% of I/O, you save 
> much more than you lose, so again the high level optimizations win.

It depends which type of I/O. If the I/O is non-blocking, you end up doing
something else instead of actively burning cycles.

> Nanooptimizations are fun (I do them myself, I admit) but that's not 
> where performance as measured by the end user lies.

I do not agree. It's not uncommon to find 2- or 3-fold performance factors
between equivalent components when one is carefully optimized and the other
one is not. Granted it takes an awful lot of time doing all those nano-opts
at the beginning, but the more you learn about how the hardware reacts to
your code, the more efficiently you write future code, with the fewest bloat.
End users notice bloat a lot (especially when CPU and RAM are excessively
wasted).

Best regards,
Willy

