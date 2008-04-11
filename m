Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbYDKOIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbYDKOIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbYDKOHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:07:52 -0400
Received: from mail0.scram.de ([78.47.204.202]:57415 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbYDKOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:07:50 -0400
X-Spam-Score: -4.221
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47FF70A7.5070002@scram.de>
Date: Fri, 11 Apr 2008 16:07:35 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: [PATCH1/7] i2c: Add support for device alias names
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier work by Jon Smirl and Jean Delvare.

This patch allows new-style i2c chip drivers to have alias names using
the official kernel aliasing system and MODULE_DEVICE_TABLE(). At this
point, the old i2c driver binding scheme (driver_name/type) is still
supported.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jon Smirl <jonsmirl@gmail.com>
---
 drivers/hwmon/f75375s.c                    |   21 ++++++++----
 drivers/i2c/chips/ds1682.c                 |    3 +-
 drivers/i2c/chips/menelaus.c               |    3 +-
 drivers/i2c/chips/tps65010.c               |    3 +-
 drivers/i2c/chips/tsl2550.c                |    3 +-
 drivers/i2c/i2c-core.c                     |   51 +++++++++++++++++++++++-----
 drivers/media/video/cs5345.c               |    3 +-
 drivers/media/video/cs53l32a.c             |    3 +-
 drivers/media/video/cx25840/cx25840-core.c |    3 +-
 drivers/media/video/ivtv/ivtv-i2c.c        |    2 +-
 drivers/media/video/m52790.c               |    3 +-
 drivers/media/video/msp3400-driver.c       |    3 +-
 drivers/media/video/saa7115.c              |    3 +-
 drivers/media/video/saa7127.c              |    3 +-
 drivers/media/video/tlv320aic23b.c         |    3 +-
 drivers/media/video/tuner-core.c           |    3 +-
 drivers/media/video/tvaudio.c              |    3 +-
 drivers/media/video/upd64031a.c            |    3 +-
 drivers/media/video/upd64083.c             |    3 +-
 drivers/media/video/v4l2-common.c          |    5 ++-
 drivers/media/video/vp27smpx.c             |    3 +-
 drivers/media/video/wm8739.c               |    3 +-
 drivers/media/video/wm8775.c               |    3 +-
 drivers/rtc/rtc-ds1307.c                   |    3 +-
 drivers/rtc/rtc-ds1374.c                   |    3 +-
 drivers/rtc/rtc-m41t80.c                   |    3 +-
 drivers/rtc/rtc-rs5c372.c                  |    3 +-
 include/linux/i2c.h                        |    5 +--
 include/linux/mod_devicetable.h            |   13 +++++++
 include/media/v4l2-common.h                |    4 ++-
 include/media/v4l2-i2c-drv-legacy.h        |    2 +-
 include/media/v4l2-i2c-drv.h               |    2 +-
 scripts/mod/file2alias.c                   |   13 +++++++
 33 files changed, 139 insertions(+), 48 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 1464338..3ec9123 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -117,7 +117,8 @@ struct f75375_data {
 static int f75375_attach_adapter(struct i2c_adapter *adapter);
 static int f75375_detect(struct i2c_adapter *adapter, int address, int kind);
 static int f75375_detach_client(struct i2c_client *client);
-static int f75375_probe(struct i2c_client *client);
+static int f75375_probe(struct i2c_client *client,
+			const struct i2c_device_id *id);
 static int f75375_remove(struct i2c_client *client);
 
 static struct i2c_driver f75375_legacy_driver = {
@@ -628,7 +629,8 @@ static void f75375_init(struct i2c_client *client, struct f75375_data *data,
 
 }
 
-static int f75375_probe(struct i2c_client *client)
+static int f75375_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
 	struct f75375_data *data = i2c_get_clientdata(client);
 	struct f75375s_platform_data *f75375s_pdata = client->dev.platform_data;
@@ -637,7 +639,8 @@ static int f75375_probe(struct i2c_client *client)
 	if (!i2c_check_functionality(client->adapter,
 				I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
-	if (!(data = kzalloc(sizeof(struct f75375_data), GFP_KERNEL)))
+	data = kzalloc(sizeof(struct f75375_data), GFP_KERNEL);
+	if (!data)
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, data);
@@ -653,7 +656,8 @@ static int f75375_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
-	if ((err = sysfs_create_group(&client->dev.kobj, &f75375_group)))
+	err = sysfs_create_group(&client->dev.kobj, &f75375_group);
+	if (err)
 		goto exit_free;
 
 	if (data->kind == f75375) {
@@ -713,7 +717,8 @@ static int f75375_detect(struct i2c_adapter *adapter, int address, int kind)
 	int err = 0;
 	const char *name = "";
 
-	if (!(client = kzalloc(sizeof(*client), GFP_KERNEL))) {
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
+	if (!client) {
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -745,10 +750,12 @@ static int f75375_detect(struct i2c_adapter *adapter, int address, int kind)
 	dev_info(&adapter->dev, "found %s version: %02X\n", name, version);
 	strlcpy(client->name, name, I2C_NAME_SIZE);
 
-	if ((err = i2c_attach_client(client)))
+	err = i2c_attach_client(client);
+	if (err)
 		goto exit_free;
 
-	if ((err = f75375_probe(client)) < 0)
+	err = f75375_probe(client, NULL);
+	if (err < 0)
 		goto exit_detach;
 
 	return 0;
diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
index 9e94542..3070821 100644
--- a/drivers/i2c/chips/ds1682.c
+++ b/drivers/i2c/chips/ds1682.c
@@ -200,7 +200,8 @@ static struct bin_attribute ds1682_eeprom_attr = {
 /*
  * Called when a ds1682 device is matched with this driver
  */
-static int ds1682_probe(struct i2c_client *client)
+static int ds1682_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
 {
 	int rc;
 
diff --git a/drivers/i2c/chips/menelaus.c b/drivers/i2c/chips/menelaus.c
index 2dea012..3b8ba7e 100644
--- a/drivers/i2c/chips/menelaus.c
+++ b/drivers/i2c/chips/menelaus.c
@@ -1149,7 +1149,8 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 
 static struct i2c_driver menelaus_i2c_driver;
 
-static int menelaus_probe(struct i2c_client *client)
+static int menelaus_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
 	struct menelaus_chip	*menelaus;
 	int			rev = 0, val;
diff --git a/drivers/i2c/chips/tps65010.c b/drivers/i2c/chips/tps65010.c
index 4154a91..3ce43f8 100644
--- a/drivers/i2c/chips/tps65010.c
+++ b/drivers/i2c/chips/tps65010.c
@@ -465,7 +465,8 @@ static int __exit tps65010_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int tps65010_probe(struct i2c_client *client)
+static int tps65010_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
 	struct tps65010		*tps;
 	int			status;
diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/i2c/chips/tsl2550.c
index a10fd27..59c2c66 100644
--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/i2c/chips/tsl2550.c
@@ -364,7 +364,8 @@ static int tsl2550_init_client(struct i2c_client *client)
  */
 
 static struct i2c_driver tsl2550_driver;
-static int __devinit tsl2550_probe(struct i2c_client *client)
+static int __devinit tsl2550_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct tsl2550_data *data;
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 8b645c6..8879acb 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -48,6 +48,17 @@ static DEFINE_IDR(i2c_adapter_idr);
 
 /* ------------------------------------------------------------------------- */
 
+static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
+						const struct i2c_client *client)
+{
+	while (id->name[0]) {
+		if (strcmp(client->name, id->name) == 0)
+			return id;
+		id++;
+	}
+	return NULL;
+}
+
 static int i2c_device_match(struct device *dev, struct device_driver *drv)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
@@ -59,6 +70,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 	if (!is_newstyle_driver(driver))
 		return 0;
 
+	/* match on an id table if there is one */
+	if (driver->id_table)
+		return i2c_match_id(driver->id_table, client) != NULL;
+
 	/* new style drivers use the same kind of driver matching policy
 	 * as platform devices or SPI:  compare device and driver IDs.
 	 */
@@ -73,11 +88,17 @@ static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	struct i2c_client	*client = to_i2c_client(dev);
 
 	/* by definition, legacy drivers can't hotplug */
-	if (dev->driver || !client->driver_name)
+	if (dev->driver)
 		return 0;
 
-	if (add_uevent_var(env, "MODALIAS=%s", client->driver_name))
-		return -ENOMEM;
+	if (client->driver_name[0]) {
+		if (add_uevent_var(env, "MODALIAS=%s", client->driver_name))
+			return -ENOMEM;
+	} else {
+		if (add_uevent_var(env, "MODALIAS=%s%s",
+				   I2C_MODULE_PREFIX, client->name))
+			return -ENOMEM;
+	}
 	dev_dbg(dev, "uevent\n");
 	return 0;
 }
@@ -91,12 +112,18 @@ static int i2c_device_probe(struct device *dev)
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct i2c_driver	*driver = to_i2c_driver(dev->driver);
 	int status;
+	const struct i2c_device_id *id;
 
 	if (!driver->probe)
 		return -ENODEV;
 	client->driver = driver;
 	dev_dbg(dev, "probe\n");
-	status = driver->probe(client);
+
+	if (driver->id_table)
+		id = i2c_match_id(driver->id_table, client);
+	else
+		id = NULL;
+	status = driver->probe(client, id);
 	if (status)
 		client->driver = NULL;
 	return status;
@@ -179,9 +206,9 @@ static ssize_t show_client_name(struct device *dev, struct device_attribute *att
 static ssize_t show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	return client->driver_name
+	return client->driver_name[0]
 		? sprintf(buf, "%s\n", client->driver_name)
-		: 0;
+		: sprintf(buf, "%s%s\n", I2C_MODULE_PREFIX, client->name);
 }
 
 static struct device_attribute i2c_dev_attrs[] = {
@@ -300,15 +327,21 @@ void i2c_unregister_device(struct i2c_client *client)
 EXPORT_SYMBOL_GPL(i2c_unregister_device);
 
 
-static int dummy_nop(struct i2c_client *client)
+static int dummy_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	return 0;
+}
+
+static int dummy_remove(struct i2c_client *client)
 {
 	return 0;
 }
 
 static struct i2c_driver dummy_driver = {
 	.driver.name	= "dummy",
-	.probe		= dummy_nop,
-	.remove		= dummy_nop,
+	.probe		= dummy_probe,
+	.remove		= dummy_remove,
 };
 
 /**
diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
index fae469c..2a429f9 100644
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -142,7 +142,8 @@ static int cs5345_command(struct i2c_client *client, unsigned cmd, void *arg)
 
 /* ----------------------------------------------------------------------- */
 
-static int cs5345_probe(struct i2c_client *client)
+static int cs5345_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
 {
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
index f41bfde..2dfd0af 100644
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -135,7 +135,8 @@ static int cs53l32a_command(struct i2c_client *client, unsigned cmd, void *arg)
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
  */
 
-static int cs53l32a_probe(struct i2c_client *client)
+static int cs53l32a_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
 	int i;
 
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 756a1ee..6f16186 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1232,7 +1232,8 @@ static int cx25840_command(struct i2c_client *client, unsigned int cmd,
 
 /* ----------------------------------------------------------------------- */
 
-static int cx25840_probe(struct i2c_client *client)
+static int cx25840_probe(struct i2c_client *client,
+			 const struct i2c_device_id *did)
 {
 	struct cx25840_state *state;
 	u32 id;
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index fa5ab1e..37b0fd6 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -167,7 +167,7 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 		return -1;
 	id = hw_driverids[idx];
 	memset(&info, 0, sizeof(info));
-	strcpy(info.driver_name, hw_drivernames[idx]);
+	strcpy(info.type, hw_drivernames[idx]);
 	info.addr = hw_addrs[idx];
 	for (i = 0; itv->i2c_clients[i] && i < I2C_CLIENTS_MAX; i++) {}
 
diff --git a/drivers/media/video/m52790.c b/drivers/media/video/m52790.c
index d4bf14c..5b9dfa2 100644
--- a/drivers/media/video/m52790.c
+++ b/drivers/media/video/m52790.c
@@ -126,7 +126,8 @@ static int m52790_command(struct i2c_client *client, unsigned int cmd,
 
 /* i2c implementation */
 
-static int m52790_probe(struct i2c_client *client)
+static int m52790_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
 {
 	struct m52790_state *state;
 
diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
index 7a11f31..3f97737 100644
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -805,7 +805,8 @@ static int msp_resume(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
-static int msp_probe(struct i2c_client *client)
+static int msp_probe(struct i2c_client *client,
+		     const struct i2c_device_id *id)
 {
 	struct msp_state *state;
 	int (*thread_func)(void *data) = NULL;
diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index 41e5e51..7882e29 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -1450,7 +1450,8 @@ static int saa7115_command(struct i2c_client *client, unsigned int cmd, void *ar
 
 /* ----------------------------------------------------------------------- */
 
-static int saa7115_probe(struct i2c_client *client)
+static int saa7115_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
 {
 	struct saa711x_state *state;
 	int	i;
diff --git a/drivers/media/video/saa7127.c b/drivers/media/video/saa7127.c
index 06c88db..e750cd6 100644
--- a/drivers/media/video/saa7127.c
+++ b/drivers/media/video/saa7127.c
@@ -661,7 +661,8 @@ static int saa7127_command(struct i2c_client *client,
 
 /* ----------------------------------------------------------------------- */
 
-static int saa7127_probe(struct i2c_client *client)
+static int saa7127_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
 {
 	struct saa7127_state *state;
 	struct v4l2_sliced_vbi_data vbi = { 0, 0, 0, 0 };  /* set to disabled */
diff --git a/drivers/media/video/tlv320aic23b.c b/drivers/media/video/tlv320aic23b.c
index dc7b9c2..f1db542 100644
--- a/drivers/media/video/tlv320aic23b.c
+++ b/drivers/media/video/tlv320aic23b.c
@@ -125,7 +125,8 @@ static int tlv320aic23b_command(struct i2c_client *client,
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
  */
 
-static int tlv320aic23b_probe(struct i2c_client *client)
+static int tlv320aic23b_probe(struct i2c_client *client,
+			      const struct i2c_device_id *id)
 {
 	struct tlv320aic23b_state *state;
 
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 78a09a2..edd451e 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1074,7 +1074,8 @@ static void tuner_lookup(struct i2c_adapter *adap,
 /* During client attach, set_type is called by adapter's attach_inform callback.
    set_type must then be completed by tuner_probe.
  */
-static int tuner_probe(struct i2c_client *client)
+static int tuner_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
 {
 	struct tuner *t;
 	struct tuner *radio;
diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 01ebcec..1fa1552 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1461,7 +1461,8 @@ static struct CHIPDESC chiplist[] = {
 /* ---------------------------------------------------------------------- */
 /* i2c registration                                                       */
 
-static int chip_probe(struct i2c_client *client)
+static int chip_probe(struct i2c_client *client,
+		      const struct i2c_device_id *id)
 {
 	struct CHIPSTATE *chip;
 	struct CHIPDESC  *desc;
diff --git a/drivers/media/video/upd64031a.c b/drivers/media/video/upd64031a.c
index bd20139..93bfd19 100644
--- a/drivers/media/video/upd64031a.c
+++ b/drivers/media/video/upd64031a.c
@@ -195,7 +195,8 @@ static int upd64031a_command(struct i2c_client *client, unsigned cmd, void *arg)
 
 /* i2c implementation */
 
-static int upd64031a_probe(struct i2c_client *client)
+static int upd64031a_probe(struct i2c_client *client,
+			   const struct i2c_device_id *id)
 {
 	struct upd64031a_state *state;
 	int i;
diff --git a/drivers/media/video/upd64083.c b/drivers/media/video/upd64083.c
index 2d9a88f..9ab712a 100644
--- a/drivers/media/video/upd64083.c
+++ b/drivers/media/video/upd64083.c
@@ -172,7 +172,8 @@ static int upd64083_command(struct i2c_client *client, unsigned cmd, void *arg)
 
 /* i2c implementation */
 
-static int upd64083_probe(struct i2c_client *client)
+static int upd64083_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
 	struct upd64083_state *state;
 	int i;
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 34deb68..afacf75 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -710,7 +710,8 @@ EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
 /* Helper function for I2C legacy drivers */
 
 int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct i2c_driver *driver,
-		const char *name, int (*probe)(struct i2c_client *))
+		const char *name, int (*probe)(struct i2c_client *,
+					       const struct i2c_device_id *id))
 {
 	struct i2c_client *client;
 	int err;
@@ -724,7 +725,7 @@ int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct i2c_driver
 	client->driver = driver;
 	strlcpy(client->name, name, sizeof(client->name));
 
-	err = probe(client);
+	err = probe(client, NULL);
 	if (err == 0) {
 		i2c_attach_client(client);
 	} else {
diff --git a/drivers/media/video/vp27smpx.c b/drivers/media/video/vp27smpx.c
index 282c814..fac0deb 100644
--- a/drivers/media/video/vp27smpx.c
+++ b/drivers/media/video/vp27smpx.c
@@ -121,7 +121,8 @@ static int vp27smpx_command(struct i2c_client *client, unsigned cmd, void *arg)
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
  */
 
-static int vp27smpx_probe(struct i2c_client *client)
+static int vp27smpx_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
 	struct vp27smpx_state *state;
 
diff --git a/drivers/media/video/wm8739.c b/drivers/media/video/wm8739.c
index 31795b4..0f8ed84 100644
--- a/drivers/media/video/wm8739.c
+++ b/drivers/media/video/wm8739.c
@@ -261,7 +261,8 @@ static int wm8739_command(struct i2c_client *client, unsigned cmd, void *arg)
 
 /* i2c implementation */
 
-static int wm8739_probe(struct i2c_client *client)
+static int wm8739_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
 {
 	struct wm8739_state *state;
 
diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index 869f9e7..67a409e 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -159,7 +159,8 @@ static int wm8775_command(struct i2c_client *client, unsigned cmd, void *arg)
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
  */
 
-static int wm8775_probe(struct i2c_client *client)
+static int wm8775_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
 {
 	struct wm8775_state *state;
 
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index f389a28..67ba8ae 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -326,7 +326,8 @@ static struct bin_attribute nvram = {
 
 static struct i2c_driver ds1307_driver;
 
-static int __devinit ds1307_probe(struct i2c_client *client)
+static int __devinit ds1307_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
 {
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 45bda18..104dcfd 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -355,7 +355,8 @@ static const struct rtc_class_ops ds1374_rtc_ops = {
 	.ioctl = ds1374_ioctl,
 };
 
-static int ds1374_probe(struct i2c_client *client)
+static int ds1374_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
 {
 	struct ds1374 *ds1374;
 	int ret;
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 1cb33ca..2ee0d07 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -756,7 +756,8 @@ static struct notifier_block wdt_notifier = {
  *
  *****************************************************************************
  */
-static int m41t80_probe(struct i2c_client *client)
+static int m41t80_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
 {
 	int i, rc = 0;
 	struct rtc_device *rtc = NULL;
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 6b67b50..ebdbad9 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -494,7 +494,8 @@ static void rs5c_sysfs_unregister(struct device *dev)
 
 static struct i2c_driver rs5c372_driver;
 
-static int rs5c372_probe(struct i2c_client *client)
+static int rs5c372_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
 {
 	int err = 0;
 	struct rs5c372 *rs5c372;
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 365e0df..92c8ecf 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -126,7 +126,7 @@ struct i2c_driver {
 	 * With the driver model, device enumeration is NEVER done by drivers;
 	 * it's done by infrastructure.  (NEW STYLE DRIVERS ONLY)
 	 */
-	int (*probe)(struct i2c_client *);
+	int (*probe)(struct i2c_client *, const struct i2c_device_id *id);
 	int (*remove)(struct i2c_client *);
 
 	/* driver model interfaces that don't relate to enumeration  */
@@ -140,11 +140,10 @@ struct i2c_driver {
 	int (*command)(struct i2c_client *client,unsigned int cmd, void *arg);
 
 	struct device_driver driver;
+	const struct i2c_device_id *id_table;
 };
 #define to_i2c_driver(d) container_of(d, struct i2c_driver, driver)
 
-#define I2C_NAME_SIZE	20
-
 /**
  * struct i2c_client - represent an I2C slave device
  * @flags: I2C_CLIENT_TEN indicates the device uses a ten bit chip address;
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 139d49d..696c07b 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -368,4 +368,17 @@ struct virtio_device_id {
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff
 
+/* i2c */
+
+/* These defines are used to separate PowerPC open firmware
+ * drivers into their own namespace */
+#define I2C_NAME_SIZE	20
+#define I2C_MODULE_PREFIX "i2c:"
+
+struct i2c_device_id {
+	char name[I2C_NAME_SIZE];
+	kernel_ulong_t driver_data;	/* Data private to the driver */
+};
+
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 316a584..9c4b906 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -107,9 +107,11 @@ int v4l2_chip_match_host(u32 id_type, u32 chip_id);
 struct i2c_driver;
 struct i2c_adapter;
 struct i2c_client;
+struct i2c_device_id;
 
 int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct i2c_driver *driver,
-		const char *name, int (*probe)(struct i2c_client *));
+		const char *name, int (*probe)(struct i2c_client *,
+					       const struct i2c_device_id *id));
 
 /* ------------------------------------------------------------------------- */
 
diff --git a/include/media/v4l2-i2c-drv-legacy.h b/include/media/v4l2-i2c-drv-legacy.h
index e764557..347b6f8 100644
--- a/include/media/v4l2-i2c-drv-legacy.h
+++ b/include/media/v4l2-i2c-drv-legacy.h
@@ -25,7 +25,7 @@ struct v4l2_i2c_driver_data {
 	const char * const name;
 	int driverid;
 	int (*command)(struct i2c_client *client, unsigned int cmd, void *arg);
-	int (*probe)(struct i2c_client *client);
+	int (*probe)(struct i2c_client *client, const struct i2c_device_id *id);
 	int (*remove)(struct i2c_client *client);
 	int (*suspend)(struct i2c_client *client, pm_message_t state);
 	int (*resume)(struct i2c_client *client);
diff --git a/include/media/v4l2-i2c-drv.h b/include/media/v4l2-i2c-drv.h
index 9e4bab2..7b6f06b 100644
--- a/include/media/v4l2-i2c-drv.h
+++ b/include/media/v4l2-i2c-drv.h
@@ -30,7 +30,7 @@ struct v4l2_i2c_driver_data {
 	const char * const name;
 	int driverid;
 	int (*command)(struct i2c_client *client, unsigned int cmd, void *arg);
-	int (*probe)(struct i2c_client *client);
+	int (*probe)(struct i2c_client *client, const struct i2c_device_id *id);
 	int (*remove)(struct i2c_client *client);
 	int (*suspend)(struct i2c_client *client, pm_message_t state);
 	int (*resume)(struct i2c_client *client);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 348d868..0d9e179 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -543,6 +543,15 @@ static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
 	return 1;
 }
 
+/* Looks like: i2c:S */
+static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
+			char *alias)
+{
+	sprintf(alias, I2C_MODULE_PREFIX "%s", id->name);
+
+	return 1;
+}
+
 /* Ignore any prefix, eg. v850 prepends _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -673,6 +682,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct virtio_device_id), "virtio",
 			 do_virtio_entry, mod);
+	else if (sym_is(symname, "__mod_i2c_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct i2c_device_id), "i2c",
+			 do_i2c_entry, mod);
 	free(zeros);
 }
 
-- 
1.5.4.5



