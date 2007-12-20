Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbXLTUKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbXLTUKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbXLTUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:09:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbXLTUJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:09:27 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 06/15] adjust assembly macros to x86_64 as well.
Date: Thu, 20 Dec 2007 18:04:01 -0200
Message-Id: <11981812412879-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1198181224677-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjust the paravirt macros used in assembly code
to accomodate for x86_64 as well.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:25.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:07:27.000000000 -0800
@@ -1159,8 +1159,6 @@
 
 #else  /* __ASSEMBLY__ */
 
-#define PARA_PATCH(struct, off)	((PARAVIRT_PATCH_##struct + (off)) / 4)
-
 #define _PVSITE(ptype, clobbers, ops, word, algn)	\
 771:;						\
 	ops;					\
@@ -1175,8 +1173,14 @@
 
 
 #ifdef CONFIG_X86_64
+#define PV_SAVE_REGS   pushq %rax; pushq %rdi; pushq %rcx; pushq %rdx
+#define PV_RESTORE_REGS popq %rdx; popq %rcx; popq %rdi; popq %rax
+#define PARA_PATCH(struct, off)        ((PARAVIRT_PATCH_##struct + (off)) / 8)
 #define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .quad, 8)
 #else
+#define PV_SAVE_REGS   pushl %eax; pushl %edi; pushl %ecx; pushl %edx
+#define PV_RESTORE_REGS popl %edx; popl %ecx; popl %edi; popl %eax
+#define PARA_PATCH(struct, off)        ((PARAVIRT_PATCH_##struct + (off)) / 4)
 #define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .long, 4)
 #endif
 
@@ -1186,25 +1190,27 @@
 
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
-		  pushl %eax; pushl %ecx; pushl %edx;			\
+		  PV_SAVE_REGS;			\
 		  call *%cs:pv_irq_ops+PV_IRQ_irq_disable;		\
-		  popl %edx; popl %ecx; popl %eax)			\
+		  PV_RESTORE_REGS;)			\
 
 #define ENABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_enable), clobbers,	\
-		  pushl %eax; pushl %ecx; pushl %edx;			\
+		  PV_SAVE_REGS;			\
 		  call *%cs:pv_irq_ops+PV_IRQ_irq_enable;		\
-		  popl %edx; popl %ecx; popl %eax)
+		  PV_RESTORE_REGS;)
 
 #define ENABLE_INTERRUPTS_SYSCALL_RET					\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_syscall_ret),\
 		  CLBR_NONE,						\
 		  jmp *%cs:pv_cpu_ops+PV_CPU_irq_enable_syscall_ret)
 
+#ifdef CONFIG_X86_32
 #define GET_CR0_INTO_EAX			\
 	push %ecx; push %edx;			\
 	call *pv_cpu_ops+PV_CPU_read_cr0;	\
 	pop %edx; pop %ecx
+#endif
 
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_PARAVIRT */
