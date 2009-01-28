Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbZA1WnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZA1WnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZA1Wmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:42:38 -0500
Received: from gw.goop.org ([64.81.55.164]:52552 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751712AbZA1Wmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:42:37 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 7] x86/paravirt: selectively save/restore regs around
	pvops calls
X-Mercurial-Node: 5849eb6475c1bbe5a6ca02815e622e538f6cec83
Message-Id: <5849eb6475c1bbe5a6ca.1233182104@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
References: <patchbomb.1233182100@abulafia.goop.org>
Date: Wed, 28 Jan 2009 14:35:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each asm paravirt-ops call says what registers are available for
clobbering.  This patch makes use of this to selectively save/restore
registers around each pvops call.  In many cases this significantly
shrinks code size.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |  100 +++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -12,19 +12,29 @@
 #define CLBR_EAX  (1 << 0)
 #define CLBR_ECX  (1 << 1)
 #define CLBR_EDX  (1 << 2)
+#define CLBR_EDI  (1 << 3)
 
-#ifdef CONFIG_X86_64
-#define CLBR_RSI  (1 << 3)
-#define CLBR_RDI  (1 << 4)
+#ifdef CONFIG_X86_32
+/* CLBR_ANY should match all regs platform has. For i386, that's just it */
+#define CLBR_ANY  ((1 << 4) - 1)
+#else
+#define CLBR_RAX  CLBR_EAX
+#define CLBR_RCX  CLBR_ECX
+#define CLBR_RDX  CLBR_EDX
+#define CLBR_RDI  CLBR_EDI
+#define CLBR_RSI  (1 << 4)
 #define CLBR_R8   (1 << 5)
 #define CLBR_R9   (1 << 6)
 #define CLBR_R10  (1 << 7)
 #define CLBR_R11  (1 << 8)
 #define CLBR_ANY  ((1 << 9) - 1)
+
+#define CLBR_ARG_REGS	(CLBR_RDI | CLBR_RSI | CLBR_RDX | \
+			 CLBR_RCX | CLBR_R8 | CLBR_R9)
+#define CLBR_RET_REG	(CLBR_RAX | CLBR_RDX)
+#define CLBR_SCRATCH	(CLBR_R10 | CLBR_R11)
+
 #include <asm/desc_defs.h>
-#else
-/* CLBR_ANY should match all regs platform has. For i386, that's just it */
-#define CLBR_ANY  ((1 << 3) - 1)
 #endif /* X86_64 */
 
 #ifndef __ASSEMBLY__
@@ -1528,33 +1538,49 @@
 	.popsection
 
 
+#define COND_PUSH(set, mask, reg)			\
+	.if ((~set) & mask); push %reg; .endif
+#define COND_POP(set, mask, reg)			\
+	.if ((~set) & mask); pop %reg; .endif
+
 #ifdef CONFIG_X86_64
-#define PV_SAVE_REGS				\
-	push %rax;				\
-	push %rcx;				\
-	push %rdx;				\
-	push %rsi;				\
-	push %rdi;				\
-	push %r8;				\
-	push %r9;				\
-	push %r10;				\
-	push %r11
-#define PV_RESTORE_REGS				\
-	pop %r11;				\
-	pop %r10;				\
-	pop %r9;				\
-	pop %r8;				\
-	pop %rdi;				\
-	pop %rsi;				\
-	pop %rdx;				\
-	pop %rcx;				\
-	pop %rax
+
+#define PV_SAVE_REGS(set)			\
+	COND_PUSH(set, CLBR_RAX, rax);		\
+	COND_PUSH(set, CLBR_RCX, rcx);		\
+	COND_PUSH(set, CLBR_RDX, rdx);		\
+	COND_PUSH(set, CLBR_RSI, rsi);		\
+	COND_PUSH(set, CLBR_RDI, rdi);		\
+	COND_PUSH(set, CLBR_R8, r8);		\
+	COND_PUSH(set, CLBR_R9, r9);		\
+	COND_PUSH(set, CLBR_R10, r10);		\
+	COND_PUSH(set, CLBR_R11, r11)
+#define PV_RESTORE_REGS(set)			\
+	COND_POP(set, CLBR_R11, r11);		\
+	COND_POP(set, CLBR_R10, r10);		\
+	COND_POP(set, CLBR_R9, r9);		\
+	COND_POP(set, CLBR_R8, r8);		\
+	COND_POP(set, CLBR_RDI, rdi);		\
+	COND_POP(set, CLBR_RSI, rsi);		\
+	COND_POP(set, CLBR_RDX, rdx);		\
+	COND_POP(set, CLBR_RCX, rcx);		\
+	COND_POP(set, CLBR_RAX, rax)
+
 #define PARA_PATCH(struct, off)        ((PARAVIRT_PATCH_##struct + (off)) / 8)
 #define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .quad, 8)
 #define PARA_INDIRECT(addr)	*addr(%rip)
 #else
-#define PV_SAVE_REGS   pushl %eax; pushl %edi; pushl %ecx; pushl %edx
-#define PV_RESTORE_REGS popl %edx; popl %ecx; popl %edi; popl %eax
+#define PV_SAVE_REGS(set)			\
+	COND_PUSH(set, CLBR_EAX, eax);		\
+	COND_PUSH(set, CLBR_EDI, edi);		\
+	COND_PUSH(set, CLBR_ECX, ecx);		\
+	COND_PUSH(set, CLBR_EDX, edx)
+#define PV_RESTORE_REGS(set)			\
+	COND_POP(set, CLBR_EDX, edx);		\
+	COND_POP(set, CLBR_ECX, ecx);		\
+	COND_POP(set, CLBR_EDI, edi);		\
+	COND_POP(set, CLBR_EAX, eax)
+
 #define PARA_PATCH(struct, off)        ((PARAVIRT_PATCH_##struct + (off)) / 4)
 #define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .long, 4)
 #define PARA_INDIRECT(addr)	*%cs:addr
@@ -1566,15 +1592,15 @@
 
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
-		  PV_SAVE_REGS;						\
+		  PV_SAVE_REGS(clobbers);				\
 		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_disable);	\
-		  PV_RESTORE_REGS;)			\
+		  PV_RESTORE_REGS(clobbers);)
 
 #define ENABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_enable), clobbers,	\
-		  PV_SAVE_REGS;						\
+		  PV_SAVE_REGS(clobbers);				\
 		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_enable);	\
-		  PV_RESTORE_REGS;)
+		  PV_RESTORE_REGS(clobbers);)
 
 #define USERGS_SYSRET32							\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usergs_sysret32),	\
@@ -1604,11 +1630,15 @@
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
 		  swapgs)
 
+/*
+ * Note: swapgs is very special, and in practise is either going to be
+ * implemented with a single "swapgs" instruction or something very
+ * special.  Either way, we don't need to save any registers for
+ * it.
+ */
 #define SWAPGS								\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
-		  PV_SAVE_REGS;						\
-		  call PARA_INDIRECT(pv_cpu_ops+PV_CPU_swapgs);		\
-		  PV_RESTORE_REGS					\
+		  call PARA_INDIRECT(pv_cpu_ops+PV_CPU_swapgs)		\
 		 )
 
 #define GET_CR2_INTO_RCX				\


