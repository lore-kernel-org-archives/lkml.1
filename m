Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab0CIBWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:22:14 -0500
Received: from mga12.intel.com ([143.182.124.36]:25896 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756420Ab0CIBWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:22:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,605,1262592000"; 
   d="scan'208";a="252338441"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension of HVM
Date: Tue, 9 Mar 2010 09:23:32 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <1268032732-8025-8-git-send-email-sheng@linux.intel.com> <alpine.DEB.2.00.1003081656210.16237@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003081656210.16237@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003090923.33000.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010 01:00:52 Stefano Stabellini wrote:
> Have you actually tried booting a guest with 2 vcpus?
> Are you sure it works for you?

I mostly tested my patches with 4 vcpus, so that I can know if the SMP code 
works well.

-- 
regards
Yang, Sheng

> 
> On Mon, 8 Mar 2010, Sheng Yang wrote:
> > We mapped each IOAPIC pin to a VIRQ, so that we can deliver interrupt
> > through these VIRQs.
> >
> > We used X86_PLATFORM_IPI_VECTOR as the notification vector for hypervisor
> > to notify guest about the event.
> >
> > The patch also enabled SMP support, then we can support IPI through
> > evtchn as well.
> >
> > When this feature is enabled, we would relay on Xen PV timer for
> > clockevent, rather than other hardware emulated ones.
> >
> > Then we don't use IOAPIC/LAPIC, eliminated the overhead brought by
> > unnecessary VMExit caused by LAPIC.
> >
> > PV evtchn depends on PV clocksource. To enable it, put following line in
> > the HVM configure file:
> >
> > cpuid = [ '0x40000002:edx=0x7' ]
> >
> > It would enable PV extension framework(bit 0), PV clocksource(bit 1), as
> > well as PV evtchn(bit 2).
> >
> > Notice if you try to enable PV evtchn without other two bits set, the
> > setting would be ignored.
> >
> > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> > ---
> >  arch/x86/xen/enlighten.c    |    6 ++--
> >  arch/x86/xen/hvmpv.c        |   70
> > +++++++++++++++++++++++++++++++++++++++- arch/x86/xen/irq.c          |  
> > 28 ++++++++++++++++
> >  arch/x86/xen/smp.c          |   76
> > ++++++++++++++++++++++++++++++++++++++++-- arch/x86/xen/xen-ops.h      | 
> >  16 +++++++++
> >  drivers/xen/events.c        |   74
> > ++++++++++++++++++++++++++++++++++++++--- include/xen/events.h        |  
> >  4 ++
> >  include/xen/hvm.h           |    5 +++
> >  include/xen/interface/xen.h |    6 +++-
> >  9 files changed, 270 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 36daccb..2d60e70 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -717,7 +717,7 @@ static u32 xen_safe_apic_wait_icr_idle(void)
> >          return 0;
> >  }
> >
> > -static void set_xen_basic_apic_ops(void)
> > +void xen_set_basic_apic_ops(void)
> >  {
> >         apic->read = xen_apic_read;
> >         apic->write = xen_apic_write;
> > @@ -1026,7 +1026,7 @@ static void xen_crash_shutdown(struct pt_regs
> > *regs) xen_reboot(SHUTDOWN_crash);
> >  }
> >
> > -static const struct machine_ops __initdata xen_machine_ops = {
> > +const struct machine_ops __initdata xen_machine_ops = {
> >         .restart = xen_restart,
> >         .halt = xen_machine_halt,
> >         .power_off = xen_machine_halt,
> > @@ -1116,7 +1116,7 @@ asmlinkage void __init xen_start_kernel(void)
> >         /*
> >          * set up the basic apic ops.
> >          */
> > -       set_xen_basic_apic_ops();
> > +       xen_set_basic_apic_ops();
> >  #endif
> >
> >         if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
> > diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
> > index e944caf..97d148d 100644
> > --- a/arch/x86/xen/hvmpv.c
> > +++ b/arch/x86/xen/hvmpv.c
> > @@ -17,6 +17,7 @@
> >  #include <xen/interface/version.h>
> >  #include <xen/interface/memory.h>
> >
> > +#include <asm/reboot.h>
> >  #include <asm/xen/cpuid.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <asm/xen/hypervisor.h>
> > @@ -45,6 +46,8 @@ static void __init xen_hvm_pv_banner(void)
> >                 version >> 16, version & 0xffff, extra.extraversion);
> >         if (xen_hvm_pv_clock_enabled())
> >                 printk(KERN_INFO "PV feature: PV clocksource enabled\n");
> > +       if (xen_hvm_pv_evtchn_enabled())
> > +               printk(KERN_INFO "PV feature: Event channel enabled\n");
> >  }
> >
> >  static int __init xen_para_available(void)
> > @@ -84,9 +87,14 @@ static int __init init_hvm_pv_info(void)
> >         if (!(edx & XEN_CPUID_FEAT2_HVM_PV))
> >                 return -ENODEV;
> >
> > -       if (edx & XEN_CPUID_FEAT2_HVM_PV_CLOCK)
> > +       if (edx & XEN_CPUID_FEAT2_HVM_PV_CLOCK) {
> >                 xen_hvm_pv_features |= XEN_HVM_PV_CLOCK_ENABLED;
> >
> > +               /* Evtchn depends on PV clocksource */
> > +               if (edx & XEN_CPUID_FEAT2_HVM_PV_EVTCHN)
> > +                       xen_hvm_pv_features |= XEN_HVM_PV_EVTCHN_ENABLED;
> > +       }
> > +
> >         if (pages < 1)
> >                 return -ENODEV;
> >
> > @@ -134,6 +142,64 @@ static void __init init_pv_clocksource(void)
> >         xen_register_clocksource();
> >  }
> >
> > +static int set_callback_via(uint64_t via)
> > +{
> > +       struct xen_hvm_param a;
> > +
> > +       a.domid = DOMID_SELF;
> > +       a.index = HVM_PARAM_CALLBACK_IRQ;
> > +       a.value = via;
> > +       return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
> > +}
> > +
> > +void do_hvm_pv_evtchn_intr(void)
> > +{
> > +       per_cpu(irq_count, smp_processor_id())++;
> > +       xen_hvm_evtchn_do_upcall(get_irq_regs());
> > +       per_cpu(irq_count, smp_processor_id())--;
> > +}
> > +
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +static void xen_hvm_pv_evtchn_apic_write(u32 reg, u32 val)
> > +{
> > +       /* The only one reached here should be EOI */
> > +       WARN_ON(reg != APIC_EOI);
> > +}
> > +#endif
> > +
> > +static void __init init_pv_evtchn(void)
> > +{
> > +       uint64_t callback_via;
> > +
> > +       if (!xen_hvm_pv_evtchn_enabled())
> > +               return;
> > +
> > +       xen_hvm_pv_init_irq_ops();
> > +
> > +       x86_init.timers.timer_init = xen_time_init;
> > +       x86_init.timers.setup_percpu_clockev = x86_init_noop;
> > +       x86_cpuinit.setup_percpu_clockev = x86_init_noop;
> > +
> > +       pv_apic_ops.startup_ipi_hook = paravirt_nop;
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +       /*
> > +        * set up the basic apic ops.
> > +        */
> > +       xen_set_basic_apic_ops();
> > +       apic->write = xen_hvm_pv_evtchn_apic_write;
> > +#endif
> > +
> > +       callback_via = HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR);
> > +       set_callback_via(callback_via);
> > +
> > +       x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
> > +
> > +       disable_acpi();
> > +
> > +       xen_hvm_pv_smp_init();
> > +       machine_ops = xen_machine_ops;
> > +}
> > +
> >  void __init xen_guest_init(void)
> >  {
> >         int r;
> > @@ -158,4 +224,6 @@ void __init xen_guest_init(void)
> >         xen_domain_type = XEN_HVM_DOMAIN;
> >
> >         init_pv_clocksource();
> > +
> > +       init_pv_evtchn();
> >  }
> > diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> > index 9d30105..e325640 100644
> > --- a/arch/x86/xen/irq.c
> > +++ b/arch/x86/xen/irq.c
> > @@ -2,6 +2,7 @@
> >
> >  #include <asm/x86_init.h>
> >
> > +#include <xen/xen.h>
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/sched.h>
> >  #include <xen/interface/vcpu.h>
> > @@ -131,3 +132,30 @@ void __init xen_init_irq_ops()
> >         pv_irq_ops = xen_irq_ops;
> >         x86_init.irqs.intr_init = xen_init_IRQ;
> >  }
> > +
> > +#ifdef CONFIG_XEN_HVM_PV
> > +static void xen_hvm_pv_evtchn_disable(void)
> > +{
> > +       native_irq_disable();
> > +       xen_irq_disable();
> > +}
> > +PV_CALLEE_SAVE_REGS_THUNK(xen_hvm_pv_evtchn_disable);
> > +
> > +static void xen_hvm_pv_evtchn_enable(void)
> > +{
> > +       native_irq_enable();
> > +       xen_irq_enable();
> > +}
> > +PV_CALLEE_SAVE_REGS_THUNK(xen_hvm_pv_evtchn_enable);
> > +
> > +void __init xen_hvm_pv_init_irq_ops(void)
> > +{
> > +       if (xen_hvm_pv_evtchn_enabled()) {
> > +               pv_irq_ops.irq_disable =
> > +                       PV_CALLEE_SAVE(xen_hvm_pv_evtchn_disable);
> > +               pv_irq_ops.irq_enable =
> > +                       PV_CALLEE_SAVE(xen_hvm_pv_evtchn_enable);
> > +               x86_init.irqs.intr_init = xen_hvm_pv_evtchn_init_IRQ;
> > +       }
> > +}
> > +#endif
> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index 563d205..a9fd12d 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -15,18 +15,24 @@
> >  #include <linux/sched.h>
> >  #include <linux/err.h>
> >  #include <linux/smp.h>
> > +#include <linux/nmi.h>
> >
> >  #include <asm/paravirt.h>
> >  #include <asm/desc.h>
> >  #include <asm/pgtable.h>
> >  #include <asm/cpu.h>
> > +#include <asm/trampoline.h>
> > +#include <asm/tlbflush.h>
> > +#include <asm/mtrr.h>
> >
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/vcpu.h>
> >
> >  #include <asm/xen/interface.h>
> >  #include <asm/xen/hypercall.h>
> > +#include <asm/xen/hypervisor.h>
> >
> > +#include <xen/xen.h>
> >  #include <xen/page.h>
> >  #include <xen/events.h>
> >
> > @@ -63,8 +69,12 @@ static __cpuinit void cpu_bringup(void)
> >         touch_softlockup_watchdog();
> >         preempt_disable();
> >
> > -       xen_enable_sysenter();
> > -       xen_enable_syscall();
> > +       if (xen_pv_domain()) {
> > +               xen_enable_sysenter();
> > +               xen_enable_syscall();
> > +       }
> > +
> > +       set_mtrr_aps_delayed_init();
> >
> >         cpu = smp_processor_id();
> >         smp_store_cpu_info(cpu);
> > @@ -171,7 +181,8 @@ static void __init xen_smp_prepare_boot_cpu(void)
> >
> >         /* We've switched to the "real" per-cpu gdt, so make sure the
> >            old memory can be recycled */
> > -       make_lowmem_page_readwrite(xen_initial_gdt);
> > +       if (xen_feature(XENFEAT_writable_descriptor_tables))
> > +               make_lowmem_page_readwrite(xen_initial_gdt);
> >
> >         xen_setup_vcpu_info_placement();
> >  }
> > @@ -282,6 +293,39 @@ cpu_initialize_context(unsigned int cpu, struct
> > task_struct *idle) return 0;
> >  }
> >
> > +static __cpuinit int
> > +hvm_pv_cpu_initialize_context(unsigned int cpu, struct task_struct
> > *idle) +{
> > +       struct vcpu_guest_context *ctxt;
> > +       unsigned long start_ip;
> > +
> > +       if (cpumask_test_and_set_cpu(cpu, xen_cpu_initialized_map))
> > +               return 0;
> > +
> > +       ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
> > +       if (ctxt == NULL)
> > +               return -ENOMEM;
> > +
> > +       early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
> > +       initial_code = (unsigned long)cpu_bringup_and_idle;
> > +       stack_start.sp = (void *) idle->thread.sp;
> > +
> > +       /* start_ip had better be page-aligned! */
> > +       start_ip = setup_trampoline();
> > +
> > +       /* only start_ip is what we want */
> > +       ctxt->flags = VGCF_HVM_GUEST;
> > +       ctxt->user_regs.eip = start_ip;
> > +
> > +       printk(KERN_INFO "Booting processor %d ip 0x%lx\n", cpu,
> > start_ip); +
> > +       if (HYPERVISOR_vcpu_op(VCPUOP_initialise, cpu, ctxt))
> > +               BUG();
> > +
> > +       kfree(ctxt);
> > +       return 0;
> > +}
> > +
> >  static int __cpuinit xen_cpu_up(unsigned int cpu)
> >  {
> >         struct task_struct *idle = idle_task(cpu);
> > @@ -292,6 +336,7 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
> >         irq_ctx_init(cpu);
> >  #else
> >         clear_tsk_thread_flag(idle, TIF_FORK);
> > +       initial_gs = per_cpu_offset(cpu);
> >         per_cpu(kernel_stack, cpu) =
> >                 (unsigned long)task_stack_page(idle) -
> >                 KERNEL_STACK_OFFSET + THREAD_SIZE;
> > @@ -305,7 +350,13 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
> >         /* make sure interrupts start blocked */
> >         per_cpu(xen_vcpu, cpu)->evtchn_upcall_mask = 1;
> >
> > -       rc = cpu_initialize_context(cpu, idle);
> > +       if (xen_pv_domain())
> > +               rc = cpu_initialize_context(cpu, idle);
> > +       else if (xen_hvm_pv_evtchn_enabled())
> > +               rc = hvm_pv_cpu_initialize_context(cpu, idle);
> > +       else
> > +               BUG();
> > +
> >         if (rc)
> >                 return rc;
> >
> > @@ -480,3 +531,20 @@ void __init xen_smp_init(void)
> >         xen_fill_possible_map();
> >         xen_init_spinlocks();
> >  }
> > +
> > +#ifdef CONFIG_XEN_HVM_PV
> > +static void xen_hvm_pv_flush_tlb_others(const struct cpumask *cpumask,
> > +                                       struct mm_struct *mm, unsigned
> > long va) +{
> > +       /* TODO Make it more specific */
> > +       flush_tlb_all();
> > +}
> > +
> > +void __init xen_hvm_pv_smp_init(void)
> > +{
> > +       if (xen_hvm_pv_evtchn_enabled()) {
> > +               smp_ops = xen_smp_ops;
> > +               pv_mmu_ops.flush_tlb_others =
> > xen_hvm_pv_flush_tlb_others; +       }
> > +}
> > +#endif
> > diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> > index d56b660..4de9874 100644
> > --- a/arch/x86/xen/xen-ops.h
> > +++ b/arch/x86/xen/xen-ops.h
> > @@ -52,6 +52,12 @@ void xen_register_clocksource(void);
> >  unsigned long xen_get_wallclock(void);
> >  int xen_set_wallclock(unsigned long time);
> >  unsigned long long xen_sched_clock(void);
> > +void xen_set_basic_apic_ops(void);
> > +
> > +#ifdef CONFIG_XEN_HVM_PV
> > +void __init xen_hvm_pv_init_irq_ops(void);
> > +void __init xen_hvm_pv_evtchn_init_IRQ(void);
> > +#endif /* CONFIG_XEN_HVM_PV */
> >
> >  irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
> >
> > @@ -62,9 +68,17 @@ void xen_setup_vcpu_info_placement(void);
> >  #ifdef CONFIG_SMP
> >  void xen_smp_init(void);
> >
> > +#ifdef CONFIG_XEN_HVM_PV
> > +void xen_hvm_pv_smp_init(void);
> > +#endif /* CONFIG_XEN_HVM_PV */
> > +
> >  extern cpumask_var_t xen_cpu_initialized_map;
> >  #else
> >  static inline void xen_smp_init(void) {}
> > +#ifdef CONFIG_XEN_HVM_PV
> > +static inline void xen_hvm_pv_smp_init(void) {}
> > +#endif /* CONFIG_XEN_HVM_PV */
> > +
> >  #endif
> >
> >  #ifdef CONFIG_PARAVIRT_SPINLOCKS
> > @@ -102,4 +116,6 @@ void xen_sysret32(void);
> >  void xen_sysret64(void);
> >  void xen_adjust_exception_frame(void);
> >
> > +extern const struct machine_ops xen_machine_ops;
> > +
> >  #endif /* XEN_OPS_H */
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index ce602dd..e4b9de6 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -32,14 +32,17 @@
> >  #include <asm/irq.h>
> >  #include <asm/idle.h>
> >  #include <asm/sync_bitops.h>
> > +#include <asm/desc.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <asm/xen/hypervisor.h>
> >
> > +#include <xen/xen.h>
> >  #include <xen/xen-ops.h>
> >  #include <xen/events.h>
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/event_channel.h>
> >
> > +
> >  /*
> >   * This lock protects updates to the following mapping and
> > reference-count * arrays. The lock does not need to be acquired to read
> > the mapping tables. @@ -616,17 +619,13 @@ static DEFINE_PER_CPU(unsigned,
> > xed_nesting_count); * a bitset of words which contain pending event bits.
> >  The second * level is a bitset of pending events themselves.
> >   */
> > -void xen_evtchn_do_upcall(struct pt_regs *regs)
> > +void __xen_evtchn_do_upcall(struct pt_regs *regs)
> >  {
> >         int cpu = get_cpu();
> > -       struct pt_regs *old_regs = set_irq_regs(regs);
> >         struct shared_info *s = HYPERVISOR_shared_info;
> >         struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
> >         unsigned count;
> >
> > -       exit_idle();
> > -       irq_enter();
> > -
> >         do {
> >                 unsigned long pending_words;
> >
> > @@ -662,10 +661,25 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
> >         } while(count != 1);
> >
> >  out:
> > +       put_cpu();
> > +}
> > +
> > +void xen_evtchn_do_upcall(struct pt_regs *regs)
> > +{
> > +       struct pt_regs *old_regs = set_irq_regs(regs);
> > +
> > +       exit_idle();
> > +       irq_enter();
> > +
> > +       __xen_evtchn_do_upcall(regs);
> > +
> >         irq_exit();
> >         set_irq_regs(old_regs);
> > +}
> >
> > -       put_cpu();
> > +void xen_hvm_evtchn_do_upcall(struct pt_regs *regs)
> > +{
> > +       __xen_evtchn_do_upcall(regs);
> >  }
> >
> >  /* Rebind a new event channel to an existing irq. */
> > @@ -944,3 +958,51 @@ void __init xen_init_IRQ(void)
> >
> >         irq_ctx_init(smp_processor_id());
> >  }
> > +
> > +void __init xen_hvm_pv_evtchn_init_IRQ(void)
> > +{
> > +       int i;
> > +
> > +       xen_init_IRQ();
> > +       for (i = 0; i < NR_IRQS_LEGACY; i++) {
> > +               struct evtchn_bind_virq bind_virq;
> > +               struct irq_desc *desc = irq_to_desc(i);
> > +               int virq, evtchn;
> > +
> > +               virq = i + VIRQ_EMUL_PIN_START;
> > +               bind_virq.virq = virq;
> > +               bind_virq.vcpu = 0;
> > +
> > +               if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
> > +                                               &bind_virq) != 0)
> > +                       BUG();
> > +
> > +               evtchn = bind_virq.port;
> > +               evtchn_to_irq[evtchn] = i;
> > +               irq_info[i] = mk_virq_info(evtchn, virq);
> > +
> > +               desc->status = IRQ_DISABLED;
> > +               desc->action = NULL;
> > +               desc->depth = 1;
> > +
> > +               /*
> > +                * 16 old-style INTA-cycle interrupts:
> > +                */
> > +               set_irq_chip_and_handler_name(i, &xen_dynamic_chip,
> > +                                       handle_level_irq, "event");
> > +       }
> > +
> > +       /*
> > +        * Cover the whole vector space, no vector can escape
> > +        * us. (some of these will be overridden and become
> > +        * 'special' SMP interrupts)
> > +        */
> > +       for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
> > +               int vector = FIRST_EXTERNAL_VECTOR + i;
> > +               if (vector != IA32_SYSCALL_VECTOR)
> > +                       set_intr_gate(vector, interrupt[i]);
> > +       }
> > +
> > +       /* generic IPI for platform specific use, now used for HVM evtchn
> > */ +       alloc_intr_gate(X86_PLATFORM_IPI_VECTOR, x86_platform_ipi); +}
> > diff --git a/include/xen/events.h b/include/xen/events.h
> > index e68d59a..b9fbb3b 100644
> > --- a/include/xen/events.h
> > +++ b/include/xen/events.h
> > @@ -56,4 +56,8 @@ void xen_poll_irq(int irq);
> >  /* Determine the IRQ which is bound to an event channel */
> >  unsigned irq_from_evtchn(unsigned int evtchn);
> >
> > +#ifdef CONFIG_XEN_HVM_PV
> > +void xen_hvm_evtchn_do_upcall(struct pt_regs *regs);
> > +#endif
> > +
> >  #endif /* _XEN_EVENTS_H */
> > diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> > index 4ea8887..c66d788 100644
> > --- a/include/xen/hvm.h
> > +++ b/include/xen/hvm.h
> > @@ -20,4 +20,9 @@ static inline unsigned long hvm_get_parameter(int idx)
> >         return xhv.value;
> >  }
> >
> > +#define HVM_CALLBACK_VIA_TYPE_VECTOR 0x2
> > +#define HVM_CALLBACK_VIA_TYPE_SHIFT 56
> > +#define HVM_CALLBACK_VECTOR(x)
> > (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\ +                           
> >    HVM_CALLBACK_VIA_TYPE_SHIFT | (x)) +
> >  #endif /* XEN_HVM_H__ */
> > diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> > index 2befa3e..70a6c6e 100644
> > --- a/include/xen/interface/xen.h
> > +++ b/include/xen/interface/xen.h
> > @@ -90,7 +90,11 @@
> >  #define VIRQ_ARCH_6    22
> >  #define VIRQ_ARCH_7    23
> >
> > -#define NR_VIRQS       24
> > +#define VIRQ_EMUL_PIN_START 24
> > +#define VIRQ_EMUL_PIN_NUM 16
> > +
> > +#define NR_VIRQS       (VIRQ_EMUL_PIN_START + VIRQ_EMUL_PIN_NUM)
> > +
> >  /*
> >   * MMU-UPDATE REQUESTS
> >   *
> > --
> > 1.5.4.5
> >
> >
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xensource.com
> > http://lists.xensource.com/xen-devel
> 
