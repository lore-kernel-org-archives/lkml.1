Return-Path: <linux-kernel-owner+w=401wt.eu-S1763745AbZE1Su0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745AbZE1Su0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZE1SuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:50:15 -0400
Received: from r00tworld.com ([212.85.137.21]:42256 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbZE1SuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:50:14 -0400
From: pageexec@freemail.hu
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 28 May 2009 20:48:54 +0200
MIME-Version: 1.0
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page allocator
Reply-to: pageexec@freemail.hu
CC: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <4A1EDC96.2322.EEEC13E@pageexec.freemail.hu>
In-reply-to: <20090528090836.GB6715@elte.hu>
References: <20090520183045.GB10547@oblivion.subreption.com>, <20090528072702.796622b6@lxorguk.ukuu.org.uk>, <20090528090836.GB6715@elte.hu>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 28 May 2009 20:48:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2009 at 11:08, Ingo Molnar wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > > As for being swapped out - I do not believe that kernel stacks can 
> > > > ever be swapped out in Linux.
> > > 
> > > yes, i referred to that as an undesirable option - because it slows 
> > > down pthread_create() quite substantially.
> > > 
> > > This needs before/after pthread_create() benchmark results.
> > 
> > kernel stacks can end up places you don't expect on hypervisor 
> > based systems.
> > 
> > In most respects the benchmarks are pretty irrelevant - wiping 
> > stuff has a performance cost, but its the sort of thing you only 
> > want to do when you have a security requirement that needs it. At 
> > that point the performance is secondary.
> 
> Bechmarks, of course, are not irrelevant _at all_.
> 
> So i'm asking for this "clear kernel stacks on freeing" aspect to be 
> benchmarked thoroughly, as i expect it to have a negative impact - 
> otherwise i'm NAK-ing this. Please Cc: me to measurements results.

last year while developing/debugging something else i also ran some kernel
compilation tests and managed to dig out this one for you ('all' refers to
all of PaX):

------------------------------------------------------------------------------------------
make -j4 2.6.24-rc7-i386-pax compiling 2.6.24-rc7-i386-pax (all with SANITIZE, no PARAVIRT)
565.63user 68.52system 5:25.52elapsed 194%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+12486066minor)pagefaults 0swaps

565.10user 68.28system 5:24.72elapsed 195%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+12485742minor)pagefaults 0swaps
------------------------------------------------------------------------------------------
make -j4 2.6.24-rc5-i386-pax compiling 2.6.24-rc5-i386-pax (all but SANITIZE, no PARAVIRT)
559.74user 50.29system 5:12.79elapsed 195%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+12397482minor)pagefaults 0swaps

561.41user 51.91system 5:14.55elapsed 194%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+12396877minor)pagefaults 0swaps
------------------------------------------------------------------------------------------

for the kernel times the overhead is about 68s vs. 51s, or 40% in this particular case.
while i don't know where this workload (the kernel part) falls in the spectrum of real
life workloads, it definitely shows that if you're kernel bound, you should think twice
before using this in production (and there's the real-time latency issue too).

