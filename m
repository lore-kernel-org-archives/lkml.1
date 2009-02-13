Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbZBMEAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbZBMEAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:00:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZBMD7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 22:59:52 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:46270 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbZBMD7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 22:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=qJ7kLkdzeDyJKXEuhwZk0BKiWqEKAlVu7slSKO7qe43QXubDEXOcUXWscLZtOjdJ2h
         U7pxpbqX6Uh8YtTvk0NpMv6wRHU5Aq36uVkBdxp8s/hbVz2as09eP2wmEbCTBj6/XKQo
         MR3XMOjNuvYc/BHjAQJ4S9MYq2VLjaxENUCeI=
Message-ID: <4994f034.02e2660a.3130.23df@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 13 Feb 2009 04:38:57 +0100
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rt/threadirqs: put the irq thread handler in a callback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when a hardirq is threaded, it is processed by do_hardirq()
which guess the best low-level handler for this irq.

This makes several branch conditions to check for each irq triggered,
adding some (very small) latencies since we are in a fastpath (irq disabled)
of the irq processing.

So it's better to put these checks only once when the handler of the irq is set
and then only dereference one pointer to find the appropriate callback.

This patch makes the irq thread handler a field in struct irq_desc.

[Note, I'm not sure the check if (!desc->handle_irq_thread) is really
useful. I've put it to ensure that even an irq_desc which never gone to
__set_irq_handler() can be handled. But I'm not sure it is possible.]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq.h |   11 ++++++++++-
 kernel/irq/chip.c   |    2 ++
 kernel/irq/manage.c |   27 ++++++++++++++++++---------
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index aa9d62e..ff83182 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -30,6 +30,7 @@
 struct irq_desc;
 typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
+typedef void (*irq_thread_handler_t)(struct irq_desc *desc);
 
 
 /*
@@ -136,6 +137,7 @@ struct irq_chip {
  * struct irq_desc - interrupt descriptor
  * @irq:		interrupt number for this descriptor
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
+ * @handle_irq_thread:	highlevel threaded irq-events handler
  * @chip:		low level interrupt hardware access
  * @msi_desc:		MSI descriptor
  * @handler_data:	per-IRQ data for the irq_chip methods
@@ -161,6 +163,9 @@ struct irq_chip {
 struct irq_desc {
 	unsigned int		irq;
 	irq_flow_handler_t	handle_irq;
+#ifdef CONFIG_PREEMPT_HARDIRQS
+	irq_thread_handler_t	handle_irq_thread;
+#endif
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
 	void			*handler_data;
@@ -393,10 +398,14 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 extern void early_init_hardirqs(void);
 extern cycles_t irq_timestamp(unsigned int irq);
 
-#if defined(CONFIG_PREEMPT_HARDIRQS)
+#ifdef CONFIG_PREEMPT_HARDIRQS
 extern void init_hardirqs(void);
+extern void
+__set_irq_thread_handler(struct irq_desc *desc, irq_flow_handler_t handle);
 #else
 static inline void init_hardirqs(void) { }
+static inline void
+__set_irq_thread_handler(struct irq_desc *desc, irq_flow_handler_t handle) { }
 #endif
 
 #else	/* end GENERIC HARDIRQS */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f25b747..e8aa31c 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -605,6 +605,8 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	desc->handle_irq = handle;
 	desc->name = name;
 
+	__set_irq_thread_handler(desc, handle);
+
 	if (handle != handle_bad_irq && is_chained) {
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8e963a9..776c715 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -901,6 +901,21 @@ static void thread_do_irq(irq_desc_t *desc)
 	desc->chip->end(irq);
 }
 
+void
+__set_irq_thread_handler(struct irq_desc *desc, irq_flow_handler_t handle)
+{
+	if (handle == handle_simple_irq)
+		desc->handle_irq_thread = thread_simple_irq;
+	else if (handle == handle_level_irq)
+		desc->handle_irq_thread = thread_level_irq;
+	else if (handle == handle_fasteoi_irq)
+		desc->handle_irq_thread = thread_fasteoi_irq;
+	else if (handle == handle_edge_irq)
+		desc->handle_irq_thread = thread_edge_irq;
+	else
+		desc->handle_irq_thread = thread_do_irq;
+}
+
 static void do_hardirq(struct irq_desc *desc)
 {
 	spin_lock(&desc->lock);
@@ -908,16 +923,10 @@ static void do_hardirq(struct irq_desc *desc)
 	if (!(desc->status & IRQ_INPROGRESS))
 		goto out;
 
-	if (desc->handle_irq == handle_simple_irq)
-		thread_simple_irq(desc);
-	else if (desc->handle_irq == handle_level_irq)
-		thread_level_irq(desc);
-	else if (desc->handle_irq == handle_fasteoi_irq)
-		thread_fasteoi_irq(desc);
-	else if (desc->handle_irq == handle_edge_irq)
-		thread_edge_irq(desc);
-	else
+	if (unlikely(!desc->handle_irq_thread))
 		thread_do_irq(desc);
+	else
+		desc->handle_irq_thread(desc);
  out:
 	spin_unlock(&desc->lock);
 
-- 
1.6.1


