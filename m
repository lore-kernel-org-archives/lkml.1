Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZBUUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZBUUml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 15:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZBUUmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 15:42:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49492 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZBUUmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 15:42:31 -0500
Date: Sat, 21 Feb 2009 20:41:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090221204147.GA25408@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221194814.GA24385@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 07:48:14PM +0000, Russell King - ARM Linux wrote:
> Previous mail sent just to Jean:
> 
> | Any ideas why the RTC isn't being detected on the ARM RiscPC platform?
> | 
> | Could it be because someone's decided to regress stuff because of having
> | an i2c_boardinfo structure without actually first making sure everything
> | is converted over?
> | 
> | If yes, what do I need to do to make it work?  (IOW, please supply a
> | patch to fix the regression or explain in detail what's required to make
> | it work.)
> 
> To summarise the situation, the bus driver is:
> 
> drivers/i2c/busses/i2c-acorn.c
> 
> which is not a platform driver.  It is not initialised by the platform
> code.  It does not provide i2c_boarddata or whatever the funky name for
> that feature is.
> 
> However, PCF8583 got converted to require i2c_boarddata without first
> fixing up the platform which uses it, thereby making the driver utterly
> useless.
> 
> Putting i2c_boarddata into i2c-acorn.c feels wrong.
> 
> So, please either revert 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 so
> that the regression can be fixed (no RTC on Acorn RiscPC machines) or
> provide a patch which fixes this mess that the above change causes.

Confirmation: reverting 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 and
removing the reference to I2C_DRIVERID_PCF8583 results in the regression
being fixed and normal behaviour being restored.

Patch below.

diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index 7d33cda..d93da76 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -2,7 +2,6 @@
  *  drivers/rtc/rtc-pcf8583.c
  *
  *  Copyright (C) 2000 Russell King
- *  Copyright (C) 2008 Wolfram Sang & Juergen Beisert, Pengutronix
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -15,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/rtc.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -27,6 +27,7 @@ struct rtc_mem {
 };
 
 struct pcf8583 {
+	struct i2c_client client;
 	struct rtc_device *rtc;
 	unsigned char ctrl;
 };
@@ -39,6 +40,10 @@ struct pcf8583 {
 #define CTRL_ALARM	0x02
 #define CTRL_TIMER	0x01
 
+static const unsigned short normal_i2c[] = { 0x50, I2C_CLIENT_END };
+
+/* Module parameters */
+I2C_CLIENT_INSMOD;
 
 static struct i2c_driver pcf8583_driver;
 
@@ -264,60 +269,105 @@ static const struct rtc_class_ops pcf8583_rtc_ops = {
 	.set_time	= pcf8583_rtc_set_time,
 };
 
-static int pcf8583_probe(struct i2c_client *client,
-				const struct i2c_device_id *id)
+static int pcf8583_probe(struct i2c_adapter *adap, int addr, int kind);
+
+static int pcf8583_attach(struct i2c_adapter *adap)
+{
+	return i2c_probe(adap, &addr_data, pcf8583_probe);
+}
+
+static int pcf8583_detach(struct i2c_client *client)
+{
+	int err;
+	struct pcf8583 *pcf = i2c_get_clientdata(client);
+	struct rtc_device *rtc = pcf->rtc;
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	if ((err = i2c_detach_client(client)))
+		return err;
+
+	kfree(pcf);
+	return 0;
+}
+
+static struct i2c_driver pcf8583_driver = {
+	.driver = {
+		.name	= "pcf8583",
+	},
+	.attach_adapter	= pcf8583_attach,
+	.detach_client	= pcf8583_detach,
+};
+
+static int pcf8583_probe(struct i2c_adapter *adap, int addr, int kind)
 {
-	struct pcf8583 *pcf8583;
+	struct pcf8583 *pcf;
+	struct i2c_client *client;
+	struct rtc_device *rtc;
+	unsigned char buf[1], ad[1] = { 0 };
 	int err;
+	struct i2c_msg msgs[2] = {
+		{
+			.addr = addr,
+			.flags = 0,
+			.len = 1,
+			.buf = ad,
+		}, {
+			.addr = addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = buf,
+		}
+	};
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		return -ENODEV;
+	if (!i2c_check_functionality(adap, I2C_FUNC_I2C))
+		return 0;
 
-	pcf8583 = kzalloc(sizeof(struct pcf8583), GFP_KERNEL);
-	if (!pcf8583)
+	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
+	if (!pcf)
 		return -ENOMEM;
 
-	pcf8583->rtc = rtc_device_register(pcf8583_driver.driver.name,
-			&client->dev, &pcf8583_rtc_ops, THIS_MODULE);
+	client = &pcf->client;
 
-	if (IS_ERR(pcf8583->rtc)) {
-		err = PTR_ERR(pcf8583->rtc);
+	client->addr		= addr;
+	client->adapter	= adap;
+	client->driver	= &pcf8583_driver;
+
+	strlcpy(client->name, pcf8583_driver.driver.name, I2C_NAME_SIZE);
+
+	if (i2c_transfer(client->adapter, msgs, 2) != 2) {
+		err = -EIO;
 		goto exit_kfree;
 	}
 
-	i2c_set_clientdata(client, pcf8583);
-	return 0;
+	err = i2c_attach_client(client);
 
-exit_kfree:
-	kfree(pcf8583);
-	return err;
-}
+	if (err)
+		goto exit_kfree;
 
-static int __devexit pcf8583_remove(struct i2c_client *client)
-{
-	struct pcf8583 *pcf8583 = i2c_get_clientdata(client);
+	rtc = rtc_device_register(pcf8583_driver.driver.name, &client->dev,
+				  &pcf8583_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(rtc)) {
+		err = PTR_ERR(rtc);
+		goto exit_detach;
+	}
+
+	pcf->rtc = rtc;
+	i2c_set_clientdata(client, pcf);
+	set_ctrl(client, buf[0]);
 
-	if (pcf8583->rtc)
-		rtc_device_unregister(pcf8583->rtc);
-	kfree(pcf8583);
 	return 0;
-}
 
-static const struct i2c_device_id pcf8583_id[] = {
-	{ "pcf8583", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, pcf8583_id);
+exit_detach:
+	i2c_detach_client(client);
 
-static struct i2c_driver pcf8583_driver = {
-	.driver = {
-		.name	= "pcf8583",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= pcf8583_probe,
-	.remove		= __devexit_p(pcf8583_remove),
-	.id_table	= pcf8583_id,
-};
+exit_kfree:
+	kfree(pcf);
+
+	return err;
+}
 
 static __init int pcf8583_init(void)
 {
