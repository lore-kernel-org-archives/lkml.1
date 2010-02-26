Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965607Ab0BZRh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:37:57 -0500
Received: from mail.atmel.fr ([81.80.104.162]:39718 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965595Ab0BZRhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:37:52 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 12:37:45 EST
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       wolfgang.mues@auerswald.de, avictor.za@gmail.com
Subject: [PATCH 2/7] mmc: at91_mci: fix timeout errors
Date: Fri, 26 Feb 2010 19:39:30 +0100
Message-Id: <7edd0d2f43b28d03e73fdf180e40ce9ae977ee56.1267209149.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
In-Reply-To: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Fix two timeout errors, one for slow SDHC cards and one for slow users while
inserting SD cards.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 6835104..f2cb716 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -756,7 +756,8 @@ static void at91_mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	host->request = mrq;
 	host->flags = 0;
 
-	mod_timer(&host->timer, jiffies +  HZ);
+	/* more than 1s timeout needed with slow SD cards */
+	mod_timer(&host->timer, jiffies +  msecs_to_jiffies(2000));
 
 	at91_mci_process_next(host);
 }
@@ -944,7 +945,8 @@ static irqreturn_t at91_mmc_det_irq(int irq, void *_host)
 			pr_debug("****** Resetting SD-card bus width ******\n");
 			at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) & ~AT91_MCI_SDCBUS);
 		}
-		mmc_detect_change(host->mmc, msecs_to_jiffies(100));
+		/* 0.5s needed because of early card detect switch firing */
+		mmc_detect_change(host->mmc, msecs_to_jiffies(500));
 	}
 	return IRQ_HANDLED;
 }
-- 
1.5.6.5

