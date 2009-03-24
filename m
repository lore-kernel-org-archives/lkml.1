Return-Path: <linux-kernel-owner+w=401wt.eu-S1762899AbZCXQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762899AbZCXQYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762592AbZCXQXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:23:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39838 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762637AbZCXQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:23:30 -0400
Message-Id: <20090324160147.923724935@polymtl.ca>
References: <20090324155625.420966314@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 11:56:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/9] IRQ handle prepare for instrumentation
Content-Disposition: inline; filename=irq-handle-prepare-for-instrumentation.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 24 Mar 2009 16:22:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename handle_IRQ_event to _handle_IRQ_event and declare it static so it can be
embedded in its caller. Create a handle_IRQ_event wrapper (non-static) to still
show the symbol to arch-specific code still using it.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/irq/handle.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: linux-2.6-lttng/kernel/irq/handle.c
===================================================================
--- linux-2.6-lttng.orig/kernel/irq/handle.c	2009-01-30 09:47:59.000000000 -0500
+++ linux-2.6-lttng/kernel/irq/handle.c	2009-01-30 10:38:14.000000000 -0500
@@ -316,14 +316,7 @@ irqreturn_t no_action(int cpl, void *dev
 	return IRQ_NONE;
 }
 
-/**
- * handle_IRQ_event - irq action chain handler
- * @irq:	the interrupt number
- * @action:	the interrupt action chain for this irq
- *
- * Handles the action chain of an irq event
- */
-irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+static irqreturn_t _handle_IRQ_event(unsigned int irq, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
@@ -346,6 +339,18 @@ irqreturn_t handle_IRQ_event(unsigned in
 	return retval;
 }
 
+/**
+ * handle_IRQ_event - irq action chain handler
+ * @irq:	the interrupt number
+ * @action:	the interrupt action chain for this irq
+ *
+ * Handles the action chain of an irq event
+ */
+irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+{
+	return _handle_IRQ_event(irq, action);
+}
+
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 /**
  * __do_IRQ - original all in one highlevel IRQ handler
@@ -378,7 +383,7 @@ unsigned int __do_IRQ(unsigned int irq)
 			desc = irq_remap_to_desc(irq, desc);
 		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
-			action_ret = handle_IRQ_event(irq, desc->action);
+			action_ret = _handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
 				note_interrupt(irq, desc, action_ret);
 		}
@@ -434,7 +439,7 @@ unsigned int __do_IRQ(unsigned int irq)
 
 		spin_unlock(&desc->lock);
 
-		action_ret = handle_IRQ_event(irq, action);
+		action_ret = _handle_IRQ_event(irq, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
