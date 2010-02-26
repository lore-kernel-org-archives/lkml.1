Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615Ab0BZRiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:38:10 -0500
Received: from mail.atmel.fr ([81.80.104.162]:39718 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965521Ab0BZRhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:37:55 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 12:37:45 EST
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       wolfgang.mues@auerswald.de, avictor.za@gmail.com,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 6/7] mmc: at91_mci: Enable MMC_CAP_SDIO_IRQ only when it actually works.
Date: Fri, 26 Feb 2010 19:39:34 +0100
Message-Id: <bfc9699a72aba4d7ea8b2450710339bb79031e1a.1267209149.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
In-Reply-To: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheets AT91SAM9261 does not support
SDIO interrupts, and AT91SAM9260/9263 have an erratum
requiring 4bit mode while using slot B for the interrupt
to work.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 4c30c56..e78cdc8 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -929,7 +929,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	mmc->f_min = 375000;
 	mmc->f_max = 25000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_SDIO_IRQ;
+	mmc->caps = 0;
 
 	mmc->max_blk_size  = MCI_MAXBLKSIZE;
 	mmc->max_blk_count = MCI_BLKATONCE;
@@ -958,6 +958,13 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 		goto fail5;
 	}
 
+	/* Add SDIO capability when available */
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
1.5.6.5

