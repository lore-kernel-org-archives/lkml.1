Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbZE3Rua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbZE3Rua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbZE3RuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 13:50:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39707 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537AbZE3RuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 13:50:22 -0400
Date: Sat, 30 May 2009 19:50:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530175003.GD20013@elte.hu>
References: <20090528090836.GB6715@elte.hu> <4A1EDC96.2322.EEEC13E@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1EDC96.2322.EEEC13E@pageexec.freemail.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 28 May 2009 at 11:08, Ingo Molnar wrote:
> 
> > 
> > * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > > > As for being swapped out - I do not believe that kernel stacks can 
> > > > > ever be swapped out in Linux.
> > > > 
> > > > yes, i referred to that as an undesirable option - because it slows 
> > > > down pthread_create() quite substantially.
> > > > 
> > > > This needs before/after pthread_create() benchmark results.
> > > 
> > > kernel stacks can end up places you don't expect on hypervisor 
> > > based systems.
> > > 
> > > In most respects the benchmarks are pretty irrelevant - wiping 
> > > stuff has a performance cost, but its the sort of thing you only 
> > > want to do when you have a security requirement that needs it. At 
> > > that point the performance is secondary.
> > 
> > Bechmarks, of course, are not irrelevant _at all_.
> > 
> > So i'm asking for this "clear kernel stacks on freeing" aspect to be 
> > benchmarked thoroughly, as i expect it to have a negative impact - 
> > otherwise i'm NAK-ing this. Please Cc: me to measurements results.
> 
> last year while developing/debugging something else i also ran some kernel
> compilation tests and managed to dig out this one for you ('all' refers to
> all of PaX):
> 
> ------------------------------------------------------------------------------------------
> make -j4 2.6.24-rc7-i386-pax compiling 2.6.24-rc7-i386-pax (all with SANITIZE, no PARAVIRT)
> 565.63user 68.52system 5:25.52elapsed 194%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (1major+12486066minor)pagefaults 0swaps
> 
> 565.10user 68.28system 5:24.72elapsed 195%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+12485742minor)pagefaults 0swaps
> ------------------------------------------------------------------------------------------
> make -j4 2.6.24-rc5-i386-pax compiling 2.6.24-rc5-i386-pax (all but SANITIZE, no PARAVIRT)
> 559.74user 50.29system 5:12.79elapsed 195%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+12397482minor)pagefaults 0swaps
> 
> 561.41user 51.91system 5:14.55elapsed 194%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+12396877minor)pagefaults 0swaps
> ------------------------------------------------------------------------------------------
> 
> for the kernel times the overhead is about 68s vs. 51s, or 40% in 
> this particular case. while i don't know where this workload (the 
> kernel part) falls in the spectrum of real life workloads, it 
> definitely shows that if you're kernel bound, you should think 
> twice before using this in production (and there's the real-time 
> latency issue too).

Yes, clearing memory causes quite brutal overhead - as expected.

If only kernel stacks are cleared before reuse that will be less 
overhead - but still it has to be benchmarked (and the overhead has 
to be justified).

	Ingo
