Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0CEPSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:18:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0CEPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:18:16 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] genirq: spurious irq detection for threaded irqs
Date: Fri,  5 Mar 2010 16:18:11 +0100
Message-Id: <1267802291-5197-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <alpine.LFD.2.00.1003042323090.2014@localhost.localdomain>
References: <alpine.LFD.2.00.1003042323090.2014@localhost.localdomain>
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
Hello,

changed since v1:

 - use note_interrupt for the threaded handler's return value, getting rid of
   note_threaded_interrupt.  The only downside is that a threaded handler
   returning IRQ_WAKE_THREAD remains uncatched now.

Best regards
Uwe

 kernel/irq/handle.c   |    6 ------
 kernel/irq/manage.c   |    8 +++++++-
 kernel/irq/spurious.c |    7 +++++++
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..a466dc6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -381,12 +381,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
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
index eb6078c..9e1ff55 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -557,12 +557,18 @@ static int irq_thread(void *data)
 			desc->status |= IRQ_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
+			irqreturn_t action_ret;
+
 			raw_spin_unlock_irq(&desc->lock);
 
-			action->thread_fn(action->irq, action->dev_id);
+			action_ret = action->thread_fn(action->irq,
+					action->dev_id);
 
 			if (oneshot)
 				irq_finalize_oneshot(action->irq, desc);
+
+			if (!noirqdebug)
+				note_interrupt(action->irq, desc, action_ret);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 89fb90a..fc5c6e6 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -216,6 +216,13 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	if (action_ret == IRQ_WAKE_THREAD)
+		/* handled in irq_thread() when the threaded handler returns */
+		return;
+
+	/* don't report IRQ_WAKE_THREAD | IRQ_HANDLED as bogus return value */
+	action_ret &= ~IRQ_WAKE_THREAD;
+
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
-- 
1.7.0

