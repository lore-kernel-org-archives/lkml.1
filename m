Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZBKAwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZBKAwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbZBKAhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:37:17 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43087 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623AbZBKAhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:37:15 -0500
Subject: [RFC][Patch] IBM Real-Time "SMI Free" mode driver
From: Keith Mannthey <kmannth@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 16:37:13 -0800
Message-Id: <1234312633.15410.546.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports the Real-Time Linux (RTL) BIOS feature.  The RTL
feature allows non-fatal System Management Interrupts (SMIs) to be
disabled on supported IBM platforms (LS21, LS22 and HS21xm blades).  

This driver creates a simple sysfs interface to allow a simple entry and
exit from RTL mode in the BIOS. 

Signed-off-by:  Keith Mannthey <kmannth@us.ibm.com>

---

diff -urN linux-2.6.29-rc3-git7-orig/drivers/misc/ibmrtl/ibm_rtl.c linux-2.6.29-rc3-git7/drivers/misc/ibmrtl/ibm_rtl.c
--- linux-2.6.29-rc3-git7-orig/drivers/misc/ibmrtl/ibm_rtl.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.29-rc3-git7/drivers/misc/ibmrtl/ibm_rtl.c	2009-02-10 13:58:21.000000000 -0500
@@ -0,0 +1,205 @@
+/*
+ * IBM Real Time Linux Mode Device Driver
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ *
+ * Author: Keith Mannthey <kmannth@us.ibm.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/sysdev.h>
+#include "rtl.h"
+
+static unsigned int table_addr;
+
+int ibm_rtl_write(u8 value)
+{
+	int ret = 0;
+	void __iomem *rtl;
+
+	/* only valid value is 0 and 1 */
+	if (value > 1) {
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	rtl = ioremap(table_addr, RTL_TABLE_SIZE);
+
+	if (!rtl) {
+		printk(KERN_WARNING "Could not ioremap RTL table\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	if (readb(rtl+RTL_STATE) != value) {
+		if (value == 1)
+			writeb(1, (rtl+RTL_CMD));
+		else
+			writeb(2, (rtl+RTL_CMD));
+
+		/*write special command*/
+		outb(bios_to_value(rtl, RTL_CMD_PORT_VALUE),
+			bios_to_value(rtl, RTL_CMD_PORT_ADDR));
+
+		while (readb(rtl+RTL_CMD))
+			msleep(10);
+
+		if (readb(rtl+RTL_CMD_STATUS))
+			ret = -EIO;
+	}
+
+	iounmap(rtl);
+err_out:
+	return ret;
+}
+
+static ssize_t rtl_show_version(struct sysdev_class *dev, char * buf)
+{
+	int ret;
+	void  __iomem *rtl;
+
+	rtl = ioremap(table_addr, RTL_TABLE_SIZE);
+
+	if (!rtl) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+	ret = sprintf(buf, "%d\n", (int)readb(rtl+RTL_VERSION));
+
+	iounmap(rtl);
+err_out:
+	return ret;
+}
+
+static ssize_t rtl_show_state(struct sysdev_class *dev, char *buf)
+{
+	int ret;
+	void __iomem *rtl;
+
+	rtl = ioremap(table_addr, RTL_TABLE_SIZE);
+
+	if (!rtl) {
+		printk(KERN_WARNING "Could not ioremap RTL table\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+	ret = sprintf(buf, "%d\n", readb(rtl+RTL_STATE));
+
+	iounmap(rtl);
+err_out:
+	return ret;
+}
+
+static ssize_t rtl_set_state(struct sysdev_class *dev, const char *buf,
+								size_t size)
+{
+	ssize_t ret;
+	switch (buf[0]) {
+	case '0':
+		ret = ibm_rtl_write(0);
+		break;
+	case '1':
+		ret = ibm_rtl_write(1);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	if (ret >= 0)
+		ret = size;
+
+	return ret;
+}
+
+static struct sysdev_class class_rtl = {
+	.name	= "ibm_rtl",
+};
+
+static SYSDEV_CLASS_ATTR(version, S_IRUGO, rtl_show_version, NULL);
+static SYSDEV_CLASS_ATTR(state, 0600, rtl_show_state, rtl_set_state);
+
+static struct sysdev_class_attribute *rtl_attributes[] = {
+	&attr_version,
+	&attr_state,
+	NULL
+};
+
+
+static int rtl_setup_sysfs(void)
+{
+	int ret, i;
+	ret = sysdev_class_register(&class_rtl);
+
+	if (!ret) {
+		for (i = 0; rtl_attributes[i]; i++)
+			sysdev_class_create_file(&class_rtl, rtl_attributes[i]);
+	}
+	return ret;
+}
+
+static void rtl_teardown_sysfs(void)
+{
+	int i;
+	for (i = 0; rtl_attributes[i]; i++)
+		sysdev_class_remove_file(&class_rtl, rtl_attributes[i]);
+	sysdev_class_unregister(&class_rtl);
+	return;
+}
+
+/* only allow the modules to load if the _RTL_ table can be found*/
+int init_module(void)
+{
+	unsigned long ebda_addr, ebda_size;
+	void __iomem *data, *d;
+	int ret, i;
+
+	/*get the address for the RTL table from the EBDA */
+	ebda_addr = *(unsigned short *)phys_to_virt(0x40E);
+	ebda_addr <<= 4;
+	ebda_size = 64*1024;
+
+	data = ioremap(ebda_addr, ebda_size);
+	d = data;
+	if (!data) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	for (i = 0 ; i < ebda_size/4; i++) {
+		unsigned int *tmp = (unsigned int *) data++;
+		if (*tmp == RTL_MAGIC_IDENT) {
+			table_addr = ebda_addr + i;
+			ret = rtl_setup_sysfs();
+			goto exit;
+		}
+	}
+
+	ret = -ENODEV;
+
+exit:
+	iounmap(d);
+	return ret;
+}
+
+void cleanup_module(void)
+{
+	rtl_teardown_sysfs();
+}
+
+MODULE_LICENSE("GPL");
diff -urN linux-2.6.29-rc3-git7-orig/drivers/misc/ibmrtl/Makefile linux-2.6.29-rc3-git7/drivers/misc/ibmrtl/Makefile
--- linux-2.6.29-rc3-git7-orig/drivers/misc/ibmrtl/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.29-rc3-git7/drivers/misc/ibmrtl/Makefile	2009-02-05 12:38:35.000000000 -0500
@@ -0,0 +1 @@
+obj-$(CONFIG_IBM_RTL) := ibm_rtl.o
diff -urN linux-2.6.29-rc3-git7-orig/drivers/misc/ibmrtl/rtl.h linux-2.6.29-rc3-git7/drivers/misc/ibmrtl/rtl.h
--- linux-2.6.29-rc3-git7-orig/drivers/misc/ibmrtl/rtl.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.29-rc3-git7/drivers/misc/ibmrtl/rtl.h	2009-02-10 13:58:12.000000000 -0500
@@ -0,0 +1,49 @@
+/*
+ * IBM Real Time Linux Mode Device Driver
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ *
+ * Author: Keith Mannthey <kmannth@us.ibm.com>
+ *
+ */
+
+#include <linux/io.h>
+
+/* The RTL table looks something like
+	u8 signature[5];
+	u8 version;
+	u8 RT_Status;
+	u8 Command;
+	u8 CommandStatus;
+	u8 CMDAddressType;
+	u8 CmdGranularity;
+	u8 CmdOffset;
+	u16 Reserve1;
+	u8 CmdPortAddress[4];
+	u8 CmdPortValue[4];
+*/
+#define RTL_TABLE_SIZE 0x16
+#define RTL_MAGIC_IDENT (('L'<<24)|('T'<<16)|('R'<<8)|'_')
+#define RTL_VERSION 0x5
+#define RTL_STATE 0x6
+#define RTL_CMD 0x7
+#define RTL_CMD_STATUS 0x8
+#define RTL_CMD_PORT_ADDR 0xE
+#define RTL_CMD_PORT_VALUE 0x12
+
+/*needed to decode CmdPortAddress and CmdPortValue*/
+#define bios_to_value(rtl, offset) (u32)((readb(rtl+(offset+1)) << 8) + \
+							readb(rtl+offset))
diff -urN linux-2.6.29-rc3-git7-orig/drivers/misc/Kconfig linux-2.6.29-rc3-git7/drivers/misc/Kconfig
--- linux-2.6.29-rc3-git7-orig/drivers/misc/Kconfig	2009-02-05 12:29:22.000000000 -0500
+++ linux-2.6.29-rc3-git7/drivers/misc/Kconfig	2009-02-05 12:45:48.000000000 -0500
@@ -75,6 +75,21 @@
 	  website <http://www.pc.ibm.com/ww/eserver/xseries/serverproven> for
 	  information on the specific driver level and support statement
 	  for your IBM server.
+config IBM_RTL
+        tristate "Device driver to enable IBM PRTL support"
+        depends on X86 && PCI && EXPERIMENTAL
+        ---help---
+	  Enable support for IBM Preimium Real Time Mode (PRTM).
+	  This module will allow you the enter and exit PRTM in the BIOS via
+	  sysfs on platforms that support this feature.  System in PRTM will
+	  not recive cpu generated SMIs for recoverable errors.  Use of this
+	  feature without proper support may void your hardware warrenty.
+
+	  If the proper bios support is found the driver will load and create
+	  /sys/devices/system/ibm_rtl/.  The "state" varable will indicate
+	  weather or not the BIOS is in PRTM.
+	  state = 0 (BIOS SMI's on)
+	  state = 1 (BIOS SMI's off)
 
 config PHANTOM
 	tristate "Sensable PHANToM (PCI)"
diff -urN linux-2.6.29-rc3-git7-orig/drivers/misc/Makefile linux-2.6.29-rc3-git7/drivers/misc/Makefile
--- linux-2.6.29-rc3-git7-orig/drivers/misc/Makefile	2009-02-05 12:29:22.000000000 -0500
+++ linux-2.6.29-rc3-git7/drivers/misc/Makefile	2009-02-05 12:39:54.000000000 -0500
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_IBM_ASM)		+= ibmasm/
+obj-$(CONFIG_IBM_RTL)		+= ibmrtl/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o


