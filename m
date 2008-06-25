Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYFYEtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYFYEtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYFYEhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:51 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37498 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756108AbYFYEhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 35 of 36] x86_64/paravirt: add adjust_exception_frame
X-Mercurial-Node: c2da9984f23c61654250d8e00fb75e3a4e5d8136
Message-Id: <c2da9984f23c61654250.1214367571@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:31 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit Xen pushes a couple of extra words onto an exception frame.
Add a hook to deal with them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/asm-offsets_64.c |    1 +
 arch/x86/kernel/entry_64.S       |    2 ++
 arch/x86/kernel/paravirt.c       |    3 +++
 arch/x86/xen/enlighten.c         |    3 +++
 include/asm-x86/paravirt.h       |    9 +++++++++
 include/asm-x86/processor.h      |    2 ++
 6 files changed, 20 insertions(+)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -61,6 +61,7 @@
 	OFFSET(PARAVIRT_PATCH_pv_irq_ops, paravirt_patch_template, pv_irq_ops);
 	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
+	OFFSET(PV_IRQ_adjust_exception_frame, pv_irq_ops, adjust_exception_frame);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
 	OFFSET(PV_CPU_nmi_return, pv_cpu_ops, nmi_return);
 	OFFSET(PV_CPU_usergs_sysret32, pv_cpu_ops, usergs_sysret32);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -864,6 +864,7 @@
  */ 		
 	.macro zeroentry sym
 	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $0	/* push error code/oldrax */ 
 	CFI_ADJUST_CFA_OFFSET 8
 	pushq %rax	/* push real oldrax to the rdi slot */ 
@@ -876,6 +877,7 @@
 
 	.macro errorentry sym
 	XCPT_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq %rax
 	CFI_ADJUST_CFA_OFFSET 8
 	CFI_REL_OFFSET rax,0
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -298,6 +298,9 @@
 	.irq_enable = native_irq_enable,
 	.safe_halt = native_safe_halt,
 	.halt = native_halt,
+#ifdef CONFIG_X86_64
+	.adjust_exception_frame = paravirt_nop,
+#endif
 };
 
 struct pv_cpu_ops pv_cpu_ops = {
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1121,6 +1121,9 @@
 	.irq_enable = xen_irq_enable,
 	.safe_halt = xen_safe_halt,
 	.halt = xen_halt,
+#ifdef CONFIG_X86_64
+	.adjust_exception_frame = paravirt_nop,
+#endif
 };
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -192,6 +192,10 @@
 	void (*irq_enable)(void);
 	void (*safe_halt)(void);
 	void (*halt)(void);
+
+#ifdef CONFIG_X86_64
+	void (*adjust_exception_frame)(void);
+#endif
 };
 
 struct pv_apic_ops {
@@ -1551,6 +1555,11 @@
 	movq %rax, %rcx;				\
 	xorq %rax, %rax;
 
+#define PARAVIRT_ADJUST_EXCEPTION_FRAME					\
+	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_adjust_exception_frame), \
+		  CLBR_NONE,						\
+		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_adjust_exception_frame))
+
 #define USERGS_SYSRET64							\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usergs_sysret64),	\
 		  CLBR_NONE,						\
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -542,6 +542,8 @@
 
 #define set_iopl_mask native_set_iopl_mask
 #define SWAPGS	swapgs
+
+#define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
 #endif /* CONFIG_PARAVIRT */
 
 /*


