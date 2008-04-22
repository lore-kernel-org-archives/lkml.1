Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbYDVC0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbYDVC0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYDVC0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:26:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:39855 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYDVC0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:26:45 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 22:26:45 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,691,1199692800"; 
   d="scan'208";a="235767203"
Date: Tue, 22 Apr 2008 10:04:20 +0800
From: alek du <alek.du@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: khali@linux-fr.org
Subject: [PATCH 2/3] i2c: Add Intel SCH I2C SMBus support
Message-ID: <20080422100420.3ee5f150@dxy.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 02:17:03.0922 (UTC) FILETIME=[F491A920:01C8A41E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Intel SCH chipsets (US15W, US15L, UL11L) i2c bus support.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/i2c/busses/Kconfig   |    7 +
 drivers/i2c/busses/Makefile  |    1 +
 drivers/i2c/busses/i2c-sch.c |  419 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 427 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-sch.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 5fa9c3c..7aad5d1 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -244,6 +244,13 @@ config I2C_PIIX4
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-piix4.
 
+config I2C_SCH
+	tristate "Intel SCH SMBUS 1.0"
+	depends on I2C && PCI
+	help
+	  If you say Y or M to this option, support will be included for the
+	  Intel SCH based systems. Module will be called i2c-sch.ko.
+
 config I2C_IBM_IIC
 	tristate "IBM PPC 4xx on-chip I2C interface"
 	depends on IBM_OCP
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index ea7068f..3165bf9 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_I2C_PASEMI)	+= i2c-pasemi.o
 obj-$(CONFIG_I2C_PCA_ISA)	+= i2c-pca-isa.o
 obj-$(CONFIG_I2C_PIIX4)		+= i2c-piix4.o
 obj-$(CONFIG_I2C_PMCMSP)	+= i2c-pmcmsp.o
+obj-$(CONFIG_I2C_SCH)		+= i2c-sch.o
 obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
 obj-$(CONFIG_I2C_PROSAVAGE)	+= i2c-prosavage.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
diff --git a/drivers/i2c/busses/i2c-sch.c b/drivers/i2c/busses/i2c-sch.c
new file mode 100644
index 0000000..4293882
--- /dev/null
+++ b/drivers/i2c/busses/i2c-sch.c
@@ -0,0 +1,419 @@
+/*
+    i2c-sch.c - Part of lm_sensors, Linux kernel modules for hardware
+    monitoring
+    - Based on i2c-piix4.c
+    Copyright (c) 1998 - 2002 Frodo Looijaard <frodol@dds.nl> and
+    Philip Edelbrock <phil@netroedge.com>
+    - Intel SCH support
+    Copyright (c) 2007 - 2008 Jacob Jun Pan <jacob.jun.pan@intel.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License version 2 as
+    published by the Free Software Foundation.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+/*
+   Supports:
+	Intel SCH
+
+   Function i2c_sch_init and i2c_sch_exit are module init/exit entries, and
+   sch_probe will be called for device initialization, In probe, SCH i2c
+   adapter will be setup by sch_setup and added by i2c_add_adapter. sch_access
+   is the main entry for the i2c-sch bus.
+   Note: we assume there can only be one device, with one SMBus interface.
+*/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/stddef.h>
+#include <linux/sched.h>
+#include <linux/ioport.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/apm_bios.h>
+#include <linux/io.h>
+
+
+struct sd {
+	const unsigned short mfr;
+	const unsigned short dev;
+	const unsigned char fn;
+	const char *name;
+};
+/* SCH SMBus address offsets */
+#define SMBHSTCNT	(0 + sch_smba)
+#define SMBHSTSTS	(1 + sch_smba)
+#define SMBHSTADD	(4 + sch_smba) /* TSA */
+#define SMBHSTCMD	(5 + sch_smba)
+#define SMBHSTDAT0	(6 + sch_smba)
+#define SMBHSTDAT1	(7 + sch_smba)
+#define SMBBLKDAT	(0x20 + sch_smba)
+
+
+/* count for request_region */
+#define SMBIOSIZE	8
+
+/* PCI Address Constants */
+#define SMBBA_SCH	0x040
+
+/* Other settings */
+#define MAX_TIMEOUT	500
+#define  ENABLE_INT9	0
+
+/* I2C constants */
+#define SCH_QUICK		0x00
+#define SCH_BYTE		0x01
+#define SCH_BYTE_DATA		0x02
+#define SCH_WORD_DATA		0x03
+#define SCH_BLOCK_DATA	0x05
+
+/* insmod parameters */
+
+/* If force is set to anything different from 0, we forcibly enable the
+   SCH. DANGEROUS! */
+static int force;
+module_param(force, int, 0);
+MODULE_PARM_DESC(force, "Forcibly enable the I2C. DANGEROUS!");
+
+
+static int sch_transaction(void);
+
+static unsigned short sch_smba;
+static struct pci_driver sch_driver;
+static struct i2c_adapter sch_adapter;
+
+/*
+ * sch_probe will call this function to get SMBus base address
+ * sch_dev and id are the arguments from probe functions
+ * return 0 for success and -ENODEV for failure
+ */
+static int __devinit sch_setup(struct pci_dev *sch_dev,
+				const struct pci_device_id *id)
+{
+	unsigned short smbase;
+	if (sch_dev->device != PCI_DEVICE_ID_INTEL_SCH_LPC) {
+		/* match up the function */
+		if (PCI_FUNC(sch_dev->devfn) != id->driver_data)
+			return -ENODEV;
+		dev_info(&sch_dev->dev, "Found %s device\n", pci_name(sch_dev));
+	} else {
+		dev_info(&sch_dev->dev, "Found SCH SMBUS %s device\n",
+			pci_name(sch_dev));
+		/* find SMBUS base address */
+		pci_read_config_word(sch_dev, 0x40, &smbase);
+		dev_info(&sch_dev->dev, "SCH SM base = 0x%04x\n", smbase);
+	}
+
+
+	/* Determine the address of the SMBus areas */
+	if (sch_dev->device == PCI_DEVICE_ID_INTEL_SCH_LPC)
+		pci_read_config_word(sch_dev, SMBBA_SCH, &sch_smba);
+	else
+		sch_smba = 0;
+	sch_smba &= 0xfff0;
+	if (sch_smba == 0) {
+		dev_err(&sch_dev->dev, "SMB base address "
+			"uninitialized - upgrade BIOS or use "
+			"force_addr=0xaddr\n");
+		return -ENODEV;
+	}
+
+	if (!request_region(sch_smba, SMBIOSIZE, sch_driver.name)) {
+		dev_err(&sch_dev->dev, "SMB region 0x%x already in use!\n",
+			sch_smba);
+		return -ENODEV;
+	}
+
+	dev_dbg(&sch_dev->dev, "SMBA = 0x%X\n", sch_smba);
+
+	return 0;
+}
+
+/*
+ * Start the i2c transaction -- the i2c_access will prepare the transaction
+ * and this function will execute it.
+ * return 0 for success and others for failure.
+ */
+static int sch_transaction(void)
+{
+	int temp;
+	int result = 0;
+	int timeout = 0;
+
+	dev_dbg(&sch_adapter.dev, "Transaction (pre): CNT=%02x, CMD=%02x, "
+		"ADD=%02x, DAT0=%02x, DAT1=%02x\n", inb(SMBHSTCNT),
+		inb(SMBHSTCMD), inb(SMBHSTADD), inb(SMBHSTDAT0),
+		inb(SMBHSTDAT1));
+
+	/* Make sure the SMBus host is ready to start transmitting */
+	temp = inb(SMBHSTSTS);
+	if (temp) {
+		if (temp == 1) {
+			dev_dbg(&sch_adapter.dev, "Completion (%02x). "
+				"clear...\n", temp);
+			outb(temp, SMBHSTSTS);
+		} else if (temp & 0xe) {
+			dev_dbg(&sch_adapter.dev, "SMBus error (%02x). "
+				"Resetting...\n", temp);
+			outb(temp, SMBHSTSTS);
+		}
+		temp =  inb(SMBHSTSTS);
+		if (temp) {
+			dev_err(&sch_adapter.dev,
+				"SMBus is not ready: (%02x)\n", temp);
+			return -EPERM;
+		} else {
+			dev_dbg(&sch_adapter.dev, "Successfull!\n");
+		}
+	}
+
+	/* start the transaction by setting bit 4 */
+	outb(inb(SMBHSTCNT) | 0x10, SMBHSTCNT);
+
+	do {
+		msleep(1);
+		temp = inb(SMBHSTSTS);
+	} while ((temp & 0x08) && (timeout++ < MAX_TIMEOUT));
+
+	/* If the SMBus is still busy, we give up */
+	if (timeout >= MAX_TIMEOUT) {
+		dev_err(&sch_adapter.dev, "SMBus Timeout!\n");
+		result = -EPERM;
+	}
+
+	if (temp & 0x10) {
+		result = -EPERM;
+		dev_err(&sch_adapter.dev, "Error: Failed bus transaction\n");
+	}
+
+	if (temp & 0x08) {
+		result = -EPERM;
+		dev_dbg(&sch_adapter.dev, "Bus collision! SMBus may be "
+			"locked until next hard reset. (sorry!)\n");
+		/* Clock stops and slave is stuck in mid-transmission */
+	}
+
+	if (temp & 0x04) {
+		result = -EPERM;
+		dev_dbg(&sch_adapter.dev, "Error: no response!\n");
+	}
+	temp = inb(SMBHSTSTS);
+	if (temp) {
+		if (temp == 0x1) {
+			dev_dbg(&sch_adapter.dev, "post complete!\n");
+			outb(temp, SMBHSTSTS);
+		} else if (temp & 0xe) {
+			dev_dbg(&sch_adapter.dev, "Error: bus, etc!\n");
+			outb(inb(SMBHSTSTS), SMBHSTSTS);
+		}
+	}
+	msleep(1);
+	temp = inb(SMBHSTSTS);
+	if (temp & 0xe) {
+		/* BSY, device or bus error */
+		dev_err(&sch_adapter.dev, "Failed reset at end of "
+			"transaction (%02x), Bus error\n", temp);
+	}
+	dev_dbg(&sch_adapter.dev, "Transaction (post): CNT=%02x, CMD=%02x, "
+		"ADD=%02x, DAT0=%02x, DAT1=%02x\n", inb(SMBHSTCNT),
+		inb(SMBHSTCMD), inb(SMBHSTADD), inb(SMBHSTDAT0),
+		inb(SMBHSTDAT1));
+	return result;
+}
+
+/*
+ * This is the main access entry for i2c-sch access
+ * adap is i2c_adapter pointer, addr is the i2c device bus address, read_write
+ * (0 for read and 1 for write), size is i2c transaction type and data is the
+ * union of transaction for data to be transfered or data read from bus.
+ *
+ * return 0 for success and  others for failure.
+ */
+static s32 sch_access(struct i2c_adapter *adap, u16 addr,
+		 unsigned short flags, char read_write,
+		 u8 command, int size, union i2c_smbus_data *data)
+{
+	int i, len;
+	dev_dbg(&sch_adapter.dev, "access size: %d %s\n", size,
+		(read_write)?"READ":"WRITE");
+	switch (size) {
+	case I2C_SMBUS_PROC_CALL:
+		dev_err(&adap->dev, "I2C_SMBUS_PROC_CALL not supported!\n");
+		return -EPERM;
+	case I2C_SMBUS_QUICK:
+		outb(((addr & 0x7f) << 1) | (read_write & 0x01),
+		       SMBHSTADD);
+		size = SCH_QUICK;
+		break;
+	case I2C_SMBUS_BYTE:
+		outb(((addr & 0x7f) << 1) | (read_write & 0x01),
+		       SMBHSTADD);
+		if (read_write == I2C_SMBUS_WRITE)
+			outb(command, SMBHSTCMD);
+		size = SCH_BYTE;
+		break;
+	case I2C_SMBUS_BYTE_DATA:
+		outb(((addr & 0x7f) << 1) | (read_write & 0x01),
+		       SMBHSTADD);
+		outb(command, SMBHSTCMD);
+		if (read_write == I2C_SMBUS_WRITE)
+			outb(data->byte, SMBHSTDAT0);
+		size = SCH_BYTE_DATA;
+		break;
+	case I2C_SMBUS_WORD_DATA:
+		outb(((addr & 0x7f) << 1) | (read_write & 0x01),
+		       SMBHSTADD);
+		outb(command, SMBHSTCMD);
+		if (read_write == I2C_SMBUS_WRITE) {
+			outb(data->word & 0xff, SMBHSTDAT0);
+			outb((data->word & 0xff00) >> 8, SMBHSTDAT1);
+		}
+		size = SCH_WORD_DATA;
+		break;
+	case I2C_SMBUS_BLOCK_DATA:
+		outb(((addr & 0x7f) << 1) | (read_write & 0x01),
+		       SMBHSTADD);
+		outb(command, SMBHSTCMD);
+		if (read_write == I2C_SMBUS_WRITE) {
+			len = data->block[0];
+			if (len < 0)
+				len = 0;
+			if (len > 32)
+				len = 32;
+			outb(len, SMBHSTDAT0);
+			i = inb(SMBHSTCNT);	/* Reset SMBBLKDAT */
+			for (i = 1; i <= len; i++)
+				outb(data->block[i], SMBBLKDAT);
+		}
+		size = SCH_BLOCK_DATA;
+		break;
+	}
+	dev_dbg(&sch_adapter.dev, "write size %d to 0x%04x\n", size, SMBHSTCNT);
+	outb((size & 0x7), SMBHSTCNT);
+
+	if (sch_transaction())	/* Error in transaction */
+		return -EPERM;
+
+	if ((read_write == I2C_SMBUS_WRITE) || (size == SCH_QUICK))
+		return 0;
+
+
+	switch (size) {
+	case SCH_BYTE:
+		/* Where is the result put? I assume here it is in
+		   SMBHSTDAT0 but it might just as well be in the
+		   SMBHSTCMD. No clue in the docs */
+		data->byte = inb(SMBHSTDAT0);
+		break;
+	case SCH_BYTE_DATA:
+		data->byte = inb(SMBHSTDAT0);
+		break;
+	case SCH_WORD_DATA:
+		data->word = inb(SMBHSTDAT0) + (inb(SMBHSTDAT1) << 8);
+		break;
+	case SCH_BLOCK_DATA:
+		data->block[0] = inb(SMBHSTDAT0);
+		i = inb(SMBHSTCNT);	/* Reset SMBBLKDAT */
+		for (i = 1; i <= data->block[0]; i++)
+			data->block[i] = inb(SMBBLKDAT);
+		break;
+	}
+	return 0;
+}
+
+static u32 sch_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
+	    I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
+	    I2C_FUNC_SMBUS_BLOCK_DATA;
+}
+
+static const struct i2c_algorithm smbus_algorithm = {
+	.smbus_xfer	= sch_access,
+	.functionality	= sch_func,
+};
+
+static struct i2c_adapter sch_adapter = {
+	.owner		= THIS_MODULE,
+	.class		= I2C_CLASS_HWMON,
+	.algo		= &smbus_algorithm,
+};
+
+static struct pci_device_id sch_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC),
+	  .driver_data = 0xf8 },
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, sch_ids);
+
+static int __devinit sch_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
+{
+	int retval;
+	retval = sch_setup(dev, id);
+	if (retval)
+		return retval;
+
+	/* set up the driverfs linkage to our parent device */
+	sch_adapter.dev.parent = &dev->dev;
+
+	snprintf(sch_adapter.name, I2C_NAME_SIZE,
+		"SMBus SCH adapter at %04x", sch_smba);
+
+	retval = i2c_add_adapter(&sch_adapter);
+	if (retval) {
+		dev_err(&dev->dev, "Couldn't register adapter!\n");
+		release_region(sch_smba, SMBIOSIZE);
+		sch_smba = 0;
+	}
+
+	return retval;
+}
+
+static void __devexit sch_remove(struct pci_dev *dev)
+{
+	if (sch_smba) {
+		i2c_del_adapter(&sch_adapter);
+		release_region(sch_smba, SMBIOSIZE);
+		sch_smba = 0;
+	}
+}
+
+static struct pci_driver sch_driver = {
+	.name		= "sch_smbus",
+	.id_table	= sch_ids,
+	.probe		= sch_probe,
+	.remove		= __devexit_p(sch_remove),
+};
+
+static int __init i2c_sch_init(void)
+{
+	return pci_register_driver(&sch_driver);
+}
+
+static void __exit i2c_sch_exit(void)
+{
+	pci_unregister_driver(&sch_driver);
+}
+
+MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
+		"Philip Edelbrock <phil@netroedge.com> and "
+		"Jacob Pan <jacob.jun.pan@intel.com> ");
+MODULE_DESCRIPTION("Intel SCH SMBus driver");
+MODULE_LICENSE("GPL");
+
+module_init(i2c_sch_init);
+module_exit(i2c_sch_exit);
-- 
1.5.2.5
