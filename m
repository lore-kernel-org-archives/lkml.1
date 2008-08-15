Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYHOI2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYHOI2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYHOI16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:27:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:62015 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYHOI14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F0vLam9P7BQuhsaBF25ISd5WqGZtSRttkc13KsG05Qy2DIx/pM7Zk/M8X40ry6gCRW
         rtWk5RdRHhWQBNKYec6hxGvKvmHxUJXiRxNRiAoJDZzI07B0fbepGuZGCVVZ3407VGrP
         kOEoOmB4/Eo7Hc53bYKLuhL5FUiIacy4dGxLo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: order variables in io_apic_xx.c
Date: Fri, 15 Aug 2008 01:27:06 -0700
Message-Id: <1218788826-19635-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move first_system_vector to apic_64.c
also add #ifdef CONFIG_INTR_REMAP to prepare 32 bit to use
same file

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/apic_64.c    |    5 +
 arch/x86/kernel/io_apic_32.c |   79 +++++++++------------
 arch/x86/kernel/io_apic_64.c |  160 ++++++++++++++++++++++---------------------
 3 files changed, 127 insertions(+), 117 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -33,6 +33,7 @@
 #include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
+#include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/pgalloc.h>
 #include <asm/nmi.h>
@@ -58,6 +59,10 @@ int x2apic_preenabled;
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
+int first_system_vector = 0xfe;
+
+char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
+
 /*
  * Debug level, exported for io_apic.c
  */
Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -54,25 +54,23 @@
 
 #define __apicdebuginit(type) static type __init
 
-int (*ioapic_renumber_irq)(int ioapic, int irq);
-atomic_t irq_mis_count;
-
-/* Where if anywhere is the i8259 connect in external int mode */
-static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
-
-static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
-
-int timer_through_8259 __initdata;
-
 /*
  *	Is the SiS APIC rmw bug present ?
  *	-1 = don't know, 0 = no, 1 = yes
  */
 int sis_apic_bug = -1;
 
+static DEFINE_SPINLOCK(ioapic_lock);
+static DEFINE_SPINLOCK(vector_lock);
+
 int first_free_entry;
 /*
+ * Rough estimation of how many shared IRQs there are, can
+ * be changed anytime.
+ */
+int pin_map_size;
+
+/*
  * # of IRQ routing registers
  */
 int nr_ioapic_registers[MAX_IO_APICS];
@@ -93,7 +91,15 @@ int mp_bus_id_to_type[MAX_MP_BUSSES];
 
 DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
-static int disable_timer_pin_1 __initdata;
+int skip_ioapic_setup;
+
+static int __init parse_noapic(char *arg)
+{
+	/* disable IO-APIC */
+	disable_ioapic_setup();
+	return 0;
+}
+early_param("noapic", parse_noapic);
 
 struct irq_cfg;
 struct irq_pin_list;
@@ -268,13 +274,6 @@ static struct irq_cfg *irq_cfg_with_new(
 	return cfg;
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
-/*
- * Rough estimation of how many shared IRQs there are, can
- * be changed anytime.
- */
-int pin_map_size;
-
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -465,6 +464,9 @@ static void __target_IO_APIC_irq(unsigne
 		entry = entry->next;
 	}
 }
+
+static int assign_irq_vector(int irq, cpumask_t mask);
+
 static void set_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
@@ -677,7 +679,6 @@ void send_IPI_self(int vector)
 #define MAX_PIRQS 8
 static int pirq_entries [MAX_PIRQS];
 static int pirqs_enabled;
-int skip_ioapic_setup;
 
 static int __init ioapic_pirq_setup(char *str)
 {
@@ -981,6 +982,7 @@ static inline int irq_trigger(int idx)
 	return MPBIOS_trigger(idx);
 }
 
+int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
@@ -1621,6 +1623,9 @@ __apicdebuginit(int) print_all_ICs(void)
 fs_initcall(print_all_ICs);
 
 
+/* Where if anywhere is the i8259 connect in external int mode */
+static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
+
 static void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
@@ -1998,6 +2003,7 @@ static void ack_apic_edge(unsigned int i
 	ack_APIC_irq();
 }
 
+atomic_t irq_mis_count;
 static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long v;
@@ -2208,6 +2214,17 @@ static inline void __init unlock_ExtINT_
 	ioapic_write_entry(apic, pin, entry0);
 }
 
+static int disable_timer_pin_1 __initdata;
+
+static int __init parse_disable_timer_pin_1(char *arg)
+{
+	disable_timer_pin_1 = 1;
+	return 0;
+}
+early_param("disable_timer_pin_1", parse_disable_timer_pin_1);
+
+int timer_through_8259 __initdata;
+
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
@@ -2977,28 +2994,6 @@ void __init setup_ioapic_dest(void)
 }
 #endif
 
-static int __init parse_disable_timer_pin_1(char *arg)
-{
-	disable_timer_pin_1 = 1;
-	return 0;
-}
-early_param("disable_timer_pin_1", parse_disable_timer_pin_1);
-
-static int __init parse_enable_timer_pin_1(char *arg)
-{
-	disable_timer_pin_1 = -1;
-	return 0;
-}
-early_param("enable_timer_pin_1", parse_enable_timer_pin_1);
-
-static int __init parse_noapic(char *arg)
-{
-	/* disable IO-APIC */
-	disable_ioapic_setup();
-	return 0;
-}
-early_param("noapic", parse_noapic);
-
 void __init ioapic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -57,6 +57,47 @@
 
 #define __apicdebuginit(type) static type __init
 
+int ioapic_force;
+
+int sis_apic_bug; /* not actually supported, dummy for compile */
+
+static DEFINE_SPINLOCK(ioapic_lock);
+static DEFINE_SPINLOCK(vector_lock);
+
+int first_free_entry;
+/*
+ * Rough estimation of how many shared IRQs there are, can
+ * be changed anytime.
+ */
+int pin_map_size;
+
+/*
+ * # of IRQ routing registers
+ */
+int nr_ioapic_registers[MAX_IO_APICS];
+
+/* I/O APIC entries */
+struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+int nr_ioapics;
+
+/* MP IRQ source entries */
+struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+
+/* # of MP IRQ source entries */
+int mp_irq_entries;
+
+DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
+
+int skip_ioapic_setup;
+
+static int __init parse_noapic(char *str)
+{
+	disable_ioapic_setup();
+	return 0;
+}
+early_param("noapic", parse_noapic);
+
+
 struct irq_cfg;
 struct irq_pin_list;
 struct irq_cfg {
@@ -228,53 +269,6 @@ static struct irq_cfg *irq_cfg_with_new(
 	return cfg;
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
-
-int first_system_vector = 0xfe;
-
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
-
-int sis_apic_bug; /* not actually supported, dummy for compile */
-
-static int no_timer_check;
-
-static int disable_timer_pin_1 __initdata;
-
-int timer_through_8259 __initdata;
-
-/* Where if anywhere is the i8259 connect in external int mode */
-static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
-
-static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
-
-/*
- * # of IRQ routing registers
- */
-int nr_ioapic_registers[MAX_IO_APICS];
-
-/* I/O APIC RTE contents at the OS boot up */
-struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
-
-/* I/O APIC entries */
-struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
-int nr_ioapics;
-
-/* MP IRQ source entries */
-struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
-
-/* # of MP IRQ source entries */
-int mp_irq_entries;
-
-DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
-
-/*
- * Rough estimation of how many shared IRQs there are, can
- * be changed anytime.
- */
-
-int pin_map_size;
-
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -481,12 +475,16 @@ static void __target_IO_APIC_irq(unsigne
 
 		apic = entry->apic;
 		pin = entry->pin;
+#ifdef CONFIG_INTR_REMAP
 		/*
 		 * With interrupt-remapping, destination information comes
 		 * from interrupt-remapping table entry.
 		 */
 		if (!irq_remapped(irq))
 			io_apic_write(apic, 0x11 + pin*2, dest);
+#else
+		io_apic_write(apic, 0x11 + pin*2, dest);
+#endif
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
@@ -497,6 +495,8 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
+static int assign_irq_vector(int irq, cpumask_t mask);
+
 static void set_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
@@ -531,7 +531,6 @@ static void set_ioapic_affinity_irq(unsi
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-int first_free_entry;
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
 	struct irq_cfg *cfg;
@@ -677,6 +676,10 @@ static void clear_IO_APIC (void)
 			clear_IO_APIC_pin(apic, pin);
 }
 
+#ifdef CONFIG_INTR_REMAP
+/* I/O APIC RTE contents at the OS boot up */
+static struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
+
 /*
  * Saves and masks all the unmasked IO-APIC RTE's
  */
@@ -739,25 +742,7 @@ void reinit_intr_remapped_IO_APIC(int in
 	 */
 	restore_IO_APIC_setup();
 }
-
-int skip_ioapic_setup;
-int ioapic_force;
-
-static int __init parse_noapic(char *str)
-{
-	disable_ioapic_setup();
-	return 0;
-}
-early_param("noapic", parse_noapic);
-
-/* Actually the next is obsolete, but keep it for paranoid reasons -AK */
-static int __init disable_timer_pin_setup(char *arg)
-{
-	disable_timer_pin_1 = 1;
-	return 1;
-}
-__setup("disable_timer_pin_1", disable_timer_pin_setup);
-
+#endif
 
 /*
  * Find the IRQ entry number of a certain pin.
@@ -1325,8 +1310,10 @@ static void __init setup_timer_IRQ0_pin(
 {
 	struct IO_APIC_route_entry entry;
 
+#ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled)
 		return;
+#endif
 
 	memset(&entry, 0, sizeof(entry));
 
@@ -1599,6 +1586,9 @@ __apicdebuginit(int) print_all_ICs(void)
 fs_initcall(print_all_ICs);
 
 
+/* Where if anywhere is the i8259 connect in external int mode */
+static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
+
 void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
@@ -1695,6 +1685,15 @@ void disable_IO_APIC(void)
 	disconnect_bsp_APIC(ioapic_i8259.pin != -1);
 }
 
+static int no_timer_check;
+
+static int __init notimercheck(char *s)
+{
+	no_timer_check = 1;
+	return 1;
+}
+__setup("no_timer_check", notimercheck);
+
 /*
  * There is a nasty bug in some older SMP boards, their mptable lies
  * about the timer IRQ. We do the following to work around the situation:
@@ -1708,6 +1707,9 @@ static int __init timer_irq_works(void)
 	unsigned long t1 = jiffies;
 	unsigned long flags;
 
+	if (no_timer_check)
+		return 1;
+
 	local_save_flags(flags);
 	local_irq_enable();
 	/* Let ten ticks pass... */
@@ -2237,6 +2239,17 @@ static inline void __init unlock_ExtINT_
 	ioapic_write_entry(apic, pin, entry0);
 }
 
+static int disable_timer_pin_1 __initdata;
+/* Actually the next is obsolete, but keep it for paranoid reasons -AK */
+static int __init disable_timer_pin_setup(char *arg)
+{
+	disable_timer_pin_1 = 1;
+	return 0;
+}
+early_param("disable_timer_pin_1", disable_timer_pin_setup);
+
+int timer_through_8259 __initdata;
+
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
@@ -2284,8 +2297,10 @@ static inline void __init check_timer(vo
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
+#ifdef CONFIG_INTR_REMAP
 		if (intr_remapping_enabled)
 			panic("BIOS bug: timer not connected to IO-APIC");
+#endif
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -2303,7 +2318,7 @@ static inline void __init check_timer(vo
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
 		unmask_IO_APIC_irq(0);
-		if (!no_timer_check && timer_irq_works()) {
+		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
 				enable_8259A_irq(0);
@@ -2312,8 +2327,10 @@ static inline void __init check_timer(vo
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
+#ifdef CONFIG_INTR_REMAP
 		if (intr_remapping_enabled)
 			panic("timer doesn't work through Interrupt-remapped IO-APIC");
+#endif
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
 			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
@@ -2389,13 +2406,6 @@ out:
 	local_irq_restore(flags);
 }
 
-static int __init notimercheck(char *s)
-{
-	no_timer_check = 1;
-	return 1;
-}
-__setup("no_timer_check", notimercheck);
-
 /*
  * Traditionally ISA IRQ2 is the cascade IRQ, and is not available
  * to devices.  However there may be an I/O APIC pin available for
