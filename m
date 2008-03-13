Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYCMPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYCMPr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYCMPrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:47:10 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:26879 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYCMPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:47:08 -0400
X-Greylist: delayed 2165 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 11:47:07 EDT
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 07/10] macb: Basic suspend/resume support
Date: Thu, 13 Mar 2008 15:39:42 +0100
Message-Id: <1205419185-26395-8-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-7-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-4-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-5-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-6-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-7-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0508 (UTC) FILETIME=[156AA8C0:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/net/macb.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index 1d210ed..94bf2ba 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -1275,8 +1275,45 @@ static int __exit macb_remove(struct platform_device *pdev)
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
 	},
-- 
1.5.4.3

