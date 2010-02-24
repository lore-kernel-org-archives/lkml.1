Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0BXHiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:24 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:42613 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0BXHiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=rq8Cz7scz+wF/8YG+vzgfcIl8JUEX1iqLlPlVaDO1sgYYMVE7ND3w2LhtXs9MRaMA7
         KEFOqiif2vRZVrXJrRRMBc5Or+DSrkaEm6N/92j120//rAVvhlQ5pRwFtLwUnrsKPZBD
         /TFxy8r/+Y6AefOGqQQq2D1op7uF5lP90SD8U=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 07/14] Regulators: lp3971 - fail if platform data was not
	supplied
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:17 -0800
Message-ID: <20100224073817.15964.82625.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in completing probe if platform data is missing so
let's abort loading early.

Also, use kcalloc when allocating several instances of the same data
structure and mark setup_regulators() as __devinit since it is only
called from lp3971_i2c_probe() which is __devinit.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/lp3971.c |   58 ++++++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 3ea639f..f5532ed 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -431,20 +431,20 @@ static int lp3971_set_bits(struct lp3971 *lp3971, u8 reg, u16 mask, u16 val)
 	return ret;
 }
 
-static int setup_regulators(struct lp3971 *lp3971,
-	struct lp3971_platform_data *pdata)
+static int __devinit setup_regulators(struct lp3971 *lp3971,
+				      struct lp3971_platform_data *pdata)
 {
 	int i, err;
-	int num_regulators = pdata->num_regulators;
-	lp3971->num_regulators = num_regulators;
-	lp3971->rdev = kzalloc(sizeof(struct regulator_dev *) * num_regulators,
-		GFP_KERNEL);
+
+	lp3971->num_regulators = pdata->num_regulators;
+	lp3971->rdev = kcalloc(pdata->num_regulators,
+				sizeof(struct regulator_dev *), GFP_KERNEL);
 
 	/* Instantiate the regulators */
-	for (i = 0; i < num_regulators; i++) {
-		int id = pdata->regulators[i].id;
-		lp3971->rdev[i] = regulator_register(&regulators[id],
-			lp3971->dev, pdata->regulators[i].initdata, lp3971);
+	for (i = 0; i < pdata->num_regulators; i++) {
+		struct lp3971_regulator_subdev *reg = &pdata->regulators[i];
+		lp3971->rdev[i] = regulator_register(&regulators[reg->id],
+					lp3971->dev, reg->initdata, lp3971);
 
 		if (IS_ERR(lp3971->rdev[i])) {
 			err = PTR_ERR(lp3971->rdev[i]);
@@ -455,10 +455,10 @@ static int setup_regulators(struct lp3971 *lp3971,
 	}
 
 	return 0;
+
 error:
-	for (i = 0; i < num_regulators; i++)
-		if (lp3971->rdev[i])
-			regulator_unregister(lp3971->rdev[i]);
+	while (--i >= 0)
+		regulator_unregister(lp3971->rdev[i]);
 	kfree(lp3971->rdev);
 	lp3971->rdev = NULL;
 	return err;
@@ -472,15 +472,17 @@ static int __devinit lp3971_i2c_probe(struct i2c_client *i2c,
 	int ret;
 	u16 val;
 
-	lp3971 = kzalloc(sizeof(struct lp3971), GFP_KERNEL);
-	if (lp3971 == NULL) {
-		ret = -ENOMEM;
-		goto err;
+	if (!pdata) {
+		dev_dbg(&i2c->dev, "No platform init data supplied\n");
+		return -ENODEV;
 	}
 
+	lp3971 = kzalloc(sizeof(struct lp3971), GFP_KERNEL);
+	if (lp3971 == NULL)
+		return -ENOMEM;
+
 	lp3971->i2c = i2c;
 	lp3971->dev = &i2c->dev;
-	i2c_set_clientdata(i2c, lp3971);
 
 	mutex_init(&lp3971->io_lock);
 
@@ -493,19 +495,15 @@ static int __devinit lp3971_i2c_probe(struct i2c_client *i2c,
 		goto err_detect;
 	}
 
-	if (pdata) {
-		ret = setup_regulators(lp3971, pdata);
-		if (ret < 0)
-			goto err_detect;
-	} else
-		dev_warn(lp3971->dev, "No platform init data supplied\n");
+	ret = setup_regulators(lp3971, pdata);
+	if (ret < 0)
+		goto err_detect;
 
+	i2c_set_clientdata(i2c, lp3971);
 	return 0;
 
 err_detect:
-	i2c_set_clientdata(i2c, NULL);
 	kfree(lp3971);
-err:
 	return ret;
 }
 
@@ -513,11 +511,13 @@ static int __devexit lp3971_i2c_remove(struct i2c_client *i2c)
 {
 	struct lp3971 *lp3971 = i2c_get_clientdata(i2c);
 	int i;
+
+	i2c_set_clientdata(i2c, NULL);
+
 	for (i = 0; i < lp3971->num_regulators; i++)
-		if (lp3971->rdev[i])
-			regulator_unregister(lp3971->rdev[i]);
+		regulator_unregister(lp3971->rdev[i]);
+
 	kfree(lp3971->rdev);
-	i2c_set_clientdata(i2c, NULL);
 	kfree(lp3971);
 
 	return 0;

