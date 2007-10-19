Return-Path: <linux-kernel-owner+w=401wt.eu-S966733AbXJSHz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966733AbXJSHz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765771AbXJSHzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:55:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46303 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764736AbXJSHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:55:10 -0400
Date: Fri, 19 Oct 2007 03:55:08 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 1/9] irq-remove: core
Message-ID: <20071019075508.GB6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 008b5fcf3c1d8456005de26ddd4256b1369225e8
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 00:45:51 2007 -0400

    [IRQ ARG REMOVAL] core interrupt delivery infrastructure updates

 include/asm-generic/irq_regs.h |   25 +++++++++++++++++++++++++
 include/linux/interrupt.h      |    4 ++--
 kernel/irq/handle.c            |    5 +++--
 kernel/irq/manage.c            |    4 ++--
 kernel/irq/spurious.c          |    3 ++-
 lib/irq_regs.c                 |    5 +++++
 6 files changed, 39 insertions(+), 7 deletions(-)

008b5fcf3c1d8456005de26ddd4256b1369225e8
diff --git a/include/asm-generic/irq_regs.h b/include/asm-generic/irq_regs.h
index 5ae1d07..1d99ef4 100644
--- a/include/asm-generic/irq_regs.h
+++ b/include/asm-generic/irq_regs.h
@@ -34,4 +34,29 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
 	return old_regs;
 }
 
+DECLARE_PER_CPU(unsigned int, __irqfunc_irqs);
+
+static inline unsigned int get_irqfunc_irq(void)
+{
+	return __get_cpu_var(__irqfunc_irqs);
+}
+
+#if 0
+static inline unsigned int set_irqfunc_irq(unsigned int new_irq)
+{
+	unsigned int old_irq, *pirq = &__get_cpu_var(__irqfunc_irqs);
+
+	old_irq = *pirq;
+	*pirq = new_irq;
+	return old_irq;
+}
+#else
+static inline void set_irqfunc_irq(unsigned int new_irq)
+{
+	int *pirq = &__get_cpu_var(__irqfunc_irqs);
+
+	*pirq = new_irq;
+}
+#endif
+
 #endif /* _ASM_GENERIC_IRQ_REGS_H */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2306920..98720ea 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -55,7 +55,7 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 
-typedef irqreturn_t (*irq_handler_t)(int, void *);
+typedef irqreturn_t (*irq_handler_t)(void *);
 
 struct irqaction {
 	irq_handler_t handler;
@@ -68,7 +68,7 @@ struct irqaction {
 	struct proc_dir_entry *dir;
 };
 
-extern irqreturn_t no_action(int cpl, void *dev_id);
+extern irqreturn_t no_action(void *dev_id);
 extern int __must_check request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e391cbb..fe19034 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -114,7 +114,7 @@ struct irq_chip dummy_irq_chip = {
 /*
  * Special, empty irq handler:
  */
-irqreturn_t no_action(int cpl, void *dev_id)
+irqreturn_t no_action(void *dev_id)
 {
 	return IRQ_NONE;
 }
@@ -137,7 +137,8 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		local_irq_enable_in_hardirq();
 
 	do {
-		ret = action->handler(irq, action->dev_id);
+		set_irqfunc_irq(irq);
+		ret = action->handler(action->dev_id);
 		if (ret == IRQ_HANDLED)
 			status |= action->flags;
 		retval |= ret;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 80eab7a..92e1456 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -455,7 +455,7 @@ void free_irq(unsigned int irq, void *dev_id)
 			 */
 			if (action->flags & IRQF_SHARED) {
 				local_irq_save(flags);
-				action->handler(irq, dev_id);
+				action->handler(dev_id);
 				local_irq_restore(flags);
 			}
 #endif
@@ -549,7 +549,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 		unsigned long flags;
 
 		local_irq_save(flags);
-		handler(irq, dev_id);
+		handler(dev_id);
 		local_irq_restore(flags);
 	}
 #endif
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 32b1619..8c6038e 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -49,7 +49,8 @@ static int misrouted_irq(int irq)
 		while (action) {
 			/* Only shared IRQ handlers are safe to call */
 			if (action->flags & IRQF_SHARED) {
-				if (action->handler(i, action->dev_id) ==
+				set_irqfunc_irq(i);
+				if (action->handler(action->dev_id) ==
 						IRQ_HANDLED)
 					ok = 1;
 			}
diff --git a/lib/irq_regs.c b/lib/irq_regs.c
index 753880a..765a938 100644
--- a/lib/irq_regs.c
+++ b/lib/irq_regs.c
@@ -15,3 +15,8 @@
 DEFINE_PER_CPU(struct pt_regs *, __irq_regs);
 EXPORT_PER_CPU_SYMBOL(__irq_regs);
 #endif
+
+#ifndef ARCH_HAS_OWN_IRQFUNC_IRQ
+DEFINE_PER_CPU(unsigned int, __irqfunc_irqs);
+EXPORT_PER_CPU_SYMBOL(__irqfunc_irqs);
+#endif
