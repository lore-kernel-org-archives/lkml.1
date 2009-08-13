Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZHMVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZHMVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZHMVcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:32:19 -0400
Received: from www.tglx.de ([62.245.132.106]:52434 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbZHMVcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:32:18 -0400
Date: Thu, 13 Aug 2009 23:31:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq fixes for 2.6.31 -V2
Message-ID: <alpine.LFD.2.00.0908132311510.1283@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus-2

Thanks for pointing out the obvious solution. 

I hope it's ok for you that I precautionary added your Signed-off-by
to the commit.

Thanks,

	tglx

------------------>
Linus Torvalds (1):
      genirq: prevent wakeup of freed irq thread


 kernel/irq/manage.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 61c679d..d222515 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -761,7 +761,6 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
-	struct task_struct *irqthread;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
@@ -809,9 +808,6 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 			desc->chip->disable(irq);
 	}
 
-	irqthread = action->thread;
-	action->thread = NULL;
-
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	unregister_handler_proc(irq, action);
@@ -819,12 +815,6 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* Make sure it's not being used on another CPU: */
 	synchronize_irq(irq);
 
-	if (irqthread) {
-		if (!test_bit(IRQTF_DIED, &action->thread_flags))
-			kthread_stop(irqthread);
-		put_task_struct(irqthread);
-	}
-
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
 	 * It's a shared IRQ -- the driver ought to be prepared for an IRQ
@@ -840,6 +830,13 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 		local_irq_restore(flags);
 	}
 #endif
+
+	if (action->thread) {
+		if (!test_bit(IRQTF_DIED, &action->thread_flags))
+			kthread_stop(action->thread);
+		put_task_struct(action->thread);
+	}
+
 	return action;
 }
 
