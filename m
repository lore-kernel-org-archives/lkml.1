Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXIUWog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXIUWog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763222AbXIUWcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:41 -0400
Received: from ns.suse.de ([195.135.220.2]:57077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763718AbXIUWcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:33 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [32/50] x86: Show last exception from/to register  contents 
Message-Id: <20070921223231.DF0BA13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
.. when dumping register state. This is particularly useful when gcc
managed to tail-call optimize an indirect call which happens to hit a
NULL (or otherwise invalid) pointer.

The result is unreliable because interrupts happening inbetween can mess
it up

AK: added some warnings that the result can be unreliable

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 Documentation/kernel-parameters.txt |    3 +++
 arch/i386/kernel/cpu/amd.c          |    4 ++++
 arch/i386/kernel/cpu/common.c       |    2 ++
 arch/i386/kernel/cpu/intel.c        |   20 ++++++++++++++------
 arch/i386/kernel/traps.c            |   35 +++++++++++++++++++++++++++++++++++
 arch/x86_64/kernel/setup.c          |   23 ++++++++++++++++++-----
 arch/x86_64/kernel/traps.c          |   33 +++++++++++++++++++++++++++++++++
 include/asm-i386/msr-index.h        |    3 +++
 include/asm-i386/processor.h        |    4 ++++
 include/asm-x86_64/msr.h            |    6 ++++++
 include/asm-x86_64/processor.h      |    3 +++
 11 files changed, 125 insertions(+), 11 deletions(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -1152,6 +1152,9 @@ and is between 256 and 4096 characters. 
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
+	noler		[X86-32/X86-64] Do not print last exception records
+			with kernel register dumps.
+
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
Index: linux/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/amd.c
+++ linux/arch/i386/kernel/cpu/amd.c
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
Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -503,6 +503,8 @@ static void __cpuinit identify_cpu(struc
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+
+	ler_enable();
 }
 
 void __init identify_boot_cpu(void)
Index: linux/arch/i386/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/intel.c
+++ linux/arch/i386/kernel/cpu/intel.c
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
Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -374,6 +374,20 @@ void show_registers(struct pt_regs *regs
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
 		show_stack_log_lvl(NULL, regs, &regs->esp, KERN_EMERG);
 
@@ -413,6 +427,19 @@ int is_valid_bugaddr(unsigned long eip)
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
@@ -891,6 +918,7 @@ fastcall void __kprobes do_debug(struct 
 	struct task_struct *tsk = current;
 
 	get_debugreg(condition, 6);
+	ler_enable();
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 					SIGTRAP) == NOTIFY_STOP)
@@ -1275,6 +1303,13 @@ static int __init kstack_setup(char *s)
 }
 __setup("kstack=", kstack_setup);
 
+static int __init ler_setup(char *s)
+{
+	ler_enabled = 0;
+	return 1;
+}
+__setup("noler", ler_setup);
+
 static int __init code_bytes_setup(char *s)
 {
 	code_bytes = simple_strtoul(s, NULL, 0);
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -639,6 +639,9 @@ static void __cpuinit init_amd(struct cp
 	    !rdmsr_safe(MSR_VM_CR, &flags, &dummy) &&
 	    (flags & 0x18))
 		set_bit(X86_FEATURE_VIRT_DISABLED, &c->x86_capability);
+
+	if (ler_enabled && c->x86 <= 17)
+		__get_cpu_var(ler_msr) = MSR_IA32_LASTINTFROMIP;
 }
 
 static int enable_svm_lock(char *s)
@@ -774,13 +777,22 @@ static void __cpuinit init_intel(struct 
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
@@ -951,6 +963,7 @@ void __cpuinit identify_cpu(struct cpuin
 #ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
+	ler_enable();
 }
  
 
Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
@@ -492,6 +492,19 @@ void show_registers(struct pt_regs *regs
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
 
@@ -530,6 +543,19 @@ void out_of_line_bug(void)
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
@@ -920,6 +946,7 @@ asmlinkage void __kprobes do_debug(struc
 	siginfo_t info;
 
 	get_debugreg(condition, 6);
+	ler_enable();
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 						SIGTRAP) == NOTIFY_STOP)
@@ -1188,6 +1215,12 @@ void __init trap_init(void)
 	cpu_init();
 }
 
+static int __init ler_setup(char *s)
+{
+	ler_enabled = 0;
+	return 1;
+}
+__setup("noler", ler_setup);
 
 static int __init oops_setup(char *s)
 { 
Index: linux/include/asm-i386/msr-index.h
===================================================================
--- linux.orig/include/asm-i386/msr-index.h
+++ linux/include/asm-i386/msr-index.h
@@ -63,6 +63,9 @@
 #define MSR_IA32_LASTINTFROMIP		0x000001dd
 #define MSR_IA32_LASTINTTOIP		0x000001de
 
+#define MSR_P4_LER_FROM_LIP 		0x000001d7
+#define MSR_P4_LER_TO_LIP 		0x000001d8
+
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
 #define MSR_IA32_MC0_ADDR		0x00000402
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
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
Index: linux/include/asm-x86_64/msr.h
===================================================================
--- linux.orig/include/asm-x86_64/msr.h
+++ linux/include/asm-x86_64/msr.h
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
 
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -334,6 +334,9 @@ struct extended_sigtable {
 	struct extended_signature sigs[0];
 };
 
+DECLARE_PER_CPU(u32, ler_msr);
+extern int ler_enabled;
+void ler_enable(void);
 
 #define ASM_NOP1 K8_NOP1
 #define ASM_NOP2 K8_NOP2
