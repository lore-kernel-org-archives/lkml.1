Return-Path: <linux-kernel-owner+w=401wt.eu-S934850AbYEBNDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934850AbYEBNDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759714AbYEBNC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:02:57 -0400
Received: from www.tglx.de ([62.245.132.106]:55532 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759378AbYEBNC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:02:56 -0400
Date: Fri, 2 May 2008 15:02:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] generic irq updates
Message-ID: <alpine.LFD.1.10.0805021502170.6003@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull gerneric irq updates from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-genirq.git master

Thanks,

	tglx

---

Thomas Gleixner (1):
      genirq: reenable a nobody cared disabled irq when a new driver arrives

 include/linux/irq.h   |    1 +
 kernel/irq/manage.c   |   49 ++++++++++++++++++++++++++++++++-----------------
 kernel/irq/spurious.c |    4 ++--
 3 files changed, 35 insertions(+), 19 deletions(-)
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1883a85..552e0ec 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -61,6 +61,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
+#define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 46e4ad1..46d6611 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -150,6 +150,26 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
+static void __enable_irq(struct irq_desc *desc, unsigned int irq)
+{
+	switch (desc->depth) {
+	case 0:
+		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN_ON(1);
+		break;
+	case 1: {
+		unsigned int status = desc->status & ~IRQ_DISABLED;
+
+		/* Prevent probing on this irq: */
+		desc->status = status | IRQ_NOPROBE;
+		check_irq_resend(desc, irq);
+		/* fall-through */
+	}
+	default:
+		desc->depth--;
+	}
+}
+
 /**
  *	enable_irq - enable handling of an irq
  *	@irq: Interrupt to enable
@@ -169,22 +189,7 @@ void enable_irq(unsigned int irq)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	switch (desc->depth) {
-	case 0:
-		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
-		WARN_ON(1);
-		break;
-	case 1: {
-		unsigned int status = desc->status & ~IRQ_DISABLED;
-
-		/* Prevent probing on this irq: */
-		desc->status = status | IRQ_NOPROBE;
-		check_irq_resend(desc, irq);
-		/* fall-through */
-	}
-	default:
-		desc->depth--;
-	}
+	__enable_irq(desc, irq);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL(enable_irq);
@@ -365,7 +370,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 			compat_irq_chip_set_default_handler(desc);
 
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
-				  IRQ_INPROGRESS);
+				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
@@ -381,6 +386,16 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
+
+	/*
+	 * Check whether we disabled the irq via the spurious handler
+	 * before. Reenable it and give it another chance.
+	 */
+	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
+		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+		__enable_irq(desc, irq);
+	}
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	new->irq = irq;
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 088dabb..c66d3f1 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -209,8 +209,8 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		 * Now kill the IRQ
 		 */
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->status |= IRQ_DISABLED;
-		desc->depth = 1;
+		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
+		desc->depth++;
 		desc->chip->disable(irq);
 	}
 	desc->irqs_unhandled = 0;
