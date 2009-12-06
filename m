Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbZLFKCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbZLFKCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbZLFKCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:02:20 -0500
Received: from www.tglx.de ([62.245.132.106]:48361 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200AbZLFKCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:02:18 -0500
Date: Sun, 6 Dec 2009 11:01:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timers hpet updates for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061101070.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-hpet git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-hpet

Thanks,

	tglx

------------------>
Jan Beulich (1):
      x86, hpet: Simplify the HPET code

Shaohua Li (1):
      x86, hpet: Disable per-cpu hpet timer if ARAT is supported

Suresh Siddha (2):
      intr-remap: generic support for remapping HPET MSIs
      x86: arch specific support for remapping HPET MSIs

Thomas Gleixner (1):
      x86: hpet: Make WARN_ON understandable


 arch/x86/include/asm/hpet.h    |    7 ++-
 arch/x86/kernel/acpi/boot.c    |    1 +
 arch/x86/kernel/apic/io_apic.c |   49 ++++++++++++++++++----
 arch/x86/kernel/hpet.c         |   77 ++++++++++++++++++++++------------
 drivers/pci/intr_remapping.c   |   89 ++++++++++++++++++++++++++++++++++++++--
 drivers/pci/intr_remapping.h   |    7 +++
 include/linux/dmar.h           |   10 ++++
 include/linux/hpet.h           |    2 +
 8 files changed, 199 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 1c22cb0..5d89fd2 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -65,11 +65,12 @@
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
+extern u8 hpet_blockid;
 extern int hpet_force_user;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
-extern unsigned long hpet_readl(unsigned long a);
+extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
 extern void hpet_msi_unmask(unsigned int irq);
@@ -78,9 +79,9 @@ extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
 extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
-extern int arch_setup_hpet_msi(unsigned int irq);
+extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
 #else
-static inline int arch_setup_hpet_msi(unsigned int irq)
+static inline int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
 	return -EINVAL;
 }
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6b8ca3a..eae642b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -624,6 +624,7 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 	}
 
 	hpet_address = hpet_tbl->address.address;
+	hpet_blockid = hpet_tbl->sequence;
 
 	/*
 	 * Some broken BIOSes advertise HPET at 0x0. We really do not
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d2ed6c5..d9c6f14 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3254,7 +3254,8 @@ void destroy_irq(unsigned int irq)
  * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
+static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+			   struct msi_msg *msg, u8 hpet_id)
 {
 	struct irq_cfg *cfg;
 	int err;
@@ -3288,7 +3289,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		irte.dest_id = IRTE_DEST(dest);
 
 		/* Set source-id of interrupt request */
-		set_msi_sid(&irte, pdev);
+		if (pdev)
+			set_msi_sid(&irte, pdev);
+		else
+			set_hpet_sid(&irte, hpet_id);
 
 		modify_irte(irq, &irte);
 
@@ -3453,7 +3457,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	int ret;
 	struct msi_msg msg;
 
-	ret = msi_compose_msg(dev, irq, &msg);
+	ret = msi_compose_msg(dev, irq, &msg, -1);
 	if (ret < 0)
 		return ret;
 
@@ -3586,7 +3590,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 	int ret;
 	struct msi_msg msg;
 
-	ret = msi_compose_msg(NULL, irq, &msg);
+	ret = msi_compose_msg(NULL, irq, &msg, -1);
 	if (ret < 0)
 		return ret;
 	dmar_msi_write(irq, &msg);
@@ -3626,6 +3630,19 @@ static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 #endif /* CONFIG_SMP */
 
+static struct irq_chip ir_hpet_msi_type = {
+	.name = "IR-HPET_MSI",
+	.unmask = hpet_msi_unmask,
+	.mask = hpet_msi_mask,
+#ifdef CONFIG_INTR_REMAP
+	.ack = ir_ack_apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity = ir_set_msi_irq_affinity,
+#endif
+#endif
+	.retrigger = ioapic_retrigger_irq,
+};
+
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.unmask = hpet_msi_unmask,
@@ -3637,20 +3654,36 @@ static struct irq_chip hpet_msi_type = {
 	.retrigger = ioapic_retrigger_irq,
 };
 
-int arch_setup_hpet_msi(unsigned int irq)
+int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
 	int ret;
 	struct msi_msg msg;
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(NULL, irq, &msg);
+	if (intr_remapping_enabled) {
+		struct intel_iommu *iommu = map_hpet_to_ir(id);
+		int index;
+
+		if (!iommu)
+			return -1;
+
+		index = alloc_irte(iommu, irq, 1);
+		if (index < 0)
+			return -1;
+	}
+
+	ret = msi_compose_msg(NULL, irq, &msg, id);
 	if (ret < 0)
 		return ret;
 
 	hpet_msi_write(irq, &msg);
 	desc->status |= IRQ_MOVE_PCNTXT;
-	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
-		"edge");
+	if (irq_remapped(irq))
+		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
+					      handle_edge_irq, "edge");
+	else
+		set_irq_chip_and_handler_name(irq, &hpet_msi_type,
+					      handle_edge_irq, "edge");
 
 	return 0;
 }
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index dedc2bd..ba6e658 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -33,6 +33,7 @@
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long				hpet_address;
+u8					hpet_blockid; /* OS timer block num */
 #ifdef CONFIG_PCI_MSI
 static unsigned long			hpet_num_timers;
 #endif
@@ -47,12 +48,12 @@ struct hpet_dev {
 	char				name[10];
 };
 
-unsigned long hpet_readl(unsigned long a)
+inline unsigned int hpet_readl(unsigned int a)
 {
 	return readl(hpet_virt_address + a);
 }
 
-static inline void hpet_writel(unsigned long d, unsigned long a)
+static inline void hpet_writel(unsigned int d, unsigned int a)
 {
 	writel(d, hpet_virt_address + a);
 }
@@ -167,7 +168,7 @@ do {								\
 
 static void hpet_reserve_msi_timers(struct hpet_data *hd);
 
-static void hpet_reserve_platform_timers(unsigned long id)
+static void hpet_reserve_platform_timers(unsigned int id)
 {
 	struct hpet __iomem *hpet = hpet_virt_address;
 	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
@@ -205,7 +206,7 @@ static void hpet_reserve_platform_timers(unsigned long id)
 
 }
 #else
-static void hpet_reserve_platform_timers(unsigned long id) { }
+static void hpet_reserve_platform_timers(unsigned int id) { }
 #endif
 
 /*
@@ -246,7 +247,7 @@ static void hpet_reset_counter(void)
 
 static void hpet_start_counter(void)
 {
-	unsigned long cfg = hpet_readl(HPET_CFG);
+	unsigned int cfg = hpet_readl(HPET_CFG);
 	cfg |= HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 }
@@ -271,7 +272,7 @@ static void hpet_resume_counter(void)
 
 static void hpet_enable_legacy_int(void)
 {
-	unsigned long cfg = hpet_readl(HPET_CFG);
+	unsigned int cfg = hpet_readl(HPET_CFG);
 
 	cfg |= HPET_CFG_LEGACY;
 	hpet_writel(cfg, HPET_CFG);
@@ -314,7 +315,7 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	unsigned int cfg, cmp, now;
 	uint64_t delta;
 
 	switch (mode) {
@@ -323,7 +324,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
 		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
+		cmp = now + (unsigned int) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
@@ -339,7 +340,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		 * (See AMD-8111 HyperTransport I/O Hub Data Sheet,
 		 * Publication # 24674)
 		 */
-		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_writel((unsigned int) delta, HPET_Tn_CMP(timer));
 		hpet_start_counter();
 		hpet_print_config();
 		break;
@@ -383,13 +384,24 @@ static int hpet_next_event(unsigned long delta,
 	hpet_writel(cnt, HPET_Tn_CMP(timer));
 
 	/*
-	 * We need to read back the CMP register to make sure that
-	 * what we wrote hit the chip before we compare it to the
-	 * counter.
+	 * We need to read back the CMP register on certain HPET
+	 * implementations (ATI chipsets) which seem to delay the
+	 * transfer of the compare register into the internal compare
+	 * logic. With small deltas this might actually be too late as
+	 * the counter could already be higher than the compare value
+	 * at that point and we would wait for the next hpet interrupt
+	 * forever. We found out that reading the CMP register back
+	 * forces the transfer so we can rely on the comparison with
+	 * the counter register below. If the read back from the
+	 * compare register does not match the value we programmed
+	 * then we might have a real hardware problem. We can not do
+	 * much about it here, but at least alert the user/admin with
+	 * a prominent warning.
 	 */
-	WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
+	WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
+		  KERN_WARNING "hpet: compare register read back failed.\n");
 
-	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
+	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
@@ -415,7 +427,7 @@ static struct hpet_dev	*hpet_devs;
 void hpet_msi_unmask(unsigned int irq)
 {
 	struct hpet_dev *hdev = get_irq_data(irq);
-	unsigned long cfg;
+	unsigned int cfg;
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
@@ -425,7 +437,7 @@ void hpet_msi_unmask(unsigned int irq)
 
 void hpet_msi_mask(unsigned int irq)
 {
-	unsigned long cfg;
+	unsigned int cfg;
 	struct hpet_dev *hdev = get_irq_data(irq);
 
 	/* mask it */
@@ -467,7 +479,7 @@ static int hpet_msi_next_event(unsigned long delta,
 
 static int hpet_setup_msi_irq(unsigned int irq)
 {
-	if (arch_setup_hpet_msi(irq)) {
+	if (arch_setup_hpet_msi(irq, hpet_blockid)) {
 		destroy_irq(irq);
 		return -EINVAL;
 	}
@@ -584,6 +596,8 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 	unsigned int num_timers_used = 0;
 	int i;
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return;
 	id = hpet_readl(HPET_ID);
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
@@ -598,7 +612,7 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 
 	for (i = start_timer; i < num_timers - RESERVE_TIMERS; i++) {
 		struct hpet_dev *hdev = &hpet_devs[num_timers_used];
-		unsigned long cfg = hpet_readl(HPET_Tn_CFG(i));
+		unsigned int cfg = hpet_readl(HPET_Tn_CFG(i));
 
 		/* Only consider HPET timer with MSI support */
 		if (!(cfg & HPET_TN_FSB_CAP))
@@ -813,7 +827,7 @@ static int hpet_clocksource_register(void)
  */
 int __init hpet_enable(void)
 {
-	unsigned long id;
+	unsigned int id;
 	int i;
 
 	if (!is_hpet_capable())
@@ -872,10 +886,8 @@ int __init hpet_enable(void)
 
 	if (id & HPET_ID_LEGSUP) {
 		hpet_legacy_clockevent_register();
-		hpet_msi_capability_lookup(2);
 		return 1;
 	}
-	hpet_msi_capability_lookup(0);
 	return 0;
 
 out_nohpet:
@@ -908,9 +920,17 @@ static __init int hpet_late_init(void)
 	if (!hpet_virt_address)
 		return -ENODEV;
 
+	if (hpet_readl(HPET_ID) & HPET_ID_LEGSUP)
+		hpet_msi_capability_lookup(2);
+	else
+		hpet_msi_capability_lookup(0);
+
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 	hpet_print_config();
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return 0;
+
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
 	}
@@ -925,7 +945,7 @@ fs_initcall(hpet_late_init);
 void hpet_disable(void)
 {
 	if (is_hpet_capable()) {
-		unsigned long cfg = hpet_readl(HPET_CFG);
+		unsigned int cfg = hpet_readl(HPET_CFG);
 
 		if (hpet_legacy_int_enabled) {
 			cfg &= ~HPET_CFG_LEGACY;
@@ -965,8 +985,8 @@ static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
 static u32 hpet_t1_cmp;
-static unsigned long hpet_default_delta;
-static unsigned long hpet_pie_delta;
+static u32 hpet_default_delta;
+static u32 hpet_pie_delta;
 static unsigned long hpet_pie_limit;
 
 static rtc_irq_handler irq_handler;
@@ -1017,7 +1037,8 @@ EXPORT_SYMBOL_GPL(hpet_unregister_irq_handler);
  */
 int hpet_rtc_timer_init(void)
 {
-	unsigned long cfg, cnt, delta, flags;
+	unsigned int cfg, cnt, delta;
+	unsigned long flags;
 
 	if (!is_hpet_enabled())
 		return 0;
@@ -1027,7 +1048,7 @@ int hpet_rtc_timer_init(void)
 
 		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
 		clc >>= hpet_clockevent.shift + DEFAULT_RTC_SHIFT;
-		hpet_default_delta = (unsigned long) clc;
+		hpet_default_delta = clc;
 	}
 
 	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
@@ -1113,7 +1134,7 @@ int hpet_set_periodic_freq(unsigned long freq)
 		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
 		do_div(clc, freq);
 		clc >>= hpet_clockevent.shift;
-		hpet_pie_delta = (unsigned long) clc;
+		hpet_pie_delta = clc;
 	}
 	return 1;
 }
@@ -1127,7 +1148,7 @@ EXPORT_SYMBOL_GPL(hpet_rtc_dropped_irq);
 
 static void hpet_rtc_timer_reinit(void)
 {
-	unsigned long cfg, delta;
+	unsigned int cfg, delta;
 	int lost_ints = -1;
 
 	if (unlikely(!hpet_rtc_flags)) {
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 4f5b871..2cc3f70 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -2,6 +2,7 @@
 #include <linux/dmar.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
+#include <linux/hpet.h>
 #include <linux/pci.h>
 #include <linux/irq.h>
 #include <asm/io_apic.h>
@@ -14,7 +15,8 @@
 #include "pci.h"
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
-static int ir_ioapic_num;
+static struct hpet_scope ir_hpet[MAX_HPET_TBS];
+static int ir_ioapic_num, ir_hpet_num;
 int intr_remapping_enabled;
 
 static int disable_intremap;
@@ -351,6 +353,16 @@ int flush_irte(int irq)
 	return rc;
 }
 
+struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
+{
+	int i;
+
+	for (i = 0; i < MAX_HPET_TBS; i++)
+		if (ir_hpet[i].id == hpet_id)
+			return ir_hpet[i].iommu;
+	return NULL;
+}
+
 struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	int i;
@@ -478,6 +490,36 @@ int set_ioapic_sid(struct irte *irte, int apic)
 	return 0;
 }
 
+int set_hpet_sid(struct irte *irte, u8 id)
+{
+	int i;
+	u16 sid = 0;
+
+	if (!irte)
+		return -1;
+
+	for (i = 0; i < MAX_HPET_TBS; i++) {
+		if (ir_hpet[i].id == id) {
+			sid = (ir_hpet[i].bus << 8) | ir_hpet[i].devfn;
+			break;
+		}
+	}
+
+	if (sid == 0) {
+		pr_warning("Failed to set source-id of HPET block (%d)\n", id);
+		return -1;
+	}
+
+	/*
+	 * Should really use SQ_ALL_16. Some platforms are broken.
+	 * While we figure out the right quirks for these broken platforms, use
+	 * SQ_13_IGNORE_3 for now.
+	 */
+	set_irte_sid(irte, SVT_VERIFY_SID_SQ, SQ_13_IGNORE_3, sid);
+
+	return 0;
+}
+
 int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 {
 	struct pci_dev *bridge;
@@ -711,6 +753,34 @@ error:
 	return -1;
 }
 
+static void ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
+				      struct intel_iommu *iommu)
+{
+	struct acpi_dmar_pci_path *path;
+	u8 bus;
+	int count;
+
+	bus = scope->bus;
+	path = (struct acpi_dmar_pci_path *)(scope + 1);
+	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
+		/ sizeof(struct acpi_dmar_pci_path);
+
+	while (--count > 0) {
+		/*
+		 * Access PCI directly due to the PCI
+		 * subsystem isn't initialized yet.
+		 */
+		bus = read_pci_config_byte(bus, path->dev, path->fn,
+					   PCI_SECONDARY_BUS);
+		path++;
+	}
+	ir_hpet[ir_hpet_num].bus   = bus;
+	ir_hpet[ir_hpet_num].devfn = PCI_DEVFN(path->dev, path->fn);
+	ir_hpet[ir_hpet_num].iommu = iommu;
+	ir_hpet[ir_hpet_num].id    = scope->enumeration_id;
+	ir_hpet_num++;
+}
+
 static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 				      struct intel_iommu *iommu)
 {
@@ -740,8 +810,8 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 	ir_ioapic_num++;
 }
 
-static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
-				 struct intel_iommu *iommu)
+static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
+				      struct intel_iommu *iommu)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_device_scope *scope;
@@ -765,6 +835,17 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 			       drhd->address);
 
 			ir_parse_one_ioapic_scope(scope, iommu);
+		} else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET) {
+			if (ir_hpet_num == MAX_HPET_TBS) {
+				printk(KERN_WARNING "Exceeded Max HPET blocks\n");
+				return -1;
+			}
+
+			printk(KERN_INFO "HPET id %d under DRHD base"
+			       " 0x%Lx\n", scope->enumeration_id,
+			       drhd->address);
+
+			ir_parse_one_hpet_scope(scope, iommu);
 		}
 		start += scope->length;
 	}
@@ -785,7 +866,7 @@ int __init parse_ioapics_under_ir(void)
 		struct intel_iommu *iommu = drhd->iommu;
 
 		if (ecap_ir_support(iommu->ecap)) {
-			if (ir_parse_ioapic_scope(drhd->hdr, iommu))
+			if (ir_parse_ioapic_hpet_scope(drhd->hdr, iommu))
 				return -1;
 
 			ir_supported = 1;
diff --git a/drivers/pci/intr_remapping.h b/drivers/pci/intr_remapping.h
index 63a263c..5662fec 100644
--- a/drivers/pci/intr_remapping.h
+++ b/drivers/pci/intr_remapping.h
@@ -7,4 +7,11 @@ struct ioapic_scope {
 	unsigned int devfn;	/* PCI devfn number */
 };
 
+struct hpet_scope {
+	struct intel_iommu *iommu;
+	u8 id;
+	unsigned int bus;
+	unsigned int devfn;
+};
+
 #define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 4a2b162..69a6fba 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -126,7 +126,9 @@ extern int free_irte(int irq);
 extern int irq_remapped(int irq);
 extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
+extern struct intel_iommu *map_hpet_to_ir(u8 id);
 extern int set_ioapic_sid(struct irte *irte, int apic);
+extern int set_hpet_sid(struct irte *irte, u8 id);
 extern int set_msi_sid(struct irte *irte, struct pci_dev *dev);
 #else
 static inline int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
@@ -158,10 +160,18 @@ static inline struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	return NULL;
 }
+static inline struct intel_iommu *map_hpet_to_ir(unsigned int hpet_id)
+{
+	return NULL;
+}
 static inline int set_ioapic_sid(struct irte *irte, int apic)
 {
 	return 0;
 }
+static inline int set_hpet_sid(struct irte *irte, u8 id)
+{
+	return -1;
+}
 static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 {
 	return 0;
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 79f63a2..219ca4f 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -126,4 +126,6 @@ struct hpet_info {
 #define	HPET_DPI	_IO('h', 0x05)	/* disable periodic */
 #define	HPET_IRQFREQ	_IOW('h', 0x6, unsigned long)	/* IRQFREQ usec */
 
+#define MAX_HPET_TBS	8		/* maximum hpet timer blocks */
+
 #endif				/* !__HPET__ */
