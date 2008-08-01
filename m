Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYHAPS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYHAPS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYHAPRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:17:48 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59984 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbYHAPRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:17:47 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 2/4] atmel_spi: Clean up SPIv1 quirk handling
Date: Fri,  1 Aug 2008 17:17:14 +0200
Message-Id: <1217603836-21243-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1217603836-21243-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1217603836-21243-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 01 Aug 2008 15:17:17.0581 (UTC) FILETIME=[AF67E3D0:01C8F3E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we have a flag called "new_1" which is basically equivalent
to cpu_is_at91rm9200(). The latter is also called directly a few places.

Clean up this mess by introducing a atmel_spi_v2() function for
determining the controller version, and move all version dependent code
over to use it. This allows us to remove the new_1 flag.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/spi/atmel_spi.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 95190c6..88239ca 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -30,13 +30,6 @@
  * The core SPI transfer engine just talks to a register bank to set up
  * DMA transfers; transfer queue progress is driven by IRQs.  The clock
  * framework provides the base clock, subdivided for each spi_device.
- *
- * Newer controllers, marked with "new_1" flag, have:
- *  - CR.LASTXFER
- *  - SPI_MR.DIV32 may become FDIV or must-be-zero (here: always zero)
- *  - SPI_SR.TXEMPTY, SPI_SR.NSSR (and corresponding irqs)
- *  - SPI_CSRx.CSAAT
- *  - SPI_CSRx.SBCR allows faster clocking
  */
 struct atmel_spi {
 	spinlock_t		lock;
@@ -45,7 +38,6 @@ struct atmel_spi {
 	int			irq;
 	struct clk		*clk;
 	struct platform_device	*pdev;
-	unsigned		new_1:1;
 	struct spi_device	*stay;
 
 	u8			stopping;
@@ -63,6 +55,23 @@ struct atmel_spi {
 #define INVALID_DMA_ADDRESS	0xffffffff
 
 /*
+ * Version 2 of the SPI controller has
+ *  - CR.LASTXFER
+ *  - SPI_MR.DIV32 may become FDIV or must-be-zero (here: always zero)
+ *  - SPI_SR.TXEMPTY, SPI_SR.NSSR (and corresponding irqs)
+ *  - SPI_CSRx.CSAAT
+ *  - SPI_CSRx.SBCR allows faster clocking
+ *
+ * We can determine the controller version by reading the VERSION
+ * register, but I haven't checked that it exists on all chips, and
+ * this is cheaper anyway.
+ */
+static bool atmel_spi_is_v2(void)
+{
+	return !cpu_is_at91rm9200();
+}
+
+/*
  * Earlier SPI controllers (e.g. on at91rm9200) have a design bug whereby
  * they assume that spi slave device state will not change on deselect, so
  * that automagic deselection is OK.  ("NPCSx rises if no data is to be
@@ -105,7 +114,7 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 			gpio, active ? " (high)" : "",
 			mr);
 
-	if (!(cpu_is_at91rm9200() && spi->chip_select == 0))
+	if (atmel_spi_is_v2() || spi->chip_select != 0)
 		gpio_set_value(gpio, active);
 	spi_writel(as, MR, mr);
 }
@@ -129,7 +138,7 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 			gpio, active ? " (low)" : "",
 			mr);
 
-	if (!(cpu_is_at91rm9200() && spi->chip_select == 0))
+	if (atmel_spi_is_v2() || spi->chip_select != 0)
 		gpio_set_value(gpio, !active);
 }
 
@@ -536,19 +545,16 @@ static int atmel_spi_setup(struct spi_device *spi)
 	}
 
 	/* see notes above re chipselect */
-	if (cpu_is_at91rm9200()
+	if (!atmel_spi_is_v2()
 			&& spi->chip_select == 0
 			&& (spi->mode & SPI_CS_HIGH)) {
 		dev_dbg(&spi->dev, "setup: can't be active-high\n");
 		return -EINVAL;
 	}
 
-	/*
-	 * Pre-new_1 chips start out at half the peripheral
-	 * bus speed.
-	 */
+	/* v1 chips start out at half the peripheral bus speed. */
 	bus_hz = clk_get_rate(as->clk);
-	if (!as->new_1)
+	if (!atmel_spi_is_v2())
 		bus_hz /= 2;
 
 	if (spi->max_speed_hz) {
@@ -755,8 +761,6 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
 		goto out_free_buffer;
 	as->irq = irq;
 	as->clk = clk;
-	if (!cpu_is_at91rm9200())
-		as->new_1 = 1;
 
 	ret = request_irq(irq, atmel_spi_interrupt, 0,
 			pdev->dev.bus_id, master);
-- 
1.5.6.3

