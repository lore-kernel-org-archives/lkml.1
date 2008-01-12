Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbYALDAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbYALDAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 22:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYALDAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 22:00:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:60928 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbYALDAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 22:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hbLdfe7wT8Kh+i1PTcLTt3XZsT9n1uS0itZ3naivAJ8tLen7EW/UMr65oDMf68naX4TslNFOsL2RKifGiCCawuEBRPLCDubpv9EOdXo0+aHp5rnH5GBd5nyaDMJvJOcpAXZ3IZrkclLUJZN7lQzwuh/NrbhJxSDLH0FCj9AW6uI=
Message-ID: <9e4733910801111900w6ace7c3bxe7e5f781db07ae4b@mail.gmail.com>
Date: Fri, 11 Jan 2008 22:00:42 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 19 1/5] Implement module aliasing for i2c to translate from device tree names
In-Reply-To: <20080112024739.7023.90634.stgit@terra.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112024737.7023.61680.stgit@terra.home>
	 <20080112024739.7023.90634.stgit@terra.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment was wrong, I2C_OF_MODULE_PREFIX was needed. Add it back.

Implement module aliasing for i2c to translate from device tree names

This patch allows new style i2c chip drivers to have alias names using
the official kernel aliasing system and MODULE_DEVICE_TABLE(). I've
tested it on PowerPC and x86. This change is required for PowerPC
device tree support.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 drivers/hwmon/f75375s.c         |    4 ++--
 drivers/i2c/chips/ds1682.c      |    2 +-
 drivers/i2c/chips/menelaus.c    |    2 +-
 drivers/i2c/chips/tps65010.c    |    2 +-
 drivers/i2c/chips/tsl2550.c     |    2 +-
 drivers/i2c/i2c-core.c          |   24 +++++++++++++++++++++++-
 drivers/rtc/rtc-ds1307.c        |    2 +-
 drivers/rtc/rtc-ds1374.c        |    2 +-
 drivers/rtc/rtc-m41t80.c        |    2 +-
 drivers/rtc/rtc-rs5c372.c       |    2 +-
 include/linux/i2c.h             |    5 ++---
 include/linux/mod_devicetable.h |   20 ++++++++++++++++++++
 scripts/mod/file2alias.c        |   12 ++++++++++++
 13 files changed, 67 insertions(+), 14 deletions(-)


diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 6892f76..2247de6 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -117,7 +117,7 @@ struct f75375_data {
 static int f75375_attach_adapter(struct i2c_adapter *adapter);
 static int f75375_detect(struct i2c_adapter *adapter, int address, int kind);
 static int f75375_detach_client(struct i2c_client *client);
-static int f75375_probe(struct i2c_client *client);
+static int f75375_probe(struct i2c_client *client, const struct
i2c_device_id *id);
 static int f75375_remove(struct i2c_client *client);

 static struct i2c_driver f75375_legacy_driver = {
@@ -628,7 +628,7 @@ static void f75375_init(struct i2c_client *client,
struct f75375_data *data,

 }

-static int f75375_probe(struct i2c_client *client)
+static int f75375_probe(struct i2c_client *client, const struct
i2c_device_id *id)
 {
 	struct f75375_data *data = i2c_get_clientdata(client);
 	struct f75375s_platform_data *f75375s_pdata = client->dev.platform_data;
diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
index 9e94542..93c0441 100644
--- a/drivers/i2c/chips/ds1682.c
+++ b/drivers/i2c/chips/ds1682.c
@@ -200,7 +200,7 @@ static struct bin_attribute ds1682_eeprom_attr = {
 /*
  * Called when a ds1682 device is matched with this driver
  */
-static int ds1682_probe(struct i2c_client *client)
+static int ds1682_probe(struct i2c_client *client, const struct
i2c_device_id *id)
 {
 	int rc;

diff --git a/drivers/i2c/chips/menelaus.c b/drivers/i2c/chips/menelaus.c
index 2dea012..89ef9b6 100644
--- a/drivers/i2c/chips/menelaus.c
+++ b/drivers/i2c/chips/menelaus.c
@@ -1149,7 +1149,7 @@ static inline void menelaus_rtc_init(struct
menelaus_chip *m)

 static struct i2c_driver menelaus_i2c_driver;

-static int menelaus_probe(struct i2c_client *client)
+static int menelaus_probe(struct i2c_client *client, const struct
i2c_device_id *id)
 {
 	struct menelaus_chip	*menelaus;
 	int			rev = 0, val;
diff --git a/drivers/i2c/chips/tps65010.c b/drivers/i2c/chips/tps65010.c
index e320994..6b13642 100644
--- a/drivers/i2c/chips/tps65010.c
+++ b/drivers/i2c/chips/tps65010.c
@@ -465,7 +465,7 @@ static int __exit tps65010_remove(struct i2c_client *client)
 	return 0;
 }

-static int tps65010_probe(struct i2c_client *client)
+static int tps65010_probe(struct i2c_client *client, const struct
i2c_device_id *id)
 {
 	struct tps65010		*tps;
 	int			status;
diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/i2c/chips/tsl2550.c
index 3de4b19..27c553d 100644
--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/i2c/chips/tsl2550.c
@@ -364,7 +364,7 @@ static int tsl2550_init_client(struct i2c_client *client)
  */

 static struct i2c_driver tsl2550_driver;
-static int __devinit tsl2550_probe(struct i2c_client *client)
+static int __devinit tsl2550_probe(struct i2c_client *client, const
struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct tsl2550_data *data;
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index b5e13e4..5f62230 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -47,6 +47,19 @@ static DEFINE_IDR(i2c_adapter_idr);

 /* ------------------------------------------------------------------------- */

+static const struct i2c_device_id *i2c_match_id(
+		const struct i2c_device_id *id, struct i2c_client *client)
+{
+	/* only powerpc drivers implement the id_table,
+	 * it is empty on other platforms */
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
@@ -58,6 +71,10 @@ static int i2c_device_match(struct device *dev,
struct device_driver *drv)
 	if (!is_newstyle_driver(driver))
 		return 0;

+	/* match on an id table if there is one */
+	if (driver->id_table)
+		return i2c_match_id(driver->id_table, client) != NULL;
+
 	/* new style drivers use the same kind of driver matching policy
 	 * as platform devices or SPI:  compare device and driver IDs.
 	 */
@@ -89,12 +106,17 @@ static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct i2c_driver	*driver = to_i2c_driver(dev->driver);
+	const struct i2c_device_id *id = NULL;

 	if (!driver->probe)
 		return -ENODEV;
 	client->driver = driver;
 	dev_dbg(dev, "probe\n");
-	return driver->probe(client);
+
+	if (driver->id_table)
+		id = i2c_match_id(driver->id_table, client);
+	
+	return driver->probe(client, id);
 }

 static int i2c_device_remove(struct device *dev)
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index bc1c7fe..9b0eab9 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -326,7 +326,7 @@ static struct bin_attribute nvram = {

 static struct i2c_driver ds1307_driver;

-static int __devinit ds1307_probe(struct i2c_client *client)
+static int __devinit ds1307_probe(struct i2c_client *client, const
struct i2c_device_id *id)
 {
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 45bda18..dab6008 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -355,7 +355,7 @@ static const struct rtc_class_ops ds1374_rtc_ops = {
 	.ioctl = ds1374_ioctl,
 };

-static int ds1374_probe(struct i2c_client *client)
+static int ds1374_probe(struct i2c_client *client, const struct
i2c_device_id *id)
 {
 	struct ds1374 *ds1374;
 	int ret;
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 1cb33ca..457f2ca 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -756,7 +756,7 @@ static struct notifier_block wdt_notifier = {
  *
  *****************************************************************************
  */
-static int m41t80_probe(struct i2c_client *client)
+static int m41t80_probe(struct i2c_client *client, const struct
i2c_device_id *id)
 {
 	int i, rc = 0;
 	struct rtc_device *rtc = NULL;
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 6b67b50..25de13b 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -494,7 +494,7 @@ static void rs5c_sysfs_unregister(struct device *dev)

 static struct i2c_driver rs5c372_driver;

-static int rs5c372_probe(struct i2c_client *client)
+static int rs5c372_probe(struct i2c_client *client, const struct
i2c_device_id *id)
 {
 	int err = 0;
 	struct rs5c372 *rs5c372;
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a100c9f..0ca1a59 100644
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
@@ -141,11 +141,10 @@ struct i2c_driver {

 	struct device_driver driver;
 	struct list_head list;
+	struct i2c_device_id *id_table;
 };
 #define to_i2c_driver(d) container_of(d, struct i2c_driver, driver)

-#define I2C_NAME_SIZE	20
-
 /**
  * struct i2c_client - represent an I2C slave device
  * @flags: I2C_CLIENT_TEN indicates the device uses a ten bit chip address;
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index e9fddb4..612d416 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -367,4 +367,24 @@ struct virtio_device_id {
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff

+/* i2c */
+
+/* These defines are used to separate PowerPC open firmware
+ * drivers into their own namespace */
+#define I2C_NAME_SIZE	(16*3)  /* Needs to be large enough to hold
device tree style names */
+#define I2C_MODULE_PREFIX "i2c:"
+#ifdef CONFIG_OF
+#define OF_I2C_PREFIX "OF,"
+#define I2C_OF_MODULE_PREFIX I2C_MODULE_PREFIX OF_I2C_PREFIX
+#define OF_I2C_ID(s,d) { OF_I2C_PREFIX s, (d) },
+#else
+#define OF_I2C_ID(s,d)
+#endif
+
+struct i2c_device_id {
+	char name[I2C_NAME_SIZE];
+	kernel_ulong_t driver_data;	/* Data private to the driver */
+};
+
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index d802b5a..ac05b04 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -539,6 +539,14 @@ static int do_virtio_entry(const char *filename,
struct virtio_device_id *id,
 	return 1;
 }

+/* Looks like: i2c:s */
+static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
+			   char *alias)
+{
+	sprintf(alias, I2C_MODULE_PREFIX "%s", id->name);
+	return 1;
+}
+
 /* Ignore any prefix, eg. v850 prepends _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -669,6 +677,10 @@ void handle_moddevtable(struct module *mod,
struct elf_info *info,
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
Jon Smirl
jonsmirl@gmail.com
