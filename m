Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZKXGgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZKXGgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZKXGgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:36:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZKXGgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:36:48 -0500
Date: Tue, 24 Nov 2009 07:36:53 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091124063653.GB20981@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop> <20091123114550.GB25575@elte.hu> <20091123120100.GC2287@wotan.suse.de> <20091123120849.GB32009@elte.hu> <20091123122731.GE2287@wotan.suse.de> <20091123124615.GA27808@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123124615.GA27808@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 01:46:15PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > (I hope i explained my point clearly enough.)
> > > 
> > > No argument that it could be done cleaner - the duality right now of 
> > > both having the fuzzy stats and the rate limiting should be decided 
> > > one way or another.
> > 
> > Well, I would say please keep domain balancing behaviour at least 
> > somewhat close to how it was with O(1) scheduler at least until CFS is 
> > more sorted out. There is no need to knee jerk because BFS is better 
> > at something.
> 
> Well, see the change (commit 0ec9fab3d) attached below - even in 
> hindsight it was well argued by Mike with quite a few numbers: +68% in 
> x264 performance.

Quite a few being one test case, and on a program with a horrible
parallelism design (rapid heavy weight forks to distribute small
units of work).

 
> If you think it's a bad change (combined with newidle-rate-limit) then 
> please show the numbers that counter it and preferably extend 'perf 
> bench sched' with the testcases that you care about most.
> 
> IIRC (and Peter mentioned this too) Mike got into the whole kbuild angle 
> due to comparing mainline scheduler to BFS - but that's really a 
> positive thing IMO, not some "knee-jerk reaction".

It is a knee-jerk "we have to be better than BFS" reaction. It is
quite obvious that vasty increasing inter node balancing and remote
cacheline touches is not a good idea (unless it helps _reasonably_
designed programs without unduely hurting others).

And when you are changing all this desktop interactivity stuff, I
would ask please not to make these kinds of "improvements" to domains
balancing. I don't think that is too much to ask given track record
of scheduler problems.

Finally, I didn't realise I would have to be responsible for shooting
down every "ooh shiny" change that gets pushed into the scheduler. I
would have hoped they are ensured to be rather well thought out and
reviewed and tested first.

I do think it is a bad change, for extensive reasons I explained. It
will obviously cause regressions on workloads with lots of newidle
events that are un-balanceable (which would include _well tuned_ net
work and data base servers). And it does. I thought you'd have been
aware of that.

http://patchwork.kernel.org/patch/58931/

> 
> 	Ingo
> 
> ----------------------->
> >From 0ec9fab3d186d9cbb00c0f694d4a260d07c198d9 Mon Sep 17 00:00:00 2001
> From: Mike Galbraith <efault@gmx.de>
> Date: Tue, 15 Sep 2009 15:07:03 +0200
> Subject: [PATCH] sched: Improve latencies and throughput
> 
> Make the idle balancer more agressive, to improve a
> x264 encoding workload provided by Jason Garrett-Glaser:
> 
>  NEXT_BUDDY NO_LB_BIAS
>  encoded 600 frames, 252.82 fps, 22096.60 kb/s
>  encoded 600 frames, 250.69 fps, 22096.60 kb/s
>  encoded 600 frames, 245.76 fps, 22096.60 kb/s
> 
>  NO_NEXT_BUDDY LB_BIAS
>  encoded 600 frames, 344.44 fps, 22096.60 kb/s
>  encoded 600 frames, 346.66 fps, 22096.60 kb/s
>  encoded 600 frames, 352.59 fps, 22096.60 kb/s
> 
>  NO_NEXT_BUDDY NO_LB_BIAS
>  encoded 600 frames, 425.75 fps, 22096.60 kb/s
>  encoded 600 frames, 425.45 fps, 22096.60 kb/s
>  encoded 600 frames, 422.49 fps, 22096.60 kb/s
> 
> Peter pointed out that this is better done via newidle_idx,
> not via LB_BIAS, newidle balancing should look for where
> there is load _now_, not where there was load 2 ticks ago.
> 
> Worst-case latencies are improved as well as no buddies
> means less vruntime spread. (as per prior lkml discussions)
> 
> This change improves kbuild-peak parallelism as well.
> 
> Reported-by: Jason Garrett-Glaser <darkshikari@gmail.com>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1253011667.9128.16.camel@marge.simson.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/ia64/include/asm/topology.h    |    5 +++--
>  arch/powerpc/include/asm/topology.h |    2 +-
>  arch/sh/include/asm/topology.h      |    3 ++-
>  arch/x86/include/asm/topology.h     |    4 +---
>  include/linux/topology.h            |    2 +-
>  kernel/sched_features.h             |    2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
> index 47f3c51..42f1673 100644
> --- a/arch/ia64/include/asm/topology.h
> +++ b/arch/ia64/include/asm/topology.h
> @@ -61,7 +61,7 @@ void build_cpu_to_node_map(void);
>  	.cache_nice_tries	= 2,			\
>  	.busy_idx		= 2,			\
>  	.idle_idx		= 1,			\
> -	.newidle_idx		= 2,			\
> +	.newidle_idx		= 0,			\
>  	.wake_idx		= 0,			\
>  	.forkexec_idx		= 1,			\
>  	.flags			= SD_LOAD_BALANCE	\
> @@ -87,10 +87,11 @@ void build_cpu_to_node_map(void);
>  	.cache_nice_tries	= 2,			\
>  	.busy_idx		= 3,			\
>  	.idle_idx		= 2,			\
> -	.newidle_idx		= 2,			\
> +	.newidle_idx		= 0,			\
>  	.wake_idx		= 0,			\
>  	.forkexec_idx		= 1,			\
>  	.flags			= SD_LOAD_BALANCE	\
> +				| SD_BALANCE_NEWIDLE	\
>  				| SD_BALANCE_EXEC	\
>  				| SD_BALANCE_FORK	\
>  				| SD_BALANCE_WAKE	\
> diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
> index a6b220a..1a2c9eb 100644
> --- a/arch/powerpc/include/asm/topology.h
> +++ b/arch/powerpc/include/asm/topology.h
> @@ -57,7 +57,7 @@ static inline int pcibus_to_node(struct pci_bus *bus)
>  	.cache_nice_tries	= 1,			\
>  	.busy_idx		= 3,			\
>  	.idle_idx		= 1,			\
> -	.newidle_idx		= 2,			\
> +	.newidle_idx		= 0,			\
>  	.wake_idx		= 0,			\
>  	.flags			= SD_LOAD_BALANCE	\
>  				| SD_BALANCE_EXEC	\
> diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
> index 9054e5c..c843677 100644
> --- a/arch/sh/include/asm/topology.h
> +++ b/arch/sh/include/asm/topology.h
> @@ -15,13 +15,14 @@
>  	.cache_nice_tries	= 2,			\
>  	.busy_idx		= 3,			\
>  	.idle_idx		= 2,			\
> -	.newidle_idx		= 2,			\
> +	.newidle_idx		= 0,			\
>  	.wake_idx		= 0,			\
>  	.forkexec_idx		= 1,			\
>  	.flags			= SD_LOAD_BALANCE	\
>  				| SD_BALANCE_FORK	\
>  				| SD_BALANCE_EXEC	\
>  				| SD_BALANCE_WAKE	\
> +				| SD_BALANCE_NEWIDLE	\
>  				| SD_SERIALIZE,		\
>  	.last_balance		= jiffies,		\
>  	.balance_interval	= 1,			\
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index 4b1b335..7fafd1b 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -116,14 +116,12 @@ extern unsigned long node_remap_size[];
>  
>  # define SD_CACHE_NICE_TRIES	1
>  # define SD_IDLE_IDX		1
> -# define SD_NEWIDLE_IDX		2
>  # define SD_FORKEXEC_IDX	0
>  
>  #else
>  
>  # define SD_CACHE_NICE_TRIES	2
>  # define SD_IDLE_IDX		2
> -# define SD_NEWIDLE_IDX		2
>  # define SD_FORKEXEC_IDX	1
>  
>  #endif
> @@ -137,7 +135,7 @@ extern unsigned long node_remap_size[];
>  	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
>  	.busy_idx		= 3,					\
>  	.idle_idx		= SD_IDLE_IDX,				\
> -	.newidle_idx		= SD_NEWIDLE_IDX,			\
> +	.newidle_idx		= 0,					\
>  	.wake_idx		= 0,					\
>  	.forkexec_idx		= SD_FORKEXEC_IDX,			\
>  									\
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index c87edcd..4298745 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -151,7 +151,7 @@ int arch_update_cpu_topology(void);
>  	.cache_nice_tries	= 1,					\
>  	.busy_idx		= 2,					\
>  	.idle_idx		= 1,					\
> -	.newidle_idx		= 2,					\
> +	.newidle_idx		= 0,					\
>  	.wake_idx		= 0,					\
>  	.forkexec_idx		= 1,					\
>  									\
> diff --git a/kernel/sched_features.h b/kernel/sched_features.h
> index 891ea0f..e98c2e8 100644
> --- a/kernel/sched_features.h
> +++ b/kernel/sched_features.h
> @@ -67,7 +67,7 @@ SCHED_FEAT(AFFINE_WAKEUPS, 1)
>   * wakeup-preemption), since its likely going to consume data we
>   * touched, increases cache locality.
>   */
> -SCHED_FEAT(NEXT_BUDDY, 1)
> +SCHED_FEAT(NEXT_BUDDY, 0)
>  
>  /*
>   * Prefer to schedule the task that ran last (when we did
