Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbYE3M0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbYE3M0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYE3M0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:26:16 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64271 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYE3M0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:26:15 -0400
Message-ID: <483FF25D.3070006@atmel.com>
Date: Fri, 30 May 2008 14:26:05 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
       =?ISO-8859-1?Q?Hans-J=FCrgen?= =?ISO-8859-1?Q?_Koch?= 
	<hjk@linutronix.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4?= =?ISO-8859-1?Q?l=E4?= 
	<syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric BENARD <ebenard@free.fr>, Andrew Victor <linux@maxim.org.za>
Subject: [PATCH 6/7] mmc: at91_mci: add sdio irq management
References: <483FE9E7.7020707@atmel.com>
In-Reply-To: <483FE9E7.7020707@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Benard <ebenard@free.fr>

Enable SDIO interrupt handling.

Signed-off-by: Eric Benard <ebenard@free.fr>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index b2138f9..92a0200 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -665,7 +665,7 @@ static void at91_mci_completed_command(struct at91mci_host *host)
 	struct mmc_command *cmd = host->cmd;
 	unsigned int status;
 
-	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
+	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff & ~(AT91_MCI_SDIOIRQA | AT91_MCI_SDIOIRQB));
 
 	cmd->resp[0] = at91_mci_read(host, AT91_MCI_RSPR(0));
 	cmd->resp[1] = at91_mci_read(host, AT91_MCI_RSPR(1));
@@ -856,6 +856,12 @@ static irqreturn_t at91_mci_irq(int irq, void *devid)
 			}
 		}
 
+		if (int_status & AT91_MCI_SDIOIRQA)
+			mmc_signal_sdio_irq(host->mmc);
+
+		if (int_status & AT91_MCI_SDIOIRQB)
+			mmc_signal_sdio_irq(host->mmc);
+
 		if (int_status & AT91_MCI_TXRDY)
 			pr_debug("Ready to transmit\n");
 
@@ -870,10 +876,10 @@ static irqreturn_t at91_mci_irq(int irq, void *devid)
 
 	if (completed) {
 		pr_debug("Completed command\n");
-		at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
+		at91_mci_write(host, AT91_MCI_IDR, 0xffffffff & ~(AT91_MCI_SDIOIRQA | AT91_MCI_SDIOIRQB));
 		at91_mci_completed_command(host);
 	} else
-		at91_mci_write(host, AT91_MCI_IDR, int_status);
+		at91_mci_write(host, AT91_MCI_IDR, int_status & ~(AT91_MCI_SDIOIRQA | AT91_MCI_SDIOIRQB));
 
 	return IRQ_HANDLED;
 }
@@ -917,10 +923,22 @@ static int at91_mci_get_ro(struct mmc_host *mmc)
 	return read_only;
 }
 
+static void at91_mci_enable_sdio_irq(struct mmc_host *mmc, int enable)
+{
+	struct at91mci_host *host = mmc_priv(mmc);
+
+	pr_debug("%s: sdio_irq %c : %s\n", mmc_hostname(host->mmc),
+		host->board->slot_b ? 'B':'A', enable ? "enable" : "disable");
+	at91_mci_write(host, enable ? AT91_MCI_IER : AT91_MCI_IDR,
+		host->board->slot_b ? AT91_MCI_SDIOIRQB : AT91_MCI_SDIOIRQA);
+
+}
+
 static const struct mmc_host_ops at91_mci_ops = {
 	.request	= at91_mci_request,
 	.set_ios	= at91_mci_set_ios,
 	.get_ro		= at91_mci_get_ro,
+	.enable_sdio_irq = at91_mci_enable_sdio_irq,
 };
 
 /*
@@ -951,7 +969,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	mmc->f_min = 375000;
 	mmc->f_max = 25000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_MULTIWRITE;
+	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_SDIO_IRQ;
 
 	mmc->max_blk_size = 4095;
 	mmc->max_blk_count = mmc->max_req_size;
-- 
1.5.3.7


