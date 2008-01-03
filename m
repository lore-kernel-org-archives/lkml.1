Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbYACA47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbYACA47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbYACAxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:53:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:32655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760690AbYACAx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:53:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=hzoo0y7qx45m6xKZqGBOo1++pMZQ2DHl6ai75PB/hScrT98RogP3yqMr5AAViYgozHhbqk0AN2CbqjKHYes9sXComQZ8F+V1E6CGQ7JsQM+wIlUZxG5rTkFULWG2GwXWkiJRgnVz9bHM4ZXpzWbWcN5vUbw9BnnQEGT/+8CfkjA=
Date: Thu, 3 Jan 2008 03:53:19 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: [PATCH] pda-power: only register available psu
Message-ID: <20080103005319.GA714@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pda-power adds both ac and usb power supply units.
This patch fixes it so that psu are added only if they are enabled.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index c058f28..42eac09 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -168,21 +168,14 @@ static int pda_power_probe(struct platform_device *pdev)
 		pda_power_supplies[1].num_supplicants = pdata->num_supplicants;
 	}
 
-	ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
-	if (ret) {
-		dev_err(dev, "failed to register %s power supply\n",
-			pda_power_supplies[0].name);
-		goto supply0_failed;
-	}
-
-	ret = power_supply_register(&pdev->dev, &pda_power_supplies[1]);
-	if (ret) {
-		dev_err(dev, "failed to register %s power supply\n",
-			pda_power_supplies[1].name);
-		goto supply1_failed;
-	}
-
 	if (ac_irq) {
+		ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
+		if (ret) {
+			dev_err(dev, "failed to register %s power supply\n",
+				pda_power_supplies[0].name);
+			goto ac_failed;
+		}
+
 		ret = request_irq(ac_irq->start, power_changed_isr,
 				  get_irq_flags(ac_irq), ac_irq->name,
 				  &pda_power_supplies[0]);
@@ -193,6 +186,13 @@ static int pda_power_probe(struct platform_device *pdev)
 	}
 
 	if (usb_irq) {
+		ret = power_supply_register(&pdev->dev, &pda_power_supplies[1]);
+		if (ret) {
+			dev_err(dev, "failed to register %s power supply\n",
+				pda_power_supplies[1].name);
+			goto usb_failed;
+		}
+
 		ret = request_irq(usb_irq->start, power_changed_isr,
 				  get_irq_flags(usb_irq), usb_irq->name,
 				  &pda_power_supplies[1]);
@@ -205,13 +205,14 @@ static int pda_power_probe(struct platform_device *pdev)
 	goto success;
 
 usb_irq_failed:
+	power_supply_unregister(&pda_power_supplies[1]);
+usb_failed:
 	if (ac_irq)
 		free_irq(ac_irq->start, &pda_power_supplies[0]);
 ac_irq_failed:
-	power_supply_unregister(&pda_power_supplies[1]);
-supply1_failed:
-	power_supply_unregister(&pda_power_supplies[0]);
-supply0_failed:
+	if (ac_irq)
+		power_supply_unregister(&pda_power_supplies[0]);
+ac_failed:
 noirqs:
 wrongid:
 success:

-- 
With best wishes
Dmitry

