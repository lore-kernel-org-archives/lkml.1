Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbXLTEnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbXLTEnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbXLTEl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:41:59 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:44205 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873AbXLTEl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:41:57 -0500
Date: Wed, 19 Dec 2007 23:41:38 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 1/5] Implement module aliasing for i2c to translate from	device
 tree names
In-reply-to: <20071220044136.20091.70984.stgit@terra.home>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071220044138.20091.31417.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071220044136.20091.70984.stgit@terra.home>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows new style i2c chip drivers to have alias names using
the official kernel aliasing system and MODULE_DEVICE_TABLE(). I've
tested it on PowerPC and x86. This change is required for PowerPC
device tree support.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 drivers/i2c/i2c-core.c          |   32 ++++++++++++++++++++++++++------
 include/linux/i2c.h             |    9 ++++-----
 include/linux/mod_devicetable.h |   20 ++++++++++++++++++++
 scripts/mod/file2alias.c        |   19 +++++++++++++++++++
 4 files changed, 69 insertions(+), 11 deletions(-)


diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index b5e13e4..fce06fd 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -47,10 +47,25 @@ static DEFINE_IDR(i2c_adapter_idr);
 
 /* ------------------------------------------------------------------------- */
 
-static int i2c_device_match(struct device *dev, struct device_driver *drv)
+static const struct i2c_device_id *i2c_device_match(const struct i2c_device_id *id, struct i2c_client *client)
+{
+	/* only powerpc drivers implement the id_table,
+	 * it is empty on other platforms */
+	if (id) {
+		while (id->name[0]) {
+			if (strcmp(client->driver_name, id->name) == 0)
+				return id;
+			id++;
+		}
+	}
+	return NULL;
+}
+
+static int i2c_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct i2c_driver	*driver = to_i2c_driver(drv);
+	const struct i2c_device_id *found_id;
 
 	/* make legacy i2c drivers bypass driver model probing entirely;
 	 * such drivers scan each i2c adapter/bus themselves.
@@ -58,9 +73,11 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 	if (!is_newstyle_driver(driver))
 		return 0;
 
-	/* new style drivers use the same kind of driver matching policy
-	 * as platform devices or SPI:  compare device and driver IDs.
-	 */
+	/* match on an id table if there is one */
+	found_id = i2c_device_match(driver->id_table, client);
+	if (found_id)
+		return 1;
+
 	return strcmp(client->driver_name, drv->name) == 0;
 }
 
@@ -89,12 +106,15 @@ static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct i2c_driver	*driver = to_i2c_driver(dev->driver);
+	const struct i2c_device_id *id;
 
 	if (!driver->probe)
 		return -ENODEV;
 	client->driver = driver;
 	dev_dbg(dev, "probe\n");
-	return driver->probe(client);
+
+	id = i2c_device_match(driver->id_table, client);
+	return driver->probe(client, id);
 }
 
 static int i2c_device_remove(struct device *dev)
@@ -189,7 +209,7 @@ static struct device_attribute i2c_dev_attrs[] = {
 static struct bus_type i2c_bus_type = {
 	.name		= "i2c",
 	.dev_attrs	= i2c_dev_attrs,
-	.match		= i2c_device_match,
+	.match		= i2c_bus_match,
 	.uevent		= i2c_device_uevent,
 	.probe		= i2c_device_probe,
 	.remove		= i2c_device_remove,
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a100c9f..49fc682 100644
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
@@ -179,7 +178,7 @@ struct i2c_client {
 					/* to the client		*/
 	struct device dev;		/* the device structure		*/
 	int irq;			/* irq issued by device (or -1) */
-	char driver_name[KOBJ_NAME_LEN];
+	char driver_name[I2C_NAME_SIZE];
 	struct list_head list;
 	struct completion released;
 };
@@ -223,7 +222,7 @@ static inline void i2c_set_clientdata (struct i2c_client *dev, void *data)
  * with the adapter already known.
  */
 struct i2c_board_info {
-	char		driver_name[KOBJ_NAME_LEN];
+	char		driver_name[I2C_NAME_SIZE];
 	char		type[I2C_NAME_SIZE];
 	unsigned short	flags;
 	unsigned short	addr;
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index e9fddb4..d66038a 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -367,4 +367,24 @@ struct virtio_device_id {
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff
 
+/* i2c */
+
+/* These defines are used to separate PowerPC open firmware
+ * drivers into their own namespace */
+#define I2C_NAME_SIZE	(16*3)
+#define I2C_MODULE_PREFIX "i2c:N"
+#ifdef CONFIG_OF
+#define OF_I2C_PREFIX "OF,"
+#define I2C_OF_MODULE_PREFIX I2C_MODULE_PREFIX OF_I2C_PREFIX
+#define OF_I2C_ID(s,d) {OF_I2C_PREFIX s, (d) },
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
index d802b5a..da43742 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -539,6 +539,21 @@ static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
 	return 1;
 }
 
+/* Looks like: i2c:Ns */
+static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
+			   char *alias)
+{
+    char *tmp;
+    sprintf (alias, I2C_MODULE_PREFIX "%s", id->name);
+
+    /* Replace all whitespace with underscores */
+    for (tmp = alias; tmp && *tmp; tmp++)
+        if (isspace (*tmp))
+            *tmp = '_';
+
+    return 1;
+}
+
 /* Ignore any prefix, eg. v850 prepends _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -669,6 +684,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct virtio_device_id), "virtio",
 			 do_virtio_entry, mod);
+	else if (sym_is(symname, "__mod_i2c_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct i2c_device_id), "i2c",
+			 do_i2c_entry, mod);
 	free(zeros);
 }
 

