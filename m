Return-Path: <linux-kernel-owner+w=401wt.eu-S934495AbZJMWOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbZJMWOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934486AbZJMWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:14:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:38953 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934474AbZJMWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qmPlbDqaOSTBYtfGDyyzDxhuXHIqLKvgf0+hopfVSgp7G8bhF0BO8UTz/UdxzBIRDt
         zncKMyGPyxe09rvyW1zKQWZ9NSC7aEd9l05uxIY/Qy7tO+Lq3h6SYVDSm5lcnzZtQbxq
         4vwQYcg8TXsl2QJusWRvog2k4gwxQK7AZiyi4=
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 7/7] mfd: pcf50633: Fix pcf50633-regulator drvdata usage
Date: Wed, 14 Oct 2009 02:12:36 +0400
Message-Id: <1255471956-29201-7-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471956-29201-6-git-send-email-fercerpav@gmail.com>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-3-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-4-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-5-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-6-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

Currently the pcf50633-regulator driver data is set to the pcf50633 core
structure, but the pcf50633-regulator remove handler assumes that it is set to
the regulator device. This patch fixes the issue by accessing the pcf506533
core structure through its parent device and setting the driver data to the
regulator device.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c            |    1 -
 drivers/regulator/pcf50633-regulator.c |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 4604ba5..a86b0c6 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -632,7 +632,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 		pdev->dev.parent = pcf->dev;
 		platform_device_add_data(pdev, &pdata->reg_init_data[i],
 					sizeof(pdata->reg_init_data[i]));
-		dev_set_drvdata(&pdev->dev, pcf);
 		pcf->regulator_pdev[i] = pdev;
 
 		platform_device_add(pdev);
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 0803ffe..c8f41dc 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -314,13 +314,15 @@ static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
 	struct pcf50633 *pcf;
 
 	/* Already set by core driver */
-	pcf = platform_get_drvdata(pdev);
+	pcf = dev_to_pcf50633(pdev->dev.parent);
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
 				  pdev->dev.platform_data, pcf);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
+	platform_set_drvdata(pdev, rdev);
+
 	if (pcf->pdata->regulator_registered)
 		pcf->pdata->regulator_registered(pcf, pdev->id);
 
@@ -331,6 +333,7 @@ static int __devexit pcf50633_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
+	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(rdev);
 
 	return 0;
-- 
1.6.0.6

