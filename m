Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbXHOMvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbXHOMvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759936AbXHOMus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:50:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759743AbXHOMup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:50:45 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/25][V3] Add debugreg/load_rsp native hooks
Date: Wed, 15 Aug 2007 09:49:24 -0300
Message-Id: <11871822244170-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11871822163867-git-send-email-gcosta@redhat.com>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds native hooks for debugreg handling functions,
and for the native load_rsp0 function. The later also have its
call sites patched.

[  updates from v2
   * there were still a raw reference to cr4 missing
]

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/process.c   |    2 +-
 arch/x86_64/kernel/smpboot.c   |    2 +-
 include/asm-x86_64/processor.h |   83 +++++++++++++++++++++++++++++++--------
 3 files changed, 68 insertions(+), 19 deletions(-)

diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 2842f50..33046f1 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -595,7 +595,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Reload esp0, LDT and the page table pointer:
 	 */
-	tss->rsp0 = next->rsp0;
+	load_rsp0(tss, next);
 
 	/* 
 	 * Switch DS and ES.
diff --git a/arch/x86_64/kernel/smpboot.c b/arch/x86_64/kernel/smpboot.c
index 32f5078..f99ced6 100644
--- a/arch/x86_64/kernel/smpboot.c
+++ b/arch/x86_64/kernel/smpboot.c
@@ -620,7 +620,7 @@ do_rest:
 	start_rip = setup_trampoline();
 
 	init_rsp = c_idle.idle->thread.rsp;
-	per_cpu(init_tss,cpu).rsp0 = init_rsp;
+	load_rsp0(&per_cpu(init_tss,cpu), &c_idle.idle->thread);
 	initial_code = start_secondary;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 
diff --git a/include/asm-x86_64/processor.h b/include/asm-x86_64/processor.h
index 1952517..524390f 100644
--- a/include/asm-x86_64/processor.h
+++ b/include/asm-x86_64/processor.h
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
 
+static inline void native_load_rsp0(struct tss_struct *tss,
+				    struct thread_struct *thread)
+{
+	tss->rsp0 = thread->rsp0;
+}
+
 #define INIT_MMAP \
 { &init_mm, 0, 0, NULL, PAGE_SHARED, VM_READ | VM_WRITE | VM_EXEC, 1, NULL, NULL }
 
@@ -264,13 +262,64 @@ struct thread_struct {
 	set_fs(USER_DS);							 \
 } while(0) 
 
-#define get_debugreg(var, register)				\
-		__asm__("movq %%db" #register ", %0"		\
-			:"=r" (var))
-#define set_debugreg(value, register)			\
-		__asm__("movq %0,%%db" #register		\
-			: /* no output */			\
-			:"r" (value))
+static inline unsigned long native_get_debugreg(int regno)
+{
+	unsigned long val;
+
+	switch (regno) {
+	case 0:
+		asm("movq %%db0, %0" :"=r" (val)); break;
+	case 1:
+		asm("movq %%db1, %0" :"=r" (val)); break;
+	case 2:
+		asm("movq %%db2, %0" :"=r" (val)); break;
+	case 3:
+		asm("movq %%db3, %0" :"=r" (val)); break;
+	case 6:
+		asm("movq %%db6, %0" :"=r" (val)); break;
+	case 7:
+		asm("movq %%db7, %0" :"=r" (val)); break;
+	default:
+		val = 0; /* assign it to keep gcc quiet */
+		WARN_ON(1);
+	}
+	return val;
+}
+
+static inline void native_set_debugreg(unsigned long value, int regno)
+{
+	switch (regno) {
+	case 0:
+		asm("movq %0,%%db0"	: /* no output */ :"r" (value));
+		break;
+	case 1:
+		asm("movq %0,%%db1"	: /* no output */ :"r" (value));
+		break;
+	case 2:
+		asm("movq %0,%%db2"	: /* no output */ :"r" (value));
+		break;
+	case 3:
+		asm("movq %0,%%db3"	: /* no output */ :"r" (value));
+		break;
+	case 6:
+		asm("movq %0,%%db6"	: /* no output */ :"r" (value));
+		break;
+	case 7:
+		asm("movq %0,%%db7"	: /* no output */ :"r" (value));
+		break;
+	default:
+		BUG();
+	}
+}
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_enabled()	0
+#define load_rsp0 		native_load_rsp0
+#define set_debugreg(val, reg)	native_set_debugreg(reg, val)
+#define get_debugreg(var, reg)	(var) = native_get_debugreg(reg)
+#endif
 
 struct task_struct;
 struct mm_struct;
-- 
1.4.4.2

