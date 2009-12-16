Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbZLPGBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbZLPGBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761574AbZLPGBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:01:36 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33765 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbZLPGBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:01:35 -0500
Date: Wed, 16 Dec 2009 15:01:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: John Linn <John.Linn@xilinx.com>, Grant Likely <grant.likely@secretlab.ca>
Cc: richard.rojfors@mocean-labs.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] spi: xilinx_spi: Fix up I/O routine wrapping bogosity.
Message-ID: <20091216060130.GD31265@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xilinx_spi presently makes some fairly questionable assumptions about I/O
routines, and attempts to assign ioread32/iowrite32 and friends directly
to its own internal function pointers. On many platforms these I/O
routines are macros or wrappers and not actual functions on their own,
resulting in things like:

ERROR: "ioread32be" [drivers/spi/xilinx_spi.ko] undefined!
ERROR: "iowrite32be" [drivers/spi/xilinx_spi.ko] undefined!
ERROR: "iowrite32" [drivers/spi/xilinx_spi.ko] undefined!
ERROR: "ioread32" [drivers/spi/xilinx_spi.ko] undefined!

If xilinx_spi wants to do this sort of casting, it needs to provide its
own wrappers for these, or change how it does accesses completely.

I've opted for the first approach, and the attached silly patch does
that. If someone with the hardware available wants to give the second
option a try that's ok too. In any event, the current code is broken for
at least: arm, avr32, blackfin, microblaze, mn10300, and sh.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/spi/xilinx_spi.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index 9f38637..154e908 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -93,6 +93,26 @@ struct xilinx_spi {
 	void (*rx_fn) (struct xilinx_spi *);
 };
 
+static void xspi_write32(u32 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+}
+
+static unsigned int xspi_read32(void __iomem *addr)
+{
+	return ioread32(addr);
+}
+
+static void xspi_write32_be(u32 val, void __iomem *addr)
+{
+	iowrite32be(val, addr);
+}
+
+static unsigned int xspi_read32_be(void __iomem *addr)
+{
+	return ioread32be(addr);
+}
+
 static void xspi_tx8(struct xilinx_spi *xspi)
 {
 	xspi->write_fn(*xspi->tx_ptr, xspi->regs + XSPI_TXD_OFFSET);
@@ -374,11 +394,11 @@ struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
 	xspi->mem = *mem;
 	xspi->irq = irq;
 	if (pdata->little_endian) {
-		xspi->read_fn = ioread32;
-		xspi->write_fn = iowrite32;
+		xspi->read_fn = xspi_read32;
+		xspi->write_fn = xspi_write32;
 	} else {
-		xspi->read_fn = ioread32be;
-		xspi->write_fn = iowrite32be;
+		xspi->read_fn = xspi_read32_be;
+		xspi->write_fn = xspi_write32_be;
 	}
 	xspi->bits_per_word = pdata->bits_per_word;
 	if (xspi->bits_per_word == 8) {
