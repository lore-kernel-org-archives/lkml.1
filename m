Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXKIViA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXKIViA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760369AbXKIVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:34:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbXKIVeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:34:05 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/24] Add debugreg/load_rsp native hooks
Date: Fri,  9 Nov 2007 16:42:47 -0200
Message-Id: <11946338212915-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1194633815833-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds native hooks for debugreg handling functions,
and for the native load_rsp0 function. The later also have its
call sites patched. There's some room for consolidation in the
processor*.h headers, and it is done, for paravirt related functions

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/process_64.c   |    2 +-
 arch/x86/kernel/smpboot_64.c   |    2 +-
 include/asm-x86/msr.h          |   67 ------------------
 include/asm-x86/processor.h    |  146 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h |  138 +-------------------------------------
 include/asm-x86/processor_64.h |   32 ++++-----
 6 files changed, 165 insertions(+), 222 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6472f37..9647a10 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -589,7 +589,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Reload esp0, LDT and the page table pointer:
 	 */
-	tss->rsp0 = next->rsp0;
+	load_esp0(tss, next);
 
 	/* 
 	 * Switch DS and ES.
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 17e54fa..8fb0f90 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -613,7 +613,7 @@ do_rest:
 	start_rip = setup_trampoline();
 
 	init_rsp = c_idle.idle->thread.rsp;
-	per_cpu(init_tss,cpu).rsp0 = init_rsp;
+	load_esp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
 	initial_code = start_secondary;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index ba4b314..48f73c7 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -253,73 +253,6 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 			  : "=a" (low), "=d" (high) \
 			  : "c" (counter))
 
-static inline void cpuid(int op, unsigned int *eax, unsigned int *ebx,
-			 unsigned int *ecx, unsigned int *edx)
-{
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (op));
-}
-
-/* Some CPUID calls want 'count' to be placed in ecx */
-static inline void cpuid_count(int op, int count, int *eax, int *ebx, int *ecx,
-			       int *edx)
-{
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (op), "c" (count));
-}
-
-/*
- * CPUID functions returning a single datum
- */
-static inline unsigned int cpuid_eax(unsigned int op)
-{
-	unsigned int eax;
-
-	__asm__("cpuid"
-		: "=a" (eax)
-		: "0" (op)
-		: "bx", "cx", "dx");
-	return eax;
-}
-static inline unsigned int cpuid_ebx(unsigned int op)
-{
-	unsigned int eax, ebx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=b" (ebx)
-		: "0" (op)
-		: "cx", "dx" );
-	return ebx;
-}
-static inline unsigned int cpuid_ecx(unsigned int op)
-{
-	unsigned int eax, ecx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=c" (ecx)
-		: "0" (op)
-		: "bx", "dx" );
-	return ecx;
-}
-static inline unsigned int cpuid_edx(unsigned int op)
-{
-	unsigned int eax, edx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=d" (edx)
-		: "0" (op)
-		: "bx", "cx");
-	return edx;
-}
-
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 46e1c04..a576a72 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -1,5 +1,151 @@
+#ifndef _X86_PROCESSOR_H_
+#define _X86_PROCESSOR_H_
+
+#include <linux/kernel.h>
+#include <asm/bug.h>
+
+static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
+				unsigned int *ecx, unsigned int *edx)
+{
+	/* ecx is often an input as well as an output. */
+	__asm__("cpuid"
+		: "=a" (*eax),
+		  "=b" (*ebx),
+		  "=c" (*ecx),
+		  "=d" (*edx)
+		: "0" (*eax), "2" (*ecx));
+}
+
+static inline unsigned long native_get_debugreg(int regno)
+{
+	unsigned long val = 0; 	/* Damn you, gcc! */
+
+	switch (regno) {
+	case 0:
+		asm volatile ("mov %%db0, %0" :"=r" (val)); break;
+	case 1:
+		asm volatile ("mov %%db1, %0" :"=r" (val)); break;
+	case 2:
+		asm volatile ("mov %%db2, %0" :"=r" (val)); break;
+	case 3:
+		asm volatile ("mov %%db3, %0" :"=r" (val)); break;
+	case 6:
+		asm volatile ("mov %%db6, %0" :"=r" (val)); break;
+	case 7:
+		asm volatile ("mov %%db7, %0" :"=r" (val)); break;
+	default:
+		WARN_ON(1);
+	}
+	return val;
+}
+
+static inline void native_set_debugreg(int regno, unsigned long value)
+{
+	switch (regno) {
+	case 0:
+		asm("mov %0,%%db0"	:  :"r" (value) : "memory");
+		break;
+	case 1:
+		asm("mov %0,%%db1"	:  :"r" (value) : "memory");
+		break;
+	case 2:
+		asm("mov %0,%%db2"	:  :"r" (value) : "memory");
+		break;
+	case 3:
+		asm("mov %0,%%db3"	:  :"r" (value) : "memory");
+		break;
+	case 6:
+		asm("mov %0,%%db6"	:  :"r" (value) : "memory");
+		break;
+	case 7:
+		asm("mov %0,%%db7"	:  :"r" (value) : "memory");
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+
 #ifdef CONFIG_X86_32
 # include "processor_32.h"
 #else
 # include "processor_64.h"
 #endif
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_enabled() 0
+#define __cpuid native_cpuid
+#define SWAPGS	swapgs
+
+static inline void load_esp0(struct tss_struct *tss,
+			     struct thread_struct *thread)
+{
+	native_load_esp0(tss, thread);
+}
+
+/*
+ * These special macros can be used to get or set a debugging register
+ */
+#define get_debugreg(var, register)				\
+	(var) = native_get_debugreg(register)
+#define set_debugreg(value, register)				\
+	native_set_debugreg(register, value)
+
+#define set_iopl_mask native_set_iopl_mask
+#endif /* CONFIG_PARAVIRT */
+
+/*
+ * Generic CPUID function
+ * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
+ * resulting in stale register contents being returned.
+ */
+static inline void cpuid(unsigned int op, unsigned int *eax, unsigned int *ebx,
+			 unsigned int *ecx, unsigned int *edx)
+{
+	*eax = op;
+	*ecx = 0;
+	__cpuid(eax, ebx, ecx, edx);
+}
+
+/* Some CPUID calls want 'count' to be placed in ecx */
+static inline void cpuid_count(int op, int count, unsigned *eax,
+			       unsigned *ebx, unsigned *ecx, unsigned *edx)
+{
+	*eax = op;
+	*ecx = count;
+	__cpuid(eax, ebx, ecx, edx);
+}
+
+/*
+ * CPUID functions returning a single datum
+ */
+static inline unsigned int cpuid_eax(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return eax;
+}
+static inline unsigned int cpuid_ebx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return ebx;
+}
+static inline unsigned int cpuid_ecx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return ecx;
+}
+static inline unsigned int cpuid_edx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return edx;
+}
+#endif
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 3b51a18..233fee3 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -132,17 +132,6 @@ extern void detect_ht(struct cpuinfo_x86 *c);
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
 
-static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
-					 unsigned int *ecx, unsigned int *edx)
-{
-	/* ecx is often an input as well as an output. */
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (*eax), "2" (*ecx));
-}
 
 #define load_cr3(pgdir) write_cr3(__pa(pgdir))
 
@@ -505,56 +494,6 @@ static inline void native_load_esp0(struct tss_struct *tss, struct thread_struct
 	}
 }
 
-
-static inline unsigned long native_get_debugreg(int regno)
-{
-	unsigned long val = 0; 	/* Damn you, gcc! */
-
-	switch (regno) {
-	case 0:
-		asm("movl %%db0, %0" :"=r" (val)); break;
-	case 1:
-		asm("movl %%db1, %0" :"=r" (val)); break;
-	case 2:
-		asm("movl %%db2, %0" :"=r" (val)); break;
-	case 3:
-		asm("movl %%db3, %0" :"=r" (val)); break;
-	case 6:
-		asm("movl %%db6, %0" :"=r" (val)); break;
-	case 7:
-		asm("movl %%db7, %0" :"=r" (val)); break;
-	default:
-		BUG();
-	}
-	return val;
-}
-
-static inline void native_set_debugreg(int regno, unsigned long value)
-{
-	switch (regno) {
-	case 0:
-		asm("movl %0,%%db0"	: /* no output */ :"r" (value));
-		break;
-	case 1:
-		asm("movl %0,%%db1"	: /* no output */ :"r" (value));
-		break;
-	case 2:
-		asm("movl %0,%%db2"	: /* no output */ :"r" (value));
-		break;
-	case 3:
-		asm("movl %0,%%db3"	: /* no output */ :"r" (value));
-		break;
-	case 6:
-		asm("movl %0,%%db6"	: /* no output */ :"r" (value));
-		break;
-	case 7:
-		asm("movl %0,%%db7"	: /* no output */ :"r" (value));
-		break;
-	default:
-		BUG();
-	}
-}
-
 /*
  * Set IOPL bits in EFLAGS from given mask
  */
@@ -571,82 +510,9 @@ static inline void native_set_iopl_mask(unsigned mask)
 				: "i" (~X86_EFLAGS_IOPL), "r" (mask));
 }
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define paravirt_enabled() 0
-#define __cpuid native_cpuid
-
-static inline void load_esp0(struct tss_struct *tss, struct thread_struct *thread)
-{
-	native_load_esp0(tss, thread);
-}
-
-/*
- * These special macros can be used to get or set a debugging register
- */
-#define get_debugreg(var, register)				\
-	(var) = native_get_debugreg(register)
-#define set_debugreg(value, register)				\
-	native_set_debugreg(register, value)
-
-#define set_iopl_mask native_set_iopl_mask
-#endif /* CONFIG_PARAVIRT */
-
-/*
- * Generic CPUID function
- * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
- * resulting in stale register contents being returned.
- */
-static inline void cpuid(unsigned int op,
-			 unsigned int *eax, unsigned int *ebx,
-			 unsigned int *ecx, unsigned int *edx)
-{
-	*eax = op;
-	*ecx = 0;
-	__cpuid(eax, ebx, ecx, edx);
-}
-
-/* Some CPUID calls want 'count' to be placed in ecx */
-static inline void cpuid_count(unsigned int op, int count,
-			       unsigned int *eax, unsigned int *ebx,
-			       unsigned int *ecx, unsigned int *edx)
-{
-	*eax = op;
-	*ecx = count;
-	__cpuid(eax, ebx, ecx, edx);
-}
-
-/*
- * CPUID functions returning a single datum
- */
-static inline unsigned int cpuid_eax(unsigned int op)
-{
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return eax;
-}
-static inline unsigned int cpuid_ebx(unsigned int op)
-{
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return ebx;
-}
-static inline unsigned int cpuid_ecx(unsigned int op)
-{
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return ecx;
-}
-static inline unsigned int cpuid_edx(unsigned int op)
+/* We don't really have one */
+static inline void native_swapgs(void)
 {
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return edx;
 }
 
 /* generic versions from gas */
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index 6c0d96a..befecc6 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -114,21 +114,13 @@ extern unsigned long mmu_cr4_features;
 static inline void set_in_cr4 (unsigned long mask)
 {
 	mmu_cr4_features |= mask;
-	__asm__("movq %%cr4,%%rax\n\t"
-		"orq %0,%%rax\n\t"
-		"movq %%rax,%%cr4\n"
-		: : "irg" (mask)
-		:"ax");
+	write_cr4(read_cr4() | mask);
 }
 
 static inline void clear_in_cr4 (unsigned long mask)
 {
 	mmu_cr4_features &= ~mask;
-	__asm__("movq %%cr4,%%rax\n\t"
-		"andq %0,%%rax\n\t"
-		"movq %%rax,%%cr4\n"
-		: : "irg" (~mask)
-		:"ax");
+	write_cr4(read_cr4() & ~mask);
 }
 
 
@@ -249,6 +241,12 @@ struct thread_struct {
 	.rsp0 = (unsigned long)&init_stack + sizeof(init_stack) \
 }
 
+static inline void native_load_esp0(struct tss_struct *tss,
+				    struct thread_struct *thread)
+{
+	tss->rsp0 = thread->rsp0;
+}
+
 #define INIT_MMAP \
 { &init_mm, 0, 0, NULL, PAGE_SHARED, VM_READ | VM_WRITE | VM_EXEC, 1, NULL, NULL }
 
@@ -264,13 +262,13 @@ struct thread_struct {
 	set_fs(USER_DS);							 \
 } while(0) 
 
-#define get_debugreg(var, register)				\
-		__asm__("movq %%db" #register ", %0"		\
-			:"=r" (var))
-#define set_debugreg(value, register)			\
-		__asm__("movq %0,%%db" #register		\
-			: /* no output */			\
-			:"r" (value))
+extern void native_swapgs(void);
+
+/* We have it for simmetry with i386 code, but we don't really use it */
+static inline void native_set_iopl_mask(unsigned mask)
+{
+
+}
 
 struct task_struct;
 struct mm_struct;
-- 
1.4.4.2

