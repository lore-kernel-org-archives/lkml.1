Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYHLDqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYHLDqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYHLDqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:46:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYHLDqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:46:11 -0400
Date: Mon, 11 Aug 2008 23:46:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ftrace_enabled_save/restore
In-Reply-To: <1218511056.24951.49.camel@caritas-dev.intel.com>
Message-ID: <alpine.DEB.1.10.0808112345100.6648@gandalf.stny.rr.com>
References: <1218511056.24951.49.camel@caritas-dev.intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Can you pull this into linux-tip.

Thanks,

-- Steve


On Tue, 12 Aug 2008, Huang Ying wrote:

> Hi, Steven,
> 
> Below is the patch of locked ftrace_enabled_save/restore, which is based
> on the non-locked version I posted with the title:
> 
> [PATCH -v3 6/7] kexec jump: __ftrace_enabled_save/restore
> 
> What do you think about this?
> 
> Best Regards,
> Huang Ying
> ----------------------------------------------------------->
> From: Steven Rostedt <srostedt@redhat.com>
> Subject: ftrace: cpu hotplug fix
> 
> Peter Zijlstra found that taking down and bringing up a new CPU caused
> ftrace to crash the kernel. This was due to some arch calls that were
> being traced by the function tracer before the smp_processor_id was set
> up. Since the function tracer uses smp_processor_id it caused a triple
> fault.
> 
> Instead of adding notrace all over the architecture code to prevent
> this problem, it is easier to simply disable the function tracer
> when bringing up a new CPU.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  include/linux/ftrace.h            |   15 ++++++++++++---
>  kernel/cpu.c                      |   11 ++++++++++-
>  kernel/trace/ftrace.c             |   20 ++++++++++++++++++++
>  kernel/trace/trace_irqsoff.c      |    3 +++
>  kernel/trace/trace_sched_wakeup.c |    2 +-
>  5 files changed, 46 insertions(+), 5 deletions(-)
> 
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -32,10 +32,19 @@ void clear_ftrace_function(void);
>  
>  extern void ftrace_stub(unsigned long a0, unsigned long a1);
>  
> +int ftrace_enabled_save(void);
> +void ftrace_enabled_restore(int enabled);
> +
>  #else /* !CONFIG_FTRACE */
> -# define register_ftrace_function(ops) do { } while (0)
> -# define unregister_ftrace_function(ops) do { } while (0)
> -# define clear_ftrace_function(ops) do { } while (0)
> +# define register_ftrace_function(ops)		do { } while (0)
> +# define unregister_ftrace_function(ops)	do { } while (0)
> +# define clear_ftrace_function(ops)		do { } while (0)
> +# define ftrace_enabled_restore(enabled)	do { } while (0)
> +
> +static inline int ftrace_enabled_save(void)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_FTRACE */
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -14,6 +14,7 @@
>  #include <linux/kthread.h>
>  #include <linux/stop_machine.h>
>  #include <linux/mutex.h>
> +#include <linux/ftrace.h>
>  
>  /*
>   * Represents all cpu's present in the system
> @@ -325,7 +326,7 @@ EXPORT_SYMBOL(cpu_down);
>  /* Requires cpu_add_remove_lock to be held */
>  static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
>  {
> -	int ret, nr_calls = 0;
> +	int ret, nr_calls = 0, saved_ftrace_enabled;
>  	void *hcpu = (void *)(long)cpu;
>  	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
>  
> @@ -343,8 +344,16 @@ static int __cpuinit _cpu_up(unsigned in
>  		goto out_notify;
>  	}
>  
> +	/*
> +	 * Disable function tracing while bringing up a new CPU.
> +	 * We don't want to trace functions that can not handle a
> +	 * smp_processor_id() call.
> +	 */
> +	saved_ftrace_enabled = ftrace_enabled_save();
> +
>  	/* Arch-specific enabling code. */
>  	ret = __cpu_up(cpu);
> +	ftrace_enabled_restore(saved_ftrace_enabled);
>  	if (ret != 0)
>  		goto out_notify;
>  	BUG_ON(!cpu_online(cpu));
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -151,6 +151,26 @@ static int __unregister_ftrace_function(
>  	return ret;
>  }
>  
> +int ftrace_enabled_save(void)
> +{
> +	mutex_lock(&ftrace_sysctl_lock);
> +
> +	return __ftrace_enabled_save();
> +}
> +
> +void ftrace_enabled_restore(int enabled)
> +{
> +	/* ftrace_enabled_restore must be paired with ftrace_enabled_save */
> +	if (!mutex_is_locked(&ftrace_sysctl_lock)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +
> +	__ftrace_enabled_restore(enabled);
> +
> +	mutex_unlock(&ftrace_sysctl_lock);
> +}
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  
>  static struct task_struct *ftraced_task;
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -76,6 +76,9 @@ irqsoff_tracer_call(unsigned long ip, un
>  	long disabled;
>  	int cpu;
>  
> +	if (unlikely(!ftrace_enabled))
> +		return;
> +
>  	/*
>  	 * Does not matter if we preempt. We test the flags
>  	 * afterward, to see if irqs are disabled or not.
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -45,7 +45,7 @@ wakeup_tracer_call(unsigned long ip, uns
>  	int resched;
>  	int cpu;
>  
> -	if (likely(!wakeup_task))
> +	if (likely(!wakeup_task) || !ftrace_enabled)
>  		return;
>  
>  	resched = need_resched();
> 
> 
> 
