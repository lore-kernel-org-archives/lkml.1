Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276Ab0AGGHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0AGGHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520Ab0AGGHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:07:14 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:50595 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0AGGHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:07:13 -0500
Date: Wed, 6 Jan 2010 21:28:52 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
Message-ID: <20100107052851.GA12419@feather>
References: <20100107044007.GA22863@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107044007.GA22863@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 11:40:07PM -0500, Mathieu Desnoyers wrote:
> Here is an implementation of a new system call, sys_membarrier(), which
> executes a memory barrier on all threads of the current process.
> 
> It aims at greatly simplifying and enhancing the current signal-based
> liburcu userspace RCU synchronize_rcu() implementation.
> (found at http://lttng.org/urcu)
> 
> Both the signal-based and the sys_membarrier userspace RCU schemes
> permit us to remove the memory barrier from the userspace RCU
> rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
> accelerating them. These memory barriers are replaced by compiler
> barriers on the read-side, and all matching memory barriers on the
> write-side are turned into an invokation of a memory barrier on all
> active threads in the process. By letting the kernel perform this
> synchronization rather than dumbly sending a signal to every process
> threads (as we currently do), we diminish the number of unnecessary wake
> ups and only issue the memory barriers on active threads. Non-running
> threads do not need to execute such barrier anyway, because these are
> implied by the scheduler context switches.
[...]
> The current implementation simply executes a memory barrier in an IPI
> handler on each active cpu. Going through the hassle of taking run queue
> locks and checking if the thread running on each online CPU belongs to
> the current thread seems more heavyweight than the cost of the IPI
> itself (not measured though).

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

Nice idea.  A few things come immediately to mind:

- If !CONFIG_SMP, this syscall should become (more of) a no-op.  Ideally
  even if CONFIG_SMP but running with one CPU.  (If you really wanted to
  go nuts, you could make it a vsyscall that did nothing with 1 CPU, to
  avoid the syscall overhead, but that seems like entirely too much
  trouble.)

- Have you tested what happens if a process does "while(1)
  membarrier();"?  By running on every CPU, including those not owned by
  the current process, this has the potential to make DoS easier,
  particularly on systems with many CPUs.  That gets even worse if a
  process forks multiple threads running that same loop.  Also consider
  that executing an IPI will do work even on a CPU currently running a
  real-time task.

- Rather than groveling through runqueues, could you somehow remotely
  check the value of current?  In theory, a race in doing so wouldn't
  matter; finding something other than the current process should mean
  you don't need to do a barrier, and finding the current process means
  you might need to do a barrier.

- Part of me thinks this ought to become slightly more general, and just
  deliver a signal that the receiving thread could handle as it likes.
  However, that would certainly prove more expensive than this, and I
  don't know that the generality would buy anything.

- Could you somehow register reader threads with the kernel, in a way
  that makes them easy to detect remotely?


- Josh Triplett
