Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbZHDSz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbZHDSz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZHDSz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:55:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZHDSzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:55:25 -0400
Date: Tue, 4 Aug 2009 20:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090804185509.GA31882@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
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
Borislav Petkov (1):
      x86, msr: execute on the correct CPU subset

H. Peter Anvin (2):
      x86: Fix assert syntax in vmlinux.lds.S
      x86: fix assembly constraints in native_save_fl()

Jack Steiner (5):
      x86, UV: Handle missing blade-local memory correctly
      x86, UV: Delete mapping of MMR rangs mapped by BIOS
      x86, UV: Fix macros for accessing large node numbers
      x86, UV: Fix UV apic mode
      x86, UV: Complete IRQ interrupt migration in arch_enable_uv_irq()

Jan Beulich (1):
      x86, 32-bit: Fix double accounting in reserve_top_address()

Pallipadi, Venkatesh (1):
      x86, pat: Fix set_memory_wc related corruption

Paul Mackerras (2):
      x86: Add quirk to make Apple MacBook5,2 use reboot=pci
      x86: Make 64-bit efi_ioremap use ioremap on MMIO regions

Robert Richter (1):
      x86: fix section mismatch for i386 init code

Subrata Modak (1):
      x86: Work around compilation warning in arch/x86/kernel/apm_32.c

Thomas Hellstrom (1):
      x86: Fix CPA memtype reserving in the set_pages_array*() cases

Yinghai Lu (1):
      x86: Don't use current_cpu_data in x2apic phys_pkg_id


 arch/x86/include/asm/efi.h            |    5 ++-
 arch/x86/include/asm/irqflags.h       |    8 ++++++-
 arch/x86/include/asm/uv/uv_hub.h      |    9 ++++++-
 arch/x86/kernel/apic/io_apic.c        |    3 ++
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |   38 ++++++--------------------------
 arch/x86/kernel/apm_32.c              |    2 +-
 arch/x86/kernel/efi.c                 |    2 +-
 arch/x86/kernel/efi_64.c              |    6 ++++-
 arch/x86/kernel/head_32.S             |    6 ++++-
 arch/x86/kernel/reboot.c              |   34 +++++++++++++++++++++++++++-
 arch/x86/kernel/vmlinux.lds.S         |   16 ++++++------
 arch/x86/lib/msr.c                    |   26 ++++++++-------------
 arch/x86/mm/pageattr.c                |   39 ++++++++++++++++++++++----------
 arch/x86/mm/pgtable.c                 |    1 -
 16 files changed, 120 insertions(+), 79 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index edc90f2..8406ed7 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,7 +33,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size)			ioremap_cache(addr, size)
+#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
@@ -84,7 +84,8 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
+extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
+				 u32 type);
 
 #endif /* CONFIG_X86_32 */
 
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 2bdab21..c6ccbe7 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -12,9 +12,15 @@ static inline unsigned long native_save_fl(void)
 {
 	unsigned long flags;
 
+	/*
+	 * Note: this needs to be "=r" not "=rm", because we have the
+	 * stack offset from what gcc expects at the time the "pop" is
+	 * executed, and so a memory reference with respect to the stack
+	 * would end up using the wrong address.
+	 */
 	asm volatile("# __raw_save_flags\n\t"
 		     "pushf ; pop %0"
-		     : "=g" (flags)
+		     : "=r" (flags)
 		     : /* no input */
 		     : "memory");
 
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 341070f..77a6850 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -175,7 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define UV_GLOBAL_MMR32_PNODE_BITS(p)	((p) << (UV_GLOBAL_MMR32_PNODE_SHIFT))
 
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
-	((unsigned long)(UV_PNODE_TO_GNODE(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
+	(((unsigned long)(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
 #define UV_APIC_PNODE_SHIFT	6
 
@@ -327,6 +327,7 @@ struct uv_blade_info {
 	unsigned short	nr_possible_cpus;
 	unsigned short	nr_online_cpus;
 	unsigned short	pnode;
+	short		memory_nid;
 };
 extern struct uv_blade_info *uv_blade_info;
 extern short *uv_node_to_blade;
@@ -363,6 +364,12 @@ static inline int uv_blade_to_pnode(int bid)
 	return uv_blade_info[bid].pnode;
 }
 
+/* Nid of memory node on blade. -1 if no blade-local memory */
+static inline int uv_blade_to_memory_nid(int bid)
+{
+	return uv_blade_info[bid].memory_nid;
+}
+
 /* Determine the number of possible cpus on a blade */
 static inline int uv_blade_nr_possible_cpus(int bid)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2284a48..d2ed6c5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3793,6 +3793,9 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
 	return irq;
 }
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 8e4cbb2..2ed4e2b 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -170,7 +170,7 @@ static unsigned long set_apic_id(unsigned int id)
 
 static int x2apic_cluster_phys_pkg_id(int initial_apicid, int index_msb)
 {
-	return current_cpu_data.initial_apicid >> index_msb;
+	return initial_apicid >> index_msb;
 }
 
 static void x2apic_send_IPI_self(int vector)
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index a284359..0b631c6 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -162,7 +162,7 @@ static unsigned long set_apic_id(unsigned int id)
 
 static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
 {
-	return current_cpu_data.initial_apicid >> index_msb;
+	return initial_apicid >> index_msb;
 }
 
 static void x2apic_send_IPI_self(int vector)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 096d19a..832e908 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -261,7 +261,7 @@ struct apic apic_x2apic_uv_x = {
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
-	.irq_dest_mode			= 1, /* logical */
+	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= uv_target_cpus,
 	.disable_esr			= 0,
@@ -362,12 +362,6 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 	BUG();
 }
 
-static __init void map_low_mmrs(void)
-{
-	init_extra_mapping_uc(UV_GLOBAL_MMR32_BASE, UV_GLOBAL_MMR32_SIZE);
-	init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);
-}
-
 enum map_type {map_wb, map_uc};
 
 static __init void map_high(char *id, unsigned long base, int shift,
@@ -395,26 +389,6 @@ static __init void map_gru_high(int max_pnode)
 		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
 }
 
-static __init void map_config_high(int max_pnode)
-{
-	union uvh_rh_gam_cfg_overlay_config_mmr_u cfg;
-	int shift = UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_BASE_SHFT;
-
-	cfg.v = uv_read_local_mmr(UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR);
-	if (cfg.s.enable)
-		map_high("CONFIG", cfg.s.base, shift, max_pnode, map_uc);
-}
-
-static __init void map_mmr_high(int max_pnode)
-{
-	union uvh_rh_gam_mmr_overlay_config_mmr_u mmr;
-	int shift = UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT;
-
-	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
-	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
-}
-
 static __init void map_mmioh_high(int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
@@ -566,8 +540,6 @@ void __init uv_system_init(void)
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
 
-	map_low_mmrs();
-
 	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
@@ -591,6 +563,8 @@ void __init uv_system_init(void)
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
 	BUG_ON(!uv_blade_info);
+	for (blade = 0; blade < uv_num_possible_blades(); blade++)
+		uv_blade_info[blade].memory_nid = -1;
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
@@ -629,6 +603,9 @@ void __init uv_system_init(void)
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
 		uv_blade_info[blade].nr_possible_cpus++;
 
+		/* Any node on the blade, else will contain -1. */
+		uv_blade_info[blade].memory_nid = nid;
+
 		uv_cpu_hub_info(cpu)->lowmem_remap_base = lowmem_redir_base;
 		uv_cpu_hub_info(cpu)->lowmem_remap_top = lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
@@ -662,11 +639,10 @@ void __init uv_system_init(void)
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
+		max_pnode = max(pnode, max_pnode);
 	}
 
 	map_gru_high(max_pnode);
-	map_mmr_high(max_pnode);
-	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
 
 	uv_cpu_init();
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 79302e9..442b550 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -811,7 +811,7 @@ static int apm_do_idle(void)
 	u8 ret = 0;
 	int idled = 0;
 	int polling;
-	int err;
+	int err = 0;
 
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 96f7ac0..19ccf6d 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -512,7 +512,7 @@ void __init efi_enter_virtual_mode(void)
 			&& end_pfn <= max_pfn_mapped))
 			va = __va(md->phys_addr);
 		else
-			va = efi_ioremap(md->phys_addr, size);
+			va = efi_ioremap(md->phys_addr, size, md->type);
 
 		md->virt_addr = (u64) (unsigned long) va;
 
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 22c3b78..ac0621a 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -98,10 +98,14 @@ void __init efi_call_phys_epilog(void)
 	early_runtime_code_mapping_set_exec(0);
 }
 
-void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
+void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
+				 u32 type)
 {
 	unsigned long last_map_pfn;
 
+	if (type == EFI_MEMORY_MAPPED_IO)
+		return ioremap(phys_addr, size);
+
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
 		return NULL;
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8663afb..0d98a01 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -602,7 +602,11 @@ ignore_int:
 #endif
 	iret
 
-.section .cpuinit.data,"wa"
+#ifndef CONFIG_HOTPLUG_CPU
+	__CPUINITDATA
+#else
+	__REFDATA
+#endif
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 508e982..834c9da 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/pm.h>
 #include <linux/efi.h>
+#include <linux/dmi.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -17,7 +18,6 @@
 #include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
-# include <linux/dmi.h>
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
 #else
@@ -404,6 +404,38 @@ EXPORT_SYMBOL(machine_real_restart);
 
 #endif /* CONFIG_X86_32 */
 
+/*
+ * Apple MacBook5,2 (2009 MacBook) needs reboot=p
+ */
+static int __init set_pci_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_CF9) {
+		reboot_type = BOOT_CF9;
+		printk(KERN_INFO "%s series board detected. "
+		       "Selecting PCI-method for reboots.\n", d->ident);
+	}
+	return 0;
+}
+
+static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
+	{	/* Handle problems with rebooting on Apple MacBook5,2 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBook",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
+		},
+	},
+	{ }
+};
+
+static int __init pci_reboot_init(void)
+{
+	dmi_check_system(pci_reboot_dmi_table);
+	return 0;
+}
+core_initcall(pci_reboot_init);
+
 static inline void kb_wait(void)
 {
 	int i;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 59f31d2..78d185d 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -393,8 +393,8 @@ SECTIONS
 
 
 #ifdef CONFIG_X86_32
-ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
-        "kernel image bigger than KERNEL_IMAGE_SIZE")
+. = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 #else
 /*
  * Per-cpu symbols which need to be offset from __per_cpu_load
@@ -407,12 +407,12 @@ INIT_PER_CPU(irq_stack_union);
 /*
  * Build-time check on the image size:
  */
-ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
-	"kernel image bigger than KERNEL_IMAGE_SIZE")
+. = ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
+	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 
 #ifdef CONFIG_SMP
-ASSERT((per_cpu__irq_stack_union == 0),
-        "irq_stack_union is not at start of per-cpu area");
+. = ASSERT((per_cpu__irq_stack_union == 0),
+           "irq_stack_union is not at start of per-cpu area");
 #endif
 
 #endif /* CONFIG_X86_32 */
@@ -420,7 +420,7 @@ ASSERT((per_cpu__irq_stack_union == 0),
 #ifdef CONFIG_KEXEC
 #include <asm/kexec.h>
 
-ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-       "kexec control code size is too big")
+. = ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+           "kexec control code size is too big");
 #endif
 
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 1440b9c..caa24ac 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -89,16 +89,13 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	rv.msrs	  = msrs;
 	rv.msr_no = msr_no;
 
-	preempt_disable();
-	/*
-	 * FIXME: handle the CPU we're executing on separately for now until
-	 * smp_call_function_many has been fixed to not skip it.
-	 */
-	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __rdmsr_on_cpu, &rv, 1);
+	this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		__rdmsr_on_cpu(&rv);
 
 	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
-	preempt_enable();
+	put_cpu();
 }
 EXPORT_SYMBOL(rdmsr_on_cpus);
 
@@ -121,16 +118,13 @@ void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	rv.msrs   = msrs;
 	rv.msr_no = msr_no;
 
-	preempt_disable();
-	/*
-	 * FIXME: handle the CPU we're executing on separately for now until
-	 * smp_call_function_many has been fixed to not skip it.
-	 */
-	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __wrmsr_on_cpu, &rv, 1);
+	this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		__wrmsr_on_cpu(&rv);
 
 	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
-	preempt_enable();
+	put_cpu();
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1b734d7..7e600c1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -591,9 +591,12 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
-	if (cpa->flags & CPA_PAGES_ARRAY)
-		address = (unsigned long)page_address(cpa->pages[cpa->curpage]);
-	else if (cpa->flags & CPA_ARRAY)
+	if (cpa->flags & CPA_PAGES_ARRAY) {
+		struct page *page = cpa->pages[cpa->curpage];
+		if (unlikely(PageHighMem(page)))
+			return 0;
+		address = (unsigned long)page_address(page);
+	} else if (cpa->flags & CPA_ARRAY)
 		address = cpa->vaddr[cpa->curpage];
 	else
 		address = *cpa->vaddr;
@@ -697,9 +700,12 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (cpa->flags & CPA_PAGES_ARRAY)
-		vaddr = (unsigned long)page_address(cpa->pages[cpa->curpage]);
-	else if (cpa->flags & CPA_ARRAY)
+	if (cpa->flags & CPA_PAGES_ARRAY) {
+		struct page *page = cpa->pages[cpa->curpage];
+		if (unlikely(PageHighMem(page)))
+			return 0;
+		vaddr = (unsigned long)page_address(page);
+	} else if (cpa->flags & CPA_ARRAY)
 		vaddr = cpa->vaddr[cpa->curpage];
 	else
 		vaddr = *cpa->vaddr;
@@ -997,12 +1003,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
 int _set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
+	unsigned long addr_copy = addr;
+
 	ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
-
 	if (!ret) {
-		ret = change_page_attr_set(&addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC), 0);
+		ret = change_page_attr_set_clr(&addr_copy, numpages,
+					       __pgprot(_PAGE_CACHE_WC),
+					       __pgprot(_PAGE_CACHE_MASK),
+					       0, 0, NULL);
 	}
 	return ret;
 }
@@ -1119,7 +1128,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
 	int free_idx;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
 			goto err_out;
@@ -1132,7 +1143,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
 err_out:
 	free_idx = i;
 	for (i = 0; i < free_idx; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		free_memtype(start, end);
 	}
@@ -1161,7 +1174,9 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 		return retval;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		free_memtype(start, end);
 	}
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index af8f965..ed34f5e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -329,7 +329,6 @@ void __init reserve_top_address(unsigned long reserve)
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
-	__VMALLOC_RESERVE += reserve;
 #endif
 }
 
