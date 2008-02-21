Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYBUCLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYBUCLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 21:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYBUCLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 21:11:41 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:8562 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbYBUCLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 21:11:40 -0500
Date: Thu, 21 Feb 2008 11:11:38 +0900 (JST)
Message-Id: <20080221.111138.41629131.nemoto@toshiba-tops.co.jp>
To: akpm@linux-foundation.org
Cc: David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] atmel_spi: Fix clock polarity
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel_spi driver does not initialize clock polarity correctly
(except for at91rm9200 CS0 channel) in some case.

The atmel_spi driver uses gpio-controlled chipselect.  OTOH spi clock
signal is controlled by CSRn.CPOL bit, but this register controls
clock signal correctly only in 'real transfer' duration.  At the time
of cs_activate() call, CSRn.CPOL will be initialized correctly, but
the controller do not know which channel is to be used next, so clock
signal will stay at the inactive state of last transfer.  If clock
polarity of new transfer and last transfer was differ, new transfer
will start with wrong clock signal state.

For example, if you started SPI MODE 2 or 3 transfer after SPI MODE 0
or 1 transfer, the clock signal state at the assertion of chipselect
will be low.  Of course this will violates SPI transfer.

This patch is short term solution for this problem.  It makes all
CSRn.CPOL match for the transfer before activating chipselect.  For
longer term, the best fix might be to let NPCS0 stay selected
permanently in MR and overwrite CSR0 with to the new slave's settings
before asserting CS.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
This patch is already in mm tree as atmel_spi-fix-clock-polarity.patch.
I just rewrite description slightly and add my signed-off and acked-by
from Haavard Skinnemoen.

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 293b7ca..85687aa 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -87,6 +87,16 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 	unsigned gpio = (unsigned) spi->controller_data;
 	unsigned active = spi->mode & SPI_CS_HIGH;
 	u32 mr;
+	int i;
+	u32 csr;
+	u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
+
+	/* Make sure clock polarity is correct */
+	for (i = 0; i < spi->master->num_chipselect; i++) {
+		csr = spi_readl(as, CSR0 + 4 * i);
+		if ((csr ^ cpol) & SPI_BIT(CPOL))
+			spi_writel(as, CSR0 + 4 * i, csr ^ SPI_BIT(CPOL));
+	}
 
 	mr = spi_readl(as, MR);
 	mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
