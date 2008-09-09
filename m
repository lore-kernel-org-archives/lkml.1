Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYIIUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYIIUzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYIIUzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:55:06 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:12286 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYIIUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:55:05 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 1/24] i386: remove kprobes' restore_interrupts in favour of conditional_sti
Date: Tue,  9 Sep 2008 21:55:55 +0200
Message-Id: <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 09 Sep 2008 21:55:30 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

x86_64 uses a helper function conditional_sti in traps_64.c which
is equal to restore_interrupts in kprobes.h. The only user of
restore_interrupts is in traps_32.c. Introduce conditional_sti
for i386 and remove restore_interrupts.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    8 +++++++-
 include/asm-x86/kprobes.h  |    9 ---------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 03df8e4..c8096f7 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -84,6 +84,12 @@ static unsigned int code_bytes = 64;
 static int ignore_nmis;
 static int die_counter;
 
+static inline void conditional_sti(struct pt_regs *regs)
+{
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
+}
+
 void printk_address(unsigned long address, int reliable)
 {
 #ifdef CONFIG_KALLSYMS
@@ -859,7 +865,7 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	 * This is an interrupt gate, because kprobes wants interrupts
 	 * disabled. Normal trap handlers don't.
 	 */
-	restore_interrupts(regs);
+	conditional_sti(regs);
 
 	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
 }
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index 54980b0..93a7f49 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -82,15 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe;
 };
 
-/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
- * if necessary, before executing the original int3/1 (trap) handler.
- */
-static inline void restore_interrupts(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
-- 
1.5.4.3

