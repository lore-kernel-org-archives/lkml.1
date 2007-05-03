Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXECVfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXECVfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXECVfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:35:05 -0400
Received: from mx27.mail.ru ([194.67.23.64]:21413 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbXECVfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:35:02 -0400
Date: Fri, 4 May 2007 01:31:30 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/8] ds2760 W1 slave
Message-ID: <20070503213130.GB20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is W1 slave for ds2760 chip, found inside almost every HP iPaq and
HTC PDAs/phones.

Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/w1/slaves/Kconfig     |   13 ++++
 drivers/w1/slaves/Makefile    |    1 +
 drivers/w1/slaves/w1_ds2760.c |  125 +++++++++++++++++++++++++++++++++++++++++
 drivers/w1/slaves/w1_ds2760.h |   50 ++++++++++++++++
 drivers/w1/w1_family.h        |    1 +
 5 files changed, 190 insertions(+), 0 deletions(-)
 create mode 100644 drivers/w1/slaves/w1_ds2760.c
 create mode 100644 drivers/w1/slaves/w1_ds2760.h

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index 904e5ae..df95d6c 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -35,4 +35,17 @@ config W1_SLAVE_DS2433_CRC
 	  Each block has 30 bytes of data and a two byte CRC16.
 	  Full block writes are only allowed if the CRC is valid.
 
+config W1_SLAVE_DS2760
+	tristate "Dallas 2760 battery monitor chip (HP iPAQ & others)"
+	depends on W1
+	help
+	  If you enable this you will have the DS2760 battery monitor
+	  chip support.
+
+	  The battery monitor chip is used in many batteries/devices
+	  as the one who is responsible for charging/discharging/monitoring
+	  Li+ batteries.
+
+	  If you are unsure, say N.
+
 endmenu
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index 725dcfd..a8eb752 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -5,4 +5,5 @@
 obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
+obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
 
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
new file mode 100644
index 0000000..5a340d1
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -0,0 +1,125 @@
+/*
+ * 1-Wire implementation for the ds2760 chip
+ *
+ * Copyright (c) 2004-2005, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/types.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+#include "w1_ds2760.h"
+
+static int w1_ds2760_io(struct device *dev, char *buf, int addr, size_t count,
+                        int io)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev)
+		return 0;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (addr > DS2760_DATA_SIZE || addr < 0) {
+		count = 0;
+		goto out;
+	}
+	if (addr + count > DS2760_DATA_SIZE)
+		count = DS2760_DATA_SIZE - addr;
+
+	if (!w1_reset_select_slave(sl)) {
+		if (!io) {
+			w1_write_8(sl->master, W1_DS2760_READ_DATA);
+			w1_write_8(sl->master, addr);
+			count = w1_read_block(sl->master, buf, count);
+		} else {
+			w1_write_8(sl->master, W1_DS2760_WRITE_DATA);
+			w1_write_8(sl->master, addr);
+			w1_write_block(sl->master, buf, count);
+			/* XXX w1_write_block returns void, not n_written */
+		}
+	}
+
+out:
+	mutex_unlock(&sl->master->mutex);
+
+	return count;
+}
+
+int w1_ds2760_read(struct device *dev, char *buf, int addr, size_t count)
+{
+	return w1_ds2760_io(dev, buf, addr, count, 0);
+}
+
+int w1_ds2760_write(struct device *dev, char *buf, int addr, size_t count)
+{
+	return w1_ds2760_io(dev, buf, addr, count, 1);
+}
+
+static ssize_t w1_ds2760_read_bin(struct kobject *kobj, char *buf, loff_t off,
+                                  size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	return w1_ds2760_read(dev, buf, off, count);
+}
+
+static struct bin_attribute w1_ds2760_bin_attr = {
+	.attr = {
+		.name = "w1_slave",
+		.mode = S_IRUGO,
+		.owner = THIS_MODULE,
+	},
+	.size = DS2760_DATA_SIZE,
+	.read = w1_ds2760_read_bin,
+};
+
+static int w1_ds2760_add_slave(struct w1_slave *sl)
+{
+	return sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
+}
+
+static void w1_ds2760_remove_slave(struct w1_slave *sl)
+{
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
+}
+
+static struct w1_family_ops w1_ds2760_fops = {
+	.add_slave    = w1_ds2760_add_slave,
+	.remove_slave = w1_ds2760_remove_slave,
+};
+
+static struct w1_family w1_ds2760_family = {
+	.fid = W1_FAMILY_DS2760,
+	.fops = &w1_ds2760_fops,
+};
+
+static int __init w1_ds2760_init(void)
+{
+	printk(KERN_INFO "1-Wire driver for the DS2760 battery monitor "
+	       " chip  - (c) 2004-2005, Szabolcs Gyurko\n");
+	return w1_register_family(&w1_ds2760_family);
+}
+
+static void __exit w1_ds2760_exit(void)
+{
+	w1_unregister_family(&w1_ds2760_family);
+}
+
+EXPORT_SYMBOL(w1_ds2760_read);
+EXPORT_SYMBOL(w1_ds2760_write);
+
+module_init(w1_ds2760_init);
+module_exit(w1_ds2760_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>");
+MODULE_DESCRIPTION("1-wire Driver Dallas 2760 battery monitor chip");
diff --git a/drivers/w1/slaves/w1_ds2760.h b/drivers/w1/slaves/w1_ds2760.h
new file mode 100644
index 0000000..0ee92b9
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds2760.h
@@ -0,0 +1,50 @@
+/*
+ * 1-Wire implementation for the ds2760 chip
+ *
+ * Copyright (c) 2004-2005, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ *
+ */
+
+#ifndef __w1_ds2760_h__
+#define __w1_ds2760_h__
+
+/* Known commands to the DS2760 chip */
+#define W1_DS2760_SWAP                      0xAA
+#define W1_DS2760_READ_DATA                 0x69
+#define W1_DS2760_WRITE_DATA                0x6C
+#define W1_DS2760_COPY_DATA                 0x48
+#define W1_DS2760_RECALL_DATA               0xB8
+#define W1_DS2760_LOCK                      0x6A
+
+/* Number of valid register addresses */
+#define DS2760_DATA_SIZE	    0x40
+
+#define DS2760_PROTECTION_REG	    0x00
+#define DS2760_STATUS_REG	    0x01
+#define DS2760_EEPROM_REG	    0x07
+#define DS2760_SPECIAL_FEATURE_REG  0x08
+#define DS2760_VOLTAGE_MSB	    0x0c
+#define DS2760_VOLTAGE_LSB	    0x0d
+#define DS2760_CURRENT_MSB	    0x0e
+#define DS2760_CURRENT_LSB	    0x0f
+#define DS2760_CURRENT_ACCUM_MSB    0x10
+#define DS2760_CURRENT_ACCUM_LSB    0x11
+#define DS2760_TEMP_MSB		    0x18
+#define DS2760_TEMP_LSB		    0x19
+#define DS2760_EEPROM_BLOCK0	    0x20
+#define DS2760_ACTIVE_FULL	    0x20
+#define DS2760_EEPROM_BLOCK1	    0x30
+#define DS2760_RATED_CAPACITY	    0x32
+#define DS2760_CURRENT_OFFSET_BIAS  0x33
+#define DS2760_ACTIVE_EMPTY	    0x3b
+
+extern int w1_ds2760_read(struct device *dev, char *buf, int addr,
+                          size_t count);
+extern int w1_ds2760_write(struct device *dev, char *buf, int addr,
+                           size_t count);
+
+#endif /* !__w1_ds2760_h__ */
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 1e2ac40..ef1e1da 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -33,6 +33,7 @@
 #define W1_THERM_DS1822  	0x22
 #define W1_EEPROM_DS2433  	0x23
 #define W1_THERM_DS18B20 	0x28
+#define W1_FAMILY_DS2760	0x30
 
 #define MAXNAMELEN		32
 
-- 
1.5.1.1-dirty

