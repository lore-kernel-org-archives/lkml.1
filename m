Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZFTSrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZFTSrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZFTSpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48043 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656AbZFTSpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 07/25] Blackfin: simplify irq stack overflow checking
Date: Sat, 20 Jun 2009 14:44:30 -0400
Message-Id: <1245523488-26536-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take a page from x86 and abstract the stack checking out of the
asm_do_IRQ() function so that the result is easier to digest.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/irqchip.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 8abb642..7378440 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -88,6 +88,22 @@ int show_interrupts(struct seq_file *p, void *v)
 }
 #endif
 
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+static void check_stack_overflow(int irq)
+{
+	/* Debugging check for stack overflow: is there less than STACK_WARN free? */
+	long sp = __get_SP() & (THREAD_SIZE - 1);
+
+	if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
+		dump_stack();
+		pr_emerg("irq%i: possible stack overflow only %ld bytes free\n",
+			irq, sp - sizeof(struct thread_info));
+	}
+}
+#else
+static inline void check_stack_overflow(int irq) { }
+#endif
+
 /*
  * do_IRQ handles all hardware IRQs.  Decoded IRQs should not
  * come via this function.  Instead, they should provide their
@@ -105,21 +121,7 @@ asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 
 	irq_enter();
 
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
-	/* Debugging check for stack overflow: is there less than STACK_WARN free? */
-	{
-		long sp;
-
-		sp = __get_SP() & (THREAD_SIZE-1);
-
-		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
-			dump_stack();
-			printk(KERN_EMERG "%s: possible stack overflow while handling irq %i "
-					" only %ld bytes free\n",
-				__func__, irq, sp - sizeof(struct thread_info));
-		}
-	}
-#endif
+	check_stack_overflow(irq);
 
 	/*
 	 * Some hardware gives randomly wrong interrupts.  Rather
-- 
1.6.3.1

