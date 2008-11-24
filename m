Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYKXPUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYKXPUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKXPUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:20:16 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:46419 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYKXPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:20:13 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/4] HID: add dynids facility
Date: Mon, 24 Nov 2008 16:20:09 +0100
Message-Id: <1227540009-14209-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1227540009-14209-1-git-send-email-jirislaby@gmail.com>
References: <1227540009-14209-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow adding new devices to the hid drivers on the fly without
a need of kernel recompilation.

Now, one can test a driver e.g. by:
echo 0003:045E:00F0.0003 > ../generic-usb/unbind
echo 0003 045E 00F0 > new_id
from some driver subdir.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/hid-core.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hid.h    |    5 ++
 2 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1cac775..efcb5b8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1304,12 +1304,92 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ }
 };
 
+struct hid_dynid {
+	struct list_head list;
+	struct hid_device_id id;
+};
+
+/**
+ * store_new_id - add a new HID device ID to this driver and re-probe devices
+ * @driver: target device driver
+ * @buf: buffer for scanning device ID data
+ * @count: input size
+ *
+ * Adds a new dynamic hid device ID to this driver,
+ * and causes the driver to probe for all devices again.
+ */
+static ssize_t store_new_id(struct device_driver *drv, const char *buf,
+		size_t count)
+{
+	struct hid_driver *hdrv = container_of(drv, struct hid_driver, driver);
+	struct hid_dynid *dynid;
+	__u32 bus, vendor, product;
+	unsigned long driver_data = 0;
+	int ret;
+
+	ret = sscanf(buf, "%x %x %x %lx",
+			&bus, &vendor, &product, &driver_data);
+	if (ret < 3)
+		return -EINVAL;
+
+	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
+	if (!dynid)
+		return -ENOMEM;
+
+	dynid->id.bus = bus;
+	dynid->id.vendor = vendor;
+	dynid->id.product = product;
+	dynid->id.driver_data = driver_data;
+
+	spin_lock(&hdrv->dyn_lock);
+	list_add_tail(&dynid->list, &hdrv->dyn_list);
+	spin_unlock(&hdrv->dyn_lock);
+
+	ret = 0;
+	if (get_driver(&hdrv->driver)) {
+		ret = driver_attach(&hdrv->driver);
+		put_driver(&hdrv->driver);
+	}
+
+	return ret ? : count;
+}
+static DRIVER_ATTR(new_id, S_IWUSR, NULL, store_new_id);
+
+static void hid_free_dynids(struct hid_driver *hdrv)
+{
+	struct hid_dynid *dynid, *n;
+
+	spin_lock(&hdrv->dyn_lock);
+	list_for_each_entry_safe(dynid, n, &hdrv->dyn_list, list) {
+		list_del(&dynid->list);
+		kfree(dynid);
+	}
+	spin_unlock(&hdrv->dyn_lock);
+}
+
+static const struct hid_device_id *hid_match_device(struct hid_device *hdev,
+		struct hid_driver *hdrv)
+{
+	struct hid_dynid *dynid;
+
+	spin_lock(&hdrv->dyn_lock);
+	list_for_each_entry(dynid, &hdrv->dyn_list, list) {
+		if (hid_match_one_id(hdev, &dynid->id)) {
+			spin_unlock(&hdrv->dyn_lock);
+			return &dynid->id;
+		}
+	}
+	spin_unlock(&hdrv->dyn_lock);
+
+	return hid_match_id(hdev, hdrv->id_table);
+}
+
 static int hid_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct hid_driver *hdrv = container_of(drv, struct hid_driver, driver);
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 
-	if (!hid_match_id(hdev, hdrv->id_table))
+	if (!hid_match_device(hdev, hdrv))
 		return 0;
 
 	/* generic wants all non-blacklisted */
@@ -1328,7 +1408,7 @@ static int hid_device_probe(struct device *dev)
 	int ret = 0;
 
 	if (!hdev->driver) {
-		id = hid_match_id(hdev, hdrv->id_table);
+		id = hid_match_device(hdev, hdrv);
 		if (id == NULL)
 			return -ENODEV;
 
@@ -1695,18 +1775,33 @@ EXPORT_SYMBOL_GPL(hid_destroy_device);
 int __hid_register_driver(struct hid_driver *hdrv, struct module *owner,
 		const char *mod_name)
 {
+	int ret;
+
 	hdrv->driver.name = hdrv->name;
 	hdrv->driver.bus = &hid_bus_type;
 	hdrv->driver.owner = owner;
 	hdrv->driver.mod_name = mod_name;
 
-	return driver_register(&hdrv->driver);
+	INIT_LIST_HEAD(&hdrv->dyn_list);
+	spin_lock_init(&hdrv->dyn_lock);
+
+	ret = driver_register(&hdrv->driver);
+	if (ret)
+		return ret;
+
+	ret = driver_create_file(&hdrv->driver, &driver_attr_new_id);
+	if (ret)
+		driver_unregister(&hdrv->driver);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__hid_register_driver);
 
 void hid_unregister_driver(struct hid_driver *hdrv)
 {
+	driver_remove_file(&hdrv->driver, &driver_attr_new_id);
 	driver_unregister(&hdrv->driver);
+	hid_free_dynids(hdrv);
 }
 EXPORT_SYMBOL_GPL(hid_unregister_driver);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 2c20f20..215035b 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -531,6 +531,8 @@ struct hid_usage_id {
  * @name: driver name (e.g. "Footech_bar-wheel")
  * @id_table: which devices is this driver for (must be non-NULL for probe
  * 	      to be called)
+ * @dyn_list: list of dynamically added device ids
+ * @dyn_lock: lock protecting @dyn_list
  * @probe: new device inserted
  * @remove: device removed (NULL if not a hot-plug capable driver)
  * @report_table: on which reports to call raw_event (NULL means all)
@@ -558,6 +560,9 @@ struct hid_driver {
 	char *name;
 	const struct hid_device_id *id_table;
 
+	struct list_head dyn_list;
+	spinlock_t dyn_lock;
+
 	int (*probe)(struct hid_device *dev, const struct hid_device_id *id);
 	void (*remove)(struct hid_device *dev);
 
-- 
1.6.0.4

