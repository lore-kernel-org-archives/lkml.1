Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0BXHiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:12 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39422 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0BXHiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=b/FV9EFT1OxHXY7YBSSSZHNmW8TmE5nw7I6ie41sOfSOY/eAclMNpjsTQfouhQh/o3
         T3jp2vaEaGcDrFtYkpeKeuEvJPK/u2JExNki36ElggjJO4IcBIhybw+Tw0aPQb4lwxOb
         Ir/jyQYQdaSejPsejL142MeTWJJQk8bv5ENE8=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 05/14] Regulators: tps65023-regulator - mark probe method as
	__devinit
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:06 -0800
Message-ID: <20100224073806.15964.87649.stgit@localhost.localdomain>
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

 drivers/regulator/tps65023-regulator.c |   35 +++++++++++++++-----------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 07fda0a..1f18354 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -457,8 +457,8 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.list_voltage = tps65023_ldo_list_voltage,
 };
 
-static
-int tps_65023_probe(struct i2c_client *client, const struct i2c_device_id *id)
+static int __devinit tps_65023_probe(struct i2c_client *client,
+				     const struct i2c_device_id *id)
 {
 	static int desc_id;
 	const struct tps_info *info = (void *)id->driver_data;
@@ -466,6 +466,7 @@ int tps_65023_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	struct regulator_dev *rdev;
 	struct tps_pmic *tps;
 	int i;
+	int error;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
@@ -475,7 +476,6 @@ int tps_65023_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * coming from the board-evm file.
 	 */
 	init_data = client->dev.platform_data;
-
 	if (!init_data)
 		return -EIO;
 
@@ -502,21 +502,12 @@ int tps_65023_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Register the regulators */
 		rdev = regulator_register(&tps->desc[i], &client->dev,
-								init_data, tps);
+					  init_data, tps);
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
-			kfree(tps);
-			return PTR_ERR(rdev);
+			error = PTR_ERR(rdev);
+			goto fail;
 		}
 
 		/* Save regulator for cleanup */
@@ -526,6 +517,13 @@ int tps_65023_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	i2c_set_clientdata(client, tps);
 
 	return 0;
+
+ fail:
+	while (--i >= 0)
+		regulator_unregister(tps->rdev[i]);
+
+	kfree(tps);
+	return error;
 }
 
 /**
@@ -539,13 +537,12 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 	struct tps_pmic *tps = i2c_get_clientdata(client);
 	int i;
 
+	/* clear the client data in i2c */
+	i2c_set_clientdata(client, NULL);
+
 	for (i = 0; i < TPS65023_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
 
-	tps->client = NULL;
-
-	/* clear the client data in i2c */
-	i2c_set_clientdata(client, NULL);
 	kfree(tps);
 
 	return 0;

