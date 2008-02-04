Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYBDMS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYBDMS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYBDMSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:18:49 -0500
Received: from ozlabs.org ([203.10.76.45]:53317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYBDMSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:18:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/5] typesafe: request_irq and devm_request_irq
Date: Mon, 4 Feb 2008 23:18:33 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200802042311.18762.rusty@rustcorp.com.au> <200802042316.02963.rusty@rustcorp.com.au> <200802042317.29130.rusty@rustcorp.com.au>
In-Reply-To: <200802042317.29130.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042318.33503.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets interrupt handler functions have their natural type
(ie. exactly match the data pointer type); it allows the old irq_handler_t
type as well.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/interrupt.h |   17 +++++++++++++++--
 kernel/irq/devres.c       |   10 +++++-----
 kernel/irq/manage.c       |    6 +++---
 3 files changed, 23 insertions(+), 10 deletions(-)

diff -r 0fe1a980708b include/linux/interrupt.h
--- a/include/linux/interrupt.h	Thu Jan 17 14:48:56 2008 +1100
+++ b/include/linux/interrupt.h	Thu Jan 17 15:42:01 2008 +1100
@@ -69,13 +69,26 @@ struct irqaction {
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
-extern int __must_check request_irq(unsigned int, irq_handler_t handler,
+
+/* Typesafe version of request_irq.  Also takes old-style void * handlers. */
+#define request_irq(irq, handler, flags, name, dev_id)			\
+	__request_irq((irq),						\
+		      cast_if_type((handler), int (*)(int, typeof(dev_id)), \
+				   irq_handler_t),			\
+		      (flags), (name), (dev_id))
+
+extern int __must_check __request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
 
 struct device;
 
-extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
+#define devm_request_irq(dev, irq, handler, flags, name, dev_id)	\
+	__devm_request_irq((dev), (irq),				\
+		      cast_if_type((handler), int (*)(int, typeof(dev_id)), \
+				   irq_handler_t),			\
+		      (flags), (name), (dev_id))
+extern int __must_check __devm_request_irq(struct device *dev, unsigned int irq,
 			    irq_handler_t handler, unsigned long irqflags,
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
diff -r 0fe1a980708b kernel/irq/devres.c
--- a/kernel/irq/devres.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/kernel/irq/devres.c	Thu Jan 17 15:42:01 2008 +1100
@@ -41,9 +41,9 @@ static int devm_irq_match(struct device 
  *	If an IRQ allocated with this function needs to be freed
  *	separately, dev_free_irq() must be used.
  */
-int devm_request_irq(struct device *dev, unsigned int irq,
-		     irq_handler_t handler, unsigned long irqflags,
-		     const char *devname, void *dev_id)
+int __devm_request_irq(struct device *dev, unsigned int irq,
+		       irq_handler_t handler, unsigned long irqflags,
+		       const char *devname, void *dev_id)
 {
 	struct irq_devres *dr;
 	int rc;
@@ -53,7 +53,7 @@ int devm_request_irq(struct device *dev,
 	if (!dr)
 		return -ENOMEM;
 
-	rc = request_irq(irq, handler, irqflags, devname, dev_id);
+	rc = __request_irq(irq, handler, irqflags, devname, dev_id);
 	if (rc) {
 		devres_free(dr);
 		return rc;
@@ -65,7 +65,7 @@ int devm_request_irq(struct device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL(devm_request_irq);
+EXPORT_SYMBOL(__devm_request_irq);
 
 /**
  *	devm_free_irq - free an interrupt
diff -r 0fe1a980708b kernel/irq/manage.c
--- a/kernel/irq/manage.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/kernel/irq/manage.c	Thu Jan 17 15:42:01 2008 +1100
@@ -514,8 +514,8 @@ EXPORT_SYMBOL(free_irq);
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *
  */
-int request_irq(unsigned int irq, irq_handler_t handler,
-		unsigned long irqflags, const char *devname, void *dev_id)
+int __request_irq(unsigned int irq, irq_handler_t handler,
+		  unsigned long irqflags, const char *devname, void *dev_id)
 {
 	struct irqaction *action;
 	int retval;
@@ -576,4 +576,4 @@ int request_irq(unsigned int irq, irq_ha
 
 	return retval;
 }
-EXPORT_SYMBOL(request_irq);
+EXPORT_SYMBOL(__request_irq);
