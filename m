Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbZHESaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbZHESaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZHES36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:29:58 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38175 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZHES34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:29:56 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Steve Glendinning <steve.glendinning@smsc.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 5/5] net: smsc911x: switch to new dev_pm_ops
Date: Wed,  5 Aug 2009 20:29:31 +0200
Message-Id: <1249496971-9019-5-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249496971-9019-4-git-send-email-daniel@caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
 <1249496971-9019-2-git-send-email-daniel@caiaq.de>
 <1249496971-9019-3-git-send-email-daniel@caiaq.de>
 <1249496971-9019-4-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hibernation is unsupported for now, which meets the actual
implementation in the driver. For free/thaw, the chip's D2 state should
be entered.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Steve Glendinning <steve.glendinning@smsc.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/smsc911x.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
index 94b6d26..c266785 100644
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -50,6 +50,7 @@
 #include <linux/swab.h>
 #include <linux/phy.h>
 #include <linux/smsc911x.h>
+#include <linux/device.h>
 #include "smsc911x.h"
 
 #define SMSC_CHIPNAME		"smsc911x"
@@ -2114,10 +2115,12 @@ out_0:
 /* This implementation assumes the devices remains powered on its VDDVARIO
  * pins during suspend. */
 
-static int smsc911x_suspend(struct platform_device *pdev, pm_message_t state)
+/* TODO: implement freeze/thaw callbacks for hibernation.*/
+
+static int smsc911x_suspend(struct device *dev)
 {
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct smsc911x_data *pdata = netdev_priv(dev);
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct smsc911x_data *pdata = netdev_priv(ndev);
 
 	/* enable wake on LAN, energy detection and the external PME
 	 * signal. */
@@ -2128,10 +2131,10 @@ static int smsc911x_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int smsc911x_resume(struct platform_device *pdev)
+static int smsc911x_resume(struct device *dev)
 {
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct smsc911x_data *pdata = netdev_priv(dev);
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct smsc911x_data *pdata = netdev_priv(ndev);
 	unsigned int to = 100;
 
 	/* Note 3.11 from the datasheet:
@@ -2149,19 +2152,25 @@ static int smsc911x_resume(struct platform_device *pdev)
 	return (to == 0) ? -EIO : 0;
 }
 
+static struct dev_pm_ops smsc911x_pm_ops = {
+	.suspend	= smsc911x_suspend,
+	.resume		= smsc911x_resume,
+};
+
+#define SMSC911X_PM_OPS (&smsc911x_pm_ops)
+
 #else
-#define smsc911x_suspend	NULL
-#define smsc911x_resume		NULL
+#define SMSC911X_PM_OPS NULL
 #endif
 
 static struct platform_driver smsc911x_driver = {
 	.probe = smsc911x_drv_probe,
 	.remove = __devexit_p(smsc911x_drv_remove),
 	.driver = {
-		.name = SMSC_CHIPNAME,
+		.name	= SMSC_CHIPNAME,
+		.owner	= THIS_MODULE,
+		.pm	= SMSC911X_PM_OPS,
 	},
-	.suspend = smsc911x_suspend,
-	.resume = smsc911x_resume,
 };
 
 /* Entry point for loading the module */
-- 
1.6.3.3

