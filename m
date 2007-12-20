Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXLTEmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXLTEmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbXLTElz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:41:55 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:49045 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbXLTElx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:41:53 -0500
Date: Wed, 19 Dec 2007 23:41:40 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 2/5] Modify several rtc drivers to use the alias names list
	property of i2c
In-reply-to: <20071220044136.20091.70984.stgit@terra.home>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071220044140.20091.31851.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071220044136.20091.70984.stgit@terra.home>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the ds1307, ds1374, and rs5c372 i2c drivers to support
device tree names using the new i2c mod alias support

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 arch/powerpc/sysdev/fsl_soc.c |   44 ++++----------------------------
 drivers/rtc/rtc-ds1307.c      |   20 +++++++++++++-
 drivers/rtc/rtc-ds1374.c      |    9 ++++++
 drivers/rtc/rtc-m41t80.c      |   57 ++++++++++++++++++++++++++++-------------
 drivers/rtc/rtc-rs5c372.c     |   16 ++++++++++--
 5 files changed, 85 insertions(+), 61 deletions(-)


diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 3ace747..268638a 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -320,48 +320,12 @@ arch_initcall(gfar_of_init);
 
 #ifdef CONFIG_I2C_BOARDINFO
 #include <linux/i2c.h>
-struct i2c_driver_device {
-	char	*of_device;
-	char	*i2c_driver;
-	char	*i2c_type;
-};
-
-static struct i2c_driver_device i2c_devices[] __initdata = {
-	{"ricoh,rs5c372a", "rtc-rs5c372", "rs5c372a",},
-	{"ricoh,rs5c372b", "rtc-rs5c372", "rs5c372b",},
-	{"ricoh,rv5c386",  "rtc-rs5c372", "rv5c386",},
-	{"ricoh,rv5c387a", "rtc-rs5c372", "rv5c387a",},
-	{"dallas,ds1307",  "rtc-ds1307",  "ds1307",},
-	{"dallas,ds1337",  "rtc-ds1307",  "ds1337",},
-	{"dallas,ds1338",  "rtc-ds1307",  "ds1338",},
-	{"dallas,ds1339",  "rtc-ds1307",  "ds1339",},
-	{"dallas,ds1340",  "rtc-ds1307",  "ds1340",},
-	{"stm,m41t00",     "rtc-ds1307",  "m41t00"},
-	{"dallas,ds1374",  "rtc-ds1374",  "rtc-ds1374",},
-};
-
-static int __init of_find_i2c_driver(struct device_node *node,
-				     struct i2c_board_info *info)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(i2c_devices); i++) {
-		if (!of_device_is_compatible(node, i2c_devices[i].of_device))
-			continue;
-		if (strlcpy(info->driver_name, i2c_devices[i].i2c_driver,
-			    KOBJ_NAME_LEN) >= KOBJ_NAME_LEN ||
-		    strlcpy(info->type, i2c_devices[i].i2c_type,
-			    I2C_NAME_SIZE) >= I2C_NAME_SIZE)
-			return -ENOMEM;
-		return 0;
-	}
-	return -ENODEV;
-}
 
 static void __init of_register_i2c_devices(struct device_node *adap_node,
 					   int bus_num)
 {
 	struct device_node *node = NULL;
+	const char *compatible;
 
 	while ((node = of_get_next_child(adap_node, node))) {
 		struct i2c_board_info info = {};
@@ -378,8 +342,12 @@ static void __init of_register_i2c_devices(struct device_node *adap_node,
 		if (info.irq == NO_IRQ)
 			info.irq = -1;
 
-		if (of_find_i2c_driver(node, &info) < 0)
+		compatible = of_get_property(node, "compatible", &len);
+		if (!compatible) {
+			printk(KERN_WARNING "i2c-mpc.c: invalid entry, missing compatible attribute\n");
 			continue;
+		}
+		strncpy(info.driver_name, compatible, sizeof(info.driver_name));
 
 		info.addr = *addr;
 
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index bc1c7fe..d4874ff 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -139,6 +139,17 @@ static inline const struct chip_desc *find_chip(const char *s)
 	return NULL;
 }
 
+static struct i2c_device_id ds1307_id[] = {
+	OF_I2C_ID("dallas,ds1307", ds_1307)
+	OF_I2C_ID("dallas,ds1337", ds_1337)
+	OF_I2C_ID("dallas,ds1338", ds_1338)
+	OF_I2C_ID("dallas,ds1339", ds_1339)
+	OF_I2C_ID("dallas,ds1340", ds_1340)
+	OF_I2C_ID("stm,m41t00", m41t00)
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, ds1307_id);
+
 static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 {
 	struct ds1307	*ds1307 = dev_get_drvdata(dev);
@@ -326,7 +337,7 @@ static struct bin_attribute nvram = {
 
 static struct i2c_driver ds1307_driver;
 
-static int __devinit ds1307_probe(struct i2c_client *client)
+static int __devinit ds1307_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
@@ -334,7 +345,11 @@ static int __devinit ds1307_probe(struct i2c_client *client)
 	const struct chip_desc	*chip;
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 
-	chip = find_chip(client->name);
+	if (id)
+		chip = &chips[id->driver_data];
+	else
+		chip = find_chip(client->name);
+
 	if (!chip) {
 		dev_err(&client->dev, "unknown chip type '%s'\n",
 				client->name);
@@ -537,6 +552,7 @@ static struct i2c_driver ds1307_driver = {
 	},
 	.probe		= ds1307_probe,
 	.remove		= __devexit_p(ds1307_remove),
+	.id_table	= ds1307_id,
 };
 
 static int __init ds1307_init(void)
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 45bda18..6dc05c4 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -41,6 +41,12 @@
 #define DS1374_REG_SR_AF	0x01 /* Alarm Flag */
 #define DS1374_REG_TCR		0x09 /* Trickle Charge */
 
+static struct i2c_device_id ds1374_id[] = {
+	OF_I2C_ID("dallas,ds1374", 0)
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, ds1374_id);
+
 struct ds1374 {
 	struct i2c_client *client;
 	struct rtc_device *rtc;
@@ -355,7 +361,7 @@ static const struct rtc_class_ops ds1374_rtc_ops = {
 	.ioctl = ds1374_ioctl,
 };
 
-static int ds1374_probe(struct i2c_client *client)
+static int ds1374_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct ds1374 *ds1374;
 	int ret;
@@ -429,6 +435,7 @@ static struct i2c_driver ds1374_driver = {
 	},
 	.probe = ds1374_probe,
 	.remove = __devexit_p(ds1374_remove),
+	.id_table = ds1374_id,
 };
 
 static int __init ds1374_init(void)
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 1cb33ca..fc33f77 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -100,8 +100,21 @@ static const struct m41t80_chip_info m41t80_chip_info_tbl[] = {
 	},
 };
 
+static struct i2c_device_id m41t80_id[] = {
+	OF_I2C_ID("stm,m41t80", 0)
+	OF_I2C_ID("stm,m41t81", M41T80_FEATURE_HT)
+	OF_I2C_ID("stm,m41t81s", M41T80_FEATURE_HT | M41T80_FEATURE_BL)
+	OF_I2C_ID("stm,m41t82", M41T80_FEATURE_HT | M41T80_FEATURE_BL)
+	OF_I2C_ID("stm,m41t83", M41T80_FEATURE_HT | M41T80_FEATURE_BL)
+	OF_I2C_ID("stm,m41t84", M41T80_FEATURE_HT | M41T80_FEATURE_BL)
+	OF_I2C_ID("stm,m41t85", M41T80_FEATURE_HT | M41T80_FEATURE_BL)
+	OF_I2C_ID("stm,m41t87", M41T80_FEATURE_HT | M41T80_FEATURE_BL)
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, m41t80_id);
+
 struct m41t80_data {
-	const struct m41t80_chip_info *chip;
+	u8 features;
 	struct rtc_device *rtc;
 };
 
@@ -208,7 +221,7 @@ static int m41t80_rtc_proc(struct device *dev, struct seq_file *seq)
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
 	u8 reg;
 
-	if (clientdata->chip->features & M41T80_FEATURE_BL) {
+	if (clientdata->features & M41T80_FEATURE_BL) {
 		reg = i2c_smbus_read_byte_data(client, M41T80_REG_FLAGS);
 		seq_printf(seq, "battery\t\t: %s\n",
 			   (reg & M41T80_FLAGS_BATT_LOW) ? "exhausted" : "ok");
@@ -756,12 +769,12 @@ static struct notifier_block wdt_notifier = {
  *
  *****************************************************************************
  */
-static int m41t80_probe(struct i2c_client *client)
+static int m41t80_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int i, rc = 0;
 	struct rtc_device *rtc = NULL;
 	struct rtc_time tm;
-	const struct m41t80_chip_info *chip;
+	u8 features;
 	struct m41t80_data *clientdata = NULL;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
@@ -773,17 +786,24 @@ static int m41t80_probe(struct i2c_client *client)
 	dev_info(&client->dev,
 		 "chip found, driver version " DRV_VERSION "\n");
 
-	chip = NULL;
-	for (i = 0; i < ARRAY_SIZE(m41t80_chip_info_tbl); i++) {
-		if (!strcmp(m41t80_chip_info_tbl[i].name, client->name)) {
-			chip = &m41t80_chip_info_tbl[i];
-			break;
+	if (id)
+		features = id->driver_data;
+	else {
+		const struct m41t80_chip_info *chip;
+
+		chip = NULL;
+		for (i = 0; i < ARRAY_SIZE(m41t80_chip_info_tbl); i++) {
+			if (!strcmp(m41t80_chip_info_tbl[i].name, client->name)) {
+				chip = &m41t80_chip_info_tbl[i];
+				break;
+			}
 		}
-	}
-	if (!chip) {
-		dev_err(&client->dev, "%s is not supported\n", client->name);
-		rc = -ENODEV;
-		goto exit;
+		if (!chip) {
+			dev_err(&client->dev, "%s is not supported\n", client->name);
+			rc = -ENODEV;
+			goto exit;
+		}
+		features = chip->features;
 	}
 
 	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
@@ -801,7 +821,7 @@ static int m41t80_probe(struct i2c_client *client)
 	}
 
 	clientdata->rtc = rtc;
-	clientdata->chip = chip;
+	clientdata->features = features;
 	i2c_set_clientdata(client, clientdata);
 
 	/* Make sure HT (Halt Update) bit is cleared */
@@ -810,7 +830,7 @@ static int m41t80_probe(struct i2c_client *client)
 		goto ht_err;
 
 	if (rc & M41T80_ALHOUR_HT) {
-		if (chip->features & M41T80_FEATURE_HT) {
+		if (features & M41T80_FEATURE_HT) {
 			m41t80_get_datetime(client, &tm);
 			dev_info(&client->dev, "HT bit was set!\n");
 			dev_info(&client->dev,
@@ -842,7 +862,7 @@ static int m41t80_probe(struct i2c_client *client)
 		goto exit;
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
-	if (chip->features & M41T80_FEATURE_HT) {
+	if (features & M41T80_FEATURE_HT) {
 		rc = misc_register(&wdt_dev);
 		if (rc)
 			goto exit;
@@ -878,7 +898,7 @@ static int m41t80_remove(struct i2c_client *client)
 	struct rtc_device *rtc = clientdata->rtc;
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
-	if (clientdata->chip->features & M41T80_FEATURE_HT) {
+	if (clientdata->features & M41T80_FEATURE_HT) {
 		misc_deregister(&wdt_dev);
 		unregister_reboot_notifier(&wdt_notifier);
 	}
@@ -896,6 +916,7 @@ static struct i2c_driver m41t80_driver = {
 	},
 	.probe = m41t80_probe,
 	.remove = m41t80_remove,
+	.id_table = m41t80_id,
 };
 
 static int __init m41t80_rtc_init(void)
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 6b67b50..e2022c0 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -69,6 +69,15 @@ enum rtc_type {
 	rtc_rv5c387a,
 };
 
+static struct i2c_device_id rs5c372_id[] = {
+	OF_I2C_ID("ricoh,rs5c372a", rtc_rs5c372a)
+	OF_I2C_ID("ricoh,rs5c372b", rtc_rs5c372b)
+	OF_I2C_ID("ricoh,rv5c386", rtc_rv5c386)
+	OF_I2C_ID("ricoh,rv5c387a", rtc_rv5c387a)
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, rs5c372_id);
+
 /* REVISIT:  this assumes that:
  *  - we're in the 21st century, so it's safe to ignore the century
  *    bit for rv5c38[67] (REG_MONTH bit 7);
@@ -494,7 +503,7 @@ static void rs5c_sysfs_unregister(struct device *dev)
 
 static struct i2c_driver rs5c372_driver;
 
-static int rs5c372_probe(struct i2c_client *client)
+static int rs5c372_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int err = 0;
 	struct rs5c372 *rs5c372;
@@ -522,7 +531,9 @@ static int rs5c372_probe(struct i2c_client *client)
 	if (err < 0)
 		goto exit_kfree;
 
-	if (strcmp(client->name, "rs5c372a") == 0)
+	if (id)
+		rs5c372->type = id->driver_data;
+	else if (strcmp(client->name, "rs5c372a") == 0)
 		rs5c372->type = rtc_rs5c372a;
 	else if (strcmp(client->name, "rs5c372b") == 0)
 		rs5c372->type = rtc_rs5c372b;
@@ -651,6 +662,7 @@ static struct i2c_driver rs5c372_driver = {
 	},
 	.probe		= rs5c372_probe,
 	.remove		= rs5c372_remove,
+	.id_table	= rs5c372_id,
 };
 
 static __init int rs5c372_init(void)

