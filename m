Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbYEPJui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbYEPJui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYEPJuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:50:22 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43280 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755326AbYEPJuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:50:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 02/10] HID: make a bus from hid code
Date: Fri, 16 May 2008 11:49:15 +0200
Message-Id: <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a bus from hid core. This is the first step for converting all the
quirks and separate almost-drivers into real drivers attached to this bus.

It's implemented to change behaviour in very tiny manner, so that no driver
needs to be changed this time.

Also add generic drivers for both usb and bt into usbhid or hidp
respectively which will bind all non-blacklisted device. Those blacklisted
will be either grabbed by special drivers or by nobody if they are broken at
the very rude base.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-core.c        |  470 ++++++++++++++++++++++++++++++++++-------
 drivers/hid/hid-input.c       |    2 +-
 drivers/hid/usbhid/hid-core.c |   44 +++-
 drivers/hid/usbhid/usbhid.h   |    2 +-
 include/linux/hid.h           |  100 ++++++++-
 net/bluetooth/hidp/core.c     |   64 +++++-
 6 files changed, 578 insertions(+), 104 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f43d6d3..2bf7561 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -534,9 +534,10 @@ static void hid_free_report(struct hid_report *report)
  * Free a device structure, all reports, and all fields.
  */
 
-void hid_free_device(struct hid_device *device)
+static void hid_device_release(struct device *dev)
 {
-	unsigned i,j;
+	struct hid_device *device = container_of(dev, struct hid_device, dev);
+	unsigned i, j;
 
 	for (i = 0; i < HID_REPORT_TYPES; i++) {
 		struct hid_report_enum *report_enum = device->report_enum + i;
@@ -552,7 +553,6 @@ void hid_free_device(struct hid_device *device)
 	kfree(device->collection);
 	kfree(device);
 }
-EXPORT_SYMBOL_GPL(hid_free_device);
 
 /*
  * Fetch a report description item from the data stream. We support long
@@ -622,18 +622,24 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
 	return NULL;
 }
 
-/*
+/**
+ * hid_parse_report - parse device report
+ *
+ * @device: hid device
+ * @start: report start
+ * @size: report size
+ *
  * Parse a report description into a hid_device structure. Reports are
  * enumerated, fields are attached to these reports.
+ * 0 returned on success, otherwise nonzero error value.
  */
-
-struct hid_device *hid_parse_report(__u8 *start, unsigned size)
+int hid_parse_report(struct hid_device *device, __u8 *start,
+		unsigned size)
 {
-	struct hid_device *device;
 	struct hid_parser *parser;
 	struct hid_item item;
 	__u8 *end;
-	unsigned i;
+	int ret;
 	static int (*dispatch_type[])(struct hid_parser *parser,
 				      struct hid_item *item) = {
 		hid_parser_main,
@@ -642,76 +648,54 @@ struct hid_device *hid_parse_report(__u8 *start, unsigned size)
 		hid_parser_reserved
 	};
 
-	if (!(device = kzalloc(sizeof(struct hid_device), GFP_KERNEL)))
-		return NULL;
-
-	if (!(device->collection = kzalloc(sizeof(struct hid_collection) *
-				   HID_DEFAULT_NUM_COLLECTIONS, GFP_KERNEL))) {
-		kfree(device);
-		return NULL;
-	}
-	device->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
-
-	for (i = 0; i < HID_REPORT_TYPES; i++)
-		INIT_LIST_HEAD(&device->report_enum[i].report_list);
-
-	if (!(device->rdesc = kmalloc(size, GFP_KERNEL))) {
-		kfree(device->collection);
-		kfree(device);
-		return NULL;
-	}
+	device->rdesc = kmalloc(size, GFP_KERNEL);
+	if (device->rdesc == NULL)
+		return -ENOMEM;
 	memcpy(device->rdesc, start, size);
 	device->rsize = size;
 
-	if (!(parser = vmalloc(sizeof(struct hid_parser)))) {
-		kfree(device->rdesc);
-		kfree(device->collection);
-		kfree(device);
-		return NULL;
+	parser = vmalloc(sizeof(struct hid_parser));
+	if (!parser) {
+		ret = -ENOMEM;
+		goto err;
 	}
+
 	memset(parser, 0, sizeof(struct hid_parser));
 	parser->device = device;
 
 	end = start + size;
+	ret = -EINVAL;
 	while ((start = fetch_item(start, end, &item)) != NULL) {
 
 		if (item.format != HID_ITEM_FORMAT_SHORT) {
 			dbg_hid("unexpected long global item\n");
-			hid_free_device(device);
-			vfree(parser);
-			return NULL;
+			goto err;
 		}
 
 		if (dispatch_type[item.type](parser, &item)) {
 			dbg_hid("item %u %u %u %u parsing failed\n",
 				item.format, (unsigned)item.size, (unsigned)item.type, (unsigned)item.tag);
-			hid_free_device(device);
-			vfree(parser);
-			return NULL;
+			goto err;
 		}
 
 		if (start == end) {
 			if (parser->collection_stack_ptr) {
 				dbg_hid("unbalanced collection at end of report description\n");
-				hid_free_device(device);
-				vfree(parser);
-				return NULL;
+				goto err;
 			}
 			if (parser->local.delimiter_depth) {
 				dbg_hid("unbalanced delimiter at end of report description\n");
-				hid_free_device(device);
-				vfree(parser);
-				return NULL;
+				goto err;
 			}
 			vfree(parser);
-			return device;
+			return 0;
 		}
 	}
 
 	dbg_hid("item fetching failed at offset %d\n", (int)(end - start));
-	hid_free_device(device);
+err:
 	vfree(parser);
-	return NULL;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hid_parse_report);
 
@@ -815,9 +799,69 @@ static __inline__ int search(__s32 *array, __s32 value, unsigned n)
 	return -1;
 }
 
-static void hid_process_event(struct hid_device *hid, struct hid_field *field, struct hid_usage *usage, __s32 value, int interrupt)
+/**
+ * hid_match_report - check if driver's raw_event should be called
+ *
+ * @hid: hid device
+ * @report_type: type to match against
+ *
+ * compare hid->driver->report_table->report_type to report->type
+ */
+static int hid_match_report(struct hid_device *hid, struct hid_report *report)
 {
+	const struct hid_report_id *id = hid->driver->report_table;
+
+	if (!id) /* NULL means all */
+		return 1;
+
+	for (; id->report_type != HID_TERMINATOR; id++)
+		if (id->report_type == HID_ANY_ID ||
+				id->report_type == report->type)
+			return 1;
+	return 0;
+}
+
+/**
+ * hid_match_usage - check if driver's event should be called
+ *
+ * @hid: hid device
+ * @usage: usage to match against
+ *
+ * compare hid->driver->usage_table->usage_{type,code} to
+ * usage->usage_{type,code}
+ */
+static int hid_match_usage(struct hid_device *hid, struct hid_usage *usage)
+{
+	const struct hid_usage_id *id = hid->driver->usage_table;
+
+	if (!id) /* NULL means all */
+		return 1;
+
+	for (; id->usage_type != HID_ANY_ID - 1; id++)
+		if ((id->usage_type == HID_ANY_ID ||
+				id->usage_type == usage->type) &&
+				(id->usage_code == HID_ANY_ID ||
+				 id->usage_code == usage->code))
+			return 1;
+	return 0;
+}
+
+static void hid_process_event(struct hid_device *hid, struct hid_field *field,
+		struct hid_usage *usage, __s32 value, int interrupt)
+{
+	struct hid_driver *hdrv = hid->driver;
+	int ret;
+
 	hid_dump_input(usage, value);
+
+	if (hdrv && hdrv->event && hid_match_usage(hid, usage)) {
+		ret = hdrv->event(hid, field, usage, value);
+		if (ret != -ENODEV) {
+			dbg_hid("%s's event failed with %d\n", hdrv->name, ret);
+			return;
+		}
+	}
+
 	if (hid->claimed & HID_CLAIMED_INPUT)
 		hidinput_hid_event(hid, field, usage, value);
 	if (hid->claimed & HID_CLAIMED_HIDDEV && interrupt && hid->hiddev_hid_event)
@@ -946,44 +990,47 @@ int hid_set_field(struct hid_field *field, unsigned offset, __s32 value)
 }
 EXPORT_SYMBOL_GPL(hid_set_field);
 
-int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int interrupt)
+static struct hid_report *hid_get_report(struct hid_report_enum *report_enum,
+		const u8 *data)
 {
-	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
-	int n, rsize, i;
+	unsigned int n = 0;	/* Normally report number is 0 */
 
-	if (!hid)
-		return -ENODEV;
+	/* Device uses numbered reports, data[0] is report number */
+	if (report_enum->numbered)
+		n = *data;
 
-	if (!size) {
-		dbg_hid("empty report\n");
-		return -1;
-	}
+	report = report_enum->report_id_hash[n];
+	if (report == NULL)
+		dbg_hid("undefined report_id %u received\n", n);
 
-	dbg_hid("report (size %u) (%snumbered)\n", size, report_enum->numbered ? "" : "un");
+	return report;
+}
 
-	n = 0;                          /* Normally report number is 0 */
-	if (report_enum->numbered) {    /* Device uses numbered reports, data[0] is report number */
-		n = *data++;
-		size--;
-	}
+void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
+		int interrupt)
+{
+	struct hid_report_enum *report_enum = hid->report_enum + type;
+	struct hid_report *report;
+	unsigned int a;
+	int rsize, csize = size;
+	u8 *cdata = data;
 
-	/* dump the report */
-	dbg_hid("report %d (size %u) = ", n, size);
-	for (i = 0; i < size; i++)
-		dbg_hid_line(" %02x", data[i]);
-	dbg_hid_line("\n");
+	report = hid_get_report(report_enum, data);
+	if (!report)
+		return;
 
-	if (!(report = report_enum->report_id_hash[n])) {
-		dbg_hid("undefined report_id %d received\n", n);
-		return -1;
+	if (report_enum->numbered) {
+		cdata++;
+		csize--;
 	}
 
 	rsize = ((report->size - 1) >> 3) + 1;
 
-	if (size < rsize) {
-		dbg_hid("report %d is too short, (%d < %d)\n", report->id, size, rsize);
-		memset(data + size, 0, rsize - size);
+	if (csize < rsize) {
+		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
+				csize, rsize);
+		memset(cdata + csize, 0, rsize - csize);
 	}
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
@@ -996,24 +1043,295 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 			hidraw_report_event(hid, data, size);
 	}
 
-	for (n = 0; n < report->maxfield; n++)
-		hid_input_field(hid, report->field[n], data, interrupt);
+	for (a = 0; a < report->maxfield; a++)
+		hid_input_field(hid, report->field[a], cdata, interrupt);
 
 	if (hid->claimed & HID_CLAIMED_INPUT)
 		hidinput_report_event(hid, report);
+}
+EXPORT_SYMBOL_GPL(hid_report_raw_event);
+
+/**
+ * hid_input_report - report data from lower layer (usb, bt...)
+ *
+ * @hid: hid device
+ * @type: HID report type (HID_*_REPORT)
+ * @data: report contents
+ * @size: size of data parameter
+ * @interrupt: called from atomic?
+ *
+ * This is data entry for lower layers.
+ */
+int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int interrupt)
+{
+	struct hid_report_enum *report_enum = hid->report_enum + type;
+	struct hid_driver *hdrv = hid->driver;
+	struct hid_report *report;
+	unsigned int i;
+	int ret;
+
+	if (!hid || !hid->driver)
+		return -ENODEV;
+
+	if (!size) {
+		dbg_hid("empty report\n");
+		return -1;
+	}
+
+	dbg_hid("report (size %u) (%snumbered)\n", size, report_enum->numbered ? "" : "un");
+
+	report = hid_get_report(report_enum, data);
+	if (!report)
+		return -1;
+
+	/* dump the report */
+	dbg_hid("report %d (size %u) = ", report->id, size);
+	for (i = 0; i < size; i++)
+		dbg_hid_line(" %02x", data[i]);
+	dbg_hid_line("\n");
+
+	if (hdrv && hdrv->raw_event && hid_match_report(hid, report)) {
+		ret = hdrv->raw_event(hid, report, data, size);
+		if (ret != -ENODEV)
+			return ret;
+	}
+
+	hid_report_raw_event(hid, type, data, size, interrupt);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hid_input_report);
 
+static bool hid_match_one_id(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	return id->bus == hdev->bus &&
+		(id->vendor == HID_ANY_ID || id->vendor == hdev->vendor) &&
+		(id->product == HID_ANY_ID || id->product == hdev->product);
+}
+
+static const struct hid_device_id *hid_match_id(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	for (; id->bus; id++)
+		if (hid_match_one_id(hdev, id))
+			return id;
+
+	return NULL;
+}
+
+static const struct hid_device_id hid_blacklist[] = {
+	{ }
+};
+
+static int hid_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct hid_driver *hdrv = container_of(drv, struct hid_driver, driver);
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+
+	if (!hid_match_id(hdev, hdrv->id_table))
+		return 0;
+
+	/* generic wants all non-blacklisted */
+	if (!strncmp(hdrv->name, "generic-", 8))
+		return !hid_match_id(hdev, hid_blacklist);
+
+	return 1;
+}
+
+static int hid_device_probe(struct device *dev)
+{
+	struct hid_driver *hdrv = container_of(dev->driver,
+			struct hid_driver, driver);
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	const struct hid_device_id *id;
+	int ret = 0;
+
+	if (!hdev->driver) {
+		if (hdrv->probe) {
+			ret = -ENODEV;
+
+			id = hid_match_id(hdev, hdrv->id_table);
+			if (id)
+				ret = hdrv->probe(hdev, id);
+		}
+		if (!ret)
+			hdev->driver = hdrv;
+	}
+	return ret;
+}
+
+static int hid_device_remove(struct device *dev)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct hid_driver *hdrv = hdev->driver;
+
+	if (hdrv) {
+		if (hdrv->remove)
+			hdrv->remove(hdev);
+		hdev->driver = NULL;
+	}
+
+	return 0;
+}
+
+static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+
+	if (add_uevent_var(env, "HID_ID=%04X:%08X:%08X",
+			hdev->bus, hdev->vendor, hdev->product))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "HID_NAME=%s", hdev->name))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "HID_PHYS=%s", hdev->phys))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "HID_UNIQ=%s", hdev->uniq))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "MODALIAS=hid:b%04Xv%08Xp%08X",
+			hdev->bus, hdev->vendor, hdev->product))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static struct bus_type hid_bus_type = {
+	.name		= "hid",
+	.match		= hid_bus_match,
+	.probe		= hid_device_probe,
+	.remove		= hid_device_remove,
+	.uevent		= hid_uevent,
+};
+
+int hid_add_device(struct hid_device *hdev)
+{
+	static atomic_t id = ATOMIC_INIT(0);
+	int ret;
+
+	if (WARN_ON(hdev->status & HID_STAT_ADDED))
+		return -EBUSY;
+
+	/* XXX hack, any other cleaner solution < 20 bus_id bytes? */
+	sprintf(hdev->dev.bus_id, "%04X:%04X:%04X.%04X", hdev->bus,
+			hdev->vendor, hdev->product, atomic_inc_return(&id));
+
+	ret = device_add(&hdev->dev);
+	if (!ret)
+		hdev->status |= HID_STAT_ADDED;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hid_add_device);
+
+/**
+ * hid_allocate_device - allocate new hid device descriptor
+ *
+ * Allocate and initialize hid device, so that hid_destroy_device might be
+ * used to free it.
+ *
+ * New hid_device pointer is returned on success, otherwise ERR_PTR encoded
+ * error value.
+ */
+struct hid_device *hid_allocate_device(void)
+{
+	struct hid_device *hdev;
+	unsigned int i;
+	int ret = -ENOMEM;
+
+	hdev = kzalloc(sizeof(*hdev), GFP_KERNEL);
+	if (hdev == NULL)
+		return ERR_PTR(ret);
+
+	device_initialize(&hdev->dev);
+	hdev->dev.release = hid_device_release;
+	hdev->dev.bus = &hid_bus_type;
+
+	hdev->collection = kcalloc(HID_DEFAULT_NUM_COLLECTIONS,
+			sizeof(struct hid_collection), GFP_KERNEL);
+	if (hdev->collection == NULL)
+		goto err;
+	hdev->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
+
+	for (i = 0; i < HID_REPORT_TYPES; i++)
+		INIT_LIST_HEAD(&hdev->report_enum[i].report_list);
+
+	return hdev;
+err:
+	put_device(&hdev->dev);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(hid_allocate_device);
+
+static void hid_remove_device(struct hid_device *hdev)
+{
+	if (hdev->status & HID_STAT_ADDED) {
+		device_del(&hdev->dev);
+		hdev->status &= ~HID_STAT_ADDED;
+	}
+}
+
+/**
+ * hid_destroy_device - free previously allocated device
+ *
+ * @hdev: hid device
+ *
+ * If you allocate hid_device through hid_allocate_device, you should ever
+ * free by this function.
+ */
+void hid_destroy_device(struct hid_device *hdev)
+{
+	hid_remove_device(hdev);
+	put_device(&hdev->dev);
+}
+EXPORT_SYMBOL_GPL(hid_destroy_device);
+
+int __hid_register_driver(struct hid_driver *hdrv, struct module *owner,
+		const char *mod_name)
+{
+	hdrv->driver.name = hdrv->name;
+	hdrv->driver.bus = &hid_bus_type;
+	hdrv->driver.owner = owner;
+	hdrv->driver.mod_name = mod_name;
+
+	return driver_register(&hdrv->driver);
+}
+EXPORT_SYMBOL_GPL(__hid_register_driver);
+
+void hid_unregister_driver(struct hid_driver *hdrv)
+{
+	driver_unregister(&hdrv->driver);
+}
+EXPORT_SYMBOL_GPL(hid_unregister_driver);
+
 static int __init hid_init(void)
 {
-	return hidraw_init();
+	int ret;
+
+	ret = bus_register(&hid_bus_type);
+	if (ret) {
+		printk(KERN_ERR "HID: can't register hid bus\n");
+		goto err;
+	}
+
+	ret = hidraw_init();
+	if (ret)
+		goto err_bus;
+
+	return 0;
+err_bus:
+	bus_unregister(&hid_bus_type);
+err:
+	return ret;
 }
 
 static void __exit hid_exit(void)
 {
 	hidraw_exit();
+	bus_unregister(&hid_bus_type);
 }
 
 module_init(hid_init);
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 452b94d..6f44ea0 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1031,7 +1031,7 @@ int hidinput_connect(struct hid_device *hid)
 				input_dev->id.vendor  = hid->vendor;
 				input_dev->id.product = hid->product;
 				input_dev->id.version = hid->version;
-				input_dev->dev.parent = hid->dev;
+				input_dev->dev.parent = hid->dev.parent;
 				hidinput->input = input_dev;
 				list_add_tail(&hidinput->list, &hid->inputs);
 			}
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 01427c5..b649fdc 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -770,8 +770,15 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		dbg_hid_line(" %02x", (unsigned char) rdesc[n]);
 	dbg_hid_line("\n");
 
-	if (!(hid = hid_parse_report(rdesc, n))) {
+	hid = hid_allocate_device();
+	if (IS_ERR(hid)) {
+		kfree(rdesc);
+		return NULL;
+	}
+
+	if (hid_parse_report(hid, rdesc, n)) {
 		dbg_hid("parsing report descriptor failed\n");
+		hid_destroy_device(hid);
 		kfree(rdesc);
 		return NULL;
 	}
@@ -798,10 +805,8 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 	if (insize > HID_MAX_BUFFER_SIZE)
 		insize = HID_MAX_BUFFER_SIZE;
 
-	if (hid_alloc_buffers(dev, hid)) {
-		hid_free_buffers(dev, hid);
+	if (hid_alloc_buffers(dev, hid))
 		goto fail;
-	}
 
 	hid->name[0] = 0;
 
@@ -881,7 +886,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 
 	hid->version = le16_to_cpu(hdesc->bcdHID);
 	hid->country = hdesc->bCountryCode;
-	hid->dev = &intf->dev;
+	hid->dev.parent = &intf->dev;
 	usbhid->intf = intf;
 	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
@@ -925,7 +930,7 @@ fail:
 	hid_free_buffers(dev, hid);
 	kfree(usbhid);
 fail_no_usbhid:
-	hid_free_device(hid);
+	hid_destroy_device(hid);
 
 	return NULL;
 }
@@ -964,14 +969,14 @@ static void hid_disconnect(struct usb_interface *intf)
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
 	kfree(usbhid);
-	hid_free_device(hid);
+	hid_destroy_device(hid);
 }
 
 static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct hid_device *hid;
 	char path[64];
-	int i;
+	int i, ret;
 	char *c;
 
 	dbg_hid("HID probe called for ifnum %d\n",
@@ -1037,7 +1042,12 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	printk(": USB HID v%x.%02x %s [%s] on %s\n",
 		hid->version >> 8, hid->version & 0xff, c, hid->name, path);
 
-	return 0;
+	ret = hid_add_device(hid);
+	if (ret) {
+		dev_err(&intf->dev, "can't add hid device: %d\n", ret);
+		hid_disconnect(intf);
+	}
+	return ret;
 }
 
 static int hid_suspend(struct usb_interface *intf, pm_message_t message)
@@ -1107,9 +1117,22 @@ static struct usb_driver hid_driver = {
 	.supports_autosuspend = 1,
 };
 
+static const struct hid_device_id hid_usb_table[] = {
+	{ HID_USB_DEVICE(HID_ANY_ID, HID_ANY_ID) },
+	{ }
+};
+
+static struct hid_driver hid_usb_driver = {
+	.name = "generic-usb",
+	.id_table = hid_usb_table,
+};
+
 static int __init hid_init(void)
 {
 	int retval;
+	retval = hid_register_driver(&hid_usb_driver);
+	if (retval)
+		goto hid_register_fail;
 	retval = usbhid_quirks_init(quirks_param);
 	if (retval)
 		goto usbhid_quirks_init_fail;
@@ -1127,6 +1150,8 @@ usb_register_fail:
 hiddev_init_fail:
 	usbhid_quirks_exit();
 usbhid_quirks_init_fail:
+	hid_unregister_driver(&hid_usb_driver);
+hid_register_fail:
 	return retval;
 }
 
@@ -1135,6 +1160,7 @@ static void __exit hid_exit(void)
 	usb_deregister(&hid_driver);
 	hiddev_exit();
 	usbhid_quirks_exit();
+	hid_unregister_driver(&hid_usb_driver);
 }
 
 module_init(hid_init);
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index 62d2d7c..b47f991 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -82,7 +82,7 @@ struct usbhid_device {
 };
 
 #define	hid_to_usb_dev(hid_dev) \
-	container_of(hid_dev->dev->parent, struct usb_device, dev)
+	container_of(hid_dev->dev.parent->parent, struct usb_device, dev)
 
 #endif
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8466292..1c25de1 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -420,6 +420,8 @@ struct hid_control_fifo {
 #define HID_CLAIMED_HIDDEV	2
 #define HID_CLAIMED_HIDRAW	4
 
+#define HID_STAT_ADDED		1
+
 #define HID_CTRL_RUNNING	1
 #define HID_OUT_RUNNING		2
 #define HID_IN_RUNNING		3
@@ -434,22 +436,26 @@ struct hid_input {
 	struct input_dev *input;
 };
 
+struct hid_driver;
+
 struct hid_device {							/* device report descriptor */
-	 __u8 *rdesc;
+	__u8 *rdesc;
 	unsigned rsize;
 	struct hid_collection *collection;				/* List of HID collections */
 	unsigned collection_size;					/* Number of allocated hid_collections */
 	unsigned maxcollection;						/* Number of parsed collections */
 	unsigned maxapplication;					/* Number of applications */
-	unsigned short bus;                                             /* BUS ID */
-	unsigned short vendor;                                          /* Vendor ID */
-	unsigned short product;                                         /* Product ID */
-	unsigned version;						/* HID version */
+	__u16 bus;							/* BUS ID */
+	__u32 vendor;							/* Vendor ID */
+	__u32 product;							/* Product ID */
+	__u32 version;							/* HID version */
 	unsigned country;						/* HID country */
 	struct hid_report_enum report_enum[HID_REPORT_TYPES];
 
-	struct device *dev;						/* device */
+	struct device dev;						/* device */
+	struct hid_driver *driver;
 
+	unsigned int status;						/* see STAT flags above */
 	unsigned claimed;						/* Claimed by hidinput, hiddev? */
 	unsigned quirks;						/* Various quirks the device can pull on us */
 
@@ -485,6 +491,16 @@ struct hid_device {							/* device report descriptor */
 #endif
 };
 
+static inline void *hid_get_drvdata(struct hid_device *hdev)
+{
+	return dev_get_drvdata(&hdev->dev);
+}
+
+static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
+{
+	dev_set_drvdata(&hdev->dev, data);
+}
+
 #define HID_GLOBAL_STACK_SIZE 4
 #define HID_COLLECTION_STACK_SIZE 4
 
@@ -513,6 +529,57 @@ struct hid_descriptor {
 	struct hid_class_descriptor desc[1];
 } __attribute__ ((packed));
 
+#define HID_DEVICE(b, ven, prod) \
+	.bus = (b), \
+	.vendor = (ven), .product = (prod)
+
+#define HID_USB_DEVICE(ven, prod)	HID_DEVICE(BUS_USB, ven, prod)
+#define HID_BLUETOOTH_DEVICE(ven, prod)	HID_DEVICE(BUS_BLUETOOTH, ven, prod)
+
+#define HID_REPORT_ID(rep) \
+	.report_type = (rep)
+#define HID_USAGE_ID(utype, ucode) \
+	.usage_type = (utype), .usage_code = (ucode)
+/* we don't want to catch types and codes equal to 0 */
+#define HID_TERMINATOR		(HID_ANY_ID - 1)
+
+struct hid_report_id {
+	__u32 report_type;
+};
+struct hid_usage_id {
+	__u32 usage_type;
+	__u32 usage_code;
+};
+
+/**
+ * struct hid_driver
+ * @name: driver name (e.g. "Footech_bar-wheel")
+ * @id_table: which devices is this driver for (must be non-NULL for probe
+ * 	      to be called)
+ * @probe: new device inserted
+ * @remove: device removed (NULL if not a hot-plug capable driver)
+ * @report_table: on which reports to call raw_event (NULL means all)
+ * @raw_event: if report in report_table, this hook is called (NULL means nop)
+ * @usage_table: on which events to call event (NULL means all)
+ * @event: if usage in usage_table, this hook is called (NULL means nop)
+ */
+struct hid_driver {
+	char *name;
+	const struct hid_device_id *id_table;
+
+	int (*probe)(struct hid_device *dev, const struct hid_device_id *id);
+	void (*remove)(struct hid_device *dev);
+
+	const struct hid_report_id *report_table;
+	int (*raw_event)(struct hid_device *hdev, struct hid_report *report,
+			u8 *data, int size);
+	const struct hid_usage_id *usage_table;
+	int (*event)(struct hid_device *hdev, struct hid_field *field,
+			struct hid_usage *usage, __s32 value);
+/* private: */
+	struct device_driver driver;
+};
+
 /* Applications from HID Usage Tables 4/8/99 Version 1.1 */
 /* We ignore a few input applications that are not widely used */
 #define IS_INPUT_APPLICATION(a) (((a >= 0x00010000) && (a <= 0x00010008)) || (a == 0x00010080) || (a == 0x000c0001))
@@ -523,6 +590,17 @@ struct hid_descriptor {
 extern int hid_debug;
 #endif
 
+extern int hid_add_device(struct hid_device *);
+extern void hid_destroy_device(struct hid_device *);
+
+extern int __must_check __hid_register_driver(struct hid_driver *,
+		struct module *, const char *mod_name);
+static inline int __must_check hid_register_driver(struct hid_driver *driver)
+{
+	return __hid_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
+}
+extern void hid_unregister_driver(struct hid_driver *);
+
 extern void hidinput_hid_event(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
 extern void hidinput_report_event(struct hid_device *hid, struct hid_report *report);
 extern int hidinput_connect(struct hid_device *);
@@ -535,8 +613,14 @@ int hidinput_mapping_quirks(struct hid_usage *, struct input_dev *, unsigned lon
 int hidinput_event_quirks(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
 int hidinput_apple_event(struct hid_device *, struct input_dev *, struct hid_usage *, __s32);
 void hid_output_report(struct hid_report *report, __u8 *data);
-void hid_free_device(struct hid_device *device);
-struct hid_device *hid_parse_report(__u8 *start, unsigned size);
+struct hid_device *hid_allocate_device(void);
+int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
+
+void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
+		int interrupt);
+
+extern int hid_generic_init(void);
+extern void hid_generic_exit(void);
 
 /* HID quirks API */
 u32 usbhid_lookup_quirk(const u16 idVendor, const u16 idProduct);
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 519cdb9..5ba536b 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -578,7 +578,7 @@ static int hidp_session(void *arg)
 	if (session->hid) {
 		if (session->hid->claimed & HID_CLAIMED_INPUT)
 			hidinput_disconnect(session->hid);
-		hid_free_device(session->hid);
+		hid_destroy_device(session->hid);
 	}
 
 	fput(session->intr_sock->file);
@@ -692,12 +692,13 @@ static void hidp_setup_quirks(struct hid_device *hid)
 			hid->quirks = hidp_blacklist[n].quirks;
 }
 
-static void hidp_setup_hid(struct hidp_session *session,
+static int hidp_setup_hid(struct hidp_session *session,
 				struct hidp_connadd_req *req)
 {
 	struct hid_device *hid = session->hid;
 	struct hid_report *report;
 	bdaddr_t src, dst;
+	int ret;
 
 	baswap(&src, &bt_sk(session->ctrl_sock->sk)->src);
 	baswap(&dst, &bt_sk(session->ctrl_sock->sk)->dst);
@@ -715,7 +716,7 @@ static void hidp_setup_hid(struct hidp_session *session,
 	strncpy(hid->phys, batostr(&src), 64);
 	strncpy(hid->uniq, batostr(&dst), 64);
 
-	hid->dev = hidp_get_device(session);
+	hid->dev.parent = hidp_get_device(session);
 
 	hid->hid_open  = hidp_open;
 	hid->hid_close = hidp_close;
@@ -732,6 +733,15 @@ static void hidp_setup_hid(struct hidp_session *session,
 
 	if (hidinput_connect(hid) == 0)
 		hid->claimed |= HID_CLAIMED_INPUT;
+
+	ret = hid_add_device(hid);
+	if (ret) {
+		if (hid->claimed & HID_CLAIMED_INPUT)
+			hidinput_disconnect(hid);
+		skb_queue_purge(&session->intr_transmit);
+	}
+
+	return ret;
 }
 
 int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
@@ -765,11 +775,19 @@ int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock,
 			return -EFAULT;
 		}
 
-		session->hid = hid_parse_report(buf, req->rd_size);
+		session->hid = hid_allocate_device();
+		if (IS_ERR(session->hid)) {
+			kfree(buf);
+			kfree(session);
+			return PTR_ERR(session->hid);
+		}
+
+		err = hid_parse_report(session->hid, buf, req->rd_size);
 
 		kfree(buf);
 
-		if (!session->hid) {
+		if (err) {
+			hid_destroy_device(session->hid);
 			kfree(session);
 			return -EINVAL;
 		}
@@ -816,8 +834,11 @@ int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock,
 			goto failed;
 	}
 
-	if (session->hid)
-		hidp_setup_hid(session, req);
+	if (session->hid) {
+		err = hidp_setup_hid(session, req);
+		if (err)
+			goto failed;
+	}
 
 	__hidp_link_session(session);
 
@@ -853,7 +874,7 @@ failed:
 	up_write(&hidp_session_sem);
 
 	if (session->hid)
-		hid_free_device(session->hid);
+		hid_destroy_device(session->hid);
 
 	input_free_device(session->input);
 	kfree(session);
@@ -940,18 +961,43 @@ int hidp_get_conninfo(struct hidp_conninfo *ci)
 	return err;
 }
 
+static const struct hid_device_id hidp_table[] = {
+	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
+	{ }
+};
+
+static struct hid_driver hidp_driver = {
+	.name = "generic-bluetooth",
+	.id_table = hidp_table,
+};
+
 static int __init hidp_init(void)
 {
+	int ret;
+
 	l2cap_load();
 
 	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
 
-	return hidp_init_sockets();
+	ret = hid_register_driver(&hidp_driver);
+	if (ret)
+		goto err;
+
+	ret = hidp_init_sockets();
+	if (ret)
+		goto err_drv;
+
+	return 0;
+err_drv:
+	hid_unregister_driver(&hidp_driver);
+err:
+	return ret;
 }
 
 static void __exit hidp_exit(void)
 {
 	hidp_cleanup_sockets();
+	hid_unregister_driver(&hidp_driver);
 }
 
 module_init(hidp_init);
-- 
1.5.4.5

