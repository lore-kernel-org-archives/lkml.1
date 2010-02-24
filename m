Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0BXHiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:20 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:42613 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab0BXHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=FQY8mqm/sVMtpvB4igu/kEpnbpnYP15mDw92RKBrbz62dNci/EMuyB2hKfbRVW5yBw
         qFj+pGAtwf0511YuQk46frJBchsY6ui/vfhWuAhRzCE7q/BChz1IuzjsBRgnXHWsaq5q
         M2k86olf6MDV2oLN3amTWzahVBFiVWAX+sbE4=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 06/14] Regulators: tps6507x-regulator - mark probe method as
	__devinit
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:12 -0800
Message-ID: <20100224073811.15964.36760.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also move error handling in probe() out of line and do not bother
to reset fields in structures that are about to be freed.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/tps6507x-regulator.c |   34 ++++++++++++++------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index f8a6dfb..c2a9539 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -538,8 +538,8 @@ static struct regulator_ops tps6507x_ldo_ops = {
 	.list_voltage = tps6507x_ldo_list_voltage,
 };
 
-static
-int tps_6507x_probe(struct i2c_client *client, const struct i2c_device_id *id)
+static int __devinit tps_6507x_probe(struct i2c_client *client,
+				     const struct i2c_device_id *id)
 {
 	static int desc_id;
 	const struct tps_info *info = (void *)id->driver_data;
@@ -547,6 +547,7 @@ int tps_6507x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	struct regulator_dev *rdev;
 	struct tps_pmic *tps;
 	int i;
+	int error;
 
 	if (!i2c_check_functionality(client->adapter,
 				I2C_FUNC_SMBUS_BYTE_DATA))
@@ -557,7 +558,6 @@ int tps_6507x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * coming from the board-evm file.
 	 */
 	init_data = client->dev.platform_data;
-
 	if (!init_data)
 		return -EIO;
 
@@ -586,18 +586,8 @@ int tps_6507x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		if (IS_ERR(rdev)) {
 			dev_err(&client->dev, "failed to register %s\n",
 				id->name);
-
-			/* Unregister */
-			while (i)
-				regulator_unregister(tps->rdev[--i]);
-
-			tps->client = NULL;
-
-			/* clear the client data in i2c */
-			i2c_set_clientdata(client, NULL);
-
-			kfree(tps);
-			return PTR_ERR(rdev);
+			error = PTR_ERR(rdev);
+			goto fail;
 		}
 
 		/* Save regulator for cleanup */
@@ -607,6 +597,13 @@ int tps_6507x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	i2c_set_clientdata(client, tps);
 
 	return 0;
+
+fail:
+	while (--i >= 0)
+		regulator_unregister(tps->rdev[i]);
+
+	kfree(tps);
+	return error;
 }
 
 /**
@@ -620,13 +617,12 @@ static int __devexit tps_6507x_remove(struct i2c_client *client)
 	struct tps_pmic *tps = i2c_get_clientdata(client);
 	int i;
 
+	/* clear the client data in i2c */
+	i2c_set_clientdata(client, NULL);
+
 	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
 
-	tps->client = NULL;
-
-	/* clear the client data in i2c */
-	i2c_set_clientdata(client, NULL);
 	kfree(tps);
 
 	return 0;

