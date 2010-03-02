Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0CBPIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:08:44 -0500
Received: from www.tglx.de ([62.245.132.106]:50075 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab0CBPIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:08:43 -0500
Date: Tue, 2 Mar 2010 16:08:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Aaro Koskinen <aaro.koskinen@nokia.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, robert.richter@amd.com
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
In-Reply-To: <20100302160110.5fd14f5f@mschwide.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.2.00.1003021605570.4245@localhost.localdomain>
References: <20090603152223.083010123@de.ibm.com> <alpine.LFD.2.00.0906092252150.3351@localhost.localdomain> <20090622162631.4b4dcee4@skybase> <20090622144110.GA9771@elte.hu> <20090622165936.0bb776e1@skybase> <20090622150553.GA14363@elte.hu>
 <20090622171834.0df64aea@skybase> <20090622152937.GA17512@elte.hu> <20090622173611.3b583c95@skybase> <20090622154030.GA19076@elte.hu> <20090624185100.6ca7e82a@skybase> <4B8D1942.8060405@nokia.com> <20100302160110.5fd14f5f@mschwide.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, Martin Schwidefsky wrote:

> On Tue, 02 Mar 2010 15:57:22 +0200
> Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
> 
> > Hi,
> > 
> > Martin Schwidefsky wrote:
> > > First version of the hrtimer patch for oprofile. I did not add the
> > > sysctl yet, if the sysctl is added in oprofile_timer_init it would not
> > > be available if some better profiling source is available. If it is
> > > added unconditionally it would only have an effect if the timer
> > > fallback is used. Both cases are not exactly nice for a user space
> > > interface.
> > 
> > I wonder what happened to this patch? Some platforms would need
> > this fix (i.e. the timer mode has to be used due to HW issues).
> 
> After SH removed their oprofile hook there is nothing left that would
> prevent us from converting oprofile to hrtimer. Just a matter of
> reminding me and have me try again ;-)
> 
> Patch against current git. Ingo, Thomas: one for the timer tree I guess.

No objections from my side, but shouldn't that go via Robert ?

Thanks,

	tglx

> --
> Subject: [PATCH] convert oprofile from timer_hook to hrtimer
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Oprofile is currently broken on systems running with NOHZ enabled.
> A maximum of 1 tick is accounted via the timer_hook if a cpu sleeps
> for a longer period of time. This does bad things to the percentages
> in the profiler output. To solve this problem convert oprofile to
> use a restarting hrtimer instead of the timer_hook.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  drivers/oprofile/oprof.c     |   12 ++++--
>  drivers/oprofile/oprof.h     |    3 +
>  drivers/oprofile/timer_int.c |   78 ++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 79 insertions(+), 14 deletions(-)
> 
> diff -urpN linux-2.6/drivers/oprofile/oprof.c linux-2.6-patched/drivers/oprofile/oprof.c
> --- linux-2.6/drivers/oprofile/oprof.c	2010-02-24 19:52:17.000000000 +0100
> +++ linux-2.6-patched/drivers/oprofile/oprof.c	2010-03-02 15:57:02.000000000 +0100
> @@ -253,22 +253,26 @@ static int __init oprofile_init(void)
>  	int err;
>  
>  	err = oprofile_arch_init(&oprofile_ops);
> -
>  	if (err < 0 || timer) {
>  		printk(KERN_INFO "oprofile: using timer interrupt.\n");
> -		oprofile_timer_init(&oprofile_ops);
> +		err = oprofile_timer_init(&oprofile_ops);
> +		if (err)
> +			goto out_arch;
>  	}
> -
>  	err = oprofilefs_register();
>  	if (err)
> -		oprofile_arch_exit();
> +		goto out_arch;
> +	return 0;
>  
> +out_arch:
> +	oprofile_arch_exit();
>  	return err;
>  }
>  
>  
>  static void __exit oprofile_exit(void)
>  {
> +	oprofile_timer_exit();
>  	oprofilefs_unregister();
>  	oprofile_arch_exit();
>  }
> diff -urpN linux-2.6/drivers/oprofile/oprof.h linux-2.6-patched/drivers/oprofile/oprof.h
> --- linux-2.6/drivers/oprofile/oprof.h	2010-02-24 19:52:17.000000000 +0100
> +++ linux-2.6-patched/drivers/oprofile/oprof.h	2010-03-02 15:57:02.000000000 +0100
> @@ -34,7 +34,8 @@ struct super_block;
>  struct dentry;
>  
>  void oprofile_create_files(struct super_block *sb, struct dentry *root);
> -void oprofile_timer_init(struct oprofile_operations *ops);
> +int oprofile_timer_init(struct oprofile_operations *ops);
> +void oprofile_timer_exit(void);
>  
>  int oprofile_set_backtrace(unsigned long depth);
>  int oprofile_set_timeout(unsigned long time);
> diff -urpN linux-2.6/drivers/oprofile/timer_int.c linux-2.6-patched/drivers/oprofile/timer_int.c
> --- linux-2.6/drivers/oprofile/timer_int.c	2010-02-24 19:52:17.000000000 +0100
> +++ linux-2.6-patched/drivers/oprofile/timer_int.c	2010-03-02 15:57:02.000000000 +0100
> @@ -13,34 +13,94 @@
>  #include <linux/oprofile.h>
>  #include <linux/profile.h>
>  #include <linux/init.h>
> +#include <linux/cpu.h>
> +#include <linux/hrtimer.h>
> +#include <asm/irq_regs.h>
>  #include <asm/ptrace.h>
>  
>  #include "oprof.h"
>  
> -static int timer_notify(struct pt_regs *regs)
> +static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
> +
> +static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
> +{
> +	oprofile_add_sample(get_irq_regs(), 0);
> +	hrtimer_forward_now(hrtimer, ns_to_ktime(TICK_NSEC));
> +	return HRTIMER_RESTART;
> +}
> +
> +static void __oprofile_hrtimer_start(void *unused)
> +{
> +	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
> +
> +	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	hrtimer->function = oprofile_hrtimer_notify;
> +
> +	hrtimer_start(hrtimer, ns_to_ktime(TICK_NSEC),
> +		      HRTIMER_MODE_REL_PINNED);
> +}
> +
> +static int oprofile_hrtimer_start(void)
>  {
> -	oprofile_add_sample(regs, 0);
> +	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
>  	return 0;
>  }
>  
> -static int timer_start(void)
> +static void __oprofile_hrtimer_stop(int cpu)
>  {
> -	return register_timer_hook(timer_notify);
> +	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
> +
> +	hrtimer_cancel(hrtimer);
>  }
>  
> +static void oprofile_hrtimer_stop(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		__oprofile_hrtimer_stop(cpu);
> +}
>  
> -static void timer_stop(void)
> +static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
> +					 unsigned long action, void *hcpu)
>  {
> -	unregister_timer_hook(timer_notify);
> +	long cpu = (long) hcpu;
> +
> +	switch (action) {
> +	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
> +		smp_call_function_single(cpu, __oprofile_hrtimer_start,
> +					 NULL, 1);
> +		break;
> +	case CPU_DEAD:
> +	case CPU_DEAD_FROZEN:
> +		__oprofile_hrtimer_stop(cpu);
> +		break;
> +	}
> +	return NOTIFY_OK;
>  }
>  
> +static struct notifier_block __refdata oprofile_cpu_notifier = {
> +	.notifier_call = oprofile_cpu_notify,
> +};
>  
> -void __init oprofile_timer_init(struct oprofile_operations *ops)
> +int __init oprofile_timer_init(struct oprofile_operations *ops)
>  {
> +	int rc;
> +
> +	rc = register_hotcpu_notifier(&oprofile_cpu_notifier);
> +	if (rc)
> +		return rc;
>  	ops->create_files = NULL;
>  	ops->setup = NULL;
>  	ops->shutdown = NULL;
> -	ops->start = timer_start;
> -	ops->stop = timer_stop;
> +	ops->start = oprofile_hrtimer_start;
> +	ops->stop = oprofile_hrtimer_stop;
>  	ops->cpu_type = "timer";
> +	return 0;
> +}
> +
> +void __exit oprofile_timer_exit(void)
> +{
> +	unregister_hotcpu_notifier(&oprofile_cpu_notifier);
>  }
> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 
