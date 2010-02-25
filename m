Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab0BYRYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:24:52 -0500
Received: from relay3.sgi.com ([192.48.152.1]:45738 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933011Ab0BYRYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:24:50 -0500
Date: Thu, 25 Feb 2010 11:24:47 -0600
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, rja@sgi.com
Subject: Re: [PATCH] x86: Enable NMI on all cpus on UV
Message-ID: <20100225172447.GC27785@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20100217165049.GA26331@sgi.com> <20100222103853.GA14522@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20100222103853.GA14522@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 22, 2010 at 11:38:53AM +0100, Ingo Molnar wrote:
> 
> * Russ Anderson <rja@sgi.com> wrote:
> 
> > Enable NMI on all cpus in UV system and add an NMI handler
> > to dump_stack on each cpu.
> > 
> > Signed-off-by: Russ Anderson <rja@sgi.com>
[...]
> >  						 struct mm_struct *mm,
> > Index: linux/arch/x86/kernel/smpboot.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/smpboot.c	2010-02-17 10:21:55.000000000 -0600
> > +++ linux/arch/x86/kernel/smpboot.c	2010-02-17 10:32:20.000000000 -0600
> > @@ -320,6 +320,8 @@ notrace static void __cpuinit start_seco
> >  	unlock_vector_lock();
> >  	ipi_call_unlock();
> >  	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
> > +	if (is_uv_system())
> > +		uv_nmi_init();
> 
> Instead of cramming it into the init sequence open-coded, shouldnt this be 
> done via the x86_platform driver mechanism?

Attached is the updated patch with the x86_platform driver mechanism
used for uv_nmi_init.

> Thanks,
> 
> 	Ingo

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=uv_nmi_handler

Enable NMI on all cpus in UV system and add an NMI handler
to dump_stack on each cpu.

Signed-off-by: Russ Anderson <rja@sgi.com>

---

By default on x86 all the cpus except the boot cpu have NMI
masked off.  This patch enables NMI on all cpus in UV system
and adds an NMI handler to dump_stack on each cpu.  This
way if a system hangs we can NMI the machine and get a 
backtrace from all the cpus.

Version 2: Use x86_platform driver mechanism for nmi init, per
Ingo's suggestion.


 arch/x86/include/asm/nmi.h         |    1 
 arch/x86/include/asm/uv/uv.h       |    1 
 arch/x86/include/asm/x86_init.h    |    2 +
 arch/x86/kernel/apic/x2apic_uv_x.c |   50 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c          |    6 ++++
 arch/x86/kernel/x86_init.c         |    2 +
 6 files changed, 62 insertions(+)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-02-25 11:01:50.929770347 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-02-25 11:02:17.622069711 -0600
@@ -20,6 +20,7 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/kdebug.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -71,6 +72,7 @@ static int __init uv_acpi_madt_oem_check
 	if (!strcmp(oem_id, "SGI")) {
 		nodeid = early_get_nodeid();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
+		x86_platform.nmi_init =  uv_nmi_init;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -569,6 +571,53 @@ void __cpuinit uv_cpu_init(void)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
 
+/*
+ * When NMI is received, print a stack trace.
+ */
+int uv_handle_nmi(struct notifier_block *self,
+		  unsigned long reason, void *data)
+{
+	unsigned long flags;
+	static DEFINE_SPINLOCK(uv_nmi_lock);
+
+	if (reason != DIE_NMI_IPI)
+		return NOTIFY_OK;
+	/*
+	 * Use a lock so only one cpu prints at a time
+	 * to prevent intermixed output.
+	 */
+	spin_lock_irqsave(&uv_nmi_lock, flags);
+	printk(KERN_INFO "NMI stack dump cpu %u:\n",
+				smp_processor_id());
+	dump_stack();
+	spin_unlock_irqrestore(&uv_nmi_lock, flags);
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block uv_dump_stack_nmi_nb = {
+  .notifier_call = uv_handle_nmi,
+  .next = NULL,
+  .priority = 0
+};
+
+void uv_register_nmi_notifier(void)
+{
+	if (register_die_notifier(&uv_dump_stack_nmi_nb))
+		printk(KERN_WARNING "UV NMI handler failed to register\n");
+}
+
+void uv_nmi_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * Unmask NMI on all cpus
+	 */
+	value = apic_read(APIC_LVT1) | APIC_DM_NMI;
+	value &= ~APIC_LVT_MASKED;
+	apic_write(APIC_LVT1, value);
+}
 
 void __init uv_system_init(void)
 {
@@ -690,5 +739,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 }
Index: linux/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv.h	2010-02-25 11:01:48.131694174 -0600
+++ linux/arch/x86/include/asm/uv/uv.h	2010-02-25 11:02:17.622069711 -0600
@@ -11,6 +11,7 @@ struct mm_struct;
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
+extern void uv_nmi_init(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
Index: linux/arch/x86/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot.c	2010-02-25 11:01:50.929770347 -0600
+++ linux/arch/x86/kernel/smpboot.c	2010-02-25 11:02:17.664720876 -0600
@@ -263,6 +263,11 @@ static void __cpuinit smp_callin(void)
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
 }
 
+void default_nmi_init(void)
+{
+	return;
+}
+
 /*
  * Activate a secondary processor.
  */
@@ -320,6 +325,7 @@ notrace static void __cpuinit start_seco
 	unlock_vector_lock();
 	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+	x86_platform.nmi_init();
 
 	/* enable local interrupts */
 	local_irq_enable();
Index: linux/arch/x86/include/asm/x86_init.h
===================================================================
--- linux.orig/arch/x86/include/asm/x86_init.h	2010-02-25 11:01:48.131694174 -0600
+++ linux/arch/x86/include/asm/x86_init.h	2010-02-25 11:02:17.696714616 -0600
@@ -126,6 +126,7 @@ struct x86_cpuinit_ops {
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
+ * @nmi_init			enable NMI on cpus
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -133,6 +134,7 @@ struct x86_platform_ops {
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
+	void (*nmi_init)(void);
 };
 
 extern struct x86_init_ops x86_init;
Index: linux/arch/x86/kernel/x86_init.c
===================================================================
--- linux.orig/arch/x86/kernel/x86_init.c	2010-02-25 11:01:47.848760574 -0600
+++ linux/arch/x86/kernel/x86_init.c	2010-02-25 11:02:17.732996103 -0600
@@ -13,6 +13,7 @@
 #include <asm/e820.h>
 #include <asm/time.h>
 #include <asm/irq.h>
+#include <asm/nmi.h>
 #include <asm/pat.h>
 #include <asm/tsc.h>
 #include <asm/iommu.h>
@@ -82,4 +83,5 @@ struct x86_platform_ops x86_platform = {
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
+	.nmi_init			= default_nmi_init
 };
Index: linux/arch/x86/include/asm/nmi.h
===================================================================
--- linux.orig/arch/x86/include/asm/nmi.h	2010-02-25 11:01:48.131694174 -0600
+++ linux/arch/x86/include/asm/nmi.h	2010-02-25 11:02:17.756721420 -0600
@@ -24,6 +24,7 @@ extern int reserve_perfctr_nmi(unsigned 
 extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
 extern void release_evntsel_nmi(unsigned int);
+extern void default_nmi_init(void);
 
 extern void setup_apic_nmi_watchdog(void *);
 extern void stop_apic_nmi_watchdog(void *);

--cmJC7u66zC7hs+87--
