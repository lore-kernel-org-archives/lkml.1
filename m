Return-Path: <linux-kernel-owner+w=401wt.eu-S932693Ab0AGI2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab0AGI2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932631Ab0AGI2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:28:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:56992 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab0AGI2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:28:43 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100107044007.GA22863@Krystal>
References: <20100107044007.GA22863@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 09:27:42 +0100
Message-ID: <1262852862.4049.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 23:40 -0500, Mathieu Desnoyers wrote:

> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 22:11:32.000000000 -0500
> +++ linux-2.6-lttng/kernel/sched.c	2010-01-06 23:20:42.000000000 -0500
> @@ -10822,6 +10822,36 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
>  
> +/*
> + * Execute a memory barrier on all CPUs on SMP systems.
> + * Do not rely on implicit barriers in smp_call_function(), just in case they
> + * are ever relaxed in the future.
> + */
> +static void membarrier_ipi(void *unused)
> +{
> +	smp_mb();
> +}
> +
> +/*
> + * sys_membarrier - issue memory barrier on current process running threads
> + *
> + * Execute a memory barrier on all running threads of the current process.
> + * Upon completion, the caller thread is ensured that all process threads
> + * have passed through a state where memory accesses match program order.
> + * (non-running threads are de facto in such a state)
> + *
> + * The current implementation simply executes a memory barrier in an IPI handler
> + * on each active cpu. Going through the hassle of taking run queue locks and
> + * checking if the thread running on each online CPU belongs to the current
> + * thread seems more heavyweight than the cost of the IPI itself.
> + */
> +SYSCALL_DEFINE0(membarrier)
> +{
> +	on_each_cpu(membarrier_ipi, NULL, 1);
> +
> +	return 0;
> +}
> +
>  #ifndef CONFIG_SMP
>  
>  int rcu_expedited_torture_stats(char *page)

OK, so my worry here is that its a DoS on large machines.

Something like:
  smp_call_function_any(current->mm->cpu_vm_mask, membarrier, NULL, 1);

might be slightly better, but would still hurt. The alternative is
iterating all cpus and looking to see if cpu_curr(cpu)->mm ==
current->mm and then send it an ipi.

Also, there was some talk a while ago about IPIs implying memory
barriers. Which I of course forgot all details about,.. at least sending
one implies a wmb and receiving one an rmb, but it could be stronger,
Oleg?



