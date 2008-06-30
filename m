Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYF3JXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYF3JXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760204AbYF3JWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:22:39 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62562 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183AbYF3JWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:22:37 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Jeff Garzik <jeff@garzik.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>
Subject: [PATCH 3/8] macb: Basic suspend/resume support
Date: Mon, 30 Jun 2008 11:21:11 +0200
Message-Id: <1214817676-30378-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:07.0726 (UTC) FILETIME=[A0C2CAE0:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

This implements suspend and resume callbacks for the macb driver. We may
have to do some more to gracefully shut the MAC down, but this at least
prevents the macb from waking the system when hooked up to a busy
network.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Cc: Nicolas FERRE <nicolas.ferre@rfo.atmel.com>
---
 drivers/net/macb.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index 92dccd4..0a5745a 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -1277,8 +1277,45 @@ static int __exit macb_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int macb_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct net_device *netdev = platform_get_drvdata(pdev);
+	struct macb *bp = netdev_priv(netdev);
+
+	netif_device_detach(netdev);
+
+#ifndef CONFIG_ARCH_AT91
+	clk_disable(bp->hclk);
+#endif
+	clk_disable(bp->pclk);
+
+	return 0;
+}
+
+static int macb_resume(struct platform_device *pdev)
+{
+	struct net_device *netdev = platform_get_drvdata(pdev);
+	struct macb *bp = netdev_priv(netdev);
+
+	clk_enable(bp->pclk);
+#ifndef CONFIG_ARCH_AT91
+	clk_enable(bp->hclk);
+#endif
+
+	netif_device_attach(netdev);
+
+	return 0;
+}
+#else
+#define macb_suspend	NULL
+#define macb_resume	NULL
+#endif
+
 static struct platform_driver macb_driver = {
 	.remove		= __exit_p(macb_remove),
+	.suspend	= macb_suspend,
+	.resume		= macb_resume,
 	.driver		= {
 		.name		= "macb",
 		.owner	= THIS_MODULE,
-- 
1.5.5.4

