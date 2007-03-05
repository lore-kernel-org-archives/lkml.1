Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXCEHcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXCEHcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXCEHcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:32:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:62847 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbXCEHcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:32:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=cEne0HyFDm5hi60IMtag9SDm9ABtNHZs6MMX1Ye8ej5jGINVNjc3v2GEpLrebS+th1Mci2VswdaTIGoY0s38E1+RCjV3N0UMGFt2vRXhwb2PA8jqML21SzEZ4fln4Vz84f5xSPh3UzEybKeAsz140AycsQ8qV6ykWd8Geg9YL08=
Date: Mon, 5 Mar 2007 15:32:00 +0800
From: "Li Yu" <raise.sail@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Greg Kroah Hartman" <greg@kroah.com>,
       "linux-usb-devel" <linux-usb-devel@lists.sourceforge.net>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Vincent Legoll" <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Harold Sargeant" <harold-sargeant@ntlworld.com>
Cc: "liyu" <liyu@ccoss.com.cn>
Subject: [PATCH] usb/hid:The HID Simple Driver Interface 0.5.0 (core)
Message-ID: <200703051531587283478@gmail.com>
X-mailer: Foxmail 6, 5, 104, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changelogs (since 0.4.1):

	1. port to 2.6.21.
	2. One bugfix.

The code base is 2.6.21-rc2.

Signed-off-by: Liyu <raise.sail@gmail.com>

diff -Naurp linux-2.6.21-rc2.orig/include/linux/hid.h linux-2.6.21-rc2/include/linux/hid.h
--- linux-2.6.21-rc2.orig/include/linux/hid.h	2007-03-05 09:09:35.000000000 +0800
+++ linux-2.6.21-rc2/include/linux/hid.h	2007-03-05 11:17:22.000000000 +0800
@@ -35,6 +35,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/input.h>
+#include <linux/mutex.h>
 
 /*
  * USB HID (Human Interface Device) interface class code
@@ -397,8 +398,15 @@ struct hid_input {
 	struct list_head list;
 	struct hid_report *report;
 	struct input_dev *input;
+	unsigned long input_lock;	/* To protect accessing input_dev from
+					 * hid-input processing. But it not 
+					 * necessary for accessing this input_dev 
+					 * instance from input subsystem. */
+	void *private;
 };
 
+struct hidinput_simple_driver;
+
 struct hid_device {							/* device report descriptor */
 	 __u8 *rdesc;
 	unsigned rsize;
@@ -429,6 +437,8 @@ struct hid_device {							/* device repo
 	char phys[64];							/* Device physical location */
 	char uniq[64];							/* Device unique identifier (serial #) */
 
+	struct hidinput_simple_driver *simple;
+
 	void *driver_data;
 
 	/* device-specific function pointers */
@@ -483,6 +493,8 @@ extern void hidinput_hid_event(struct hi
 extern void hidinput_report_event(struct hid_device *hid, struct hid_report *report);
 extern int hidinput_connect(struct hid_device *);
 extern void hidinput_disconnect(struct hid_device *);
+extern void hidinput_reconnect_core(struct hid_device *);
+extern int hidinput_disconnect_core(struct hid_device *);
 
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, int, int);
diff -Naurp linux-2.6.21-rc2.orig/include/linux/hid-simple.h linux-2.6.21-rc2/include/linux/hid-simple.h
--- linux-2.6.21-rc2.orig/include/linux/hid-simple.h	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6.21-rc2/include/linux/hid-simple.h	2007-03-05 13:37:42.000000000 +0800
@@ -0,0 +1,260 @@
+/*
+ *  NOTE:
+ *	For use me , you must include hid.h in your source first. 
+ */
+#ifndef __HID_SIMPLE_H
+#define __HID_SIMPLE_H
+
+#ifdef __KERNEL__
+
+#include <asm/bitops.h>
+/***** The public interface for simple device driver *****/
+struct usage_block {
+	int usage; /* usage code */
+	int value; /* not used, for F_EVENT_BY_VALUE in future  */
+	int event; /* input event type, e.g. EV_KEY. */
+	int code;  /* input subsystem code, e.g. KEY_F1. */
+	int flags; /* not used */
+};
+
+struct usage_page_block {
+	int page; /* usage page code */
+	int flags; /* not used */
+	struct usage_block *usage_blockes;
+};
+
+extern struct mutex matched_devices_lock;
+extern struct mutex simple_drivers_lock;
+extern struct list_head simple_drivers_list;
+extern struct list_head matched_devices_list;
+
+/* usage_block flags list */
+#define F_EVENT_BY_VALUE (0x1) /* submit input event by usage_block.value, 
+				  not implement yet */
+
+#define USAGE_BLOCK(i_usage, i_value, i_event, i_code, i_flags) \
+	{\
+		.usage = (i_usage),\
+		.value = (i_value),\
+		.event = (i_event),\
+		.code = (i_code),\
+		.flags = (i_flags),\
+	}
+
+#define USAGE_BLOCK_NULL {}
+
+#define USAGE_PAGE_BLOCK(i_page, i_usage_blockes) \
+	{\
+		.page = (i_page),\
+		.usage_blockes = (i_usage_blockes),\
+	}
+
+#define USAGE_PAGE_BLOCK_NULL {}
+
+#define __SIMPLE_DRIVER_INIT \
+	.owner = THIS_MODULE,
+
+struct matched_device;
+
+struct hidinput_simple_driver {
+/* private */
+	struct list_head node; /* link with simple_drivers_list */
+	struct list_head raw_devices;
+	unsigned long flags;
+/* public for hid sub-layer, for example, USB. */
+	int (*match_device)(struct hidinput_simple_driver *drv,
+				struct matched_device *dev);
+/* public for drivers. */
+	struct module *owner;
+	char *name;
+	int (*connect)(struct hid_device *, struct hid_input *);	
+	void (*disconnect)(struct hid_device *, struct hid_input *);
+	void (*setup_usage)(struct hid_field *,   struct hid_usage *);
+	void (*clear_usage)(struct hid_field *,   struct hid_usage *);
+	int (*pre_event)(const struct hid_device *, const struct hid_field *,
+					const struct hid_usage *, const __s32);
+	int (*post_event)(const struct hid_device *, const struct hid_field *,
+					const struct hid_usage *, const __s32);
+	int (*open)(struct input_dev *);
+	void (*close)(struct input_dev *);
+	void *id_table;
+	struct usage_page_block *usage_page_table;
+	void *private;
+};
+
+int hidinput_register_simple_driver(struct hidinput_simple_driver *device);
+void hidinput_unregister_simple_driver(struct hidinput_simple_driver *device);
+struct hid_input* hidinput_simple_inputdev_to_hidinput(struct input_dev *dev);
+
+/********************* The public section end ***********/
+
+/***** The private section for simple device driver implement only *****/
+
+/* simple driver internal flags */
+#define HIDINPUT_SIMPLE_SETUP_USAGE	(0x0)
+#define HIDINPUT_SIMPLE_KEYBIT	(0x1)
+#define HIDINPUT_SIMPLE_RELBIT	(0x2)
+#define HIDINPUT_SIMPLE_ABSBIT	(0x3)
+#define HIDINPUT_SIMPLE_MSCBIT	(0x4)
+#define HIDINPUT_SIMPLE_SWBIT	(0x5)
+#define HIDINPUT_SIMPLE_LEDBIT	(0x6)
+#define HIDINPUT_SIMPLE_SNDBIT	(0x7)
+#define HIDINPUT_SIMPLE_FFBIT	(0x8)
+#define HIDINPUT_SIMPLE_FFSTSBIT	(0x9)
+
+/* used in hidinput_simple_driver_configure_usage() */
+#define __OP_SET_BIT (1)
+#define __OP_CLR_BIT (0)
+
+enum hid_simple_type {
+	HID_SIMPLE_NONE,
+	HID_SIMPLE_USB,
+	HID_SIMPLE_BLUETOOTH,	
+};
+
+struct hid_device;
+/* 
+ *  matched_device record one device which hid-subsystem will scan, it may 
+ *  be one simple device can not handle.
+ */
+struct matched_device {
+	enum hid_simple_type type;
+	void *id; /* device id, for example USB ID. */
+	struct hid_device *hid; /* if it's not zero, this device is matched with some simple driver. */
+	void *private; /* used in hid sub-layer */
+	struct list_head node;
+};
+
+#ifdef CONFIG_HID_SIMPLE
+extern void hidinput_simple_driver_configure_usage(struct hidinput_simple_driver *simple, struct hid_device *hid);
+extern int hidinput_simple_driver_init(struct hidinput_simple_driver *simple);
+extern void hidinput_simple_driver_clear(struct hidinput_simple_driver *simple);
+extern int hidinput_simple_driver_connect(struct hidinput_simple_driver *simple, 
+						struct matched_device *dev);
+extern void hidinput_simple_driver_disconnect(struct hid_device *hid, 
+						struct matched_device *dev);
+static inline void hidinput_lock_simple(struct hid_input *dev)
+{
+	while (!test_and_set_bit(0, &dev->input_lock))
+		schedule();
+}
+
+static inline int hidinput_trylock_simple(struct hid_input *dev)
+{
+	if (!test_and_set_bit(0, &dev->input_lock))
+		return 0;
+	return -EBUSY;
+}
+
+static inline void hidinput_unlock_simple(struct hid_input *dev)
+{
+	clear_bit(0, &dev->input_lock);
+}
+
+static inline int hidinput_simple_event_filter(struct hid_device *hid, 
+							struct hid_field *field,
+							struct hid_usage *usage,
+							__s32 value)
+{
+	int ret;
+
+	if (!hid->simple || !hid->simple->pre_event)
+		return (!0);
+	if (hidinput_trylock_simple(field->hidinput))
+		return 0;
+	ret = hid->simple->pre_event(hid, field, usage, value);
+	hidinput_unlock_simple(field->hidinput);
+	return ret;
+}
+
+static inline void hidinput_simple_event_post(struct hid_device *hid, 
+							struct hid_field *field,
+							struct hid_usage *usage,
+							__s32 value)
+{
+	if (!hid->simple || !hid->simple->post_event)
+		return;
+	if (hidinput_trylock_simple(field->hidinput))
+		return;
+	hid->simple->post_event(hid, field, usage, value);
+	hidinput_unlock_simple(field->hidinput);
+}
+
+static inline void hidinput_simple_driver_setup_usage(struct hidinput_simple_driver *simple, struct hid_device *hid)
+{
+	if (simple) {
+		set_bit(HIDINPUT_SIMPLE_SETUP_USAGE, &simple->flags);
+		hidinput_simple_driver_configure_usage(simple, hid);
+	}
+}
+
+static inline void hidinput_simple_driver_clear_usage(struct hidinput_simple_driver *simple, struct hid_device *hid)
+{
+	if (simple) {
+		clear_bit(HIDINPUT_SIMPLE_SETUP_USAGE, &simple->flags);
+		hidinput_simple_driver_configure_usage(simple, hid);
+	}
+}
+extern void hidinput_simple_driver_bind_foreach(void);
+extern void hidinput_simple_driver_bind_foreach_simple(
+					struct hid_device *hid,
+					struct matched_device *matched);
+extern void hidinput_simple_driver_bind_foreach_matched(
+				struct hidinput_simple_driver *simple);
+static inline struct matched_device* hidinput_simple_matched_device_new(void)
+{
+	struct matched_device *matched;
+
+	matched = kmalloc(sizeof(struct matched_device), GFP_KERNEL);
+	if (matched) {
+		matched->hid = NULL;
+		matched->type = HID_SIMPLE_NONE;
+	}
+	return matched;
+}
+extern int hidinput_register_simple_usb_driver(struct hidinput_simple_driver *simple);
+extern void hidinput_unregister_simple_usb_driver(struct hidinput_simple_driver *simple);
+#else /* CONFIG_HID_SIMPLE */
+static inline void hidinput_simple_driver_bind_foreach_simple(
+					struct hid_device *hid,
+					struct matched_device *matched) {}
+static inline void hidinput_simple_driver_configure_usage(struct hid_device *hid) {}
+static inline int hidinput_simple_driver_init
+		(struct hidinput_simple_driver *simple) {return 0;}
+static inline void hidinput_simple_driver_clear(
+				struct hidinput_simple_driver *simple) {}
+static inline int hidinput_simple_driver_connect(
+					struct hidinput_simple_driver *simple,
+						struct matched_device *dev)
+{
+	return 0;
+}
+static inline void hidinput_simple_driver_disconnect(struct hid_device *hid, 
+						struct matched_device *dev) {}
+static inline void hidinput_lock_simple(struct hid_input *dev) {}
+static inline int hidinput_trylock_simple(struct hid_input *dev) {return 0;}
+static inline void hidinput_unlock_simple(struct hid_input *dev) {}
+static inline int hidinput_simple_event_filter(struct hid_device *hid, 
+							struct hid_field *field,
+							struct hid_usage *usage,
+							__s32 value) { return 0; }
+static inline void hidinput_simple_event_post(struct hid_device *hid, 
+							struct hid_field *field,
+							struct hid_usage *usage,
+							__s32 value) {}
+static inline void hidinput_simple_driver_setup_usage(
+						struct hidinput_simple_driver *simple,
+							struct hid_device *hid) {}
+static inline void hidinput_simple_driver_clear_usage(struct hid_device *hid) {}
+static inline void hidinput_simple_driver_ff_init(struct input_dev *input_dev) {}
+static inline void hidinput_simple_driver_bind_foreach(void) {}
+static inline void hidinput_simple_driver_bind_foreach_matched(
+				struct hidinput_simple_driver *simple) {}
+static inline struct matched_device* hidinput_simple_matched_device_new(void)
+{
+	return NULL;
+}
+#endif
+/***** The private section end.  *****/
+#endif /* __KERNEL__ */
+#endif /* __HID_SIMPLE_H */
diff -Naurp linux-2.6.21-rc2.orig/drivers/hid/hid-core.c linux-2.6.21-rc2/drivers/hid/hid-core.c
--- linux-2.6.21-rc2.orig/drivers/hid/hid-core.c	2007-03-05 09:09:32.000000000 +0800
+++ linux-2.6.21-rc2/drivers/hid/hid-core.c	2007-03-05 11:17:26.000000000 +0800
@@ -26,8 +26,10 @@
 #include <asm/byteorder.h>
 #include <linux/input.h>
 #include <linux/wait.h>
+#include <linux/mutex.h>
 
 #include <linux/hid.h>
+#include <linux/hid-simple.h>
 #include <linux/hiddev.h>
 #include <linux/hid-debug.h>
 
@@ -41,6 +43,19 @@
 #define DRIVER_LICENSE "GPL"
 
 /*
+ * The global data structure for simple device driver interface.
+ */
+DEFINE_MUTEX(matched_devices_lock);
+DEFINE_MUTEX(simple_drivers_lock);
+LIST_HEAD(matched_devices_list);
+LIST_HEAD(simple_drivers_list);
+
+EXPORT_SYMBOL(matched_devices_lock);
+EXPORT_SYMBOL(simple_drivers_lock);
+EXPORT_SYMBOL(matched_devices_list);
+EXPORT_SYMBOL(simple_drivers_list);
+
+/*
  * Register a new report for a device.
  */
 
@@ -807,8 +822,12 @@ static __inline__ int search(__s32 *arra
 static void hid_process_event(struct hid_device *hid, struct hid_field *field, struct hid_usage *usage, __s32 value, int interrupt)
 {
 	hid_dump_input(usage, value);
-	if (hid->claimed & HID_CLAIMED_INPUT)
+	if (hid->claimed & HID_CLAIMED_INPUT) {
+		if (!hidinput_simple_event_filter(hid, field, usage, value))
+			return;
 		hidinput_hid_event(hid, field, usage, value);
+		hidinput_simple_event_post(hid, field, usage, value);
+	}
 	if (hid->claimed & HID_CLAIMED_HIDDEV && interrupt && hid->hiddev_hid_event)
 		hid->hiddev_hid_event(hid, field, usage, value);
 }
@@ -833,7 +852,6 @@ void hid_input_field(struct hid_device *
 		return;
 
 	for (n = 0; n < count; n++) {
-
 			value[n] = min < 0 ? snto32(extract(data, offset + n * size, size), size) :
 						    extract(data, offset + n * size, size);
 
@@ -993,5 +1011,136 @@ int hid_input_report(struct hid_device *
 }
 EXPORT_SYMBOL_GPL(hid_input_report);
 
+#ifdef CONFIG_HID_SIMPLE
+static int hidinput_simple_driver_bind_one(struct hidinput_simple_driver *simple,
+						struct hid_device *hid,
+						struct matched_device *matched,
+								int reload)
+{
+	int ret;
+
+	if (!try_module_get(simple->owner))
+		return -ENODEV;
+	/*
+	 * If the simple driver register itself after device insert,
+	 * we must send hotplug message to userspace again, elsewise,
+	 * we will break down some applications.
+	 */
+	if (reload && hidinput_disconnect_core(hid)) {
+		module_put(simple->owner);
+		return -ENODEV;
+	}
+	ret = hidinput_simple_driver_connect(simple, matched);
+
+	if (reload)
+		hidinput_reconnect_core(hid); /* To activate this input_dev */
+	if (!ret)
+		printk(KERN_INFO "The simple driver \'%s\' attach"
+			" to the device \'%s\'\n", simple->name, hid->name);
+	else
+		module_put(simple->owner);
+	return 0;
+}
+
+void hidinput_simple_driver_bind_foreach_simple(
+						struct hid_device *hid,
+					struct matched_device *matched)
+{
+	struct hidinput_simple_driver *simple;
+	struct list_head *node;
+	
+	if (!hid || !matched || !matched->id || matched->hid)
+		return;
+	mutex_lock(&simple_drivers_lock);
+	list_for_each(node, &simple_drivers_list) {
+		simple = list_entry(node, struct hidinput_simple_driver, node);
+		if (simple->match_device(simple, matched)) {
+			if (!hidinput_simple_driver_bind_one(simple, hid,
+								matched, 0))
+				break;
+		}
+	}
+	mutex_unlock(&simple_drivers_lock);
+}
+EXPORT_SYMBOL(hidinput_simple_driver_bind_foreach_simple);
+
+void hidinput_simple_driver_bind_foreach_matched(
+					struct hidinput_simple_driver *simple)
+{
+	struct list_head *node=NULL;
+	struct matched_device *matched;
+	struct hid_device *hid=NULL;
+
+	if (!simple)
+		return;
+
+	mutex_lock(&matched_devices_lock);
+	list_for_each(node, &matched_devices_list) {
+		matched = list_entry(node, struct matched_device, node);
+		hid = matched->hid;
+		if (!hid || hid->simple)
+			continue;
+		if (!simple->match_device(simple, matched))
+			continue;
+		if (!hidinput_simple_driver_bind_one(simple, hid, matched, 1))
+			break;
+	}
+	mutex_unlock(&matched_devices_lock);
+}
+
+void hidinput_simple_driver_bind_foreach(void)
+{
+	struct hidinput_simple_driver *simple;
+	struct matched_device *matched = NULL;
+	struct list_head *matched_node = NULL, *simple_node = NULL;
+	struct hid_device *hid = NULL;
+
+	mutex_lock(&matched_devices_lock);
+	list_for_each(matched_node, &matched_devices_list) {
+		matched = list_entry(matched_node, struct matched_device, node);
+		hid = matched->hid;
+		if (!hid || hid->simple)
+			continue;
+		mutex_lock(&simple_drivers_lock);
+		list_for_each(simple_node, &simple_drivers_list) {
+			simple = list_entry(simple_node, struct hidinput_simple_driver, node);
+			if (!simple->match_device(simple,matched))
+				continue;
+			hidinput_simple_driver_bind_one(simple, 
+							hid, matched, 1);
+		}
+		mutex_unlock(&simple_drivers_lock);
+	}
+	mutex_unlock(&matched_devices_lock);
+}
+
+int hidinput_register_simple_driver(struct hidinput_simple_driver *simple)
+{
+	if (!simple || !simple->name)
+		return -EINVAL;
+
+	hidinput_simple_driver_init(simple);
+	hidinput_simple_driver_bind_foreach_matched(simple);
+
+	mutex_lock(&simple_drivers_lock);
+	list_add(&simple->node, &simple_drivers_list);
+	mutex_unlock(&simple_drivers_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hidinput_register_simple_driver);
+
+void hidinput_unregister_simple_driver(struct hidinput_simple_driver *simple)
+{
+	hidinput_simple_driver_clear(simple);
+	mutex_lock(&simple_drivers_lock);
+	list_del(&simple->node);
+	mutex_unlock(&simple_drivers_lock);
+	/* to active simple device driver that it is waiting */
+	hidinput_simple_driver_bind_foreach();
+}
+EXPORT_SYMBOL_GPL(hidinput_unregister_simple_driver);
+#endif
+
 MODULE_LICENSE(DRIVER_LICENSE);
 
diff -Naurp linux-2.6.21-rc2.orig/drivers/hid/hid-input.c linux-2.6.21-rc2/drivers/hid/hid-input.c
--- linux-2.6.21-rc2.orig/drivers/hid/hid-input.c	2007-03-05 09:09:32.000000000 +0800
+++ linux-2.6.21-rc2/drivers/hid/hid-input.c	2007-03-05 11:17:26.000000000 +0800
@@ -30,8 +30,10 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/spinlock.h>
 
 #include <linux/hid.h>
+#include <linux/hid-simple.h>
 #include <linux/hid-debug.h>
 
 static int hid_pb_fnmode = 1;
@@ -65,6 +67,8 @@ static const struct {
 	__s32 y;
 }  hid_hat_to_axis[] = {{ 0, 0}, { 0,-1}, { 1,-1}, { 1, 0}, { 1, 1}, { 0, 1}, {-1, 1}, {-1, 0}, {-1,-1}};
 
+typedef void (*do_usage_t)(struct hid_field *, struct hid_usage *);
+
 #define map_abs(c)	do { usage->code = c; usage->type = EV_ABS; bit = input->absbit; max = ABS_MAX; } while (0)
 #define map_rel(c)	do { usage->code = c; usage->type = EV_REL; bit = input->relbit; max = REL_MAX; } while (0)
 #define map_key(c)	do { usage->code = c; usage->type = EV_KEY; bit = input->keybit; max = KEY_MAX; } while (0)
@@ -74,6 +78,15 @@ static const struct {
 #define map_rel_clear(c)	do { map_rel(c); clear_bit(c, bit); } while (0)
 #define map_key_clear(c)	do { map_key(c); clear_bit(c, bit); } while (0)
 
+static inline void hidinput_send_event(struct hid_input *hidinput, int type,
+							int code, int value)
+{
+	if (!hidinput_trylock_simple(hidinput)) {
+		input_event(hidinput->input, type, code, value);
+		hidinput_unlock_simple(hidinput);
+	}
+}
+
 #ifdef CONFIG_USB_HIDINPUT_POWERBOOK
 
 struct hidinput_key_translation {
@@ -144,7 +157,7 @@ static struct hidinput_key_translation *
 	return NULL;
 }
 
-static int hidinput_pb_event(struct hid_device *hid, struct input_dev *input,
+static int hidinput_pb_event(struct hid_device *hid, struct hid_input *hidinput,
 		struct hid_usage *usage, __s32 value)
 {
 	struct hidinput_key_translation *trans;
@@ -153,7 +166,7 @@ static int hidinput_pb_event(struct hid_
 		if (value) hid->quirks |=  HID_QUIRK_POWERBOOK_FN_ON;
 		else       hid->quirks &= ~HID_QUIRK_POWERBOOK_FN_ON;
 
-		input_event(input, usage->type, usage->code, value);
+		hidinput_send_event(hidinput, usage->type, usage->code, value);
 
 		return 1;
 	}
@@ -178,14 +191,16 @@ static int hidinput_pb_event(struct hid_
 				else
 					clear_bit(usage->code, hid->pb_pressed_fn);
 
-				input_event(input, usage->type, trans->to, value);
+				hidinput_send_event(hidinput, usage->type, trans->to, value);
 
 				return 1;
 			}
 		}
 
+		if (hidinput_trylock_simple(hidinput))
+			return 0;
 		if (test_bit(usage->code, hid->pb_pressed_numlock) ||
-				test_bit(LED_NUML, input->led)) {
+				test_bit(LED_NUML, hidinput->input->led)) {
 			trans = find_translation(powerbook_numlock_keys, usage->code);
 
 			if (trans) {
@@ -194,17 +209,18 @@ static int hidinput_pb_event(struct hid_
 				else
 					clear_bit(usage->code, hid->pb_pressed_numlock);
 
-				input_event(input, usage->type, trans->to, value);
+				input_event(hidinput->input, usage->type, trans->to, value);
 			}
-
+			hidinput_unlock_simple(hidinput);
 			return 1;
 		}
+		hidinput_unlock_simple(hidinput);
 	}
 
 	if (hid->quirks & HID_QUIRK_POWERBOOK_ISO_KEYBOARD) {
 		trans = find_translation(powerbook_iso_keyboard, usage->code);
 		if (trans) {
-			input_event(input, usage->type, trans->to, value);
+			input_event(hidinput->input, usage->type, trans->to, value);
 			return 1;
 		}
 	}
@@ -230,7 +246,7 @@ static void hidinput_pb_setup(struct inp
 
 }
 #else
-static inline int hidinput_pb_event(struct hid_device *hid, struct input_dev *input,
+static int hidinput_pb_event(struct hid_device *hid, struct hid_input *hidinput,
 		struct hid_usage *usage, __s32 value)
 {
 	return 0;
@@ -241,16 +257,13 @@ static inline void hidinput_pb_setup(str
 }
 #endif
 
-static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_field *field,
+static void hidinput_configure_usage(struct input_dev *input, struct hid_field *field,
 				     struct hid_usage *usage)
 {
-	struct input_dev *input = hidinput->input;
 	struct hid_device *device = input->private;
 	int max = 0, code;
 	unsigned long *bit = NULL;
 
-	field->hidinput = hidinput;
-
 #ifdef CONFIG_HID_DEBUG
 	printk(KERN_DEBUG "Mapping: ");
 	hid_resolv_usage(usage->hid);
@@ -274,7 +287,6 @@ static void hidinput_configure_usage(str
 				map_key_clear(hid_keyboard[usage->hid & HID_USAGE]);
 			} else
 				map_key(KEY_UNKNOWN);
-
 			break;
 
 		case HID_UP_BUTTON:
@@ -696,6 +708,7 @@ ignore:
 
 void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct hid_usage *usage, __s32 value)
 {
+	struct hid_input *hidinput;
 	struct input_dev *input;
 	int *quirks = &hid->quirks;
 
@@ -707,6 +720,8 @@ void hidinput_hid_event(struct hid_devic
 	if (!usage->type)
 		return;
 
+	hidinput = field->hidinput;
+
 	if (((hid->quirks & HID_QUIRK_2WHEEL_MOUSE_HACK_5) && (usage->hid == 0x00090005))
 		|| ((hid->quirks & HID_QUIRK_2WHEEL_MOUSE_HACK_7) && (usage->hid == 0x00090007))) {
 		if (value) hid->quirks |=  HID_QUIRK_2WHEEL_MOUSE_HACK_ON;
@@ -715,16 +730,16 @@ void hidinput_hid_event(struct hid_devic
 	}
 
 	if ((hid->quirks & HID_QUIRK_INVERT_HWHEEL) && (usage->code == REL_HWHEEL)) {
-		input_event(input, usage->type, usage->code, -value);
+		hidinput_send_event(hidinput, usage->type, usage->code, -value);
 		return;
 	}
 
 	if ((hid->quirks & HID_QUIRK_2WHEEL_MOUSE_HACK_ON) && (usage->code == REL_WHEEL)) {
-		input_event(input, usage->type, REL_HWHEEL, value);
+		hidinput_send_event(hidinput, usage->type, REL_HWHEEL, value);
 		return;
 	}
 
-	if ((hid->quirks & HID_QUIRK_POWERBOOK_HAS_FN) && hidinput_pb_event(hid, input, usage, value))
+	if ((hid->quirks & HID_QUIRK_POWERBOOK_HAS_FN) && hidinput_pb_event(hid, hidinput, usage, value))
 		return;
 
 	if (usage->hat_min < usage->hat_max || usage->hat_dir) {
@@ -732,8 +747,8 @@ void hidinput_hid_event(struct hid_devic
 		if (!hat_dir)
 			hat_dir = (value - usage->hat_min) * 8 / (usage->hat_max - usage->hat_min + 1) + 1;
 		if (hat_dir < 0 || hat_dir > 8) hat_dir = 0;
-		input_event(input, usage->type, usage->code    , hid_hat_to_axis[hat_dir].x);
-                input_event(input, usage->type, usage->code + 1, hid_hat_to_axis[hat_dir].y);
+		hidinput_send_event(hidinput, usage->type, usage->code, hid_hat_to_axis[hat_dir].x);
+		hidinput_send_event(hidinput, usage->type, usage->code + 1, hid_hat_to_axis[hat_dir].y);
                 return;
         }
 
@@ -744,18 +759,18 @@ void hidinput_hid_event(struct hid_devic
 
 	if (usage->hid == (HID_UP_DIGITIZER | 0x0032)) { /* InRange */
 		if (value) {
-			input_event(input, usage->type, (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code, 1);
+			hidinput_send_event(hidinput, usage->type, (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code, 1);
 			return;
 		}
-		input_event(input, usage->type, usage->code, 0);
-		input_event(input, usage->type, BTN_TOOL_RUBBER, 0);
+		hidinput_send_event(hidinput, usage->type, usage->code, 0);
+		hidinput_send_event(hidinput, usage->type, BTN_TOOL_RUBBER, 0);
 		return;
 	}
 
 	if (usage->hid == (HID_UP_DIGITIZER | 0x0030) && (*quirks & HID_QUIRK_NOTOUCH)) { /* Pressure */
 		int a = field->logical_minimum;
 		int b = field->logical_maximum;
-		input_event(input, EV_KEY, BTN_TOUCH, value > a + ((b - a) >> 3));
+		hidinput_send_event(hidinput, EV_KEY, BTN_TOUCH, value > a + ((b - a) >> 3));
 	}
 
 	if (usage->hid == (HID_UP_PID | 0x83UL)) { /* Simultaneous Effects Max */
@@ -771,18 +786,22 @@ void hidinput_hid_event(struct hid_devic
 	if ((usage->type == EV_KEY) && (usage->code == 0)) /* Key 0 is "unassigned", not KEY_UNKNOWN */
 		return;
 
-	input_event(input, usage->type, usage->code, value);
+	hidinput_send_event(hidinput, usage->type, usage->code, value);
 
 	if ((field->flags & HID_MAIN_ITEM_RELATIVE) && (usage->type == EV_KEY))
-		input_event(input, usage->type, usage->code, 0);
+		hidinput_send_event(hidinput, usage->type, usage->code, 0);
 }
 
 void hidinput_report_event(struct hid_device *hid, struct hid_report *report)
 {
 	struct hid_input *hidinput;
 
-	list_for_each_entry(hidinput, &hid->inputs, list)
+	list_for_each_entry(hidinput, &hid->inputs, list) {
+		if (hidinput_trylock_simple(hidinput))
+			continue;
 		input_sync(hidinput->input);
+		hidinput_unlock_simple(hidinput);
+	}
 }
 EXPORT_SYMBOL_GPL(hidinput_report_event);
 
@@ -806,13 +825,46 @@ EXPORT_SYMBOL_GPL(hidinput_find_field);
 static int hidinput_open(struct input_dev *dev)
 {
 	struct hid_device *hid = dev->private;
-	return hid->hid_open(hid);
+	int ret = 0;
+
+	if (hid && hid->simple && hid->simple->open)
+		ret = hid->simple->open(dev);
+	else
+		ret = hid->hid_open(hid);
+	return ret;
 }
 
 static void hidinput_close(struct input_dev *dev)
 {
 	struct hid_device *hid = dev->private;
-	hid->hid_close(hid);
+
+	if (hid && hid->simple && hid->simple->close)
+		hid->simple->close(dev);
+	else
+		hid->hid_close(hid);
+}
+
+static void hidinput_input_init(struct hid_device *hid,
+				struct input_dev *input_dev)
+{
+	if (!hid || !input_dev)
+		return;
+
+	input_dev->private = hid;
+	input_dev->event = hid->hidinput_input_event;
+	input_dev->open = hidinput_open;
+	input_dev->close = hidinput_close;
+
+	input_dev->name = hid->name;
+	input_dev->phys = hid->phys;
+	input_dev->uniq = hid->uniq;
+	input_dev->id.bustype = hid->bus;
+	input_dev->id.vendor = hid->vendor;
+	input_dev->id.product = hid->product;
+	input_dev->id.version = hid->version;
+	input_dev->cdev.dev = hid->dev;
+
+	return;
 }
 
 /*
@@ -859,27 +911,18 @@ int hidinput_connect(struct hid_device *
 					return -1;
 				}
 
-				input_dev->private = hid;
-				input_dev->event = hid->hidinput_input_event;
-				input_dev->open = hidinput_open;
-				input_dev->close = hidinput_close;
-
-				input_dev->name = hid->name;
-				input_dev->phys = hid->phys;
-				input_dev->uniq = hid->uniq;
-				input_dev->id.bustype = hid->bus;
-				input_dev->id.vendor  = hid->vendor;
-				input_dev->id.product = hid->product;
-				input_dev->id.version = hid->version;
-				input_dev->cdev.dev = hid->dev;
+				hidinput_input_init(hid, input_dev);
+				hidinput->input_lock = 0;				
 				hidinput->input = input_dev;
 				list_add_tail(&hidinput->list, &hid->inputs);
 			}
 
-			for (i = 0; i < report->maxfield; i++)
+			for (i = 0; i < report->maxfield; i++) {
+				report->field[i]->hidinput = hidinput;
 				for (j = 0; j < report->field[i]->maxusage; j++)
-					hidinput_configure_usage(hidinput, report->field[i],
+					hidinput_configure_usage(hidinput->input, report->field[i],
 								 report->field[i]->usage + j);
+			}
 
 			if (hid->quirks & HID_QUIRK_MULTI_INPUT) {
 				/* This will leave hidinput NULL, so that it
@@ -900,6 +943,78 @@ int hidinput_connect(struct hid_device *
 }
 EXPORT_SYMBOL_GPL(hidinput_connect);
 
+static void hidinput_setup_usage(struct hid_device *hid, 
+					struct input_dev *input)
+{
+	struct hid_report *report;
+	int i, j, k;
+
+	for (i = 0; i < hid->maxcollection; i++)
+		if (hid->collection[i].type == HID_COLLECTION_APPLICATION ||
+		    hid->collection[i].type == HID_COLLECTION_PHYSICAL)
+			if (IS_INPUT_APPLICATION(hid->collection[i].usage))
+				break;
+
+	if (i == hid->maxcollection)
+		return;
+
+	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++)
+		list_for_each_entry(report, &hid->report_enum[k].report_list, list) {
+			if (!report->maxfield)
+				continue;
+			for (i = 0; i < report->maxfield; i++)
+				for (j = 0; j < report->field[i]->maxusage; j++)
+					hidinput_configure_usage(input, report->field[i],
+								 report->field[i]->usage + j);
+		}
+	return;
+}
+
+/*
+ *  The caller must be call hidinput_reconnect() soon, 
+ *  this function hold hidinput->input_lock.
+ */
+int hidinput_disconnect_core(struct hid_device *hid)
+{
+	struct hid_input *hidinput, *next;
+	struct input_dev *input_dev = NULL;
+	struct list_head tmp_list;
+
+	INIT_LIST_HEAD(&tmp_list);
+	list_for_each_entry_safe(hidinput, next, &hid->inputs, list) {
+		input_dev = input_allocate_device();
+		if (!input_dev)
+			break;
+		list_add_tail(&input_dev->node, &tmp_list);
+	}
+	while (!list_empty(&tmp_list)) {
+		list_del_init(tmp_list.next);
+	}
+	if (!input_dev)
+		return -ENOMEM;
+	list_for_each_entry_safe(hidinput, next, &hid->inputs, list) {
+		hidinput_input_init(hid, input_dev);
+		hidinput_lock_simple(hidinput);
+		input_unregister_device(hidinput->input);
+		hidinput->input = input_dev;
+		if (!(hid->quirks&HID_QUIRK_MULTI_INPUT))
+			hid_ff_init(hid);
+	}
+	return 0;
+}
+
+void hidinput_reconnect_core(struct hid_device *hid)
+{
+	struct hid_input *hidinput, *next;
+
+	list_for_each_entry_safe(hidinput, next, &hid->inputs, list) {
+		hidinput_setup_usage(hid, hidinput->input);
+		hidinput_simple_driver_setup_usage(hid->simple, hid);
+		input_register_device(hidinput->input);
+		hidinput_unlock_simple(hidinput);
+	}
+}
+
 void hidinput_disconnect(struct hid_device *hid)
 {
 	struct hid_input *hidinput, *next;
diff -Naurp linux-2.6.21-rc2.orig/drivers/hid/hid-simple.c linux-2.6.21-rc2/drivers/hid/hid-simple.c
--- linux-2.6.21-rc2.orig/drivers/hid/hid-simple.c	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6.21-rc2/drivers/hid/hid-simple.c	2007-03-05 11:17:26.000000000 +0800
@@ -0,0 +1,334 @@
+/*
+ *  HID Simple Driver Interface v0.5.0
+ * 
+ *  Copyright (c) 2006 Li Yu <raise.sail@gmail.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so either by
+ * e-mail - mail your message to <vojtech@ucw.cz>, or by paper mail:
+ * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/input.h>
+
+#include <linux/hid.h>
+#include <linux/hid-simple.h>
+
+/* 
+ *  raw_simple_driver record one device which hid simple device handle.
+ *  It used as one member of hid_simple_driver.
+ */ 
+
+struct raw_simple_device {
+	struct hid_device *hid;
+	struct list_head node;
+};
+
+typedef void (*do_usage_t)(struct hid_field *, struct hid_usage *);
+
+int hidinput_simple_driver_init(struct hidinput_simple_driver *simple)
+{
+	if (unlikely(!simple))
+		return -EINVAL;
+	INIT_LIST_HEAD(&simple->node);
+	INIT_LIST_HEAD(&simple->raw_devices);
+	simple->flags = 0;
+	return 0;
+}
+
+static void inline hidinput_simple_configure_one_usage(int op, 
+						struct input_dev *input,
+						struct hid_usage *usage,
+						struct usage_block *usage_block)
+{
+	unsigned long *bits;
+	int flag;
+	struct hid_device *hid;
+
+	hid = input->private;
+	switch (usage_block->event) {
+	case EV_KEY:
+		flag = HIDINPUT_SIMPLE_KEYBIT;
+		bits = input->keybit;
+		break;
+	case EV_REL:
+		flag = HIDINPUT_SIMPLE_RELBIT;
+		bits = input->relbit;
+		break;
+	case EV_ABS:
+		flag = HIDINPUT_SIMPLE_ABSBIT;
+		bits = input->relbit;
+		break;
+	case EV_MSC:
+		flag = HIDINPUT_SIMPLE_MSCBIT;
+		bits = input->absbit;
+		break;
+	case EV_SW:
+		flag = HIDINPUT_SIMPLE_SWBIT;
+		bits = input->swbit;
+		break;
+	case EV_LED:
+		flag = HIDINPUT_SIMPLE_LEDBIT;
+		bits = input->ledbit;
+		break;
+	case EV_SND:
+		flag = HIDINPUT_SIMPLE_SNDBIT;
+		bits = input->sndbit;
+		break;
+	case EV_FF:
+		flag = HIDINPUT_SIMPLE_FFBIT;
+		bits = input->ffbit;
+		break;
+	case EV_FF_STATUS:
+		flag = HIDINPUT_SIMPLE_FFSTSBIT;
+		bits = NULL;
+		break;
+	default:
+		return;
+	}
+
+	if (__OP_SET_BIT == op) {
+		usage->code = usage_block->code;
+		usage->type = usage_block->event;
+		if (bits)
+			set_bit(usage_block->code, bits);
+		/* if this event bit is set by us first, remember it */
+		if (!test_and_set_bit(usage_block->event, input->evbit))
+			set_bit(flag, &hid->simple->flags);
+	}
+	else if (__OP_CLR_BIT == op) {
+		usage->code = 0;
+		usage->type = 0;
+		if (bits)
+			clear_bit(usage_block->code, bits);
+		/* clear event bit, only if it's set by us. */
+		if (test_and_clear_bit(flag, &hid->simple->flags))
+			clear_bit(usage_block->event, input->evbit);
+	}
+}
+
+static do_usage_t hidinput_simple_driver_configure_usage_prep(
+					struct hidinput_simple_driver *simple,
+							int *op)
+{
+	do_usage_t do_usage;
+
+	if (test_bit(HIDINPUT_SIMPLE_SETUP_USAGE, &simple->flags)) {
+		do_usage = simple->setup_usage;
+		*op = __OP_SET_BIT;
+	}
+	else {
+		do_usage = simple->clear_usage;
+		*op = __OP_CLR_BIT;
+	}
+	return do_usage;
+}
+
+static void __hidinput_simple_driver_configure_usage(
+					struct hidinput_simple_driver *simple,
+						int op,
+						struct hid_field *field,
+						struct hid_usage *hid_usage)
+{
+	struct input_dev *input = field->hidinput->input;
+	struct usage_block *usage_block;
+	struct usage_page_block *page_block;
+	int page;
+	int usage;
+
+	page = (hid_usage->hid & HID_USAGE_PAGE);
+	usage = (hid_usage->hid & HID_USAGE);
+	page_block = simple->usage_page_table;
+	for (;page_block && page_block->usage_blockes;page_block++) {
+		if (page_block->page != page)
+			continue;
+		usage_block = page_block->usage_blockes;
+		for (; usage_block && usage_block->usage; usage_block++) {
+			if (usage_block->usage != usage)
+				continue;
+			hidinput_simple_configure_one_usage(op, input, 
+						hid_usage, usage_block);
+		}
+	}
+}
+
+/*
+ *  To give one simple device a configure usage chance.
+ *  The framework of this function come from hidinput_connect()
+ */
+void hidinput_simple_driver_configure_usage(struct hidinput_simple_driver *simple, 							struct hid_device *hid)
+{
+	struct hid_report *report;
+	int i, j, k;
+	do_usage_t do_usage;
+	int op;
+
+	if (!simple)
+		return;
+	do_usage = hidinput_simple_driver_configure_usage_prep(simple, &op);
+
+	for (i = 0; i < hid->maxcollection; i++)
+		if (hid->collection[i].type == HID_COLLECTION_APPLICATION ||
+			hid->collection[i].type==HID_COLLECTION_PHYSICAL)
+			if (IS_INPUT_APPLICATION(hid->collection[i].usage))
+				break;
+
+	if (i == hid->maxcollection)
+		return;
+
+	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++)
+		list_for_each_entry(report, &hid->report_enum[k].report_list, list) {
+			if (!report->maxfield)
+				continue;
+
+			for (i = 0; i < report->maxfield; i++)
+				for (j = 0; j < report->field[i]->maxusage; j++) {
+					__hidinput_simple_driver_configure_usage(simple, op, report->field[i], report->field[i]->usage + j);
+					if (do_usage)
+						do_usage(report->field[i],
+						report->field[i]->usage + j);
+				}
+		}
+
+	return;
+}
+
+static int hidinput_simple_driver_push(struct hidinput_simple_driver *simple,
+					struct matched_device *matched)
+{
+	struct raw_simple_device *raw_simple;
+
+	raw_simple = kmalloc(sizeof(struct raw_simple_device), GFP_KERNEL);
+	if (!raw_simple)
+		return -ENOMEM;
+	matched->hid->simple = simple;
+	raw_simple->hid = matched->hid;
+	list_add(&raw_simple->node, &simple->raw_devices);
+	return 0;
+}
+
+static void hidinput_simple_driver_pop(struct hid_device *hid, struct matched_device *matched)
+{
+	struct list_head *node;
+	struct raw_simple_device *raw_simple=NULL;
+
+	list_for_each (node, &hid->simple->raw_devices) {
+		raw_simple = list_entry(node, struct raw_simple_device, node);
+		if (raw_simple && raw_simple->hid == hid) {
+			hid->simple = NULL;
+			list_del(&raw_simple->node);
+			raw_simple->hid = NULL;
+			kfree(raw_simple);
+			return;
+		}
+	}
+}
+
+void hidinput_simple_driver_clear(struct hidinput_simple_driver *simple)
+{
+	struct raw_simple_device *raw_simple;
+	struct hid_device *hid;
+
+	while (!list_empty_careful(&simple->raw_devices)) {
+		raw_simple = list_entry(simple->raw_devices.next, 
+					struct raw_simple_device, node);
+		hid = raw_simple->hid;
+		if (hid) {
+			if (hid->simple)
+				BUG_ON(hid->simple != simple);
+			hidinput_simple_driver_disconnect(hid, NULL);
+			hidinput_disconnect_core(hid);
+			hidinput_reconnect_core(hid);
+			hid->simple = NULL;
+		}
+		list_del_init(simple->raw_devices.next);
+		raw_simple->hid = NULL;
+		kfree(raw_simple);
+	}
+}
+
+int hidinput_simple_driver_connect(struct hidinput_simple_driver *simple, 
+						struct matched_device *matched)
+{
+	struct hid_input *hidinput, *next;
+	int ret = -ENODEV;
+
+	if (!simple || !matched || !matched->hid)
+		return -EINVAL;
+
+	if (!simple->connect) {
+		ret = 0;
+		goto exit;
+	}
+	list_for_each_entry_safe(hidinput, next, &matched->hid->inputs, list) {
+		if (!simple->connect(matched->hid, hidinput))
+			ret = 0;
+	}
+exit:
+	matched->hid->simple = simple;
+	hidinput_simple_driver_setup_usage(simple, matched->hid);
+	/* One simple driver may handle more devices */
+	if (hidinput_simple_driver_push(simple, matched)) {
+		hidinput_simple_driver_disconnect(matched->hid, NULL);
+		return -ENODEV;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(hidinput_simple_driver_connect);
+
+void hidinput_simple_driver_disconnect(struct hid_device *hid, 
+						struct matched_device *matched)
+{
+	struct hid_input *hidinput, *next;
+
+	if (!hid || !hid->simple)
+		return;
+	if (!hid->simple->disconnect)
+		goto exit;
+
+	hidinput_simple_driver_clear_usage(hid->simple, hid);
+	wmb();
+	list_for_each_entry_safe(hidinput, next, &hid->inputs, list) {
+		hid->simple->disconnect(hid, hidinput);
+	}
+exit:
+	if (matched)
+		hidinput_simple_driver_pop(hid, matched);
+	return;
+}
+EXPORT_SYMBOL(hidinput_simple_driver_disconnect);
+
+struct hid_input* hidinput_simple_inputdev_to_hidinput(struct input_dev *dev)
+{
+	struct hid_device *hid = dev->private;
+	struct list_head *iter;
+	struct hid_input *hidinput;
+
+	if (!hid)
+		return NULL;
+	list_for_each(iter, &hid->inputs) {
+		hidinput = list_entry(iter, struct hid_input, list);
+		if (hidinput->input == dev)
+			return hidinput;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(hidinput_simple_inputdev_to_hidinput);
diff -Naurp linux-2.6.21-rc2.orig/drivers/hid/Kconfig linux-2.6.21-rc2/drivers/hid/Kconfig
--- linux-2.6.21-rc2.orig/drivers/hid/Kconfig	2007-03-05 09:09:32.000000000 +0800
+++ linux-2.6.21-rc2/drivers/hid/Kconfig	2007-03-05 11:17:26.000000000 +0800
@@ -36,5 +36,13 @@ config HID_DEBUG
 
 	If unsure, say N
 
+config HID_SIMPLE
+        bool "HID simple driver interface"
+        depends on HID
+        help
+          This simple interface let the writing HID driver more easier. Moreover,
+          this allow you write force-feedback driver without touch HID input
+          implementation code. Also, it can be used as input filter.
+
 endmenu
 
diff -Naurp linux-2.6.21-rc2.orig/drivers/hid/Makefile linux-2.6.21-rc2/drivers/hid/Makefile
--- linux-2.6.21-rc2.orig/drivers/hid/Makefile	2007-03-05 09:09:32.000000000 +0800
+++ linux-2.6.21-rc2/drivers/hid/Makefile	2007-03-05 11:17:26.000000000 +0800
@@ -3,6 +3,10 @@
 #
 hid-objs			:= hid-core.o hid-input.o
 
+ifeq ($(CONFIG_HID_SIMPLE),y)
+hid-objs     += hid-simple.o
+endif
+
 obj-$(CONFIG_HID)		+= hid.o
 hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 
diff -Naurp linux-2.6.21-rc2.orig/drivers/usb/input/hid-core.c linux-2.6.21-rc2/drivers/usb/input/hid-core.c
--- linux-2.6.21-rc2.orig/drivers/usb/input/hid-core.c	2007-03-05 09:09:34.000000000 +0800
+++ linux-2.6.21-rc2/drivers/usb/input/hid-core.c	2007-03-05 13:40:58.000000000 +0800
@@ -33,6 +33,7 @@
 #include <linux/usb.h>
 
 #include <linux/hid.h>
+#include <linux/hid-simple.h>
 #include <linux/hiddev.h>
 #include <linux/hid-debug.h>
 #include "usbhid.h"
@@ -1286,8 +1287,30 @@ static void hid_disconnect(struct usb_in
 	del_timer_sync(&usbhid->io_retry);
 	flush_scheduled_work();
 
-	if (hid->claimed & HID_CLAIMED_INPUT)
+	if (hid->claimed & HID_CLAIMED_INPUT) {
+		struct list_head *node;
+		struct matched_device *matched = NULL;
+		struct hidinput_simple_driver *simple = hid->simple;
+
+		mutex_lock(&matched_devices_lock);
+		list_for_each(node, &matched_devices_list) {
+			matched = list_entry(node, struct matched_device, node);
+			if (matched->private == intf) {
+				list_del(&matched->node);
+				break;
+			}
+			matched = NULL;
+		}
+		mutex_unlock(&matched_devices_lock);
+		/* disconnect simple device driver if need */
+		if (matched && simple) {
+			hidinput_simple_driver_disconnect(hid, matched);
+			module_put(simple->owner);
+		}
+		if (matched)
+			kfree(matched);
 		hidinput_disconnect(hid);
+	}
 	if (hid->claimed & HID_CLAIMED_HIDDEV)
 		hiddev_disconnect(hid);
 
@@ -1315,15 +1338,30 @@ static int hid_probe(struct usb_interfac
 	usbhid_init_reports(hid);
 	hid_dump_device(hid);
 
-	if (!hidinput_connect(hid))
+	usb_set_intfdata(intf, hid);
+
+	if (!hidinput_connect(hid)) {
+		struct matched_device *matched;
+		matched = hidinput_simple_matched_device_new();
+		if (matched) {
+			matched->type = HID_SIMPLE_USB;
+			matched->id = (void*)id;
+			matched->private = intf;
+			matched->hid = hid;
+			mutex_lock(&matched_devices_lock);
+			list_add(&matched->node, &matched_devices_list);
+			mutex_unlock(&matched_devices_lock);
+			hidinput_simple_driver_bind_foreach_simple(hid, matched);
+		}
 		hid->claimed |= HID_CLAIMED_INPUT;
+	}
 	if (!hiddev_connect(hid))
 		hid->claimed |= HID_CLAIMED_HIDDEV;
 
 	usb_set_intfdata(intf, hid);
 
 	if (!hid->claimed) {
-		printk ("HID device not claimed by input or hiddev\n");
+		printk (KERN_INFO"HID device not claimed by input or hiddev\n");
 		hid_disconnect(intf);
 		return -ENODEV;
 	}
@@ -1404,8 +1442,37 @@ static void hid_post_reset(struct usb_in
 	/* FIXME: Any more reinitialization needed? */
 
 	hid_resume(intf);
+
 }
 
+#ifdef CONFIG_HID_SIMPLE
+/* return non-zero mean these two paramenters can be buddy :) */
+static int hidinput_match_simple(
+				struct hidinput_simple_driver *drv,
+					struct matched_device *dev)
+{
+	if (!dev || !drv || HID_SIMPLE_USB != dev->type || !dev->private) {
+		return 0;
+	}
+	return (int)usb_match_id(dev->private, drv->id_table);
+}
+
+int hidinput_register_simple_usb_driver(struct hidinput_simple_driver *simple)
+{
+	if (!simple)
+		return -ENODEV;
+	simple->match_device = hidinput_match_simple;
+	return hidinput_register_simple_driver(simple);
+}
+EXPORT_SYMBOL_GPL(hidinput_register_simple_usb_driver);
+
+void hidinput_unregister_simple_usb_driver(struct hidinput_simple_driver *simple)
+{
+	hidinput_unregister_simple_driver(simple);
+}
+EXPORT_SYMBOL_GPL(hidinput_unregister_simple_usb_driver);
+#endif
+
 static struct usb_device_id hid_usb_ids [] = {
 	{ .match_flags = USB_DEVICE_ID_MATCH_INT_CLASS,
 		.bInterfaceClass = USB_INTERFACE_CLASS_HID },
@@ -1445,7 +1512,17 @@ hiddev_init_fail:
 
 static void __exit hid_exit(void)
 {
+	struct list_head *node, *tmp;
+	struct matched_device *matched;
+
 	usb_deregister(&hid_driver);
+	list_for_each_safe(node, tmp, &matched_devices_list) {
+		matched = list_entry(node, struct matched_device, node);
+		if (HID_SIMPLE_USB == matched->type) {
+			list_del(&matched->node);
+			kfree(matched);
+		}
+	}	
 	hiddev_exit();
 }
 

