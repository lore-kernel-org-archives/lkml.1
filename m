Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYJ1Rrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYJ1Rrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYJ1RqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:46:22 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57686 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754060AbYJ1RqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:46:21 -0400
Date: Tue, 28 Oct 2008 20:46:19 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH 5/6] gpio/pca953x: pass gpio_chip pointer to the
	setup/teardown callbacks
Message-ID: <20081028174619.GE25349@oksana.dev.rtsoft.ru>
References: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed so that the platform code could register the chip
with the platform internal structures.

While at it, also change gpio_base to the signed type (we'll pass
-1 for the dynamic allocation).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/pca953x.c      |    7 +++----
 include/linux/i2c/pca953x.h |    8 +++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 9ceeb89..7597e01 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -235,8 +235,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 		goto out_failed;
 
 	if (pdata->setup) {
-		ret = pdata->setup(client, chip->gpio_chip.base,
-				chip->gpio_chip.ngpio, pdata->context);
+		ret = pdata->setup(client, &chip->gpio_chip, pdata->context);
 		if (ret < 0)
 			dev_warn(&client->dev, "setup failed, %d\n", ret);
 	}
@@ -256,8 +255,8 @@ static int pca953x_remove(struct i2c_client *client)
 	int ret = 0;
 
 	if (pdata->teardown) {
-		ret = pdata->teardown(client, chip->gpio_chip.base,
-				chip->gpio_chip.ngpio, pdata->context);
+		ret = pdata->teardown(client, &chip->gpio_chip,
+				      pdata->context);
 		if (ret < 0) {
 			dev_err(&client->dev, "%s failed, %d\n",
 					"teardown", ret);
diff --git a/include/linux/i2c/pca953x.h b/include/linux/i2c/pca953x.h
index 3c73612..60d60c0 100644
--- a/include/linux/i2c/pca953x.h
+++ b/include/linux/i2c/pca953x.h
@@ -1,8 +1,10 @@
 /* platform data for the PCA9539 16-bit I/O expander driver */
 
+struct gpio_chip;
+
 struct pca953x_platform_data {
 	/* number of the first GPIO */
-	unsigned	gpio_base;
+	int		gpio_base;
 
 	/* initial polarity inversion setting */
 	uint16_t	invert;
@@ -10,9 +12,9 @@ struct pca953x_platform_data {
 	void		*context;	/* param to setup/teardown */
 
 	int		(*setup)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
+				struct gpio_chip *chip,
 				void *context);
 	int		(*teardown)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
+				struct gpio_chip *chip,
 				void *context);
 };
-- 
1.5.6.3

