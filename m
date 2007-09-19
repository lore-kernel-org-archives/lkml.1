Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbXISPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbXISPnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXISPnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:43:21 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:7275 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbXISPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:43:20 -0400
X-IronPort-AV: i="4.20,274,1186372800"; 
   d="scan'208"; a="51816242:sNHT295030218"
Subject: [PATCH 2/4] Blackfin EMAC driver: add power management interface
	and change the bf537mac_reset to bf537mac_disable
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 19 Sep 2007 23:37:14 +0800
Message-Id: <1190216234.15707.28.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 19 Sep 2007 15:37:18.0102 (UTC) FILETIME=[F6061B60:01C7FAD2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/net/bfin_mac.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index ead7be9..5cb4433 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -672,7 +672,7 @@ static void bf537mac_poll(struct net_device *dev)
 }
 #endif				/* CONFIG_NET_POLL_CONTROLLER */
 
-static void bf537mac_reset(void)
+static void bf537mac_disable(void)
 {
 	unsigned int opmode;
 
@@ -730,7 +730,7 @@ static void bf537mac_timeout(struct net_device *dev)
 {
 	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
-	bf537mac_reset();
+	bf537mac_disable();
 
 	/* reset tx queue */
 	tx_list_tail = tx_list_head->next;
@@ -810,7 +810,7 @@ static int bf537mac_open(struct net_device *dev)
 
 	bf537mac_setphy(dev);
 	setup_system_regs(dev);
-	bf537mac_reset();
+	bf537mac_disable();
 	bf537mac_enable(dev);
 
 	pr_debug("hardware init finished\n");
@@ -968,15 +968,30 @@ static int bfin_mac_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int bfin_mac_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM
+static int bfin_mac_suspend(struct platform_device *pdev, pm_message_t mesg)
 {
+	struct net_device *net_dev = platform_get_drvdata(pdev);
+
+	if (netif_running(net_dev))
+		bf537mac_close(net_dev);
+
 	return 0;
 }
 
 static int bfin_mac_resume(struct platform_device *pdev)
 {
+	struct net_device *net_dev = platform_get_drvdata(pdev);
+
+	if (netif_running(net_dev))
+		bf537mac_open(net_dev);
+
 	return 0;
 }
+#else
+#define bfin_mac_suspend NULL
+#define bfin_mac_resume NULL
+#endif	/* CONFIG_PM */
 
 static struct platform_driver bfin_mac_driver = {
 	.probe = bfin_mac_probe,
-- 
1.5.2

