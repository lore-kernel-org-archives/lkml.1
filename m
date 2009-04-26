Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZDZRTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZDZRTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZDZRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:19:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbZDZRTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:19:10 -0400
Date: Sun, 26 Apr 2009 19:18:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090426171848.GA20228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86: hpet: fix periodic mode programming on AMD 81xx

Coly Li (1):
      uv_time: add parameter to uv_read_rtc()

H. Peter Anvin (1):
      x86, kbuild: make "make install" not depend on vmlinux

Jack Steiner (3):
      x86/uv: fix init of memory-less nodes
      x86/uv: fix init of cpu-less nodes
      x86/uv: fix for no memory at paddr 0

Jaswinder Singh Rajput (1):
      x86: mm/numa_32.c calculate_numa_remap_pages should use __init

Len Brown (1):
      x86, hpet: Stop soliciting hpet=force users on ICH4M

Michael K. Johnson (1):
      x86: more than 8 32-bit CPUs requires X86_BIGSMP

Rusty Russell (2):
      x86: fix boot crash in NMI watchdog with CONFIG_CPUMASK_OFFSTACK=y and flat APIC
      x86: avoid theoretical spurious NMI backtraces with CONFIG_CPUMASK_OFFSTACK=y

Suresh Siddha (1):
      x86-64: fix FPU corruption with signals and preemption

Weidong Han (1):
      docs, x86: add nox2apic back to kernel-parameters.txt

Yinghai Lu (1):
      x86: check boundary in setup_node_bootmem()


 Documentation/kernel-parameters.txt |    2 ++
 arch/x86/Kconfig                    |    1 +
 arch/x86/Makefile                   |    6 +++++-
 arch/x86/kernel/apic/nmi.c          |    5 +++--
 arch/x86/kernel/apic/x2apic_uv_x.c  |   15 +++++++++++++++
 arch/x86/kernel/hpet.c              |   18 +++++++++++++++++-
 arch/x86/kernel/quirks.c            |    2 --
 arch/x86/kernel/uv_time.c           |   10 +++++-----
 arch/x86/kernel/xsave.c             |    4 +++-
 arch/x86/mm/numa_32.c               |    2 +-
 arch/x86/mm/numa_64.c               |    3 +++
 arch/x86/mm/srat_64.c               |    6 +++++-
 12 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 600cdd7..90b3924 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1620,6 +1620,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nowb		[ARM]
 
+	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
+
 	nptcg=		[IA64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9086e6..b5cda6c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -664,6 +664,7 @@ config MAXSMP
 
 config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
+	range 2 8 if SMP && X86_32 && !X86_BIGSMP
 	range 2 512 if SMP && !MAXSMP
 	default "1" if !SMP
 	default "4096" if MAXSMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f05d8c9..8c86b72 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -153,7 +153,7 @@ endif
 
 boot := arch/x86/boot
 
-BOOT_TARGETS = bzlilo bzdisk fdimage fdimage144 fdimage288 isoimage install
+BOOT_TARGETS = bzlilo bzdisk fdimage fdimage144 fdimage288 isoimage
 
 PHONY += bzImage $(BOOT_TARGETS)
 
@@ -171,6 +171,10 @@ bzImage: vmlinux
 $(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
+PHONY += install
+install:
+	$(Q)$(MAKE) $(build)=$(boot) $@
+
 PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index d6bd624..ce4fbfa 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -138,7 +138,7 @@ int __init check_nmi_watchdog(void)
 	if (!prev_nmi_count)
 		goto error;
 
-	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL);
+	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL|__GFP_ZERO);
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
 #ifdef CONFIG_SMP
@@ -414,7 +414,8 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		touched = 1;
 	}
 
-	if (cpumask_test_cpu(cpu, backtrace_mask)) {
+	/* We can be called before check_nmi_watchdog, hence NULL check. */
+	if (backtrace_mask != NULL && cpumask_test_cpu(cpu, backtrace_mask)) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index de1a50a..2bda693 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -19,6 +19,7 @@
 #include <linux/timer.h>
 #include <linux/cpu.h>
 #include <linux/init.h>
+#include <linux/io.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -34,6 +35,17 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 
+static int early_get_nodeid(void)
+{
+	union uvh_node_id_u node_id;
+	unsigned long *mmr;
+
+	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
+	node_id.v = *mmr;
+	early_iounmap(mmr, sizeof(*mmr));
+	return node_id.s.node_id;
+}
+
 static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
@@ -42,6 +54,8 @@ static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		else if (!strcmp(oem_table_id, "UVX"))
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
+			__get_cpu_var(x2apic_extra_bits) =
+				early_get_nodeid() << (UV_APIC_PNODE_SHIFT - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
@@ -638,6 +652,7 @@ void __init uv_system_init(void)
 		if (uv_node_to_blade[nid] >= 0)
 			continue;
 		paddr = node_start_pfn(nid) << PAGE_SHIFT;
+		paddr = uv_soc_phys_ram_to_gpa(paddr);
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3f0019e..81408b9 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -236,6 +236,10 @@ static void hpet_stop_counter(void)
 	unsigned long cfg = hpet_readl(HPET_CFG);
 	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
+}
+
+static void hpet_reset_counter(void)
+{
 	hpet_writel(0, HPET_COUNTER);
 	hpet_writel(0, HPET_COUNTER + 4);
 }
@@ -250,6 +254,7 @@ static void hpet_start_counter(void)
 static void hpet_restart_counter(void)
 {
 	hpet_stop_counter();
+	hpet_reset_counter();
 	hpet_start_counter();
 }
 
@@ -309,7 +314,7 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg;
+	unsigned long cfg, cmp, now;
 	uint64_t delta;
 
 	switch (mode) {
@@ -317,12 +322,23 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		hpet_stop_counter();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
+		now = hpet_readl(HPET_COUNTER);
+		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
+		hpet_writel(cmp, HPET_Tn_CMP(timer));
+		udelay(1);
+		/*
+		 * HPET on AMD 81xx needs a second write (with HPET_TN_SETVAL
+		 * cleared) to T0_CMP to set the period. The HPET_TN_SETVAL
+		 * bit is automatically cleared after the first write.
+		 * (See AMD-8111 HyperTransport I/O Hub Data Sheet,
+		 * Publication # 24674)
+		 */
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
 		hpet_start_counter();
 		hpet_print_config();
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e95022e..7563b31 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -261,8 +261,6 @@ static void old_ich_force_enable_hpet_user(struct pci_dev *dev)
 {
 	if (hpet_force_user)
 		old_ich_force_enable_hpet(dev);
-	else
-		hpet_print_force_info();
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1,
diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 2ffb6c5..583f11d 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -29,7 +29,7 @@
 
 #define RTC_NAME		"sgi_rtc"
 
-static cycle_t uv_read_rtc(void);
+static cycle_t uv_read_rtc(struct clocksource *cs);
 static int uv_rtc_next_event(unsigned long, struct clock_event_device *);
 static void uv_rtc_timer_setup(enum clock_event_mode,
 				struct clock_event_device *);
@@ -123,7 +123,7 @@ static int uv_setup_intr(int cpu, u64 expires)
 	/* Initialize comparator value */
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
 
-	return (expires < uv_read_rtc() && !uv_intr_pending(pnode));
+	return (expires < uv_read_rtc(NULL) && !uv_intr_pending(pnode));
 }
 
 /*
@@ -256,7 +256,7 @@ static int uv_rtc_unset_timer(int cpu)
 
 	spin_lock_irqsave(&head->lock, flags);
 
-	if (head->next_cpu == bcpu && uv_read_rtc() >= *t)
+	if (head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t)
 		rc = 1;
 
 	*t = ULLONG_MAX;
@@ -278,7 +278,7 @@ static int uv_rtc_unset_timer(int cpu)
 /*
  * Read the RTC.
  */
-static cycle_t uv_read_rtc(void)
+static cycle_t uv_read_rtc(struct clocksource *cs)
 {
 	return (cycle_t)uv_read_local_mmr(UVH_RTC);
 }
@@ -291,7 +291,7 @@ static int uv_rtc_next_event(unsigned long delta,
 {
 	int ced_cpu = cpumask_first(ced->cpumask);
 
-	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc());
+	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc(NULL));
 }
 
 /*
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 0a5b04a..c5ee17e 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -89,7 +89,7 @@ int save_i387_xstate(void __user *buf)
 
 	if (!used_math())
 		return 0;
-	clear_used_math(); /* trigger finit */
+
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
 		/*
 	 	 * Start with clearing the user buffer. This will present a
@@ -114,6 +114,8 @@ int save_i387_xstate(void __user *buf)
 			return -1;
 	}
 
+	clear_used_math(); /* trigger finit */
+
 	if (task_thread_info(tsk)->status & TS_XSAVE) {
 		struct _fpstate __user *fx = buf;
 		struct _xstate __user *x = buf;
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 3daefa0..d253006 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -257,7 +257,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
-static unsigned long calculate_numa_remap_pages(void)
+static __init unsigned long calculate_numa_remap_pages(void)
 {
 	int nid;
 	unsigned long size, reserve_pages = 0;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index d73aaa8..2d05a12 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -188,6 +188,9 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
 
+	if (!end)
+		return;
+
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index c7d272b..33c5fa5 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -28,6 +28,7 @@ int acpi_numa __initdata;
 static struct acpi_table_slit *acpi_slit;
 
 static nodemask_t nodes_parsed __initdata;
+static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
@@ -141,6 +142,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 
 	apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
+	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
 	       pxm, apic_id, node);
@@ -174,6 +176,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	else
 		apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
+	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
 	       pxm, apic_id, node);
@@ -402,7 +405,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
-	node_possible_map = nodes_parsed;
+	/* Account for nodes with cpus and no memory */
+	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
 	/* Finally register nodes */
 	for_each_node_mask(i, node_possible_map)
