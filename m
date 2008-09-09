Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYIJDCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYIJDCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYIJDCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:02:11 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:19325 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYIJDCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:02:10 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 8/24] i386: convert hardware exception 7 to an interrupt gate
Date: Tue,  9 Sep 2008 21:56:02 +0200
Message-Id: <1220990178-29773-9-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-8-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-7-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-8-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 05:01:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Handle no coprocessor exception with interrupt initially off.

device_not_available in entry_32.S calls either math_state_restore
or math_emulate. This patch adds an extra indirection to be
able to re-enable interrupts explicitly in traps_32.c

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |   15 ++-------------
 arch/x86/kernel/traps_32.c |   14 +++++++++++++-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 109792b..5a88585 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -760,20 +760,9 @@ ENTRY(device_not_available)
 	RING0_INT_FRAME
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	GET_CR0_INTO_EAX
-	testl $0x4, %eax		# EM (math emulation bit)
-	jne device_not_available_emulate
-	preempt_stop(CLBR_ANY)
-	call math_state_restore
-	jmp ret_from_exception
-device_not_available_emulate:
-	pushl $0			# temporary storage for ORIG_EIP
+	pushl $do_device_not_available
 	CFI_ADJUST_CFA_OFFSET 4
-	call math_emulate
-	addl $4, %esp
-	CFI_ADJUST_CFA_OFFSET -4
-	jmp ret_from_exception
+	jmp error_code
 	CFI_ENDPROC
 END(device_not_available)
 
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 5d8d057..3ddd71b 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -46,6 +46,7 @@
 #include <linux/edac.h>
 #endif
 
+#include <asm/processor-flags.h>
 #include <asm/arch_hooks.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
@@ -1234,6 +1235,17 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
+void __kprobes do_device_not_available(struct pt_regs *regs, long error)
+{
+	if (read_cr0() & X86_CR0_EM) {
+		conditional_sti(regs);
+		math_emulate(0);
+	} else {
+		math_state_restore(); /* interrupts still off */
+		conditional_sti(regs);
+	}
+}
+
 void __init trap_init(void)
 {
 	int i;
@@ -1253,7 +1265,7 @@ void __init trap_init(void)
 	set_system_intr_gate(4, &overflow); /* int4 can be called from all */
 	set_intr_gate(5, &bounds);
 	set_intr_gate(6, &invalid_op);
-	set_trap_gate(7, &device_not_available);
+	set_intr_gate(7, &device_not_available);
 	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
 	set_trap_gate(9, &coprocessor_segment_overrun);
 	set_trap_gate(10, &invalid_TSS);
-- 
1.5.4.3

