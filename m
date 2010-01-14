Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405Ab0ANLcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0ANLcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956Ab0ANLcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:32:41 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43007 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0ANLcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:32:41 -0500
Date: Thu, 14 Jan 2010 20:32:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Dale Farnsworth <dale@farnsworth.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: rtc-max6900: SMBus support.
Message-ID: <20100114113235.GA20473@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current rtc-max6900 driver only supports getting and setting the time
through bursting, which requires a controller capable of such. As
bursting is merely an optimization, we can also opt for the non-burst
fallback path that pokes at the date/time registers individually.

By opting for the fallback solution, it's possible to fully support the
RTC on controllers that only implement I2C_FUNC_SMBUS_BYTE_DATA instead
of requiring master transfers via I2C_FUNC_I2C.

This was tested with an I2C_FUNC_SMBUS_BYTE_DATA controller with a MAX6909
attached. Currently only a subset of the MAX6909 functionality is supported,
patches to extend the current driver to be forthcoming.

There are no functional changes for I2C_FUNC_I2C controllers.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/rtc/Kconfig       |    4 +-
 drivers/rtc/rtc-max6900.c |   83 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 8167e9e..1f74b46 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -167,10 +167,10 @@ config RTC_DRV_DS1672
 	  will be called rtc-ds1672.
 
 config RTC_DRV_MAX6900
-	tristate "Maxim MAX6900"
+	tristate "Maxim MAX6900/MAX6909"
 	help
 	  If you say yes here you will get support for the
-	  Maxim MAX6900 I2C RTC chip.
+	  Maxim MAX6900 and MAX6909 I2C RTC chips.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max6900.
diff --git a/drivers/rtc/rtc-max6900.c b/drivers/rtc/rtc-max6900.c
index a4f6665..5e0c289 100644
--- a/drivers/rtc/rtc-max6900.c
+++ b/drivers/rtc/rtc-max6900.c
@@ -1,8 +1,10 @@
 /*
- * rtc class driver for the Maxim MAX6900 chip
+ * rtc class driver for the Maxim MAX6900/MAX6909 chip
  *
  * Author: Dale Farnsworth <dale@farnsworth.org>
  *
+ * SMBus support by Paul Mundt.
+ *
  * based on previously existing rtc class drivers
  *
  * 2007 (c) MontaVista, Software, Inc.  This file is licensed under
@@ -17,7 +19,7 @@
 #include <linux/rtc.h>
 #include <linux/delay.h>
 
-#define DRV_VERSION "0.2"
+#define DRV_VERSION "0.3"
 
 /*
  * register indices
@@ -39,6 +41,12 @@
 #define MAX6900_REG_CT_WP		(1 << 7)	/* Write Protect */
 
 /*
+ * index to command wrappers
+ */
+#define MAX6900_REG_WRITE(reg)		(0x80 + ((reg) * sizeof(u16)))
+#define MAX6900_REG_READ(reg)		(0x81 + ((reg) * sizeof(u16)))
+
+/*
  * register read/write commands
  */
 #define MAX6900_REG_CONTROL_WRITE	0x8e
@@ -52,7 +60,9 @@
 
 static struct i2c_driver max6900_driver;
 
-static int max6900_i2c_read_regs(struct i2c_client *client, u8 *buf)
+static unsigned int smbus_mode;	/* disabled by default, prefer bursting */
+
+static int max6900_i2c_burst_read(struct i2c_client *client, u8 *buf)
 {
 	u8 reg_burst_read[1] = { MAX6900_REG_BURST_READ };
 	u8 reg_century_read[1] = { MAX6900_REG_CENTURY_READ };
@@ -92,7 +102,7 @@ static int max6900_i2c_read_regs(struct i2c_client *client, u8 *buf)
 	return 0;
 }
 
-static int max6900_i2c_write_regs(struct i2c_client *client, u8 const *buf)
+static int max6900_i2c_burst_write(struct i2c_client *client, u8 const *buf)
 {
 	u8 i2c_century_buf[1 + 1] = { MAX6900_REG_CENTURY_WRITE };
 	struct i2c_msg century_msgs[1] = {
@@ -141,6 +151,58 @@ static int max6900_i2c_write_regs(struct i2c_client *client, u8 const *buf)
 	return -EIO;
 }
 
+static int max6900_i2c_smbus_read(struct i2c_client *client, u8 *buf)
+{
+	int rc = 0, i;
+
+	for (i = 0; i < MAX6900_REG_LEN; i++) {
+		rc = i2c_smbus_read_byte_data(client, MAX6900_REG_READ(i));
+		if (rc < 0) {
+			dev_err(&client->dev, "%s: register read failed\n",
+				__func__);
+			return rc;
+		}
+		buf[i] = rc;
+	}
+
+	return 0;
+}
+
+static int max6900_i2c_smbus_write(struct i2c_client *client, u8 const *buf)
+{
+	int rc = 0, i;
+
+	for (i = 0; i < MAX6900_REG_LEN; i++)
+		rc |= i2c_smbus_write_byte_data(client,
+				MAX6900_REG_WRITE(i), buf[i]);
+
+	if (rc < 0) {
+		dev_err(&client->dev, "%s: register write failed\n",
+			__func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static inline int
+max6900_i2c_read_regs(struct i2c_client *client, u8 *buf)
+{
+	if (smbus_mode)
+		return max6900_i2c_smbus_read(client, buf);
+
+	return max6900_i2c_burst_read(client, buf);
+}
+
+static inline int
+max6900_i2c_write_regs(struct i2c_client *client, u8 const *buf)
+{
+	if (smbus_mode)
+		return max6900_i2c_smbus_write(client, buf);
+
+	return max6900_i2c_burst_write(client, buf);
+}
+
 static int max6900_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
 {
 	int rc;
@@ -232,8 +294,17 @@ max6900_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct rtc_device *rtc;
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		return -ENODEV;
+	/*
+	 * Prefer burst mode if there's a fully functional I2C adapter to
+	 * work with, otherwise scrape by with SMBus.
+	 */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		if (i2c_check_functionality(client->adapter,
+				    I2C_FUNC_SMBUS_BYTE_DATA))
+			smbus_mode = 1;
+		else
+			return -ENODEV;
+	}
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
