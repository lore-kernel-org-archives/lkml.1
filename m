Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbYBSKQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbYBSKQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYBSKP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:15:57 -0500
Received: from www.tglx.de ([62.245.132.106]:35081 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbYBSKP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:15:56 -0500
Date: Tue, 19 Feb 2008 11:15:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq fixes for .25
Message-ID: <alpine.LFD.1.00.0802191106420.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull genirq fixes for .25 from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-genirq.git

  - fix spurious irq after free_irq() bug
  - replace open coded jiffies comparison

Thanks,

	tglx

---
S.Caglar Onur (1):
      genirq: spurious.c: use time_* macros

Thomas Gleixner (1):
      genirq: do not leave interupts enabled on free_irq

 kernel/irq/chip.c     |   20 +++++++++++++++++++-
 kernel/irq/spurious.c |    3 ++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cc54c62..fdb3fbe 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -246,6 +246,17 @@ static unsigned int default_startup(unsigned int irq)
 }
 
 /*
+ * default shutdown function
+ */
+static void default_shutdown(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	desc->chip->mask(irq);
+	desc->status |= IRQ_MASKED;
+}
+
+/*
  * Fixup enable/disable function pointers
  */
 void irq_chip_set_defaults(struct irq_chip *chip)
@@ -256,8 +267,15 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->disable = default_disable;
 	if (!chip->startup)
 		chip->startup = default_startup;
+	/*
+	 * We use chip->disable, when the user provided its own. When
+	 * we have default_disable set for chip->disable, then we need
+	 * to use default_shutdown, otherwise the irq line is not
+	 * disabled on free_irq():
+	 */
 	if (!chip->shutdown)
-		chip->shutdown = chip->disable;
+		chip->shutdown = chip->disable != default_disable ?
+			chip->disable : default_shutdown;
 	if (!chip->name)
 		chip->name = chip->typename;
 	if (!chip->end)
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index a6b2bc8..088dabb 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -6,6 +6,7 @@
  * This file contains spurious interrupt handling.
  */
 
+#include <linux/jiffies.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -179,7 +180,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		 * otherwise the couter becomes a doomsday timer for otherwise
 		 * working systems
 		 */
-		if (jiffies - desc->last_unhandled > HZ/10)
+		if (time_after(jiffies, desc->last_unhandled + HZ/10))
 			desc->irqs_unhandled = 1;
 		else
 			desc->irqs_unhandled++;
