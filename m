Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYJAXDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYJAXDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYJAXDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:03:21 -0400
Received: from www.tglx.de ([62.245.132.106]:56526 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYJAXDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:03:20 -0400
Message-Id: <20081001223302.111345767@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 01 Oct 2008 23:02:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: [RFC patch 4/5] genirq: add a helper to check whether the irq thread
	should run
References: <20081001223213.078984344@linutronix.de>
Content-Disposition: inline; filename=genirq-add-irq-trigger-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper allows threaded irq handlers to determine whether another
interrupt arrived or not while the thread is running.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/interrupt.h |    5 +++++
 kernel/irq/manage.c       |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -109,6 +109,11 @@ extern int __must_check devm_request_irq
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
+static inline int irq_thread_should_run(struct irqaction *action)
+{
+	return test_and_clear_bit(IRQF_RUNTHREAD, &action->flags);
+}
+
 /*
  * On lockdep we dont want to enable hardirqs in hardirq
  * context. Use local_irq_enable_in_hardirq() to annotate
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -341,7 +341,7 @@ static int irq_thread(void *data)
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
-		if (!test_and_clear_bit(IRQF_RUNTHREAD, &action->flags)) {
+		if (!irq_thread_should_run(action)) {
 			schedule();
 			/* Avoid running the handler on stop */
 			if (kthread_should_stop())


