Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZHGRBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZHGRBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZHGRBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:01:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:61030 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbZHGRBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:01:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,342,1246863600"; 
   d="scan'208";a="481684903"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, alan@linux.intel.com, greg@kroah.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Upstream revion 4 for RAR Register; include changes due to debugging July 7, 2009
Date: Fri,  7 Aug 2009 10:02:15 -0700
Message-Id: <1249664535-29690-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 For the upstream community, this is revision 3. Changes are the
 relocation of this driver to the staging area and add TODO file

 This is the Linux driver for the restricted access memory
 region control registers. The restricted access memory
 regions are regions of memory on the MID platform that
 are configured so that they cannot be accessed by processes 
 running on the main x86 system processor. They can only be
 accessed by dedicated system peripherals.

 Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

 Date: August 7, 2009

---
 drivers/staging/Kconfig                     |    2 +
 drivers/staging/Makefile                    |    1 +
 drivers/staging/rar_register/Kconfig        |   15 +
 drivers/staging/rar_register/Makefile       |    3 +
 drivers/staging/rar_register/rar_register.c |  551 +++++++++++++++++++++++++++
 include/linux/rar/rar_register.h            |   68 ++++
 6 files changed, 640 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/rar_register/Kconfig
 create mode 100644 drivers/staging/rar_register/Makefile
 create mode 100644 drivers/staging/rar_register/rar_register.c
 create mode 100644 include/linux/rar/rar_register.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 348bf61..5294008 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -129,5 +129,7 @@ source "drivers/staging/pata_rdc/Kconfig"
 
 source "drivers/staging/udlfb/Kconfig"
 
+source "drivers/staging/rar_register/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 8d61d7b..929dbf7 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -46,3 +46,4 @@ obj-$(CONFIG_VT6655)		+= vt6655/
 obj-$(CONFIG_USB_CPC)		+= cpc-usb/
 obj-$(CONFIG_RDC_17F3101X)	+= pata_rdc/
 obj-$(CONFIG_FB_UDL)		+= udlfb/
+obj-$(CONFIG_RAR_REGISTER)	+= rar_register/
diff --git a/drivers/staging/rar_register/Kconfig b/drivers/staging/rar_register/Kconfig
new file mode 100644
index 0000000..e951162
--- /dev/null
+++ b/drivers/staging/rar_register/Kconfig
@@ -0,0 +1,15 @@
+#
+# Serial device configuration
+#
+
+menu "RAR Register Driver"
+
+config RAR_REGISTER
+	tristate "Intel Restricted Access Region Register Driver"
+	depends on MRST
+	default y
+	---help---
+		This driver allows other kernel drivers access to the
+		contents of the restricted access region registers. 
+
+endmenu
diff --git a/drivers/staging/rar_register/Makefile b/drivers/staging/rar_register/Makefile
new file mode 100644
index 0000000..63ba70e
--- /dev/null
+++ b/drivers/staging/rar_register/Makefile
@@ -0,0 +1,3 @@
+EXTRA_CFLAGS += -DLITTLE__ENDIAN 
+obj-$(CONFIG_RAR_REGISTER) += rar_register.o
+rar_register_driver-objs := rar_register.o
diff --git a/drivers/staging/rar_register/rar_register.c b/drivers/staging/rar_register/rar_register.c
new file mode 100644
index 0000000..ec44d7d
--- /dev/null
+++ b/drivers/staging/rar_register/rar_register.c
@@ -0,0 +1,551 @@
+/*
+ *  rar_register.c - An Intel Restricted Access Region register driver
+ *
+ *  Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License as
+ *  published by the Free Software Foundation; either version 2 of the
+ *  License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
+ *  02111-1307, USA.
+ *
+ * -------------------------------------------------------------------
+ *
+ *  20090806 Ossama Othman <ossama.othman@intel.com>
+ *      Return zero high address if upper 22 bits is zero.
+ *      Cleaned up checkpatch errors.
+ *      Clarified that driver is dealing with bus addresses.
+ *
+ *  20090702 Ossama Othman <ossama.othman@intel.com>
+ *      Removed unnecessary include directives
+ *      Cleaned up spinlocks.
+ *      Cleaned up logging.
+ *      Improved invalid parameter checks.
+ *      Fixed and simplified RAR address retrieval and RAR locking
+ *      code.
+ *
+ *  20090626 Mark Allyn <mark.a.allyn@intel.com>
+ *      Initial publish
+ */
+
+#include <linux/rar/rar_register.h>
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+
+
+/* PCI vendor id for controller */
+#define VENDOR_ID 0x8086
+
+/* PCI device id for controller */
+#define DEVICE_ID 0x4110
+
+
+/* === Lincroft Message Bus Interface === */
+/* Message Control Register */
+#define LNC_MCR_OFFSET 0xD0
+
+/* Message Data Register */
+#define LNC_MDR_OFFSET 0xD4
+
+/* Message Opcodes */
+#define LNC_MESSAGE_READ_OPCODE  0xD0
+#define LNC_MESSAGE_WRITE_OPCODE 0xE0
+
+/* Message Write Byte Enables */
+#define LNC_MESSAGE_BYTE_WRITE_ENABLES 0xF
+
+/* B-unit Port */
+#define LNC_BUNIT_PORT 0x3
+
+/* === Lincroft B-Unit Registers - Programmed by IA32 firmware === */
+#define LNC_BRAR0L  0x10
+#define LNC_BRAR0H  0x11
+#define LNC_BRAR1L  0x12
+#define LNC_BRAR1H  0x13
+
+/* Reserved for SeP */
+#define LNC_BRAR2L  0x14
+#define LNC_BRAR2H  0x15
+
+
+
+static DEFINE_SPINLOCK(rar_spinlock_lock);
+unsigned long rar_flags;
+
+static DEFINE_SPINLOCK(lnc_reg_lock);
+unsigned long lnc_reg_flags;
+
+/* RAR Bus Address Range */
+struct RAR_address_range {
+	u32 low;
+	u32 high;
+};
+
+/* Structure containing low and high RAR register offsets. */
+struct RAR_offsets {
+	u32 low;  /* Register offset for low  RAR bus address. */
+	u32 high; /* Register offset for high RAR bus address. */
+};
+
+static struct RAR_offsets const rar_offsets[] = {
+	{ LNC_BRAR0L, LNC_BRAR0H },
+	{ LNC_BRAR1L, LNC_BRAR1H },
+	{ LNC_BRAR2L, LNC_BRAR2H }
+};
+
+static struct pci_dev *rar_dev;
+static u32 registered;
+
+/* Moorestown supports three restricted access regions. */
+#define MRST_NUM_RAR 3
+
+static struct RAR_address_range rar_addr[MRST_NUM_RAR];
+
+/* prototype for init */
+static int __init rar_init_handler(void);
+static void __exit rar_exit_handler(void);
+
+const struct pci_device_id rar_pci_id_tbl[] = {
+	{ PCI_DEVICE(VENDOR_ID, DEVICE_ID) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, rar_pci_id_tbl);
+
+/*
+ * Function that is activated on the succesful probe of the RAR
+ * device (Moorestown host controller).
+ */
+static int rar_probe(struct pci_dev *dev, const struct pci_device_id *id);
+
+/* field for registering driver to PCI device */
+static struct pci_driver rar_pci_driver = {
+	.name = "rar_register",
+	.id_table = rar_pci_id_tbl,
+	.probe = rar_probe
+};
+
+const struct pci_device_id *my_id_table = rar_pci_id_tbl;
+
+/*
+ * This function is used to retrieved RAR info using the Lincroft
+ * message bus interface.
+ */
+static int memrar_get_rar_addr(struct pci_dev *pdev,
+			       int offset,
+			       u32 *addr)
+{
+	/*
+	 * ======== The Lincroft Message Bus Interface ========
+	 * Lincroft registers may be obtained from the PCI
+	 * (the Host Bridge) using the Lincroft Message Bus
+	 * Interface.  That message bus interface is generally
+	 * comprised of two registers: a control register (MCR, 0xDO)
+	 * and a data register (MDR, 0xD4).
+	 *
+	 * The MCR (message control register) format is the following:
+	 *   1.  [31:24]: Opcode
+	 *   2.  [23:16]: Port
+	 *   3.  [15:8]: Register Offset
+	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
+	 *              to 1)
+	 *   5.  [3:0]: reserved
+	 *
+	 *  Read (0xD0) and write (0xE0) opcodes are written to the
+	 *  control register when reading and writing to Lincroft
+	 *  registers, respectively.
+	 *
+	 *  We're interested in registers found in the Lincroft
+	 *  B-unit.  The B-unit port is 0x3.
+	 *
+	 *  The six B-unit RAR register offsets we use are listed
+	 *  earlier in this file.
+	 *
+	 *  Lastly writing to the MCR register requires the "Byte
+	 *  enables" bits to be set to 1.  This may be achieved by
+	 *  writing 0xF at bit 4.
+	 *
+	 * The MDR (message data register) format is the following:
+	 *   1. [31:0]: Read/Write Data
+	 *
+	 *  Data being read from this register is only available after
+	 *  writing the appropriate control message to the MCR
+	 *  register.
+	 *
+	 *  Data being written to this register must be written before
+	 *  writing the appropriate control message to the MCR
+	 *  register.
+	 */
+
+	int result;
+
+	/* Construct control message */
+	u32 const message =
+		(LNC_MESSAGE_READ_OPCODE << 24)
+		| (LNC_BUNIT_PORT << 16)
+		| (offset << 8)
+		| (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
+
+	dev_dbg(&pdev->dev, "Offset for 'get' LNC MSG is %x\n", offset);
+
+	if (addr == 0) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&lnc_reg_lock, lnc_reg_flags);
+
+	/* Send the control message */
+	result = pci_write_config_dword(pdev,
+					LNC_MCR_OFFSET,
+					message);
+
+	dev_dbg(&pdev->dev,
+		"Result from send ctl register is %x\n",
+		result);
+
+	if (!result) {
+		result = pci_read_config_dword(pdev,
+					       LNC_MDR_OFFSET,
+					       addr);
+
+		dev_dbg(&pdev->dev,
+			"Result from read data register is %x\n",
+			result);
+
+		dev_dbg(&pdev->dev,
+			"Value read from data register is %x\n",
+			*addr);
+	}
+
+	spin_unlock_irqrestore(&lnc_reg_lock, lnc_reg_flags);
+
+	return result;
+}
+
+static int memrar_set_rar_addr(struct pci_dev *pdev,
+			       int offset,
+			       u32 addr)
+{
+	/*
+	 *  Data being written to this register must be written before
+	 *  writing the appropriate control message to the MCR
+	 *  register.
+	 *
+	 *  @note See memrar_get_rar_addr() for a description of the
+	 *        message bus interface being used here.
+	 */
+
+	int result = 0;
+
+	/* Construct control message */
+	u32 const message =
+	       (LNC_MESSAGE_WRITE_OPCODE << 24)
+	       | (LNC_BUNIT_PORT << 16)
+	       | (offset << 8)
+	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
+
+	if (addr == 0) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&lnc_reg_lock, lnc_reg_flags);
+
+	dev_dbg(&pdev->dev,
+		"Offset for 'set' LNC MSG is %x\n", offset);
+
+	/* Send the control message */
+	result = pci_write_config_dword(pdev,
+					LNC_MDR_OFFSET,
+					addr);
+
+	dev_dbg(&pdev->dev,
+		"Result from write data register is %x\n",
+		result);
+
+	if (!result) {
+		dev_dbg(&pdev->dev,
+			"Value written to data register is %x\n",
+			addr);
+
+		result = pci_write_config_dword(pdev,
+						LNC_MCR_OFFSET,
+						message);
+
+		dev_dbg(&pdev->dev,
+			"Result from send ctl register is %x\n",
+			result);
+	}
+
+	spin_unlock_irqrestore(&lnc_reg_lock, lnc_reg_flags);
+
+	return result;
+}
+
+/*
+ * Initialize RAR parameters, such as bus addresses, etc.
+ */
+static int memrar_init_rar_params(struct pci_dev *pdev)
+{
+	size_t const num_offsets = ARRAY_SIZE(rar_offsets);
+	struct RAR_offsets const *end = rar_offsets + num_offsets;
+	struct RAR_offsets const *i;
+	struct pci_dev *my_pdev;
+	unsigned int n = 0;
+	int result = 0;
+
+	/* Retrieve RAR start and end bus addresses. */
+
+	/*
+	 * Access the RAR registers through the Lincroft Message Bus
+	 * Interface on PCI device: 00:00.0 Host bridge.
+	 */
+
+	/* struct pci_dev *pdev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0)); */
+
+	my_pdev = pci_dev_get(pdev);
+
+	if (my_pdev == NULL) {
+		WARN_ON(1);
+		return -ENODEV;
+	}
+
+	for (i = rar_offsets; i != end; ++i, ++n) {
+		if (memrar_get_rar_addr(my_pdev,
+					i->low,
+					&(rar_addr[n].low)) != 0
+		    || memrar_get_rar_addr(my_pdev,
+					   i->high,
+					   &(rar_addr[n].high)) != 0) {
+			result = -1;
+			break;
+		}
+
+		/*
+		 * Only the upper 22 bits of the RAR addresses are
+		 * stored in their corresponding RAR registers so we
+		 * must set the lower 10 bits accordingly.
+		 *
+		 * The low address has its lower 10 bits cleared, and
+		 * the high address has all its lower 10 bits set,
+		 * e.g.:
+		 *
+		 *   low = 0x2ffffc00
+		 *  high = 0x3fffffff
+		 *
+		 * This is not arbitrary, and is actually how RAR
+		 * addressing/configuration works.
+		 */
+		rar_addr[n].low  &= 0xfffffc00u;  /* Clear bits 9:0 */
+
+		/*
+		 * Set bits 9:0 if the 1 KiB aligned (the upper 22
+		 * bits) high address is non-zero.
+		 *
+		 * Otherwise set all bits to zero since that indicates
+		 * no RAR address is configured.
+		 */
+		if ((rar_addr[n].high & 0xfffffc00u) == 0)
+			rar_addr[n].high = 0;
+		else
+			rar_addr[n].high |= 0x3ffu;
+	}
+
+	/* Done accessing the device. */
+	/* pci_dev_put(pdev); */
+
+	if (result == 0) {
+		size_t z;
+		for (z = 0; z != MRST_NUM_RAR; ++z) {
+			/*
+			 * "BRAR" refers to the RAR registers in the
+			 * Lincroft B-unit.
+			 */
+			dev_info(&pdev->dev,
+				 "BRAR[%u] bus address range = "
+				 "[0x%08x, 0x%08x]\n",
+				 z,
+				 rar_addr[z].low,
+				 rar_addr[z].high);
+		}
+	}
+
+	return result;
+}
+
+/*
+ * This function registers the driver with the device subsystem (
+ * either PCI, USB, etc).
+*/
+static int __init rar_init_handler(void)
+{
+	return pci_register_driver(&rar_pci_driver);
+}
+
+static void __exit rar_exit_handler(void)
+{
+	pci_unregister_driver(&rar_pci_driver);
+}
+
+module_init(rar_init_handler);
+module_exit(rar_exit_handler);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Intel Restricted Access Region Register Driver");
+
+/*
+ * Function that is activaed on the succesful probe of the RAR device
+ * (Moorestown host controller).
+ */
+int rar_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	int error;
+	registered = 0;
+
+	dev_dbg(&dev->dev,
+		"PCI probe starting\n");
+
+	/* enable the device */
+	error = pci_enable_device(dev);
+	if (error) {
+		dev_err(&dev->dev,
+			"Error enabling RAR register PCI device\n");
+		goto end_function;
+	}
+
+	/*
+	 * Initialize the RAR parameters, which have to be retrieved */
+	/* via the message bus interface.
+	 */
+	error = memrar_init_rar_params(dev);
+	if (error) {
+		pci_disable_device(dev);
+
+		dev_err(&dev->dev,
+			"Error retrieving RAR addresses\n");
+
+		goto end_function;
+	}
+
+	rar_dev = dev;
+	registered = 1;
+
+end_function:
+
+	return error;
+}
+
+
+/*
+ * The rar_get_address function is used by other device drivers
+ * to obtain RAR address information on a RAR. It takes three
+ * parameters:
+ *
+ * int rar_index
+ * The rar_index is an index to the rar for which you wish to retrieve
+ * the address information.
+ * Values can be 0,1, or 2.
+ *
+ * The function returns a 0 upon success or a -1 if there is no RAR
+ * facility on this system.
+ */
+int rar_get_address(int rar_index,
+		    u32 *start_address,
+		    u32 *end_address)
+{
+	int result = -ENODEV;
+
+	if (registered) {
+		if (start_address == 0
+		    || end_address == 0
+		    || rar_index >= MRST_NUM_RAR
+		    || rar_index < 0) {
+			result = -EINVAL;
+		} else {
+			*start_address = rar_addr[rar_index].low;
+			*end_address   = rar_addr[rar_index].high;
+			result = 0;
+		}
+	}
+
+	return result;
+}
+EXPORT_SYMBOL(rar_get_address);
+
+/*
+ * The rar_lock function is ued by other device drivers to lock an RAR.
+ * once an RAR is locked, it stays locked until the next system reboot.
+ * The function takes one parameter:
+ *
+ * int rar_index
+ * The rar_index is an index to the rar that you want to lock.
+ * Values can be 0,1, or 2.
+ *
+ * The function returns a 0 upon success or a -1 if there is no RAR
+ * facility on this system.
+ */
+int rar_lock(int rar_index)
+{
+	int result = -ENODEV;
+
+	if  (rar_index >= MRST_NUM_RAR || rar_index < 0) {
+		result = -EINVAL;
+		goto exit_rar_lock;
+	}
+
+	spin_lock_irqsave(&rar_spinlock_lock, rar_flags);
+
+	if (registered)	{
+		/*
+		 * Clear bits 4:0 in low register to lock.
+		 * Clear bits 8,4:0 in high register to lock.
+		 *
+		 * The rest of the lower 10 bits in both registers are
+		 * unused so we might as well clear them all.
+		 */
+		u32 const low  = rar_addr[rar_index].low  & 0xfffffc00u;
+		u32 const high = rar_addr[rar_index].high & 0xfffffc00u;
+
+		/*
+		 * Now program the register using the Lincroft message
+		 * bus interface.
+		 */
+		result = memrar_set_rar_addr(rar_dev,
+					     rar_offsets[rar_index].low,
+					     low);
+
+		if (result == 0)
+			result =
+				memrar_set_rar_addr(
+					rar_dev,
+					rar_offsets[rar_index].high,
+					high);
+	}
+
+	spin_unlock_irqrestore(&rar_spinlock_lock, rar_flags);
+
+exit_rar_lock:
+
+	return result;
+}
+EXPORT_SYMBOL(rar_lock);
+
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
diff --git a/include/linux/rar/rar_register.h b/include/linux/rar/rar_register.h
new file mode 100644
index 0000000..21b9560
--- /dev/null
+++ b/include/linux/rar/rar_register.h
@@ -0,0 +1,68 @@
+/*
+ *      Copyright (C) 2008, 2009 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ */
+
+
+#ifndef _RAR_REGISTER_H
+#define _RAR_REGISTER_H
+
+# include <linux/types.h>
+
+
+/* The get_rar_address function is used by other device drivers
+ * to obtain RAR address information on a RAR. It takes two
+ * parameter:
+ *
+ * int rar_index
+ * The rar_index is an index to the rar for which you wish to retrieve
+ * the address information.
+ * Values can be 0,1, or 2.
+ *
+ * struct RAR_address_struct is a pointer to a place to which the function
+ * can return the address structure for the RAR.
+ *
+ * The function returns a 0 upon success or a -1 if there is no RAR
+ * facility on this system.
+ */
+int rar_get_address(int rar_index,
+		    u32 *start_address,
+		    u32 *end_address);
+
+
+/* The lock_rar function is ued by other device drivers to lock an RAR.
+ * once an RAR is locked, it stays locked until the next system reboot.
+ * The function takes one parameter:
+ *
+ * int rar_index
+ * The rar_index is an index to the rar that you want to lock.
+ * Values can be 0,1, or 2.
+ *
+ * The function returns a 0 upon success or a -1 if there is no RAR
+ * facility on this system.
+ */
+int rar_lock(int rar_index);
+
+
+#endif  /* _RAR_REGISTER_H */
+
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
-- 
1.6.0.6

