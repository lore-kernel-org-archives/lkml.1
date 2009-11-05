Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbZKER4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbZKER4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbZKER4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:56:10 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45221 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZKERzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:55:43 -0500
Message-Id: <20091105152702.283954757@linux-mips.org>
User-Agent: quilt/0.47-1
Date: Thu, 05 Nov 2009 16:26:00 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] SPI: spi_txx9: Fix bit rate calculation
References: <20091105152555.227009519@linux-mips.org>
Content-Disposition: inline; filename=0005.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

TXx9 SPI bit rate is calculated by:
        fBR = (spi-baseclk) / (n + 1)
Fix calculation of min_speed_hz, max_speed_hz and n.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/spi/spi_txx9.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: upstream-linus/drivers/spi/spi_txx9.c
===================================================================
--- upstream-linus.orig/drivers/spi/spi_txx9.c
+++ upstream-linus/drivers/spi/spi_txx9.c
@@ -29,6 +29,8 @@
 
 
 #define SPI_FIFO_SIZE 4
+#define SPI_MAX_DIVIDER 0xff	/* Max. value for SPCR1.SER */
+#define SPI_MIN_DIVIDER 1	/* Min. value for SPCR1.SER */
 
 #define TXx9_SPMCR		0x00
 #define TXx9_SPCR0		0x04
@@ -193,11 +195,8 @@ static void txx9spi_work_one(struct txx9
 
 		if (prev_speed_hz != speed_hz
 				|| prev_bits_per_word != bits_per_word) {
-			u32 n = (c->baseclk + speed_hz - 1) / speed_hz;
-			if (n < 1)
-				n = 1;
-			else if (n > 0xff)
-				n = 0xff;
+			int n = DIV_ROUND_UP(c->baseclk, speed_hz) - 1;
+			n = clamp(n, SPI_MIN_DIVIDER, SPI_MAX_DIVIDER);
 			/* enter config mode */
 			txx9spi_wr(c, mcr | TXx9_SPMCR_CONFIG | TXx9_SPMCR_BCLR,
 					TXx9_SPMCR);
@@ -370,8 +369,8 @@ static int __init txx9spi_probe(struct p
 		goto exit;
 	}
 	c->baseclk = clk_get_rate(c->clk);
-	c->min_speed_hz = (c->baseclk + 0xff - 1) / 0xff;
-	c->max_speed_hz = c->baseclk;
+	c->min_speed_hz = DIV_ROUND_UP(c->baseclk, SPI_MAX_DIVIDER + 1);
+	c->max_speed_hz = c->baseclk / (SPI_MIN_DIVIDER + 1);
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)


