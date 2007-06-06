Return-Path: <linux-kernel-owner+w=401wt.eu-S932681AbXFFRbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbXFFRbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbXFFRay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:30:54 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:45403 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141AbXFFRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:30:54 -0400
Date: Wed, 6 Jun 2007 19:34:03 +0200
From: Clifford Wolf <clifford@clifford.at>
To: galak@kernel.crashing.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] spi_mpc83xx.c underclocking hotfix
Message-ID: <20070606173402.GA15877@clifford.at>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi kumar (spi_mpc83xx maintainer), Hi list,

the MPC83xx SPI controller clock divider can divide the system clock by not
more then 1024. The spi_mpc83xx driver does not check this and silently
writes garbage to the SPI controller registers when asked to run at lower
frequencies. I've tried to run the SPI on a 266MHz MPC8349E with 100kHz for
debugging a bus problem and suddenly was confronted with a 2nd problem to
debug..  ;-)

The attached patch adds an additional check which avoids writing garbage to
the SPI controller registers and warn the user about it. This might help
others to avoid simmilar problems.

yours,
 - clifford

-- 
Hardware /nm./: the part of the computer that you can kick.

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="spi_mpc83xx_hotfix.patch"

Index: drivers/spi/spi_mpc83xx.c
===================================================================
--- drivers/spi/spi_mpc83xx.c	(revision 170)
+++ drivers/spi/spi_mpc83xx.c	(working copy)
@@ -158,6 +158,12 @@
 
 		if ((mpc83xx_spi->sysclk / spi->max_speed_hz) >= 64) {
 			u8 pm = mpc83xx_spi->sysclk / (spi->max_speed_hz * 64);
+			if (pm > 0x0f) {
+				printk(KERN_WARNING "MPC83xx SPI: SPICLK can't be less then a SYSCLK/1024!\n"
+						"Requested SPICLK is %d Hz. Will use %d Hz instead.\n",
+						spi->max_speed_hz, mpc83xx_spi->sysclk / 1024);
+				pm = 0x0f;
+			}
 			regval |= SPMODE_PM(pm) | SPMODE_DIV16;
 		} else {
 			u8 pm = mpc83xx_spi->sysclk / (spi->max_speed_hz * 4);

--cWoXeonUoKmBZSoM--
