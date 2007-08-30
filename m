Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbXH3OPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbXH3OPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758785AbXH3OP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:15:26 -0400
Received: from mail.atmel.fr ([81.80.104.162]:41446 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbXH3OPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:15:24 -0400
Message-ID: <46D6D0F4.3090904@rfo.atmel.com>
Date: Thu, 30 Aug 2007 16:15:16 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Andrew Victor <andrew@sanpeople.com>, Marc Pignat <marc.pignat@hevs.ch>,
       anti.sullin@artecdesign.ee,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: [PATCH] bug in AT91 MCI suspend routines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anti Sullin <anti.sullin@artecdesign.ee>

This patch fixes a bug in AT91 mmc host driver, that enables the wakeup 
from suspend on card detection pin even if the card detect pin is not 
available (==0). If not card detection pin is defined, IRQ0 == FIQ gets 
enabled and if some activity is present on that pin, the system gets a 
FIQ request, that causes a crash.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
---

Original patch from Anti Sullin reviewed by Andrew Victor and
Marc Pignat ; thank you to all of you.

 drivers/mmc/host/at91_mci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-snapshot/drivers/mmc/host/at91_mci.c
===================================================================
--- linux-2.6-snapshot.orig/drivers/mmc/host/at91_mci.c
+++ linux-2.6-snapshot/drivers/mmc/host/at91_mci.c
@@ -941,7 +941,7 @@ static int __exit at91_mci_remove(struct
 
 	host = mmc_priv(mmc);
 
-	if (host->present != -1) {
+	if (host->board->det_pin) {
 		device_init_wakeup(&pdev->dev, 0);
 		free_irq(host->board->det_pin, host);
 		cancel_delayed_work(&host->mmc->detect);
@@ -972,7 +972,7 @@ static int at91_mci_suspend(struct platf
 	struct at91mci_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	if (device_may_wakeup(&pdev->dev))
+	if (host->board->det_pin && device_may_wakeup(&pdev->dev))
 		enable_irq_wake(host->board->det_pin);
 
 	if (mmc)
@@ -987,7 +987,7 @@ static int at91_mci_resume(struct platfo
 	struct at91mci_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	if (device_may_wakeup(&pdev->dev))
+	if (host->board->det_pin && device_may_wakeup(&pdev->dev))
 		disable_irq_wake(host->board->det_pin);
 
 	if (mmc)
