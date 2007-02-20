Return-Path: <linux-kernel-owner+w=401wt.eu-S1750995AbXBTJUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995AbXBTJUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 04:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXBTJUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 04:20:34 -0500
Received: from mail.atmel.fr ([81.80.104.162]:64592 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbXBTJUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 04:20:33 -0500
Message-ID: <45DABD2F.8000805@rfo.atmel.com>
Date: Tue, 20 Feb 2007 10:19:43 +0100
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@insightbb.com>
CC: David Brownell <david-b@pacbell.net>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, tony@atomide.com,
       imre.deak@solidboot.com
Subject: [PATCH] input/spi: add ads7843 support to ads7846 touchscreen driver
References: <20061222192536.A206A1F0CDB@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200702161108.51014.david-b@pacbell.net>	
	 <45D99C81.7080401@rfo.atmel.com> <200702191046.43909.david-b@pacbell.net>
In-Reply-To: <200702191046.43909.david-b@pacbell.net>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the ads7843 touchscreen controller to the ads7846
driver code.

The ads7843 support has now become almost trivial since the last
rework.

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com> 
---
Index: linux-2.6.20-at91/drivers/input/touchscreen/ads7846.c
===================================================================
--- linux-2.6.20-at91.orig/drivers/input/touchscreen/ads7846.c
+++ linux-2.6.20-at91/drivers/input/touchscreen/ads7846.c
@@ -39,7 +39,8 @@
 /*
  * This code has been heavily tested on a Nokia 770, and lightly
  * tested on other ads7846 devices (OSK/Mistral, Lubbock).
- * Support for ads7843 and ads7845 has only been stubbed in.
+ * Support for ads7843 tested on Atmel at91sam926x-EK.
+ * Support for ads7845 has only been stubbed in.
  *
  * IRQ handling needs a workaround because of a shortcoming in handling
  * edge triggered IRQs on some platforms like the OMAP1/2. These
@@ -246,18 +247,16 @@ static int ads7846_read12_ser(struct dev
 
 	/* REVISIT:  take a few more samples, and compare ... */
 
-	/* maybe off internal vREF */
-	if (use_internal) {
-		req->ref_off = REF_OFF;
-		req->xfer[4].tx_buf = &req->ref_off;
-		req->xfer[4].len = 1;
-		spi_message_add_tail(&req->xfer[4], &req->msg);
-
-		req->xfer[5].rx_buf = &req->scratch;
-		req->xfer[5].len = 2;
-		CS_CHANGE(req->xfer[5]);
-		spi_message_add_tail(&req->xfer[5], &req->msg);
-	}
+	/* converter in low power mode & enable PENIRQ */
+	req->ref_off = PWRDOWN;
+	req->xfer[4].tx_buf = &req->ref_off;
+	req->xfer[4].len = 1;
+	spi_message_add_tail(&req->xfer[4], &req->msg);
+
+	req->xfer[5].rx_buf = &req->scratch;
+	req->xfer[5].len = 2;
+	CS_CHANGE(req->xfer[5]);
+	spi_message_add_tail(&req->xfer[5], &req->msg);
 
 	ts->irq_disabled = 1;
 	disable_irq(spi->irq);
@@ -536,6 +535,10 @@ static void ads7846_rx(void *ads)
 	} else
 		Rt = 0;
 
+	if (ts->model == 7843)
+		Rt = ts->pressure_max / 2;
+
+
 	/* Sample found inconsistent by debouncing or pressure is beyond
 	 * the maximum. Don't report it to user space, repeat at least
 	 * once more the measurement



