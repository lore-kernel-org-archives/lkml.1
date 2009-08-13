Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZHMTld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZHMTld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZHMTlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:41:32 -0400
Received: from www.tglx.de ([62.245.132.106]:56312 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbZHMTla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:41:30 -0400
Message-Id: <20090813193116.463023904@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 13 Aug 2009 19:40:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: [RFC patch 1/3] genirq: Add oneshot support
References: <20090813191535.945521006@linutronix.de>
Content-Disposition: inline; filename=genirq-add-oneshot-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For threaded interrupt handlers we expect the hard interrupt handler
part to mask the interrupt on the originating device. The interrupt
line itself is reenabled after the hard interrupt handler has
executed.

This requires access to the originating device from hard interrupt
context which is not always possible. There are devices which can only
be accessed via a bus (i2c, spi, ...). The bus access requires thread
context. For such devices we need to keep the interrupt line masked
until the threaded handler has executed.

Add a new flag IRQF_ONESHOT which allows drivers to request that the
interrupt is not unmasked after the hard interrupt context handler has
been executed and the thread has been woken. The interrupt line is
unmasked after the thread handler function has been executed.

Note that for now IRQF_ONESHOT cannot be used with IRQF_SHARED to
avoid complex accounting mechanisms.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/interrupt.h |    4 ++++
 include/linux/irq.h       |    1 +
 kernel/irq/chip.c         |   14 +++++++++++---
 kernel/irq/manage.c       |   29 +++++++++++++++++++++++++++--
 4 files changed, 43 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -49,6 +49,9 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
+ *                Used by threaded interrupts which need to keep the
+ *                irq line disabled until the threaded handler has been run.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -58,6 +61,7 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_ONESHOT		0x00002000
 
 /*
  * Bits used by threaded handlers:
Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -69,6 +69,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
+#define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -382,7 +382,10 @@ handle_level_irq(unsigned int irq, struc
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
-	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
+
+	if (unlikely(desc->status & IRQ_ONESHOT))
+		desc->status |= IRQ_MASKED;
+	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
 out_unlock:
 	spin_unlock(&desc->lock);
@@ -478,8 +481,13 @@ handle_edge_irq(unsigned int irq, struct
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	if (unlikely(desc->status & IRQ_ONESHOT)) {
+		desc->status |= IRQ_MASKED;
+		mask_ack_irq(desc, irq);
+	} else {
+		if (desc->chip->ack)
+			desc->chip->ack(irq);
+	}
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -444,6 +444,21 @@ static int irq_wait_for_interrupt(struct
 }
 
 /*
+ * Oneshot interrupts keep the irq line masked until the threaded
+ * handler finished. unmask if the interrupt has not been disabled and
+ * is marked MASKED.
+ */
+static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+{
+	spin_lock_irq(&desc->lock);
+	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
+		desc->status &= ~IRQ_MASKED;
+		desc->chip->unmask(irq);
+	}
+	spin_unlock_irq(&desc->lock);
+}
+
+/*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
@@ -451,7 +466,7 @@ static int irq_thread(void *data)
 	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake;
+	int wake, oneshot = desc->status & IRQ_ONESHOT;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -475,6 +490,9 @@ static int irq_thread(void *data)
 			spin_unlock_irq(&desc->lock);
 
 			action->thread_fn(action->irq, action->dev_id);
+
+			if (oneshot)
+				irq_finalize_oneshot(action->irq, desc);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -547,6 +565,10 @@ __setup_irq(unsigned int irq, struct irq
 		rand_initialize_irq(irq);
 	}
 
+	/* Oneshot interrupts are not allowed with shared */
+	if ((new->flags & IRQF_ONESHOT) && (new->flags & IRQF_SHARED))
+		return -EINVAL;
+
 	/*
 	 * Threaded handler ?
 	 */
@@ -620,9 +642,12 @@ __setup_irq(unsigned int irq, struct irq
 			desc->status |= IRQ_PER_CPU;
 #endif
 
-		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
+		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING | IRQ_ONESHOT |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
+		if (new->flags & IRQF_ONESHOT)
+			desc->status |= IRQ_ONESHOT;
+
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;


