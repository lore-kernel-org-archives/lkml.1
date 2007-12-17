Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbXLRBks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbXLRBks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXLRBh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:37:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796AbXLRBh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:37:26 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/21] [PATCH] provide x86_64 with a load_sp0 function.
Date: Mon, 17 Dec 2007 20:52:33 -0200
Message-Id: <11979320163651-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320114180-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirt guests need to inform the underlying hypervisor whenever the sp0
tss field changes. i386 already has such a function, and we use it for
x86_64 too. There's an unnecessary (for 64-bit) msr handling part in the original
version, and it is placed around an ifdef. Making no more sense in
processor_32.h, it is moved to the common header

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/process_64.c   |    2 +-
 arch/x86/kernel/smpboot_64.c   |    2 +-
 include/asm-x86/processor.h    |   22 +++++++++++++++++++++-
 include/asm-x86/processor_32.h |   20 --------------------
 4 files changed, 23 insertions(+), 23 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-x86/arch/x86/kernel/process_64.c
@@ -628,7 +628,7 @@ __switch_to(struct task_struct *prev_p, 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
 	 */
-	tss->x86_tss.sp0 = next->sp0;
+	load_sp0(tss, next);
 
 	/* 
 	 * Switch DS and ES.
Index: linux-2.6-x86/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6-x86/arch/x86/kernel/smpboot_64.c
@@ -614,7 +614,7 @@ do_rest:
 	start_rip = setup_trampoline();
 
 	init_rsp = c_idle.idle->thread.sp;
-	per_cpu(init_tss, cpu).x86_tss.sp0 = init_rsp;
+	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
 	initial_code = start_secondary;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -189,8 +189,22 @@ static inline void native_set_iopl_mask(
 #endif
 }
 
+static inline void native_load_sp0(struct tss_struct *tss,
+				   struct thread_struct *thread)
+{
+	tss->x86_tss.sp0 = thread->sp0;
+#ifdef CONFIG_X86_32
+	/* Only happens when SEP is enabled, no need to test "SEP"arately */
+	if (unlikely(tss->x86_tss.ss1 != thread->sysenter_cs)) {
+		tss->x86_tss.ss1 = thread->sysenter_cs;
+		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
+	}
+#endif
+}
 
-#ifndef CONFIG_PARAVIRT
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
 #define __cpuid native_cpuid
 #define paravirt_enabled() 0
 
@@ -202,6 +216,12 @@ static inline void native_set_iopl_mask(
 #define set_debugreg(value, register)				\
 	native_set_debugreg(register, value)
 
+static inline void load_sp0(struct tss_struct *tss,
+			    struct thread_struct *thread)
+{
+	native_load_sp0(tss, thread);
+}
+
 #define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -278,26 +278,6 @@ extern unsigned long thread_saved_pc(str
 
 #define KSTK_ESP(task) (task_pt_regs(task)->sp)
 
-static inline void native_load_sp0(struct tss_struct *tss, struct thread_struct *thread)
-{
-	tss->x86_tss.sp0 = thread->sp0;
-	/* This can only happen when SEP is enabled, no need to test "SEP"arately */
-	if (unlikely(tss->x86_tss.ss1 != thread->sysenter_cs)) {
-		tss->x86_tss.ss1 = thread->sysenter_cs;
-		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
-	}
-}
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-
-static inline void load_sp0(struct tss_struct *tss, struct thread_struct *thread)
-{
-	native_load_sp0(tss, thread);
-}
-#endif /* CONFIG_PARAVIRT */
-
 /* generic versions from gas */
 #define GENERIC_NOP1	".byte 0x90\n"
 #define GENERIC_NOP2    	".byte 0x89,0xf6\n"
