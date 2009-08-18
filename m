Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZHRWE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZHRWE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZHRWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:04:21 -0400
Received: from ru.mvista.com ([213.79.90.228]:44089 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbZHRWET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:04:19 -0400
Date: Wed, 19 Aug 2009 02:04:20 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] spi_mpc8xxx: Factor out SPI mode change steps into a
 call
Message-ID: <20090818220420.GF25090@oksana.dev.rtsoft.ru>
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll add more steps soon, so get rid of the duplication.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/spi/spi_mpc8xxx.c |   56 +++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 518671b..4b119ea 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -155,6 +155,26 @@ MPC83XX_SPI_TX_BUF(u8)
 MPC83XX_SPI_TX_BUF(u16)
 MPC83XX_SPI_TX_BUF(u32)
 
+static void mpc8xxx_spi_change_mode(struct spi_device *spi)
+{
+	struct mpc8xxx_spi *mspi = spi_master_get_devdata(spi->master);
+	struct spi_mpc8xxx_cs *cs = spi->controller_state;
+	__be32 __iomem *mode = &mspi->base->mode;
+	unsigned long flags;
+
+	if (cs->hw_mode == mpc8xxx_spi_read_reg(mode))
+		return;
+
+	/* Turn off IRQs locally to minimize time that SPI is disabled. */
+	local_irq_save(flags);
+
+	/* Turn off SPI unit prior changing mode */
+	mpc8xxx_spi_write_reg(mode, cs->hw_mode & ~SPMODE_ENABLE);
+	mpc8xxx_spi_write_reg(mode, cs->hw_mode);
+
+	local_irq_restore(flags);
+}
+
 static void mpc8xxx_spi_chipselect(struct spi_device *spi, int value)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
@@ -168,27 +188,13 @@ static void mpc8xxx_spi_chipselect(struct spi_device *spi, int value)
 	}
 
 	if (value == BITBANG_CS_ACTIVE) {
-		u32 regval = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->mode);
-
 		mpc8xxx_spi->rx_shift = cs->rx_shift;
 		mpc8xxx_spi->tx_shift = cs->tx_shift;
 		mpc8xxx_spi->get_rx = cs->get_rx;
 		mpc8xxx_spi->get_tx = cs->get_tx;
 
-		if (cs->hw_mode != regval) {
-			unsigned long flags;
-			__be32 __iomem *mode = &mpc8xxx_spi->base->mode;
-
-			regval = cs->hw_mode;
-			/* Turn off IRQs locally to minimize time that
-			 * SPI is disabled
-			 */
-			local_irq_save(flags);
-			/* Turn off SPI unit prior changing mode */
-			mpc8xxx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
-			mpc8xxx_spi_write_reg(mode, regval);
-			local_irq_restore(flags);
-		}
+		mpc8xxx_spi_change_mode(spi);
+
 		if (pdata->cs_control)
 			pdata->cs_control(spi, pol);
 	}
@@ -198,7 +204,6 @@ static
 int mpc8xxx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi;
-	u32 regval;
 	u8 bits_per_word, pm;
 	u32 hz;
 	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
@@ -286,21 +291,8 @@ int mpc8xxx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 		pm--;
 
 	cs->hw_mode |= SPMODE_PM(pm);
-	regval =  mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->mode);
-	if (cs->hw_mode != regval) {
-		unsigned long flags;
-		__be32 __iomem *mode = &mpc8xxx_spi->base->mode;
-
-		regval = cs->hw_mode;
-		/* Turn off IRQs locally to minimize time
-		 * that SPI is disabled
-		 */
-		local_irq_save(flags);
-		/* Turn off SPI unit prior changing mode */
-		mpc8xxx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
-		mpc8xxx_spi_write_reg(mode, regval);
-		local_irq_restore(flags);
-	}
+
+	mpc8xxx_spi_change_mode(spi);
 	return 0;
 }
 
-- 
1.6.3.3

