Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbXAYFB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbXAYFB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933241AbXAYFBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:01:25 -0500
Received: from nic2.axis.se ([193.13.178.10]:41827 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231AbXAYFBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:01:24 -0500
Date: Thu, 25 Jan 2007 05:49:03 +0100
Message-Id: <200701250449.l0P4n34B017001@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: dbrownell@users.sourceforge.net
CC: mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] 1/5: Updates to SPI and mmc_spi for SD+MMC over SPI: spi_bitbang fix, kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on replies, I'm not subscribed to LKML.  Thanks.)

First, a small bug-fix for spi_bitbang: it must always call the
setup_transfer function via the overridable pointer, not assume
that its spi_bitbang_setup_transfer is sufficient.  Otherwise,
if all options in the transfers are default (0), the overrided
function will never be called.  Granted, the function replacing
it must call spi_bitbang_setup_transfer, but it might also have
other important things to do, even if the second argument (the
spi_transfer) is NULL.  Tested together with the other patches
on the spi_crisv32_sser and spi_crisv32_gpio drivers (not yet in
the kernel, will IIUC be submitted as part of the usual
arch-maintainer-pushes).

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>

--- a/drivers/spi/spi_bitbang.c	2006-10-13 10:02:33.000000000 +0200
+++ b/drivers/spi/spi_bitbang.c	2007-01-24 05:21:12.959454043 +0100
@@ -210,7 +216,7 @@ int spi_bitbang_setup(struct spi_device 
 	if (!cs->txrx_word)
 		return -EINVAL;
 
-	retval = spi_bitbang_setup_transfer(spi, NULL);
+	retval = bitbang->setup_transfer(spi, NULL);
 	if (retval < 0)
 		return retval;
 
@@ -441,9 +463,10 @@ EXPORT_SYMBOL_GPL(spi_bitbang_transfer);
  * hardware that basically exposes a shift register) or per-spi_transfer
  * (which takes better advantage of hardware like fifos or DMA engines).
  *
- * Drivers using per-word I/O loops should use (or call) spi_bitbang_setup and
- * spi_bitbang_cleanup to handle those spi master methods.  Those methods are
- * the defaults if the bitbang->txrx_bufs routine isn't initialized.
+ * Drivers using per-word I/O loops should use (or call) spi_bitbang_setup,
+ * spi_bitbang_cleanup and spi_bitbang_setup_transfer to handle those spi
+ * master methods.  Those methods are the defaults if the bitbang->txrx_bufs
+ * routine isn't initialized.
  *
  * This routine registers the spi_master, which will process requests in a
  * dedicated task, keeping IRQs unblocked most of the time.  To stop


brgds, H-P
