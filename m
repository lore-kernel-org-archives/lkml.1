Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYJEQ2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYJEQ2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbYJEQWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:45 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62764 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758154AbYJEQWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:39 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v2 6/7] atmel-mci: Don't overwrite error bits when NOTBUSY is set
Date: Sun,  5 Oct 2008 18:21:29 +0200
Message-Id: <1223223690-2637-7-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223223690-2637-6-git-send-email-haavard.skinnemoen@atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-6-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 05 Oct 2008 16:21:15.0228 (UTC) FILETIME=[63AC19C0:01C92706]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a data error, we wait for the NOTBUSY bit to be set so that we can
be sure the data transfer is completely finished. However, when NOTBUSY
is set, the interrupt handler copies the contents of SR into
data_status, overwriting any error bits we may have detected earlier.

To avoid this, initialize data_status to 0 before starting a request, and
don't overwrite it unless it still contains 0.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index d45dfa2..02529af 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -694,6 +694,7 @@ static void atmci_start_request(struct atmel_mci *host,
 
 	host->pending_events = 0;
 	host->completed_events = 0;
+	host->data_status = 0;
 
 	if (host->need_reset) {
 		mci_writel(host, CR, MCI_CR_SWRST);
@@ -1408,7 +1409,8 @@ static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 		if (pending & MCI_NOTBUSY) {
 			mci_writel(host, IDR,
 					ATMCI_DATA_ERROR_FLAGS | MCI_NOTBUSY);
-			host->data_status = status;
+			if (!host->data_status)
+				host->data_status = status;
 			smp_wmb();
 			atmci_set_pending(host, EVENT_DATA_COMPLETE);
 			tasklet_schedule(&host->tasklet);
-- 
1.5.6.5

