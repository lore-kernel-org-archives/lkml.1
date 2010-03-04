Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0CDKa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:30:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50258 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0CDKa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:30:26 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] genirq: spurious irq detection for threaded irqs
Date: Thu,  4 Mar 2010 11:30:22 +0100
Message-Id: <1267698622-1216-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For threaded irqs the top half returns IRQ_WAKE_THREAD.  Don't treat
that value like IRQ_HANDLED for the spurious check.  Instead check the
return value of the threaded handler to be able to detect stuck irqs
that only have threaded handlers and no top half that can detect the
problem.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h   |    2 ++
 kernel/irq/handle.c   |    6 ------
 kernel/irq/manage.c   |    7 ++++++-
 kernel/irq/spurious.c |   17 +++++++++++++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 451481c..f261765 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -323,6 +323,8 @@ static inline void generic_handle_irq(unsigned int irq)
 }
 
 /* Handling of unhandled and spurious interrupts: */
+extern void note_threaded_interrupt(unsigned int irq, struct irq_desc *desc,
+			   irqreturn_t action_ret);
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 814940e..3f63947 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -383,12 +383,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		switch (ret) {
 		case IRQ_WAKE_THREAD:
 			/*
-			 * Set result to handled so the spurious check
-			 * does not trigger.
-			 */
-			ret = IRQ_HANDLED;
-
-			/*
 			 * Catch drivers which return WAKE_THREAD but
 			 * did not set up a thread function
 			 */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..81fdc45 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -557,12 +557,17 @@ static int irq_thread(void *data)
 			desc->status |= IRQ_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
+			irqreturn_t action_ret;
+
 			raw_spin_unlock_irq(&desc->lock);
 
-			action->thread_fn(action->irq, action->dev_id);
+			action_ret = action->thread_fn(action->irq, action->dev_id);
 
 			if (oneshot)
 				irq_finalize_oneshot(action->irq, desc);
+
+			if (!noirqdebug)
+				note_threaded_interrupt(action->irq, desc, action_ret);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 89fb90a..56395fd 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -213,8 +213,8 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 	return action && (action->flags & IRQF_IRQPOLL);
 }
 
-void note_interrupt(unsigned int irq, struct irq_desc *desc,
-		    irqreturn_t action_ret)
+void note_threaded_interrupt(unsigned int irq, struct irq_desc *desc,
+		irqreturn_t action_ret)
 {
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		/*
@@ -262,6 +262,19 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 	desc->irqs_unhandled = 0;
 }
 
+void note_interrupt(unsigned int irq, struct irq_desc *desc,
+		irqreturn_t action_ret)
+{
+	if (action_ret == IRQ_WAKE_THREAD)
+		/* handled in irq_thread() when the threaded handler returns */
+		return;
+
+	/* don't report IRQ_WAKE_THREAD | IRQ_HANDLED as bogus return value */
+	action_ret &= ~IRQ_WAKE_THREAD;
+
+	note_threaded_interrupt(irq, desc, action_ret);
+}
+
 int noirqdebug __read_mostly;
 
 int noirqdebug_setup(char *str)
-- 
1.7.0

