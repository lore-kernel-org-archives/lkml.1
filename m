Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbYFYEqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbYFYEqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYFYEhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:43 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37455 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755475AbYFYEhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 19 of 36] paravirt_ops: define PARA_INDIRECT for indirect asm
	calls
X-Mercurial-Node: 79981976b577491a53643209857aedbbcbbe99c3
Message-Id: <79981976b577491a5364.1214367555@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:15 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit it's best to use a %cs: prefix to access memory where the
other segments may not bet set up properly yet.  On 64-bit it's best
to use a rip-relative addressing mode.  Define PARA_INDIRECT() to
abstract this and generate the proper addressing mode in each case.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/paravirt.h |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1456,55 +1456,57 @@
 #define PV_RESTORE_REGS popq %rdx; popq %rcx; popq %rdi; popq %rax
 #define PARA_PATCH(struct, off)        ((PARAVIRT_PATCH_##struct + (off)) / 8)
 #define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .quad, 8)
+#define PARA_INDIRECT(addr)	*addr(%rip)
 #else
 #define PV_SAVE_REGS   pushl %eax; pushl %edi; pushl %ecx; pushl %edx
 #define PV_RESTORE_REGS popl %edx; popl %ecx; popl %edi; popl %eax
 #define PARA_PATCH(struct, off)        ((PARAVIRT_PATCH_##struct + (off)) / 4)
 #define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .long, 4)
+#define PARA_INDIRECT(addr)	*%cs:addr
 #endif
 
 #define INTERRUPT_RETURN						\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
-		  jmp *%cs:pv_cpu_ops+PV_CPU_iret)
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_iret))
 
 #define INTERRUPT_RETURN_NMI_SAFE					\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_nmi_return), CLBR_NONE,	\
-		  jmp *%cs:pv_cpu_ops+PV_CPU_nmi_return)
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_nmi_return))
 
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
-		  PV_SAVE_REGS;			\
-		  call *%cs:pv_irq_ops+PV_IRQ_irq_disable;		\
+		  PV_SAVE_REGS;						\
+		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_disable);	\
 		  PV_RESTORE_REGS;)			\
 
 #define ENABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_enable), clobbers,	\
-		  PV_SAVE_REGS;			\
-		  call *%cs:pv_irq_ops+PV_IRQ_irq_enable;		\
+		  PV_SAVE_REGS;						\
+		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_enable);	\
 		  PV_RESTORE_REGS;)
 
 #define ENABLE_INTERRUPTS_SYSCALL_RET					\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_syscall_ret),\
 		  CLBR_NONE,						\
-		  jmp *%cs:pv_cpu_ops+PV_CPU_irq_enable_syscall_ret)
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_irq_enable_syscall_ret))
 
 
 #ifdef CONFIG_X86_32
-#define GET_CR0_INTO_EAX			\
-	push %ecx; push %edx;			\
-	call *pv_cpu_ops+PV_CPU_read_cr0;	\
+#define GET_CR0_INTO_EAX				\
+	push %ecx; push %edx;				\
+	call PARA_INDIRECT(pv_cpu_ops+PV_CPU_read_cr0);	\
 	pop %edx; pop %ecx
 #else
 #define SWAPGS								\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
 		  PV_SAVE_REGS;						\
-		  call *pv_cpu_ops+PV_CPU_swapgs;			\
+		  call PARA_INDIRECT(pv_cpu_ops+PV_CPU_swapgs);		\
 		  PV_RESTORE_REGS					\
 		 )
 
-#define GET_CR2_INTO_RCX			\
-	call *pv_mmu_ops+PV_MMU_read_cr2;	\
-	movq %rax, %rcx;			\
+#define GET_CR2_INTO_RCX				\
+	call PARA_INDIRECT(pv_mmu_ops+PV_MMU_read_cr2);	\
+	movq %rax, %rcx;				\
 	xorq %rax, %rax;
 
 #endif


