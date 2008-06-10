Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYFJJ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYFJJ14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYFJJ1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:27:46 -0400
Received: from mail.atmel.fr ([81.80.104.162]:61740 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbYFJJ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:27:45 -0400
Message-ID: <484E4901.3060705@atmel.com>
Date: Tue, 10 Jun 2008 11:27:29 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>
Subject: [PATCH] at91_mci: manage cmd error and data error independently
References: <48495843.1050902@atmel.com> <20080609130854.2237c05a@mjolnir.drzeus.cx>
In-Reply-To: <20080609130854.2237c05a@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In at91_mci_completed_command() function, this patch distinguishes 
command error and data error. It reports it in the corresponding 
error field.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Related to this thread :

Pierre Ossman :

> On Fri, 06 Jun 2008 17:31:15 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>
>   
>> Hi Pierre,
>>
>> Here are the results of a mmc_test run played on at91_mci after applying 
>> this patch series :
>> http://lkml.org/lkml/2008/5/30/201
>>
>> I skipped some of the tests just to concentrate on those ones.
>>
>> Can you tell me if the test is correct : are the errors reported for the 
>> xfer_size tests the normal behavior (I assume yes because a failure is 
>> simulated) ?
>>     
>
> No. You're supposed to get an OK there as well. Basically it tests that
> the driver doesn't report some unexpected error (-ETIMEDOUT is the
> desired one) or overreports the number of written bytes.
>   
Ok, so here is the first correction of the driver reporting the proper 
values in read.

It goes on top of this series :
http://lkml.org/lkml/2008/5/30/201

 drivers/mmc/host/at91_mci.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 9948fe1..86a3c5b 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -663,6 +664,7 @@ static void at91_mci_process_next(struct at91mci_host *host)
 static void at91_mci_completed_command(struct at91mci_host *host, unsigned int status)
 {
 	struct mmc_command *cmd = host->cmd;
+	struct mmc_data *data = cmd->data;
 
 	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff & ~(AT91_MCI_SDIOIRQA | AT91_MCI_SDIOIRQB));
 
@@ -685,15 +687,25 @@ static void at91_mci_completed_command(struct at91mci_host *host, unsigned int s
 			cmd->error = 0;
 		}
 		else {
-			if (status & (AT91_MCI_RTOE | AT91_MCI_DTOE))
-				cmd->error = -ETIMEDOUT;
-			else if (status & (AT91_MCI_RCRCE | AT91_MCI_DCRCE))
-				cmd->error = -EILSEQ;
-			else
-				cmd->error = -EIO;
+			if (status & (AT91_MCI_DTOE | AT91_MCI_DCRCE)) {
+				if (data) {
+					if (status & AT91_MCI_DTOE)
+						data->error = -ETIMEDOUT;
+					else if (status & AT91_MCI_DCRCE)
+						data->error = -EILSEQ;
+				}
+			} else {
+				if (status & AT91_MCI_RTOE)
+					cmd->error = -ETIMEDOUT;
+				else if (status & AT91_MCI_RCRCE)
+					cmd->error = -EILSEQ;
+				else
+					cmd->error = -EIO;
+			}
 
-			pr_debug("Error detected and set to %d (cmd = %d, retries = %d)\n",
-				 cmd->error, cmd->opcode, cmd->retries);
+			pr_debug("Error detected and set to %d/%d (cmd = %d, retries = %d)\n",
+				cmd->error, data ? data->error : 0,
+				 cmd->opcode, cmd->retries);
 		}
 	}
 	else
-- 
1.5.3.7


