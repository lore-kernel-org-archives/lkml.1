Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZDDT2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZDDT2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZDDT2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:28:15 -0400
Received: from [213.79.90.228] ([213.79.90.228]:8084 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756740AbZDDT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:28:14 -0400
Date: Sat, 4 Apr 2009 23:28:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/3] spi_mpc83xx: Quieten down the "Requested speed is too
	low" message
Message-ID: <20090404192810.GB12183@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a platform is running at high frequencies it's not always
possible to scale-down a frequency to a requested value, and using
mmc_spi driver this leads to the following printk flood during card
polling:

  ...
  mmc_spi spi32766.0: Requested speed is too low: 400000 Hz. Will use
  520828 Hz instead.
  mmc_spi spi32766.0: Requested speed is too low: 400000 Hz. Will use
  520828 Hz instead.
  ...

Fix this by using WARN_ONCE(), it's better than the flood, and also
better than turning dev_err() into dev_dbg(), since we actually want
to warn that some things may not work correctly.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/spi/spi_mpc83xx.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
index f4573a9..08b49d2 100644
--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/completion.h>
@@ -275,12 +276,12 @@ int mpc83xx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	if ((mpc83xx_spi->spibrg / hz) > 64) {
 		cs->hw_mode |= SPMODE_DIV16;
 		pm = mpc83xx_spi->spibrg / (hz * 64);
-		if (pm > 16) {
-			dev_err(&spi->dev, "Requested speed is too "
-				"low: %d Hz. Will use %d Hz instead.\n",
-				hz, mpc83xx_spi->spibrg / 1024);
+
+		WARN_ONCE(pm > 16, "%s: Requested speed is too low: %d Hz. "
+			  "Will use %d Hz instead.\n", dev_name(&spi->dev),
+			  hz, mpc83xx_spi->spibrg / 1024);
+		if (pm > 16)
 			pm = 16;
-		}
 	} else
 		pm = mpc83xx_spi->spibrg / (hz * 4);
 	if (pm)
-- 
1.5.6.5

