Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXH1KoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXH1KoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXH1KoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:44:01 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27447
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbXH1KoA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:44:00 -0400
Message-Id: <46D418AF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 28 Aug 2007 11:44:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: [PATCH] x86: optionally show last exception from/to register
	contents (v2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. when dumping register state. This is particularly useful when gcc
managed to tail-call optimize an indirect call which happens to hit a
NULL (or otherwise invalid) pointer.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 Documentation/kernel-parameters.txt |    3 +++
 arch/i386/kernel/cpu/amd.c          |    4 ++++
 arch/i386/kernel/cpu/common.c       |    2 ++
 arch/i386/kernel/cpu/intel.c        |   20 ++++++++++++++------
 arch/i386/kernel/traps.c            |   35 +++++++++++++++++++++++++++++++++++
 arch/x86_64/kernel/setup.c          |   23 ++++++++++++++++++-----
 arch/x86_64/kernel/traps.c          |   34 ++++++++++++++++++++++++++++++++++
 include/asm-i386/msr-index.h        |    3 +++
 include/asm-i386/processor.h        |    4 ++++
 include/asm-x86_64/msr.h            |    6 ++++++
 include/asm-x86_64/processor.h      |    3 +++
 11 files changed, 126 insertions(+), 11 deletions(-)

--- linux-2.6.23-rc4/Documentation/kernel-parameters.txt	2007-08-28 09:41:55.000000000 +0200
+++ 2.6.23-rc4-x86-ler/Documentation/kernel-parameters.txt	2007-08-17 09:58:55.000000000 +0200
@@ -1155,6 +1155,9 @@ and is between 256 and 4096 characters. 
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
+	noler		[X86-32/X86-64] Do not print last exception records
+			with kernel register dumps.
+
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
--- linux-2.6.23-rc4/arch/i386/kernel/cpu/amd.c	2007-08-28 09:41:58.000000000 +0200
+++ 2.6.23-rc4-x86-ler/arch/i386/kernel/cpu/amd.c	2007-08-17 10:02:17.000000000 +0200
@@ -238,9 +238,13 @@ static void __cpuinit init_amd(struct cp
 	case 0x10:
 	case 0x11:
 		set_bit(X86_FEATURE_K8, c->x86_capability);
+		if (ler_enabled)
+			__get_cpu_var(ler_msr) = MSR_IA32_LASTINTFROMIP;
 		break;
 	case 6:
 		set_bit(X86_FEATURE_K7, c->x86_capability); 
+		if (ler_enabled)
+			__get_cpu_var(ler_msr) = MSR_IA32_LASTINTFROMIP;
 		break;
 	}
 	if (c->x86 >= 6)
--- linux-2.6.23-rc4/arch/i386/kernel/cpu/common.c	2007-08-28 09:41:58.000000000 +0200
+++ 2.6.23-rc4-x86-ler/arch/i386/kernel/cpu/common.c	2007-08-07 10:42:55.000000000 +0200
@@ -503,6 +503,8 @@ static void __cpuinit identify_cpu(struc
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+
+	ler_enable();
 }
 
 void __init identify_boot_cpu(void)
--- linux-2.6.23-rc4/arch/i386/kernel/cpu/intel.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc4-x86-ler/arch/i386/kernel/cpu/intel.c	2007-08-07 10:42:55.000000000 +0200
@@ -188,15 +188,23 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
-	if (c->x86 == 15) {
+	switch (c->x86) {
+	case 15:
 		set_bit(X86_FEATURE_P4, c->x86_capability);
 		set_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
-	}
-	if (c->x86 == 6) 
+		if (c->x86_model >= 0x03)
+			set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
+		if (ler_enabled)
+			__get_cpu_var(ler_msr) = MSR_P4_LER_FROM_LIP;
+		break;
+	case 6:
 		set_bit(X86_FEATURE_P3, c->x86_capability);
-	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-		(c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
+		if (c->x86_model >= 0x0e)
+			set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
+		if (ler_enabled)
+			__get_cpu_var(ler_msr) = MSR_IA32_LASTINTFROMIP;
+		break;
+	}
 
 	if (cpu_has_ds) {
 		unsigned int l1;
--- linux-2.6.23-rc4/arch/i386/kernel/traps.c	2007-08-28 09:41:58.000000000 +0200
+++ 2.6.23-rc4-x86-ler/arch/i386/kernel/traps.c	2007-08-17 14:26:08.000000000 +0200
@@ -321,6 +321,20 @@ void show_registers(struct pt_regs *regs
 		unsigned int code_len = code_bytes;
 		unsigned char c;
 
+		if (oops_in_progress && __get_cpu_var(ler_msr)) {
+			u32 from, to, hi;
+
+			if (rdmsr_safe(__get_cpu_var(ler_msr), &from, &hi) == 0
+			    && rdmsr_safe(__get_cpu_var(ler_msr) + 1, &to, &hi) == 0) {
+				printk("\n" KERN_EMERG
+				       "last branch before last exception/interrupt\n");
+				printk(KERN_EMERG " from %08x", from);
+				print_symbol(" (%s)\n", from);
+				printk(KERN_EMERG " to %08x", to);
+				print_symbol(" (%s)", to);
+			} else
+				__get_cpu_var(ler_msr) = 0;
+		}
 		printk("\n" KERN_EMERG "Stack: ");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)esp, KERN_EMERG);
 
@@ -360,6 +374,19 @@ int is_valid_bugaddr(unsigned long eip)
 	return ud2 == 0x0b0f;
 }
 
+DEFINE_PER_CPU(u32, ler_msr);
+int ler_enabled = 1;
+
+void ler_enable(void) {
+	if (__get_cpu_var(ler_msr)) {
+		u32 lo, hi;
+
+		if (rdmsr_safe(MSR_IA32_DEBUGCTLMSR, &lo, &hi) < 0
+		    || wrmsr_safe(MSR_IA32_DEBUGCTLMSR, lo | 1, hi) < 0)
+			__get_cpu_var(ler_msr) = 0;
+	}
+}
+
 /*
  * This is gone through when something in the kernel has done something bad and
  * is about to be terminated.
@@ -846,6 +873,7 @@ fastcall void __kprobes do_debug(struct 
 	struct task_struct *tsk = current;
 
 	get_debugreg(condition, 6);
+	ler_enable();
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 					SIGTRAP) == NOTIFY_STOP)
@@ -1239,3 +1267,10 @@ static int __init code_bytes_setup(char 
 	return 1;
 }
 __setup("code_bytes=", code_bytes_setup);
+
+static int __init ler_setup(char *s)
+{
+	ler_enabled = 0;
+	return 1;
+}
+__setup("noler", ler_setup);
--- linux-2.6.23-rc4/arch/x86_64/kernel/setup.c	2007-08-28 09:42:04.000000000 +0200
+++ 2.6.23-rc4-x86-ler/arch/x86_64/kernel/setup.c	2007-08-17 10:00:41.000000000 +0200
@@ -617,6 +617,9 @@ static void __cpuinit init_amd(struct cp
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
+
+	if (ler_enabled && c->x86 <= 17)
+		__get_cpu_var(ler_msr) = MSR_IA32_LASTINTFROMIP;
 }
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
@@ -736,13 +739,22 @@ static void __cpuinit init_intel(struct 
 			c->x86_phys_bits = 36;
 	}
 
-	if (c->x86 == 15)
+	switch (c->x86) {
+	case 15:
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
-	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
-	if (c->x86 == 6)
+		if (c->x86_model >= 0x03)
+			set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
+		if (ler_enabled)
+			__get_cpu_var(ler_msr) = MSR_P4_LER_FROM_LIP;
+		break;
+	case 6:
+		if (c->x86_model >= 0x0e)
+			set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
 		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
+		if (ler_enabled)
+			__get_cpu_var(ler_msr) = MSR_IA32_LASTINTFROMIP;
+		break;
+	}
 	if (c->x86 == 15)
 		set_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
 	else
@@ -906,6 +918,7 @@ void __cpuinit identify_cpu(struct cpuin
 #ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
+	ler_enable();
 }
  
 
--- linux-2.6.23-rc4/arch/x86_64/kernel/traps.c	2007-08-28 09:42:05.000000000 +0200
+++ 2.6.23-rc4-x86-ler/arch/x86_64/kernel/traps.c	2007-08-17 14:26:31.000000000 +0200
@@ -426,6 +426,19 @@ void show_registers(struct pt_regs *regs
 	 * time of the fault..
 	 */
 	if (in_kernel) {
+		if (oops_in_progress && __get_cpu_var(ler_msr)) {
+			u64 from, to;
+
+			if (checking_rdmsrl(__get_cpu_var(ler_msr), from) == 0
+			    && checking_rdmsrl(__get_cpu_var(ler_msr) + 1, to) == 0) {
+				printk("last branch before last exception/interrupt\n");
+				printk(" from ");
+				printk_address(from);
+				printk(" to ");
+				printk_address(to);
+			} else
+				__get_cpu_var(ler_msr) = 0;
+		}
 		printk("Stack: ");
 		_show_stack(NULL, regs, (unsigned long*)rsp);
 
@@ -464,6 +477,19 @@ void out_of_line_bug(void)
 EXPORT_SYMBOL(out_of_line_bug);
 #endif
 
+DEFINE_PER_CPU(u32, ler_msr);
+int ler_enabled = 1;
+
+void ler_enable(void) {
+	if (__get_cpu_var(ler_msr)) {
+		u32 lo, hi;
+
+		if (rdmsr_safe(MSR_IA32_DEBUGCTLMSR, &lo, &hi) < 0
+		    || wrmsr_safe(MSR_IA32_DEBUGCTLMSR, lo | 1, hi) < 0)
+			__get_cpu_var(ler_msr) = 0;
+	}
+}
+
 static DEFINE_SPINLOCK(die_lock);
 static int die_owner = -1;
 static unsigned int die_nest_count;
@@ -849,6 +875,7 @@ asmlinkage void __kprobes do_debug(struc
 	siginfo_t info;
 
 	get_debugreg(condition, 6);
+	ler_enable();
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 						SIGTRAP) == NOTIFY_STOP)
@@ -1136,3 +1163,10 @@ static int __init kstack_setup(char *s)
 	return 0;
 }
 early_param("kstack", kstack_setup);
+
+static int __init ler_setup(char *s)
+{
+	ler_enabled = 0;
+	return 1;
+}
+__setup("noler", ler_setup);
--- linux-2.6.23-rc4/include/asm-i386/msr-index.h	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc4-x86-ler/include/asm-i386/msr-index.h	2007-08-07 10:42:55.000000000 +0200
@@ -63,6 +63,9 @@
 #define MSR_IA32_LASTINTFROMIP		0x000001dd
 #define MSR_IA32_LASTINTTOIP		0x000001de
 
+#define MSR_P4_LER_FROM_LIP 		0x000001d7
+#define MSR_P4_LER_TO_LIP 		0x000001d8
+
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
 #define MSR_IA32_MC0_ADDR		0x00000402
--- linux-2.6.23-rc4/include/asm-i386/processor.h	2007-08-28 09:42:34.000000000 +0200
+++ 2.6.23-rc4-x86-ler/include/asm-i386/processor.h	2007-08-07 10:42:55.000000000 +0200
@@ -643,6 +643,10 @@ static inline unsigned int cpuid_edx(uns
 	return edx;
 }
 
+DECLARE_PER_CPU(u32, ler_msr);
+extern int ler_enabled;
+void ler_enable(void);
+
 /* generic versions from gas */
 #define GENERIC_NOP1	".byte 0x90\n"
 #define GENERIC_NOP2    	".byte 0x89,0xf6\n"
--- linux-2.6.23-rc4/include/asm-x86_64/msr.h	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc4-x86-ler/include/asm-x86_64/msr.h	2007-08-17 14:45:14.000000000 +0200
@@ -63,6 +63,12 @@
                       :"c"(msr), "i"(-EIO), "0"(0));		\
 	  ret__; })		
 
+#define checking_rdmsrl(msr,val) ({				\
+	u32 lo__, hi__;						\
+	int rc__ = rdmsr_safe(msr, &lo__, &hi__);		\
+	val = lo__ | ((u64)hi__ << 32);				\
+	rc__; })
+
 #define rdtsc(low,high) \
      __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))
 
--- linux-2.6.23-rc4/include/asm-x86_64/processor.h	2007-08-28 09:42:36.000000000 +0200
+++ 2.6.23-rc4-x86-ler/include/asm-x86_64/processor.h	2007-08-07 10:42:55.000000000 +0200
@@ -333,6 +333,9 @@ struct extended_sigtable {
 	struct extended_signature sigs[0];
 };
 
+DECLARE_PER_CPU(u32, ler_msr);
+extern int ler_enabled;
+void ler_enable(void);
 
 #define ASM_NOP1 K8_NOP1
 #define ASM_NOP2 K8_NOP2


