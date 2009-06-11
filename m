Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbZFKKHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbZFKKHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbZFKKH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:07:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56353 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbZFKKH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:07:27 -0400
Date: Thu, 11 Jun 2009 12:07:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: powerpc: Implement generalized cache
	events for POWER processors
Message-ID: <20090611100720.GC12703@elte.hu>
References: <18992.36329.189378.17992@drongo.ozlabs.ibm.com> <18992.36430.933526.742969@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18992.36430.933526.742969@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> This adds tables of event codes for the generalized cache events 
> for all the currently supported powerpc processors: 
> POWER{4,5,5+,6,7} and PPC970*, plus powerpc-specific code to use 
> these tables when a generalized cache event is requested.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  arch/powerpc/include/asm/perf_counter.h |    3 ++
>  arch/powerpc/kernel/perf_counter.c      |   42 +++++++++++++++++++++++++++-
>  arch/powerpc/kernel/power4-pmu.c        |   41 +++++++++++++++++++++++++++
>  arch/powerpc/kernel/power5+-pmu.c       |   45 +++++++++++++++++++++++++++++-
>  arch/powerpc/kernel/power5-pmu.c        |   41 +++++++++++++++++++++++++++
>  arch/powerpc/kernel/power6-pmu.c        |   46 +++++++++++++++++++++++++++++-
>  arch/powerpc/kernel/power7-pmu.c        |   41 +++++++++++++++++++++++++++
>  arch/powerpc/kernel/ppc970-pmu.c        |   41 +++++++++++++++++++++++++++
>  8 files changed, 294 insertions(+), 6 deletions(-)

Ah, cool! I tried to construct the table so that Power would be able 
to fill it in a meaningful way - it seems like that was indeed 
possible.

Any particular observations you have about the cache events 
generalization? Would you do more of them (which ones?), fewer of 
them?

We can also add transparent fallback logic to the tools perhaps: for 
example a 'hits == total-misses' combo counter.

This can be expressed in the sampling space too: the latest tools do 
weighted samples, so we can actually do _negative_, weighted 
sampling: the misses can subtract from a function's ->count value.

I dont know whether we should do such combo counters in the kernel 
itself - i'm slightly against that notion. (seems complex)

One last-minute change we are thinking about is to change 'L2' to 
'LLC'. This matters on systems which have a L3 cache. The first 
level and the last level cache are generally the most important 
ones. What do you think?

> +	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
> +		[C(OP_READ)] = {	0x430e6,	0x400052	},
> +		[C(OP_WRITE)] = {	-1,		-1		},
> +		[C(OP_PREFETCH)] = {	-1,		-1		},

Ah, the RESULT_ACCESS/RESULT_MISS tabularization is a nice aesthetic 
touch - will do that for x86 too.

> @@ -483,8 +524,9 @@ struct power_pmu power6_pmu = {
>  	.get_constraint = p6_get_constraint,
>  	.get_alternatives = p6_get_alternatives,
>  	.disable_pmc = p6_disable_pmc,
> +	.limited_pmc_event = p6_limited_pmc_event,
> +	.flags = PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
>  	.n_generic = ARRAY_SIZE(power6_generic_events),
>  	.generic_events = power6_generic_events,
> -	.flags = PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
> -	.limited_pmc_event = p6_limited_pmc_event,
> +	.cache_events = &power6_cache_events,

Btw., a very small nit, any way i could convince you to do such 
mass-initializations in the Power code, in the way we do elsewhere 
in perfcounters, by using vertical spacing:

 	.get_constraint		= p6_get_constraint,
 	.get_alternatives	= p6_get_alternatives,
 	.disable_pmc		= p6_disable_pmc,
	.limited_pmc_event	= p6_limited_pmc_event,
	.flags			= PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
  	.n_generic		= ARRAY_SIZE(power6_generic_events),
  	.generic_events		= power6_generic_events,
	.cache_events		= &power6_cache_events,

IMHO that form is infinitely more readable.

Thanks,

	Ingo
