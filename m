Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYJPRPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYJPRPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYJPRNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:13:13 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7155 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755170AbYJPRNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:13:11 -0400
Date: Thu, 16 Oct 2008 21:13:06 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 6/7] gpio/pca953x: convert to dev_gpiochip_add and make it
	work with the OF
Message-ID: <20081016171306.GF5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With OpenFirmware we can't handle platform data for the devices, so let's
not strictly depend on it. That way we can't set polarity invertion for
this controller, but we'll handle this with active-low/high GPIO flags in
the OF tree.

Also switch the driver to dev_gpiochip calls, so that OF subsystem would
know about the newly registered chips.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/pca953x.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index cc84686..6e51fda 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -188,7 +188,6 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
 	gc->label = chip->client->name;
-	gc->dev = &chip->client->dev;
 	gc->owner = THIS_MODULE;
 }
 
@@ -200,8 +199,6 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	int ret;
 
 	pdata = client->dev.platform_data;
-	if (pdata == NULL)
-		return -ENODEV;
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -209,7 +206,10 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 
 	chip->client = client;
 
-	chip->gpio_start = pdata->gpio_base;
+	if (pdata)
+		chip->gpio_start = pdata->gpio_base;
+	else
+		chip->gpio_start = -1;
 
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
@@ -225,16 +225,18 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 		goto out_failed;
 
 	/* set platform specific polarity inversion */
-	ret = pca953x_write_reg(chip, PCA953X_INVERT, pdata->invert);
-	if (ret)
-		goto out_failed;
+	if (pdata) {
+		ret = pca953x_write_reg(chip, PCA953X_INVERT, pdata->invert);
+		if (ret)
+			goto out_failed;
+	}
 
 
-	ret = gpiochip_add(&chip->gpio_chip);
+	ret = dev_gpiochip_add(&client->dev, &chip->gpio_chip);
 	if (ret)
 		goto out_failed;
 
-	if (pdata->setup) {
+	if (pdata && pdata->setup) {
 		ret = pdata->setup(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0)
@@ -255,7 +257,7 @@ static int pca953x_remove(struct i2c_client *client)
 	struct pca953x_chip *chip = i2c_get_clientdata(client);
 	int ret = 0;
 
-	if (pdata->teardown) {
+	if (pdata && pdata->teardown) {
 		ret = pdata->teardown(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0) {
@@ -265,7 +267,7 @@ static int pca953x_remove(struct i2c_client *client)
 		}
 	}
 
-	ret = gpiochip_remove(&chip->gpio_chip);
+	ret = dev_gpiochip_remove(&client->dev, &chip->gpio_chip);
 	if (ret) {
 		dev_err(&client->dev, "%s failed, %d\n",
 				"gpiochip_remove()", ret);
-- 
1.5.6.3

