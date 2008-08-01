Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbYHAPSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbYHAPSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYHAPRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:17:42 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59976 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbYHAPRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:17:40 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 3/4] atmel_spi: Use CSR0 for all chip selects on V2 controllers
Date: Fri,  1 Aug 2008 17:17:15 +0200
Message-Id: <1217603836-21243-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1217603836-21243-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1217603836-21243-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1217603836-21243-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 01 Aug 2008 15:17:17.0612 (UTC) FILETIME=[AF6C9EC0:01C8F3E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This solves several issues:
  * It fixes the wrong idle clock polarity issue in a cleaner and less
    expensive way.
  * It handles the AT32AP7000 errata "SPI Chip Select 0 BITS field
    overrides other Chip Selects". Other chips, e.g. AT91SAM9261, have
    similar issues.

Currently, the AT91RM9200 code path is left alone. But it might be
interesting to try the same technique on RM9200 using a different CSR
register.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/spi/atmel_spi.c |   95 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 88239ca..f4d60ec 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -51,6 +51,12 @@ struct atmel_spi {
 	dma_addr_t		buffer_dma;
 };
 
+/* Controller-specific per-slave state */
+struct atmel_spi_device {
+	unsigned int		npcs_pin;
+	u32			csr;
+};
+
 #define BUFFER_SIZE		PAGE_SIZE
 #define INVALID_DMA_ADDRESS	0xffffffff
 
@@ -89,39 +95,54 @@ static bool atmel_spi_is_v2(void)
  * Master on Chip Select 0.")  No workaround exists for that ... so for
  * nCS0 on that chip, we (a) don't use the GPIO, (b) can't support CS_HIGH,
  * and (c) will trigger that first erratum in some cases.
+ *
+ * TODO: Test if the atmel_spi_is_v2() branch below works on
+ * AT91RM9200 if we use some other register than CSR0. However, don't
+ * do this unconditionally since AP7000 has an errata where the BITS
+ * field in CSR0 overrides all other CSRs.
  */
 
 static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 {
-	unsigned gpio = (unsigned) spi->controller_data;
+	struct atmel_spi_device *asd = spi->controller_state;
 	unsigned active = spi->mode & SPI_CS_HIGH;
-	u32 mr;
-	int i;
-	u32 csr;
-	u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
-
-	/* Make sure clock polarity is correct */
-	for (i = 0; i < spi->master->num_chipselect; i++) {
-		csr = spi_readl(as, CSR0 + 4 * i);
-		if ((csr ^ cpol) & SPI_BIT(CPOL))
-			spi_writel(as, CSR0 + 4 * i, csr ^ SPI_BIT(CPOL));
-	}
 
-	mr = spi_readl(as, MR);
-	mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
-
-	dev_dbg(&spi->dev, "activate %u%s, mr %08x\n",
-			gpio, active ? " (high)" : "",
-			mr);
+	if (atmel_spi_is_v2()) {
+		/*
+		 * Always use CSR0. This ensures that the clock
+		 * switches to the correct idle polarity before we
+		 * toggle the CS.
+		 */
+		spi_writel(as, CSR0, asd->csr);
+		spi_writel(as, MR, SPI_BF(PCS, 0x0e) | SPI_BIT(MODFDIS)
+				| SPI_BIT(MSTR));
+		spi_readl(as, MR);
+		gpio_set_value(asd->npcs_pin, active);
+	} else {
+		u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
+		int i;
+		u32 mr;
+		u32 csr;
+
+		/* Make sure clock polarity is correct */
+		for (i = 0; i < spi->master->num_chipselect; i++) {
+			csr = spi_readl(as, CSR0 + 4 * i);
+			if ((csr ^ cpol) & SPI_BIT(CPOL))
+				spi_writel(as, CSR0 + 4 * i,
+						csr ^ SPI_BIT(CPOL));
+		}
 
-	if (atmel_spi_is_v2() || spi->chip_select != 0)
-		gpio_set_value(gpio, active);
-	spi_writel(as, MR, mr);
+		mr = spi_readl(as, MR);
+		mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
+		if (spi->chip_select != 0)
+			gpio_set_value(asd->npcs_pin, active);
+		spi_writel(as, MR, mr);
+	}
 }
 
 static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 {
-	unsigned gpio = (unsigned) spi->controller_data;
+	struct atmel_spi_device *asd = spi->controller_state;
 	unsigned active = spi->mode & SPI_CS_HIGH;
 	u32 mr;
 
@@ -135,11 +156,11 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 	}
 
 	dev_dbg(&spi->dev, "DEactivate %u%s, mr %08x\n",
-			gpio, active ? " (low)" : "",
+			asd->npcs_pin, active ? " (low)" : "",
 			mr);
 
 	if (atmel_spi_is_v2() || spi->chip_select != 0)
-		gpio_set_value(gpio, !active);
+		gpio_set_value(asd->npcs_pin, !active);
 }
 
 static inline int atmel_spi_xfer_is_last(struct spi_message *msg,
@@ -511,6 +532,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 static int atmel_spi_setup(struct spi_device *spi)
 {
 	struct atmel_spi	*as;
+	struct atmel_spi_device	*asd;
 	u32			scbr, csr;
 	unsigned int		bits = spi->bits_per_word;
 	unsigned long		bus_hz;
@@ -595,11 +617,20 @@ static int atmel_spi_setup(struct spi_device *spi)
 
 	/* chipselect must have been muxed as GPIO (e.g. in board setup) */
 	npcs_pin = (unsigned int)spi->controller_data;
-	if (!spi->controller_state) {
+	asd = spi->controller_state;
+	if (!asd) {
+		asd = kzalloc(sizeof(struct atmel_spi_device), GFP_KERNEL);
+		if (!asd)
+			return -ENOMEM;
+
 		ret = gpio_request(npcs_pin, spi->dev.bus_id);
-		if (ret)
+		if (ret) {
+			kfree(asd);
 			return ret;
-		spi->controller_state = (void *)npcs_pin;
+		}
+
+		asd->npcs_pin = npcs_pin;
+		spi->controller_state = asd;
 		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
 	} else {
 		unsigned long		flags;
@@ -611,11 +642,14 @@ static int atmel_spi_setup(struct spi_device *spi)
 		spin_unlock_irqrestore(&as->lock, flags);
 	}
 
+	asd->csr = csr;
+
 	dev_dbg(&spi->dev,
 		"setup: %lu Hz bpw %u mode 0x%x -> csr%d %08x\n",
 		bus_hz / scbr, bits, spi->mode, spi->chip_select, csr);
 
-	spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
+	if (!atmel_spi_is_v2())
+		spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
 
 	return 0;
 }
@@ -690,10 +724,11 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 static void atmel_spi_cleanup(struct spi_device *spi)
 {
 	struct atmel_spi	*as = spi_master_get_devdata(spi->master);
+	struct atmel_spi_device	*asd = spi->controller_state;
 	unsigned		gpio = (unsigned) spi->controller_data;
 	unsigned long		flags;
 
-	if (!spi->controller_state)
+	if (!asd)
 		return;
 
 	spin_lock_irqsave(&as->lock, flags);
@@ -703,7 +738,9 @@ static void atmel_spi_cleanup(struct spi_device *spi)
 	}
 	spin_unlock_irqrestore(&as->lock, flags);
 
+	spi->controller_state = NULL;
 	gpio_free(gpio);
+	kfree(asd);
 }
 
 /*-------------------------------------------------------------------------*/
-- 
1.5.6.3

