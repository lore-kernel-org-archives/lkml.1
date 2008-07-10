Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYGJVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYGJVwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYGJVwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:52:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56561 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYGJVwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:52:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Thomas Gleixner <tglx@linutronix.de> Gleixner" <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jul 2008 14:48:54 -0700
Message-ID: <m13amho1fd.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Thomas Gleixner <tglx@linutronix.de> Gleixner"
	<tglx@linutronix.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4975]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] Enable polling for disabled screaming irqs
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we disable a screaming irq we never see it again.  If the irq
line is shared or if the driver half works this is a real pain.  So
periodically poll the handlers for screaming interrupts.

I use a timer instead of the classic irq poll technique of working off
the timer interrupt because when we use the local apic timers
note_interrupt is never called (bug?).  Further on a system with
dynamic ticks the timer interrupt might not even fire unless there is
a timer telling it it needs to.

I forced this case on my test system with an e1000 nic and my ssh
session remained responsive despite the interrupt handler only being
called every 10th of a second.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/irq/spurious.c |  147 ++++++++++++++++++++++++++++++------------------
 1 files changed, 92 insertions(+), 55 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index c66d3f1..3d97eba 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -12,83 +12,118 @@
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/timer.h>
 
 static int irqfixup __read_mostly;
 
+#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
+static void poll_spurious_irqs(unsigned long dummy);
+static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
+
 /*
  * Recovery handler for misrouted interrupts.
  */
-static int misrouted_irq(int irq)
+static int try_one_irq(int irq, struct irq_desc *desc)
 {
-	int i;
+	struct irqaction *action;
 	int ok = 0;
 	int work = 0;	/* Did we do work for a real IRQ */
 
-	for (i = 1; i < NR_IRQS; i++) {
-		struct irq_desc *desc = irq_desc + i;
-		struct irqaction *action;
-
-		if (i == irq)	/* Already tried */
-			continue;
-
-		spin_lock(&desc->lock);
-		/* Already running on another processor */
-		if (desc->status & IRQ_INPROGRESS) {
-			/*
-			 * Already running: If it is shared get the other
-			 * CPU to go looking for our mystery interrupt too
-			 */
-			if (desc->action && (desc->action->flags & IRQF_SHARED))
-				desc->status |= IRQ_PENDING;
-			spin_unlock(&desc->lock);
-			continue;
-		}
-		/* Honour the normal IRQ locking */
-		desc->status |= IRQ_INPROGRESS;
-		action = desc->action;
+	spin_lock(&desc->lock);
+	/* Already running on another processor */
+	if (desc->status & IRQ_INPROGRESS) {
+		/*
+		 * Already running: If it is shared get the other
+		 * CPU to go looking for our mystery interrupt too
+		 */
+		if (desc->action && (desc->action->flags & IRQF_SHARED))
+			desc->status |= IRQ_PENDING;
 		spin_unlock(&desc->lock);
+		return ok;
+	}
+	/* Honour the normal IRQ locking */
+	desc->status |= IRQ_INPROGRESS;
+	action = desc->action;
+	spin_unlock(&desc->lock);
 
-		while (action) {
-			/* Only shared IRQ handlers are safe to call */
-			if (action->flags & IRQF_SHARED) {
-				if (action->handler(i, action->dev_id) ==
-						IRQ_HANDLED)
-					ok = 1;
-			}
-			action = action->next;
+	while (action) {
+		/* Only shared IRQ handlers are safe to call */
+		if (action->flags & IRQF_SHARED) {
+			if (action->handler(irq, action->dev_id) ==
+				IRQ_HANDLED)
+				ok = 1;
 		}
-		local_irq_disable();
-		/* Now clean up the flags */
-		spin_lock(&desc->lock);
-		action = desc->action;
+		action = action->next;
+	}
+	local_irq_disable();
+	/* Now clean up the flags */
+	spin_lock(&desc->lock);
+	action = desc->action;
 
+	/*
+	 * While we were looking for a fixup someone queued a real
+	 * IRQ clashing with our walk:
+	 */
+	while ((desc->status & IRQ_PENDING) && action) {
 		/*
-		 * While we were looking for a fixup someone queued a real
-		 * IRQ clashing with our walk:
-		 */
-		while ((desc->status & IRQ_PENDING) && action) {
-			/*
-			 * Perform real IRQ processing for the IRQ we deferred
-			 */
-			work = 1;
-			spin_unlock(&desc->lock);
-			handle_IRQ_event(i, action);
-			spin_lock(&desc->lock);
-			desc->status &= ~IRQ_PENDING;
-		}
-		desc->status &= ~IRQ_INPROGRESS;
-		/*
-		 * If we did actual work for the real IRQ line we must let the
-		 * IRQ controller clean up too
+		 * Perform real IRQ processing for the IRQ we deferred
 		 */
-		if (work && desc->chip && desc->chip->end)
-			desc->chip->end(i);
+		work = 1;
 		spin_unlock(&desc->lock);
+		handle_IRQ_event(irq, action);
+		spin_lock(&desc->lock);
+		desc->status &= ~IRQ_PENDING;
+	}
+	desc->status &= ~IRQ_INPROGRESS;
+	/*
+	 * If we did actual work for the real IRQ line we must let the
+	 * IRQ controller clean up too
+	 */
+	if (work && desc->chip && desc->chip->end)
+		desc->chip->end(irq);
+	spin_unlock(&desc->lock);
+
+	return ok;
+	
+}
+
+static int misrouted_irq(int irq)
+{
+	int i;
+	int ok = 0;
+
+ 	for (i = 1; i < NR_IRQS; i++) {
+		struct irq_desc *desc = irq_desc + i;
+
+		if (i == irq)	/* Already tried */
+			continue;
+
+		if (try_one_irq(i, desc))
+			ok = 1;
 	}
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
 
+static void poll_spurious_irqs(unsigned long dummy)
+{
+	int i;
+	for (i = 1; i < NR_IRQS; i++) {
+		struct irq_desc *desc = irq_desc + i;
+		unsigned int status;
+
+		/* Racy but it doesn't matter */
+		status = desc->status;
+		barrier();
+		if (!(status & IRQ_SPURIOUS_DISABLED))
+			continue;
+
+		try_one_irq(i, desc);
+	}
+
+	mod_timer(&poll_spurious_irq_timer, jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
+}
+
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
@@ -212,6 +247,8 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
 		desc->chip->disable(irq);
+
+		mod_timer(&poll_spurious_irq_timer, jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 	}
 	desc->irqs_unhandled = 0;
 }
-- 
1.5.3.rc6.17.g1911

