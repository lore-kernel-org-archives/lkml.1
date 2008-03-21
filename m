Return-Path: <linux-kernel-owner+w=401wt.eu-S1764484AbYCUXul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764484AbYCUXul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYCUXq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:46:29 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60221 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761894AbYCUXq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:46:26 -0400
Message-Id: <20080321224423.720490172@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, david-b@pacbell.net,
       anemo@mba.ocn.ne.jp, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 48/76] atmel_spi: fix clock polarity
Content-Disposition: inline; filename=atmel_spi-fix-clock-polarity.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The atmel_spi driver does not initialize clock polarity correctly (except for
at91rm9200 CS0 channel) in some case.

The atmel_spi driver uses gpio-controlled chipselect.  OTOH spi clock signal
is controlled by CSRn.CPOL bit, but this register controls clock signal
correctly only in 'real transfer' duration.  At the time of cs_activate()
call, CSRn.CPOL will be initialized correctly, but the controller do not know
which channel is to be used next, so clock signal will stay at the inactive
state of last transfer.  If clock polarity of new transfer and last transfer
was differ, new transfer will start with wrong clock signal state.

For example, if you started SPI MODE 2 or 3 transfer after SPI MODE 0 or 1
transfer, the clock signal state at the assertion of chipselect will be low.
Of course this will violates SPI transfer.

This patch is short term solution for this problem.  It makes all CSRn.CPOL
match for the transfer before activating chipselect.  For longer term, the
best fix might be to let NPCS0 stay selected permanently in MR and overwrite
CSR0 with to the new slave's settings before asserting CS.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/spi/atmel_spi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -85,6 +85,16 @@ static void cs_activate(struct atmel_spi
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

-- 
