Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYHUShW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYHUShW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYHUShI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:37:08 -0400
Received: from gw.goop.org ([64.81.55.164]:54319 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYHUShF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:37:05 -0400
Message-ID: <48ADB5CF.3050209@goop.org>
Date: Thu, 21 Aug 2008 11:37:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 7/7] Xen:  Implement CPU hotplugging
References: <> <1219341888-23191-1-git-send-email-alex.nixon@citrix.com> <1219341888-23191-2-git-send-email-alex.nixon@citrix.com> <1219341888-23191-3-git-send-email-alex.nixon@citrix.com> <1219341888-23191-4-git-send-email-alex.nixon@citrix.com> <1219341888-23191-5-git-send-email-alex.nixon@citrix.com> <1219341888-23191-6-git-send-email-alex.nixon@citrix.com> <1219341888-23191-7-git-send-email-alex.nixon@citrix.com>
In-Reply-To: <1219341888-23191-7-git-send-email-alex.nixon@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> Note the changes from 2.6.18-xen CPU hotplugging:
>
> A vcpu_down request from the remote admin via Xenbus both hotunplugs the CPU, and disables it by removing it from the cpu_present map, and removing its entry in /sys
>
> A vcpu_up request from the remote admin only re-enables the CPU, and does not immediately bring the CPU up.  A udev event is emitted, which can be caught by the user if he wishes to automatically re-up CPUs when available, or implement a more complex policy.
>   

Good, that's better.

> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/xen/enlighten.c  |    7 +++
>  arch/x86/xen/irq.c        |    2 +-
>  arch/x86/xen/smp.c        |   52 +++++++++++++++++++++-----
>  arch/x86/xen/spinlock.c   |    5 ++
>  arch/x86/xen/time.c       |    8 ++++
>  arch/x86/xen/xen-ops.h    |    6 +++
>  drivers/xen/Makefile      |    2 +-
>  drivers/xen/cpu_hotplug.c |   90 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/xen/events.c      |    4 ++
>  9 files changed, 164 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/xen/cpu_hotplug.c
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index c421049..204d64b 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1342,6 +1342,12 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
>  	.set_fixmap = xen_set_fixmap,
>  };
>  
> +static const struct pv_hotplug_ops xen_hotplug_ops = {
> +	.play_dead = xen_play_dead,
> +	.cpu_disable = xen_cpu_disable,
> +	.cpu_die = xen_cpu_die,
> +};
> +
>  static void xen_reboot(int reason)
>  {
>  	struct sched_shutdown r = { .reason = reason };
> @@ -1655,6 +1661,7 @@ asmlinkage void __init xen_start_kernel(void)
>  	pv_cpu_ops = xen_cpu_ops;
>  	pv_apic_ops = xen_apic_ops;
>  	pv_mmu_ops = xen_mmu_ops;
> +	pv_hotplug_ops = xen_hotplug_ops;
>  
>  	xen_init_irq_ops();
>  
> diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> index 4e3f7f7..f33f75b 100644
> --- a/arch/x86/xen/irq.c
> +++ b/arch/x86/xen/irq.c
> @@ -134,7 +134,7 @@ static const struct pv_irq_ops xen_irq_ops __initdata = {
>  	.restore_fl = xen_restore_fl,
>  	.irq_disable = xen_irq_disable,
>  	.irq_enable = xen_irq_enable,
> -	.wb_invd_halt = xen_wbinvd_halt,
> +	.wbinvd_halt = xen_wbinvd_halt,
>   

What's this?  A typo fix?  It should be folded back to the appropriate
patch (except for the fact that I think this op should be gone).

>  	.safe_halt = xen_safe_halt,
>  	.halt = xen_halt,
>  #ifdef CONFIG_X86_64
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index baca7f2..682eaa4 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -12,7 +12,6 @@
>   * result, all CPUs are treated as if they're single-core and
>   * single-threaded.
>   *
> - * This does not handle HOTPLUG_CPU yet.
>   
Remove the blank line too.
>   */
>  #include <linux/sched.h>
>  #include <linux/err.h>
> @@ -61,11 +60,12 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static __cpuinit void cpu_bringup_and_idle(void)
> +static __cpuinit void cpu_bringup(void)
>  {
>  	int cpu = smp_processor_id();
>  
>  	cpu_init();
> +	touch_softlockup_watchdog();
>  	preempt_disable();
>  
>  	xen_enable_sysenter();
> @@ -86,6 +86,11 @@ static __cpuinit void cpu_bringup_and_idle(void)
>  	local_irq_enable();
>  
>  	wmb();			/* make sure everything is out */
> +}
> +
> +static __cpuinit void cpu_bringup_and_idle(void)
> +{
> +	cpu_bringup();
>  	cpu_idle();
>  }
>  
> @@ -209,8 +214,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>  
>  		cpu_set(cpu, cpu_present_map);
>  	}
> -
> -	//init_xenbus_allowed_cpumask();
>  }
>  
>  static __cpuinit int
> @@ -278,12 +281,6 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
>  	struct task_struct *idle = idle_task(cpu);
>  	int rc;
>  
> -#if 0
> -	rc = cpu_up_check(cpu);
> -	if (rc)
> -		return rc;
> -#endif
> -
>  #ifdef CONFIG_X86_64
>  	/* Allocate node local memory for AP pdas */
>  	WARN_ON(cpu == 0);
> @@ -336,6 +333,41 @@ static void xen_smp_cpus_done(unsigned int max_cpus)
>  {
>  }
>  
> +int xen_cpu_disable(void)
> +{
> +	unsigned int cpu = smp_processor_id();
> +	if (cpu == 0)
> +		return -EBUSY;
> +
> +	cpu_disable_common();
> +
> +	load_cr3(swapper_pg_dir);
> +	return 0;
> +}
> +
> +void xen_cpu_die(unsigned int cpu)
> +{
> +	while (HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL)) {
> +		current->state = TASK_UNINTERRUPTIBLE;
> +		schedule_timeout(HZ/10);
> +	}
> +	unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
> +	unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
> +	unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
> +	unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
> +	xen_uninit_lock_cpu(cpu);
> +	xen_teardown_timer(cpu);
> +
> +	if (num_online_cpus() == 1)
> +		alternatives_smp_switch(0);
> +}
> +
> +void xen_play_dead(void)
> +{
> +	native_play_dead();
> +	cpu_bringup();
>   

No, call common_play_dead(), then xen_halt(), then cpu_bringup().

> +}
> +
>  static void stop_self(void *v)
>  {
>  	int cpu = smp_processor_id();
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index bfb1707..74a5114 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -173,6 +173,11 @@ void __cpuinit xen_init_lock_cpu(int cpu)
>  	printk("cpu %d spinlock event irq %d\n", cpu, irq);
>  }
>  
> +void xen_uninit_lock_cpu(int cpu)
> +{
> +	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
> +}
> +
>  void __init xen_init_spinlocks(void)
>  {
>  	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 685b774..8034d69 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -452,6 +452,14 @@ void xen_setup_timer(int cpu)
>  	setup_runstate_info(cpu);
>  }
>  
> +void xen_teardown_timer(int cpu)
> +{
> +	struct clock_event_device *evt;
> +	BUG_ON(cpu == 0);
> +	evt = &per_cpu(xen_clock_events, cpu);
> +	unbind_from_irqhandler(evt->irq, NULL);
> +}
> +
>  void xen_setup_cpu_clockevents(void)
>  {
>  	BUG_ON(preemptible());
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index 3c70ebc..a16e5b5 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -33,6 +33,7 @@ void __init xen_build_dynamic_phys_to_machine(void);
>  
>  void xen_init_irq_ops(void);
>  void xen_setup_timer(int cpu);
> +void xen_teardown_timer(int cpu);
>  void xen_setup_cpu_clockevents(void);
>  unsigned long xen_tsc_khz(void);
>  void __init xen_time_init(void);
> @@ -48,11 +49,16 @@ void xen_mark_init_mm_pinned(void);
>  
>  void __init xen_setup_vcpu_info_placement(void);
>  
> +void xen_play_dead(void);
> +void xen_cpu_die(unsigned int cpu);
> +int xen_cpu_disable(void);
> +
>  #ifdef CONFIG_SMP
>  void xen_smp_init(void);
>  
>  void __init xen_init_spinlocks(void);
>  __cpuinit void xen_init_lock_cpu(int cpu);
> +void xen_uninit_lock_cpu(int cpu);
>  
>  extern cpumask_t xen_cpu_initialized_map;
>  #else
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 363286c..f62d8df 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,4 +1,4 @@
> -obj-y	+= grant-table.o features.o events.o manage.o
> +obj-y	+= grant-table.o features.o events.o manage.o cpu_hotplug.o
>  obj-y	+= xenbus/
>  obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
>  obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
> diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
> new file mode 100644
> index 0000000..f1727ce
> --- /dev/null
> +++ b/drivers/xen/cpu_hotplug.c
> @@ -0,0 +1,90 @@
> +#include <linux/notifier.h>
> +
> +#include <xen/xenbus.h>
> +
> +#include <asm-x86/xen/hypervisor.h>
> +#include <asm/cpu.h>
> +
> +static void enable_hotplug_cpu(int cpu)
> +{
> +	if (!cpu_present(cpu))
> +		arch_register_cpu(cpu);
> +
> +	cpu_set(cpu, cpu_present_map);
> +}
> +
> +static void disable_hotplug_cpu(int cpu)
> +{
> +	if (cpu_present(cpu))
> +		arch_unregister_cpu(cpu);
> +
> +	cpu_clear(cpu, cpu_present_map);
> +}
> +
> +static void vcpu_hotplug(unsigned int cpu)
> +{
> +	int err;
> +	char dir[32], state[32];
> +
> +	if (!cpu_possible(cpu))
> +		return;
> +
> +	sprintf(dir, "cpu/%u", cpu);
> +	err = xenbus_scanf(XBT_NIL, dir, "availability", "%s", state);
> +	if (err != 1) {
> +		printk(KERN_ERR "XENBUS: Unable to read cpu state\n");
> +		return;
> +	}
> +
> +	if (strcmp(state, "online") == 0) {
> +		enable_hotplug_cpu(cpu);
> +	} else if (strcmp(state, "offline") == 0) {
> +		(void)cpu_down(cpu);
> +		disable_hotplug_cpu(cpu);
> +	} else {
> +		printk(KERN_ERR "XENBUS: unknown state(%s) on CPU%d\n",
> +		       state, cpu);
> +	}
> +}
> +
> +static void handle_vcpu_hotplug_event(
> +	struct xenbus_watch *watch, const char **vec, unsigned int len)
>   

Fix the formatting here (split the line at a ',').

> +{
> +	unsigned int cpu;
> +	char *cpustr;
> +	const char *node = vec[XS_WATCH_PATH];
> +
> +	cpustr = strstr(node, "cpu/");
> +	if (cpustr != NULL) {
> +		sscanf(cpustr, "cpu/%u", &cpu);
> +		vcpu_hotplug(cpu);
> +	}
> +}
> +
> +static int setup_cpu_watcher(struct notifier_block *notifier,
> +			      unsigned long event, void *data)
> +{
> +	static struct xenbus_watch cpu_watch = {
> +		.node = "cpu",
> +		.callback = handle_vcpu_hotplug_event};
> +
> +	(void)register_xenbus_watch(&cpu_watch);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static int __init setup_vcpu_hotplug_event(void)
> +{
> +	static struct notifier_block xsn_cpu = {
> +		.notifier_call = setup_cpu_watcher };
> +
> +	if (!is_running_on_xen())
> +		return -ENODEV;
> +
> +	register_xenstore_notifier(&xsn_cpu);
> +
> +	return 0;
> +}
> +
> +arch_initcall(setup_vcpu_hotplug_event);
> +
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 2a49ffc..63ca861 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -358,6 +358,10 @@ static void unbind_from_irq(unsigned int irq)
>  			per_cpu(virq_to_irq, cpu_from_evtchn(evtchn))
>  				[index_from_irq(irq)] = -1;
>  			break;
> +		case IRQT_IPI:
> +			per_cpu(ipi_to_irq, cpu_from_evtchn(evtchn))
> +				[index_from_irq(irq)] = -1;
> +			break;
>  		default:
>  			break;
>  		}
>   

