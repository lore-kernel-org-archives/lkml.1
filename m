Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbZCWSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbZCWSZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758797AbZCWSYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:24:38 -0400
Received: from www.tglx.de ([62.245.132.106]:57630 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760542AbZCWSYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:24:37 -0400
Message-Id: <20090323172835.369506866@linutronix.de>
User-Agent: quilt/0.47-1
Date: Mon, 23 Mar 2009 18:23:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>, David Brownell <david-b@pacbell.net>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 2/2] genirq: add support for threaded interrupts to devres
References: <20090323172814.548471871@linutronix.de>
Content-Disposition: inline;
	filename=genirq-add-support-for-threaded-to-devres.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: support threaded interrupts in devres

Some devices use devres_request_irq() for to install their interrupt
handler. Add support for threaded interrupts to devres as well.

[tglx - simplified and adapted to latest threadirq version]

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |   17 ++++++++++++++---
 kernel/irq/devres.c       |   16 ++++++++++------
 2 files changed, 24 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -123,9 +123,20 @@ extern void free_irq(unsigned int, void 
 
 struct device;
 
-extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
-			    irq_handler_t handler, unsigned long irqflags,
-			    const char *devname, void *dev_id);
+extern int __must_check
+devm_request_threaded_irq(struct device *dev, unsigned int irq,
+			  irq_handler_t handler, irq_handler_t thread_fn,
+			  unsigned long irqflags, const char *devname,
+			  void *dev_id);
+
+static inline int __must_check
+devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
+		 unsigned long irqflags, const char *devname, void *dev_id)
+{
+	return devm_request_threaded_irq(dev, irq, handler, NULL, irqflags,
+					 devname, dev_id);
+}
+
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
 /*
Index: linux-2.6-tip/kernel/irq/devres.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/devres.c
+++ linux-2.6-tip/kernel/irq/devres.c
@@ -26,10 +26,12 @@ static int devm_irq_match(struct device 
 }
 
 /**
- *	devm_request_irq - allocate an interrupt line for a managed device
+ *	devm_request_threaded_irq - allocate an interrupt line for a managed device
  *	@dev: device to request interrupt for
  *	@irq: Interrupt line to allocate
  *	@handler: Function to be called when the IRQ occurs
+ *	@thread_fn: function to be called in a threaded interrupt context. NULL
+ *		    for devices which handle everything in @handler
  *	@irqflags: Interrupt type flags
  *	@devname: An ascii name for the claiming device
  *	@dev_id: A cookie passed back to the handler function
@@ -42,9 +44,10 @@ static int devm_irq_match(struct device 
  *	If an IRQ allocated with this function needs to be freed
  *	separately, dev_free_irq() must be used.
  */
-int devm_request_irq(struct device *dev, unsigned int irq,
-		     irq_handler_t handler, unsigned long irqflags,
-		     const char *devname, void *dev_id)
+int devm_request_threaded_irq(struct device *dev, unsigned int irq,
+			      irq_handler_t handler, irq_handler_t thread_fn,
+			      unsigned long irqflags, const char *devname,
+			      void *dev_id)
 {
 	struct irq_devres *dr;
 	int rc;
@@ -54,7 +57,8 @@ int devm_request_irq(struct device *dev,
 	if (!dr)
 		return -ENOMEM;
 
-	rc = request_irq(irq, handler, irqflags, devname, dev_id);
+	rc = request_threaded_irq(irq, handler, thread_fn, irqflags, devname,
+				  dev_id);
 	if (rc) {
 		devres_free(dr);
 		return rc;
@@ -66,7 +70,7 @@ int devm_request_irq(struct device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL(devm_request_irq);
+EXPORT_SYMBOL(devm_request_threaded_irq);
 
 /**
  *	devm_free_irq - free an interrupt


