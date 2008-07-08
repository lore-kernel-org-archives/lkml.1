Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYGHXU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYGHXU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYGHXOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:50 -0400
Received: from gw.goop.org ([64.81.55.164]:51204 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbYGHXOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 27 of 55] xen64: add hypervisor callbacks for events, etc
X-Mercurial-Node: 43817046e3f319aeec964d22144314e7a89a0c8f
Message-Id: <43817046e3f319aeec96.1215554809@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_64.S |   98 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1312,3 +1312,101 @@
 	sysret
 	CFI_ENDPROC
 ENDPROC(ignore_sysret)
+
+#ifdef CONFIG_XEN
+ENTRY(xen_hypervisor_callback)
+	zeroentry xen_do_hypervisor_callback
+END(xen_hypervisor_callback)
+
+/*
+# A note on the "critical region" in our callback handler.
+# We want to avoid stacking callback handlers due to events occurring
+# during handling of the last event. To do this, we keep events disabled
+# until we've done all processing. HOWEVER, we must enable events before
+# popping the stack frame (can't be done atomically) and so it would still
+# be possible to get enough handler activations to overflow the stack.
+# Although unlikely, bugs of that kind are hard to track down, so we'd
+# like to avoid the possibility.
+# So, on entry to the handler we detect whether we interrupted an
+# existing activation in its critical region -- if so, we pop the current
+# activation and restart the handler using the previous one.
+*/
+ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
+	CFI_STARTPROC
+/* Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
+   see the correct pointer to the pt_regs */
+	movq %rdi, %rsp            # we don't return, adjust the stack frame
+	CFI_ENDPROC
+	CFI_DEFAULT_STACK
+11:	incl %gs:pda_irqcount
+	movq %rsp,%rbp
+	CFI_DEF_CFA_REGISTER rbp
+	cmovzq %gs:pda_irqstackptr,%rsp
+	pushq %rbp			# backlink for old unwinder
+	call xen_evtchn_do_upcall
+	popq %rsp
+	CFI_DEF_CFA_REGISTER rsp
+	decl %gs:pda_irqcount
+	jmp  error_exit
+	CFI_ENDPROC
+END(do_hypervisor_callback)
+
+/*
+# Hypervisor uses this for application faults while it executes.
+# We get here for two reasons:
+#  1. Fault while reloading DS, ES, FS or GS
+#  2. Fault while executing IRET
+# Category 1 we do not need to fix up as Xen has already reloaded all segment
+# registers that could be reloaded and zeroed the others.
+# Category 2 we fix up by killing the current process. We cannot use the
+# normal Linux return path in this case because if we use the IRET hypercall
+# to pop the stack frame we end up in an infinite loop of failsafe callbacks.
+# We distinguish between categories by comparing each saved segment register
+# with its current contents: any discrepancy means we in category 1.
+*/
+ENTRY(xen_failsafe_callback)
+#if 1
+	ud2a
+#else
+	_frame (RIP-0x30)
+	CFI_REL_OFFSET rcx, 0
+	CFI_REL_OFFSET r11, 8
+	movw %ds,%cx
+	cmpw %cx,0x10(%rsp)
+	CFI_REMEMBER_STATE
+	jne 1f
+	movw %es,%cx
+	cmpw %cx,0x18(%rsp)
+	jne 1f
+	movw %fs,%cx
+	cmpw %cx,0x20(%rsp)
+	jne 1f
+	movw %gs,%cx
+	cmpw %cx,0x28(%rsp)
+	jne 1f
+	/* All segments match their saved values => Category 2 (Bad IRET). */
+	movq (%rsp),%rcx
+	CFI_RESTORE rcx
+	movq 8(%rsp),%r11
+	CFI_RESTORE r11
+	addq $0x30,%rsp
+	CFI_ADJUST_CFA_OFFSET -0x30
+	movq $11,%rdi	/* SIGSEGV */
+	jmp do_exit
+	CFI_RESTORE_STATE
+1:	/* Segment mismatch => Category 1 (Bad segment). Retry the IRET. */
+	movq (%rsp),%rcx
+	CFI_RESTORE rcx
+	movq 8(%rsp),%r11
+	CFI_RESTORE r11
+	addq $0x30,%rsp
+	CFI_ADJUST_CFA_OFFSET -0x30
+	pushq $0
+	CFI_ADJUST_CFA_OFFSET 8
+	SAVE_ALL
+	jmp error_exit
+	CFI_ENDPROC
+#endif
+END(xen_failsafe_callback)
+
+#endif /* CONFIG_XEN */


