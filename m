Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0BTB3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:29:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:56135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0BTB3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:29:47 -0500
Date: Sat, 20 Feb 2010 01:29:26 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D04@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D04@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, pic: Make use of legacy_pic abstraction
Message-ID: <tip-b81bb373a7e832a43921356aa1291044d7f52fb1@git.kernel.org>
Git-Commit-ID: b81bb373a7e832a43921356aa1291044d7f52fb1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 01:29:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b81bb373a7e832a43921356aa1291044d7f52fb1
Gitweb:     http://git.kernel.org/tip/b81bb373a7e832a43921356aa1291044d7f52fb1
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Mon, 9 Nov 2009 11:27:04 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 16:25:17 -0800

x86, pic: Make use of legacy_pic abstraction

This patch replaces legacy PIC-related global variable and functions
with the new legacy_pic abstraction.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D04@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/hw_irq.h  |    7 -----
 arch/x86/include/asm/i8259.h   |    8 -----
 arch/x86/kernel/apic/apic.c    |    8 +++---
 arch/x86/kernel/apic/io_apic.c |   57 +++++++++++++++++++---------------------
 arch/x86/kernel/apic/nmi.c     |    2 +-
 arch/x86/kernel/i8259.c        |   21 ++++++++++-----
 arch/x86/kernel/irqinit.c      |    2 +-
 arch/x86/kernel/smpboot.c      |    5 ++-
 arch/x86/kernel/visws_quirks.c |   14 ++++++---
 9 files changed, 59 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eeac829..a929c9e 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -53,13 +53,6 @@ extern void threshold_interrupt(void);
 extern void call_function_interrupt(void);
 extern void call_function_single_interrupt(void);
 
-/* PIC specific functions */
-extern void disable_8259A_irq(unsigned int irq);
-extern void enable_8259A_irq(unsigned int irq);
-extern int i8259A_irq_pending(unsigned int irq);
-extern void make_8259A_irq(unsigned int irq);
-extern void init_8259A(int aeoi);
-
 /* IOAPIC */
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
 extern unsigned long io_apic_irqs;
diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index e8a3e05..2832bab 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -26,11 +26,6 @@ extern unsigned int cached_irq_mask;
 
 extern spinlock_t i8259A_lock;
 
-extern void init_8259A(int auto_eoi);
-extern void enable_8259A_irq(unsigned int irq);
-extern void disable_8259A_irq(unsigned int irq);
-extern unsigned int startup_8259A_irq(unsigned int irq);
-
 /* the PIC may need a careful delay on some platforms, hence specific calls */
 static inline unsigned char inb_pic(unsigned int port)
 {
@@ -70,7 +65,4 @@ struct legacy_pic {
 extern struct legacy_pic *legacy_pic;
 extern struct legacy_pic null_legacy_pic;
 
-extern void mask_8259A(void);
-extern void unmask_8259A(void);
-
 #endif /* _ASM_X86_I8259_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index dfca210..94f22b1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1390,7 +1390,7 @@ void __init enable_IR_x2apic(void)
 	}
 
 	local_irq_save(flags);
-	mask_8259A();
+	legacy_pic->mask_all();
 	mask_IO_APIC_setup(ioapic_entries);
 
 	if (dmar_table_init_ret)
@@ -1422,7 +1422,7 @@ void __init enable_IR_x2apic(void)
 nox2apic:
 	if (!ret) /* IR enabling failed */
 		restore_IO_APIC_setup(ioapic_entries);
-	unmask_8259A();
+	legacy_pic->restore_mask();
 	local_irq_restore(flags);
 
 out:
@@ -2018,7 +2018,7 @@ static int lapic_resume(struct sys_device *dev)
 		}
 
 		mask_IO_APIC_setup(ioapic_entries);
-		mask_8259A();
+		legacy_pic->mask_all();
 	}
 
 	if (x2apic_mode)
@@ -2062,7 +2062,7 @@ static int lapic_resume(struct sys_device *dev)
 
 	if (intr_remapping_enabled) {
 		reenable_intr_remapping(x2apic_mode);
-		unmask_8259A();
+		legacy_pic->restore_mask();
 		restore_IO_APIC_setup(ioapic_entries);
 		free_ioapic_entries(ioapic_entries);
 	}
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 75265ab..1704cd8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -94,8 +94,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-/* Number of legacy interrupts */
-static int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
@@ -147,7 +145,6 @@ static struct irq_cfg irq_cfgx[NR_IRQS];
 
 void __init io_apic_disable_legacy(void)
 {
-	nr_legacy_irqs = 0;
 	nr_irqs_gsi = 0;
 }
 
@@ -164,13 +161,13 @@ int __init arch_early_irq_init(void)
 	node= cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
-		if (i < nr_legacy_irqs)
+		if (i < legacy_pic->nr_legacy_irqs)
 			cfg[i].vector = IRQ0_VECTOR + i;
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
-		if (i < nr_legacy_irqs)
+		if (i < legacy_pic->nr_legacy_irqs)
 			cpumask_setall(cfg[i].domain);
 	}
 
@@ -850,7 +847,7 @@ static int __init find_isa_irq_apic(int irq, int type)
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < nr_legacy_irqs) {
+	if (irq < legacy_pic->nr_legacy_irqs) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -1446,8 +1443,8 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	}
 
 	ioapic_register_intr(irq, desc, trigger);
-	if (irq < nr_legacy_irqs)
-		disable_8259A_irq(irq);
+	if (irq < legacy_pic->nr_legacy_irqs)
+		legacy_pic->chip->mask(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
 }
@@ -1810,7 +1807,7 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
-	if (!nr_legacy_irqs)
+	if (!legacy_pic->nr_legacy_irqs)
 		return;
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
@@ -1894,7 +1891,7 @@ void __init enable_IO_APIC(void)
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
 
-	if (!nr_legacy_irqs)
+	if (!legacy_pic->nr_legacy_irqs)
 		return;
 
 	for(apic = 0; apic < nr_ioapics; apic++) {
@@ -1951,7 +1948,7 @@ void disable_IO_APIC(void)
 	 */
 	clear_IO_APIC();
 
-	if (!nr_legacy_irqs)
+	if (!legacy_pic->nr_legacy_irqs)
 		return;
 
 	/*
@@ -2184,9 +2181,9 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < nr_legacy_irqs) {
-		disable_8259A_irq(irq);
-		if (i8259A_irq_pending(irq))
+	if (irq < legacy_pic->nr_legacy_irqs) {
+		legacy_pic->chip->mask(irq);
+		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
 	cfg = irq_cfg(irq);
@@ -2719,8 +2716,8 @@ static inline void init_IO_APIC_traps(void)
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < nr_legacy_irqs)
-				make_8259A_irq(irq);
+			if (irq < legacy_pic->nr_legacy_irqs)
+				legacy_pic->make_irq(irq);
 			else
 				/* Strange. Oh, well.. */
 				desc->chip = &no_irq_chip;
@@ -2877,7 +2874,7 @@ static inline void __init check_timer(void)
 	/*
 	 * get/set the timer IRQ vector:
 	 */
-	disable_8259A_irq(0);
+	legacy_pic->chip->mask(0);
 	assign_irq_vector(0, cfg, apic->target_cpus());
 
 	/*
@@ -2890,7 +2887,7 @@ static inline void __init check_timer(void)
 	 * automatically.
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
-	init_8259A(1);
+	legacy_pic->init(1);
 #ifdef CONFIG_X86_32
 	{
 		unsigned int ver;
@@ -2949,7 +2946,7 @@ static inline void __init check_timer(void)
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
-				enable_8259A_irq(0);
+				legacy_pic->chip->unmask(0);
 			}
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(0, pin1);
@@ -2972,14 +2969,14 @@ static inline void __init check_timer(void)
 		 */
 		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		enable_8259A_irq(0);
+		legacy_pic->chip->unmask(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
-				disable_8259A_irq(0);
+				legacy_pic->chip->mask(0);
 				setup_nmi();
-				enable_8259A_irq(0);
+				legacy_pic->chip->unmask(0);
 			}
 			goto out;
 		}
@@ -2987,7 +2984,7 @@ static inline void __init check_timer(void)
 		 * Cleanup, just in case ...
 		 */
 		local_irq_disable();
-		disable_8259A_irq(0);
+		legacy_pic->chip->mask(0);
 		clear_IO_APIC_pin(apic2, pin2);
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
@@ -3006,22 +3003,22 @@ static inline void __init check_timer(void)
 
 	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
-	enable_8259A_irq(0);
+	legacy_pic->chip->unmask(0);
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
 	local_irq_disable();
-	disable_8259A_irq(0);
+	legacy_pic->chip->mask(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as ExtINT IRQ...\n");
 
-	init_8259A(0);
-	make_8259A_irq(0);
+	legacy_pic->init(0);
+	legacy_pic->make_irq(0);
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 
 	unlock_ExtINT_logic();
@@ -3063,7 +3060,7 @@ void __init setup_IO_APIC(void)
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
-	io_apic_irqs = nr_legacy_irqs ? ~PIC_IRQS : ~0UL;
+	io_apic_irqs = legacy_pic->nr_legacy_irqs ? ~PIC_IRQS : ~0UL;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 	/*
@@ -3074,7 +3071,7 @@ void __init setup_IO_APIC(void)
 	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
-	if (nr_legacy_irqs)
+	if (legacy_pic->nr_legacy_irqs)
 		check_timer();
 }
 
@@ -3875,7 +3872,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
-	if (irq >= nr_legacy_irqs) {
+	if (irq >= legacy_pic->nr_legacy_irqs) {
 		cfg = desc->chip_data;
 		if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
 			printk(KERN_INFO "can not add pin %d for irq %d\n",
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 0159a69..3817739 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -177,7 +177,7 @@ int __init check_nmi_watchdog(void)
 error:
 	if (nmi_watchdog == NMI_IO_APIC) {
 		if (!timer_through_8259)
-			disable_8259A_irq(0);
+			legacy_pic->chip->mask(0);
 		on_each_cpu(__acpi_nmi_disable, NULL, 1);
 	}
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index b80987c..1c790e7 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -34,6 +34,12 @@
 static int i8259A_auto_eoi;
 DEFINE_SPINLOCK(i8259A_lock);
 static void mask_and_ack_8259A(unsigned int);
+static void mask_8259A(void);
+static void unmask_8259A(void);
+static void disable_8259A_irq(unsigned int irq);
+static void enable_8259A_irq(unsigned int irq);
+static void init_8259A(int auto_eoi);
+static int i8259A_irq_pending(unsigned int irq);
 
 struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
@@ -63,7 +69,7 @@ unsigned int cached_irq_mask = 0xffff;
  */
 unsigned long io_apic_irqs;
 
-void disable_8259A_irq(unsigned int irq)
+static void disable_8259A_irq(unsigned int irq)
 {
 	unsigned int mask = 1 << irq;
 	unsigned long flags;
@@ -77,7 +83,7 @@ void disable_8259A_irq(unsigned int irq)
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-void enable_8259A_irq(unsigned int irq)
+static void enable_8259A_irq(unsigned int irq)
 {
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
@@ -91,7 +97,7 @@ void enable_8259A_irq(unsigned int irq)
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-int i8259A_irq_pending(unsigned int irq)
+static int i8259A_irq_pending(unsigned int irq)
 {
 	unsigned int mask = 1<<irq;
 	unsigned long flags;
@@ -107,7 +113,7 @@ int i8259A_irq_pending(unsigned int irq)
 	return ret;
 }
 
-void make_8259A_irq(unsigned int irq)
+static void make_8259A_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
@@ -281,7 +287,7 @@ static int __init i8259A_init_sysfs(void)
 
 device_initcall(i8259A_init_sysfs);
 
-void mask_8259A(void)
+static void mask_8259A(void)
 {
 	unsigned long flags;
 
@@ -293,7 +299,7 @@ void mask_8259A(void)
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-void unmask_8259A(void)
+static void unmask_8259A(void)
 {
 	unsigned long flags;
 
@@ -305,7 +311,7 @@ void unmask_8259A(void)
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-void init_8259A(int auto_eoi)
+static void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
 
@@ -358,6 +364,7 @@ void init_8259A(int auto_eoi)
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
+
 /*
  * make i8259 a driver so that we can select pic functions at run time. the goal
  * is to make x86 binary compatible among pc compatible and non-pc compatible
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index d593222..89b9510 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -123,7 +123,7 @@ void __init init_ISA_irqs(void)
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	init_bsp_APIC();
 #endif
-	init_8259A(0);
+	legacy_pic->init(0);
 
 	/*
 	 * 16 old-style INTA-cycle interrupts:
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3e6150d..f7a52f4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -68,6 +68,7 @@
 #include <linux/mc146818rtc.h>
 
 #include <asm/smpboot_hooks.h>
+#include <asm/i8259.h>
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
@@ -287,9 +288,9 @@ notrace static void __cpuinit start_secondary(void *unused)
 	check_tsc_sync_target();
 
 	if (nmi_watchdog == NMI_IO_APIC) {
-		disable_8259A_irq(0);
+		legacy_pic->chip->mask(0);
 		enable_NMI_through_LVT0();
-		enable_8259A_irq(0);
+		legacy_pic->chip->unmask(0);
 	}
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index b48ef6c..f067e95 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -505,7 +505,7 @@ static struct irq_chip cobalt_irq_type = {
  */
 static unsigned int startup_piix4_master_irq(unsigned int irq)
 {
-	init_8259A(0);
+	legacy_pic->init(0);
 
 	return startup_cobalt_irq(irq);
 }
@@ -529,9 +529,6 @@ static struct irq_chip piix4_master_irq_type = {
 
 static struct irq_chip piix4_virtual_irq_type = {
 	.name =		"PIIX4-virtual",
-	.shutdown =	disable_8259A_irq,
-	.enable =	enable_8259A_irq,
-	.disable =	disable_8259A_irq,
 };
 
 
@@ -606,7 +603,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 		handle_IRQ_event(realirq, desc->action);
 
 	if (!(desc->status & IRQ_DISABLED))
-		enable_8259A_irq(realirq);
+		legacy_pic->chip->unmask(realirq);
 
 	return IRQ_HANDLED;
 
@@ -625,6 +622,12 @@ static struct irqaction cascade_action = {
 	.name =		"cascade",
 };
 
+static inline void set_piix4_virtual_irq_type(void)
+{
+	piix4_virtual_irq_type.shutdown = i8259A_chip.mask;
+	piix4_virtual_irq_type.enable =	i8259A_chip.unmask;
+	piix4_virtual_irq_type.disable = i8259A_chip.mask;
+}
 
 void init_VISWS_APIC_irqs(void)
 {
@@ -650,6 +653,7 @@ void init_VISWS_APIC_irqs(void)
 			desc->chip = &piix4_master_irq_type;
 		}
 		else if (i < CO_IRQ_APIC0) {
+			set_piix4_virtual_irq_type();
 			desc->chip = &piix4_virtual_irq_type;
 		}
 		else if (IS_CO_APIC(i)) {
