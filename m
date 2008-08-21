Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYHUSUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYHUSUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYHUST7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:19:59 -0400
Received: from gw.goop.org ([64.81.55.164]:42925 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbYHUST6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:19:58 -0400
Message-ID: <48ADB1CC.7080004@goop.org>
Date: Thu, 21 Aug 2008 11:19:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/7] x86/paravirt:  Add hooks for CPU hotplugging
References: <> <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
In-Reply-To: <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/paravirt.c   |    8 ++++++++
>  arch/x86/kernel/process_32.c |   10 ++++++++--
>  arch/x86/kernel/process_64.c |    9 +++++++--
>  arch/x86/kernel/smpboot.c    |    8 ++++----
>  include/asm-x86/paravirt.h   |   27 +++++++++++++++++++++++++++
>  include/asm-x86/smp.h        |   13 +++++++++++--
>  6 files changed, 65 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 7cd2747..8ffe4d1 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -125,6 +125,7 @@ static void *get_call_destination(u8 type)
>  		.pv_apic_ops = pv_apic_ops,
>  		.pv_mmu_ops = pv_mmu_ops,
>  		.pv_lock_ops = pv_lock_ops,
> +		.pv_hotplug_ops = pv_hotplug_ops,
>   

I think I'd prefer these to be part of smp_ops.  We're only talking
about three new operations, and they're the logical compliments of the
existing smp_ops functions for bringing up cpus.

    J


>  	};
>  	return *((void **)&tmpl + type);
>  }
> @@ -455,9 +456,16 @@ struct pv_mmu_ops pv_mmu_ops = {
>  	.set_fixmap = native_set_fixmap,
>  };
>  
> +struct pv_hotplug_ops pv_hotplug_ops = {
> +	.cpu_die = native_cpu_die,
> +	.cpu_disable = native_cpu_disable,
> +	.play_dead = native_play_dead,
> +};
> +
>  EXPORT_SYMBOL_GPL(pv_time_ops);
>  EXPORT_SYMBOL    (pv_cpu_ops);
>  EXPORT_SYMBOL    (pv_mmu_ops);
>  EXPORT_SYMBOL_GPL(pv_apic_ops);
>  EXPORT_SYMBOL_GPL(pv_info);
>  EXPORT_SYMBOL    (pv_irq_ops);
> +EXPORT_SYMBOL    (pv_hotplug_ops);
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 593b73e..53887cd 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -77,6 +77,12 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
>  #ifdef CONFIG_HOTPLUG_CPU
>  #include <asm/nmi.h>
>  
> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#else
> +#define play_dead native_play_dead
> +#endif
> +
>  static void cpu_exit_clear(void)
>  {
>  	int cpu = raw_smp_processor_id();
> @@ -93,7 +99,7 @@ static void cpu_exit_clear(void)
>  }
>  
>  /* We don't actually take CPU down, just spin without interrupts. */
> -static inline void play_dead(void)
> +void native_play_dead(void)
>  {
>  	/* This must be done before dead CPU ack */
>  	cpu_exit_clear();
> @@ -109,7 +115,7 @@ static inline void play_dead(void)
>  	wbinvd_halt();
>  }
>  #else
> -static inline void play_dead(void)
> +void play_dead(void)
>  {
>  	BUG();
>  }
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index 8248dc0..7512044 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -86,13 +86,18 @@ void exit_idle(void)
>  		return;
>  	__exit_idle();
>  }
> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#else
> +#define play_dead native_play_dead
> +#endif
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  DECLARE_PER_CPU(int, cpu_state);
>  
>  #include <linux/nmi.h>
>  /* We halt the CPU with physical CPU hotplug */
> -static inline void play_dead(void)
> +void native_play_dead(void)
>  {
>  	idle_task_exit();
>  	mb();
> @@ -104,7 +109,7 @@ static inline void play_dead(void)
>  	wbinvd_halt();
>  }
>  #else
> -static inline void play_dead(void)
> +void native_play_dead(void)
>  {
>  	BUG();
>  }
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index eea2fd6..2a555a1 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1340,7 +1340,7 @@ static void __ref remove_cpu_from_maps(int cpu)
>  	numa_remove_cpu(cpu);
>  }
>  
> -int __cpu_disable(void)
> +int native_cpu_disable(void)
>  {
>  	int cpu = smp_processor_id();
>  
> @@ -1379,7 +1379,7 @@ int __cpu_disable(void)
>  	return 0;
>  }
>  
> -void __cpu_die(unsigned int cpu)
> +void native_cpu_die(unsigned int cpu)
>  {
>  	/* We don't do anything here: idle task is faking death itself. */
>  	unsigned int i;
> @@ -1397,12 +1397,12 @@ void __cpu_die(unsigned int cpu)
>  	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
>  }
>  #else /* ... !CONFIG_HOTPLUG_CPU */
> -int __cpu_disable(void)
> +int native_cpu_disable(void)
>  {
>  	return -ENOSYS;
>  }
>  
> -void __cpu_die(unsigned int cpu)
> +void native_cpu_die(unsigned int cpu)
>  {
>  	/* We said "no" in __cpu_disable */
>  	BUG();
> diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
> index eca8c4f..fd922c3 100644
> --- a/include/asm-x86/paravirt.h
> +++ b/include/asm-x86/paravirt.h
> @@ -332,6 +332,12 @@ struct pv_lock_ops {
>  	void (*spin_unlock)(struct raw_spinlock *lock);
>  };
>  
> +struct pv_hotplug_ops {
> +	void (*play_dead)(void);
> +	int (*cpu_disable)(void);
> +	void (*cpu_die)(unsigned int);
> +};
> +
>  /* This contains all the paravirt structures: we get a convenient
>   * number for each function using the offset which we use to indicate
>   * what to patch. */
> @@ -343,6 +349,7 @@ struct paravirt_patch_template {
>  	struct pv_apic_ops pv_apic_ops;
>  	struct pv_mmu_ops pv_mmu_ops;
>  	struct pv_lock_ops pv_lock_ops;
> +	struct pv_hotplug_ops pv_hotplug_ops;
>  };
>  
>  extern struct pv_info pv_info;
> @@ -353,6 +360,7 @@ extern struct pv_irq_ops pv_irq_ops;
>  extern struct pv_apic_ops pv_apic_ops;
>  extern struct pv_mmu_ops pv_mmu_ops;
>  extern struct pv_lock_ops pv_lock_ops;
> +extern struct pv_hotplug_ops pv_hotplug_ops;
>  
>  #define PARAVIRT_PATCH(x)					\
>  	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
> @@ -1408,6 +1416,25 @@ static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
>  
>  #endif
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +
> +static inline int __cpu_disable(void)
> +{
> +	return PVOP_CALL0(int, pv_hotplug_ops.cpu_disable);
> +}
> +
> +static inline void __cpu_die(unsigned int cpu)
> +{
> +	PVOP_VCALL1(pv_hotplug_ops.cpu_die, cpu);
> +}
> +
> +static inline void play_dead(void)
> +{
> +	PVOP_VCALL0(pv_hotplug_ops.play_dead);
> +}
> +
> +#endif
> +
>  /* These all sit in the .parainstructions section to tell us what to patch. */
>  struct paravirt_patch_site {
>  	u8 *instr; 		/* original instructions */
> diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
> index 29324c1..f7d153f 100644
> --- a/include/asm-x86/smp.h
> +++ b/include/asm-x86/smp.h
> @@ -113,11 +113,20 @@ void native_smp_prepare_boot_cpu(void);
>  void native_smp_prepare_cpus(unsigned int max_cpus);
>  void native_smp_cpus_done(unsigned int max_cpus);
>  int native_cpu_up(unsigned int cpunum);
> +int native_cpu_disable(void);
> +void native_cpu_die(unsigned int cpu);
> +void native_play_dead(void);
> +
>  void native_send_call_func_ipi(cpumask_t mask);
>  void native_send_call_func_single_ipi(int cpu);
>  
> -extern int __cpu_disable(void);
> -extern void __cpu_die(unsigned int cpu);
> +
> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#else
> +#define __cpu_disable	native_cpu_disable
> +#define __cpu_die	native_cpu_die
> +#endif
>  
>  void smp_store_cpu_info(int id);
>  #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
>   

