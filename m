Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYE3MoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYE3MoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYE3MoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:44:04 -0400
Received: from mail.atmel.fr ([81.80.104.162]:58742 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYE3MoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:44:02 -0400
Message-ID: <483FF687.4060404@atmel.com>
Date: Fri, 30 May 2008 14:43:51 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] mmc: at91_mci: support for block size not modulo 4
References: <483FE9E7.7020707@atmel.com>
In-Reply-To: <483FE9E7.7020707@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Pignat <marc.pignat@hevs.ch>

Implement transfer with size not modulo 4 for at91sam9*. Please note 
that the
at91rm9200 simply can't handle this.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
drivers/mmc/host/at91_mci.c |   15 ++++++++++-----
1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 8979ad3..543b64b 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -233,11 +233,11 @@ static void at91_mci_pre_dma_read(struct 
at91mci_host *host)

		if (i == 0) {
			at91_mci_write(host, ATMEL_PDC_RPR, sg->dma_address);
-			at91_mci_write(host, ATMEL_PDC_RCR, sg->length / 4);
+			at91_mci_write(host, ATMEL_PDC_RCR, (data->blksz & 0x3) ? sg->length 
: sg->length / 4);
		}
		else {
			at91_mci_write(host, ATMEL_PDC_RNPR, sg->dma_address);
-			at91_mci_write(host, ATMEL_PDC_RNCR, sg->length / 4);
+			at91_mci_write(host, ATMEL_PDC_RNCR, (data->blksz & 0x3) ? 
sg->length : sg->length / 4);
		}
	}

@@ -430,7 +430,7 @@ static void at91_mci_send_command(struct 
at91mci_host *host, struct mmc_command

	if (data) {

-		if ( data->blksz & 0x3 ) {
+		if ( cpu_is_at91rm9200() && (data->blksz & 0x3) ) {
			pr_debug("Unsupported block size\n");
			cmd->error = -EINVAL;
			mmc_request_done(host->mmc, host->request);
@@ -482,7 +482,10 @@ static void at91_mci_send_command(struct 
at91mci_host *host, struct mmc_command
	} else {
		/* zero block length and PDC mode */
		mr = at91_mci_read(host, AT91_MCI_MR) & 0x7fff;
-		at91_mci_write(host, AT91_MCI_MR, mr | (block_length << 16) | 
AT91_MCI_PDCMODE);
+		mr |= (data->blksz & 0x3) ? AT91_MCI_PDCFBYTE : 0;
+		mr |= (block_length << 16);
+		mr |= AT91_MCI_PDCMODE;
+		at91_mci_write(host, AT91_MCI_MR, mr);

		/*
		 * Disable the PDC controller
@@ -517,7 +520,9 @@ static void at91_mci_send_command(struct 
at91mci_host *host, struct mmc_command
				pr_debug("Transmitting %d bytes\n", host->total_length);

				at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);
-				at91_mci_write(host, ATMEL_PDC_TCR, host->total_length / 4);
+				at91_mci_write(host, ATMEL_PDC_TCR, (data->blksz & 0x3) ?
+						host->total_length : host->total_length / 4);
+
				ier = AT91_MCI_CMDRDY;
			}
		}
-- 
1.5.3.7



