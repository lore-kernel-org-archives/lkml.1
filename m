Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYKYPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYKYPK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYKYPKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:10:51 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49846 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751521AbYKYPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:10:50 -0500
Message-ID: <492C1578.30302@sgi.com>
Date: Tue, 25 Nov 2008 07:10:48 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix-local_cpu_mask
References: <200811250238.53883.rusty@rustcorp.com.au> <20081124171749.GB27851@elte.hu> <20081124172343.GB11971@elte.hu> <492AFE54.6030906@sgi.com>
In-Reply-To: <492AFE54.6030906@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>> plus there's a build failure as well on 32-bit:
>>
>> kernel/sched_rt.c:1561: error: 'per_cpu__local_cpu_mask' undeclared (first use in this function)
>> kernel/sched_rt.c:1561: error: (Each undeclared identifier is reported only once
>> kernel/sched_rt.c:1561: error: for each function it appears in.)
>> kernel/sched.c:8348: error: 'nohz' undeclared (first use in this function)
>> kernel/sched.c:8350: error: 'cpu_isolated_map' undeclared (first use in this function)
>>
>> with the attached config, caused by your patches. Please send delta 
>> fixes against tip/cpus4096.
>>
>> Thanks,
>>
>> 	Ingo

Hi Ingo,

You can ignore this patch.  I'm testing Rusty's alternative fixes and will Ack as soon as they
pass your configs (and the offline/online test).

Thanks,
Mike

>>
> sched: fix-local_cpu_mask
> 
> This should fix the errors for the i386 non-smp case.  I've also
> checked it against the 32/64 allnoconfigs and allyesconfigs.
> 
> Based on tip/cpus4096 @ v2.6.28-rc6-254-g96f874e
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/sched.c    |    6 ++++--
>  kernel/sched_rt.c |    4 +++-
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.28-tip-cpumasks.orig/kernel/sched.c
> +++ linux-2.6.28-tip-cpumasks/kernel/sched.c
> @@ -8347,12 +8347,14 @@ void __init sched_init(void)
>  	 */
>  	current->sched_class = &fair_sched_class;
>  
> -	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
> -	alloc_bootmem_cpumask_var(&nohz_cpu_mask);
> +#ifdef CONFIG_SMP
>  #ifdef CONFIG_NO_HZ
> +	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
>  	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
>  #endif
> +	/* Allocate the cpu_isolated_map if CONFIG_CPUMASK_OFFSTACK */
>  	alloc_bootmem_cpumask_var(&cpu_isolated_map);
> +#endif
>  
>  	scheduler_running = 1;
>  }
> --- linux-2.6.28-tip-cpumasks.orig/kernel/sched_rt.c
> +++ linux-2.6.28-tip-cpumasks/kernel/sched_rt.c
> @@ -1552,7 +1552,8 @@ static void print_rt_stats(struct seq_fi
>  }
>  #endif /* CONFIG_SCHED_DEBUG */
>  
> -/* Note that this is never called for !SMP, but that's OK. */
> +#ifdef CONFIG_SMP
> +/* Note that this is never called for !SMP */
>  static inline void init_sched_rt_class(void)
>  {
>  	unsigned int i;
> @@ -1560,3 +1561,4 @@ static inline void init_sched_rt_class(v
>  	for_each_possible_cpu(i)
>  		alloc_cpumask_var(&per_cpu(local_cpu_mask, i), GFP_KERNEL);
>  }
> +#endif

