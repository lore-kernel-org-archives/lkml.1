Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZKMKmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZKMKmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbZKMKm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:42:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50080 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbZKMKmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:42:19 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 3/3] [V2] mpc52xx_spi: add gpio chipselect
Date: Fri, 13 Nov 2009 11:41:17 +0100
Message-Id: <1258108877-25435-4-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258108877-25435-3-git-send-email-l.fu@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
 <1258108877-25435-1-git-send-email-l.fu@pengutronix.de>
 <1258108877-25435-2-git-send-email-l.fu@pengutronix.de>
 <1258108877-25435-3-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one enables the mpc52xx_spi driver for usage of user defined gpio lines
as chipselect. This way we can control some more spi devices than only one

V2 Changes:
* preinitialize the gpio as output in probe function and call gpio_set_value in
  the chip select function instead of calling direction_output every time.
* initialize the gpio line with output high, since we don't support CS_HIGH
  in the driver currently any way. change gpio value setting to default active
  low in chip select call.
* free the gpio array while error or removing.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/spi/mpc52xx_spi.c |   64 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
index 64862cf..97beba2 100644
--- a/drivers/spi/mpc52xx_spi.c
+++ b/drivers/spi/mpc52xx_spi.c
@@ -21,6 +21,7 @@
 #include <linux/spi/mpc52xx_spi.h>
 #include <linux/of_spi.h>
 #include <linux/io.h>
+#include <linux/of_gpio.h>
 #include <asm/time.h>
 #include <asm/mpc52xx.h>
 
@@ -79,7 +80,6 @@ struct mpc52xx_spi {
 	spinlock_t lock;
 	struct work_struct work;
 
-
 	/* Details of current transfer (length, and buffer pointers) */
 	struct spi_message *message;	/* current message */
 	struct spi_transfer *transfer;	/* current transfer */
@@ -89,6 +89,8 @@ struct mpc52xx_spi {
 	u8 *rx_buf;
 	const u8 *tx_buf;
 	int cs_change;
+	int gpio_cs_count;
+	unsigned int *gpio_cs;
 };
 
 /*
@@ -96,7 +98,13 @@ struct mpc52xx_spi {
  */
 static void mpc52xx_spi_chipsel(struct mpc52xx_spi *ms, int value)
 {
-	out_8(ms->regs + SPI_PORTDATA, value ? 0 : 0x08);
+	int cs;
+
+	if (ms->gpio_cs_count > 0) {
+		cs = ms->message->spi->chip_select;
+		gpio_set_value(ms->gpio_cs[cs], value ? 0 : 1);
+	} else
+		out_8(ms->regs + SPI_PORTDATA, value ? 0 : 0x08);
 }
 
 /*
@@ -390,8 +398,9 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	struct spi_master *master;
 	struct mpc52xx_spi *ms;
 	void __iomem *regs;
-	int rc;
 	u8 ctrl1;
+	int rc, i = 0;
+	int gpio_cs;
 
 	/* MMIO registers */
 	dev_dbg(&op->dev, "probing mpc5200 SPI device\n");
@@ -426,8 +435,8 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 		rc = -ENOMEM;
 		goto err_alloc;
 	}
+
 	master->bus_num = -1;
-	master->num_chipselect = 1;
 	master->setup = mpc52xx_spi_setup;
 	master->transfer = mpc52xx_spi_transfer;
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
@@ -441,6 +450,40 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	ms->irq1 = irq_of_parse_and_map(op->node, 1);
 	ms->state = mpc52xx_spi_fsmstate_idle;
 	ms->ipb_freq = mpc5xxx_get_bus_frequency(op->node);
+	ms->gpio_cs_count = of_gpio_count(op->node);
+	if (ms->gpio_cs_count > 0) {
+		master->num_chipselect = ms->gpio_cs_count;
+		ms->gpio_cs = kmalloc(ms->gpio_cs_count * sizeof(unsigned int),
+				GFP_KERNEL);
+		if (!ms->gpio_cs) {
+			rc = -ENOMEM;
+			goto err_alloc;
+		}
+
+		for (i = 0; i < ms->gpio_cs_count; i++) {
+			gpio_cs = of_get_gpio(op->node, i);
+			if (gpio_cs < 0) {
+				dev_err(&op->dev,
+					"could not parse the gpio field "
+					"in oftree\n");
+				rc = -ENODEV;
+				goto err_gpio;
+			}
+
+			rc = gpio_request(gpio_cs, dev_name(&op->dev));
+			if (rc) {
+				dev_err(&op->dev,
+					"can't request spi cs gpio #%d "
+					"on gpio line %d\n", i, gpio_cs);
+				goto err_gpio;
+			}
+
+			gpio_direction_output(gpio_cs, 1);
+			ms->gpio_cs[i] = gpio_cs;
+		}
+	} else
+		master->num_chipselect = 1;
+
 	spin_lock_init(&ms->lock);
 	INIT_LIST_HEAD(&ms->queue);
 	INIT_WORK(&ms->work, mpc52xx_spi_wq);
@@ -477,6 +520,12 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
  err_register:
 	dev_err(&ms->master->dev, "initialization failed\n");
 	spi_master_put(master);
+ err_gpio:
+	while (i-- > 0)
+		gpio_free(ms->gpio_cs[i]);
+
+	if (ms->gpio_cs != NULL)
+		kfree(ms->gpio_cs);
  err_alloc:
  err_init:
 	iounmap(regs);
@@ -487,10 +536,17 @@ static int __devexit mpc52xx_spi_remove(struct of_device *op)
 {
 	struct spi_master *master = dev_get_drvdata(&op->dev);
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
+	int i;
 
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
+	for (i = 0; i < ms->gpio_cs_count; i++)
+		gpio_free(ms->gpio_cs[i]);
+
+	if (ms->gpio_cs != NULL)
+		kfree(ms->gpio_cs);
+
 	spi_unregister_master(master);
 	spi_master_put(master);
 	iounmap(ms->regs);
-- 
1.6.5.2

