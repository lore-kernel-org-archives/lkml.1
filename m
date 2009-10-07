Return-Path: <linux-kernel-owner+w=401wt.eu-S933507AbZJGOnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbZJGOnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbZJGOnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:43:08 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:35921 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111AbZJGOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:43:05 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v7 PATCH 3/7]: x86: refactor x86 idle power management code
 and remove all instances of pm_idle.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20091006153126.GA7358@linux.vnet.ibm.com>
References: <20091006152421.GA7278@linux.vnet.ibm.com>
	 <20091006153126.GA7358@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 16:45:50 +0200
Message-Id: <1254926750.26976.253.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 21:01 +0530, Arun R Bharadwaj wrote:
> +++ linux.trees.git/arch/x86/kernel/process.c
> @@ -9,6 +9,7 @@
>  #include <linux/pm.h>
>  #include <linux/clockchips.h>
>  #include <linux/random.h>
> +#include <linux/cpuidle.h>
>  #include <trace/events/power.h>
>  #include <asm/system.h>
>  #include <asm/apic.h>
> @@ -244,12 +245,6 @@ int sys_vfork(struct pt_regs *regs)
>  unsigned long boot_option_idle_override = 0;
>  EXPORT_SYMBOL(boot_option_idle_override);
>  
> -/*
> - * Powermanagement idle function, if any..
> - */
> -void (*pm_idle)(void);
> -EXPORT_SYMBOL(pm_idle);
> -
>  #ifdef CONFIG_X86_32
>  /*
>   * This halt magic was a workaround for ancient floppy DMA
> @@ -329,17 +324,15 @@ static void do_nothing(void *unused)
>  }
>  
>  /*
> - * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
> - * pm_idle and update to new pm_idle value. Required while changing pm_idle
> - * handler on SMP systems.
> + * cpu_idle_wait - Required while changing idle routine handler on SMP systems.
>   *
> - * Caller must have changed pm_idle to the new value before the call. Old
> - * pm_idle value will not be used by any CPU after the return of this function.
> + * Caller must have changed idle routine to the new value before the call. Old
> + * value will not be used by any CPU after the return of this function.
>   */
>  void cpu_idle_wait(void)
>  {
>         smp_mb();
> -       /* kick all the CPUs so that they exit out of pm_idle */
> +       /* kick all the CPUs so that they exit out of idle loop */
>         smp_call_function(do_nothing, NULL, 1);
>  }
>  EXPORT_SYMBOL_GPL(cpu_idle_wait);
> @@ -518,15 +511,59 @@ static void c1e_idle(void)
>                 default_idle();
>  }
>  
> +static void (*local_idle)(void);
> +DEFINE_PER_CPU(struct cpuidle_device, idle_devices);
> +
> +struct cpuidle_driver cpuidle_default_driver = {
> +       .name =         "cpuidle_default",
> +};
> +
> +static int local_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
> +{
> +       ktime_t t1, t2;
> +       s64 diff;
> +       int ret;
> +
> +       t1 = ktime_get();
> +       local_idle();
> +       t2 = ktime_get();
> +
> +       diff = ktime_to_us(ktime_sub(t2, t1));
> +       if (diff > INT_MAX)
> +               diff = INT_MAX;
> +       ret = (int) diff;
> +
> +       return ret;
> +}
> +
> +static int setup_cpuidle_simple(void)
> +{
> +       struct cpuidle_device *dev;
> +       int cpu;
> +
> +       if (!cpuidle_curr_driver)
> +               cpuidle_register_driver(&cpuidle_default_driver);
> +
> +       for_each_online_cpu(cpu) {
> +               dev = &per_cpu(idle_devices, cpu);
> +               dev->cpu = cpu;
> +               dev->states[0].enter = local_idle_loop;
> +               dev->state_count = 1;
> +               cpuidle_register_device(dev);
> +       }
> +       return 0;
> +}
> +device_initcall(setup_cpuidle_simple);
> +
>  void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
>  {
>  #ifdef CONFIG_SMP
> -       if (pm_idle == poll_idle && smp_num_siblings > 1) {
> +       if (local_idle == poll_idle && smp_num_siblings > 1) {
>                 printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
>                         " performance may degrade.\n");
>         }
>  #endif
> -       if (pm_idle)
> +       if (local_idle)
>                 return;
>  
>         if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
> @@ -534,18 +571,20 @@ void __cpuinit select_idle_routine(const
>                  * One CPU supports mwait => All CPUs supports mwait
>                  */
>                 printk(KERN_INFO "using mwait in idle threads.\n");
> -               pm_idle = mwait_idle;
> +               local_idle = mwait_idle;
>         } else if (check_c1e_idle(c)) {
>                 printk(KERN_INFO "using C1E aware idle routine\n");
> -               pm_idle = c1e_idle;
> +               local_idle = c1e_idle;
>         } else
> -               pm_idle = default_idle;
> +               local_idle = default_idle;
> +
> +       return;
>  }
>  
>  void __init init_c1e_mask(void)
>  {
>         /* If we're using c1e_idle, we need to allocate c1e_mask. */
> -       if (pm_idle == c1e_idle)
> +       if (local_idle == c1e_idle)
>                 zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
>  }
>  
> @@ -556,7 +595,7 @@ static int __init idle_setup(char *str)
>  
>         if (!strcmp(str, "poll")) {
>                 printk("using polling idle threads.\n");
> -               pm_idle = poll_idle;
> +               local_idle = poll_idle;
>         } else if (!strcmp(str, "mwait"))
>                 force_mwait = 1;
>         else if (!strcmp(str, "halt")) {
> @@ -567,7 +606,7 @@ static int __init idle_setup(char *str)
>                  * To continue to load the CPU idle driver, don't touch
>                  * the boot_option_idle_override.
>                  */
> -               pm_idle = default_idle;
> +               local_idle = default_idle;
>                 idle_halt = 1;
>                 return 0;
>         } else if (!strcmp(str, "nomwait")) {


What guarantees that the cpuidle bits actually select this
cpuidle_default driver when you do idle=poll?

Also, cpuidle already has a poll loop in it, why duplicate that?

