Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYLCTyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYLCTyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLCTuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:19 -0500
Received: from kroah.org ([198.145.64.141]:34582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754513AbYLCTuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:11 -0500
Date: Wed, 3 Dec 2008 11:48:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ned Forrester <nforrester@whoi.edu>,
       Vernon Sauder <vernoninhand@gmail.com>,
       "J. Scott Merritt" <merrij3@rpi.edu>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 010/104] pxa2xx_spi: bugfix full duplex dma data corruption
Message-ID: <20081203194836.GK8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pxa2xx_spi-bugfix-full-duplex-dma-data-corruption.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ned Forrester <nforrester@whoi.edu>

commit 393df744e056ba24e9531d0657d09fc3c7c0dd22 upstream.

Fixes a data corruption bug in pxa2xx_spi.c when operating in full duplex
mode with DMA and using buffers that overlap.

SPI transmit and receive buffers are allowed to be the same or to overlap.
 However, this driver fails if such overlap is attempted in DMA mode
because it maps the rx and tx buffers in the wrong order.  By mapping
DMA_FROM_DEVICE (read) before DMA_TO_DEVICE (write), it invalidates the
cache before flushing it, thus discarding data which should have been
transmitted.

The patch corrects the order of mapping.  This bug exists in all versions
of pxa2xx_spi.c; similar bugs are in the drivers for two other SPI
controllers (au1500, imx).

A version of this patch has been tested on kernel 2.6.20 using
verification of loopback data with: random transfer length, random
bits-per-word, random positive offsets (both larger and smaller than
transfer length) between the start of the rx and tx buffers, and varying
clock rates.

Signed-off-by: Ned Forrester <nforrester@whoi.edu>
Cc: Vernon Sauder <vernoninhand@gmail.com>
Cc: J. Scott Merritt <merrij3@rpi.edu>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/spi/pxa2xx_spi.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -348,21 +348,21 @@ static int map_dma_buffers(struct driver
 	} else
 		drv_data->tx_map_len = drv_data->len;
 
-	/* Stream map the rx buffer */
-	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
-						drv_data->rx_map_len,
-						DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, drv_data->rx_dma))
-		return 0;
-
-	/* Stream map the tx buffer */
+	/* Stream map the tx buffer. Always do DMA_TO_DEVICE first
+	 * so we flush the cache *before* invalidating it, in case
+	 * the tx and rx buffers overlap.
+	 */
 	drv_data->tx_dma = dma_map_single(dev, drv_data->tx,
-						drv_data->tx_map_len,
-						DMA_TO_DEVICE);
+					drv_data->tx_map_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, drv_data->tx_dma))
+		return 0;
 
-	if (dma_mapping_error(dev, drv_data->tx_dma)) {
-		dma_unmap_single(dev, drv_data->rx_dma,
+	/* Stream map the rx buffer */
+	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
 					drv_data->rx_map_len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, drv_data->rx_dma)) {
+		dma_unmap_single(dev, drv_data->tx_dma,
+					drv_data->tx_map_len, DMA_TO_DEVICE);
 		return 0;
 	}
 

