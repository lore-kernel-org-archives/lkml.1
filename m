Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZIKTc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZIKTc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZIKTcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:32:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43587 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbZIKTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:32:44 -0400
Date: Fri, 11 Sep 2009 21:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/apic for v2.6.32
Message-ID: <20090911193227.GA24320@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.3 required=5.9 tests=BAYES_00,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.5
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

 Thanks,

	Ingo

------------------>
Bartlomiej Zolnierkiewicz (1):
      x86: Remove superfluous NULL pointer check in destroy_irq()

Cyrill Gorcunov (7):
      x86, ioapic: Introduce for_each_irq_pin() helper
      x86, ioapic: Throw BUG instead of NULL dereference
      x86, apic: Drop redundant bit assignment
      x86, ioapic: Panic on irq-pin binding only if needed
      x86, ioapic: Define IO_APIC_DEFAULT_PHYS_BASE constant
      x86, ioapic: Get rid of needless check and simplify ioapic_setup_resources()
      x86, apic: Slim down stack usage in early_init_lapic_mapping()

Feng Tang (1):
      ACPI, x86: expose some IO-APIC routines when CONFIG_ACPI=n

Gleb Natapov (1):
      x86/apic: Enable x2APIC without interrupt remapping under KVM

Jeremy Fitzhardinge (12):
      x86/acpi: acpi_parse_madt_ioapic_entries: remove redundant braces
      x86/ioapic.c: ioapic_modify_irq is too large to inline
      x86/ioapic.c: unify __mask_IO_APIC_irq()
      x86/ioapic.c: remove #ifdef for 82093AA workaround
      x86/ioapic.c: remove redundant declaration of irq_pin_list
      x86/ioapic.c: move lost comment to what seems like appropriate place
      x86/ioapic.c: convert io_apic_level_ack_pending loop to normal for() loop
      x86/ioapic.c: simplify add_pin_to_irq_node()
      x86/ioapic.c: convert replace_pin_at_irq_node to conventional for() loop
      x86/ioapic.c: clean up replace_pin_at_irq_node logic and comments
      x86/ioapic.c: convert __target_IO_APIC_irq to conventional for() loop
      x86/ioapic.c: unify ioapic_retrigger_irq()

Roel Kluin (1):
      x86: Fix x86_model test in es7000_apic_is_cluster()

Yinghai Lu (1):
      x86, apic: Move dmar_table_init() out of enable_IR()


 arch/x86/include/asm/apic.h      |    7 +
 arch/x86/include/asm/apicdef.h   |    3 +-
 arch/x86/include/asm/io_apic.h   |   13 ++-
 arch/x86/kernel/acpi/boot.c      |  105 +------------
 arch/x86/kernel/apic/apic.c      |  110 +++++++------
 arch/x86/kernel/apic/es7000_32.c |    2 +-
 arch/x86/kernel/apic/io_apic.c   |  324 +++++++++++++++++++++-----------------
 arch/x86/kernel/apic/probe_64.c  |    6 +-
 arch/x86/kernel/mpparse.c        |   10 +-
 9 files changed, 269 insertions(+), 311 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index bb7d479..586b7ad 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -183,6 +183,10 @@ static inline int x2apic_enabled(void)
 }
 
 #define x2apic_supported()	(cpu_has_x2apic)
+static inline void x2apic_force_phys(void)
+{
+	x2apic_phys = 1;
+}
 #else
 static inline void check_x2apic(void)
 {
@@ -194,6 +198,9 @@ static inline int x2apic_enabled(void)
 {
 	return 0;
 }
+static inline void x2apic_force_phys(void)
+{
+}
 
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 7ddb36a..7386bfa 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -8,7 +8,8 @@
  * Ingo Molnar <mingo@redhat.com>, 1999, 2000
  */
 
-#define	APIC_DEFAULT_PHYS_BASE	0xfee00000
+#define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
+#define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
 #define	APIC_ID		0x20
 
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 330ee80..85232d3 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,11 +150,10 @@ extern int timer_through_8259;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-#ifdef CONFIG_ACPI
+extern u8 io_apic_unique_id(u8 id);
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-#endif /* CONFIG_ACPI */
 
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
@@ -177,6 +176,16 @@ extern int setup_ioapic_entry(int apic, int irq,
 			      int polarity, int vector, int pin);
 extern void ioapic_write_entry(int apic, int pin,
 			       struct IO_APIC_route_entry e);
+
+struct mp_ioapic_gsi{
+	int gsi_base;
+	int gsi_end;
+};
+extern struct mp_ioapic_gsi  mp_gsi_routing[];
+int mp_find_ioapic(int gsi);
+int mp_find_ioapic_pin(int ioapic, int gsi);
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6b8ca3a..67e929b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -833,106 +833,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
 extern int es7000_plat;
 #endif
 
-static struct {
-	int gsi_base;
-	int gsi_end;
-} mp_ioapic_routing[MAX_IO_APICS];
-
-int mp_find_ioapic(int gsi)
-{
-	int i = 0;
-
-	/* Find the IOAPIC that manages this GSI. */
-	for (i = 0; i < nr_ioapics; i++) {
-		if ((gsi >= mp_ioapic_routing[i].gsi_base)
-		    && (gsi <= mp_ioapic_routing[i].gsi_end))
-			return i;
-	}
-
-	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
-	return -1;
-}
-
-int mp_find_ioapic_pin(int ioapic, int gsi)
-{
-	if (WARN_ON(ioapic == -1))
-		return -1;
-	if (WARN_ON(gsi > mp_ioapic_routing[ioapic].gsi_end))
-		return -1;
-
-	return gsi - mp_ioapic_routing[ioapic].gsi_base;
-}
-
-static u8 __init uniq_ioapic_id(u8 id)
-{
-#ifdef CONFIG_X86_32
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
-	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return io_apic_get_unique_id(nr_ioapics, id);
-	else
-		return id;
-#else
-	int i;
-	DECLARE_BITMAP(used, 256);
-	bitmap_zero(used, 256);
-	for (i = 0; i < nr_ioapics; i++) {
-		struct mpc_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->apicid, used);
-	}
-	if (!test_bit(id, used))
-		return id;
-	return find_first_zero_bit(used, 256);
-#endif
-}
-
-static int bad_ioapic(unsigned long address)
-{
-	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_ERR "ERROR: Max # of I/O APICs (%d) exceeded "
-		       "(found %d)\n", MAX_IO_APICS, nr_ioapics);
-		panic("Recompile kernel with bigger MAX_IO_APICS!\n");
-	}
-	if (!address) {
-		printk(KERN_ERR "WARNING: Bogus (zero) I/O APIC address"
-		       " found in table, skipping!\n");
-		return 1;
-	}
-	return 0;
-}
-
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
-{
-	int idx = 0;
-
-	if (bad_ioapic(address))
-		return;
-
-	idx = nr_ioapics;
-
-	mp_ioapics[idx].type = MP_IOAPIC;
-	mp_ioapics[idx].flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].apicaddr = address;
-
-	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].apicid = uniq_ioapic_id(id);
-	mp_ioapics[idx].apicver = io_apic_get_version(idx);
-
-	/*
-	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
-	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
-	 */
-	mp_ioapic_routing[idx].gsi_base = gsi_base;
-	mp_ioapic_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
-
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
-	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
-	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
-
-	nr_ioapics++;
-}
-
 int __init acpi_probe_gsi(void)
 {
 	int idx;
@@ -947,7 +847,7 @@ int __init acpi_probe_gsi(void)
 
 	max_gsi = 0;
 	for (idx = 0; idx < nr_ioapics; idx++) {
-		gsi = mp_ioapic_routing[idx].gsi_end;
+		gsi = mp_gsi_routing[idx].gsi_end;
 
 		if (gsi > max_gsi)
 			max_gsi = gsi;
@@ -1179,9 +1079,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	 * If MPS is present, it will handle them,
 	 * otherwise the system will stay in PIC mode
 	 */
-	if (acpi_disabled || acpi_noirq) {
+	if (acpi_disabled || acpi_noirq)
 		return -ENODEV;
-	}
 
 	if (!cpu_has_apic)
 		return -ENODEV;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0a1c283..159740d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -49,6 +49,7 @@
 #include <asm/mtrr.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
+#include <asm/kvm_para.h>
 
 unsigned int num_processors;
 
@@ -1361,52 +1362,80 @@ void enable_x2apic(void)
 }
 #endif /* CONFIG_X86_X2APIC */
 
-void __init enable_IR_x2apic(void)
+int __init enable_IR(void)
 {
 #ifdef CONFIG_INTR_REMAP
-	int ret;
-	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
-
-	ret = dmar_table_init();
-	if (ret) {
-		pr_debug("dmar_table_init() failed with %d:\n", ret);
-		goto ir_failed;
-	}
-
 	if (!intr_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
-		goto ir_failed;
+		return 0;
 	}
 
-
 	if (!x2apic_preenabled && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
-		return;
+		return 0;
 	}
 
+	if (enable_intr_remapping(x2apic_supported()))
+		return 0;
+
+	pr_info("Enabled Interrupt-remapping\n");
+
+	return 1;
+
+#endif
+	return 0;
+}
+
+void __init enable_IR_x2apic(void)
+{
+	unsigned long flags;
+	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	int ret, x2apic_enabled = 0;
+	int dmar_table_init_ret = 0;
+
+#ifdef CONFIG_INTR_REMAP
+	dmar_table_init_ret = dmar_table_init();
+	if (dmar_table_init_ret)
+		pr_debug("dmar_table_init() failed with %d:\n",
+				dmar_table_init_ret);
+#endif
+
 	ioapic_entries = alloc_ioapic_entries();
 	if (!ioapic_entries) {
-		pr_info("Allocate ioapic_entries failed: %d\n", ret);
-		goto end;
+		pr_err("Allocate ioapic_entries failed\n");
+		goto out;
 	}
 
 	ret = save_IO_APIC_setup(ioapic_entries);
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto end;
+		goto out;
 	}
 
 	local_irq_save(flags);
-	mask_IO_APIC_setup(ioapic_entries);
 	mask_8259A();
+	mask_IO_APIC_setup(ioapic_entries);
 
-	ret = enable_intr_remapping(x2apic_supported());
-	if (ret)
-		goto end_restore;
+	if (dmar_table_init_ret)
+		ret = 0;
+	else
+		ret = enable_IR();
 
-	pr_info("Enabled Interrupt-remapping\n");
+	if (!ret) {
+		/* IR is required if there is APIC ID > 255 even when running
+		 * under KVM
+		 */
+		if (max_physical_apicid > 255 || !kvm_para_available())
+			goto nox2apic;
+		/*
+		 * without IR all CPUs can be addressed by IOAPIC/MSI
+		 * only in physical mode
+		 */
+		x2apic_force_phys();
+	}
+
+	x2apic_enabled = 1;
 
 	if (x2apic_supported() && !x2apic_mode) {
 		x2apic_mode = 1;
@@ -1414,41 +1443,25 @@ void __init enable_IR_x2apic(void)
 		pr_info("Enabled x2apic\n");
 	}
 
-end_restore:
-	if (ret)
-		/*
-		 * IR enabling failed
-		 */
+nox2apic:
+	if (!ret) /* IR enabling failed */
 		restore_IO_APIC_setup(ioapic_entries);
-
 	unmask_8259A();
 	local_irq_restore(flags);
 
-end:
+out:
 	if (ioapic_entries)
 		free_ioapic_entries(ioapic_entries);
 
-	if (!ret)
+	if (x2apic_enabled)
 		return;
 
-ir_failed:
 	if (x2apic_preenabled)
-		panic("x2apic enabled by bios. But IR enabling failed");
+		panic("x2apic: enabled by BIOS but kernel init failed.");
 	else if (cpu_has_x2apic)
-		pr_info("Not enabling x2apic,Intr-remapping\n");
-#else
-	if (!cpu_has_x2apic)
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic enabled prior OS handover,"
-		      " enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
-#endif
-
-	return;
+		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
 }
 
-
 #ifdef CONFIG_X86_64
 /*
  * Detect and enable local APICs on non-SMP boards.
@@ -1549,8 +1562,6 @@ no_apic:
 #ifdef CONFIG_X86_64
 void __init early_init_lapic_mapping(void)
 {
-	unsigned long phys_addr;
-
 	/*
 	 * If no local APIC can be found then go out
 	 * : it means there is no mpatable and MADT
@@ -1558,11 +1569,9 @@ void __init early_init_lapic_mapping(void)
 	if (!smp_found_config)
 		return;
 
-	phys_addr = mp_lapic_addr;
-
-	set_fixmap_nocache(FIX_APIC_BASE, phys_addr);
+	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
 	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, phys_addr);
+		    APIC_BASE, mp_lapic_addr);
 
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
@@ -1651,7 +1660,6 @@ int __init APIC_init_uniprocessor(void)
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
 			boot_cpu_physical_apicid);
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
 #endif
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 8952a58..89174f8 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -167,7 +167,7 @@ static int es7000_apic_is_cluster(void)
 {
 	/* MPENTIUMIII */
 	if (boot_cpu_data.x86 == 6 &&
-	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11))
+	    (boot_cpu_data.x86_model >= 7 && boot_cpu_data.x86_model <= 11))
 		return 1;
 
 	return 0;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d2ed6c5..3c8f9e7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -66,6 +66,8 @@
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
+#define for_each_irq_pin(entry, head) \
+	for (entry = head; entry; entry = entry->next)
 
 /*
  *      Is the SiS APIC rmw bug present ?
@@ -85,6 +87,9 @@ int nr_ioapic_registers[MAX_IO_APICS];
 struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
+/* IO APIC gsi routing info */
+struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
+
 /* MP IRQ source entries */
 struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
@@ -116,15 +121,6 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-struct irq_pin_list;
-
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * the indexing order of this array favors 1:1 mappings
- * between pins and IRQs.
- */
-
 struct irq_pin_list {
 	int apic, pin;
 	struct irq_pin_list *next;
@@ -139,6 +135,11 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 	return pin;
 }
 
+/*
+ * This is performance-critical, we want to do it O(1)
+ *
+ * Most irqs are mapped 1:1 with pins.
+ */
 struct irq_cfg {
 	struct irq_pin_list *irq_2_pin;
 	cpumask_var_t domain;
@@ -414,13 +415,10 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	entry = cfg->irq_2_pin;
-	for (;;) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		int pin;
 
-		if (!entry)
-			break;
 		pin = entry->pin;
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
@@ -428,9 +426,6 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 			spin_unlock_irqrestore(&ioapic_lock, flags);
 			return true;
 		}
-		if (!entry->next)
-			break;
-		entry = entry->next;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -498,72 +493,68 @@ static void ioapic_mask_entry(int apic, int pin)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static int
+add_pin_to_irq_node_nopanic(struct irq_cfg *cfg, int node, int apic, int pin)
 {
-	struct irq_pin_list *entry;
+	struct irq_pin_list **last, *entry;
 
-	entry = cfg->irq_2_pin;
-	if (!entry) {
-		entry = get_one_free_irq_2_pin(node);
-		if (!entry) {
-			printk(KERN_ERR "can not alloc irq_2_pin to add %d - %d\n",
-					apic, pin);
-			return;
-		}
-		cfg->irq_2_pin = entry;
-		entry->apic = apic;
-		entry->pin = pin;
-		return;
-	}
-
-	while (entry->next) {
-		/* not again, please */
+	/* don't allow duplicates */
+	last = &cfg->irq_2_pin;
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		if (entry->apic == apic && entry->pin == pin)
-			return;
-
-		entry = entry->next;
+			return 0;
+		last = &entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin(node);
-	entry = entry->next;
+	entry = get_one_free_irq_2_pin(node);
+	if (!entry) {
+		printk(KERN_ERR "can not alloc irq_pin_list (%d,%d,%d)\n",
+				node, apic, pin);
+		return -ENOMEM;
+	}
 	entry->apic = apic;
 	entry->pin = pin;
+
+	*last = entry;
+	return 0;
+}
+
+static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+{
+	if (add_pin_to_irq_node_nopanic(cfg, node, apic, pin))
+		panic("IO-APIC: failed to add irq-pin. Can not proceed\n");
 }
 
 /*
  * Reroute an IRQ to a different pin.
  */
 static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
-				      int oldapic, int oldpin,
-				      int newapic, int newpin)
+					   int oldapic, int oldpin,
+					   int newapic, int newpin)
 {
-	struct irq_pin_list *entry = cfg->irq_2_pin;
-	int replaced = 0;
+	struct irq_pin_list *entry;
 
-	while (entry) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
-			replaced = 1;
 			/* every one is different, right? */
-			break;
+			return;
 		}
-		entry = entry->next;
 	}
 
-	/* why? call replace before add? */
-	if (!replaced)
-		add_pin_to_irq_node(cfg, node, newapic, newpin);
+	/* old apic/pin didn't exist, so just add new ones */
+	add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
-static inline void io_apic_modify_irq(struct irq_cfg *cfg,
-				int mask_and, int mask_or,
-				void (*final)(struct irq_pin_list *entry))
+static void io_apic_modify_irq(struct irq_cfg *cfg,
+			       int mask_and, int mask_or,
+			       void (*final)(struct irq_pin_list *entry))
 {
 	int pin;
 	struct irq_pin_list *entry;
 
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		pin = entry->pin;
 		reg = io_apic_read(entry->apic, 0x10 + pin * 2);
@@ -580,7 +571,6 @@ static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
-#ifdef CONFIG_X86_64
 static void io_apic_sync(struct irq_pin_list *entry)
 {
 	/*
@@ -596,11 +586,6 @@ static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 {
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
-#else /* CONFIG_X86_32 */
-static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, NULL);
-}
 
 static void __mask_and_edge_IO_APIC_irq(struct irq_cfg *cfg)
 {
@@ -613,7 +598,6 @@ static void __unmask_and_level_IO_APIC_irq(struct irq_cfg *cfg)
 	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED,
 			IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
-#endif /* CONFIG_X86_32 */
 
 static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
@@ -1702,12 +1686,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 		if (!entry)
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
-		for (;;) {
+		for_each_irq_pin(entry, cfg->irq_2_pin)
 			printk("-> %d:%d", entry->apic, entry->pin);
-			if (!entry->next)
-				break;
-			entry = entry->next;
-		}
 		printk("\n");
 	}
 
@@ -2211,7 +2191,6 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	return was_pending;
 }
 
-#ifdef CONFIG_X86_64
 static int ioapic_retrigger_irq(unsigned int irq)
 {
 
@@ -2224,14 +2203,6 @@ static int ioapic_retrigger_irq(unsigned int irq)
 
 	return 1;
 }
-#else
-static int ioapic_retrigger_irq(unsigned int irq)
-{
-	apic->send_IPI_self(irq_cfg(irq)->vector);
-
-	return 1;
-}
-#endif
 
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
@@ -2269,13 +2240,9 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	struct irq_pin_list *entry;
 	u8 vector = cfg->vector;
 
-	entry = cfg->irq_2_pin;
-	for (;;) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 
-		if (!entry)
-			break;
-
 		apic = entry->apic;
 		pin = entry->pin;
 		/*
@@ -2288,9 +2255,6 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
 		io_apic_modify(apic, 0x10 + pin*2, reg);
-		if (!entry->next)
-			break;
-		entry = entry->next;
 	}
 }
 
@@ -2515,11 +2479,8 @@ atomic_t irq_mis_count;
 static void ack_apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-
-#ifdef CONFIG_X86_32
 	unsigned long v;
 	int i;
-#endif
 	struct irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
@@ -2532,31 +2493,28 @@ static void ack_apic_level(unsigned int irq)
 	}
 #endif
 
-#ifdef CONFIG_X86_32
 	/*
-	* It appears there is an erratum which affects at least version 0x11
-	* of I/O APIC (that's the 82093AA and cores integrated into various
-	* chipsets).  Under certain conditions a level-triggered interrupt is
-	* erroneously delivered as edge-triggered one but the respective IRR
-	* bit gets set nevertheless.  As a result the I/O unit expects an EOI
-	* message but it will never arrive and further interrupts are blocked
-	* from the source.  The exact reason is so far unknown, but the
-	* phenomenon was observed when two consecutive interrupt requests
-	* from a given source get delivered to the same CPU and the source is
-	* temporarily disabled in between.
-	*
-	* A workaround is to simulate an EOI message manually.  We achieve it
-	* by setting the trigger mode to edge and then to level when the edge
-	* trigger mode gets detected in the TMR of a local APIC for a
-	* level-triggered interrupt.  We mask the source for the time of the
-	* operation to prevent an edge-triggered interrupt escaping meanwhile.
-	* The idea is from Manfred Spraul.  --macro
-	*/
+	 * It appears there is an erratum which affects at least version 0x11
+	 * of I/O APIC (that's the 82093AA and cores integrated into various
+	 * chipsets).  Under certain conditions a level-triggered interrupt is
+	 * erroneously delivered as edge-triggered one but the respective IRR
+	 * bit gets set nevertheless.  As a result the I/O unit expects an EOI
+	 * message but it will never arrive and further interrupts are blocked
+	 * from the source.  The exact reason is so far unknown, but the
+	 * phenomenon was observed when two consecutive interrupt requests
+	 * from a given source get delivered to the same CPU and the source is
+	 * temporarily disabled in between.
+	 *
+	 * A workaround is to simulate an EOI message manually.  We achieve it
+	 * by setting the trigger mode to edge and then to level when the edge
+	 * trigger mode gets detected in the TMR of a local APIC for a
+	 * level-triggered interrupt.  We mask the source for the time of the
+	 * operation to prevent an edge-triggered interrupt escaping meanwhile.
+	 * The idea is from Manfred Spraul.  --macro
+	 */
 	cfg = desc->chip_data;
 	i = cfg->vector;
-
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
-#endif
 
 	/*
 	 * We must acknowledge the irq before we move it or the acknowledge will
@@ -2598,7 +2556,7 @@ static void ack_apic_level(unsigned int irq)
 		unmask_IO_APIC_irq_desc(desc);
 	}
 
-#ifdef CONFIG_X86_32
+	/* Tail end of version 0x11 I/O APIC bug workaround */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 		spin_lock(&ioapic_lock);
@@ -2606,26 +2564,15 @@ static void ack_apic_level(unsigned int irq)
 		__unmask_and_level_IO_APIC_irq(cfg);
 		spin_unlock(&ioapic_lock);
 	}
-#endif
 }
 
 #ifdef CONFIG_INTR_REMAP
 static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
-	int apic, pin;
 	struct irq_pin_list *entry;
 
-	entry = cfg->irq_2_pin;
-	for (;;) {
-
-		if (!entry)
-			break;
-
-		apic = entry->apic;
-		pin = entry->pin;
-		io_apic_eoi(apic, pin);
-		entry = entry->next;
-	}
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		io_apic_eoi(entry->apic, entry->pin);
 }
 
 static void
@@ -3241,8 +3188,7 @@ void destroy_irq(unsigned int irq)
 	cfg = desc->chip_data;
 	dynamic_irq_cleanup(irq);
 	/* connect back irq_cfg */
-	if (desc)
-		desc->chip_data = cfg;
+	desc->chip_data = cfg;
 
 	free_irte(irq);
 	spin_lock_irqsave(&vector_lock, flags);
@@ -3912,7 +3858,11 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	 */
 	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
-		add_pin_to_irq_node(cfg, node, ioapic, pin);
+		if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
+			printk(KERN_INFO "can not add pin %d for irq %d\n",
+				pin, irq);
+			return 0;
+		}
 	}
 
 	setup_IO_APIC_irq(ioapic, pin, irq, desc, trigger, polarity);
@@ -3941,11 +3891,28 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
 	return __io_apic_set_pci_routing(dev, irq, irq_attr);
 }
 
-/* --------------------------------------------------------------------------
-                          ACPI-based IOAPIC Configuration
-   -------------------------------------------------------------------------- */
+u8 __init io_apic_unique_id(u8 id)
+{
+#ifdef CONFIG_X86_32
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
+	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		return io_apic_get_unique_id(nr_ioapics, id);
+	else
+		return id;
+#else
+	int i;
+	DECLARE_BITMAP(used, 256);
 
-#ifdef CONFIG_ACPI
+	bitmap_zero(used, 256);
+	for (i = 0; i < nr_ioapics; i++) {
+		struct mpc_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->apicid, used);
+	}
+	if (!test_bit(id, used))
+		return id;
+	return find_first_zero_bit(used, 256);
+#endif
+}
 
 #ifdef CONFIG_X86_32
 int __init io_apic_get_unique_id(int ioapic, int apic_id)
@@ -4054,8 +4021,6 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 	return 0;
 }
 
-#endif /* CONFIG_ACPI */
-
 /*
  * This function currently is only a helper for the i386 smp boot process where
  * we need to reprogram the ioredtbls to cater for the cpus which have come online
@@ -4109,7 +4074,7 @@ void __init setup_ioapic_dest(void)
 
 static struct resource *ioapic_resources;
 
-static struct resource * __init ioapic_setup_resources(void)
+static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 {
 	unsigned long n;
 	struct resource *res;
@@ -4125,15 +4090,13 @@ static struct resource * __init ioapic_setup_resources(void)
 	mem = alloc_bootmem(n);
 	res = (void *)mem;
 
-	if (mem != NULL) {
-		mem += sizeof(struct resource) * nr_ioapics;
+	mem += sizeof(struct resource) * nr_ioapics;
 
-		for (i = 0; i < nr_ioapics; i++) {
-			res[i].name = mem;
-			res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-			sprintf(mem,  "IOAPIC %u", i);
-			mem += IOAPIC_RESOURCE_NAME_SIZE;
-		}
+	for (i = 0; i < nr_ioapics; i++) {
+		res[i].name = mem;
+		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		sprintf(mem,  "IOAPIC %u", i);
+		mem += IOAPIC_RESOURCE_NAME_SIZE;
 	}
 
 	ioapic_resources = res;
@@ -4147,7 +4110,7 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	ioapic_res = ioapic_setup_resources();
+	ioapic_res = ioapic_setup_resources(nr_ioapics);
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
 			ioapic_phys = mp_ioapics[i].apicaddr;
@@ -4176,11 +4139,9 @@ fake_ioapic_page:
 			    __fix_to_virt(idx), ioapic_phys);
 		idx++;
 
-		if (ioapic_res != NULL) {
-			ioapic_res->start = ioapic_phys;
-			ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
-			ioapic_res++;
-		}
+		ioapic_res->start = ioapic_phys;
+		ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+		ioapic_res++;
 	}
 }
 
@@ -4201,3 +4162,76 @@ void __init ioapic_insert_resources(void)
 		r++;
 	}
 }
+
+int mp_find_ioapic(int gsi)
+{
+	int i = 0;
+
+	/* Find the IOAPIC that manages this GSI. */
+	for (i = 0; i < nr_ioapics; i++) {
+		if ((gsi >= mp_gsi_routing[i].gsi_base)
+		    && (gsi <= mp_gsi_routing[i].gsi_end))
+			return i;
+	}
+
+	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
+	return -1;
+}
+
+int mp_find_ioapic_pin(int ioapic, int gsi)
+{
+	if (WARN_ON(ioapic == -1))
+		return -1;
+	if (WARN_ON(gsi > mp_gsi_routing[ioapic].gsi_end))
+		return -1;
+
+	return gsi - mp_gsi_routing[ioapic].gsi_base;
+}
+
+static int bad_ioapic(unsigned long address)
+{
+	if (nr_ioapics >= MAX_IO_APICS) {
+		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
+		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
+		return 1;
+	}
+	if (!address) {
+		printk(KERN_WARNING "WARNING: Bogus (zero) I/O APIC address"
+		       " found in table, skipping!\n");
+		return 1;
+	}
+	return 0;
+}
+
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+{
+	int idx = 0;
+
+	if (bad_ioapic(address))
+		return;
+
+	idx = nr_ioapics;
+
+	mp_ioapics[idx].type = MP_IOAPIC;
+	mp_ioapics[idx].flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].apicaddr = address;
+
+	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+	mp_ioapics[idx].apicid = io_apic_unique_id(id);
+	mp_ioapics[idx].apicver = io_apic_get_version(idx);
+
+	/*
+	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
+	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
+	 */
+	mp_gsi_routing[idx].gsi_base = gsi_base;
+	mp_gsi_routing[idx].gsi_end = gsi_base +
+	    io_apic_get_redir_entries(idx);
+
+	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
+	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
+	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
+	       mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
+
+	nr_ioapics++;
+}
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index bc3e880..f3b1037 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -50,11 +50,11 @@ static struct apic *apic_probe[] __initdata = {
 void __init default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_X2APIC
-	if (x2apic_mode && (apic != &apic_x2apic_phys &&
+	if (x2apic_mode
 #ifdef CONFIG_X86_UV
-		       apic != &apic_x2apic_uv_x &&
+		       && apic != &apic_x2apic_uv_x
 #endif
-		       apic != &apic_x2apic_cluster)) {
+		       ) {
 		if (x2apic_phys)
 			apic = &apic_x2apic_phys;
 		else
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 651c93b..fcd513b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -482,11 +482,11 @@ static void __init construct_ioapic_table(int mpc_default_type)
 		MP_bus_info(&bus);
 	}
 
-	ioapic.type = MP_IOAPIC;
-	ioapic.apicid = 2;
-	ioapic.apicver = mpc_default_type > 4 ? 0x10 : 0x01;
-	ioapic.flags = MPC_APIC_USABLE;
-	ioapic.apicaddr = 0xFEC00000;
+	ioapic.type	= MP_IOAPIC;
+	ioapic.apicid	= 2;
+	ioapic.apicver	= mpc_default_type > 4 ? 0x10 : 0x01;
+	ioapic.flags	= MPC_APIC_USABLE;
+	ioapic.apicaddr	= IO_APIC_DEFAULT_PHYS_BASE;
 	MP_ioapic_info(&ioapic);
 
 	/*
