Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZLMDi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZLMDi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 22:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbZLMDi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 22:38:56 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:55658 "HELO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757862AbZLMDiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 22:38:55 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B23DA53.9090008@cam.ac.uk>
Date: Sat, 12 Dec 2009 18:00:51 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>,
       Daniel Mack <daniel@caiaq.de>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: [PATCH] isl29003: Move from misc to als now it available with minimal
 changes
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

 I originally offered to move this to IIO, but ALS is more appropriate.
 There are a couple of attibutes in here that don't correspond directly
 to any currently in ALS. Feel free to offer suggestions for renames etc
 on these, but I'd prefer to see them in a second patch allowing us to
 keep things in this movement patch nice and clean. Will do api help
 once these are pinned down.

 I've used the git move detection here so as to highlight what has actually
 changed in the driver.  Just ask if you would prefer a version without
 that.

 Daniel: Don't suppose you could test this?  I don't think I have done
 anything that should cause any problems and it builds fine, but always
 nice to confirm!

 Other than the tsl2563 driver currently in IIO (Greg K-H has sent pull
 request) I think this is the final non ALS ambient light sensor in
 mainline (assuming other patches have gone in first)

 For purposes of testing I've put a kit tree up on kernel.org.
 I will rebase this as makes sense to make minor edits to this and the tsl2550
 driver so please don't base off it or send on without either telling me
 or warning whoever you send it to.

 git://git.kernel.org/pub/scm/linux/kernel/git/jic23/als-temp.git



 drivers/als/Kconfig              |   10 ++++++++
 drivers/als/Makefile             |    1 +
 drivers/{misc => als}/isl29003.c |   45 +++++++++++++++++++++++++------------
 drivers/misc/Kconfig             |   10 --------
 drivers/misc/Makefile            |    1 -
 5 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/als/Kconfig b/drivers/als/Kconfig
index 1564ffc..9d99ac2 100644
--- a/drivers/als/Kconfig
+++ b/drivers/als/Kconfig
@@ -11,6 +11,16 @@ menuconfig ALS
 
 if ALS
 
+config ALS_ISL29003
+	tristate "Intersil ISL29003 ambient light sensor"
+	depends on I2C && SYSFS
+	help
+	  If you say yes here you get support for the Intersil ISL29003
+	  ambient light sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called isl29003.
+
 config ALS_TSL2550
 	tristate "Taos TSL2550 ambient light sensor"
 	depends on EXPERIMENTAL && I2C
diff --git a/drivers/als/Makefile b/drivers/als/Makefile
index 7be5631..55aa8af 100644
--- a/drivers/als/Makefile
+++ b/drivers/als/Makefile
@@ -4,4 +4,5 @@
 
 obj-$(CONFIG_ALS)		+= als_sys.o
 
+obj-$(CONFIG_ALS_ISL29003)	+= isl29003.o
 obj-$(CONFIG_ALS_TSL2550)	+= tsl2550.o
\ No newline at end of file
diff --git a/drivers/misc/isl29003.c b/drivers/als/isl29003.c
similarity index 90%
rename from drivers/misc/isl29003.c
rename to drivers/als/isl29003.c
index a71e245..2ab188e 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/als/isl29003.c
@@ -31,9 +31,10 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
+#include <linux/als_sys.h>
 
 #define ISL29003_DRV_NAME	"isl29003"
-#define DRIVER_VERSION		"1.0"
+#define DRIVER_VERSION		"2.0"
 
 #define ISL29003_REG_COMMAND		0x00
 #define ISL29003_ADC_ENABLED		(1 << 7)
@@ -61,6 +62,7 @@
 #define ISL29003_NUM_CACHABLE_REGS	4
 
 struct isl29003_data {
+	struct device *classdev;
 	struct i2c_client *client;
 	struct mutex lock;
 	u8 reg_cache[ISL29003_NUM_CACHABLE_REGS];
@@ -196,7 +198,7 @@ static int isl29003_get_adc_value(struct i2c_client *client)
 static ssize_t isl29003_show_range(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	return sprintf(buf, "%i\n", isl29003_get_range(client));
 }
 
@@ -204,7 +206,7 @@ static ssize_t isl29003_store_range(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	unsigned long val;
 	int ret;
 
@@ -227,7 +229,7 @@ static ssize_t isl29003_show_resolution(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	return sprintf(buf, "%d\n", isl29003_get_resolution(client));
 }
 
@@ -235,7 +237,7 @@ static ssize_t isl29003_store_resolution(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	unsigned long val;
 	int ret;
 
@@ -256,14 +258,14 @@ static DEVICE_ATTR(resolution, S_IWUSR | S_IRUGO,
 static ssize_t isl29003_show_mode(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	return sprintf(buf, "%d\n", isl29003_get_mode(client));
 }
 
 static ssize_t isl29003_store_mode(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	unsigned long val;
 	int ret;
 
@@ -286,7 +288,7 @@ static ssize_t isl29003_show_power_state(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	return sprintf(buf, "%d\n", isl29003_get_power_state(client));
 }
 
@@ -294,7 +296,7 @@ static ssize_t isl29003_store_power_state(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	unsigned long val;
 	int ret;
 
@@ -313,7 +315,7 @@ static DEVICE_ATTR(power_state, S_IWUSR | S_IRUGO,
 static ssize_t isl29003_show_lux(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 
 	/* No LUX data if not operational */
 	if (!isl29003_get_power_state(client))
@@ -322,14 +324,14 @@ static ssize_t isl29003_show_lux(struct device *dev,
 	return sprintf(buf, "%d\n", isl29003_get_adc_value(client));
 }
 
-static DEVICE_ATTR(lux, S_IRUGO, isl29003_show_lux, NULL);
+static DEVICE_ATTR(illuminance0, S_IRUGO, isl29003_show_lux, NULL);
 
 static struct attribute *isl29003_attributes[] = {
 	&dev_attr_range.attr,
 	&dev_attr_resolution.attr,
 	&dev_attr_mode.attr,
 	&dev_attr_power_state.attr,
-	&dev_attr_lux.attr,
+	&dev_attr_illuminance0.attr,
 	NULL
 };
 
@@ -388,14 +390,23 @@ static int __devinit isl29003_probe(struct i2c_client *client,
 	if (err)
 		goto exit_kfree;
 
+	data->classdev = als_device_register(&client->dev);
+	if (IS_ERR(data->classdev)) {
+		err = PTR_ERR(data->classdev);
+		goto exit_kfree;
+	}
+
 	/* register sysfs hooks */
-	err = sysfs_create_group(&client->dev.kobj, &isl29003_attr_group);
+	err = sysfs_create_group(&data->classdev->kobj, &isl29003_attr_group);
 	if (err)
-		goto exit_kfree;
+		goto exit_unreg;
 
 	dev_info(&client->dev, "driver version %s enabled\n", DRIVER_VERSION);
+
 	return 0;
 
+exit_unreg:
+	als_device_unregister(data->classdev);
 exit_kfree:
 	kfree(data);
 	return err;
@@ -403,9 +414,13 @@ exit_kfree:
 
 static int __devexit isl29003_remove(struct i2c_client *client)
 {
-	sysfs_remove_group(&client->dev.kobj, &isl29003_attr_group);
+	struct isl29003_data *data = i2c_get_clientdata(client);
+
+	sysfs_remove_group(&data->classdev->kobj, &isl29003_attr_group);	
+	als_device_unregister(data->classdev);
 	isl29003_set_power_state(client, 0);
 	kfree(i2c_get_clientdata(client));
+
 	return 0;
 }
 
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2c16ca6..e5ffa20 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -223,16 +223,6 @@ config DELL_LAPTOP
 	This driver adds support for rfkill and backlight control to Dell
 	laptops.
 
-config ISL29003
-	tristate "Intersil ISL29003 ambient light sensor"
-	depends on I2C && SYSFS
-	help
-	  If you say yes here you get support for the Intersil ISL29003
-	  ambient light sensor.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called isl29003.
-
 config EP93XX_PWM
 	tristate "EP93xx PWM support"
 	depends on ARCH_EP93XX
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 906a0ed..ab6e0af 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -18,7 +18,6 @@ obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
 obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
-obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_C2PORT)		+= c2port/
-- 
1.6.4.4

