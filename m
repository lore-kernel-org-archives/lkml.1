Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYHRShO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYHRShO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYHRSg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:36:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbYHRSg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:36:56 -0400
Date: Mon, 18 Aug 2008 20:36:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080818183638.GA24986@elte.hu>
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
Andi Kleen (1):
      x86: fix build warnings in real mode code

David Fries (1):
      x86: fix i486 suspend to disk CR4 oops

Marcin Slusarz (7):
      x86, tsc: fix section mismatch warning
      x86: fix MP_processor_info section mismatch warning
      x86: mmconf: fix section mismatch warning
      x86: mpparse.c: fix section mismatch warning
      x86, percpu: silence section mismatch warnings related to EARLY_PER_CPU variables
      x86: silence section mismatch warning - get_local_pda
      x86, calgary: fix section mismatch warning - get_tce_space_from_tar

Mathieu Desnoyers (1):
      x86: correct register constraints for 64-bit atomic operations


 arch/x86/boot/boot.h               |    2 ++
 arch/x86/boot/memory.c             |    1 -
 arch/x86/kernel/acpi/sleep.c       |    2 +-
 arch/x86/kernel/efi_32.c           |    4 ++--
 arch/x86/kernel/mmconf-fam10h_64.c |    2 +-
 arch/x86/kernel/mpparse.c          |    6 +++---
 arch/x86/kernel/pci-calgary_64.c   |    2 +-
 arch/x86/kernel/smpboot.c          |   11 +++++++++--
 arch/x86/kernel/tsc.c              |    2 +-
 arch/x86/power/cpu_32.c            |    6 ++++--
 arch/x86/power/hibernate_asm_32.S  |   26 +++++++++++++++-----------
 include/asm-x86/atomic_64.h        |    8 ++++----
 include/asm-x86/mmconfig.h         |    2 +-
 include/asm-x86/percpu.h           |    2 +-
 14 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 616b804..cc0ef13 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -30,6 +30,8 @@
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+
 extern struct setup_header hdr;
 extern struct boot_params boot_params;
 
diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 53165c9..8c3c25f 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -13,7 +13,6 @@
  */
 
 #include "boot.h"
-#include <linux/kernel.h>
 
 #define SMAP	0x534d4150	/* ASCII "SMAP" */
 
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 81e5ab6..426e5d9 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -86,7 +86,7 @@ int acpi_save_state_mem(void)
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
-	header->pmode_cr4 = read_cr4();
+	header->pmode_cr4 = read_cr4_safe();
 	header->realmode_flags = acpi_realmode_flags;
 	header->real_magic = 0x12345678;
 
diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index 4b63c8e..5cab48e 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -53,7 +53,7 @@ void efi_call_phys_prelog(void)
 	 * directory. If I have PAE, I just need to duplicate one entry in
 	 * page directory.
 	 */
-	cr4 = read_cr4();
+	cr4 = read_cr4_safe();
 
 	if (cr4 & X86_CR4_PAE) {
 		efi_bak_pg_dir_pointer[0].pgd =
@@ -91,7 +91,7 @@ void efi_call_phys_epilog(void)
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 
-	cr4 = read_cr4();
+	cr4 = read_cr4_safe();
 
 	if (cr4 & X86_CR4_PAE) {
 		swapper_pg_dir[pgd_index(0)].pgd =
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index fdfdc55..efc2f36 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -238,7 +238,7 @@ static struct dmi_system_id __devinitdata mmconf_dmi_table[] = {
 	{}
 };
 
-void __init check_enable_amd_mmconf_dmi(void)
+void __cpuinit check_enable_amd_mmconf_dmi(void)
 {
 	dmi_check_system(mmconf_dmi_table);
 }
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6780905..b3fb430 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -49,7 +49,7 @@ static int __init mpf_checksum(unsigned char *mp, int len)
 	return sum & 0xFF;
 }
 
-static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
+static void __init MP_processor_info(struct mpc_config_processor *m)
 {
 	int apicid;
 	char *bootup_cpu = "";
@@ -484,7 +484,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 }
 
 
-static void construct_ioapic_table(int mpc_default_type)
+static void __init construct_ioapic_table(int mpc_default_type)
 {
 	struct mpc_config_ioapic ioapic;
 	struct mpc_config_bus bus;
@@ -529,7 +529,7 @@ static void construct_ioapic_table(int mpc_default_type)
 	construct_default_ioirq_mptable(mpc_default_type);
 }
 #else
-static inline void construct_ioapic_table(int mpc_default_type) { }
+static inline void __init construct_ioapic_table(int mpc_default_type) { }
 #endif
 
 static inline void __init construct_default_ISA_mptable(int mpc_default_type)
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 02d1932..218d783 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1350,7 +1350,7 @@ static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
  * Function for kdump case. Get the tce tables from first kernel
  * by reading the contents of the base adress register of calgary iommu
  */
-static void get_tce_space_from_tar(void)
+static void __init get_tce_space_from_tar(void)
 {
 	int bus;
 	void __iomem *target;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a8fb8a9..e139e61 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -756,6 +756,14 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 }
 
 #ifdef CONFIG_X86_64
+
+/* __ref because it's safe to call free_bootmem when after_bootmem == 0. */
+static void __ref free_bootmem_pda(struct x8664_pda *oldpda)
+{
+	if (!after_bootmem)
+		free_bootmem((unsigned long)oldpda, sizeof(*oldpda));
+}
+
 /*
  * Allocate node local memory for the AP pda.
  *
@@ -784,8 +792,7 @@ int __cpuinit get_local_pda(int cpu)
 
 	if (oldpda) {
 		memcpy(newpda, oldpda, size);
-		if (!after_bootmem)
-			free_bootmem((unsigned long)oldpda, size);
+		free_bootmem_pda(oldpda);
 	}
 
 	newpda->in_bootmem = 0;
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7603c05..46af716 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -104,7 +104,7 @@ __setup("notsc", notsc_setup);
 /*
  * Read TSC and the reference counters. Take care of SMI disturbance
  */
-static u64 __init tsc_read_refs(u64 *pm, u64 *hpet)
+static u64 tsc_read_refs(u64 *pm, u64 *hpet)
 {
 	u64 t1, t2;
 	int i;
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index 7dc5d5c..d3e083d 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -45,7 +45,7 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr0 = read_cr0();
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
-	ctxt->cr4 = read_cr4();
+	ctxt->cr4 = read_cr4_safe();
 }
 
 /* Needed by apm.c */
@@ -98,7 +98,9 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	/*
 	 * control registers
 	 */
-	write_cr4(ctxt->cr4);
+	/* cr4 was introduced in the Pentium CPU */
+	if (ctxt->cr4)
+		write_cr4(ctxt->cr4);
 	write_cr3(ctxt->cr3);
 	write_cr2(ctxt->cr2);
 	write_cr0(ctxt->cr0);
diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index b95aa6c..4fc7e87 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -28,9 +28,9 @@ ENTRY(swsusp_arch_suspend)
 	ret
 
 ENTRY(restore_image)
-	movl	resume_pg_dir, %ecx
-	subl	$__PAGE_OFFSET, %ecx
-	movl	%ecx, %cr3
+	movl	resume_pg_dir, %eax
+	subl	$__PAGE_OFFSET, %eax
+	movl	%eax, %cr3
 
 	movl	restore_pblist, %edx
 	.p2align 4,,7
@@ -52,17 +52,21 @@ copy_loop:
 
 done:
 	/* go back to the original page tables */
-	movl	$swapper_pg_dir, %ecx
-	subl	$__PAGE_OFFSET, %ecx
-	movl	%ecx, %cr3
+	movl	$swapper_pg_dir, %eax
+	subl	$__PAGE_OFFSET, %eax
+	movl	%eax, %cr3
 	/* Flush TLB, including "global" things (vmalloc) */
-	movl	mmu_cr4_features, %eax
-	movl	%eax, %edx
+	movl	mmu_cr4_features, %ecx
+	jecxz	1f	# cr4 Pentium and higher, skip if zero
+	movl	%ecx, %edx
 	andl	$~(1<<7), %edx;  # PGE
 	movl	%edx, %cr4;  # turn off PGE
-	movl	%cr3, %ecx;  # flush TLB
-	movl	%ecx, %cr3
-	movl	%eax, %cr4;  # turn PGE back on
+1:
+	movl	%cr3, %eax;  # flush TLB
+	movl	%eax, %cr3
+	jecxz	1f	# cr4 Pentium and higher, skip if zero
+	movl	%ecx, %cr4;  # turn PGE back on
+1:
 
 	movl saved_context_esp, %esp
 	movl saved_context_ebp, %ebp
diff --git a/include/asm-x86/atomic_64.h b/include/asm-x86/atomic_64.h
index a009519..91c7d03 100644
--- a/include/asm-x86/atomic_64.h
+++ b/include/asm-x86/atomic_64.h
@@ -228,7 +228,7 @@ static inline void atomic64_add(long i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter));
 }
 
 /**
@@ -242,7 +242,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "subq %1,%0"
 		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter));
 }
 
 /**
@@ -260,7 +260,7 @@ static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 
 	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
+		     : "er" (i), "m" (v->counter) : "memory");
 	return c;
 }
 
@@ -341,7 +341,7 @@ static inline int atomic64_add_negative(long i, atomic64_t *v)
 
 	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
 		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
+		     : "er" (i), "m" (v->counter) : "memory");
 	return c;
 }
 
diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
index 95beda0..e293ab8 100644
--- a/include/asm-x86/mmconfig.h
+++ b/include/asm-x86/mmconfig.h
@@ -3,7 +3,7 @@
 
 #ifdef CONFIG_PCI_MMCONFIG
 extern void __cpuinit fam10h_check_enable_mmcfg(void);
-extern void __init check_enable_amd_mmconf_dmi(void);
+extern void __cpuinit check_enable_amd_mmconf_dmi(void);
 #else
 static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
diff --git a/include/asm-x86/percpu.h b/include/asm-x86/percpu.h
index 4e91ee1..f643a3a 100644
--- a/include/asm-x86/percpu.h
+++ b/include/asm-x86/percpu.h
@@ -182,7 +182,7 @@ do {							\
 	DEFINE_PER_CPU(_type, _name) = _initvalue;			\
 	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\
 				{ [0 ... NR_CPUS-1] = _initvalue };	\
-	__typeof__(_type) *_name##_early_ptr = _name##_early_map
+	__typeof__(_type) *_name##_early_ptr __refdata = _name##_early_map
 
 #define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
 	EXPORT_PER_CPU_SYMBOL(_name)
