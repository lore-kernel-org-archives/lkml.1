Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbXJ0TyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbXJ0TyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXJ0Tx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:53:57 -0400
Received: from www.tglx.de ([62.245.132.106]:34051 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbXJ0Tx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:53:56 -0400
Date: Sat, 27 Oct 2007 21:53:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, James Bottomley <jejb@steeleye.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Git pull] x86 bugfixes
In-Reply-To: <alpine.LFD.0.9999.0710262010030.3186@localhost.localdomain>
Message-ID: <alpine.LFD.0.9999.0710272149330.3186@localhost.localdomain>
References: <alpine.LFD.0.9999.0710262010030.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull x86 bugfixes from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Some more voyager fixes and other compile warning fixups than in the
yesterday pull request.

Thanks,
	tglx

Eric W. Biederman (1):
      x86: Fix boot protocol KEEP_SEGMENTS check.

James Bottomley (1):
      x86: voyager: fix bogus conversion to per_cpu for boot_cpu_info

Jeff Garzik (2):
      x86: fix !SMP compiler warning in arch/x86/kernel/acpi/processor.c
      x86: fix compiler warnings in arch/x86/kernel/early-quirks.c

Ken'ichi Ohmichi (1):
      x86: Dump filtering supports x86_64 sparsemem

Thomas Gleixner (2):
      Revert "i386: export i386 smp_call_function_mask() to modules"
      x86: export smp_ops to allow modular build of KVM

 arch/x86/boot/compressed/head_32.S  |   12 ++++--------
 arch/x86/boot/compressed/head_64.S  |    7 +++++++
 arch/x86/kernel/acpi/processor.c    |    3 +--
 arch/x86/kernel/asm-offsets_64.c    |   10 ++++++++++
 arch/x86/kernel/early-quirks.c      |    4 +++-
 arch/x86/kernel/machine_kexec_64.c  |    2 ++
 arch/x86/kernel/smp_32.c            |    8 +-------
 arch/x86/mach-voyager/voyager_smp.c |    4 ++--
 include/asm-x86/smp_32.h            |    9 ++++++---
 9 files changed, 36 insertions(+), 23 deletions(-)
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index a0ae2e7..036e635 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -33,24 +33,20 @@
 	.globl startup_32
 
 startup_32:
-	/* check to see if KEEP_SEGMENTS flag is meaningful */
-	cmpw $0x207, BP_version(%esi)
-	jb 1f
-
+	cld
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 	 * us to not reload segments */
 	testb $(1<<6), BP_loadflags(%esi)
-	jnz 2f
+	jnz 1f
 
-1:	cli
+	cli
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
 	movl %eax,%ss
-
-2:	cld
+1:
 
 /* Calculate the delta between where we were compiled to run
  * at and where we were actually loaded at.  This can only be done
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 4946764..1ccb38a 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -29,6 +29,7 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/msr.h>
+#include <asm/asm-offsets.h>
 
 .section ".text.head"
 	.code32
@@ -36,11 +37,17 @@
 
 startup_32:
 	cld
+	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
+	 * us to not reload segments */
+	testb $(1<<6), BP_loadflags(%esi)
+	jnz 1f
+
 	cli
 	movl	$(__KERNEL_DS), %eax
 	movl	%eax, %ds
 	movl	%eax, %es
 	movl	%eax, %ss
+1:
 
 /* Calculate the delta between where we were compiled to run
  * at and where we were actually loaded at.  This can only be done
diff --git a/arch/x86/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
index 2ed0a4c..f63e5ff 100644
--- a/arch/x86/kernel/acpi/processor.c
+++ b/arch/x86/kernel/acpi/processor.c
@@ -62,8 +62,7 @@ static void init_intel_pdc(struct acpi_processor *pr, struct cpuinfo_x86 *c)
 /* Initialize _PDC data based on the CPU vendor */
 void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
 {
-	unsigned int cpu = pr->id;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct cpuinfo_x86 *c = &cpu_data(pr->id);
 
 	pr->pdc = NULL;
 	if (c->x86_vendor == X86_VENDOR_INTEL)
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 7e50bda..d1b6ed9 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -15,12 +15,16 @@
 #include <asm/segment.h>
 #include <asm/thread_info.h>
 #include <asm/ia32.h>
+#include <asm/bootparam.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
 
 #define BLANK() asm volatile("\n->" : : )
 
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem))
+
 #define __NO_STUBS 1
 #undef __SYSCALL
 #undef _ASM_X86_64_UNISTD_H_
@@ -109,5 +113,11 @@ int main(void)
 	DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
 	BLANK();
 	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+
+	BLANK();
+	OFFSET(BP_scratch, boot_params, scratch);
+	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
+	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
+	OFFSET(BP_version, boot_params, hdr.version);
 	return 0;
 }
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index dc34acb..639e632 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -35,12 +35,14 @@ static void __init via_bugs(void)
 }
 
 #ifdef CONFIG_ACPI
+#ifdef CONFIG_X86_IO_APIC
 
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
 	return 0;
 }
-#endif
+#endif /* CONFIG_X86_IO_APIC */
+#endif /* CONFIG_ACPI */
 
 static void __init nvidia_bugs(void)
 {
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 0d8577f..aa3d2c8 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -233,6 +233,8 @@ NORET_TYPE void machine_kexec(struct kimage *image)
 
 void arch_crash_save_vmcoreinfo(void)
 {
+	VMCOREINFO_SYMBOL(init_level4_pgt);
+
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index f321153..fcaa026 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -708,10 +708,4 @@ struct smp_ops smp_ops = {
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
 };
-
-int smp_call_function_mask(cpumask_t mask, void (*func) (void *info),
-			   void *info, int wait)
-{
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
-}
-EXPORT_SYMBOL(smp_call_function_mask);
+EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 361ac51..6937143 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -29,14 +29,14 @@
 #include <asm/arch_hooks.h>
 
 /* TLB state -- visible externally, indexed physically */
-DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate) ____cacheline_aligned = { &init_mm, 0 };
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate) = { &init_mm, 0 };
 
 /* CPU IRQ affinity -- set to all ones initially */
 static unsigned long cpu_irq_affinity[NR_CPUS] __cacheline_aligned = { [0 ... NR_CPUS-1]  = ~0UL };
 
 /* per CPU data structure (for /proc/cpuinfo et al), visible externally
  * indexed physically */
-DEFINE_PER_CPU(cpuinfo_x86, cpu_info) __cacheline_aligned;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 /* physical ID of the CPU used to boot the system */
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 7056d86..e10b7af 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -94,9 +94,12 @@ static inline void smp_send_reschedule(int cpu)
 {
 	smp_ops.smp_send_reschedule(cpu);
 }
-extern int smp_call_function_mask(cpumask_t mask,
-				  void (*func) (void *info), void *info,
-				  int wait);
+static inline int smp_call_function_mask(cpumask_t mask,
+					 void (*func) (void *info), void *info,
+					 int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
