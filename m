Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZFHXGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZFHXGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbZFHXGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:06:20 -0400
Received: from xes-mad.com ([216.165.139.214]:50157 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbZFHXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:06:19 -0400
From: Nate Case <ncase@xes-inc.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Nate Case <ncase@xes-inc.com>
Subject: [PATCH next 1/2] gpio: pca953x: Get platform_data from OpenFirmware
Date: Mon,  8 Jun 2009 17:51:52 -0500
Message-Id: <1244501513-19836-2-git-send-email-ncase@xes-inc.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1244501513-19836-1-git-send-email-ncase@xes-inc.com>
References: <1244501513-19836-1-git-send-email-ncase@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OpenFirmware platforms, it makes the most sense to get platform_data
from the device tree.  Make an attempt to translate OF node properties
into platform_data struct before bailing out.

Note that the implementation approach taken differs from other device
drivers that make use of device tree information.  This is because I2C
chips are already registered automatically by of_i2c, so we can get by
with a small translator function in the driver.

Signed-off-by: Nate Case <ncase@xes-inc.com>
---
 drivers/gpio/pca953x.c |   79 ++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 8dc0164..258246e 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -15,6 +15,10 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
+#ifdef CONFIG_OF_GPIO
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#endif
 
 #include <asm/gpio.h>
 
@@ -49,6 +53,7 @@ struct pca953x_chip {
 	uint16_t reg_direction;
 
 	struct i2c_client *client;
+	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
 };
 
@@ -194,6 +199,55 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 	gc->owner = THIS_MODULE;
 }
 
+/*
+ * Handlers for alternative sources of platform_data
+ */
+#ifdef CONFIG_OF_GPIO
+/*
+ * Translate OpenFirmware node properties into platform_data
+ */
+static struct pca953x_platform_data *
+pca953x_get_alt_pdata(struct i2c_client *client)
+{
+	struct pca953x_platform_data *pdata;
+	struct device_node *node;
+	const uint16_t *val;
+
+	node = dev_archdata_get_node(&client->dev.archdata);
+	if (node == NULL)
+		return NULL;
+
+	pdata = kzalloc(sizeof(struct pca953x_platform_data), GFP_KERNEL);
+	if (pdata == NULL) {
+		dev_err(&client->dev, "Unable to allocate platform_data\n");
+		return NULL;
+	}
+
+	pdata->gpio_base = -1;
+	val = of_get_property(node, "linux,gpio-base", NULL);
+	if (val) {
+		if (*val < 0)
+			dev_warn(&client->dev,
+				 "invalid gpio-base in device tree\n");
+		else
+			pdata->gpio_base = *val;
+	}
+
+	val = of_get_property(node, "polarity", NULL);
+	if (val) {
+		pdata->invert = *val;
+	}
+
+	return pdata;
+}
+#else
+static struct pca953x_platform_data *
+pca953x_get_alt_pdata(struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
+
 static int __devinit pca953x_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
@@ -201,15 +255,25 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	struct pca953x_chip *chip;
 	int ret;
 
+	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
 	pdata = client->dev.platform_data;
 	if (pdata == NULL) {
-		dev_dbg(&client->dev, "no platform data\n");
-		return -EINVAL;
+		pdata = pca953x_get_alt_pdata(client);
+		/*
+		 * Unlike normal platform_data, this is allocated
+		 * dynamically and must be freed in the driver
+		 */
+		chip->dyn_pdata = pdata;
 	}
 
-	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
-	if (chip == NULL)
-		return -ENOMEM;
+	if (pdata == NULL) {
+		dev_dbg(&client->dev, "no platform data\n");
+		ret = -EINVAL;
+		goto out_failed;
+	}
 
 	chip->client = client;
 
@@ -249,6 +313,8 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	return 0;
 
 out_failed:
+	if (chip->dyn_pdata != NULL)
+		kfree(chip->dyn_pdata);
 	kfree(chip);
 	return ret;
 }
@@ -276,6 +342,9 @@ static int pca953x_remove(struct i2c_client *client)
 		return ret;
 	}
 
+	if (chip->dyn_pdata != NULL)
+		kfree(chip->dyn_pdata);
+
 	kfree(chip);
 	return 0;
 }
-- 
1.6.0.2

