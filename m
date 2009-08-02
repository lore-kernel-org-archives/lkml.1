Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZHBRST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZHBRST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZHBRST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:18:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47130 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZHBRSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:18:17 -0400
Date: Sun, 2 Aug 2009 10:18:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-ID: <20090802171820.GL6854@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 01:09:34PM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc
> Gitweb:     http://git.kernel.org/tip/c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sun, 2 Aug 2009 11:28:21 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 2 Aug 2009 13:27:17 +0200
> 
> debug lockups: Improve lockup detection
> 
> When debugging a recent lockup bug i found various deficiencies
> in how our current lockup detection helpers work:
> 
>  - SysRq-L is not very efficient as it uses a workqueue, hence
>    it cannot punch through hard lockups and cannot see through
>    most soft lockups either.
> 
>  - The SysRq-L code depends on the NMI watchdog - which is off
>    by default.
> 
>  - We dont print backtraces from the RCU code's built-in
>    'RCU state machine is stuck' debug code. This debug
>    code tends to be one of the first (and only) mechanisms
>    that show that a lockup has occured.
> 
> This patch changes the code so taht we:
> 
>  - Trigger the NMI backtrace code from SysRq-L instead of using
>    a workqueue (which cannot punch through hard lockups)
> 
>  - Trigger print-all-CPU-backtraces from the RCU lockup detection
>    code
> 
> Also decouple the backtrace printing code from the NMI watchdog:
> 
>  - Dont use variable size cpumasks (it might not be initialized
>    and they are a bit more fragile anyway)
> 
>  - Trigger an NMI immediately via an IPI, instead of waiting
>    for the NMI tick to occur. This is a lot faster and can
>    produce more relevant backtraces. It will also work if the
>    NMI watchdog is disabled.
> 
>  - Dont print the 'dazed and confused' message when we print
>    a backtrace from the NMI
> 
>  - Do a show_regs() plus a dump_stack() to get maximum info
>    out of the dump. Worst-case we get two stacktraces - which
>    is not a big deal. Sometimes, if register content is
>    corrupted, the precise stack walker in show_regs() wont
>    give us a full backtrace - in this case dump_stack() will
>    do it.

Looks good from an RCU perspective!  I will need to dump task stacks
in the new version.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/apic/nmi.c |   18 ++++++++++++------
>  drivers/char/sysrq.c       |    8 ++------
>  kernel/rcutree.c           |    7 ++++++-
>  3 files changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> index b3025b4..1bb1ac2 100644
> --- a/arch/x86/kernel/apic/nmi.c
> +++ b/arch/x86/kernel/apic/nmi.c
> @@ -39,7 +39,7 @@
>  int unknown_nmi_panic;
>  int nmi_watchdog_enabled;
> 
> -static cpumask_var_t backtrace_mask;
> +static cpumask_t backtrace_mask __read_mostly;
> 
>  /* nmi_active:
>   * >0: the lapic NMI watchdog is active, but can be disabled
> @@ -138,7 +138,6 @@ int __init check_nmi_watchdog(void)
>  	if (!prev_nmi_count)
>  		goto error;
> 
> -	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL|__GFP_ZERO);
>  	printk(KERN_INFO "Testing NMI watchdog ... ");
> 
>  #ifdef CONFIG_SMP
> @@ -415,14 +414,17 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
>  	}
> 
>  	/* We can be called before check_nmi_watchdog, hence NULL check. */
> -	if (backtrace_mask != NULL && cpumask_test_cpu(cpu, backtrace_mask)) {
> +	if (cpumask_test_cpu(cpu, &backtrace_mask)) {
>  		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
> 
>  		spin_lock(&lock);
>  		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
> +		show_regs(regs);
>  		dump_stack();
>  		spin_unlock(&lock);
> -		cpumask_clear_cpu(cpu, backtrace_mask);
> +		cpumask_clear_cpu(cpu, &backtrace_mask);
> +
> +		rc = 1;
>  	}
> 
>  	/* Could check oops_in_progress here too, but it's safer not to */
> @@ -556,10 +558,14 @@ void __trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> 
> -	cpumask_copy(backtrace_mask, cpu_online_mask);
> +	cpumask_copy(&backtrace_mask, cpu_online_mask);
> +
> +	printk(KERN_INFO "sending NMI to all CPUs:\n");
> +	apic->send_IPI_all(NMI_VECTOR);
> +
>  	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
>  	for (i = 0; i < 10 * 1000; i++) {
> -		if (cpumask_empty(backtrace_mask))
> +		if (cpumask_empty(&backtrace_mask))
>  			break;
>  		mdelay(1);
>  	}
> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> index 5d7a02f..165f307 100644
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -24,6 +24,7 @@
>  #include <linux/sysrq.h>
>  #include <linux/kbd_kern.h>
>  #include <linux/proc_fs.h>
> +#include <linux/nmi.h>
>  #include <linux/quotaops.h>
>  #include <linux/perf_counter.h>
>  #include <linux/kernel.h>
> @@ -222,12 +223,7 @@ static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
> 
>  static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
>  {
> -	struct pt_regs *regs = get_irq_regs();
> -	if (regs) {
> -		printk(KERN_INFO "CPU%d:\n", smp_processor_id());
> -		show_regs(regs);
> -	}
> -	schedule_work(&sysrq_showallcpus);
> +	trigger_all_cpu_backtrace();
>  }
> 
>  static struct sysrq_key_op sysrq_showallcpus_op = {
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 7717b95..9c5fa9f 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -35,6 +35,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
> +#include <linux/nmi.h>
>  #include <asm/atomic.h>
>  #include <linux/bitops.h>
>  #include <linux/module.h>
> @@ -469,6 +470,8 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  	}
>  	printk(" (detected by %d, t=%ld jiffies)\n",
>  	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
> +	trigger_all_cpu_backtrace();
> +
>  	force_quiescent_state(rsp, 0);  /* Kick them all. */
>  }
> 
> @@ -479,12 +482,14 @@ static void print_cpu_stall(struct rcu_state *rsp)
> 
>  	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu jiffies)\n",
>  			smp_processor_id(), jiffies - rsp->gp_start);
> -	dump_stack();
> +	trigger_all_cpu_backtrace();
> +
>  	spin_lock_irqsave(&rnp->lock, flags);
>  	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
>  		rsp->jiffies_stall =
>  			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
>  	spin_unlock_irqrestore(&rnp->lock, flags);
> +
>  	set_need_resched();  /* kick ourselves to get things going. */
>  }
> 
