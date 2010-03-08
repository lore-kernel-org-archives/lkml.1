Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0CHX62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:58:28 -0500
Received: from smtp-out-093.synserver.de ([212.40.180.93]:1032 "HELO
	smtp-out-093.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756056Ab0CHX6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:58:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 30490
From: Lars-Peter Clausen <lars@metafoo.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot and handle_level_irq
Date: Tue,  9 Mar 2010 00:57:59 +0100
Message-Id: <1268092679-18070-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel has been compiled with preemtion support and handle_level_irq is
called from process context for a oneshot irq there is a race between
irq_finalize_oneshot and handle_level_irq which results in the irq not being
unmasked after its handlers have been run.

irq_finalize_oneshot is expected to unmask the irq after the threaded irq
handler has been run. It only does so if IRQ_MASKED is set for the irqs status.
IRQ_MASKED gets set in the lower part of handle_level_irq after handle_IRQ_event
has been called.
handle_IRQ_event will wakeup the oneshot irqs threaded handler and if the
kernel has been build with preemption there is a chance that the threaded irq
handler will finish before execution is returned to handle_level_irq.
As a result irq_finalize_oneshot will not unmask the irq and handle_level_irq
will set the IRQ_MASKED flag. Thus the irq will stay masked and stalls.

In case of an race the call-graph would look like this:
 handle_level_irq
 |- mask_ack_irq
 |- handle_IRQ_event
    |- wake_up_process
       |- irq_thread
          |- action->thread_fn
          |- irq_finalize_oneshot # Does not unmask the irq
|- # Set IRQ_MASKED status flag

This patch fixes the race by adding an additional irq status flag which indicates
whether the oneshot threaded handler is still running. And if it's not running
anymore handle_level_irq is going to unmask the irq as for non oneshot irqs.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/irq.h |    1 +
 kernel/irq/chip.c   |    5 +++--
 kernel/irq/manage.c |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 707ab12..48ff905 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -71,6 +71,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+#define IRQ_ONESHOT_INPROGRESS	0x20000000	/* IRQ onshot handler is running */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 42ec11b..ea5c398 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -474,7 +474,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
 
-	desc->status |= IRQ_INPROGRESS;
+	desc->status |= IRQ_INPROGRESS | IRQ_ONESHOT_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
@@ -484,7 +484,8 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
-	if (unlikely(desc->status & IRQ_ONESHOT))
+	if (unlikely((desc->status & (IRQ_ONESHOT | IRQ_ONESHOT_INPROGRESS)) ==
+			IRQ_ONESHOT | IRQ_ONESHOT_INPROGRESS))
 		desc->status |= IRQ_MASKED;
 	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..cfff5e5 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -489,6 +489,7 @@ static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
 		desc->status &= ~IRQ_MASKED;
 		desc->chip->unmask(irq);
 	}
+	desc->status &= ~IRQ_ONESHOT_INPROGRESS;
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(irq, desc);
 }
-- 
1.5.6.5

