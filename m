Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab0CAKyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:54:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54475 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0CAKyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:54:03 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 5/6] rtc/mc13783: protect rtc {,un}registration by mc13783 lock
Date: Mon,  1 Mar 2010 11:53:44 +0100
Message-Id: <1267440825-14694-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: rtc-linux@googlegroups.com
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to protect from interrupt handlers using an unregistered rtc
device.

To assert that the reset irq is considered now before the rtc is
registered the corresponding status is checked before.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this depends on patch 4/6 which added mc13783_irq_status.

Best regards
Uwe

 drivers/rtc/rtc-mc13783.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
index 0a978a0..6a36201 100644
--- a/drivers/rtc/rtc-mc13783.c
+++ b/drivers/rtc/rtc-mc13783.c
@@ -169,6 +169,7 @@ static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct mc13783_rtc *priv;
+	int rtcrst_pending;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -177,8 +178,6 @@ static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
 	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, priv);
 
-	priv->valid = 1;
-
 	mc13783_lock(priv->mc13783);
 
 	ret = mc13783_irq_request(priv->mc13783, MC13783_IRQ_RTCRST,
@@ -186,33 +185,37 @@ static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_reset_irq_request;
 
+	ret = mc13783_irq_status(priv->mc13783, MC13783_IRQ_RTCRST,
+			NULL, &rtcrst_pending);
+	if (ret)
+		goto err_reset_irq_status;
+
+	priv->valid = !rtcrst_pending;
+
 	ret = mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
 			mc13783_rtc_update_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_update_irq_request;
 
-	mc13783_unlock(priv->mc13783);
-
 	priv->rtc = rtc_device_register(pdev->name,
 			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
-
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
-		mc13783_lock(priv->mc13783);
-
 		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 err_update_irq_request:
 
+err_reset_irq_status:
+
 		mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
 err_reset_irq_request:
 
-		mc13783_unlock(priv->mc13783);
-
 		platform_set_drvdata(pdev, NULL);
 		kfree(priv);
 	}
 
+	mc13783_unlock(priv->mc13783);
+
 	return ret;
 }
 
@@ -220,10 +223,10 @@ static int __devexit mc13783_rtc_remove(struct platform_device *pdev)
 {
 	struct mc13783_rtc *priv = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(priv->rtc);
-
 	mc13783_lock(priv->mc13783);
 
+	rtc_device_unregister(priv->rtc);
+
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
 
-- 
1.7.0

