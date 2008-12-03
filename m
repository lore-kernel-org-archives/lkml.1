Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYLCV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYLCV3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLCV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:29:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57614 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYLCV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:29:07 -0500
Date: Wed, 3 Dec 2008 21:29:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] misc: Add dell-wmi driver for hotkey control
Message-ID: <20081203212903.GA25109@srcf.ucam.org>
References: <20081203195644.GC22560@srcf.ucam.org> <alpine.LNX.2.00.0812032149470.16637@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0812032149470.16637@titan.stealer.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks - updated version follows.

commit 6e7b4e08dc924e3ec71f33b9e0e8fda077c2be89
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Dec 3 19:42:40 2008 +0000

    misc: add dell-wmi driver
    
    Add a WMI driver for Dell laptops. Currently it does nothing but send a
    generic input event when a button with a picture of a battery on it is
    pressed, but maybe other uses will appear over time.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 618c1ef..fe2c17e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1371,6 +1371,11 @@ P:	Doug Warzecha
 M:	Douglas_Warzecha@dell.com
 S:	Maintained
 
+DELL WMI EXTRAS DRIVER
+P:	Matthew Garrett
+M:	mjg59@srcf.ucam.org
+S:	Maintained
+
 DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
 M:	device@lanana.org
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fee7304..5837544 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -227,6 +227,16 @@ config HP_WMI
          To compile this driver as a module, choose M here: the module will
          be called hp-wmi.
 
+config DELL_WMI
+       tristate "Dell WMI extras"
+       depends on ACPI_WMI
+       depends on INPUT
+       help
+         Say Y here if you want to support WMI-based hotkeys on Dell laptops.
+
+         To compile this driver as a module, choose M here: the module will
+         be called dell-wmi.
+
 config ICS932S401
 	tristate "Integrated Circuits ICS932S401"
 	depends on I2C && EXPERIMENTAL
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 817f7f5..5b47819 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
+obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
 obj-$(CONFIG_ICS932S401)	+= ics932s401.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
diff --git a/drivers/misc/dell-wmi.c b/drivers/misc/dell-wmi.c
new file mode 100644
index 0000000..2fab941
--- /dev/null
+++ b/drivers/misc/dell-wmi.c
@@ -0,0 +1,210 @@
+/*
+ * Dell WMI hotkeys
+ *
+ * Copyright (C) 2008 Red Hat <mjg@redhat.com>
+ *
+ * Portions based on wistron_btns.c:
+ * Copyright (C) 2005 Miloslav Trmac <mitr@volny.cz>
+ * Copyright (C) 2005 Bernhard Rosenkraenzer <bero@arklinux.org>
+ * Copyright (C) 2005 Dmitry Torokhov <dtor@mail.ru>
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/input.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
+#include <linux/string.h>
+
+MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
+MODULE_DESCRIPTION("Dell laptop WMI hotkeys driver");
+MODULE_LICENSE("GPL");
+
+#define DELL_EVENT_GUID "9DBB5994-A997-11DA-B012-B622A1EF5492"
+
+MODULE_ALIAS("wmi:"DELL_EVENT_GUID);
+
+struct key_entry {
+	char type;		/* See KE_* below */
+	u16 code;
+	u16 keycode;
+};
+
+enum { KE_KEY, KE_SW, KE_END };
+
+static struct key_entry dell_wmi_keymap[] = {
+	{KE_KEY, 0xe045, KEY_PROG1},
+	{KE_END, 0}
+};
+
+static struct input_dev *dell_wmi_input_dev;
+
+static struct key_entry *dell_wmi_get_entry_by_scancode(int code)
+{
+	struct key_entry *key;
+
+	for (key = dell_wmi_keymap; key->type != KE_END; key++)
+		if (code == key->code)
+			return key;
+
+	return NULL;
+}
+
+static struct key_entry *dell_wmi_get_entry_by_keycode(int keycode)
+{
+	struct key_entry *key;
+
+	for (key = dell_wmi_keymap; key->type != KE_END; key++)
+		if (key->type == KE_KEY && keycode == key->keycode)
+			return key;
+
+	return NULL;
+}
+
+static int dell_wmi_getkeycode(struct input_dev *dev, int scancode,
+			       int *keycode)
+{
+	struct key_entry *key = dell_wmi_get_entry_by_scancode(scancode);
+
+	if (key && key->type == KE_KEY) {
+		*keycode = key->keycode;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int dell_wmi_setkeycode(struct input_dev *dev, int scancode, int keycode)
+{
+	struct key_entry *key;
+	int old_keycode;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	key = dell_wmi_get_entry_by_scancode(scancode);
+	if (key && key->type == KE_KEY) {
+		old_keycode = key->keycode;
+		key->keycode = keycode;
+		set_bit(keycode, dev->keybit);
+		if (!dell_wmi_get_entry_by_keycode(old_keycode))
+			clear_bit(old_keycode, dev->keybit);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static void dell_wmi_notify(u32 value, void *context)
+{
+	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
+	static struct key_entry *key;
+	union acpi_object *obj;
+
+	wmi_get_event_data(value, &response);
+
+	obj = (union acpi_object *)response.pointer;
+
+	if (obj && obj->type == ACPI_TYPE_BUFFER) {
+		int *buffer = (int *)obj->buffer.pointer;
+		key = dell_wmi_get_entry_by_scancode(buffer[1]);
+		if (key) {
+			input_report_key(dell_wmi_input_dev, key->keycode, 1);
+			input_sync(dell_wmi_input_dev);
+			input_report_key(dell_wmi_input_dev, key->keycode, 0);
+			input_sync(dell_wmi_input_dev);
+		} else
+			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
+			       buffer[1]);
+	}
+}
+
+static int __init dell_wmi_input_setup(void)
+{
+	struct key_entry *key;
+	int err;
+
+	dell_wmi_input_dev = input_allocate_device();
+
+	if (!dell_wmi_input_dev)
+		return -ENOMEM;
+
+	dell_wmi_input_dev->name = "Dell WMI hotkeys";
+	dell_wmi_input_dev->phys = "wmi/input0";
+	dell_wmi_input_dev->id.bustype = BUS_HOST;
+	dell_wmi_input_dev->getkeycode = dell_wmi_getkeycode;
+	dell_wmi_input_dev->setkeycode = dell_wmi_setkeycode;
+
+	for (key = dell_wmi_keymap; key->type != KE_END; key++) {
+		switch (key->type) {
+		case KE_KEY:
+			set_bit(EV_KEY, dell_wmi_input_dev->evbit);
+			set_bit(key->keycode, dell_wmi_input_dev->keybit);
+			break;
+		case KE_SW:
+			set_bit(EV_SW, dell_wmi_input_dev->evbit);
+			set_bit(key->keycode, dell_wmi_input_dev->swbit);
+			break;
+		}
+	}
+
+	err = input_register_device(dell_wmi_input_dev);
+
+	if (err) {
+		input_free_device(dell_wmi_input_dev);
+		return err;
+	}
+
+	return 0;
+}
+
+static int __init dell_wmi_init(void)
+{
+	int err;
+
+	if (wmi_has_guid(DELL_EVENT_GUID)) {
+		err = dell_wmi_input_setup();
+
+		if (err)
+			return err;
+
+		err = wmi_install_notify_handler(DELL_EVENT_GUID,
+						 dell_wmi_notify, NULL);
+		if (err) {
+			input_unregister_device(dell_wmi_input_dev);
+			printk(KERN_ERR "dell-wmi: Unable to register"
+			       " notify handler - %d\n", err);
+			return err;
+		}
+
+	} else
+		printk(KERN_WARNING "dell-wmi: No known WMI GUID found\n");
+
+	return 0;
+}
+
+static void __exit dell_wmi_exit(void)
+{
+	if (wmi_has_guid(DELL_EVENT_GUID)) {
+		wmi_remove_notify_handler(DELL_EVENT_GUID);
+		input_unregister_device(dell_wmi_input_dev);
+	}
+}
+
+module_init(dell_wmi_init);
+module_exit(dell_wmi_exit);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
