Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbZE1GRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbZE1GRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbZE1GRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:17:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:47017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZE1GRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:17:02 -0400
Date: Thu, 28 May 2009 08:17:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Message-ID: <20090528061702.GB6920@wotan.suse.de>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1C3805.7060404@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 11:42:13AM -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> >I did more 'perf stat mmap-perf 1' measurements (bound to a single 
> >core, running single thread - to exclude cross-CPU noise), which in 
> >essence measures CONFIG_PARAVIRT=y overhead on native kernels:
> >  
> 
> Thanks for taking the time to make these measurements.  You'll agree 
> they're much better numbers than the last time you ran these tests?
> 
> > Performance counter stats for './mmap-perf':
> >
> >      [vanilla]  [PARAVIRT=y]
> >
> >    1230.805297   1242.828348  task clock ticks     (msecs)   + 0.97%
> >     3602663413    3637329004  CPU cycles           (events)  + 0.96%
> >     1927074043    1958330813  instructions         (events)  + 1.62%
> >
> >That's around 1% on really fast hardware (Core2 E6800 @ 2.93 GHz, 
> >4MB L2 cache), i.e. still significant overhead. Distros generally 
> >enable CONFIG_PARAVIRT, even though a large majority of users never 
> >actually runs them as Xen guests.
> >  
> 
> Did you do only a single run, or is this the result of multiple runs?  
> If so, what was your procedure? How did you control for page 
> placement/cache effects/other boot-to-boot variations?
> 
> Your numbers are not dissimilar to my measurements, but I also saw up to 
> 1% performance improvement vs native from boot to boot (I saw up to 10% 
> reduction of cache misses with pvops, possibly because of its 
> de-inlining effects).
> 
> I also saw about 1% boot to boot variation with the non-pvops kernel.
> 
> While I think pvops does add *some* overhead, I think the absolute 
> magnitude is swamped in the noise.  The best we can say is "somewhere 
> under 1% on modern hardware".
> 
> >Are there plans to analyze and fix this overhead too, beyond the 
> >paravirt-spinlocks overhead you analyzed? (Note that i had 
> >CONFIG_PARAVIRT_SPINLOCKS disabled in this test.)
> >
> >I think only those users should get overhead who actually run such 
> >kernels in a virtualized environment.
> >
> >I cannot cite a single other kernel feature that has so much 
> >performance impact when runtime-disabled. For example, an often 
> >cited bloat and overhead source is CONFIG_SECURITY=y.
> >  
> 
> Your particular benchmark does many, many mmap/mprotect/munmap/mremap 
> calls, and takes a lot of pagefaults.  That's going to hit the hot path 
> with lots of pte updates and so on, but very few security hooks.  How 
> does it compare with a more balanced workload?
> 
> >Its runtime overhead (same system, same workload) is:
> >
> >      [vanilla]  [SECURITY=y]
> >
> >    1219.652255   1230.805297  task clock ticks     (msecs)   + 0.91%
> >     3574548461    3602663413  CPU cycles           (events)  + 0.78%
> >     1915177924    1927074043  instructions         (events)  + 0.62%
> >
> >( With the difference that the distros that enable CONFIG_SECURITY=y
> >  tend to install and use at least one security module by default. )
> >
> >So everyone who runs a CONFIG_PARAVIRT=y distro kernel has 1% of 
> >overhead in this mmap-test workload - even if no Xen is used on that 
> >box, ever.
> >  
> 
> So you're saying that:
> 
>    * CONFIG_SECURITY adding +0.91% to wallclock time is OK, but pvops
>      adding +0.97% is not,
>    * your test is sensitive enough to make 0.06% difference
>      significant, and
>    * this benchmark is representative enough of real workloads that its
>      results are overall meaningful?

FWIW, we had to disable paravirt in our default SLES11 kernel.
(admittedly this was before some of the recent improvements were
made). But there are only so many 1% performance regressions you
can introduce before customers won't upgrade (or vendors won't
publish benchmarks with the new software).

But OTOH, almost any bit feature is going to cost performance. I don't
think this is something new (as noted with CONFIG_SECURITY). It is
just something people have to trade off and decide for themselves.
If you make it configurable and keep performance as good as reasonably
possible, then I don't think more can be asked.

If performance overhead is too much and/or too few users can take
advantage of a feature, then distros can always special-case it. I
think may did for pae...

