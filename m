Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYATJyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYATJyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYATJyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:54:45 -0500
Received: from ozlabs.org ([203.10.76.45]:60818 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbYATJyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:54:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/6] typesafe: request_irq and devm_request_irq
Date: Sun, 20 Jan 2008 20:54:03 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801202050.41495.rusty@rustcorp.com.au> <200801202051.42958.rusty@rustcorp.com.au>
In-Reply-To: <200801202051.42958.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202054.03484.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets interrupt handler functions have their natural type
(ie. exactly match the data pointer type); it allows the old irq_handler_t
type as well.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/interrupt.h |   17 +++++++++++++++--
 include/linux/kernel.h    |    7 +++++++
 kernel/irq/devres.c       |   10 +++++-----
 kernel/irq/manage.c       |    6 +++---
 4 files changed, 30 insertions(+), 10 deletions(-)

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
