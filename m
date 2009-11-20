Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZKTAQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZKTAQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZKTAQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:16:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:22007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772AbZKTAQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:16:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,773,1249282800"; 
   d="scan'208,223";a="468911549"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Date: Thu, 19 Nov 2009 16:16:59 -0800
Subject: [PATCH 2/3] x86/apic: make use of legacy_pic abstraction
Thread-Topic: [PATCH 2/3] x86/apic: make use of legacy_pic abstraction
Thread-Index: AcppdsbTkvx06KTgQIyLoASFBoyyqg==
Message-ID: <43F901BD926A4E43B106BF17856F07558A00D90F@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 58b901fe67cd0c0d7877436c529100f67334f3c8 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 19 Nov 2009 07:36:57 -0800
Subject: [PATCH] x86/apic: make use of legacy_pic abstraction

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/hw_irq.h  |    7 -----
 arch/x86/include/asm/i8259.h   |    8 ------
 arch/x86/kernel/apic/apic.c    |    8 +++---
 arch/x86/kernel/apic/io_apic.c |   54 +++++++++++++++++++--------------------
 arch/x86/kernel/apic/nmi.c     |    2 +-
 arch/x86/kernel/i8259.c        |   21 ++++++++++-----
 arch/x86/kernel/irqinit.c      |    2 +-
 arch/x86/kernel/smpboot.c      |    5 ++-
 arch/x86/kernel/visws_quirks.c |   14 ++++++---
 9 files changed, 58 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index ba180d9..b2c3782 100644
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
index 894aa97..632d8db 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1414,7 +1414,7 @@ void __init enable_IR_x2apic(void)
        }

        local_irq_save(flags);
-       mask_8259A();
+       legacy_pic->mask_all();
        mask_IO_APIC_setup(ioapic_entries);

        if (dmar_table_init_ret)
@@ -1446,7 +1446,7 @@ void __init enable_IR_x2apic(void)
 nox2apic:
        if (!ret) /* IR enabling failed */
                restore_IO_APIC_setup(ioapic_entries);
-       unmask_8259A();
+       legacy_pic->restore_mask();
        local_irq_restore(flags);

 out:
@@ -2056,7 +2056,7 @@ static int lapic_resume(struct sys_device *dev)
                }

                mask_IO_APIC_setup(ioapic_entries);
-               mask_8259A();
+               legacy_pic->mask_all();
        }

        if (x2apic_mode)
@@ -2100,7 +2100,7 @@ static int lapic_resume(struct sys_device *dev)

        if (intr_remapping_enabled) {
                reenable_intr_remapping(x2apic_mode);
-               unmask_8259A();
+               legacy_pic->restore_mask();
                restore_IO_APIC_setup(ioapic_entries);
                free_ioapic_entries(ioapic_entries);
        }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index dc69f28..35aa616 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -96,8 +96,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;

-/* Number of legacy interrupts */
-static int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;

@@ -201,7 +199,7 @@ int __init arch_early_irq_init(void)
                desc->chip_data = &cfg[i];
                zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
                zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
-               if (i < nr_legacy_irqs)
+               if (i < legacy_pic->nr_legacy_irqs)
                        cpumask_setall(cfg[i].domain);
        }

@@ -875,7 +873,7 @@ static int __init find_isa_irq_apic(int irq, int type)
  */
 static int EISA_ELCR(unsigned int irq)
 {
-       if (irq < nr_legacy_irqs) {
+       if (irq < legacy_pic->nr_legacy_irqs) {
                unsigned int port = 0x4d0 + (irq >> 3);
                return (inb(port) >> (irq & 7)) & 1;
        }
@@ -1472,8 +1470,8 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
        }

        ioapic_register_intr(irq, desc, trigger);
-       if (irq < nr_legacy_irqs)
-               disable_8259A_irq(irq);
+       if (irq < legacy_pic->nr_legacy_irqs)
+               legacy_pic->chip->mask(irq);

        ioapic_write_entry(apic_id, pin, entry);
 }
@@ -1839,7 +1837,7 @@ __apicdebuginit(void) print_PIC(void)
        unsigned int v;
        unsigned long flags;

-       if (apic_verbosity == APIC_QUIET || !nr_legacy_irqs)
+       if (apic_verbosity == APIC_QUIET || !legacy_pic->nr_legacy_irqs)
                return;

        printk(KERN_DEBUG "\nprinting PIC contents\n");
@@ -1903,7 +1901,7 @@ void __init enable_IO_APIC(void)
                nr_ioapic_registers[apic] = reg_01.bits.entries+1;
        }

-       if (!nr_legacy_irqs)
+       if (!legacy_pic->nr_legacy_irqs)
                return;

        for(apic = 0; apic < nr_ioapics; apic++) {
@@ -1960,7 +1958,7 @@ void disable_IO_APIC(void)
         */
        clear_IO_APIC();

-       if (!nr_legacy_irqs)
+       if (!legacy_pic->nr_legacy_irqs)
                return;

        /*
@@ -2193,9 +2191,9 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
        struct irq_cfg *cfg;

        spin_lock_irqsave(&ioapic_lock, flags);
-       if (irq < nr_legacy_irqs) {
-               disable_8259A_irq(irq);
-               if (i8259A_irq_pending(irq))
+       if (irq < legacy_pic->nr_legacy_irqs) {
+               legacy_pic->chip->mask(irq);
+               if (legacy_pic->irq_pending(irq))
                        was_pending = 1;
        }
        cfg = irq_cfg(irq);
@@ -2671,8 +2669,8 @@ static inline void init_IO_APIC_traps(void)
                         * so default to an old-fashioned 8259
                         * interrupt if we can..
                         */
-                       if (irq < nr_legacy_irqs)
-                               make_8259A_irq(irq);
+                       if (irq < legacy_pic->nr_legacy_irqs)
+                               legacy_pic->make_irq(irq);
                        else
                                /* Strange. Oh, well.. */
                                desc->chip = &no_irq_chip;
@@ -2829,7 +2827,7 @@ static inline void __init check_timer(void)
        /*
         * get/set the timer IRQ vector:
         */
-       disable_8259A_irq(0);
+       legacy_pic->chip->mask(0);
        assign_irq_vector(0, cfg, apic->target_cpus());

        /*
@@ -2842,7 +2840,7 @@ static inline void __init check_timer(void)
         * automatically.
         */
        apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
-       init_8259A(1);
+       legacy_pic->init(1);
 #ifdef CONFIG_X86_32
        {
                unsigned int ver;
@@ -2901,7 +2899,7 @@ static inline void __init check_timer(void)
                if (timer_irq_works()) {
                        if (nmi_watchdog == NMI_IO_APIC) {
                                setup_nmi();
-                               enable_8259A_irq(0);
+                               legacy_pic->chip->unmask(0);
                        }
                        if (disable_timer_pin_1 > 0)
                                clear_IO_APIC_pin(0, pin1);
@@ -2924,14 +2922,14 @@ static inline void __init check_timer(void)
                 */
                replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
                setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-               enable_8259A_irq(0);
+               legacy_pic->chip->unmask(0);
                if (timer_irq_works()) {
                        apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
                        timer_through_8259 = 1;
                        if (nmi_watchdog == NMI_IO_APIC) {
-                               disable_8259A_irq(0);
+                               legacy_pic->chip->mask(0);
                                setup_nmi();
-                               enable_8259A_irq(0);
+                               legacy_pic->chip->unmask(0);
                        }
                        goto out;
                }
@@ -2939,7 +2937,7 @@ static inline void __init check_timer(void)
                 * Cleanup, just in case ...
                 */
                local_irq_disable();
-               disable_8259A_irq(0);
+               legacy_pic->chip->mask(0);
                clear_IO_APIC_pin(apic2, pin2);
                apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
        }
@@ -2958,22 +2956,22 @@ static inline void __init check_timer(void)

        lapic_register_intr(0, desc);
        apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);     /* Fixed mode */
-       enable_8259A_irq(0);
+       legacy_pic->chip->unmask(0);

        if (timer_irq_works()) {
                apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
                goto out;
        }
        local_irq_disable();
-       disable_8259A_irq(0);
+       legacy_pic->chip->mask(0);
        apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
        apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");

        apic_printk(APIC_QUIET, KERN_INFO
                    "...trying to set up timer as ExtINT IRQ...\n");

-       init_8259A(0);
-       make_8259A_irq(0);
+       legacy_pic->init(0);
+       legacy_pic->make_irq(0);
        apic_write(APIC_LVT0, APIC_DM_EXTINT);

        unlock_ExtINT_logic();
@@ -3015,7 +3013,7 @@ void __init setup_IO_APIC(void)
        /*
         * calling enable_IO_APIC() is moved to setup_local_APIC for BP
         */
-       io_apic_irqs = nr_legacy_irqs ? ~PIC_IRQS : ~0UL;
+       io_apic_irqs = legacy_pic->nr_legacy_irqs ? ~PIC_IRQS : ~0UL;

        apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
        /*
@@ -3026,7 +3024,7 @@ void __init setup_IO_APIC(void)
        sync_Arb_IDs();
        setup_IO_APIC_irqs();
        init_IO_APIC_traps();
-       if (nr_legacy_irqs)
+       if (legacy_pic->nr_legacy_irqs)
                check_timer();
 }

@@ -3867,7 +3865,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
        /*
         * IRQs < 16 are already in the irq_2_pin[] map
         */
-       if (irq >= nr_legacy_irqs) {
+       if (irq >= legacy_pic->nr_legacy_irqs) {
                cfg = desc->chip_data;
                if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
                        printk(KERN_INFO "can not add pin %d for irq %d\n",
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 7ff61d6..1c586fa 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -176,7 +176,7 @@ int __init check_nmi_watchdog(void)
 error:
        if (nmi_watchdog == NMI_IO_APIC) {
                if (!timer_through_8259)
-                       disable_8259A_irq(0);
+                       legacy_pic->chip->mask(0);
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
        .name           = "XT-PIC",
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
index 40f3077..9898312 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -123,7 +123,7 @@ void __init init_ISA_irqs(void)
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
        init_bsp_APIC();
 #endif
-       init_8259A(0);
+       legacy_pic->init(0);

        /*
         * 16 old-style INTA-cycle interrupts:
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 565ebc6..a1b19a5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -67,6 +67,7 @@
 #include <linux/mc146818rtc.h>

 #include <asm/smpboot_hooks.h>
+#include <asm/i8259.h>

 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
@@ -286,9 +287,9 @@ notrace static void __cpuinit start_secondary(void *unused)
        check_tsc_sync_target();

        if (nmi_watchdog == NMI_IO_APIC) {
-               disable_8259A_irq(0);
+               legacy_pic->chip->mask(0);
                enable_NMI_through_LVT0();
-               enable_8259A_irq(0);
+               legacy_pic->chip->unmask(0);
        }

 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index f068553..80fee4e 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -508,7 +508,7 @@ static struct irq_chip cobalt_irq_type = {
  */
 static unsigned int startup_piix4_master_irq(unsigned int irq)
 {
-       init_8259A(0);
+       legacy_pic->init(0);

        return startup_cobalt_irq(irq);
 }
@@ -532,9 +532,6 @@ static struct irq_chip piix4_master_irq_type = {

 static struct irq_chip piix4_virtual_irq_type = {
        .typename =     "PIIX4-virtual",
-       .shutdown =     disable_8259A_irq,
-       .enable =       enable_8259A_irq,
-       .disable =      disable_8259A_irq,
 };


@@ -609,7 +606,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
                handle_IRQ_event(realirq, desc->action);

        if (!(desc->status & IRQ_DISABLED))
-               enable_8259A_irq(realirq);
+               legacy_pic->chip->unmask(realirq);

        return IRQ_HANDLED;

@@ -628,6 +625,12 @@ static struct irqaction cascade_action = {
        .name =         "cascade",
 };

+static inline void set_piix4_virtual_irq_type(void)
+{
+       piix4_virtual_irq_type.shutdown = i8259A_chip.mask;
+       piix4_virtual_irq_type.enable = i8259A_chip.unmask;
+       piix4_virtual_irq_type.disable = i8259A_chip.mask;
+}

 void init_VISWS_APIC_irqs(void)
 {
@@ -653,6 +656,7 @@ void init_VISWS_APIC_irqs(void)
                        desc->chip = &piix4_master_irq_type;
                }
                else if (i < CO_IRQ_APIC0) {
+                       set_piix4_virtual_irq_type();
                        desc->chip = &piix4_virtual_irq_type;
                }
                else if (IS_CO_APIC(i)) {
--
1.5.6.5

