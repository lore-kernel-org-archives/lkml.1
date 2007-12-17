Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXLRBik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXLRBik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbXLRBgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:36:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202AbXLRBgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:36:44 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 5/21] [PATCH] unify paravirt pieces of processor.h
Date: Mon, 17 Dec 2007 20:52:28 -0200
Message-Id: <11979319903443-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979319853319-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies the paravirt pieces of processor.h
The functionality present in 32 bit, but not (yet) in 64-bit,
like load_sp0 is _not_ done here, and let to a different patch.

With this unification, we get paravirt for free in x86_64 processor.h

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |   90 +++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/processor_32.h |   87 --------------------------------------
 include/asm-x86/processor_64.h |   36 ----------------
 3 files changed, 89 insertions(+), 124 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -29,9 +29,97 @@ static inline void load_cr3(pgd_t *pgdir
 # include "processor_64.h"
 #endif
 
+static inline unsigned long native_get_debugreg(int regno)
+{
+	unsigned long val = 0; 	/* Damn you, gcc! */
+
+	switch (regno) {
+	case 0:
+		asm("mov %%db0, %0" :"=r" (val)); break;
+	case 1:
+		asm("mov %%db1, %0" :"=r" (val)); break;
+	case 2:
+		asm("mov %%db2, %0" :"=r" (val)); break;
+	case 3:
+		asm("mov %%db3, %0" :"=r" (val)); break;
+	case 6:
+		asm("mov %%db6, %0" :"=r" (val)); break;
+	case 7:
+		asm("mov %%db7, %0" :"=r" (val)); break;
+	default:
+		BUG();
+	}
+	return val;
+}
+
+static inline void native_set_debugreg(int regno, unsigned long value)
+{
+	switch (regno) {
+	case 0:
+		asm("mov %0,%%db0"	: /* no output */ :"r" (value));
+		break;
+	case 1:
+		asm("mov %0,%%db1"	: /* no output */ :"r" (value));
+		break;
+	case 2:
+		asm("mov %0,%%db2"	: /* no output */ :"r" (value));
+		break;
+	case 3:
+		asm("mov %0,%%db3"	: /* no output */ :"r" (value));
+		break;
+	case 6:
+		asm("mov %0,%%db6"	: /* no output */ :"r" (value));
+		break;
+	case 7:
+		asm("mov %0,%%db7"	: /* no output */ :"r" (value));
+		break;
+	default:
+		BUG();
+	}
+}
+
+
 #ifndef CONFIG_PARAVIRT
 #define __cpuid native_cpuid
-#endif
+#define paravirt_enabled() 0
+
+/*
+ * These special macros can be used to get or set a debugging register
+ */
+#define get_debugreg(var, register)				\
+	(var) = native_get_debugreg(register)
+#define set_debugreg(value, register)				\
+	native_set_debugreg(register, value)
+
+#endif /* CONFIG_PARAVIRT */
+
+/*
+ * Save the cr4 feature set we're using (ie
+ * Pentium 4MB enable and PPro Global page
+ * enable), so that any CPU's that boot up
+ * after us can get the correct flags.
+ */
+extern unsigned long mmu_cr4_features;
+
+static inline void set_in_cr4(unsigned long mask)
+{
+	unsigned cr4;
+	mmu_cr4_features |= mask;
+	cr4 = read_cr4();
+	cr4 |= mask;
+	write_cr4(cr4);
+}
+
+static inline void clear_in_cr4(unsigned long mask)
+{
+	unsigned cr4;
+	mmu_cr4_features &= ~mask;
+	cr4 = read_cr4();
+	cr4 &= ~mask;
+	write_cr4(cr4);
+}
+
+
 
 /*
  * Generic CPUID function
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -120,33 +120,6 @@ extern void detect_ht(struct cpuinfo_x86
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
 
-
-/*
- * Save the cr4 feature set we're using (ie
- * Pentium 4MB enable and PPro Global page
- * enable), so that any CPU's that boot up
- * after us can get the correct flags.
- */
-extern unsigned long mmu_cr4_features;
-
-static inline void set_in_cr4 (unsigned long mask)
-{
-	unsigned cr4;
-	mmu_cr4_features |= mask;
-	cr4 = read_cr4();
-	cr4 |= mask;
-	write_cr4(cr4);
-}
-
-static inline void clear_in_cr4 (unsigned long mask)
-{
-	unsigned cr4;
-	mmu_cr4_features &= ~mask;
-	cr4 = read_cr4();
-	cr4 &= ~mask;
-	write_cr4(cr4);
-}
-
 /* Stop speculative execution */
 static inline void sync_core(void)
 {
@@ -484,57 +457,6 @@ static inline void native_load_sp0(struc
 		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
 	}
 }
-
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
@@ -554,21 +476,12 @@ static inline void native_set_iopl_mask(
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define paravirt_enabled() 0
 
 static inline void load_sp0(struct tss_struct *tss, struct thread_struct *thread)
 {
 	native_load_sp0(tss, thread);
 }
 
-/*
- * These special macros can be used to get or set a debugging register
- */
-#define get_debugreg(var, register)				\
-	(var) = native_get_debugreg(register)
-#define set_debugreg(value, register)				\
-	native_set_debugreg(register, value)
-
 #define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -88,34 +88,6 @@ extern void init_scattered_cpuid_feature
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
-/*
- * Save the cr4 feature set we're using (ie
- * Pentium 4MB enable and PPro Global page
- * enable), so that any CPU's that boot up
- * after us can get the correct flags.
- */
-extern unsigned long mmu_cr4_features;
-
-static inline void set_in_cr4 (unsigned long mask)
-{
-	mmu_cr4_features |= mask;
-	__asm__("movq %%cr4,%%rax\n\t"
-		"orq %0,%%rax\n\t"
-		"movq %%rax,%%cr4\n"
-		: : "irg" (mask)
-		:"ax");
-}
-
-static inline void clear_in_cr4 (unsigned long mask)
-{
-	mmu_cr4_features &= ~mask;
-	__asm__("movq %%cr4,%%rax\n\t"
-		"andq %0,%%rax\n\t"
-		"movq %%rax,%%cr4\n"
-		: : "irg" (~mask)
-		:"ax");
-}
-
 
 /*
  * User space process size. 47bits minus one guard page.
@@ -254,14 +226,6 @@ struct thread_struct {
 	set_fs(USER_DS);							 \
 } while(0) 
 
-#define get_debugreg(var, register)				\
-		__asm__("movq %%db" #register ", %0"		\
-			:"=r" (var))
-#define set_debugreg(value, register)			\
-		__asm__("movq %0,%%db" #register		\
-			: /* no output */			\
-			:"r" (value))
-
 struct task_struct;
 struct mm_struct;
 
