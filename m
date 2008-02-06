Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbYBFBdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbYBFBdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbYBFBdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:33:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:31780 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbYBFBdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:33:15 -0500
Date: Tue, 5 Feb 2008 17:31:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com
Subject: Re: [PATCH 3/8] sched: rt-group: interface
Message-Id: <20080205173137.bfbac1c7.randy.dunlap@oracle.com>
In-Reply-To: <20080204211836.968632000@chello.nl>
References: <20080204210258.118479000@chello.nl>
	<20080204211836.968632000@chello.nl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 22:03:01 +0100 Peter Zijlstra wrote:

> Change the rt_ratio interface to rt_runtime_us, to match rt_period_us.
> This avoids picking a granularity for the ratio.
> 
> Extend the /sys/kernel/uids/<uid>/ interface to allow setting
> the group's rt_runtime.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  Documentation/ABI/testing/sysfs-kernel-uids |    6 +
>  Documentation/sched-rt-group.txt            |   59 +++++++++++
>  include/linux/sched.h                       |    7 -
>  kernel/sched.c                              |  145 +++++++++++++++++++++-------
>  kernel/sched_rt.c                           |   53 ++++------
>  kernel/sysctl.c                             |   32 +++---
>  kernel/user.c                               |   28 +++++
>  7 files changed, 250 insertions(+), 80 deletions(-)

> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -7780,30 +7783,76 @@ unsigned long sched_group_shares(struct 
>  }
>  
>  /*
> - * Ensure the total rt_ratio <= sysctl_sched_rt_ratio
> + * Ensure that the real time constraints are schedulable.
>   */
> -int sched_group_set_rt_ratio(struct task_group *tg, unsigned long rt_ratio)
> +static DEFINE_MUTEX(rt_constraints_mutex);
> +
> +static unsigned long to_ratio(u64 period, u64 runtime)
> +{
> +	if (runtime == RUNTIME_INF)
> +		return 1ULL << 16;
> +
> +	runtime *= (1ULL << 16);
> +	do_div(runtime, period);

Isn't do_div() defined as taking (uint64_t, uint32_t) ?

> +	return runtime;
> +}
> +

> Index: linux-2.6/Documentation/sched-rt-group.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6/Documentation/sched-rt-group.txt
> @@ -0,0 +1,59 @@
> +
> +
> +Real-Time group scheduling.
> +
> +The problem space:
> +
> +In order to schedule multiple groups of realtime tasks each group must
> +be assigned a fixed portion of the cpu time available. Without a minimum

Use "cpu" or "CPU" consistently, please.  (I prefer CPU, but ....)

> +guarantee a realtime group can obviously fall short. A fuzzy upper limit
> +is of no use since it cannot be relied upon. Which leaves us with just
> +the single fixed portion.
> +
> +CPU time is divided by means of specifying how much time can be spend

s/spend/spent/

> +running in a given period. Say a frame fixed realtime renderer must
> +deliver a 25 frames a second, which yields a period of 0.04s. Now say

   drop "a"^

> +it will also have to play some music and respond to input, leaving it
> +with around 80% for the graphics. We can then give this group a runtime
> +of 0.8 * 0.04s = 0.032s.
> +
> +This way the graphics group will have a 0.04s period with a 0.032s runtime
> +limit.
> +
> +Now if the audio thread needs to refill the dma buffer every 0.005s, but

DMA preferably.

> +needs only about 3% cpu time to do so, it will can do with a 0.03 * 0.005s

   s/will can do/can do/

> += 0.00015s.
> +
> +
> +The Interface:
> +
> +system wide:
> +
> +/proc/sys/kernel/sched_rt_period_ms
> +/proc/sys/kernel/sched_rt_runtime_us
> +
> +CONFIG_FAIR_USER_SCHED
> +
> +/sys/kernel/uids/<uid>/cpu_rt_runtime_us
> +
> +or
> +
> +CONFIG_FAIR_CGROUP_SCHED
> +
> +/cgroup/<cgroup>/cpu.rt_runtime_us
> +
> +[ time is specified in us because the interface is s32, this gives an

s/,/;/

> +  operating range of ~35m to 1us ]
> +
> +The period takes values in [ 1, INT_MAX ], runtime in [ -1, INT_MAX - 1 ].
> +
> +A runtime of -1 specifies runtime == period, ie. no limit.
> +
> +New groups get the period from /proc/sys/kernel/sched_rt_period_us and
> +a runtime of 0.
> +
> +Settings are constrainted to:

                constrained

> +
> +   \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
> +
> +in order to keep the configuration schedulable.

---
~Randy
