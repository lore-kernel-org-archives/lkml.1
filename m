Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbYBGA1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbYBGA1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbYBFX74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:56 -0500
Received: from mx1.suse.de ([195.135.220.2]:46580 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbYBFX7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:54 -0500
Date: Wed, 6 Feb 2008 15:54:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dbrownell@users.sourceforge.net,
       kalle.valo@nokia.com
Subject: [patch 64/73] spi: omap2_mcspi PIO RX fix
Message-ID: <20080206235417.GM13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="spi-omap2_mcspi-pio-rx-fix.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Kalle Valo <kalle.valo@nokia.com>

patch feed9bab7b14b77be8d796bcee95e2343fb82955 in mainline.

Before transmission of the last word in PIO RX_ONLY mode rx+tx mode
is enabled:

	/* prevent last RX_ONLY read from triggering
	 * more word i/o: switch to rx+tx
	 */
	if (c == 0 && tx == NULL)
		mcspi_write_cs_reg(spi,
				OMAP2_MCSPI_CHCONF0, l);

But because c is decremented after the test, c will never be zero and
rx+tx will not be enabled. This breaks RX_ONLY mode PIO transfers.

Fix it by decrementing c in the beginning of the various I/O loops.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/spi/omap2_mcspi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/omap2_mcspi.c
+++ b/drivers/spi/omap2_mcspi.c
@@ -350,6 +350,7 @@ omap2_mcspi_txrx_pio(struct spi_device *
 		tx = xfer->tx_buf;
 
 		do {
+			c -= 1;
 			if (tx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
 						OMAP2_MCSPI_CHSTAT_TXS) < 0) {
@@ -380,7 +381,6 @@ omap2_mcspi_txrx_pio(struct spi_device *
 						word_len, *(rx - 1));
 #endif
 			}
-			c -= 1;
 		} while (c);
 	} else if (word_len <= 16) {
 		u16		*rx;
@@ -389,6 +389,7 @@ omap2_mcspi_txrx_pio(struct spi_device *
 		rx = xfer->rx_buf;
 		tx = xfer->tx_buf;
 		do {
+			c -= 2;
 			if (tx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
 						OMAP2_MCSPI_CHSTAT_TXS) < 0) {
@@ -419,7 +420,6 @@ omap2_mcspi_txrx_pio(struct spi_device *
 						word_len, *(rx - 1));
 #endif
 			}
-			c -= 2;
 		} while (c);
 	} else if (word_len <= 32) {
 		u32		*rx;
@@ -428,6 +428,7 @@ omap2_mcspi_txrx_pio(struct spi_device *
 		rx = xfer->rx_buf;
 		tx = xfer->tx_buf;
 		do {
+			c -= 4;
 			if (tx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
 						OMAP2_MCSPI_CHSTAT_TXS) < 0) {
@@ -458,7 +459,6 @@ omap2_mcspi_txrx_pio(struct spi_device *
 						word_len, *(rx - 1));
 #endif
 			}
-			c -= 4;
 		} while (c);
 	}
 

-- 
