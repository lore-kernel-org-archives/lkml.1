Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYK1RUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYK1RUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 12:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYK1RUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 12:20:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52010 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYK1RT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 12:19:59 -0500
Date: Fri, 28 Nov 2008 17:19:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Perzynski <daniel.perzynski@gmail.com>
Cc: linux-kernel@vger.kernel.org, linu-acpi@vger.kernel.org
Subject: Re: HP WMI laptop extras driver
Message-ID: <20081128171954.GA7719@srcf.ucam.org>
References: <28f715610811221343s67ed9901nc80618774fcbdcf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f715610811221343s67ed9901nc80618774fcbdcf8@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you apply the attached patch, build the quickstart driver, load it 
and tell me what messages you get from the quickstart keys on your 
device?

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index b0243fd..94460ea 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -400,4 +400,11 @@ config ACPI_SBS
 	  This driver adds support for the Smart Battery System, another
 	  type of access to battery information, found on some laptops.
 
+config ACPI_QUICKSTART
+       tristate "ACPI Application Quickstart Keys"
+       depends on INPUT
+       help
+         This driver adds support for the PNP0C32 application start keys
+	 found on some laptops.
+
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 3c0c933..898ca7b 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -66,3 +66,4 @@ obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= acpi_memhotplug.o
 obj-$(CONFIG_ACPI_PROCFS_POWER)	+= cm_sbs.o
 obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
+obj-$(CONFIG_ACPI_QUICKSTART)	+= quickstart.o
diff --git a/drivers/acpi/quickstart.c b/drivers/acpi/quickstart.c
new file mode 100644
index 0000000..2abbeb0
--- /dev/null
+++ b/drivers/acpi/quickstart.c
@@ -0,0 +1,507 @@
+/*
+ *  quickstart.c - ACPI Direct App Launch driver
+ *
+ *  Copyright (C) 2007 Angelo Arrifano <miknix@gmail.com>
+ *
+ *  Information gathered from disassebled dsdt and from here:
+ *  "http://download.microsoft.com/download/9/c/5/
+ *  9c5b2167-8017-4bae-9fde-d599bac8184a/DirAppLaunch_Vista.doc"
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#define QUICKSTART_VERSION "1.00"
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+
+MODULE_AUTHOR("Angelo Arrifano");
+MODULE_DESCRIPTION("ACPI Direct App Launch driver");
+MODULE_LICENSE("GPL");
+
+#define QUICKSTART_ACPI_DEVICE_NAME   "quickstart"
+#define QUICKSTART_ACPI_CLASS         "quickstart"
+#define QUICKSTART_ACPI_HID           "PNP0C32"
+
+#define QUICKSTART_PF_DRIVER_NAME     "quickstart"
+#define QUICKSTART_PF_DEVICE_NAME     "quickstart"
+#define QUICKSTART_PF_DEVATTR_NAME    "pressed_button"
+
+#define QUICKSTART_MAX_BTN_NAME_LEN   16
+
+struct quickstart_btn_list {
+	char *name;
+	struct quickstart_btn_list *next;
+};
+
+static struct quickstart_driver_data {
+	struct quickstart_btn_list *btn_lst;
+	struct quickstart_btn_list *pressed;
+} quickstart_data = {
+.btn_lst = NULL,.pressed = NULL,};
+
+static struct input_dev *quickstart_input_dev;
+
+/*
+ * ACPI driver Structs
+ */
+
+struct quickstart_acpi {
+	struct acpi_device *device;
+	struct quickstart_btn_list *btn;
+};
+static int quickstart_acpi_add(struct acpi_device *device);
+static int quickstart_acpi_remove(struct acpi_device *device, int type);
+static const struct acpi_device_id quickstart_device_ids[] = {
+	{QUICKSTART_ACPI_HID, 0},
+	{"", 0},
+};
+
+static struct acpi_driver quickstart_acpi_driver = {
+	.name = "quickstart",
+	.class = QUICKSTART_ACPI_CLASS,
+	.ids = quickstart_device_ids,
+	.ops = {
+		.add = quickstart_acpi_add,
+		.remove = quickstart_acpi_remove,
+		},
+};
+
+/*
+ * Platform driver structs
+ */
+static ssize_t buttons_show(struct device *dev,
+			    struct device_attribute *attr, char *buf);
+static ssize_t pressed_button_show(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+static ssize_t pressed_button_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count);
+static DEVICE_ATTR(pressed_button, 0666, pressed_button_show,
+		   pressed_button_store);
+static DEVICE_ATTR(buttons, 0444, buttons_show, NULL);
+static struct platform_device *pf_device;
+static struct platform_driver pf_driver = {
+	.driver = {
+		   .name = QUICKSTART_PF_DRIVER_NAME,
+		   .owner = THIS_MODULE,
+		   }
+};
+
+struct key_entry {
+        char type;              /* See KE_* below */
+        u32 code;
+        u16 keycode;
+};
+
+enum { KE_KEY, KE_END };
+
+static struct key_entry quickstart_keymap[] = {
+	{KE_END, 0}
+};
+
+static struct key_entry *quickstart_get_entry_by_scancode(int code)
+{
+        struct key_entry *key;
+
+        for (key = quickstart_keymap; key->type != KE_END; key++)
+                if (code == key->code)
+                        return key;
+
+        return NULL;
+}
+
+static struct key_entry *quickstart_get_entry_by_keycode(int keycode)
+{
+        struct key_entry *key;
+
+        for (key = quickstart_keymap; key->type != KE_END; key++)
+                if (key->type == KE_KEY && keycode == key->keycode)
+                        return key;
+
+        return NULL;
+}
+
+static int quickstart_getkeycode(struct input_dev *dev, int scancode,
+				 int *keycode)
+{
+        struct key_entry *key = quickstart_get_entry_by_scancode(scancode);
+
+        if (key && key->type == KE_KEY) {
+                *keycode = key->keycode;
+                return 0;
+        }
+
+        return -EINVAL;
+}
+
+static int quickstart_setkeycode(struct input_dev *dev, int scancode,
+				 int keycode)
+{
+        struct key_entry *key;
+        int old_keycode;
+
+        if (keycode < 0 || keycode > KEY_MAX)
+                return -EINVAL;
+
+        key = quickstart_get_entry_by_scancode(scancode);
+        if (key && key->type == KE_KEY) {
+                old_keycode = key->keycode;
+                key->keycode = keycode;
+                set_bit(keycode, dev->keybit);
+                if (!quickstart_get_entry_by_keycode(old_keycode))
+                        clear_bit(old_keycode, dev->keybit);
+                return 0;
+        }
+
+        return -EINVAL;
+}
+
+/*
+ * Platform driver functions
+ */
+static ssize_t buttons_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	int count = 0;
+	char tmpbuf[QUICKSTART_MAX_BTN_NAME_LEN + 2];
+	struct quickstart_btn_list *ptr = quickstart_data.btn_lst;
+
+	if (!ptr)
+		return snprintf(buf, PAGE_SIZE, "none");
+
+	while (ptr && (count < PAGE_SIZE)) {
+		if (ptr->name) {
+			strncpy(tmpbuf, ptr->name, QUICKSTART_MAX_BTN_NAME_LEN);
+			strcat(tmpbuf, "\n");
+			count += snprintf(buf + count,
+					  PAGE_SIZE - count, tmpbuf);
+		}
+		ptr = ptr->next;
+	}
+
+	return count;
+}
+
+static ssize_t pressed_button_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			(quickstart_data.pressed ? quickstart_data.pressed->
+			 name : "none"));
+}
+
+static ssize_t pressed_button_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	if (count < 2)
+		return -EINVAL;
+
+	if (strncasecmp(buf, "none", 4) != 0)
+		return -EINVAL;
+
+	quickstart_data.pressed = NULL;
+	return count;
+}
+
+/* Hotstart Helper functions */
+static int quickstart_btnlst_add(struct quickstart_btn_list **data)
+{
+	struct quickstart_btn_list **ptr = &quickstart_data.btn_lst;
+
+	while (*ptr)
+		ptr = &((*ptr)->next);
+
+	*ptr = kzalloc(sizeof(struct quickstart_btn_list), GFP_KERNEL);
+	if (!*ptr) {
+		*data = NULL;
+		return (-ENOMEM);
+	}
+	*data = *ptr;
+
+	return 0;
+}
+
+static void quickstart_btnlst_free(void)
+{
+	struct quickstart_btn_list *ptr = quickstart_data.btn_lst;
+	struct quickstart_btn_list *lptr = NULL;
+
+	if (!ptr)
+		return;
+
+	while (ptr) {
+		lptr = ptr;
+		ptr = ptr->next;
+		if (lptr->name)
+			kfree(lptr->name);
+		kfree(lptr);
+	}
+
+	return;
+}
+
+static void quickstart_acpi_get_event(struct quickstart_acpi *quickstart,
+	unsigned long long *button)
+{
+	acpi_status status;
+
+	status = acpi_evaluate_integer(quickstart->device->handle,
+				      "GHID", NULL, button);
+	if (ACPI_FAILURE(status))
+		printk (KERN_WARNING
+			"quickstart: Warning: GHID method failed\n");
+
+	return;
+}
+
+/* ACPI Driver functions */
+static void quickstart_acpi_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct quickstart_acpi *quickstart = data;
+	struct key_entry *key;
+	unsigned long long button;
+
+	if (!quickstart)
+		return;
+
+	/* There will be two events:
+	 * 0x02 - A quickstart button was pressed while device was off/sleeping.
+	 * 0x80 - A quickstart button was pressed while device was up. */
+	if (event & 0x02)
+		quickstart_data.pressed = quickstart->btn;
+
+	quickstart_acpi_get_event(quickstart, &button);
+
+	key = quickstart_get_entry_by_scancode(button);
+
+	if (!key)
+		printk(KERN_INFO "Quickstart: Unknown key pressed - 0x%llx\n",
+		       button);
+
+	input_report_key(quickstart_input_dev, key->keycode, 1);
+	input_sync(quickstart_input_dev);
+	input_report_key(quickstart_input_dev, key->keycode, 0);
+	input_sync(quickstart_input_dev);
+
+	return;
+}
+
+static int quickstart_acpi_config(struct quickstart_acpi *quickstart, char *bid)
+{
+	int len = strlen(bid);
+	int ret;
+
+	/* Add button to list */
+	ret = quickstart_btnlst_add(&quickstart->btn);
+	if (ret)
+		return ret;
+
+	quickstart->btn->name = kzalloc(len + 1, GFP_KERNEL);
+	if (!quickstart->btn->name) {
+		quickstart_btnlst_free();
+		return -ENOMEM;
+	}
+	strcpy(quickstart->btn->name, bid);
+
+	return 0;
+}
+
+static int quickstart_acpi_add(struct acpi_device *device)
+{
+	int ret = 0;
+	acpi_status status = AE_OK;
+	struct quickstart_acpi *quickstart = NULL;
+
+	if (!device)
+		return -EINVAL;
+
+	quickstart = kzalloc(sizeof(struct quickstart_acpi), GFP_KERNEL);
+	if (!quickstart)
+		return -ENOMEM;
+
+	quickstart->device = device;
+	strcpy(acpi_device_name(device), QUICKSTART_ACPI_DEVICE_NAME);
+	strcpy(acpi_device_class(device), QUICKSTART_ACPI_CLASS);
+	device->driver_data = quickstart;
+
+	/* Add button to list and initialize some stuff */
+	ret = quickstart_acpi_config(quickstart, acpi_device_bid(device));
+	if (ret)
+		goto fail_config;
+
+	status = acpi_install_notify_handler(device->handle,
+					     ACPI_ALL_NOTIFY,
+					     quickstart_acpi_notify,
+					     quickstart);
+	if (ACPI_FAILURE(status)) {
+		printk("quickstart: Error installing notify handler\n");
+		ret = -ENODEV;
+		goto fail_installnotify;
+	}
+
+	/* Call device GHID method. This is a workaround to get a notify
+	 * event when hot button is pressed while laptop is powered off.
+	 * This works, even if the method fails. */
+	quickstart_acpi_get_event(quickstart, NULL);
+
+	return 0;
+
+fail_installnotify:
+fail_config:
+
+	kfree(quickstart);
+
+	return ret;
+}
+
+static int quickstart_acpi_remove(struct acpi_device *device, int type)
+{
+	acpi_status status = 0;
+	struct quickstart_acpi *quickstart = NULL;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	quickstart = acpi_driver_data(device);
+
+	status = acpi_remove_notify_handler(device->handle,
+					    ACPI_ALL_NOTIFY,
+					    quickstart_acpi_notify);
+	if (ACPI_FAILURE(status))
+		printk("quickstart: Error removing notify handler\n");
+
+	kfree(quickstart);
+
+	return 0;
+}
+
+/* Module functions */
+
+static void quickstart_exit(void)
+{
+	device_remove_file(&pf_device->dev, &dev_attr_pressed_button);
+	device_remove_file(&pf_device->dev, &dev_attr_buttons);
+
+	input_unregister_device(quickstart_input_dev);
+
+	platform_device_unregister(pf_device);
+
+	platform_driver_unregister(&pf_driver);
+
+	acpi_bus_unregister_driver(&quickstart_acpi_driver);
+
+	quickstart_btnlst_free();
+
+	return;
+}
+
+static int __init quickstart_init(void)
+{
+	int ret;
+	acpi_status status = 0;
+	struct key_entry *key;
+
+	/* ACPI Check */
+	if (acpi_disabled)
+		return -ENODEV;
+
+	/* ACPI driver register */
+	status = acpi_bus_register_driver(&quickstart_acpi_driver);
+	if (status < 0)
+		return -ENODEV;
+
+	/* Platform driver register */
+	ret = platform_driver_register(&pf_driver);
+	if (ret)
+		goto fail_pfdrv_reg;
+
+	/* Platform device register */
+	pf_device = platform_device_alloc(QUICKSTART_PF_DEVICE_NAME, -1);
+	if (!pf_device) {
+		ret = -ENOMEM;
+		goto fail_pfdev_alloc;
+	}
+
+	ret = platform_device_register(pf_device);
+	if (ret)
+		goto fail_pfdev_reg;
+
+	/* Create device sysfs file */
+	ret = device_create_file(&pf_device->dev, &dev_attr_pressed_button);
+	if (ret)
+		goto fail_dev_file;
+
+	ret = device_create_file(&pf_device->dev, &dev_attr_buttons);
+	if (ret)
+		goto fail_dev_file2;
+
+	quickstart_input_dev = input_allocate_device();
+	if (!quickstart_input_dev)
+		goto fail_input_alloc;
+
+	quickstart_input_dev->name = "ACPI Quickstart hotkeys";
+	quickstart_input_dev->phys = "quickstart/input0";
+	quickstart_input_dev->id.bustype = BUS_HOST;
+	quickstart_input_dev->getkeycode = quickstart_getkeycode;
+	quickstart_input_dev->setkeycode = quickstart_setkeycode;
+
+	for (key = quickstart_keymap; key->type != KE_END; key++) {
+		set_bit(EV_KEY, quickstart_input_dev->evbit);
+		set_bit(key->keycode, quickstart_input_dev->evbit);
+	}
+
+	ret = input_register_device(quickstart_input_dev);
+	if (ret)
+		goto fail_input_register;
+
+	printk("quickstart: ACPI Direct App Launch ver %s\n",
+	       QUICKSTART_VERSION);
+
+	return 0;
+
+fail_input_register:
+	input_free_device(quickstart_input_dev);
+
+fail_input_alloc:
+	device_remove_file(&pf_device->dev, &dev_attr_buttons);
+
+fail_dev_file2:
+	device_remove_file(&pf_device->dev, &dev_attr_pressed_button);
+
+fail_dev_file:
+	platform_device_del(pf_device);
+
+fail_pfdev_reg:
+	platform_device_put(pf_device);
+
+fail_pfdev_alloc:
+	platform_driver_unregister(&pf_driver);
+
+fail_pfdrv_reg:
+	acpi_bus_unregister_driver(&quickstart_acpi_driver);
+
+	return ret;
+}
+
+module_init(quickstart_init);
+module_exit(quickstart_exit);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
