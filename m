Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYJGAnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYJGAnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYJGAla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:41:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:60178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbYJGAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:41:28 -0400
Date: Mon, 6 Oct 2008 17:37:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       Eric Miao <eric.y.miao@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 08/71] pxa2xx_spi: dma bugfixes
Message-ID: <20081007003744.GI3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pxa2xx_spi-dma-bugfixes.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ned Forrester <nforrester@whoi.edu>

commit 7e96445533ac3f4f7964646a202ff3620602fab4 upstream

Fixes two DMA bugs in the pxa2xx_spi driver.  The first bug is in all
versions of this driver; the second was introduced in the 2.6.20 kernel,
and prevents using the driver with chips like m25p16 flash (which can
issue large DMA reads).

 1. Zero length transfers are permitted for use to insert timing,
    but pxa2xx_spi.c will fail if this is requested in DMA mode.
    Fixed by using programmed I/O (PIO) mode for such transfers.

 2. Transfers larger than 8191 are not permitted in DMA mode.  A
    test for length rejects all large transfers regardless of DMA
    or PIO mode.  Worked around by rejecting only large transfers
    with DMA mapped buffers, and forcing all other transfers
    larger than 8191 to use PIO mode.  A rate limited warning is
    issued for DMA transfers forced to PIO mode.

This patch should apply to all kernels back to and including 2.6.20;
it was test patched against 2.6.20.  An additional patch would be
required for older kernels, but those versions are very buggy anyway.

Signed-off-by: Ned Forrester <nforrester@whoi.edu>
Cc: Vernon Sauder <vernoninhand@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/spi/pxa2xx_spi.c |   57 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 14 deletions(-)

--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -48,9 +48,10 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define MAX_BUSES 3
 
-#define DMA_INT_MASK (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
-#define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
-#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
+#define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
+#define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
+#define IS_DMA_ALIGNED(x)	(((x) & 0x07) == 0)
+#define MAX_DMA_LEN		8191
 
 /*
  * for testing SSCR1 changes that require SSP restart, basically
@@ -850,14 +851,27 @@ static void pump_transfers(unsigned long
 			udelay(previous->delay_usecs);
 	}
 
-	/* Check transfer length */
-	if (transfer->len > 8191)
-	{
-		dev_warn(&drv_data->pdev->dev, "pump_transfers: transfer "
-				"length greater than 8191\n");
-		message->status = -EINVAL;
-		giveback(drv_data);
-		return;
+	/* Check for transfers that need multiple DMA segments */
+	if (transfer->len > MAX_DMA_LEN && chip->enable_dma) {
+
+		/* reject already-mapped transfers; PIO won't always work */
+		if (message->is_dma_mapped
+				|| transfer->rx_dma || transfer->tx_dma) {
+			dev_err(&drv_data->pdev->dev,
+				"pump_transfers: mapped transfer length "
+				"of %lu is greater than %d\n",
+				transfer->len, MAX_DMA_LEN);
+			message->status = -EINVAL;
+			giveback(drv_data);
+			return;
+		}
+
+		/* warn ... we force this to PIO mode */
+		if (printk_ratelimit())
+			dev_warn(&message->spi->dev, "pump_transfers: "
+				"DMA disabled for transfer length %ld "
+				"greater than %d\n",
+				(long)drv_data->len, MAX_DMA_LEN);
 	}
 
 	/* Setup the transfer state based on the type of transfer */
@@ -926,7 +940,7 @@ static void pump_transfers(unsigned long
 							&dma_thresh))
 				if (printk_ratelimit())
 					dev_warn(&message->spi->dev,
-						"pump_transfer: "
+						"pump_transfers: "
 						"DMA burst size reduced to "
 						"match bits_per_word\n");
 		}
@@ -940,8 +954,23 @@ static void pump_transfers(unsigned long
 
 	message->state = RUNNING_STATE;
 
-	/* Try to map dma buffer and do a dma transfer if successful */
-	if ((drv_data->dma_mapped = map_dma_buffers(drv_data))) {
+	/* Try to map dma buffer and do a dma transfer if successful, but
+	 * only if the length is non-zero and less than MAX_DMA_LEN.
+	 *
+	 * Zero-length non-descriptor DMA is illegal on PXA2xx; force use
+	 * of PIO instead.  Care is needed above because the transfer may
+	 * have have been passed with buffers that are already dma mapped.
+	 * A zero-length transfer in PIO mode will not try to write/read
+	 * to/from the buffers
+	 *
+	 * REVISIT large transfers are exactly where we most want to be
+	 * using DMA.  If this happens much, split those transfers into
+	 * multiple DMA segments rather than forcing PIO.
+	 */
+	drv_data->dma_mapped = 0;
+	if (drv_data->len > 0 && drv_data->len <= MAX_DMA_LEN)
+		drv_data->dma_mapped = map_dma_buffers(drv_data);
+	if (drv_data->dma_mapped) {
 
 		/* Ensure we have the correct interrupt handler */
 		drv_data->transfer_handler = dma_transfer;

-- 
