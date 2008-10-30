Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYJ3B33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYJ3B33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYJ3B3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:29:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3599 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYJ3B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:29:20 -0400
Subject: i2c: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:29:21 +0100
Message-Id: <1225330161.5970.86.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: i2c: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Jean Delvare <khali@linux-fr.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 5a485c2..ce3cd48 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -459,7 +459,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 		pr_debug("I2C adapter driver [%s] forgot to specify "
 			 "physical device\n", adap->name);
 	}
-	sprintf(adap->dev.bus_id, "i2c-%d", adap->nr);
+	dev_set_name(&adap->dev, "i2c-%d", adap->nr);
 	adap->dev.release = &i2c_adapter_dev_release;
 	adap->dev.class = &i2c_adapter_class;
 	res = device_register(&adap->dev);
@@ -845,8 +845,7 @@ int i2c_attach_client(struct i2c_client *client)
 	} else
 		client->dev.release = i2c_client_dev_release;
 
-	snprintf(&client->dev.bus_id[0], sizeof(client->dev.bus_id),
-		"%d-%04x", i2c_adapter_id(adapter), client->addr);
+	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adapter), client->addr);
 	res = device_register(&client->dev);
 	if (res)
 		goto out_err;
@@ -856,7 +855,7 @@ int i2c_attach_client(struct i2c_client *client)
 	mutex_unlock(&adapter->clist_lock);
 
 	dev_dbg(&adapter->dev, "client [%s] registered with bus id %s\n",
-		client->name, client->dev.bus_id);
+		client->name, dev_name(&client->dev));
 
 	if (adapter->client_register)  {
 		if (adapter->client_register(client)) {


