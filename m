Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZGCJI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZGCJI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZGCJIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:08:50 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:53873 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZGCJIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:08:49 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Bernhard Walle <bernhard.walle@gmx.de>
Subject: [PATCH 1/2] IRQ: fix performance regression on large IA64 systems
Date: Fri,  3 Jul 2009 11:01:48 +0200
Message-Id: <1246611709-9919-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b60c1f6ffd88850079ae419aa933ab0eddbd5535
(drop note_interrupt() for per-CPU for proper scaling) removed call to
note_interrupt() in __do_IRQ(). Commit
d85a60d85ea5b7c597508c1510c88e657773d378
(Add IRQF_IRQPOLL flag (common code)) added it again, because it's needed
for irqpoll.

This patch now introduces a new parameter 'only_fixup' for
note_interrupt(). This parameter determines two cases:

  TRUE  => The function should be only executed when irqfixup is set.
           Either 'irqpoll' or 'irqfixup' directly set that.

  FALSE => Just the behaviour as note_interrupt() always had.

Now the patch converts all calls of note_interrupt() to only_fixup=FALSE,
except the call that has been removed by b60c1f6ffd.
So that call is always done, but the body is only executed when either
'irqpoll' or 'irqfixup' are specified.

This is needed because __do_IRQ() calls note_interrupt() to record IRQ
statistics. It ends up creating serious cache line contention,
enough that a 1024p system live locks under the crushing weight of the
timer tick.

The note_interrupt() call modifies fields in the irq_desc_t structure.
For PER_CPU timer interrupts (on ia64 machines) this causes cacheline
contention.

Systems with 1024 processors take an extremely long time to boot up, as
most of the time is spent attempting to service timer interrupts.  With
noirqdebug added to the boot line, the system boots in close to the normal
amount of time.

Based on Bernhard's patch.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Bernhard Walle <bernhard.walle@gmx.de>
---
 arch/arm/mach-ns9xxx/irq.c              |    2 +-
 arch/powerpc/platforms/cell/interrupt.c |    2 +-
 drivers/mfd/ezx-pcap.c                  |    2 +-
 drivers/mfd/twl4030-irq.c               |    2 +-
 include/linux/irq.h                     |    2 +-
 kernel/irq/chip.c                       |   10 +++++-----
 kernel/irq/handle.c                     |    4 ++--
 kernel/irq/spurious.c                   |   10 +++++++++-
 8 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index feb0e54..f559a75 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -85,7 +85,7 @@ static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 	/* XXX: There is no direct way to access noirqdebug, so check
 	 * unconditionally for spurious irqs...
 	 * Maybe this function should go to kernel/irq/chip.c? */
-	note_interrupt(irq, desc, action_ret);
+	note_interrupt(irq, desc, action_ret, false);
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 882e470..3742589 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -268,7 +268,7 @@ static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
+			note_interrupt(irq, desc, action_ret, false);
 		spin_lock(&desc->lock);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index c1de4af..5007ff0 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -176,7 +176,7 @@ static void pcap_isr_work(struct work_struct *work)
 				break;
 
 			if (desc->status & IRQ_DISABLED)
-				note_interrupt(irq, desc, IRQ_NONE);
+				note_interrupt(irq, desc, IRQ_NONE, false);
 			else
 				desc->handle_irq(irq, desc);
 		}
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index bae61b2..e00e598 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -233,7 +233,7 @@ static int twl4030_irq_thread(void *data)
 				 */
 				if (d->status & IRQ_DISABLED)
 					note_interrupt(module_irq, d,
-							IRQ_NONE);
+							IRQ_NONE, false);
 				else
 					d->handle_irq(module_irq, d);
 			}
diff --git a/include/linux/irq.h b/include/linux/irq.h
index cb2e77a..69707ff 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -322,7 +322,7 @@ static inline void generic_handle_irq(unsigned int irq)
 
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
-			   irqreturn_t action_ret);
+			   irqreturn_t action_ret, bool only_fixup);
 
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 13c68e7..0e54062 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -333,7 +333,7 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 
 	action_ret = handle_IRQ_event(irq, action);
 	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+		note_interrupt(irq, desc, action_ret, false);
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
@@ -378,7 +378,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	action_ret = handle_IRQ_event(irq, action);
 	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+		note_interrupt(irq, desc, action_ret, false);
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
@@ -431,7 +431,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 
 	action_ret = handle_IRQ_event(irq, action);
 	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+		note_interrupt(irq, desc, action_ret, false);
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
@@ -509,7 +509,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
+			note_interrupt(irq, desc, action_ret, false);
 		spin_lock(&desc->lock);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
@@ -538,7 +538,7 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+		note_interrupt(irq, desc, action_ret, false);
 
 	if (desc->chip->eoi)
 		desc->chip->eoi(irq);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 065205b..b535926 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -463,7 +463,7 @@ unsigned int __do_IRQ(unsigned int irq)
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
-				note_interrupt(irq, desc, action_ret);
+				note_interrupt(irq, desc, action_ret, true);
 		}
 		desc->chip->end(irq);
 		return 1;
@@ -517,7 +517,7 @@ unsigned int __do_IRQ(unsigned int irq)
 
 		action_ret = handle_IRQ_event(irq, action);
 		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
+			note_interrupt(irq, desc, action_ret, false);
 
 		spin_lock(&desc->lock);
 		if (likely(!(desc->status & IRQ_PENDING)))
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 4d56829..c0463b9 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -223,9 +223,17 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 	return action && (action->flags & IRQF_IRQPOLL);
 }
 
+/*
+ * The parameter "only_fixup" means that the function should be only executed
+ * if this parameter is set either to false or to true simultaneously with
+ * irqfixup enabled.
+ */
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
-		    irqreturn_t action_ret)
+		    irqreturn_t action_ret, bool only_fixup)
 {
+	if (only_fixup && irqfixup == 0)
+		return;
+
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
-- 
1.6.3.2

