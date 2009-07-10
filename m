Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZGJMoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZGJMoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZGJMkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:40:11 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37308 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbZGJMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:40:08 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:43:30 +0300
Message-Id: <20090710124330.1262.68846.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 29/32] omap_hsmmc: protect the card when the cover is open
X-OriginalArrivalTime: 10 Jul 2009 12:39:54.0088 (UTC) FILETIME=[86557680:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9b524a70c3d8f3d138646630bb2144c9895af47a Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Fri, 22 May 2009 16:53:49 +0300
Subject: [PATCH] omap_hsmmc: protect the card when the cover is open

Depending on the manufacturer, there is a small possibility that
removing a card while it is being written to, can render the
card permanently unusable.  To prevent that, the card is made
inaccessible when the cover is open.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   63 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 5055d52..2570bfe 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -163,6 +163,8 @@ struct omap_hsmmc_host {
 	int			context_loss;
 	int			dpm_state;
 	int			vdd;
+	int			protect_card;
+	int			reqs_blocked;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -347,6 +349,9 @@ static void send_init_stream(struct omap_hsmmc_host *host)
 	int reg = 0;
 	unsigned long timeout;
 
+	if (host->protect_card)
+		return;
+
 	disable_irq(host->irq);
 	OMAP_HSMMC_WRITE(host->base, CON,
 		OMAP_HSMMC_READ(host->base, CON) | INIT_STREAM);
@@ -771,6 +776,30 @@ err:
 	return ret;
 }
 
+/* Protect the card while the cover is open */
+static void omap_hsmmc_protect_card(struct omap_hsmmc_host *host)
+{
+	if (!mmc_slot(host).get_cover_state)
+		return;
+
+	host->reqs_blocked = 0;
+	if (mmc_slot(host).get_cover_state(host->dev, host->slot_id)) {
+		if (host->protect_card) {
+			printk(KERN_INFO "%s: cover is closed, "
+					 "card is now accessible\n",
+					 mmc_hostname(host->mmc));
+			host->protect_card = 0;
+		}
+	} else {
+		if (!host->protect_card) {
+			printk(KERN_INFO "%s: cover is open, "
+					 "card is now inaccessible\n",
+					 mmc_hostname(host->mmc));
+			host->protect_card = 1;
+		}
+	}
+}
+
 /*
  * Work Item to notify the core about card insertion/removal
  */
@@ -788,8 +817,10 @@ static void omap_hsmmc_detect(struct work_struct *work)
 
 	if (slot->card_detect)
 		carddetect = slot->card_detect(slot->card_detect_irq);
-	else
+	else {
+		omap_hsmmc_protect_card(host);
 		carddetect = -ENOSYS;
+	}
 
 	if (carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
@@ -1025,8 +1056,32 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 	 * interrupts, but not if we are already in interrupt context i.e.
 	 * retries.
 	 */
-	if (!in_interrupt())
+	if (!in_interrupt()) {
 		disable_irq(host->irq);
+		/*
+		 * Protect the card from I/O if there is a possibility
+		 * it can be removed.
+		 */
+		if (host->protect_card) {
+			if (host->reqs_blocked < 3) {
+				/*
+				 * Ensure the controller is left in a consistent
+				 * state by resetting the command and data state
+				 * machines.
+				 */
+				omap_hsmmc_reset_controller_fsm(host, SRD);
+				omap_hsmmc_reset_controller_fsm(host, SRC);
+				host->reqs_blocked += 1;
+			}
+			req->cmd->error = -EBADF;
+			if (req->data)
+				req->data->error = -EBADF;
+			enable_irq(host->irq);
+			mmc_request_done(mmc, req);
+			return;
+		} else if (host->reqs_blocked)
+			host->reqs_blocked = 0;
+	}
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
 	err = omap_hsmmc_prepare_data(host, req);
@@ -1715,6 +1770,8 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 
 	mmc_host_lazy_disable(host->mmc);
 
+	omap_hsmmc_protect_card(host);
+
 	mmc_add_host(mmc);
 
 	if (mmc_slot(host).name != NULL) {
@@ -1880,6 +1937,8 @@ static int omap_hsmmc_resume(struct platform_device *pdev)
 					"Unmask interrupt failed\n");
 		}
 
+		omap_hsmmc_protect_card(host);
+
 		/* Notify the core to resume the host */
 		ret = mmc_resume_host(host->mmc);
 		if (ret == 0)
-- 
1.5.6.3

