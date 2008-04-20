Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYDTXJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYDTXJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYDTXJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:09:33 -0400
Received: from ozlabs.org ([203.10.76.45]:44406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbYDTXJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:09:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] typesafe: request_irq and devm_request_irq
Date: Mon, 21 Apr 2008 09:09:23 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200804210859.00080.rusty@rustcorp.com.au> <200804210905.33090.rusty@rustcorp.com.au> <200804210907.44606.rusty@rustcorp.com.au>
In-Reply-To: <200804210907.44606.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210909.23232.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets interrupt handler functions have their natural type
(ie. exactly match the data pointer type); it allows the old irq_handler_t
type as well.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/interrupt.h |   14 ++++++++++++--
 kernel/irq/devres.c       |   10 +++++-----
 kernel/irq/manage.c       |    6 +++---
 3 files changed, 20 insertions(+), 10 deletions(-)

diff -r b285fd1d3230 include/linux/interrupt.h
--- a/include/linux/interrupt.h	Mon Apr 07 15:48:58 2008 +1000
+++ b/include/linux/interrupt.h	Mon Apr 07 15:57:39 2008 +1000
@@ -69,13 +69,23 @@ struct irqaction {
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
-extern int __must_check request_irq(unsigned int, irq_handler_t handler,
+
+/* Typesafe version of request_irq.  Also takes old-style void * handlers. */
+#define request_irq(irq, handler, flags, name, dev_id)			\
+	__request_irq((irq), typesafe_cb_preargs(int,(handler),(dev_id),int), \
+		      (flags), (name), (dev_id))
+
+extern int __must_check __request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
 
 struct device;
 
-extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
+#define devm_request_irq(dev, irq, handler, flags, name, dev_id)	\
+	__devm_request_irq((dev), (irq),				\
+			   typesafe_cb_preargs(int, (handler), (dev_id), int), \
+			   (flags), (name), (dev_id))
+extern int __must_check __devm_request_irq(struct device *dev, unsigned int irq,
 			    irq_handler_t handler, unsigned long irqflags,
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
diff -r b285fd1d3230 kernel/irq/devres.c
--- a/kernel/irq/devres.c	Mon Apr 07 15:48:58 2008 +1000
+++ b/kernel/irq/devres.c	Mon Apr 07 15:57:39 2008 +1000
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
diff -r b285fd1d3230 kernel/irq/manage.c
--- a/kernel/irq/manage.c	Mon Apr 07 15:48:58 2008 +1000
+++ b/kernel/irq/manage.c	Mon Apr 07 15:57:39 2008 +1000
@@ -517,8 +517,8 @@ EXPORT_SYMBOL(free_irq);
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
@@ -579,4 +579,4 @@ int request_irq(unsigned int irq, irq_ha
 
 	return retval;
 }
-EXPORT_SYMBOL(request_irq);
+EXPORT_SYMBOL(__request_irq);
