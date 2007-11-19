Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbXKSV4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbXKSV4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXKSV4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:56:21 -0500
Received: from v1539.ncsrv.de ([89.110.150.23]:57708 "EHLO v1539.ncsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbXKSV4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:56:19 -0500
X-Greylist: delayed 2037 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 16:56:18 EST
Message-Id: <20071119211914.444515284@hendrik-sattler.de>
References: <20071119211318.046166499@hendrik-sattler.de>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 22:13:20 +0100
From: post@hendrik-sattler.de
To: linux-kernel@vger.kernel.org
Cc: i2c@lm-sensors.org, Hendrik Sattler <post@hendrik-sattler.de>
Subject: [PATCH 2/2] fjkeyinf driver for FSC Lifebook laptops
Content-Disposition: inline; filename=fjkeyinf.patch
X-Spam-Score: -3.5 (---)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is another approach for FJKEYINF support for the FSC Lifebook laptop
series.
In comparison to the apanel driver that was posted lately, it supports more
than one entry in the table and slits off the actual handling of the I2C
devices to seperate drivers, allowing resuse in other scenarios.

Signed-off-by: Hendrik Sattler <post@hendrik-sattler.de>
---

This is a kernel module for parsing the FJKEYINF table present in some
laptops manufactured by Fujitsu-Siemens Computers. It does not
implement handling the chips mentioned in the database but
already has support for triggering the oz99x I2C driver.

Index: git-linville/drivers/misc/fjkeyinf.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linville/drivers/misc/fjkeyinf.c	2007-11-18 23:39:10.884205915 +0100
@@ -0,0 +1,242 @@
+/*
+    Fujitsu Lifebook FJKEYINF information base
+
+    Copyright (C) 2001-2003 Jochen Eisinger <jochen@penguin-breeder.org>
+                  2006-2007 Hendrik Sattler <post@hendrik-sattler.de>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/kmod.h>
+#include <linux/input.h>
+#include <linux/i2c.h>
+#include <linux/list.h>
+
+#include <linux/oz99x.h>
+
+/* scan the system rom for the signature "FJKEYINF" */
+/* FSC Lifebook C-6637:
+ * type = 5, access = 4 chip = 2, slave = 0x16 (unknown)
+ * type = 1, access = 4 chip = 1, slave = 0x18 (OZ992S with buttons '1'-'4')
+ * type = 6, access = 4 chip = 3, slave = 0x5c (unknown)
+ */
+
+/* Scan the system ROM for the signature "FJKEYINF" */
+static __init const void __iomem *bios_signature(const void __iomem *bios,
+						 size_t len)
+{
+	size_t offset = 0;
+	const char signature[] = {'F', 'J', 'K', 'E', 'Y', 'I', 'N', 'F'};
+
+	for (; offset < len; offset += 0x10)
+		if (check_signature(bios + offset, signature,
+				    sizeof(signature)))
+			return bios + offset;
+
+	return NULL;
+}
+
+static __init const void __iomem *fjkeyinf_get(void)
+{
+	struct resource *res = iomem_resource.child;
+	const unsigned char __iomem *bios;
+	const unsigned char __iomem *ptr;
+	struct fjkeyinf_elem __iomem *retval = NULL;
+	unsigned long len;
+	const char sig[] = { 'F', 'J', 'K', 'E', 'Y', 'I', 'N', 'F' };
+
+	/* find the "System ROM" resource */
+	while (res != NULL) {
+		if (res->name && !strcmp("System ROM", res->name))
+			break;
+		res = res->sibling;
+	}
+
+	if (!res) {
+		pr_err("fjkeyinf: failed to locate System ROM resource\n");
+		return NULL;
+	}
+	len = (res->end - res->start) + 1;
+	bios = ioremap(res->start, len);
+
+	/* try to locate the signature in the System ROM */
+	ptr = bios_signature(bios, len);
+	if (ptr)
+		retval = (struct fjkeyinf_elem __iomem *)(ptr+ARRAY_SIZE(sig));
+
+	return retval;
+}
+
+static struct oz99x_platform_data keycodes[3] =  {
+	{
+		.keymap = {
+			KEY_PROG1,
+			KEY_PROG2,
+			KEY_PROG3,
+			KEY_PROG4
+		}
+	}, {
+		.keymap = {
+			KEY_MAIL,
+			KEY_WWW,
+			KEY_PROG1,
+			KEY_PROG2
+		}
+	}, {
+		.keymap = {
+			KEY_FORWARD,
+			KEY_REWIND,
+			KEY_STOP,
+			KEY_PLAYPAUSE
+		}
+	}
+};
+
+struct fjkeyinf_client {
+	struct i2c_client *client;
+	struct list_head list;
+};
+static LIST_HEAD(fjkeyinf_clients);
+
+static int fjkeyinf_attach_adapter(struct i2c_adapter *adapter)
+{
+	struct i2c_board_info board_info;
+	struct fjkeyinf_client *data;
+	const void __iomem *bios;
+	const void __iomem *tmp;
+	u8 func;
+	u8 bus;
+	u8 chip;
+	u8 addr;
+
+	if (adapter->id != I2C_HW_SMBUS_I801)
+		return -ENODEV;
+
+	bios = fjkeyinf_get();
+	if (bios == NULL) {
+		pr_err("fjkeyinf: no Fujitsu BIOS signature found.\n");
+		return -ENODEV;
+	}
+
+	tmp = bios;
+	do {
+		board_info.driver_name[0] = 0;
+		board_info.addr = 0;
+		board_info.platform_data = NULL;
+
+		func = readb(tmp);
+		if (!func || (func & 0x80))
+			break;
+
+		bus = readb(tmp+1);
+		chip = readb(tmp+2);
+		addr = readb(tmp+3);
+
+		pr_info("fjkeyinf: function = %d, bustype = %d, "
+		       "chip = %d, address = 0x%02x\n",
+		       (int)func,
+		       (int)bus,
+		       (int)chip,
+		       (int)(addr >> 1) & 0x7F);
+
+		switch (chip) {
+		case 1: /* OZ992 */
+			strncat(board_info.driver_name, "oz99x",
+				sizeof(board_info.driver_name));
+			board_info.addr = ((addr >> 1)) & 0x7F;
+			switch (func) {
+			case 1: /* numbered buttons */
+				board_info.platform_data = &keycodes[0];
+				break;
+
+			case 2: /* CD control buttons */
+				board_info.platform_data = &keycodes[2];
+				break;
+
+			case 6: /* application buttons */
+				board_info.platform_data = &keycodes[1];
+				break;
+			}
+			break;
+
+		default: /* unknown/unsupported chip */
+			break;
+		}
+		tmp += 4;
+
+		if (board_info.addr == 0)
+			continue;
+
+		data = kzalloc(sizeof(*data), GFP_KERNEL);
+		data->client = i2c_new_device(adapter, &board_info);
+		if (!data->client) {
+			pr_err("fjkeyinf: adding new i2c device failed\n");
+			kfree(data);
+			data = NULL;
+		} else {
+			list_add(&data->list, &fjkeyinf_clients);
+		}
+	} while (1);
+	iounmap((void __iomem *)bios);
+	return 0;
+}
+
+static int fjkeyinf_detach_adapter(struct i2c_adapter *adapter)
+{
+	struct fjkeyinf_client *data, *tmp;
+
+	list_for_each_entry_safe(data, tmp, &fjkeyinf_clients, list) {
+		if (data->client->adapter == adapter) {
+			i2c_unregister_device(data->client);
+			list_del(&data->list);
+		}
+	}
+	return 0;
+}
+
+static struct i2c_driver fjkeyinf_driver = {
+	.driver = {
+		.name   = "fjkeyinf",
+	},
+	.id             = 0,
+	.attach_adapter = fjkeyinf_attach_adapter,
+	.detach_adapter = fjkeyinf_detach_adapter
+};
+
+static int __init fjkeyinf_module_init(void)
+{
+	return i2c_add_driver(&fjkeyinf_driver);
+}
+
+static void __exit fjkeyinf_module_exit(void)
+{
+	i2c_del_driver(&fjkeyinf_driver);
+}
+
+module_init(fjkeyinf_module_init);
+module_exit(fjkeyinf_module_exit);
+
+MODULE_ALIAS("dmi:*:svnFUJITSU*:pnLifeBook*");
+MODULE_ALIAS("dmi:*:svnFUJITSU*:pnLifebook*");
+
+MODULE_DESCRIPTION("Special devices table in Fujitsu-Siemens laptops");
+MODULE_AUTHOR("Hendrik Sattler");
+MODULE_LICENSE("GPL");
Index: git-linville/drivers/misc/Kconfig
===================================================================
--- git-linville.orig/drivers/misc/Kconfig	2007-11-18 23:25:41.140961949 +0100
+++ git-linville/drivers/misc/Kconfig	2007-11-18 23:25:49.057631185 +0100
@@ -219,6 +219,21 @@
 
 	  If you are not sure, say Y here.
 
+config FJKEYINF
+	tristate "Fujutsu(-Siemens) Lifebook special BIOS signature support"
+	depends on X86
+	depends on I2C
+	select I2C_I801
+	select CHECK_SIGNATURE
+	help
+	  Say Y here to enable evaluation of the the special BIOS signature
+	  present on may Fujitsu(-Siemens) Lifebooks.
+	  The following SMBus chips are currently supported if the proper
+	  signature is found:
+	    - oz99x (for panel buttons and LEDs)
+
+	  To compile this driver as module, say M here: the module will be
+	  called fjkeyinf.
 
 config ATMEL_SSC
 	tristate "Device driver for Atmel SSC peripheral"
Index: git-linville/drivers/misc/Makefile
===================================================================
--- git-linville.orig/drivers/misc/Makefile	2007-11-18 23:25:41.204298606 +0100
+++ git-linville/drivers/misc/Makefile	2007-11-18 23:25:49.084282003 +0100
@@ -17,3 +17,4 @@
 obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
 obj-$(CONFIG_FUJITSU_LAPTOP)	+= fujitsu-laptop.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
+obj-$(CONFIG_FJKEYINF)		+= fjkeyinf.o

-- 

