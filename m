Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZDFMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZDFMBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZDFMBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:01:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47091 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbZDFMBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:01:06 -0400
Message-ID: <49D9EF0F.9090808@nokia.com>
Date: Mon, 06 Apr 2009 15:01:19 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: [PATCH] omap_hsmmc: Flush posted write to IRQ
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2009 12:00:19.0509 (UTC) FILETIME=[41BB3650:01C9B6AF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@deeprootsystems.com>

Spurious IRQs seen on MMC after 2.6.29.  Flush posted write in IRQ
handler.

The interrupt line is released by clearing the error status bits
in the MMCHS_STAT register, which must occur before the interrupt
handler returns to avoid unwanted irqs.  Hence the need to flush
the posted write.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---




This patch is slightly modified from Kevin's original, which is
here:

	http://marc.info/?l=linux-omap&m=123862814815052&w=2



 drivers/mmc/host/omap_hsmmc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 04e5a0c..2ae6049 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -452,6 +452,8 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	if (host->mrq == NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
 			OMAP_HSMMC_READ(host->base, STAT));
+		/* Flush posted write */
+		OMAP_HSMMC_READ(host->base, STAT);
 		return IRQ_HANDLED;
 	}
 
@@ -523,6 +525,8 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	}
 
 	OMAP_HSMMC_WRITE(host->base, STAT, status);
+	/* Flush posted write */
+	OMAP_HSMMC_READ(host->base, STAT);
 
 	if (end_cmd || (status & CC))
 		mmc_omap_cmd_done(host, host->cmd);
-- 
1.5.6.3
