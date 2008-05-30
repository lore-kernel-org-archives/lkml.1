Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYE3M3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYE3M3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYE3M3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:29:01 -0400
Received: from mail.atmel.fr ([81.80.104.162]:34926 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYE3M3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:29:00 -0400
Message-ID: <483FF2FD.7020609@atmel.com>
Date: Fri, 30 May 2008 14:28:45 +0200
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
Subject: [PATCH 7/7] mmc: at91_mci: do not read irq status twice as it will
 forget some errors
References: <483FE9E7.7020707@atmel.com>
In-Reply-To: <483FE9E7.7020707@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading AT91_MCI_SR again at the end of transfer can corrupt the
error reporting. Some fields in the SR register are read-and-clear.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 92a0200..9948fe1 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -660,10 +660,9 @@ static void at91_mci_process_next(struct at91mci_host *host)
 /*
  * Handle a command that has been completed
  */
-static void at91_mci_completed_command(struct at91mci_host *host)
+static void at91_mci_completed_command(struct at91mci_host *host, unsigned int status)
 {
 	struct mmc_command *cmd = host->cmd;
-	unsigned int status;
 
 	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff & ~(AT91_MCI_SDIOIRQA | AT91_MCI_SDIOIRQB));
 
@@ -677,10 +676,9 @@ static void at91_mci_completed_command(struct at91mci_host *host)
 		host->buffer = NULL;
 	}
 
-	status = at91_mci_read(host, AT91_MCI_SR);
-
-	pr_debug("Status = %08X [%08X %08X %08X %08X]\n",
-		 status, cmd->resp[0], cmd->resp[1], cmd->resp[2], cmd->resp[3]);
+	pr_debug("Status = %08X/%08x [%08X %08X %08X %08X]\n",
+		 status, at91_mci_read(host, AT91_MCI_SR),
+		 cmd->resp[0], cmd->resp[1], cmd->resp[2], cmd->resp[3]);
 
 	if (status & AT91_MCI_ERRORS) {
 		if ((status & AT91_MCI_RCRCE) && !(mmc_resp_type(cmd) & MMC_RSP_CRC)) {
@@ -877,7 +875,7 @@ static irqreturn_t at91_mci_irq(int irq, void *devid)
 	if (completed) {
 		pr_debug("Completed command\n");
 		at91_mci_write(host, AT91_MCI_IDR, 0xffffffff & ~(AT91_MCI_SDIOIRQA | AT91_MCI_SDIOIRQB));
-		at91_mci_completed_command(host);
+		at91_mci_completed_command(host, int_status);
 	} else
 		at91_mci_write(host, AT91_MCI_IDR, int_status & ~(AT91_MCI_SDIOIRQA | AT91_MCI_SDIOIRQB));
 
-- 
1.5.3.7


