Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0BXHoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:44:22 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:42086 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab0BXHoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:44:20 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 02:44:20 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=ErJKEve2dmCXTX439HV/fOa/h26kzJWWvKDYgR7vFsUkjCYSDUbX3whgCEpZjXniur
         pXkUdu7klggak0qbQKEA4pVPIdln1f0fRPQ9IXdqV8Kg3WSxIvkHVZYn3x3M0Ju8I7E9
         3ObeFpbRYsKeySa31DoVUH9m0zCgcGpMIQ3zk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver data
	handling
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:50 -0800
Message-ID: <20100224073849.15964.62321.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver data set by platform_set_drvdata() is for private use of
the driver currently bound to teh device and not for use by parent,
subsystem and anyone else.

Also have wm8400_register_regulator() accept 'sturct wm8400 *'
instead of generic device structure.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/wm8400-regulator.c |   13 +++++++------
 include/linux/mfd/wm8400.h           |    4 +++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index d9a2c98..71b89e8 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -317,14 +317,17 @@ static struct regulator_desc regulators[] = {
 
 static int __devinit wm8400_regulator_probe(struct platform_device *pdev)
 {
+	struct wm8400 *wm8400 = container_of(pdev, struct wm8400, regulators[pdev->id]);
 	struct regulator_dev *rdev;
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-		pdev->dev.platform_data, dev_get_drvdata(&pdev->dev));
+				  pdev->dev.platform_data, wm8400);
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
+	platform_set_drvdata(pdev, rdev);
+
 	return 0;
 }
 
@@ -332,6 +335,7 @@ static int __devexit wm8400_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
+	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(rdev);
 
 	return 0;
@@ -356,11 +360,9 @@ static struct platform_driver wm8400_regulator_driver = {
  * @param reg      The regulator to control.
  * @param initdata Regulator initdata for the regulator.
  */
-int wm8400_register_regulator(struct device *dev, int reg,
+int wm8400_register_regulator(struct wm8400 *wm8400, int reg,
 			      struct regulator_init_data *initdata)
 {
-	struct wm8400 *wm8400 = dev_get_drvdata(dev);
-
 	if (wm8400->regulators[reg].name)
 		return -EBUSY;
 
@@ -368,9 +370,8 @@ int wm8400_register_regulator(struct device *dev, int reg,
 
 	wm8400->regulators[reg].name = "wm8400-regulator";
 	wm8400->regulators[reg].id = reg;
-	wm8400->regulators[reg].dev.parent = dev;
+	wm8400->regulators[reg].dev.parent = wm8400->dev;
 	wm8400->regulators[reg].dev.platform_data = initdata;
-	dev_set_drvdata(&wm8400->regulators[reg].dev, wm8400);
 
 	return platform_device_register(&wm8400->regulators[reg]);
 }
diff --git a/include/linux/mfd/wm8400.h b/include/linux/mfd/wm8400.h
index b46b566..f9e49cc 100644
--- a/include/linux/mfd/wm8400.h
+++ b/include/linux/mfd/wm8400.h
@@ -34,7 +34,9 @@ struct wm8400_platform_data {
 	int (*platform_init)(struct device *dev);
 };
 
-int wm8400_register_regulator(struct device *dev, int reg,
+struct wm8400;
+
+int wm8400_register_regulator(struct wm8400 *wm8400, int reg,
 			      struct regulator_init_data *initdata);
 
 #endif

