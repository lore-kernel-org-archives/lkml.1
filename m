Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbZFQWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbZFQWgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762106AbZFQWgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:36:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55382 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762092AbZFQWg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:36:29 -0400
X-Sasl-enc: wbCfdN7C/B9Hyio2uB4S45VINnve1G0vB0h+o3SmJ1pD 1245278190
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Stas Sergeev <stsp@aknet.ru>, Tejun Heo <tj@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 2/3] i386: fix/simplify espfix stack switching, move it into assembly
Date: Thu, 18 Jun 2009 00:35:58 +0200
Message-Id: <1245278159-6840-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1245278159-6840-1-git-send-email-heukelum@fastmail.fm>
References: <1245278159-6840-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The espfix code triggers if we have a protected mode userspace
application with a 16-bit stack. On returning to userspace, with iret,
the CPU doesn't restore the high word of the stack pointer. This is an
"official" bug, and the work-around used in the kernel is to temporarily
switch to a 32-bit stack segment/pointer pair where the high word of the
pointer is equal to the high word of the userspace stackpointer.

The current implementation uses THREAD_SIZE to determine the cut-off,
but there is no good reason not to use the more natural 64kb... However,
implementing this by simply substituting THREAD_SIZE with 65536 in
patch_espfix_desc crashed the test application. patch_espfix_desc tries
to do what is described above, but gets it subtly wrong if the userspace
stack pointer is just below a multiple of THREAD_SIZE: an overflow
occurs to bit 13... With a bit of luck, when the kernelspace
stackpointer is just below a 64kb-boundary, the overflow then ripples
trough to bit 16 and userspace will see its stack pointer changed by
65536.

This patch moves all espfix code into entry_32.S. Selecting a 16-bit
cut-off simplifies the code. The game with changing the limit dynamically
is removed too. It complicates matters and I see no value in it. Changing
only the top 16-bit word of ESP is one instruction and it also implies
that only two bytes of the ESPFIX GDT entry need to be changed and this
can be implemented in just a handful simple to understand instructions.
As a side effect, the operation to compute the original ESP from the
ESPFIX ESP and the GDT entry simplifies a bit too, and the remaining
three instructions have been expanded inline in entry_32.S.

impact: can now reliably run userspace with ESP=xxxxfffc on 16-bit
stack segment

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Stas Sergeev <stsp@aknet.ru>

---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/entry_32.S   |   49 +++++++++++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9fa3388..f1961c0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -108,7 +108,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	/* data */
 	[GDT_ENTRY_APMBIOS_BASE+2]	= { { { 0x0000ffff, 0x00409200 } } },
 
-	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x00000000, 0x00c09200 } } },
+	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_PERCPU]		= { { { 0x0000ffff, 0x00cf9200 } } },
 	GDT_STACK_CANARY_INIT
 #endif
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index d7d1c7d..848f73f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -588,24 +588,34 @@ ldt_ss:
 	jne restore_nocheck
 #endif
 
-	/* If returning to userspace with 16bit stack,
-	 * try to fix the higher word of ESP, as the CPU
-	 * won't restore it.
-	 * This is an "official" bug of all the x86-compatible
-	 * CPUs, which we can try to work around to make
-	 * dosemu and wine happy. */
-	movl PT_OLDESP(%esp), %eax
-	movl %esp, %edx
-	call patch_espfix_desc
+/*
+ * Setup and switch to ESPFIX stack
+ *
+ * We're returning to userspace with a 16 bit stack. The CPU will not
+ * restore the high word of ESP for us on executing iret... This is an
+ * "official" bug of all the x86-compatible CPUs, which we can work
+ * around to make dosemu and wine happy. We do this by preloading the
+ * high word of ESP with the high word of the userspace ESP while
+ * compensating for the offset by changing to the ESPFIX segment with
+ * a base address that matches for the difference.
+ */
+	mov %esp, %edx			/* load kernel esp */
+	mov PT_OLDESP(%esp), %eax	/* load userspace esp */
+	mov %dx, %ax			/* eax: new kernel esp */
+	sub %eax, %edx			/* offset (low word is 0) */
+	PER_CPU(gdt_page, %ebx)
+	shr $16, %edx
+	mov %dl, GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx) /* bits 16..23 */
+	mov %dh, GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx) /* bits 24..31 */
 	pushl $__ESPFIX_SS
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl %eax
+	push %eax			/* new kernel esp */
 	CFI_ADJUST_CFA_OFFSET 4
 	/* Disable interrupts, but do not irqtrace this section: we
 	 * will soon execute iret and the tracer was already set to
 	 * the irqstate after the iret */
 	DISABLE_INTERRUPTS(CLBR_EAX)
-	lss (%esp), %esp
+	lss (%esp), %esp		/* switch to espfix segment */
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
 	CFI_ENDPROC
@@ -718,15 +728,24 @@ PTREGSCALL(vm86)
 PTREGSCALL(vm86old)
 
 .macro FIXUP_ESPFIX_STACK
-	/* since we are on a wrong stack, we cant make it a C code :( */
+/*
+ * Switch back for ESPFIX stack to the normal zerobased stack
+ *
+ * We can't call C functions using the ESPFIX stack. This code reads
+ * the high word of the segment base from the GDT and swiches to the
+ * normal stack and adjusts ESP with the matching offset.
+ */
+	/* fixup the stack */
 	PER_CPU(gdt_page, %ebx)
-	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
-	addl %esp, %eax
+	mov GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx), %al /* bits 16..23 */
+	mov GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx), %ah /* bits 24..31 */
+	shl $16, %eax
+	addl %esp, %eax			/* the adjusted stack pointer */
 	pushl $__KERNEL_DS
 	CFI_ADJUST_CFA_OFFSET 4
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
-	lss (%esp), %esp
+	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
 .endm
 .macro UNWIND_ESPFIX_STACK
-- 
1.5.4.3

