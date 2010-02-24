Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0BXHpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:45:35 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48790 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0BXHpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:45:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=xV2ezw+HomxxzZvsY0jEbdj37AoM7SzjaHRF6uqLNF1M7IMD33TivkpHLuqub47+vT
         PjjKT8qZQ/aTOcqo0nTtrX1UsOiu2gggtDHkeojPZ4jL+lGlfCfF1gICOcFlaW204mZG
         5UvTWI0K4cs+qjPCSwyePjFS4/e7gWnrqmuuw=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 03/14] Regulators: fixed - annotate probe and remove methods
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:37:55 -0800
Message-ID: <20100224073755.15964.7976.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __devinit/__devexit markings to probe and remove methids of the
driver, change types of variables containing boolean data to boolean,
set up driver's owner field so we have proper sysfs link between
driver and the module.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/fixed.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index a3d3bfc..d11f762 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -32,8 +32,8 @@ struct fixed_voltage_data {
 	int microvolts;
 	int gpio;
 	unsigned startup_delay;
-	unsigned enable_high:1;
-	unsigned is_enabled:1;
+	bool enable_high;
+	bool is_enabled;
 };
 
 static int fixed_voltage_is_enabled(struct regulator_dev *dev)
@@ -49,7 +49,7 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
 
 	if (gpio_is_valid(data->gpio)) {
 		gpio_set_value_cansleep(data->gpio, data->enable_high);
-		data->is_enabled = 1;
+		data->is_enabled = true;
 	}
 
 	return 0;
@@ -61,7 +61,7 @@ static int fixed_voltage_disable(struct regulator_dev *dev)
 
 	if (gpio_is_valid(data->gpio)) {
 		gpio_set_value_cansleep(data->gpio, !data->enable_high);
-		data->is_enabled = 0;
+		data->is_enabled = false;
 	}
 
 	return 0;
@@ -101,7 +101,7 @@ static struct regulator_ops fixed_voltage_ops = {
 	.list_voltage = fixed_voltage_list_voltage,
 };
 
-static int regulator_fixed_voltage_probe(struct platform_device *pdev)
+static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 {
 	struct fixed_voltage_config *config = pdev->dev.platform_data;
 	struct fixed_voltage_data *drvdata;
@@ -174,7 +174,7 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 		/* Regulator without GPIO control is considered
 		 * always enabled
 		 */
-		drvdata->is_enabled = 1;
+		drvdata->is_enabled = true;
 	}
 
 	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
@@ -202,7 +202,7 @@ err:
 	return ret;
 }
 
-static int regulator_fixed_voltage_remove(struct platform_device *pdev)
+static int __devexit reg_fixed_voltage_remove(struct platform_device *pdev)
 {
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
@@ -216,10 +216,11 @@ static int regulator_fixed_voltage_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver regulator_fixed_voltage_driver = {
-	.probe		= regulator_fixed_voltage_probe,
-	.remove		= regulator_fixed_voltage_remove,
+	.probe		= reg_fixed_voltage_probe,
+	.remove		= __devexit_p(reg_fixed_voltage_remove),
 	.driver		= {
 		.name		= "reg-fixed-voltage",
+		.owner		= THIS_MODULE,
 	},
 };
 

