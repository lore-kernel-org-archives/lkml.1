Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXLTULL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXLTULL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbXLTUKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:10:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbXLTUKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:10:34 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 07/15] change irq functions to accomodate x86_64
Date: Thu, 20 Dec 2007 18:04:02 -0200
Message-Id: <11981812771615-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981812412879-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the irq handling function definitions
in paravirt.h (like raw_local_irq_disable) to accomodate for x86_64.
The differences are in the calling convention.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |   43 ++++++++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 13 deletions(-)

Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:27.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:07:28.000000000 -0800
@@ -1085,52 +1085,68 @@
 extern struct paravirt_patch_site __parainstructions[],
 	__parainstructions_end[];
 
+#ifdef CONFIG_X86_32
+#define PV_SAVE_REGS "pushl %%ecx; pushl %%edx;"
+#define PV_RESTORE_REGS "popl %%edx; popl %%ecx"
+#define PV_FLAGS_ARG "0"
+#define PV_EXTRA_CLOBBERS
+#define PV_VEXTRA_CLOBBERS
+#else
+/* We save some registers, but all of them, that's too much. We clobber all
+ * caller saved registers but the argument parameter */
+#define PV_SAVE_REGS "pushq %%rdi;"
+#define PV_RESTORE_REGS "popq %%rdi;"
+#define PV_EXTRA_CLOBBERS EXTRA_CLOBBERS, "rcx" , "rdx"
+#define PV_VEXTRA_CLOBBERS EXTRA_CLOBBERS, "rdi", "rcx" , "rdx"
+#define PV_FLAGS_ARG "D"
+#endif
+
 static inline unsigned long __raw_local_save_flags(void)
 {
 	unsigned long f;
 
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     : "=a"(f)
 		     : paravirt_type(pv_irq_ops.save_fl),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
+		     : "memory", "cc" PV_VEXTRA_CLOBBERS);
 	return f;
 }
 
 static inline void raw_local_irq_restore(unsigned long f)
 {
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     : "=a"(f)
-		     : "0"(f),
+		     : PV_FLAGS_ARG(f),
 		       paravirt_type(pv_irq_ops.restore_fl),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
+		     : "memory", "cc" PV_EXTRA_CLOBBERS);
 }
 
 static inline void raw_local_irq_disable(void)
 {
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     :
 		     : paravirt_type(pv_irq_ops.irq_disable),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+		     : "memory", "eax", "cc" PV_EXTRA_CLOBBERS);
 }
 
 static inline void raw_local_irq_enable(void)
 {
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     :
 		     : paravirt_type(pv_irq_ops.irq_enable),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+		     : "memory", "eax", "cc" PV_EXTRA_CLOBBERS);
 }
 
 static inline unsigned long __raw_local_irq_save(void)
@@ -1205,6 +1221,7 @@
 		  CLBR_NONE,						\
 		  jmp *%cs:pv_cpu_ops+PV_CPU_irq_enable_syscall_ret)
 
+
 #ifdef CONFIG_X86_32
 #define GET_CR0_INTO_EAX			\
 	push %ecx; push %edx;			\
