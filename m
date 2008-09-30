Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYI3KYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYI3KYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYI3KXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:23:42 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:33879 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYI3KXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:23:38 -0400
Message-Id: <20080930102336.554569899@zoo.weinigel.se>
References: <20080930102313.418263345@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Tue, 30 Sep 2008 12:23:16 +0200
From: Christer Weinigel <christer@weinigel.se>
To: drzeus-list@drzeus.cx
Cc: Christer Weinigel <christer.weinigel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 3/3] RFC: Low-latency SDIO, add hard interrupt handlers
Content-Disposition: inline; filename=sdio-async-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, the goal of all these changes, add a hard SDIO interrupt
handler which will be called directly from interrupt context.

Nothing really tricky here, the patch adds a new function
sdio_claim_hard_irq and moves the common code from sdio_hard_irq into
__sdio_claim_irq.  It also adds some code that calls the hard
interrupt handler directly from interrupt context.

One very important thing here is that since the hard interrupt handler
will return immediately, it has to call sdio_release_host when it is
done.  The call to sdio_kick_irq do the right thing, either process
the next hard interrupt, wake up the soft interrupt workqueue or
return 0 which really releases the host.

This work is done for my employer, CSR.

Signed-off-by: Christer Weinigel CSR <christer.weinigel@csr.com>

Index: linux-2.6.26.2/include/linux/mmc/sdio_func.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/mmc/sdio_func.h
+++ linux-2.6.26.2/include/linux/mmc/sdio_func.h
@@ -15,6 +15,8 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 
+#define SDIO_HAVE_HARD_IRQ 1
+
 struct mmc_card;
 struct sdio_func;
 
@@ -36,7 +38,8 @@ struct sdio_func_tuple {
 struct sdio_func {
 	struct mmc_card		*card;		/* the card this device belongs to */
 	struct device		dev;		/* the device */
-	sdio_irq_handler_t	*irq_handler;	/* IRQ callback */
+	sdio_irq_handler_t	*irq_handler;	/* IRQ thread callback */
+	sdio_irq_handler_t	*hard_irq_handler; /* hard IRQ callback */
 	unsigned int		num;		/* function number */
 
 	unsigned char		class;		/* standard interface class */
@@ -110,6 +113,8 @@ extern void sdio_unregister_driver(struc
  * SDIO I/O operations
  */
 extern void sdio_claim_host(struct sdio_func *func);
+extern int sdio_claim_hard_irq(struct sdio_func *func,
+			       sdio_irq_handler_t *handler);
 extern void sdio_release_host(struct sdio_func *func);
 
 extern int sdio_enable_func(struct sdio_func *func);
Index: linux-2.6.26.2/drivers/mmc/core/sdio_irq.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/core/sdio_irq.c
+++ linux-2.6.26.2/drivers/mmc/core/sdio_irq.c
@@ -23,8 +23,27 @@
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
 
+#include "core.h"
 #include "sdio_ops.h"
 
+static int sdio_process_hard_irqs(struct mmc_card *card)
+{
+	int i;
+
+	for (i = 1; i <= 7; i++) {
+		if (card->pending_irqs & (1 << i)) {
+			struct sdio_func *func = card->sdio_func[i - 1];
+			if (func && func->hard_irq_handler) {
+				card->pending_irqs &= ~(1 << i);
+				func->hard_irq_handler(func);
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
 static int process_sdio_pending_irqs(struct mmc_card *card)
 {
 	int i, ret, count;
@@ -150,7 +169,8 @@ int sdio_kick_irq(struct mmc_host *host)
 		return 0;
 
 	if (host->sdio_irqs && host->card->pending_irqs) {
-		queue_work(host->irq_workqueue, &host->irq_work);
+		if (!sdio_process_hard_irqs(host->card))
+			queue_work(host->irq_workqueue, &host->irq_work);
 		return 1;
 	}
 
@@ -181,6 +201,12 @@ void mmc_signal_sdio_irq(struct mmc_host
 		return;
 	}
 
+	if (!host->card) {
+		pr_debug("%s: card is removed\n", __func__);
+		mmc_release_host(host);
+		return;
+	}
+
 	mmc_io_rw_direct_start(host->card, 0, 0, SDIO_CCCR_INTx, 0, 1,
 			       sdio_irq_pending_done, host);
 }
@@ -223,17 +249,8 @@ static void sdio_irq_pending_done(struct
 	mmc_release_host(host);
 }
 
-/**
- *	sdio_claim_irq - claim the IRQ for a SDIO function
- *	@func: SDIO function
- *	@handler: IRQ handler callback
- *
- *	Claim and activate the IRQ for the given SDIO function. The provided
- *	handler will be called when that IRQ is asserted.  The host is always
- *	claimed already when the handler is called so the handler must not
- *	call sdio_claim_host() nor sdio_release_host().
- */
-int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
+static int __sdio_claim_irq(struct sdio_func *func,
+			    sdio_irq_handler_t *handler, bool hard)
 {
 	int ret;
 	unsigned char reg;
@@ -243,7 +260,7 @@ int sdio_claim_irq(struct sdio_func *fun
 
 	pr_debug("SDIO: Enabling IRQ for %s...\n", sdio_func_id(func));
 
-	if (func->irq_handler) {
+	if (func->irq_handler || func->hard_irq_handler) {
 		pr_debug("SDIO: IRQ for %s already in use.\n", sdio_func_id(func));
 		return -EBUSY;
 	}
@@ -260,16 +277,54 @@ int sdio_claim_irq(struct sdio_func *fun
 	if (ret)
 		return ret;
 
-	func->irq_handler = handler;
+	if (hard)
+		func->hard_irq_handler = handler;
+	else
+		func->irq_handler = handler;
 	ret = sdio_card_irq_get(func->card);
-	if (ret)
+	if (ret) {
 		func->irq_handler = NULL;
+		func->hard_irq_handler = NULL;
+	}
 
 	return ret;
 }
+
+/**
+ *	sdio_claim_irq - claim the IRQ for a SDIO function
+ *	@func: SDIO function
+ *	@handler: IRQ handler callback
+ *
+ *	Claim and activate the IRQ for the given SDIO function. The provided
+ *	handler will be called when that IRQ is asserted.  The host is always
+ *	claimed already when the handler is called so the handler must not
+ *	call sdio_claim_host() nor sdio_release_host().
+ */
+int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
+{
+	return __sdio_claim_irq(func, handler, 0);
+}
 EXPORT_SYMBOL_GPL(sdio_claim_irq);
 
 /**
+ *	sdio_claim_hard_irq - claim the IRQ for a SDIO function
+ *	@func: SDIO function
+ *	@handler: IRQ handler callback
+ *
+ *	Claim and activate the IRQ for the given SDIO function. The
+ *	provided handler will be called directly from the interrupt
+ *	handler when that IRQ is asserted, so the function can not
+ *	sleep.  The host is always claimed already when the handler is
+ *	called so the handler must not call sdio_claim_host().  When
+ *	handler is done the function should call sdio_release_host().
+ */
+int sdio_claim_hard_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
+{
+	return __sdio_claim_irq(func, handler, 1);
+}
+EXPORT_SYMBOL_GPL(sdio_claim_hard_irq);
+
+/**
  *	sdio_release_irq - release the IRQ for a SDIO function
  *	@func: SDIO function
  *
@@ -287,6 +342,7 @@ int sdio_release_irq(struct sdio_func *f
 
 	if (func->irq_handler) {
 		func->irq_handler = NULL;
+		func->hard_irq_handler = NULL;
 		sdio_card_irq_put(func->card);
 	}
 

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
