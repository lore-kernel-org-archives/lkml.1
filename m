Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZJEA6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZJEA6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbZJEA6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:58:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1724 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244AbZJEAzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 07/21] arch/x86/kernel/apic/: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:34 -0700
Message-Id: <8cfc302f51029f238ae1c6f077334b45f6c83c96.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted printk(KERN_<level> to pr_<level>(
Stripped an "ACPI: " typo prefix
Stripped "APIC: " from a few printks

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/apic/apic.c         |   48 ++++----
 arch/x86/kernel/apic/apic_flat_64.c |    5 +-
 arch/x86/kernel/apic/bigsmp_32.c    |    8 +-
 arch/x86/kernel/apic/io_apic.c      |  239 +++++++++++++++++------------------
 arch/x86/kernel/apic/nmi.c          |   29 ++---
 arch/x86/kernel/apic/numaq_32.c     |   53 ++++-----
 arch/x86/kernel/apic/probe_32.c     |   18 ++--
 arch/x86/kernel/apic/probe_64.c     |    8 +-
 arch/x86/kernel/apic/summit_32.c    |   23 ++--
 arch/x86/kernel/apic/x2apic_uv_x.c  |   26 ++--
 10 files changed, 225 insertions(+), 232 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 894aa97..50f7e6b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -14,6 +14,8 @@
  *	Mikael Pettersson	:	PM converted to driver model.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/perf_event.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
@@ -145,8 +147,7 @@ static int x2apic_preenabled;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
-		pr_warning("Bios already enabled x2apic, "
-			   "can't enforce nox2apic");
+		pr_warning("Bios already enabled x2apic, can't enforce nox2apic");
 		return 0;
 	}
 
@@ -587,14 +588,15 @@ calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)
 
 	res = (((u64)deltapm) *  mult) >> 22;
 	do_div(res, 1000000);
-	pr_warning("APIC calibration not consistent "
-		   "with PM-Timer: %ldms instead of 100ms\n",(long)res);
+	pr_warning("APIC calibration not consistent with PM-Timer: "
+		   "%ldms instead of 100ms\n",
+		   (long)res);
 
 	/* Correct the lapic counter value */
 	res = (((u64)(*delta)) * pm_100ms);
 	do_div(res, deltapm);
-	pr_info("APIC delta adjusted to PM-Timer: "
-		"%lu (%ld)\n", (unsigned long)res, *delta);
+	pr_info("APIC delta adjusted to PM-Timer: %lu (%ld)\n",
+		(unsigned long)res, *delta);
 	*delta = (long)res;
 
 	/* Correct the tsc counter value */
@@ -773,8 +775,8 @@ void __init setup_boot_APIC_clock(void)
 	if (nmi_watchdog != NMI_IO_APIC)
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
 	else
-		pr_warning("APIC timer registered as dummy,"
-			" due to nmi_watchdog=%d!\n", nmi_watchdog);
+		pr_warning("APIC timer registered as dummy, due to nmi_watchdog=%d!\n",
+			   nmi_watchdog);
 
 	/* Setup the lapic or request the broadcast */
 	setup_APIC_timer();
@@ -1371,8 +1373,7 @@ int __init enable_IR(void)
 	}
 
 	if (!x2apic_preenabled && skip_ioapic_setup) {
-		pr_info("Skipped enabling intr-remap because of skipping "
-			"io-apic setup\n");
+		pr_info("Skipped enabling intr-remap because of skipping io-apic setup\n");
 		return 0;
 	}
 
@@ -1398,7 +1399,7 @@ void __init enable_IR_x2apic(void)
 	dmar_table_init_ret = dmar_table_init();
 	if (dmar_table_init_ret)
 		pr_debug("dmar_table_init() failed with %d:\n",
-				dmar_table_init_ret);
+			 dmar_table_init_ret);
 #endif
 
 	ioapic_entries = alloc_ioapic_entries();
@@ -1512,8 +1513,7 @@ static int __init detect_init_APIC(void)
 		 * "lapic" specified.
 		 */
 		if (!force_enable_local_apic) {
-			pr_info("Local APIC disabled by BIOS -- "
-				"you can enable it with \"lapic\"\n");
+			pr_info("Local APIC disabled by BIOS -- you can enable it with \"lapic\"\n");
 			return -1;
 		}
 		/*
@@ -1596,7 +1596,7 @@ void __init init_apic_mappings(void)
 	/* If no local APIC can be found return early */
 	if (!smp_found_config && detect_init_APIC()) {
 		/* lets NOP'ify apic operations */
-		pr_info("APIC: disable apic facility\n");
+		pr_info("disable apic facility\n");
 		apic_disable();
 	} else {
 		apic_phys = mp_lapic_addr;
@@ -1659,7 +1659,7 @@ int __init APIC_init_uniprocessor(void)
 	if (!cpu_has_apic &&
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
-			boot_cpu_physical_apicid);
+		       boot_cpu_physical_apicid);
 		return -1;
 	}
 #endif
@@ -1742,8 +1742,8 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	inc_irq_stat(irq_spurious_count);
 
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	pr_info("spurious APIC interrupt on CPU#%d, "
-		"should never happen.\n", smp_processor_id());
+	pr_info("spurious APIC interrupt on CPU#%d, should never happen.\n",
+		smp_processor_id());
 	irq_exit();
 }
 
@@ -1775,7 +1775,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 	 * 7: Illegal register address
 	 */
 	pr_debug("APIC error on CPU%d: %02x(%02x)\n",
-		smp_processor_id(), v , v1);
+		 smp_processor_id(), v , v1);
 	irq_exit();
 }
 
@@ -1878,7 +1878,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	if (version == 0x0) {
 		pr_warning("BIOS bug, APIC version is 0 for CPU#%d! "
 			   "fixing up to 0x10. (tell your hw vendor)\n",
-				version);
+			   version);
 		version = 0x10;
 	}
 	apic_version[apicid] = version;
@@ -1887,9 +1887,9 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		int max = nr_cpu_ids;
 		int thiscpu = max + disabled_cpus;
 
-		pr_warning(
-			"ACPI: NR_CPUS/possible_cpus limit of %i reached."
-			"  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);
+		pr_warning("NR_CPUS/possible_cpus limit of %i reached."
+			   "  Processor %d/0x%x ignored.\n",
+			   max, thiscpu, apicid);
 
 		disabled_cpus++;
 		return;
@@ -2208,7 +2208,7 @@ static int __cpuinit set_multi(const struct dmi_system_id *d)
 {
 	if (multi)
 		return 0;
-	pr_info("APIC: %s detected, Multi Chassis\n", d->ident);
+	pr_info("%s detected, Multi Chassis\n", d->ident);
 	multi = 1;
 	return 0;
 }
@@ -2317,7 +2317,7 @@ static int __init apic_set_verbosity(char *arg)
 		apic_verbosity = APIC_VERBOSE;
 	else {
 		pr_warning("APIC Verbosity level %s not recognised"
-			" use apic=verbose or apic=debug\n", arg);
+			   " - use apic=verbose or apic=debug\n", arg);
 		return -EINVAL;
 	}
 
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index d0c99ab..34accf9 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -8,6 +8,9 @@
  * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
  * James Cleverdon.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
@@ -237,7 +240,7 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	 */
 	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
-		printk(KERN_DEBUG "system APIC only can use physical flat");
+		pr_dbg("system APIC only can use physical flat");
 		return 1;
 	}
 #endif
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 77a0641..7c21b11 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -3,6 +3,9 @@
  *
  * Drives the local APIC in "clustered mode".
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/kernel.h>
@@ -75,8 +78,7 @@ static void bigsmp_init_apic_ldr(void)
 
 static void bigsmp_setup_apic_routing(void)
 {
-	printk(KERN_INFO
-		"Enabling APIC mode:  Physflat.  Using %d I/O APICs\n",
+	pr_info("Enabling APIC mode:  Physflat.  Using %d I/O APICs\n",
 		nr_ioapics);
 }
 
@@ -166,7 +168,7 @@ static int dmi_bigsmp; /* can be set by dmi scanners */
 
 static int hp_ht_bigsmp(const struct dmi_system_id *d)
 {
-	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
+	pr_notice("%s detected: force use of apic=bigsmp\n", d->ident);
 	dmi_bigsmp = 1;
 
 	return 0;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index dc69f28..52d35b7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -20,6 +20,8 @@
  *	Paul Diefenbaugh	:	Added full ACPI support
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
@@ -249,7 +251,7 @@ int arch_init_chip_data(struct irq_desc *desc, int node)
 	if (!cfg) {
 		desc->chip_data = get_one_free_irq_cfg(node);
 		if (!desc->chip_data) {
-			printk(KERN_ERR "can not alloc irq_cfg\n");
+			pr_err("can not alloc irq_cfg\n");
 			BUG_ON(1);
 		}
 	}
@@ -516,8 +518,8 @@ add_pin_to_irq_node_nopanic(struct irq_cfg *cfg, int node, int apic, int pin)
 
 	entry = get_one_free_irq_2_pin(node);
 	if (!entry) {
-		printk(KERN_ERR "can not alloc irq_pin_list (%d,%d,%d)\n",
-				node, apic, pin);
+		pr_err("can not alloc irq_pin_list (%d,%d,%d)\n",
+		       node, apic, pin);
 		return -ENOMEM;
 	}
 	entry->apic = apic;
@@ -935,7 +937,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			pr_warning("broken BIOS!!\n");
 			polarity = 1;
 			break;
 		}
@@ -946,7 +948,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			pr_warning("broken BIOS!!\n");
 			polarity = 1;
 			break;
 		}
@@ -993,7 +995,7 @@ static int MPBIOS_trigger(int idx)
 				}
 				default:
 				{
-					printk(KERN_WARNING "broken BIOS!!\n");
+					pr_warning("broken BIOS!!\n");
 					trigger = 1;
 					break;
 				}
@@ -1007,7 +1009,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			pr_warning("broken BIOS!!\n");
 			trigger = 1;
 			break;
 		}
@@ -1018,7 +1020,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			pr_warning("broken BIOS!!\n");
 			trigger = 0;
 			break;
 		}
@@ -1046,7 +1048,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
 	if (mp_irqs[idx].dstirq != pin)
-		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
+		pr_err("broken BIOS or MPTABLE parser, ayiee!!\n");
 
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
@@ -1465,8 +1467,8 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, irq, &entry,
 			       dest, trigger, polarity, cfg->vector, pin)) {
-		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mp_ioapics[apic_id].apicid, pin);
+		pr_info("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+			mp_ioapics[apic_id].apicid, pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1531,7 +1533,7 @@ static void __init setup_IO_APIC_irqs(void)
 
 		desc = irq_to_desc_alloc_node(irq, node);
 		if (!desc) {
-			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+			pr_info("can not get irq_desc for %d\n", irq);
 			continue;
 		}
 		cfg = desc->chip_data;
@@ -1602,16 +1604,16 @@ __apicdebuginit(void) print_IO_APIC(void)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
-	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
+	pr_dbg("number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
-		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
+		pr_dbg("number of IO-APIC #%d registers: %d.\n",
 		       mp_ioapics[i].apicid, nr_ioapic_registers[i]);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
 	 * know about every hardware change ASAP.
 	 */
-	printk(KERN_INFO "testing the IO APIC.......................\n");
+	pr_info("testing the IO APIC.......................\n");
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 
@@ -1624,18 +1626,18 @@ __apicdebuginit(void) print_IO_APIC(void)
 		reg_03.raw = io_apic_read(apic, 3);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
-	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
-	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
-	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
-	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
-	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
+	pr_dbg("\n");
+	pr_dbg("IO APIC #%d......\n", mp_ioapics[apic].apicid);
+	pr_dbg(".... register #00: %08X\n", reg_00.raw);
+	pr_dbg(".......    : physical APIC id: %02X\n", reg_00.bits.ID);
+	pr_dbg(".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
+	pr_dbg(".......    : LTS          : %X\n", reg_00.bits.LTS);
 
-	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
-	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
+	pr_dbg(".... register #01: %08X\n", *(int *)&reg_01);
+	pr_dbg(".......     : max redirection entries: %04X\n", reg_01.bits.entries);
 
-	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
-	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
+	pr_dbg(".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
+	pr_dbg(".......     : IO APIC version: %04X\n", reg_01.bits.version);
 
 	/*
 	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
@@ -1643,8 +1645,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 	 * value, so ignore it if reg_02 == reg_01.
 	 */
 	if (reg_01.bits.version >= 0x10 && reg_02.raw != reg_01.raw) {
-		printk(KERN_DEBUG ".... register #02: %08X\n", reg_02.raw);
-		printk(KERN_DEBUG ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
+		pr_dbg(".... register #02: %08X\n", reg_02.raw);
+		pr_dbg(".......     : arbitration: %02X\n", reg_02.bits.arbitration);
 	}
 
 	/*
@@ -1654,38 +1656,33 @@ __apicdebuginit(void) print_IO_APIC(void)
 	 */
 	if (reg_01.bits.version >= 0x20 && reg_03.raw != reg_02.raw &&
 	    reg_03.raw != reg_01.raw) {
-		printk(KERN_DEBUG ".... register #03: %08X\n", reg_03.raw);
-		printk(KERN_DEBUG ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
+		pr_dbg(".... register #03: %08X\n", reg_03.raw);
+		pr_dbg(".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
 	}
 
-	printk(KERN_DEBUG ".... IRQ redirection table:\n");
+	pr_dbg(".... IRQ redirection table:\n");
 
-	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
-			  " Stat Dmod Deli Vect:   \n");
+	pr_dbg(" NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   \n");
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
 		struct IO_APIC_route_entry entry;
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %03X ",
-			i,
-			entry.dest
-		);
-
-		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
-			entry.mask,
-			entry.trigger,
-			entry.irr,
-			entry.polarity,
-			entry.delivery_status,
-			entry.dest_mode,
-			entry.delivery_mode,
-			entry.vector
-		);
+		pr_dbg(" %02x %03X %1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
+		       i,
+		       entry.dest,
+		       entry.mask,
+		       entry.trigger,
+		       entry.irr,
+		       entry.polarity,
+		       entry.delivery_status,
+		       entry.dest_mode,
+		       entry.delivery_mode,
+		       entry.vector);
 	}
 	}
-	printk(KERN_DEBUG "IRQ to pin mappings:\n");
+	pr_dbg("IRQ to pin mappings:\n");
 	for_each_irq_desc(irq, desc) {
 		struct irq_pin_list *entry;
 
@@ -1693,13 +1690,13 @@ __apicdebuginit(void) print_IO_APIC(void)
 		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
-		printk(KERN_DEBUG "IRQ%d ", irq);
+		pr_dbg("IRQ%d ", irq);
 		for_each_irq_pin(entry, cfg->irq_2_pin)
-			printk("-> %d:%d", entry->apic, entry->pin);
-		printk("\n");
+			pr_cont("-> %d:%d", entry->apic, entry->pin);
+		pr_cont("\n");
 	}
 
-	printk(KERN_INFO ".................................... done.\n");
+	pr_info(".................................... done.\n");
 
 	return;
 }
@@ -1711,12 +1708,12 @@ __apicdebuginit(void) print_APIC_field(int base)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
-	printk(KERN_DEBUG);
+	pr_dbg("");
 
 	for (i = 0; i < 8; i++)
-		printk(KERN_CONT "%08x", apic_read(base + i*0x10));
+		pr_cont("%08x", apic_read(base + i*0x10));
 
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 __apicdebuginit(void) print_local_APIC(void *dummy)
@@ -1727,26 +1724,26 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
-	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
+	pr_dbg("printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
+	pr_info("... APIC ID:      %08x (%01x)\n", v, read_apic_id());
 	v = apic_read(APIC_LVR);
-	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
+	pr_info("... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
 	maxlvt = lapic_get_maxlvt();
 
 	v = apic_read(APIC_TASKPRI);
-	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
+	pr_dbg("... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
 
 	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
 		if (!APIC_XAPIC(ver)) {
 			v = apic_read(APIC_ARBPRI);
-			printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
+			pr_dbg("... APIC ARBPRI: %08x (%02x)\n", v,
 			       v & APIC_ARBPRI_MASK);
 		}
 		v = apic_read(APIC_PROCPRI);
-		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
+		pr_dbg("... APIC PROCPRI: %08x\n", v);
 	}
 
 	/*
@@ -1755,23 +1752,23 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	 */
 	if (!APIC_INTEGRATED(ver) || maxlvt == 3) {
 		v = apic_read(APIC_RRR);
-		printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
+		pr_dbg("... APIC RRR: %08x\n", v);
 	}
 
 	v = apic_read(APIC_LDR);
-	printk(KERN_DEBUG "... APIC LDR: %08x\n", v);
+	pr_dbg("... APIC LDR: %08x\n", v);
 	if (!x2apic_enabled()) {
 		v = apic_read(APIC_DFR);
-		printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
+		pr_dbg("... APIC DFR: %08x\n", v);
 	}
 	v = apic_read(APIC_SPIV);
-	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
+	pr_dbg("... APIC SPIV: %08x\n", v);
 
-	printk(KERN_DEBUG "... APIC ISR field:\n");
+	pr_dbg("... APIC ISR field:\n");
 	print_APIC_field(APIC_ISR);
-	printk(KERN_DEBUG "... APIC TMR field:\n");
+	pr_dbg("... APIC TMR field:\n");
 	print_APIC_field(APIC_TMR);
-	printk(KERN_DEBUG "... APIC IRR field:\n");
+	pr_dbg("... APIC IRR field:\n");
 	print_APIC_field(APIC_IRR);
 
 	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
@@ -1779,49 +1776,49 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 			apic_write(APIC_ESR, 0);
 
 		v = apic_read(APIC_ESR);
-		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
+		pr_dbg("... APIC ESR: %08x\n", v);
 	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
+	pr_dbg("... APIC ICR: %08x\n", (u32)icr);
+	pr_dbg("... APIC ICR2: %08x\n", (u32)(icr >> 32));
 
 	v = apic_read(APIC_LVTT);
-	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
+	pr_dbg("... APIC LVTT: %08x\n", v);
 
 	if (maxlvt > 3) {                       /* PC is LVT#4. */
 		v = apic_read(APIC_LVTPC);
-		printk(KERN_DEBUG "... APIC LVTPC: %08x\n", v);
+		pr_dbg("... APIC LVTPC: %08x\n", v);
 	}
 	v = apic_read(APIC_LVT0);
-	printk(KERN_DEBUG "... APIC LVT0: %08x\n", v);
+	pr_dbg("... APIC LVT0: %08x\n", v);
 	v = apic_read(APIC_LVT1);
-	printk(KERN_DEBUG "... APIC LVT1: %08x\n", v);
+	pr_dbg("... APIC LVT1: %08x\n", v);
 
 	if (maxlvt > 2) {			/* ERR is LVT#3. */
 		v = apic_read(APIC_LVTERR);
-		printk(KERN_DEBUG "... APIC LVTERR: %08x\n", v);
+		pr_dbg("... APIC LVTERR: %08x\n", v);
 	}
 
 	v = apic_read(APIC_TMICT);
-	printk(KERN_DEBUG "... APIC TMICT: %08x\n", v);
+	pr_dbg("... APIC TMICT: %08x\n", v);
 	v = apic_read(APIC_TMCCT);
-	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
+	pr_dbg("... APIC TMCCT: %08x\n", v);
 	v = apic_read(APIC_TDCR);
-	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
+	pr_dbg("... APIC TDCR: %08x\n", v);
 
 	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
 		v = apic_read(APIC_EFEAT);
 		maxlvt = (v >> 16) & 0xff;
-		printk(KERN_DEBUG "... APIC EFEAT: %08x\n", v);
+		pr_dbg("... APIC EFEAT: %08x\n", v);
 		v = apic_read(APIC_ECTRL);
-		printk(KERN_DEBUG "... APIC ECTRL: %08x\n", v);
+		pr_dbg("... APIC ECTRL: %08x\n", v);
 		for (i = 0; i < maxlvt; i++) {
 			v = apic_read(APIC_EILVTn(i));
-			printk(KERN_DEBUG "... APIC EILVT%d: %08x\n", i, v);
+			pr_dbg("... APIC EILVT%d: %08x\n", i, v);
 		}
 	}
-	printk("\n");
+	pr_dbg("\n");
 }
 
 __apicdebuginit(void) print_all_local_APICs(void)
@@ -1842,15 +1839,15 @@ __apicdebuginit(void) print_PIC(void)
 	if (apic_verbosity == APIC_QUIET || !nr_legacy_irqs)
 		return;
 
-	printk(KERN_DEBUG "\nprinting PIC contents\n");
+	pr_dbg("\nprinting PIC contents\n");
 
 	spin_lock_irqsave(&i8259A_lock, flags);
 
 	v = inb(0xa1) << 8 | inb(0x21);
-	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
+	pr_dbg("... PIC  IMR: %04x\n", v);
 
 	v = inb(0xa0) << 8 | inb(0x20);
-	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
+	pr_dbg("... PIC  IRR: %04x\n", v);
 
 	outb(0x0b,0xa0);
 	outb(0x0b,0x20);
@@ -1860,10 +1857,10 @@ __apicdebuginit(void) print_PIC(void)
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
+	pr_dbg("... PIC  ISR: %04x\n", v);
 
 	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
+	pr_dbg("... PIC ELCR: %04x\n", v);
 }
 
 __apicdebuginit(int) print_all_ICs(void)
@@ -1933,7 +1930,7 @@ void __init enable_IO_APIC(void)
 	i8259_apic = find_isa_irq_apic(0, mp_ExtINT);
 	/* Trust the MP table if nothing is setup in the hardware */
 	if ((ioapic_i8259.pin == -1) && (i8259_pin >= 0)) {
-		printk(KERN_WARNING "ExtINT not setup in hardware but reported by MP table\n");
+		pr_warning("ExtINT not setup in hardware but reported by MP table\n");
 		ioapic_i8259.pin  = i8259_pin;
 		ioapic_i8259.apic = i8259_apic;
 	}
@@ -1941,7 +1938,7 @@ void __init enable_IO_APIC(void)
 	if (((ioapic_i8259.apic != i8259_apic) || (ioapic_i8259.pin != i8259_pin)) &&
 		(i8259_pin >= 0) && (ioapic_i8259.pin >= 0))
 	{
-		printk(KERN_WARNING "ExtINT in hardware and MP table differ\n");
+		pr_warning("ExtINT in hardware and MP table differ\n");
 	}
 
 	/*
@@ -2046,9 +2043,9 @@ void __init setup_ioapic_ids_from_mpc(void)
 		old_id = mp_ioapics[apic_id].apicid;
 
 		if (mp_ioapics[apic_id].apicid >= get_physical_broadcast()) {
-			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
+			pr_err("BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
 				apic_id, mp_ioapics[apic_id].apicid);
-			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+			pr_err("... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
 			mp_ioapics[apic_id].apicid = reg_00.bits.ID;
 		}
@@ -2060,14 +2057,14 @@ void __init setup_ioapic_ids_from_mpc(void)
 		 */
 		if (apic->check_apicid_used(phys_id_present_map,
 					mp_ioapics[apic_id].apicid)) {
-			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
+			pr_err("BIOS bug, IO-APIC#%d ID %d is already used!...\n",
 				apic_id, mp_ioapics[apic_id].apicid);
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
 			if (i >= get_physical_broadcast())
 				panic("Max APIC ID exceeded!\n");
-			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+			pr_err("... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
 			mp_ioapics[apic_id].apicid = i;
@@ -2111,7 +2108,7 @@ void __init setup_ioapic_ids_from_mpc(void)
 		reg_00.raw = io_apic_read(apic_id, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		if (reg_00.bits.ID != mp_ioapics[apic_id].apicid)
-			printk("could not set ID!\n");
+			pr_cont("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
 	}
@@ -3108,7 +3105,7 @@ static int __init ioapic_init_sysfs(void)
 			* sizeof(struct IO_APIC_route_entry);
 		mp_ioapic_data[i] = kzalloc(size, GFP_KERNEL);
 		if (!mp_ioapic_data[i]) {
-			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
+			pr_err("Can't suspend/resume IOAPIC %d\n", i);
 			continue;
 		}
 		dev = &mp_ioapic_data[i]->dev;
@@ -3118,7 +3115,7 @@ static int __init ioapic_init_sysfs(void)
 		if (error) {
 			kfree(mp_ioapic_data[i]);
 			mp_ioapic_data[i] = NULL;
-			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
+			pr_err("Can't suspend/resume IOAPIC %d\n", i);
 			continue;
 		}
 	}
@@ -3148,7 +3145,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	for (new = irq_want; new < nr_irqs; new++) {
 		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
-			printk(KERN_INFO "can not get irq_desc for %d\n", new);
+			pr_info("can not get irq_desc for %d\n", new);
 			continue;
 		}
 		cfg_new = desc_new->chip_data;
@@ -3390,15 +3387,13 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 
 	iommu = map_dev_to_ir(dev);
 	if (!iommu) {
-		printk(KERN_ERR
-		       "Unable to map PCI %s to iommu\n", pci_name(dev));
+		pr_err("Unable to map PCI %s to iommu\n", pci_name(dev));
 		return -ENOENT;
 	}
 
 	index = alloc_irte(iommu, irq, nvec);
 	if (index < 0) {
-		printk(KERN_ERR
-		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
+		pr_err("Unable to allocate %d IRTE for PCI %s\n", nvec,
 		       pci_name(dev));
 		return -ENOSPC;
 	}
@@ -3808,7 +3803,7 @@ void __init probe_nr_irqs_gsi(void)
 			nr_irqs_gsi = nr;
 	}
 
-	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
+	pr_dbg("nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
 #ifdef CONFIG_SPARSE_IRQ
@@ -3856,7 +3851,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
-		printk(KERN_INFO "can not get irq_desc %d\n", irq);
+		pr_info("can not get irq_desc %d\n", irq);
 		return 0;
 	}
 
@@ -3870,7 +3865,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	if (irq >= nr_legacy_irqs) {
 		cfg = desc->chip_data;
 		if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
-			printk(KERN_INFO "can not add pin %d for irq %d\n",
+			pr_info("can not add pin %d for irq %d\n",
 				pin, irq);
 			return 0;
 		}
@@ -3951,8 +3946,8 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	if (apic_id >= get_physical_broadcast()) {
-		printk(KERN_WARNING "IOAPIC[%d]: Invalid apic_id %d, trying "
-			"%d\n", ioapic, apic_id, reg_00.bits.ID);
+		pr_warning("IOAPIC[%d]: Invalid apic_id %d, trying %d\n",
+			   ioapic, apic_id, reg_00.bits.ID);
 		apic_id = reg_00.bits.ID;
 	}
 
@@ -3970,8 +3965,8 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 		if (i == get_physical_broadcast())
 			panic("Max apic_id exceeded!\n");
 
-		printk(KERN_WARNING "IOAPIC[%d]: apic_id %d already used, "
-			"trying %d\n", ioapic, apic_id, i);
+		pr_warning("IOAPIC[%d]: apic_id %d already used, trying %d\n",
+			   ioapic, apic_id, i);
 
 		apic_id = i;
 	}
@@ -3989,7 +3984,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 
 		/* Sanity check */
 		if (reg_00.bits.ID != apic_id) {
-			printk("IOAPIC[%d]: Unable to change apic_id!\n", ioapic);
+			pr_info("IOAPIC[%d]: Unable to change apic_id!\n", ioapic);
 			return -1;
 		}
 	}
@@ -4127,9 +4122,7 @@ void __init ioapic_init_mappings(void)
 			ioapic_phys = mp_ioapics[i].apicaddr;
 #ifdef CONFIG_X86_32
 			if (!ioapic_phys) {
-				printk(KERN_ERR
-				       "WARNING: bogus zero IO-APIC "
-				       "address found in MPTABLE, "
+				pr_err("WARNING: bogus zero IO-APIC address found in MPTABLE, "
 				       "disabling IO/APIC support!\n");
 				smp_found_config = 0;
 				skip_ioapic_setup = 1;
@@ -4163,8 +4156,7 @@ void __init ioapic_insert_resources(void)
 
 	if (!r) {
 		if (nr_ioapics > 0)
-			printk(KERN_ERR
-				"IO APIC resources couldn't be allocated.\n");
+			pr_err("IO APIC resources couldn't be allocated.\n");
 		return;
 	}
 
@@ -4185,7 +4177,7 @@ int mp_find_ioapic(int gsi)
 			return i;
 	}
 
-	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
+	pr_err("ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
 	return -1;
 }
 
@@ -4202,13 +4194,12 @@ int mp_find_ioapic_pin(int ioapic, int gsi)
 static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
-		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
+		pr_warning("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping!\n",
+			   MAX_IO_APICS, nr_ioapics);
 		return 1;
 	}
 	if (!address) {
-		printk(KERN_WARNING "WARNING: Bogus (zero) I/O APIC address"
-		       " found in table, skipping!\n");
+		pr_warning("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
 		return 1;
 	}
 	return 0;
@@ -4239,10 +4230,10 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	mp_gsi_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
-	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
-	       mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
+	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
+		idx, mp_ioapics[idx].apicid,
+		mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
+		mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
 
 	nr_ioapics++;
 }
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 7ff61d6..b02fd66 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -11,6 +11,8 @@
  *  Mikael Pettersson	: PM converted to driver model. Disable/enable API.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/apic.h>
 
 #include <linux/nmi.h>
@@ -106,16 +108,13 @@ static __init void nmi_cpu_busy(void *data)
 
 static void report_broken_nmi(int cpu, unsigned int *prev_nmi_count)
 {
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 
-	printk(KERN_WARNING
-		"WARNING: CPU#%d: NMI appears to be stuck (%d->%d)!\n",
-			cpu, prev_nmi_count[cpu], get_nmi_count(cpu));
+	pr_warning("WARNING: CPU#%d: NMI appears to be stuck (%d->%d)!\n",
+		   cpu, prev_nmi_count[cpu], get_nmi_count(cpu));
 
-	printk(KERN_WARNING
-		"Please report this to bugzilla.kernel.org,\n");
-	printk(KERN_WARNING
-		"and attach the output of the 'dmesg' command.\n");
+	pr_warning("Please report this to bugzilla.kernel.org,\n");
+	pr_warning("and attach the output of the 'dmesg' command.\n");
 
 	per_cpu(wd_enabled, cpu) = 0;
 	atomic_dec(&nmi_active);
@@ -138,7 +137,7 @@ int __init check_nmi_watchdog(void)
 	if (!prev_nmi_count)
 		goto error;
 
-	printk(KERN_INFO "Testing NMI watchdog ... ");
+	pr_info("Testing NMI watchdog ... ");
 
 #ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -162,7 +161,7 @@ int __init check_nmi_watchdog(void)
 		atomic_set(&nmi_active, -1);
 		goto error;
 	}
-	printk("OK.\n");
+	pr_cont("OK.\n");
 
 	/*
 	 * now that we know it works we can reduce NMI frequency to
@@ -418,7 +417,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
-		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
+		pr_warning("NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
 		dump_stack();
 		spin_unlock(&lock);
@@ -520,8 +519,7 @@ int proc_nmi_enabled(struct ctl_table *table, int write,
 		return 0;
 
 	if (atomic_read(&nmi_active) < 0 || !nmi_watchdog_active()) {
-		printk(KERN_WARNING
-			"NMI watchdog is permanently disabled\n");
+		pr_warning("NMI watchdog is permanently disabled\n");
 		return -EIO;
 	}
 
@@ -536,8 +534,7 @@ int proc_nmi_enabled(struct ctl_table *table, int write,
 		else
 			disable_ioapic_nmi_watchdog();
 	} else {
-		printk(KERN_WARNING
-			"NMI watchdog doesn't know what hardware to touch\n");
+		pr_warning("NMI watchdog doesn't know what hardware to touch\n");
 		return -EIO;
 	}
 	return 0;
@@ -560,7 +557,7 @@ void arch_trigger_all_cpu_backtrace(void)
 
 	cpumask_copy(&backtrace_mask, cpu_online_mask);
 
-	printk(KERN_INFO "sending NMI to all CPUs:\n");
+	pr_info("sending NMI to all CPUs:\n");
 	apic->send_IPI_all(NMI_VECTOR);
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index efa00e2..d95e5c3 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -23,6 +23,9 @@
  *
  * Send feedback to <gone@us.ibm.com>
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/nodemask.h>
 #include <linux/topology.h>
 #include <linux/bootmem.h>
@@ -124,7 +127,7 @@ void __cpuinit numaq_tsc_disable(void)
 		return;
 
 	if (num_online_nodes() > 1) {
-		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
+		pr_dbg("NUMAQ: disabling TSC\n");
 		setup_clear_cpu_cap(X86_FEATURE_TSC);
 	}
 }
@@ -145,11 +148,10 @@ static int mpc_apic_id(struct mpc_cpu *m)
 	int quad = translation_table[mpc_record]->trans_quad;
 	int logical_apicid = generate_logical_apicid(quad, m->apicid);
 
-	printk(KERN_DEBUG
-		"Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
-		 m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
-		(m->cpufeature & CPU_MODEL_MASK) >> 4,
-		 m->apicver, quad, logical_apicid);
+	pr_dbg("Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
+	       m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->cpufeature & CPU_MODEL_MASK) >> 4,
+	       m->apicver, quad, logical_apicid);
 
 	return logical_apicid;
 }
@@ -163,7 +165,7 @@ static void mpc_oem_bus_info(struct mpc_bus *m, char *name)
 	mp_bus_id_to_node[m->busid] = quad;
 	mp_bus_id_to_local[m->busid] = local;
 
-	printk(KERN_INFO "Bus #%d is %s (node %d)\n", m->busid, name, quad);
+	pr_info("Bus #%d is %s (node %d)\n", m->busid, name, quad);
 }
 
 /* x86_quirks member */
@@ -190,13 +192,12 @@ static void numaq_mpc_record(unsigned int mode)
 
 static void __init MP_translation_info(struct mpc_trans *m)
 {
-	printk(KERN_INFO
-	    "Translation: record %d, type %d, quad %d, global %d, local %d\n",
-	       mpc_record, m->trans_type, m->trans_quad, m->trans_global,
-	       m->trans_local);
+	pr_info("Translation: record %d, type %d, quad %d, global %d, local %d\n",
+		mpc_record, m->trans_type, m->trans_quad, m->trans_global,
+		m->trans_local);
 
 	if (mpc_record >= MAX_MPC_ENTRY)
-		printk(KERN_ERR "MAX_MPC_ENTRY exceeded!\n");
+		pr_err("MAX_MPC_ENTRY exceeded!\n");
 	else
 		translation_table[mpc_record] = m; /* stash this for later */
 
@@ -224,19 +225,17 @@ static void __init smp_read_mpc_oem(struct mpc_table *mpc)
 	unsigned char *oemptr = ((unsigned char *)oemtable) + count;
 
 	mpc_record = 0;
-	printk(KERN_INFO
-		"Found an OEM MPC table at %8p - parsing it ... \n", oemtable);
+	pr_info("Found an OEM MPC table at %8p - parsing it ... \n", oemtable);
 
 	if (memcmp(oemtable->signature, MPC_OEM_SIGNATURE, 4)) {
-		printk(KERN_WARNING
-		       "SMP mpc oemtable: bad signature [%c%c%c%c]!\n",
-		       oemtable->signature[0], oemtable->signature[1],
-		       oemtable->signature[2], oemtable->signature[3]);
+		pr_warning("SMP mpc oemtable: bad signature [%c%c%c%c]!\n",
+			   oemtable->signature[0], oemtable->signature[1],
+			   oemtable->signature[2], oemtable->signature[3]);
 		return;
 	}
 
 	if (mpf_checksum((unsigned char *)oemtable, oemtable->length)) {
-		printk(KERN_WARNING "SMP oem mptable: checksum error!\n");
+		pr_warning("SMP oem mptable: checksum error!\n");
 		return;
 	}
 
@@ -253,9 +252,8 @@ static void __init smp_read_mpc_oem(struct mpc_table *mpc)
 				break;
 			}
 		default:
-			printk(KERN_WARNING
-			       "Unrecognised OEM table entry type! - %d\n",
-			       (int)*oemptr);
+			pr_warning("Unrecognised OEM table entry type! - %d\n",
+				   (int)*oemptr);
 			return;
 		}
 	}
@@ -357,8 +355,7 @@ static inline void numaq_init_apic_ldr(void)
 
 static inline void numaq_setup_apic_routing(void)
 {
-	printk(KERN_INFO
-		"Enabling APIC mode:  NUMA-Q.  Using %d I/O APICs\n",
+	pr_info("Enabling APIC mode:  NUMA-Q.  Using %d I/O APICs\n",
 		nr_ioapics);
 }
 
@@ -444,7 +441,7 @@ static int
 numaq_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	if (strncmp(oem, "IBM NUMA", 8))
-		printk(KERN_ERR "Warning! Not a NUMA-Q system!\n");
+		pr_err("Warning! Not a NUMA-Q system!\n");
 	else
 		found_numaq = 1;
 
@@ -478,13 +475,11 @@ static void numaq_setup_portio_remap(void)
 	if (num_quads <= 1)
 		return;
 
-	printk(KERN_INFO
-		"Remapping cross-quad port I/O for %d quads\n", num_quads);
+	pr_info("Remapping cross-quad port I/O for %d quads\n", num_quads);
 
 	xquad_portio = ioremap(XQUAD_PORTIO_BASE, num_quads*XQUAD_PORTIO_QUAD);
 
-	printk(KERN_INFO
-		"xquad_portio vaddr 0x%08lx, len %08lx\n",
+	pr_info("xquad_portio vaddr 0x%08lx, len %08lx\n",
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }
 
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 0c0182c..7914b69 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -6,6 +6,9 @@
  *
  * Generic x86 APIC driver probe layer.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
@@ -55,9 +58,7 @@ late_initcall(print_ipi_mode);
 void default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_IO_APIC
-	printk(KERN_INFO
-		"Enabling APIC mode:  Flat.  Using %d I/O APICs\n",
-		nr_ioapics);
+	pr_info("Enabling APIC mode:  Flat.  Using %d I/O APICs\n", nr_ioapics);
 #endif
 }
 
@@ -205,8 +206,7 @@ void __init generic_bigsmp_probe(void)
 	if (!cmdline_apic && apic == &apic_default) {
 		if (apic_bigsmp.probe()) {
 			apic = &apic_bigsmp;
-			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       apic->name);
+			pr_info("Overriding APIC driver with %s\n", apic->name);
 		}
 	}
 #endif
@@ -226,7 +226,7 @@ void __init generic_apic_probe(void)
 		if (!apic_probe[i])
 			panic("Didn't find an APIC driver");
 	}
-	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
+	pr_info("Using APIC driver %s\n", apic->name);
 }
 
 /* These functions can switch the APIC even after the initial ->probe() */
@@ -244,8 +244,7 @@ generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 
 		if (!cmdline_apic) {
 			apic = apic_probe[i];
-			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-			       apic->name);
+			pr_info("Switched to APIC driver `%s'.\n", apic->name);
 		}
 		return 1;
 	}
@@ -264,8 +263,7 @@ int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 		if (!cmdline_apic) {
 			apic = apic_probe[i];
-			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-			       apic->name);
+			pr_info("Switched to APIC driver `%s'.\n", apic->name);
 		}
 		return 1;
 	}
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index c4cbd30..8bdc8fd 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -8,6 +8,9 @@
  * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
  * James Cleverdon.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
@@ -79,7 +82,7 @@ void __init default_setup_apic_routing(void)
 		}
 	}
 
-	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
+	pr_info("Setting APIC routing to %s\n", apic->name);
 
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
@@ -108,8 +111,7 @@ int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	for (i = 0; apic_probe[i]; ++i) {
 		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
 			apic = apic_probe[i];
-			printk(KERN_INFO "Setting APIC routing to %s.\n",
-				apic->name);
+			pr_info("Setting APIC routing to %s.\n", apic->name);
 			return 1;
 		}
 	}
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 645ecc4..a118786 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <asm/io.h>
@@ -228,8 +230,8 @@ static int summit_apic_id_registered(void)
 
 static void summit_setup_apic_routing(void)
 {
-	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
-						nr_ioapics);
+	pr_info("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
+		nr_ioapics);
 }
 
 static int summit_apicid_to_node(int logical_apicid)
@@ -289,7 +291,7 @@ static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
 		int new_apicid = summit_cpu_to_logical_apicid(cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
-			printk("%s: Not a valid mask!\n", __func__);
+			pr_err("%s: Not a valid mask!\n", __func__);
 			return BAD_APICID;
 		}
 		apicid |= new_apicid;
@@ -369,7 +371,7 @@ static int setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		}
 	}
 	if (i == rio_table_hdr->num_rio_dev) {
-		printk(KERN_ERR "%s: Couldn't find owner Cyclone for Winnipeg!\n", __func__);
+		pr_err("%s: Couldn't find owner Cyclone for Winnipeg!\n", __func__);
 		return last_bus;
 	}
 
@@ -380,7 +382,7 @@ static int setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		}
 	}
 	if (i == rio_table_hdr->num_scal_dev) {
-		printk(KERN_ERR "%s: Couldn't find owner Twister for Cyclone!\n", __func__);
+		pr_err("%s: Couldn't find owner Twister for Cyclone!\n", __func__);
 		return last_bus;
 	}
 
@@ -410,7 +412,7 @@ static int setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		num_buses = 9;
 		break;
 	default:
-		printk(KERN_INFO "%s: Unsupported Winnipeg type!\n", __func__);
+		pr_info("%s: Unsupported Winnipeg type!\n", __func__);
 		return last_bus;
 	}
 
@@ -425,13 +427,15 @@ static int build_detail_arrays(void)
 	int i, scal_detail_size, rio_detail_size;
 
 	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES) {
-		printk(KERN_WARNING "%s: MAX_NUMNODES too low!  Defined as %d, but system has %d nodes.\n", __func__, MAX_NUMNODES, rio_table_hdr->num_scal_dev);
+		pr_warning("%s: MAX_NUMNODES too low!  Defined as %d, but system has %d nodes.\n",
+			   __func__, MAX_NUMNODES, rio_table_hdr->num_scal_dev);
 		return 0;
 	}
 
 	switch (rio_table_hdr->version) {
 	default:
-		printk(KERN_WARNING "%s: Invalid Rio Grande Table Version: %d\n", __func__, rio_table_hdr->version);
+		pr_warning("%s: Invalid Rio Grande Table Version: %d\n",
+			   __func__, rio_table_hdr->version);
 		return 0;
 	case 2:
 		scal_detail_size = 11;
@@ -476,7 +480,8 @@ void setup_summit(void)
 		offset = *((unsigned short *)(ptr + offset));
 	}
 	if (!rio_table_hdr) {
-		printk(KERN_ERR "%s: Unable to locate Rio Grande Table in EBDA - bailing!\n", __func__);
+		pr_err("%s: Unable to locate Rio Grande Table in EBDA - bailing!\n",
+		       __func__);
 		return;
 	}
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..547c2bc 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -7,6 +7,9 @@
  *
  * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
 #include <linux/proc_fs.h>
@@ -371,8 +374,8 @@ static __init void map_high(char *id, unsigned long base, int shift,
 
 	paddr = base << shift;
 	bytes = (1UL << shift) * (max_pnode + 1);
-	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
-						paddr + bytes);
+	pr_info("UV: Map %s_HI 0x%lx - 0x%lx\n",
+		id, paddr, paddr + bytes);
 	if (map_type == map_uc)
 		init_extra_mapping_uc(paddr, bytes);
 	else
@@ -417,9 +420,7 @@ static __init void uv_rtc_init(void)
 	status = uv_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK,
 					&ticks_per_sec);
 	if (status != BIOS_STATUS_SUCCESS || ticks_per_sec < 100000) {
-		printk(KERN_WARNING
-			"unable to determine platform RTC clock frequency, "
-			"guessing.\n");
+		pr_warning("unable to determine platform RTC clock frequency, guessing.\n");
 		/* BIOS gives wrong value for clock freq. so guess */
 		sn_rtc_cycles_per_second = 1000000000000UL / 30000UL;
 	} else
@@ -560,15 +561,15 @@ void __init uv_system_init(void)
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_extra = (node_id.s.node_id & ~((1 << n_val) - 1)) >> 1;
 	gnode_upper = ((unsigned long)gnode_extra  << m_val);
-	printk(KERN_DEBUG "UV: N %d, M %d, gnode_upper 0x%lx, gnode_extra 0x%x\n",
-			n_val, m_val, gnode_upper, gnode_extra);
+	pr_dbg("UV: N %d, M %d, gnode_upper 0x%lx, gnode_extra 0x%x\n",
+	       n_val, m_val, gnode_upper, gnode_extra);
 
-	printk(KERN_DEBUG "UV: global MMR base 0x%lx\n", mmr_base);
+	pr_dbg("UV: global MMR base 0x%lx\n", mmr_base);
 
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
 		uv_possible_blades +=
 		  hweight64(uv_read_local_mmr( UVH_NODE_PRESENT_TABLE + i * 8));
-	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
+	pr_dbg("UV: Found %d blades\n", uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
@@ -634,10 +635,9 @@ void __init uv_system_init(void)
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
 
-		printk(KERN_DEBUG "UV: cpu %d, apicid 0x%x, pnode %d, nid %d, "
-			"lcpu %d, blade %d\n",
-			cpu, per_cpu(x86_cpu_to_apicid, cpu), pnode, nid,
-			lcpu, blade);
+		pr_dbg("UV: cpu %d, apicid 0x%x, pnode %d, nid %d, lcpu %d, blade %d\n",
+		       cpu, per_cpu(x86_cpu_to_apicid, cpu), pnode, nid,
+		       lcpu, blade);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
-- 
1.6.3.1.10.g659a0.dirty

