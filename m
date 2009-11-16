Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZKPGJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZKPGJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZKPGJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:09:53 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58393 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZKPGIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=XCTx6B+2fo89flibJDyRPME3I1/XLLCMOXidKEnh1Lw2mewT1seduo8h1ryenWbUNV
         1f4L2U9qclZZxfxGbUVKdiBdUuUkCgJz3jziPDY/3ui3A9p01560866U4p0Lo4eNJV7u
         JCYCGrOiCp1BVF+Rlzj/4/luicqIiSyjc/BuA=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3/5] mfd: pcf50633 - move creating of regulator devices out of
	line
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Balaji Rao <balajirrao@openmoko.org>
Date: Sun, 15 Nov 2009 22:08:54 -0800
Message-ID: <20091116060854.20162.55542.stgit@localhost.localdomain>
In-Reply-To: <20091116060611.20162.81714.stgit@localhost.localdomain>
References: <20091116060611.20162.81714.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up pcf50633_probe a bit and lays ground for the patch adding
error handling to the probe function.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/mfd/pcf50633-core.c |   57 +++++++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index ff43f34..474a76c 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -438,6 +438,45 @@ out:
 	return IRQ_HANDLED;
 }
 
+static int pcf50633_regulator_dev_register(struct pcf50633 *pcf,
+					   unsigned int num)
+{
+	struct pcf50633_platform_data *pdata = pcf->pdata;
+	struct platform_device *pdev;
+	int error;
+
+	pdev = platform_device_alloc("pcf50633-regltr", num);
+	if (!pdev) {
+		dev_err(pcf->dev,
+			"Not enough memory for regulator device %d\n", num);
+		return -ENOMEM;
+	}
+
+	pdev->dev.parent = pcf->dev;
+
+	error = platform_device_add_data(pdev, &pdata->reg_init_data[num],
+					 sizeof(pdata->reg_init_data[num]));
+	if (error) {
+		dev_err(pcf->dev, "Failed to add platform data for %s: %d\n",
+			dev_name(&pdev->dev), error);
+		goto err_free_dev;
+	}
+
+	error = platform_device_add(pdev);
+	if (error) {
+		dev_err(pcf->dev, "Failed to register %s: %d\n",
+			dev_name(&pdev->dev), error);
+		goto err_free_dev;
+	}
+
+	pcf->regulator_pdev[num] = pdev;
+	return 0;
+
+ err_free_dev:
+	platform_device_put(pdev);
+	return error;
+}
+
 static void
 pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
 						struct platform_device **pdev)
@@ -588,22 +627,8 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_client_dev_register(pcf, "pcf50633-adc",
 						&pcf->adc_pdev);
 
-	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
-		struct platform_device *pdev;
-
-		pdev = platform_device_alloc("pcf50633-regltr", i);
-		if (!pdev) {
-			dev_err(pcf->dev, "Cannot create regulator %d\n", i);
-			continue;
-		}
-
-		pdev->dev.parent = pcf->dev;
-		platform_device_add_data(pdev, &pdata->reg_init_data[i],
-					sizeof(pdata->reg_init_data[i]));
-		pcf->regulator_pdev[i] = pdev;
-
-		platform_device_add(pdev);
-	}
+	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
+		pcf50633_regulator_dev_register(pcf, i);
 
 	if (enable_irq_wake(client->irq) < 0)
 		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"

