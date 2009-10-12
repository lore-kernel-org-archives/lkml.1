Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbZJLQun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbZJLQun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932814AbZJLQum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:50:42 -0400
Received: from ru.mvista.com ([213.79.90.228]:55728 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932815AbZJLQuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:50:37 -0400
Date: Mon, 12 Oct 2009 20:49:25 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] spi_mpc8xxx: Turn qe_mode into flags
Message-ID: <20091012164925.GG4578@oksana.dev.rtsoft.ru>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091012164841.GA32214@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon there will be more flags introduced in subsequent patches, so
let's turn qe_mode into flags.

Also introduce mpc8xxx_spi_strmode() and print current SPI mode.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_mpc8xxx.c   |   30 +++++++++++++++++++-----------
 include/linux/fsl_devices.h |    2 +-
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 4b119ea..80374df 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -96,7 +96,8 @@ struct mpc8xxx_spi {
 	u32 rx_shift;		/* RX data reg shift when in qe mode */
 	u32 tx_shift;		/* TX data reg shift when in qe mode */
 
-	bool qe_mode;
+	unsigned int flags;
+#define SPI_QE_CPU_MODE		(1 << 0) /* QE CPU ("PIO") mode */
 
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
@@ -235,14 +236,14 @@ int mpc8xxx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	if (bits_per_word <= 8) {
 		cs->get_rx = mpc8xxx_spi_rx_buf_u8;
 		cs->get_tx = mpc8xxx_spi_tx_buf_u8;
-		if (mpc8xxx_spi->qe_mode) {
+		if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
 			cs->rx_shift = 16;
 			cs->tx_shift = 24;
 		}
 	} else if (bits_per_word <= 16) {
 		cs->get_rx = mpc8xxx_spi_rx_buf_u16;
 		cs->get_tx = mpc8xxx_spi_tx_buf_u16;
-		if (mpc8xxx_spi->qe_mode) {
+		if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
 			cs->rx_shift = 16;
 			cs->tx_shift = 16;
 		}
@@ -252,7 +253,8 @@ int mpc8xxx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	} else
 		return -EINVAL;
 
-	if (mpc8xxx_spi->qe_mode && spi->mode & SPI_LSB_FIRST) {
+	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE &&
+			spi->mode & SPI_LSB_FIRST) {
 		cs->tx_shift = 0;
 		if (bits_per_word <= 8)
 			cs->rx_shift = 8;
@@ -518,6 +520,13 @@ static void mpc8xxx_spi_cleanup(struct spi_device *spi)
 	kfree(spi->controller_state);
 }
 
+static const char *mpc8xxx_spi_strmode(unsigned int flags)
+{
+	if (flags & SPI_QE_CPU_MODE)
+		return "QE CPU";
+	return "CPU";
+}
+
 static struct spi_master * __devinit
 mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 {
@@ -544,14 +553,14 @@ mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 	master->cleanup = mpc8xxx_spi_cleanup;
 
 	mpc8xxx_spi = spi_master_get_devdata(master);
-	mpc8xxx_spi->qe_mode = pdata->qe_mode;
 	mpc8xxx_spi->get_rx = mpc8xxx_spi_rx_buf_u8;
 	mpc8xxx_spi->get_tx = mpc8xxx_spi_tx_buf_u8;
+	mpc8xxx_spi->flags = pdata->flags;
 	mpc8xxx_spi->spibrg = pdata->sysclk;
 
 	mpc8xxx_spi->rx_shift = 0;
 	mpc8xxx_spi->tx_shift = 0;
-	if (mpc8xxx_spi->qe_mode) {
+	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
 		mpc8xxx_spi->rx_shift = 16;
 		mpc8xxx_spi->tx_shift = 24;
 	}
@@ -584,7 +593,7 @@ mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 
 	/* Enable SPI interface */
 	regval = pdata->initial_spmode | SPMODE_INIT_VAL | SPMODE_ENABLE;
-	if (pdata->qe_mode)
+	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE)
 		regval |= SPMODE_OP;
 
 	mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mode, regval);
@@ -604,9 +613,8 @@ mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 	if (ret < 0)
 		goto unreg_master;
 
-	printk(KERN_INFO
-	       "%s: MPC8xxx SPI Controller driver at 0x%p (irq = %d)\n",
-	       dev_name(dev), mpc8xxx_spi->base, mpc8xxx_spi->irq);
+	dev_info(dev, "at 0x%p (irq = %d), %s mode\n", mpc8xxx_spi->base,
+		 mpc8xxx_spi->irq, mpc8xxx_spi_strmode(mpc8xxx_spi->flags));
 
 	return master;
 
@@ -797,7 +805,7 @@ static int __devinit of_mpc8xxx_spi_probe(struct of_device *ofdev,
 
 	prop = of_get_property(np, "mode", NULL);
 	if (prop && !strcmp(prop, "cpu-qe"))
-		pdata->qe_mode = 1;
+		pdata->flags = SPI_QE_CPU_MODE;
 
 	ret = of_mpc8xxx_spi_get_chipselects(dev);
 	if (ret)
diff --git a/include/linux/fsl_devices.h b/include/linux/fsl_devices.h
index 43fc95d..39fd946 100644
--- a/include/linux/fsl_devices.h
+++ b/include/linux/fsl_devices.h
@@ -74,7 +74,7 @@ struct spi_device;
 struct fsl_spi_platform_data {
 	u32 	initial_spmode;	/* initial SPMODE value */
 	s16	bus_num;
-	bool	qe_mode;
+	unsigned int flags;
 	/* board specific information */
 	u16	max_chipselect;
 	void	(*cs_control)(struct spi_device *spi, bool on);
-- 
1.6.3.3

