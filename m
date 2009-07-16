Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbZGPIL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbZGPIL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZGPILz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:11:55 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43850 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZGPILw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:11:52 -0400
Date: Thu, 16 Jul 2009 13:40:10 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, linux-tip-commits@vger.kernel.org,
       Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090716081010.GB3134@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512193656.D647.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 07:44:37PM +0900, KOSAKI Motohiro wrote:
> ------------------------------------
> Subject: [PATCH] sched: cpuacct: Use bigger percpu counter batch values for stats counters
> 
> percpu counters used to accumulate statistics in cpuacct controller use
> the default batch value [max(2*nr_cpus, 32)] which can be too small for
> archs that define VIRT_CPU_ACCOUNTING. In such archs, a tick could result in
> cputime updates in the range of thousands. As a result, cpuacct_update_stats()
> would end up acquiring the percpu counter spinlock on every tick which
> is not good for performance.
> 
> Let those architectures to have a bigger batch threshold so that percpu counter
> spinlock isn't taken on every tick. This change doesn't affect the archs which
> don't define VIRT_CPU_ACCOUNTING and they continue to have the default
> percpu counter batch value.
> 
>  v7:
>  - fix typo and changelog
> 
>  v6:
>  - fix build error when UP
> 
>  v5:
>  - move cpuacct_batch initialization into sched_init()
> 
>  v4:
>   - rewrite patch description (thanks Bharata!)
>   - append read_mostly to cpuacct_batch
>   - cpuacct_batch is initialized by sched_init_debug()
> 
>  v3:
>   - revert using percpu_counter_sum()
> 
>  v2:
>   - use percpu_counter_sum() instead percpu_counter_read()
> 
> Cc: Balaji Rao <balajirrao@gmail.com>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/sched.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: b/kernel/sched.c
> ===================================================================
> --- a/kernel/sched.c	2009-05-12 13:12:59.000000000 +0900
> +++ b/kernel/sched.c	2009-05-12 19:04:49.000000000 +0900
> @@ -870,6 +870,8 @@ static __read_mostly int scheduler_runni
>   */
>  int sysctl_sched_rt_runtime = 950000;
> 
> +static __read_mostly s32 cpuacct_batch;
> +
>  static inline u64 global_rt_period(void)
>  {
>  	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
> @@ -9284,6 +9286,10 @@ void __init sched_init(void)
> 
>  	perf_counter_init();
> 
> +#ifdef CONFIG_SMP
> +	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> +#endif

On ppc64, calling jiffies_to_cputime() from sched_init() is too early because
jiffies_to_cputime() needs tb_ticks_per_sec which gets initialized only
later in time_init(). Because of this I see that cpuacct_batch will always
be zero effectively negating what this patch is trying to do.

As explained by you earlier, we too are finding the default batch value to
be too low for ppc64 with VIRT_CPU_ACCOUNTING turned on. Hence I guess
if this patch is taken in (ofcourse with the above issue fixed), it will
benefit ppc64 also.

Regards,
Bharata.
