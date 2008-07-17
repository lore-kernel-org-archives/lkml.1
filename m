Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbYGQJef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbYGQJef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbYGQJeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:34:19 -0400
Received: from mail.atmel.fr ([81.80.104.162]:42391 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbYGQJeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:34:18 -0400
Message-ID: <487F120F.2050305@atmel.com>
Date: Thu, 17 Jul 2008 11:34:07 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>, Ville Syrjala <syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] at91_mci: Enable MMC_CAP_SDIO_IRQ only when it actually
 works
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheets AT91SAM9261 does not support
SDIO interrupts, and AT91SAM9260/9263 have an erratum
requiring 4bit mode while using slot B for the interrupt
to work.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Original patch from Ville Syrjala.
I removed the rm9200 from the original patch as this chip is not
SDIO capable (error in datasheet).

 drivers/mmc/host/at91_mci.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 59bf71e..f3d725e 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -1000,7 +1000,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	mmc->f_min = 375000;
 	mmc->f_max = 25000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_SDIO_IRQ;
+	mmc->caps = 0;
 
 	mmc->max_blk_size = 4095;
 	mmc->max_blk_count = mmc->max_req_size;
@@ -1018,6 +1018,13 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 				" - using 1 wire\n");
 	}
 
+	/* Add SDIO capability when  available */
+	if (cpu_is_at91sam9260() || cpu_is_at91sam9263()) {
+		/* AT91SAM9260/9263 erratum */
+		if (host->board->wire4 || !host->board->slot_b)
+			mmc->caps |= MMC_CAP_SDIO_IRQ;
+	}
+
 	/*
 	 * Reserve GPIOs ... board init code makes sure these pins are set
 	 * up as GPIOs with the right direction (input, except for vcc)
-- 
1.5.3.7




