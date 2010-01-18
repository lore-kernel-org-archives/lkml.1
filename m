Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109Ab0ARIgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0ARIgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062Ab0ARIgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:36:14 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38517 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab0ARIgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:36:13 -0500
Message-ID: <4B541D6F.3000003@linux.vnet.ibm.com>
Date: Mon, 18 Jan 2010 14:05:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten> <20090820051038.GF21100@kryten> <20100118044142.GS12666@kryten>
In-Reply-To: <20100118044142.GS12666@kryten>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010 10:11 AM, Anton Blanchard wrote:
> 
> Hi,
> 
> Another try at this percpu_counter batch issue with CONFIG_VIRT_CPU_ACCOUNTING
> and CONFIG_CGROUP_CPUACCT enabled. Thoughts?
> 
> --
> 
> When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we can
> call cpuacct_update_stats with values much larger than percpu_counter_batch.
> This means the call to percpu_counter_add will always add to the global count
> which is protected by a spinlock and we end up with a global spinlock in
> the scheduler.
> 
> Based on an idea by KOSAKI Motohiro, this patch scales the batch value by
> cputime_one_jiffy such that we have the same batch limit as we would
> if CONFIG_VIRT_CPU_ACCOUNTING was disabled. His patch did this once at boot
> but that initialisation happened too early on PowerPC (before time_init)
> and it was never updated at runtime as a result of a hotplug cpu add/remove.
> 
> This patch instead scales percpu_counter_batch by cputime_one_jiffy at
> runtime, which keeps the batch correct even after cpu hotplug operations.
> We cap it at INT_MAX in case of overflow.
> 
> For architectures that do not support CONFIG_VIRT_CPU_ACCOUNTING,
> cputime_one_jiffy is the constant 1 and gcc is smart enough to
> optimise min(s32 percpu_counter_batch, INT_MAX) to just percpu_counter_batch
> at least on x86 and PowerPC. So there is no need to add an #ifdef.
> 
> On a 64 thread PowerPC box with CONFIG_VIRT_CPU_ACCOUNTING and 
> CONFIG_CGROUP_CPUACCT enabled, a context switch microbenchmark is 234x faster
> and almost matches a CONFIG_CGROUP_CPUACCT disabled kernel:
> 
> CONFIG_CGROUP_CPUACCT disabled:		16906698 ctx switches/sec
> CONFIG_CGROUP_CPUACCT enabled:		   61720 ctx switches/sec
> CONFIG_CGROUP_CPUACCT + patch:		16663217 ctx switches/sec
> 
> Tested with:
> 
> wget http://ozlabs.org/~anton/junkcode/context_switch.c
> make context_switch
> for i in `seq 0 63`; do taskset -c $i ./context_switch & done
> vmstat 1
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Note: ccing ia64 and s390 who have not yet added code to statically
> initialise cputime_one_jiffy at boot. 
> See a42548a18866e87092db93b771e6c5b060d78401 (cputime: Optimize
> jiffies_to_cputime(1) for details). Adding this would help optimise not only
> this patch but many other areas of the scheduler when
> CONFIG_VIRT_CPU_ACCOUNTING is enabled.
> 
> Index: linux.trees.git/kernel/sched.c
> ===================================================================
> --- linux.trees.git.orig/kernel/sched.c	2010-01-18 14:27:12.000000000 +1100
> +++ linux.trees.git/kernel/sched.c	2010-01-18 15:21:59.000000000 +1100
> @@ -10894,6 +10894,7 @@ static void cpuacct_update_stats(struct 
>  		enum cpuacct_stat_index idx, cputime_t val)
>  {
>  	struct cpuacct *ca;
> +	int batch;
> 
>  	if (unlikely(!cpuacct_subsys.active))
>  		return;
> @@ -10901,8 +10902,9 @@ static void cpuacct_update_stats(struct 
>  	rcu_read_lock();
>  	ca = task_ca(tsk);
> 
> +	batch = min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX);
>  	do {
> -		percpu_counter_add(&ca->cpustat[idx], val);
> +		__percpu_counter_add(&ca->cpustat[idx], val, batch);
>  		ca = ca->parent;
>  	} while (ca);
>  	rcu_read_unlock();

Looks good to me, but I'll test it as well and revert back. I think we
might need to look at the call side where we do the percpu_counter_read().

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
