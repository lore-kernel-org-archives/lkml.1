Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYJGNFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYJGNFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYJGNFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:05:42 -0400
Received: from smtp4-ft1.vinci-energies.com ([81.252.86.87]:46271 "EHLO
	vinci-energies.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbYJGNFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:05:41 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 09:05:40 EDT
From: BARRE Sebastien <sbarre@sdelcc.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Oct 2008 14:55:52 +0200
Subject: [PATCH 2.6.26.5] rtc-ds1307 : SMBus compatibility
Thread-Topic: [PATCH 2.6.26.5] rtc-ds1307 : SMBus compatibility
Thread-Index: AckofAd/CN5hf8ytT1qop1Sifi128A==
Message-ID: <C1C62166118DFA4A8BBA01A2411F0D170E9BE59C2F@PRI-MBX-101.dom1.vinci-energies.net>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change all i2c access functions to SMBus access functions in order to use the ds1307 on SMBus.
I expect that using SMBus access functions is correct for all boards with i2C or SMBus adapter. Is it correct ?

I have tested it on my Geode LX board with a ds1307 device.

Please CC me your comments.
Thanks.

--- a/drivers/rtc/rtc-ds1307.c  2008-09-08 17:40:20.000000000 +0000
+++ b/drivers/rtc/rtc-ds1307.c  2008-10-07 13:21:57.000000000 +0000
@@ -92,7 +92,6 @@ struct ds1307 {
        bool                    has_nvram;
        u8                      regs[8];
        enum ds_type            type;
-       struct i2c_msg          msg[2];
        struct i2c_client       *client;
        struct i2c_client       dev;
        struct rtc_device       *rtc;
@@ -138,12 +137,10 @@ static int ds1307_get_time(struct device
        int             tmp;

        /* read the RTC date and time registers all at once */
-       ds1307->msg[1].flags = I2C_M_RD;
-       ds1307->msg[1].len = 7;
-
-       tmp = i2c_transfer(to_i2c_adapter(ds1307->client->dev.parent),
-                       ds1307->msg, 2);
-       if (tmp != 2) {
+       u8      *buf = ds1307->regs;
+       tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+                       DS1307_REG_SECS, 7, buf);
+       if (tmp != 7) {
                dev_err(dev, "%s error %d\n", "read", tmp);
                return -EIO;
        }
@@ -180,7 +177,6 @@ static int ds1307_get_time(struct device
 static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 {
        struct ds1307   *ds1307 = dev_get_drvdata(dev);
-       int             result;
        int             tmp;
        u8              *buf = ds1307->regs;

@@ -190,7 +186,6 @@ static int ds1307_set_time(struct device
                t->tm_hour, t->tm_mday,
                t->tm_mon, t->tm_year, t->tm_wday);

-       *buf++ = 0;             /* first register addr */
        buf[DS1307_REG_SECS] = BIN2BCD(t->tm_sec);
        buf[DS1307_REG_MIN] = BIN2BCD(t->tm_min);
        buf[DS1307_REG_HOUR] = BIN2BCD(t->tm_hour);
@@ -215,16 +210,12 @@ static int ds1307_set_time(struct device
                break;
        }

-       ds1307->msg[1].flags = 0;
-       ds1307->msg[1].len = 8;
-
        dev_dbg(dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
                "write", buf[0], buf[1], buf[2], buf[3],
                buf[4], buf[5], buf[6]);

-       result = i2c_transfer(to_i2c_adapter(ds1307->client->dev.parent),
-                       &ds1307->msg[1], 1);
-       if (result != 1) {
+       tmp = i2c_smbus_write_i2c_block_data(ds1307->client, 0, 7, buf);
+       if (tmp < 0) {
                dev_err(dev, "%s error %d\n", "write", tmp);
                return -EIO;
        }
@@ -246,8 +237,7 @@ ds1307_nvram_read(struct kobject *kobj,
 {
        struct i2c_client       *client;
        struct ds1307           *ds1307;
-       struct i2c_msg          msg[2];
-       int                     result;
+       int     tmp;

        client = kobj_to_i2c_client(kobj);
        ds1307 = i2c_get_clientdata(client);
@@ -259,24 +249,13 @@ ds1307_nvram_read(struct kobject *kobj,
        if (unlikely(!count))
                return count;

-       msg[0].addr = client->addr;
-       msg[0].flags = 0;
-       msg[0].len = 1;
-       msg[0].buf = buf;
-
-       buf[0] = 8 + off;
-
-       msg[1].addr = client->addr;
-       msg[1].flags = I2C_M_RD;
-       msg[1].len = count;
-       msg[1].buf = buf;
-
-       result = i2c_transfer(to_i2c_adapter(client->dev.parent), msg, 2);
-       if (result != 2) {
-               dev_err(&client->dev, "%s error %d\n", "nvram read", result);
+       tmp = i2c_smbus_read_i2c_block_data(client, 8 + off, count, buf);
+       if (tmp < 0) {
+               dev_err(&client->dev, "%s error %d\n", "read", tmp);
                return -EIO;
        }
-       return count;
+
+       return tmp;
 }

 static ssize_t
@@ -284,8 +263,8 @@ ds1307_nvram_write(struct kobject *kobj,
                char *buf, loff_t off, size_t count)
 {
        struct i2c_client       *client;
-       u8                      buffer[NVRAM_SIZE + 1];
-       int                     ret;
+       u8                      buffer[NVRAM_SIZE];
+       int                     tmp;

        client = kobj_to_i2c_client(kobj);

@@ -296,11 +275,14 @@ ds1307_nvram_write(struct kobject *kobj,
        if (unlikely(!count))
                return count;

-       buffer[0] = 8 + off;
-       memcpy(buffer + 1, buf, count);
+       memcpy(buffer, buf, count);

-       ret = i2c_master_send(client, buffer, count + 1);
-       return (ret < 0) ? ret : (ret - 1);
+       tmp = i2c_smbus_write_i2c_block_data(client, 8 + off, count, buffer);
+       if (tmp < 0) {
+               dev_err(&client->dev, "%s error %d\n", "write", tmp);
+               return -EIO;
+       }
+       return count;
 }

 static struct bin_attribute nvram = {
@@ -325,11 +307,15 @@ static int __devinit ds1307_probe(struct
        struct ds1307           *ds1307;
        int                     err = -ENODEV;
        int                     tmp;
+       u8                      *buf;
+
        const struct chip_desc  *chip = &chips[id->driver_data];
        struct i2c_adapter      *adapter = to_i2c_adapter(client->dev.parent);

        if (!i2c_check_functionality(adapter,
-                       I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
+                       I2C_FUNC_SMBUS_WRITE_BYTE_DATA
+                       | I2C_FUNC_SMBUS_WRITE_I2C_BLOCK
+                       | I2C_FUNC_SMBUS_READ_I2C_BLOCK))
                return -EIO;

        if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
@@ -338,35 +324,21 @@ static int __devinit ds1307_probe(struct
        ds1307->client = client;
        i2c_set_clientdata(client, ds1307);

-       ds1307->msg[0].addr = client->addr;
-       ds1307->msg[0].flags = 0;
-       ds1307->msg[0].len = 1;
-       ds1307->msg[0].buf = &ds1307->reg_addr;
-
-       ds1307->msg[1].addr = client->addr;
-       ds1307->msg[1].flags = I2C_M_RD;
-       ds1307->msg[1].len = sizeof(ds1307->regs);
-       ds1307->msg[1].buf = ds1307->regs;
-
        ds1307->type = id->driver_data;

        switch (ds1307->type) {
        case ds_1337:
        case ds_1339:
-               ds1307->reg_addr = DS1337_REG_CONTROL;
-               ds1307->msg[1].len = 2;
-
+               buf = &ds1307->regs[DS1337_REG_CONTROL];
                /* get registers that the "rtc" read below won't read... */
-               tmp = i2c_transfer(adapter, ds1307->msg, 2);
+               tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+                               DS1337_REG_CONTROL, 2, buf);
                if (tmp != 2) {
                        pr_debug("read error %d\n", tmp);
                        err = -EIO;
                        goto exit_free;
                }

-               ds1307->reg_addr = 0;
-               ds1307->msg[1].len = sizeof(ds1307->regs);
-
                /* oscillator off?  turn it on, so clock can tick. */
                if (ds1307->regs[0] & DS1337_BIT_nEOSC)
                        i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL,
@@ -385,9 +357,9 @@ static int __devinit ds1307_probe(struct

 read_rtc:
        /* read RTC registers */
-
-       tmp = i2c_transfer(adapter, ds1307->msg, 2);
-       if (tmp != 2) {
+       buf = ds1307->regs;
+       tmp = i2c_smbus_read_i2c_block_data(ds1307->client, 0, 8, buf);
+       if (tmp != 8) {
                pr_debug("read error %d\n", tmp);
                err = -EIO;
                goto exit_free;

--
Sébastien Barré
Bureau d'étude - Développement
SDEL Contrôle Commande
D2A - Rue Nungesser et Coli
44860 Saint Aignan de Grand Lieu
FRANCE
Tél : +33(0)2 40 84 50 88
Fax : +33(0)2 40 84 51 10
