Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZKJJNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZKJJNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZKJJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:12:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34859 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbZKJJM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:12:26 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       l.fu@pengutronix.de
Subject: [PATCH 3/3] mpc52xx_spi: add gpio chipselect
Date: Tue, 10 Nov 2009 10:12:09 +0100
Message-Id: <1257844329-20687-4-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257844329-20687-3-git-send-email-l.fu@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
 <1257844329-20687-2-git-send-email-l.fu@pengutronix.de>
 <1257844329-20687-3-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one enables the mpc52xx_spi driver for usage of user defined gpio lines
as chipselect. This way we can control some more spi devices than only one

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/spi/mpc52xx_spi.c |   57 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
index 79ba678..58c2ce5 100644
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
+		gpio_direction_output(ms->gpio_cs[cs], value);
+	} else
+		out_8(ms->regs + SPI_PORTDATA, value ? 0 : 0x08);
 }
 
 /*
@@ -390,8 +398,9 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	struct spi_master *master;
 	struct mpc52xx_spi *ms;
 	void __iomem *regs;
-	int rc;
 	int ctrl1;
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
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST;
@@ -441,6 +450,39 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
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
+				goto err_alloc;
+			}
+
+			ms->gpio_cs[i] = gpio_cs;
+			rc = gpio_request(ms->gpio_cs[i], dev_name(&op->dev));
+			if (rc) {
+				dev_err(&op->dev,
+					"can't request spi cs gpio #%d "
+					"on gpio line %d\n",
+					i, gpio_cs);
+				goto err_gpio;
+			}
+		}
+	} else
+		master->num_chipselect = 1;
+
 	spin_lock_init(&ms->lock);
 	INIT_LIST_HEAD(&ms->queue);
 	INIT_WORK(&ms->work, mpc52xx_spi_wq);
@@ -477,6 +519,9 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
  err_register:
 	dev_err(&ms->master->dev, "initialization failed\n");
 	spi_master_put(master);
+ err_gpio:
+	while (i-- > 0)
+		gpio_free(ms->gpio_cs[i]);
  err_alloc:
  err_init:
 	iounmap(regs);
@@ -487,10 +532,14 @@ static int __devexit mpc52xx_spi_remove(struct of_device *op)
 {
 	struct spi_master *master = dev_get_drvdata(&op->dev);
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
+	int i;
 
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
+	for (i = 0; i < ms->gpio_cs_count; i++)
+		gpio_free(ms->gpio_cs[i]);
+
 	spi_unregister_master(master);
 	spi_master_put(master);
 	iounmap(ms->regs);
-- 
1.6.5.2

