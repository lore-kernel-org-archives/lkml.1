Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYBJRak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYBJRak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYBJRaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:30:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:13681 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYBJRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:30:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=KClf/6aOISnA9kWZP+u0f09Xte1UnByNZ/wwYi0VP6mtvzaVsy8zsQk2jW0AnB0MD8yckg7N3RxAt7wHAsgoyuRIqe5RcES5Xrr92MHsKf6QKnEoe+kgZHJOu+BIqwdHzIgPnbRMVqdFz2EHFe3w0gPINRMl1rOqFWVf6Wb++bM=
Date: Sun, 10 Feb 2008 17:29:51 +0000 (GMT)
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       khali@linux-fr.org, david-b@pacbell.net, tim@ngndg.com
Subject: [PATCH] rtc: add support for the S-35390A RTC chip
Message-ID: <alpine.DEB.1.00.0802101714260.7986@git.byronbradley.co.uk>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Byron Bradley <byron.bbradley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch has been sent to the i2c, rtc and lkml mailing lists
and it looks like there are no more comments but nobody has picked this up
to merge with mainline. It was in and out of -mm a few times because of
problems with the i2c_new_dummy() function that it depends on but it
seems to have gotten stuck out of -mm. The I2C fixes are already in
mainline so I see no reason why this can't be merged.

Linus, since I expect the merge window will be closing soon I'm sending
this to you has a final attempt to get it in for 2.6.25.

From: Byron Bradley <byron.bbradley@gmail.com>
Subject: [PATCH] rtc: add support for the S-35390A RTC chip

This adds basic get/set time support for the Seiko Instruments S-35390A.
This chip communicates using I2C and is used on the QNAP TS-109/TS-209 NAS
devices.

Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: David Brownell <david-b@pacbell.net>
Tested-by: Tim Ellis <tim@ngndg.com>
---
 drivers/rtc/Kconfig       |    9 ++
 drivers/rtc/Makefile      |    1 +
 drivers/rtc/rtc-s35390a.c |  316 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 326 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-s35390a.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 6402d69..82f5ad9 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -250,6 +250,15 @@ config RTC_DRV_TWL92330
 	  platforms.  The support is integrated with the rest of
 	  the Menelaus driver; it's not separate module.

+config RTC_DRV_S35390A
+	tristate "Seiko Instruments S-35390A"
+	help
+	  If you say yes here you will get support for the Seiko
+	  Instruments S-35390A.
+
+	  This driver can also be built as a module. If so the module
+	  will be called rtc-s35390a.
+
 endif # I2C

 comment "SPI RTC drivers"
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index ec703f3..872f121 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
 obj-$(CONFIG_RTC_DRV_RS5C372)	+= rtc-rs5c372.o
+obj-$(CONFIG_RTC_DRV_S35390A)	+= rtc-s35390a.o
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
new file mode 100644
index 0000000..b517787
--- /dev/null
+++ b/drivers/rtc/rtc-s35390a.c
@@ -0,0 +1,316 @@
+/*
+ * Seiko Instruments S-35390A RTC Driver
+ *
+ * Copyright (c) 2007 Byron Bradley
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/i2c.h>
+#include <linux/bitrev.h>
+#include <linux/bcd.h>
+#include <linux/slab.h>
+
+#define S35390A_CMD_STATUS1	0
+#define S35390A_CMD_STATUS2	1
+#define S35390A_CMD_TIME1	2
+
+#define S35390A_BYTE_YEAR	0
+#define S35390A_BYTE_MONTH	1
+#define S35390A_BYTE_DAY	2
+#define S35390A_BYTE_WDAY	3
+#define S35390A_BYTE_HOURS	4
+#define S35390A_BYTE_MINS	5
+#define S35390A_BYTE_SECS	6
+
+#define S35390A_FLAG_POC	0x01
+#define S35390A_FLAG_BLD	0x02
+#define S35390A_FLAG_24H	0x40
+#define S35390A_FLAG_RESET	0x80
+#define S35390A_FLAG_TEST	0x01
+
+struct s35390a {
+	struct i2c_client *client[8];
+	struct rtc_device *rtc;
+	int twentyfourhour;
+};
+
+static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+{
+	struct i2c_client *client = s35390a->client[reg];
+	struct i2c_msg msg[] = {
+		{ client->addr, 0, len, buf },
+	};
+
+	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int s35390a_get_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+{
+	struct i2c_client *client = s35390a->client[reg];
+	struct i2c_msg msg[] = {
+		{ client->addr, I2C_M_RD, len, buf },
+	};
+
+	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int s35390a_reset(struct s35390a *s35390a)
+{
+	char buf[1];
+
+	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf)) < 0)
+		return -EIO;
+
+	if (!(buf[0] & (S35390A_FLAG_POC | S35390A_FLAG_BLD)))
+		return 0;
+
+	buf[0] |= (S35390A_FLAG_RESET | S35390A_FLAG_24H);
+	buf[0] &= 0xf0;
+	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf));
+}
+
+static int s35390a_disable_test_mode(struct s35390a *s35390a)
+{
+	char buf[1];
+
+	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf)) < 0)
+		return -EIO;
+
+	if (!(buf[0] & S35390A_FLAG_TEST))
+		return 0;
+
+	buf[0] &= ~S35390A_FLAG_TEST;
+	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf));
+}
+
+static char s35390a_hr2reg(struct s35390a *s35390a, int hour)
+{
+	if (s35390a->twentyfourhour)
+		return BIN2BCD(hour);
+
+	if (hour < 12)
+		return BIN2BCD(hour);
+
+	return 0x40 | BIN2BCD(hour - 12);
+}
+
+static int s35390a_reg2hr(struct s35390a *s35390a, char reg)
+{
+	unsigned hour;
+
+	if (s35390a->twentyfourhour)
+		return BCD2BIN(reg & 0x3f);
+
+	hour = BCD2BIN(reg & 0x3f);
+	if (reg & 0x40)
+		hour += 12;
+
+	return hour;
+}
+
+static int s35390a_set_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	struct s35390a	*s35390a = i2c_get_clientdata(client);
+	int i, err;
+	char buf[7];
+
+	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
+		"mon=%d, year=%d, wday=%d\n", __FUNCTION__, tm->tm_sec,
+		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,
+		tm->tm_wday);
+
+	buf[S35390A_BYTE_YEAR] = BIN2BCD(tm->tm_year - 100);
+	buf[S35390A_BYTE_MONTH] = BIN2BCD(tm->tm_mon + 1);
+	buf[S35390A_BYTE_DAY] = BIN2BCD(tm->tm_mday);
+	buf[S35390A_BYTE_WDAY] = BIN2BCD(tm->tm_wday);
+	buf[S35390A_BYTE_HOURS] = s35390a_hr2reg(s35390a, tm->tm_hour);
+	buf[S35390A_BYTE_MINS] = BIN2BCD(tm->tm_min);
+	buf[S35390A_BYTE_SECS] = BIN2BCD(tm->tm_sec);
+
+	/* This chip expects the bits of each byte to be in reverse order */
+	for (i = 0; i < 7; ++i)
+		buf[i] = bitrev8(buf[i]);
+
+	err = s35390a_set_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
+
+	return err;
+}
+
+static int s35390a_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	char buf[7];
+	int i, err;
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
+	if (err < 0)
+		return err;
+
+	/* This chip returns the bits of each byte in reverse order */
+	for (i = 0; i < 7; ++i)
+		buf[i] = bitrev8(buf[i]);
+
+	tm->tm_sec = BCD2BIN(buf[S35390A_BYTE_SECS]);
+	tm->tm_min = BCD2BIN(buf[S35390A_BYTE_MINS]);
+	tm->tm_hour = s35390a_reg2hr(s35390a, buf[S35390A_BYTE_HOURS]);
+	tm->tm_wday = BCD2BIN(buf[S35390A_BYTE_WDAY]);
+	tm->tm_mday = BCD2BIN(buf[S35390A_BYTE_DAY]);
+	tm->tm_mon = BCD2BIN(buf[S35390A_BYTE_MONTH]) - 1;
+	tm->tm_year = BCD2BIN(buf[S35390A_BYTE_YEAR]) + 100;
+
+	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, mday=%d, "
+		"mon=%d, year=%d, wday=%d\n", __FUNCTION__, tm->tm_sec,
+		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,
+		tm->tm_wday);
+
+	return rtc_valid_tm(tm);
+}
+
+static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return s35390a_get_datetime(to_i2c_client(dev), tm);
+}
+
+static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return s35390a_set_datetime(to_i2c_client(dev), tm);
+}
+
+static const struct rtc_class_ops s35390a_rtc_ops = {
+	.read_time	= s35390a_rtc_read_time,
+	.set_time	= s35390a_rtc_set_time,
+};
+
+static struct i2c_driver s35390a_driver;
+
+static int s35390a_probe(struct i2c_client *client)
+{
+	int err;
+	unsigned int i;
+	struct s35390a *s35390a;
+	struct rtc_time tm;
+	char buf[1];
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		err = -ENODEV;
+		goto exit;
+	}
+
+	s35390a = kzalloc(sizeof(struct s35390a), GFP_KERNEL);
+	if (!s35390a) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	s35390a->client[0] = client;
+	i2c_set_clientdata(client, s35390a);
+
+	/* This chip uses multiple addresses, use dummy devices for them */
+	for (i = 1; i < 8; ++i) {
+		s35390a->client[i] = i2c_new_dummy(client->adapter,
+					client->addr + i, "rtc-s35390a");
+		if (!s35390a->client[i]) {
+			dev_err(&client->dev, "Address %02x unavailable\n",
+						client->addr + i);
+			err = -EBUSY;
+			goto exit_dummy;
+		}
+	}
+
+	err = s35390a_reset(s35390a);
+	if (err < 0) {
+		dev_err(&client->dev, "error resetting chip\n");
+		goto exit_dummy;
+	}
+
+	err = s35390a_disable_test_mode(s35390a);
+	if (err < 0) {
+		dev_err(&client->dev, "error disabling test mode\n");
+		goto exit_dummy;
+	}
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf));
+	if (err < 0) {
+		dev_err(&client->dev, "error checking 12/24 hour mode\n");
+		goto exit_dummy;
+	}
+	if (buf[0] & S35390A_FLAG_24H)
+		s35390a->twentyfourhour = 1;
+	else
+		s35390a->twentyfourhour = 0;
+
+	if (s35390a_get_datetime(client, &tm) < 0)
+		dev_warn(&client->dev, "clock needs to be set\n");
+
+	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
+				&client->dev, &s35390a_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(s35390a->rtc)) {
+		err = PTR_ERR(s35390a->rtc);
+		goto exit_dummy;
+	}
+	return 0;
+
+exit_dummy:
+	for (i = 1; i < 8; ++i)
+		if (s35390a->client[i])
+			i2c_unregister_device(s35390a->client[i]);
+	kfree(s35390a);
+	i2c_set_clientdata(client, NULL);
+
+exit:
+	return err;
+}
+
+static int s35390a_remove(struct i2c_client *client)
+{
+	unsigned int i;
+
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	for (i = 1; i < 8; ++i)
+		if (s35390a->client[i])
+			i2c_unregister_device(s35390a->client[i]);
+
+	rtc_device_unregister(s35390a->rtc);
+	kfree(s35390a);
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static struct i2c_driver s35390a_driver = {
+	.driver		= {
+		.name	= "rtc-s35390a",
+	},
+	.probe		= s35390a_probe,
+	.remove		= s35390a_remove,
+};
+
+static int __init s35390a_rtc_init(void)
+{
+	return i2c_add_driver(&s35390a_driver);
+}
+
+static void __exit s35390a_rtc_exit(void)
+{
+	i2c_del_driver(&s35390a_driver);
+}
+
+MODULE_AUTHOR("Byron Bradley <byron.bbradley@gmail.com>");
+MODULE_DESCRIPTION("S35390A RTC driver");
+MODULE_LICENSE("GPL");
+
+module_init(s35390a_rtc_init);
+module_exit(s35390a_rtc_exit);
-- 
1.5.4.rc2.38.gd6da3

