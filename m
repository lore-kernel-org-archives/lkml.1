Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZFTSr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZFTSr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbZFTSp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48058 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694AbZFTSp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 08/25] Blackfin: abstract irq14 lowering in do_irq
Date: Sat, 20 Jun 2009 14:44:31 -0400
Message-Id: <1245523488-26536-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the optional IRQ14 lowering code to further simplify the
asm_do_IRQ() function and keep the ifdef nest under control.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/irqchip.c |   43 +++++++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 7378440..4b5fd36 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -104,6 +104,29 @@ static void check_stack_overflow(int irq)
 static inline void check_stack_overflow(int irq) { }
 #endif
 
+#ifndef CONFIG_IPIPE
+static void maybe_lower_to_irq14(void)
+{
+	unsigned short pending, other_ints;
+
+	/*
+	 * If we're the only interrupt running (ignoring IRQ15 which
+	 * is for syscalls), lower our priority to IRQ14 so that
+	 * softirqs run at that level.  If there's another,
+	 * lower-level interrupt, irq_exit will defer softirqs to
+	 * that. If the interrupt pipeline is enabled, we are already
+	 * running at IRQ14 priority, so we don't need this code.
+	 */
+	CSYNC();
+	pending = bfin_read_IPEND() & ~0x8000;
+	other_ints = pending & (pending - 1);
+	if (other_ints == 0)
+		lower_to_irq14();
+}
+#else
+static inline void maybe_lower_to_irq14(void) { }
+#endif
+
 /*
  * do_IRQ handles all hardware IRQs.  Decoded IRQs should not
  * come via this function.  Instead, they should provide their
@@ -114,9 +137,6 @@ __attribute__((l1_text))
 #endif
 asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 {
-#ifndef CONFIG_IPIPE
-	unsigned short pending, other_ints;
-#endif
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
 	irq_enter();
@@ -132,21 +152,8 @@ asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 	else
 		generic_handle_irq(irq);
 
-#ifndef CONFIG_IPIPE
-	/*
-	 * If we're the only interrupt running (ignoring IRQ15 which
-	 * is for syscalls), lower our priority to IRQ14 so that
-	 * softirqs run at that level.  If there's another,
-	 * lower-level interrupt, irq_exit will defer softirqs to
-	 * that. If the interrupt pipeline is enabled, we are already
-	 * running at IRQ14 priority, so we don't need this code.
-	 */
-	CSYNC();
-	pending = bfin_read_IPEND() & ~0x8000;
-	other_ints = pending & (pending - 1);
-	if (other_ints == 0)
-		lower_to_irq14();
-#endif /* !CONFIG_IPIPE */
+	maybe_lower_to_irq14();
+
 	irq_exit();
 
 	set_irq_regs(old_regs);
-- 
1.6.3.1

