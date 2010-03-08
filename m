Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0CHWQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:16:38 -0500
Received: from claw.goop.org ([74.207.240.146]:54577 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab0CHWQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:16:35 -0500
Message-ID: <4B95773E.1090608@goop.org>
Date: Mon, 08 Mar 2010 14:16:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>, Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension
 of HVM
References: <1267769277-20522-1-git-send-email-sheng@linux.intel.com> <1267769277-20522-8-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1267769277-20522-8-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 10:07 PM, Sheng Yang wrote:
> We mapped each IOAPIC pin to a VIRQ, so that we can deliver interrupt through
> these VIRQs.
>
> We used X86_PLATFORM_IPI_VECTOR as the notification vector for hypervisor
> to notify guest about the event.
>
> The patch also enabled SMP support, then we can support IPI through evtchn as well.
>
> When this feature is enabled, we would relay on Xen PV timer for clockevent,
> rather than other hardware emulated ones.
>
> Then we don't use IOAPIC/LAPIC, eliminated the overhead brought by
> unnecessary VMExit caused by LAPIC.
>
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> ---
>   arch/x86/xen/enlighten.c    |    6 ++--
>   arch/x86/xen/hvmpv.c        |   59 +++++++++++++++++++++++++++++++++
>   arch/x86/xen/irq.c          |   28 ++++++++++++++++
>   arch/x86/xen/smp.c          |   76 ++++++++++++++++++++++++++++++++++++++++--
>   arch/x86/xen/xen-ops.h      |   16 +++++++++
>   drivers/xen/events.c        |   74 ++++++++++++++++++++++++++++++++++++++---
>   include/xen/events.h        |    4 ++
>   include/xen/hvm.h           |    5 +++
>   include/xen/interface/xen.h |    6 +++-
>   9 files changed, 260 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 36daccb..2d60e70 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -717,7 +717,7 @@ static u32 xen_safe_apic_wait_icr_idle(void)
>           return 0;
>   }
>
> -static void set_xen_basic_apic_ops(void)
> +void xen_set_basic_apic_ops(void)
>   {
>   	apic->read = xen_apic_read;
>   	apic->write = xen_apic_write;
> @@ -1026,7 +1026,7 @@ static void xen_crash_shutdown(struct pt_regs *regs)
>   	xen_reboot(SHUTDOWN_crash);
>   }
>
> -static const struct machine_ops __initdata xen_machine_ops = {
> +const struct machine_ops __initdata xen_machine_ops = {
>   	.restart = xen_restart,
>   	.halt = xen_machine_halt,
>   	.power_off = xen_machine_halt,
> @@ -1116,7 +1116,7 @@ asmlinkage void __init xen_start_kernel(void)
>   	/*
>   	 * set up the basic apic ops.
>   	 */
> -	set_xen_basic_apic_ops();
> +	xen_set_basic_apic_ops();
>   #endif
>
>   	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
> diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
> index 305dcca..673b036 100644
> --- a/arch/x86/xen/hvmpv.c
> +++ b/arch/x86/xen/hvmpv.c
> @@ -17,6 +17,7 @@
>   #include<xen/interface/version.h>
>   #include<xen/interface/memory.h>
>
> +#include<asm/reboot.h>
>   #include<asm/xen/cpuid.h>
>   #include<asm/xen/hypercall.h>
>   #include<asm/xen/hypervisor.h>
> @@ -44,6 +45,8 @@ static void __init xen_hvm_pv_banner(void)
>   	printk(KERN_INFO "Xen version: %d.%d%s\n",
>   		version>>  16, version&  0xffff, extra.extraversion);
>   	printk(KERN_INFO "PV feature: PV clocksource enabled\n");
> +	if (xen_hvm_pv_evtchn_enabled())
> +		printk(KERN_INFO "PV feature: Event channel enabled\n");
>   }
>
>   static int __init xen_para_available(void)
> @@ -83,6 +86,9 @@ static int __init init_hvm_pv_info(void)
>   	if (!(edx&  XEN_CPUID_FEAT2_HVM_PV))
>   		return -ENODEV;
>
> +	if (edx&  XEN_CPUID_FEAT2_HVM_PV_EVTCHN)
> +		xen_hvm_pv_features |= XEN_HVM_PV_EVTCHN_ENABLED;
> +
>   	if (pages<  1)
>   		return -ENODEV;
>
> @@ -127,9 +133,35 @@ static void __init init_pv_clocksource(void)
>   	xen_register_clocksource();
>   }
>
> +static int set_callback_via(uint64_t via)
> +{
> +	struct xen_hvm_param a;
> +
> +	a.domid = DOMID_SELF;
> +	a.index = HVM_PARAM_CALLBACK_IRQ;
> +	a.value = via;
> +	return HYPERVISOR_hvm_op(HVMOP_set_param,&a);
> +}
> +
> +void do_hvm_pv_evtchn_intr(void)
> +{
> +	per_cpu(irq_count, smp_processor_id())++;
> +	xen_hvm_evtchn_do_upcall(get_irq_regs());
> +	per_cpu(irq_count, smp_processor_id())--;
> +}
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +static void xen_hvm_pv_evtchn_apic_write(u32 reg, u32 val)
> +{
> +	/* The only one reached here should be EOI */
> +	WARN_ON(reg != APIC_EOI);
> +}
> +#endif
> +
>   void __init xen_guest_init(void)
>   {
>   	int r;
> +	uint64_t callback_via;
>
>   	/* Ensure the we won't confused with others */
>   	if (xen_domain())
> @@ -152,4 +184,31 @@ void __init xen_guest_init(void)
>   	init_pv_clocksource();
>
>   	xen_domain_type = XEN_HVM_DOMAIN;
> +
> +	if (xen_hvm_pv_evtchn_enabled()) {
> +		xen_hvm_pv_init_irq_ops();
> +
> +		x86_init.timers.timer_init = xen_time_init;
> +		x86_init.timers.setup_percpu_clockev = x86_init_noop;
> +		x86_cpuinit.setup_percpu_clockev = x86_init_noop;
> +
> +		pv_apic_ops.startup_ipi_hook = paravirt_nop;
> +#ifdef CONFIG_X86_LOCAL_APIC
> +		/*
> +		 * set up the basic apic ops.
> +		 */
> +		xen_set_basic_apic_ops();
> +		apic->write = xen_hvm_pv_evtchn_apic_write;
> +#endif
> +
> +		callback_via = HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR);
> +		set_callback_via(callback_via);
> +
> +		x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
> +
> +		disable_acpi();
> +
> +		xen_hvm_pv_smp_init();
> +		machine_ops = xen_machine_ops;
> +	}
>   }
> diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> index 9d30105..e325640 100644
> --- a/arch/x86/xen/irq.c
> +++ b/arch/x86/xen/irq.c
> @@ -2,6 +2,7 @@
>
>   #include<asm/x86_init.h>
>
> +#include<xen/xen.h>
>   #include<xen/interface/xen.h>
>   #include<xen/interface/sched.h>
>   #include<xen/interface/vcpu.h>
> @@ -131,3 +132,30 @@ void __init xen_init_irq_ops()
>   	pv_irq_ops = xen_irq_ops;
>   	x86_init.irqs.intr_init = xen_init_IRQ;
>   }
> +
> +#ifdef CONFIG_XEN_HVM_PV
> +static void xen_hvm_pv_evtchn_disable(void)
> +{
> +	native_irq_disable();
> +	xen_irq_disable();
> +}
> +PV_CALLEE_SAVE_REGS_THUNK(xen_hvm_pv_evtchn_disable);
> +
> +static void xen_hvm_pv_evtchn_enable(void)
> +{
> +	native_irq_enable();
> +	xen_irq_enable();
> +}
>    

Why is it necessary to disable both the event mask and eflags.IF?  
Surely IF is enough?

If it is necessary here, why not for save/restore flags?


     J
