Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYBDRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYBDRNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbYBDRNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:13:02 -0500
Received: from mail.atmel.fr ([81.80.104.162]:54888 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbYBDRNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:13:00 -0500
Message-ID: <47A74790.50207@atmel.com>
Date: Mon, 04 Feb 2008 18:12:48 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>, David Brownell <david-b@pacbell.net>
CC: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Victor <linux@maxim.org.za>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] at91_mci:  use generic GPIO calls
References: <200802011901.27532.david-b@pacbell.net>
In-Reply-To: <200802011901.27532.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Update the AT91 MMC driver to use the generic GPIO calls instead of the
AT91-specific calls; and to request (and release) those GPIO signals.

That required updating the probe() fault cleanup codepaths.  Now there
is a single sequence for freeing resources, in reverse order of their
allocation.  Also that code uses use dev_*() for messaging, and has less
abuse of KERN_ERR.

Likewise with updating remove() cleanup.  This had to free the GPIOs,
and while adding that code I noticed and fixed two other problems:  it
was poking at a workqueue owned by the mmc core; and in one (rare)
case would try freeing an IRQ that it didn't allocate.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Little update from previous patch to match the modification introduced
by :
http://lkml.org/lkml/2008/1/30/308
So it applies on to of it.

 drivers/mmc/host/at91_mci.c |  114 ++++++++++++++++++++++++++++++--------------
 1 file changed, 80 insertions(+), 34 deletions(-)

--- linux-2.6-snapshot.orig/drivers/mmc/host/at91_mci.c
+++ linux-2.6-snapshot/drivers/mmc/host/at91_mci.c
@@ -70,10 +70,11 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/gpio.h>
+
 #include <asm/mach/mmc.h>
 #include <asm/arch/board.h>
 #include <asm/arch/cpu.h>
-#include <asm/arch/gpio.h>
 #include <asm/arch/at91_mci.h>
 
 #define DRIVER_NAME "at91_mci"
@@ -659,10 +660,10 @@ static void at91_mci_set_ios(struct mmc_
 	if (host->board->vcc_pin) {
 		switch (ios->power_mode) {
 		case MMC_POWER_OFF:
-			at91_set_gpio_value(host->board->vcc_pin, 0);
+			gpio_set_value(host->board->vcc_pin, 0);
 			break;
 		case MMC_POWER_UP:
-			at91_set_gpio_value(host->board->vcc_pin, 1);
+			gpio_set_value(host->board->vcc_pin, 1);
 			break;
 		default:
 			break;
@@ -769,7 +770,7 @@ static irqreturn_t at91_mci_irq(int irq,
 static irqreturn_t at91_mmc_det_irq(int irq, void *_host)
 {
 	struct at91mci_host *host = _host;
-	int present = !at91_get_gpio_value(irq);
+	int present = !gpio_get_value(irq_to_gpio(irq));
 
 	/*
 	 * we expect this irq on both insert and remove,
@@ -794,7 +795,7 @@ static int at91_mci_get_ro(struct mmc_ho
 	struct at91mci_host *host = mmc_priv(mmc);
 
 	if (host->board->wp_pin) {
-		read_only = at91_get_gpio_value(host->board->wp_pin);
+		read_only = gpio_get_value(host->board->wp_pin);
 		printk(KERN_WARNING "%s: card is %s\n", mmc_hostname(mmc),
 				(read_only ? "read-only" : "read-write") );
 	}
@@ -821,8 +822,6 @@ static int __init at91_mci_probe(struct 
 	struct resource *res;
 	int ret;
 
-	pr_debug("Probe MCI devices\n");
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENXIO;
@@ -832,9 +831,9 @@ static int __init at91_mci_probe(struct 
 
 	mmc = mmc_alloc_host(sizeof(struct at91mci_host), &pdev->dev);
 	if (!mmc) {
-		pr_debug("Failed to allocate mmc host\n");
-		release_mem_region(res->start, res->end - res->start + 1);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "couldn't allocate mmc host\n");
+		goto fail6;
 	}
 
 	mmc->ops = &at91_mci_ops;
@@ -854,19 +853,44 @@ static int __init at91_mci_probe(struct 
 		if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
 			mmc->caps |= MMC_CAP_4_BIT_DATA;
 		else
-			printk("AT91 MMC: 4 wire bus mode not supported"
+			dev_warn(&pdev->dev, "4 wire bus mode not supported"
 				" - using 1 wire\n");
 	}
 
 	/*
+	 * Reserve GPIOs ... board init code makes sure these pins are set
+	 * up as GPIOs with the right direction (input, except for vcc)
+	 */
+	if (host->board->det_pin) {
+		ret = gpio_request(host->board->det_pin, "mmc_detect");
+		if (ret < 0) {
+			dev_dbg(&pdev->dev, "couldn't claim card detect pin\n");
+			goto fail5;
+		}
+	}
+	if (host->board->wp_pin) {
+		ret = gpio_request(host->board->wp_pin, "mmc_wp");
+		if (ret < 0) {
+			dev_dbg(&pdev->dev, "couldn't claim wp sense pin\n");
+			goto fail4;
+		}
+	}
+	if (host->board->vcc_pin) {
+		ret = gpio_request(host->board->vcc_pin, "mmc_vcc");
+		if (ret < 0) {
+			dev_dbg(&pdev->dev, "couldn't claim vcc switch pin\n");
+			goto fail3;
+		}
+	}
+
+	/*
 	 * Get Clock
 	 */
 	host->mci_clk = clk_get(&pdev->dev, "mci_clk");
 	if (IS_ERR(host->mci_clk)) {
-		printk(KERN_ERR "AT91 MMC: no clock defined.\n");
-		mmc_free_host(mmc);
-		release_mem_region(res->start, res->end - res->start + 1);
-		return -ENODEV;
+		ret = -ENODEV;
+		dev_dbg(&pdev->dev, "no mci_clk?\n");
+		goto fail2;
 	}
 
 	/*
@@ -874,10 +898,8 @@ static int __init at91_mci_probe(struct 
 	 */
 	host->baseaddr = ioremap(res->start, res->end - res->start + 1);
 	if (!host->baseaddr) {
-		clk_put(host->mci_clk);
-		mmc_free_host(mmc);
-		release_mem_region(res->start, res->end - res->start + 1);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto fail1;
 	}
 
 	/*
@@ -891,15 +913,11 @@ static int __init at91_mci_probe(struct 
 	 * Allocate the MCI interrupt
 	 */
 	host->irq = platform_get_irq(pdev, 0);
-	ret = request_irq(host->irq, at91_mci_irq, IRQF_SHARED, DRIVER_NAME, host);
+	ret = request_irq(host->irq, at91_mci_irq, IRQF_SHARED,
+			mmc_hostname(mmc), host);
 	if (ret) {
-		printk(KERN_ERR "AT91 MMC: Failed to request MCI interrupt\n");
-		clk_disable(host->mci_clk);
-		clk_put(host->mci_clk);
-		mmc_free_host(mmc);
-		iounmap(host->baseaddr);
-		release_mem_region(res->start, res->end - res->start + 1);
-		return ret;
+		dev_dbg(&pdev->dev, "request MCI interrupt failed\n");
+		goto fail0;
 	}
 
 	platform_set_drvdata(pdev, mmc);
@@ -908,8 +926,7 @@ static int __init at91_mci_probe(struct 
 	 * Add host to MMC layer
 	 */
 	if (host->board->det_pin) {
-		host->present = !at91_get_gpio_value(host->board->det_pin);
-		device_init_wakeup(&pdev->dev, 1);
+		host->present = !gpio_get_value(host->board->det_pin);
 	}
 	else
 		host->present = -1;
@@ -920,15 +937,38 @@ static int __init at91_mci_probe(struct 
 	 * monitor card insertion/removal if we can
 	 */
 	if (host->board->det_pin) {
-		ret = request_irq(host->board->det_pin, at91_mmc_det_irq,
-				0, DRIVER_NAME, host);
+		ret = request_irq(gpio_to_irq(host->board->det_pin),
+				at91_mmc_det_irq, 0, mmc_hostname(mmc), host);
 		if (ret)
-			printk(KERN_ERR "AT91 MMC: Couldn't allocate MMC detect irq\n");
+			dev_warn(&pdev->dev, "request MMC detect irq failed\n");
+		else
+			device_init_wakeup(&pdev->dev, 1);
 	}
 
 	pr_debug("Added MCI driver\n");
 
 	return 0;
+
+fail0:
+	clk_disable(host->mci_clk);
+	iounmap(host->baseaddr);
+fail1:
+	clk_put(host->mci_clk);
+fail2:
+	if (host->board->vcc_pin)
+		gpio_free(host->board->vcc_pin);
+fail3:
+	if (host->board->wp_pin)
+		gpio_free(host->board->wp_pin);
+fail4:
+	if (host->board->det_pin)
+		gpio_free(host->board->det_pin);
+fail5:
+	mmc_free_host(mmc);
+fail6:
+	release_mem_region(res->start, res->end - res->start + 1);
+	dev_err(&pdev->dev, "probe failed, err %d\n", ret);
+	return ret;
 }
 
 /*
@@ -946,9 +986,10 @@ static int __exit at91_mci_remove(struct
 	host = mmc_priv(mmc);
 
 	if (host->board->det_pin) {
+		if (device_can_wakeup(&pdev->dev))
+			free_irq(gpio_to_irq(host->board->det_pin), host);
 		device_init_wakeup(&pdev->dev, 0);
-		free_irq(host->board->det_pin, host);
-		cancel_delayed_work(&host->mmc->detect);
+		gpio_free(host->board->det_pin);
 	}
 
 	at91_mci_disable(host);
@@ -958,6 +999,11 @@ static int __exit at91_mci_remove(struct
 	clk_disable(host->mci_clk);			/* Disable the peripheral clock */
 	clk_put(host->mci_clk);
 
+	if (host->board->vcc_pin)
+		gpio_free(host->board->vcc_pin);
+	if (host->board->wp_pin)
+		gpio_free(host->board->wp_pin);
+
 	iounmap(host->baseaddr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, res->end - res->start + 1);

