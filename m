Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYK0QYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYK0QYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYK0QYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:24:00 -0500
Received: from mail.atmel.fr ([81.80.104.162]:54440 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYK0QX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:23:59 -0500
Message-ID: <492EC995.8050701@atmel.com>
Date: Thu, 27 Nov 2008 17:23:49 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: wux@landicorp.com, Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: at91_mci: reorder timer setup and mmc_add_host() call
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As said in function comment mmc_add_host() requires that:
"The host must be prepared to start servicing requests
before this function completes."

During this function, at91_mci_request() can be invoqued
without timer beeing setup leading to a kernel Oops.
This has been reported inserting this driver as a module.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reported-by: Wu Xuan <wux@landicorp.com>
---
 drivers/mmc/host/at91_mci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 1f8b5b3..e556d42 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -1088,6 +1088,8 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 		goto fail0;
 	}
 
+	setup_timer(&host->timer, at91_timeout_timer, (unsigned long)host);
+
 	platform_set_drvdata(pdev, mmc);
 
 	/*
@@ -1101,8 +1103,6 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 
 	mmc_add_host(mmc);
 
-	setup_timer(&host->timer, at91_timeout_timer, (unsigned long)host);
-
 	/*
 	 * monitor card insertion/removal if we can
 	 */
-- 
1.5.3.7



