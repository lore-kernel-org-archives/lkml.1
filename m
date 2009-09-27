Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZI0FWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZI0FWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 01:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZI0FWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 01:22:16 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:25901
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbZI0FWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 01:22:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIBAFiTvkp8qN+D/2dsb2JhbAAI00qEHgU
X-IronPort-AV: E=Sophos;i="4.44,459,1249228800"; 
   d="scan'208";a="584264054"
Subject: [PATCH] atmel_spi: fix dma addr calculation for len > BUFFER_SIZE
From: Ben Nizette <bn@niasdigital.com>
To: hskinnemoen@atmel.com
Cc: spi-devel-general@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>, dbrownell@users.sourceforge.net
Content-Type: text/plain
Date: Sun, 27 Sep 2009 15:26:27 +1000
Message-Id: <1254029187.7587.146.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If len > BUFFER_LEN and !xfer->rx_buf we end up calculating the tx
buffer address as

*tx_dma = xfer->tx_dma + xfer->len - BUFFER_SIZE;

which is constant; i.e. we just send the last BUFFER_SIZE data over
again until we've reached the right number of bytes.

This patch gets around this by using the /requested/ length when
calculating addresses.

Note there's no way len != *plen when we calculate the rx buffer address
but conceptually we should be using *plen and I don't want someone to
come through later, see the calculations for rx and tx are different and
"clean up" back to what we had.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---
 drivers/spi/atmel_spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index f5b3fdb..8ce70cb 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -189,14 +189,14 @@ static void atmel_spi_next_xfer_data(struct spi_master *master,
 
 	/* use scratch buffer only when rx or tx data is unspecified */
 	if (xfer->rx_buf)
-		*rx_dma = xfer->rx_dma + xfer->len - len;
+		*rx_dma = xfer->rx_dma + xfer->len - *plen;
 	else {
 		*rx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
 			len = BUFFER_SIZE;
 	}
 	if (xfer->tx_buf)
-		*tx_dma = xfer->tx_dma + xfer->len - len;
+		*tx_dma = xfer->tx_dma + xfer->len - *plen;
 	else {
 		*tx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
-- 
1.6.0.4



