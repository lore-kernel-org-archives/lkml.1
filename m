Return-Path: <linux-kernel-owner+w=401wt.eu-S933288AbZJFUpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbZJFUpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbZJFUpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:45:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:25817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797AbZJFUps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:45:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,514,1249282800"; 
   d="scan'208";a="500448442"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, alan@linux.intel.com, greg@kroah.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Changes to integrate RAR with SEP and fix RAR problems
Date: Tue,  6 Oct 2009 13:45:53 -0700
Message-Id: <1254861953-18099-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SEP stands for Security Processor; a dedicated processor
that does encryption, decryption, key management, and
secure storage.

RAR stands for Restricted Access Region; this is memory
aboard the MID platform that is restricted (via hardware)
from access by software running on the x86 processor.
Dedicated 'smart' peripherals such as sound, video, and
encryption can access these regions of memory. They are here
to help protect copyrighted midia from being illegally copied.

This is upstream revision 4 of the RAR driver.

This is a patch referenced from the linux-next repository
as pulled on October 6, 2009; from the following URL:

git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

This is a modified RAR driver to include integration with
the SEP driver

Plese be aware that the SEP driver requires this driver
in order to compile and run. There are API function calls
within this driver that are required by the SEP driver.

Other drivers being developed in the future will also 
require this driver.

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Date: October 06, 2009

 drivers/staging/Kconfig                       |    2 +-
 drivers/staging/Makefile                      |    2 +-
 drivers/staging/rar/Kconfig                   |   17 -
 drivers/staging/rar/Makefile                  |    2 -
 drivers/staging/rar/rar_driver.c              |  444 ---
 drivers/staging/rar/rar_driver.h              |   99 -
 drivers/staging/rar_register/Kconfig          |   15 +
 drivers/staging/rar_register/Makefile         |    3 +
 drivers/staging/rar_register/rar_register.c   |  661 +++++
 include/linux/rar/memrar.h                    |  172 ++
 include/linux/rar/rar_register.h              |   79 +
 delete mode 100644 drivers/staging/rar/Kconfig
 delete mode 100644 drivers/staging/rar/Makefile
 delete mode 100644 drivers/staging/rar/rar_driver.c
 delete mode 100644 drivers/staging/rar/rar_driver.h
 create mode 100644 drivers/staging/rar_register/Kconfig
 create mode 100644 drivers/staging/rar_register/Makefile
 create mode 100644 drivers/staging/rar_register/rar_register.c
 create mode 100644 include/linux/rar/memrar.h
 create mode 100644 include/linux/rar/rar_register.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index ab64971..bacac81 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -121,7 +121,7 @@ source "drivers/staging/hv/Kconfig"
 
 source "drivers/staging/vme/Kconfig"
 
-source "drivers/staging/rar/Kconfig"
+source "drivers/staging/rar_register/Kconfig"
 
 source "drivers/staging/sep/Kconfig"
 
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index baffd0e..cf14e56 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -42,7 +42,7 @@ obj-$(CONFIG_VT6656)		+= vt6656/
 obj-$(CONFIG_FB_UDL)		+= udlfb/
 obj-$(CONFIG_HYPERV)		+= hv/
 obj-$(CONFIG_VME_BUS)		+= vme/
-obj-$(CONFIG_RAR_REGISTER)	+= rar/
+obj-$(CONFIG_RAR_REGISTER)	+= rar_register/
 obj-$(CONFIG_DX_SEP)		+= sep/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_COWLOOP)		+= cowloop/
diff --git a/drivers/staging/rar/Kconfig b/drivers/staging/rar/Kconfig
deleted file mode 100644
index 17f8bf3..0000000
--- a/drivers/staging/rar/Kconfig
+++ /dev/null
@@ -1,17 +0,0 @@
-#
-# RAR device configuration
-#
-
-menu "RAR Register Driver"
-#
-#	Restricted Access Register Manager
-#
-config RAR_REGISTER
-	tristate "Restricted Access Region Register Driver"
-	default n
-	---help---
-		This driver allows other kernel drivers access to the
-		contents of the restricted access region control
-		registers.
-
-endmenu
diff --git a/drivers/staging/rar/Makefile b/drivers/staging/rar/Makefile
deleted file mode 100644
index 5422ed0..0000000
--- a/drivers/staging/rar/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-EXTRA_CFLAGS += -DLITTLE__ENDIAN
-obj-$(CONFIG_RAR_REGISTER) += rar_driver.o
diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
deleted file mode 100644
index 9805d74..0000000
--- a/drivers/staging/rar/rar_driver.c
+++ /dev/null
@@ -1,444 +0,0 @@
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <linux/kdev_t.h>
-#include <linux/semaphore.h>
-#include <linux/mm.h>
-#include <linux/poll.h>
-#include <linux/wait.h>
-#include <linux/ioctl.h>
-#include <linux/ioport.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/pagemap.h>
-#include <linux/pci.h>
-#include <linux/firmware.h>
-#include <linux/sched.h>
-#include "rar_driver.h"
-
-/* The following defines are for the IPC process to retrieve RAR in */
-
-/* === Lincroft Message Bus Interface === */
-/* Message Control Register */
-#define LNC_MCR_OFFSET 0xD0
-
-/* Message Data Register */
-#define LNC_MDR_OFFSET 0xD4
-
-/* Message Opcodes */
-#define LNC_MESSAGE_READ_OPCODE  0xD0
-#define LNC_MESSAGE_WRITE_OPCODE 0xE0
-
-/* Message Write Byte Enables */
-#define LNC_MESSAGE_BYTE_WRITE_ENABLES 0xF
-
-/* B-unit Port */
-#define LNC_BUNIT_PORT 0x3
-
-/* === Lincroft B-Unit Registers - Programmed by IA32 firmware === */
-#define LNC_BRAR0L  0x10
-#define LNC_BRAR0H  0x11
-#define LNC_BRAR1L  0x12
-#define LNC_BRAR1H  0x13
-
-/* Reserved for SeP */
-#define LNC_BRAR2L  0x14
-#define LNC_BRAR2H  0x15
-
-
-/* This structure is only used during module initialization. */
-struct RAR_offsets {
-	int low; /* Register offset for low RAR physical address. */
-	int high; /* Register offset for high RAR physical address. */
-};
-
-struct pci_dev *rar_dev;
-static uint32_t registered;
-
-/* Moorestown supports three restricted access regions. */
-#define MRST_NUM_RAR 3
-
-struct RAR_address_struct rar_addr[MRST_NUM_RAR];
-
-/* prototype for init */
-static int __init rar_init_handler(void);
-static void __exit rar_exit_handler(void);
-
-/*
-  function that is activated on the succesfull probe of the RAR device
-*/
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
-
-static struct pci_device_id rar_pci_id_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, rar_pci_id_tbl);
-
-/* field for registering driver to PCI device */
-static struct pci_driver rar_pci_driver = {
-	.name = "rar_driver",
-	.id_table = rar_pci_id_tbl,
-	.probe = rar_probe
-};
-
-/* This function is used to retrieved RAR info using the IPC message
-   bus interface */
-static int memrar_get_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 *addr)
-{
-	/*
-	 * ======== The Lincroft Message Bus Interface ========
-	 * Lincroft registers may be obtained from the PCI
-	 * (the Host Bridge) using the Lincroft Message Bus
-	 * Interface.  That message bus interface is generally
-	 * comprised of two registers: a control register (MCR, 0xDO)
-	 * and a data register (MDR, 0xD4).
-	 *
-	 * The MCR (message control register) format is the following:
-	 *   1.  [31:24]: Opcode
-	 *   2.  [23:16]: Port
-	 *   3.  [15:8]: Register Offset
-	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
-	 *              to 1)
-	 *   5.  [3:0]: reserved
-	 *
-	 *  Read (0xD0) and write (0xE0) opcodes are written to the
-	 *  control register when reading and writing to Lincroft
-	 *  registers, respectively.
-	 *
-	 *  We're interested in registers found in the Lincroft
-	 *  B-unit.  The B-unit port is 0x3.
-	 *
-	 *  The six B-unit RAR register offsets we use are listed
-	 *  earlier in this file.
-	 *
-	 *  Lastly writing to the MCR register requires the "Byte
-	 *  enables" bits to be set to 1.  This may be achieved by
-	 *  writing 0xF at bit 4.
-	 *
-	 * The MDR (message data register) format is the following:
-	 *   1. [31:0]: Read/Write Data
-	 *
-	 *  Data being read from this register is only available after
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 *
-	 *  Data being written to this register must be written before
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 */
-
-	int result = 0; /* result */
-	/* Construct control message */
-	u32 const message =
-	       (LNC_MESSAGE_READ_OPCODE << 24)
-	       | (LNC_BUNIT_PORT << 16)
-	       | (offset << 8)
-	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
-
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
-
-	if (addr == 0)
-		return -EINVAL;
-
-	/* Send the control message */
-	result = pci_write_config_dword(pdev,
-	                          LNC_MCR_OFFSET,
-	                          message);
-
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
-
-	if (!result)
-		result = pci_read_config_dword(pdev,
-		                              LNC_MDR_OFFSET,
-				              addr);
-
-	printk(KERN_WARNING "rar- result from read data register is %x\n",
-	  result);
-
-	printk(KERN_WARNING "rar- value read from data register is %x\n",
-	  *addr);
-
-	if (result)
-		return -1;
-	else
-		return 0;
-}
-
-static int memrar_set_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 addr)
-{
-	/*
-	 * ======== The Lincroft Message Bus Interface ========
-	 * Lincroft registers may be obtained from the PCI
-	 * (the Host Bridge) using the Lincroft Message Bus
-	 * Interface.  That message bus interface is generally
-	 * comprised of two registers: a control register (MCR, 0xDO)
-	 * and a data register (MDR, 0xD4).
-	 *
-	 * The MCR (message control register) format is the following:
-	 *   1.  [31:24]: Opcode
-	 *   2.  [23:16]: Port
-	 *   3.  [15:8]: Register Offset
-	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
-	 *              to 1)
-	 *   5.  [3:0]: reserved
-	 *
-	 *  Read (0xD0) and write (0xE0) opcodes are written to the
-	 *  control register when reading and writing to Lincroft
-	 *  registers, respectively.
-	 *
-	 *  We're interested in registers found in the Lincroft
-	 *  B-unit.  The B-unit port is 0x3.
-	 *
-	 *  The six B-unit RAR register offsets we use are listed
-	 *  earlier in this file.
-	 *
-	 *  Lastly writing to the MCR register requires the "Byte
-	 *  enables" bits to be set to 1.  This may be achieved by
-	 *  writing 0xF at bit 4.
-	 *
-	 * The MDR (message data register) format is the following:
-	 *   1. [31:0]: Read/Write Data
-	 *
-	 *  Data being read from this register is only available after
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 *
-	 *  Data being written to this register must be written before
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 */
-
-	int result = 0; /* result */
-
-	/* Construct control message */
-	u32 const message =
-	       (LNC_MESSAGE_WRITE_OPCODE << 24)
-	       | (LNC_BUNIT_PORT << 16)
-	       | (offset << 8)
-	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
-
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
-
-	if (addr == 0)
-		return -EINVAL;
-
-	/* Send the control message */
-	result = pci_write_config_dword(pdev,
-	                          LNC_MDR_OFFSET,
-	                          addr);
-
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
-
-	if (!result)
-		result = pci_write_config_dword(pdev,
-		                              LNC_MCR_OFFSET,
-				              message);
-
-	printk(KERN_WARNING "rar- result from write data register is %x\n",
-	  result);
-
-	printk(KERN_WARNING "rar- value read to data register is %x\n",
-	  addr);
-
-	if (result)
-		return -1;
-	else
-		return 0;
-}
-
-/*
-
- * Initialize RAR parameters, such as physical addresses, etc.
-
- */
-static int memrar_init_rar_params(struct pci_dev *pdev)
-{
-	struct RAR_offsets const offsets[] = {
-	       { LNC_BRAR0L, LNC_BRAR0H },
-	       { LNC_BRAR1L, LNC_BRAR1H },
-	       { LNC_BRAR2L, LNC_BRAR2H }
-	};
-
-	size_t const num_offsets = sizeof(offsets) / sizeof(offsets[0]);
-	struct RAR_offsets const *end = offsets + num_offsets;
-	struct RAR_offsets const *i;
-	unsigned int n = 0;
-	int result = 0;
-
-	/* Retrieve RAR start and end physical addresses. */
-
-	/*
-	 * Access the RAR registers through the Lincroft Message Bus
-	 * Interface on PCI device: 00:00.0 Host bridge.
-	 */
-
-	/* struct pci_dev *pdev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0)); */
-
-	if (pdev == NULL)
-	       return -ENODEV;
-
-	for (i = offsets; i != end; ++i, ++n) {
-	       if (memrar_get_rar_addr (pdev,
-		                       (*i).low,
-		                       &(rar_addr[n].low)) != 0
-		   || memrar_get_rar_addr (pdev,
-		                          (*i).high,
-		                          &(rar_addr[n].high)) != 0) {
-		       result = -1;
-		       break;
-	       }
-	}
-
-	/* Done accessing the device. */
-	/* pci_dev_put(pdev); */
-
-	if (result == 0) {
-	if(1) {
-	       size_t z;
-	       for (z = 0; z != MRST_NUM_RAR; ++z) {
-			printk(KERN_WARNING "rar - BRAR[%Zd] physical address low\n"
-			     "\tlow:  0x%08x\n"
-			     "\thigh: 0x%08x\n",
-			     z,
-			     rar_addr[z].low,
-			     rar_addr[z].high);
-			}
-	       }
-	}
-
-	return result;
-}
-
-/*
-  function that is activaed on the succesfull probe of the RAR device
-*/
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	/* error */
-	int error;
-
-	/*------------------------
-	CODE
-	---------------------------*/
-
-	DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
-	  "Rar pci probe starting\n");
-	error = 0;
-
-	/* enable the device */
-	error = pci_enable_device(pdev);
-	if (error) {
-		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
-		  "error enabling pci device\n");
-		goto end_function;
-	}
-
-	rar_dev = pdev;
-	registered = 1;
-
-	/* Initialize the RAR parameters, which have to be retrieved */
-	/* via the message bus service */
-	error=memrar_init_rar_params(rar_dev);
-
-	if (error) {
-		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
-		  "error getting RAR addresses device\n");
-		registered = 0;
-		goto end_function;
-		}
-
-end_function:
-
-	return error;
-}
-
-/*
-  this function registers th driver to
-  the device subsystem( either PCI, USB, etc)
-*/
-static int __init rar_init_handler(void)
-{
-	return pci_register_driver(&rar_pci_driver);
-}
-
-static void __exit rar_exit_handler(void)
-{
-	pci_unregister_driver(&rar_pci_driver);
-}
-
-module_init(rar_init_handler);
-module_exit(rar_exit_handler);
-
-MODULE_LICENSE("GPL");
-
-
-/* The get_rar_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes two
- * parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
- *
- * struct RAR_address_struct is a pointer to a place to which the function
- * can return the address structure for the RAR.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses)
-{
-	if (registered && (rar_index < 3) && (rar_index >= 0)) {
-		*addresses=rar_addr[rar_index];
-		/* strip off lock bit information  */
-		addresses->low = addresses->low & 0xfffffff0;
-		addresses->high = addresses->high & 0xfffffff0;
-		return 0;
-		}
-
-	else {
-		return -ENODEV;
-		}
-}
-
-
-EXPORT_SYMBOL(get_rar_address);
-
-/* The lock_rar function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int lock_rar(int rar_index)
-{
-	u32 working_addr;
-	int result;
-if (registered && (rar_index < 3) && (rar_index >= 0)) {
-	/* first make sure that lock bits are clear (this does lock) */
-	working_addr=rar_addr[rar_index].low & 0xfffffff0;
-
-	/* now send that value to the register using the IPC */
-        result=memrar_set_rar_addr(rar_dev,rar_index,working_addr);
-	return result;
-	}
-
-else {
-	return -ENODEV;
-	}
-}
diff --git a/drivers/staging/rar/rar_driver.h b/drivers/staging/rar/rar_driver.h
deleted file mode 100644
index 3690f98..0000000
--- a/drivers/staging/rar/rar_driver.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/* === RAR Physical Addresses === */
-struct RAR_address_struct {
-        u32 low;
-        u32 high;
-};
-
-/* The get_rar_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes two
- * parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
- *
- * struct RAR_address_struct is a pointer to a place to which the function
- * can return the address structure for the RAR.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses);
-
-
-/* The lock_rar function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int lock_rar(int rar_index);
-
-
-/* DEBUG LEVEL MASKS */
-#define RAR_DEBUG_LEVEL_BASIC       0x1
-
-#define RAR_DEBUG_LEVEL_REGISTERS   0x2
-
-#define RAR_DEBUG_LEVEL_EXTENDED    0x4
-
-#define DEBUG_LEVEL	0x7
-
-/* FUNCTIONAL MACROS */
-
-/* debug macro without paramaters */
-#define DEBUG_PRINT_0(DEBUG_LEVEL , info) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info); \
-  } \
-}while(0)
-
-/* debug macro with 1 paramater */
-#define DEBUG_PRINT_1(DEBUG_LEVEL , info , param1) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1); \
-  } \
-}while(0)
-
-/* debug macro with 2 paramaters */
-#define DEBUG_PRINT_2(DEBUG_LEVEL , info , param1, param2) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2); \
-  } \
-}while(0)
-
-/* debug macro with 3 paramaters */
-#define DEBUG_PRINT_3(DEBUG_LEVEL , info , param1, param2 , param3) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2 , param3); \
-  } \
-}while(0)
-
-/* debug macro with 4 paramaters */
-#define DEBUG_PRINT_4(DEBUG_LEVEL , info , param1, param2 , param3 , param4) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2 , param3 , param4); \
-  } \
-}while(0)
-
diff --git a/drivers/staging/rar_register/Kconfig b/drivers/staging/rar_register/Kconfig
new file mode 100644
index 0000000..1d2a5cc
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
+	depends on X86_MRST
+	default n
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
index 0000000..17375c6
--- /dev/null
+++ b/drivers/staging/rar_register/rar_register.c
@@ -0,0 +1,661 @@
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
+#include <linux/rar/memrar.h>
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
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
+/* Moorestown supports three restricted access regions. */
+#define MRST_NUM_RAR 3
+
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
+struct RAR_client {
+	int (*client_callback)(void *client_data);
+	void *customer_data;
+	int client_called;
+	};
+
+DEFINE_SPINLOCK(rar_spinlock_lock);
+DEFINE_SPINLOCK(lnc_reg_lock);
+
+struct RAR_device {
+	unsigned long rar_flags;
+	unsigned long lnc_reg_flags;
+	struct RAR_offsets rar_offsets[MRST_NUM_RAR];
+	struct RAR_address_range rar_addr[MRST_NUM_RAR];
+	struct pci_dev *rar_dev;
+	u32 registered;
+	};
+	
+/* this platform has only one rar_device for 3 rar regions */
+struct RAR_device my_rar_device;
+
+/* flag to indicatew whether or not this driver is registered;
+ * this is for the entire driver and not just a device */
+int driver_registered = 0;
+
+/* this data is for handling requests from other drivers which arrive 
+ * prior to this driver initializing
+ */
+
+struct RAR_client clients[MRST_NUM_RAR];
+int num_clients = 0;
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
+	spin_lock_irqsave(&lnc_reg_lock, my_rar_device.lnc_reg_flags);
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
+	spin_unlock_irqrestore(&lnc_reg_lock, my_rar_device.lnc_reg_flags);
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
+	spin_lock_irqsave(&lnc_reg_lock, my_rar_device.lnc_reg_flags);
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
+	spin_unlock_irqrestore(&lnc_reg_lock, my_rar_device.lnc_reg_flags);
+
+	return result;
+}
+
+/*
+ * Initialize RAR parameters, such as bus addresses, etc.
+ */
+static int memrar_init_rar_params(struct pci_dev *pdev)
+{
+	struct RAR_offsets const *end = my_rar_device.rar_offsets + MRST_NUM_RAR;
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
+	for (i = my_rar_device.rar_offsets; i != end; ++i, ++n) {
+		if (memrar_get_rar_addr(my_pdev,
+					i->low,
+					&(my_rar_device.rar_addr[n].low)) != 0
+		    || memrar_get_rar_addr(my_pdev,
+					   i->high,
+					   &(my_rar_device.rar_addr[n].high)) != 0) {
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
+		my_rar_device.rar_addr[n].low  &= 0xfffffc00u;  /* Clear bits 9:0 */
+
+		/*
+		 * Set bits 9:0 if the 1 KiB aligned (the upper 22
+		 * bits) high address is non-zero.
+		 *
+		 * Otherwise set all bits to zero since that indicates
+		 * no RAR address is configured.
+		 */
+		if ((my_rar_device.rar_addr[n].high & 0xfffffc00u) == 0)
+			my_rar_device.rar_addr[n].high = 0;
+		else
+			my_rar_device.rar_addr[n].high |= 0x3ffu;
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
+				 my_rar_device.rar_addr[z].low,
+				 my_rar_device.rar_addr[z].high);
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
+	int counter;
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
+	/* we have only one device; fill in the rar_device structure */
+	my_rar_device.rar_dev = dev;
+	my_rar_device.rar_flags = 0;
+	my_rar_device.lnc_reg_flags = 0;
+	my_rar_device.rar_offsets[0].low = LNC_BRAR0L;
+	my_rar_device.rar_offsets[0].high = LNC_BRAR0H;
+	my_rar_device.rar_offsets[1].low = LNC_BRAR1L;
+	my_rar_device.rar_offsets[1].high = LNC_BRAR1H;
+	my_rar_device.rar_offsets[2].low = LNC_BRAR2L;
+	my_rar_device.rar_offsets[2].high = LNC_BRAR2H;
+	my_rar_device.registered = 1;
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
+	driver_registered = 1;
+
+	/* now call anyone who has registered (using callbacks) */
+	for (counter = 0; counter < num_clients; counter += 1) {
+		if (!clients[counter].client_called) {
+			error = (*clients[counter].client_callback)(
+			  clients[counter].customer_data);
+			clients[counter].client_called = 1;
+			dev_dbg(&my_rar_device.rar_dev->dev, "Callback called for %d\n",
+			  counter);
+		}
+	}
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
+	if (my_rar_device.registered) {
+		if (start_address == 0
+		    || end_address == 0
+		    || rar_index >= MRST_NUM_RAR
+		    || rar_index < 0) {
+			result = -EINVAL;
+		} else {
+			*start_address = my_rar_device.rar_addr[rar_index].low;
+			*end_address   = my_rar_device.rar_addr[rar_index].high;
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
+	spin_lock_irqsave(&rar_spinlock_lock, my_rar_device.rar_flags);
+
+	if (my_rar_device.registered)	{
+
+		u32 low;
+		u32 high;
+
+		/*
+		 * Clear bits 4:0 in low register to lock.
+		 * Clear bits 8,4:0 in high register to lock.
+		 *
+		 * The rest of the lower 10 bits in both registers are
+		 * unused so we might as well clear them all.
+		 */
+		if (rar_index == RAR_TYPE_VIDEO) {
+			low  = my_rar_device.rar_addr[rar_index].low  & 0xfffffc00u;
+			high = my_rar_device.rar_addr[rar_index].high & 0xfffffc00u;
+			low |= 0x00000009;
+			high |= 0x00000015;
+		}
+
+		else if (rar_index == RAR_TYPE_AUDIO) {
+			low  = my_rar_device.rar_addr[rar_index].low  & 0xfffffc00u;
+			high = my_rar_device.rar_addr[rar_index].high & 0xfffffc00u;
+			low |= 0x00000008;
+			high |= 0x00000018;
+		}
+
+		else {
+			low  = my_rar_device.rar_addr[rar_index].low  & 0xfffffc00u;
+			high = my_rar_device.rar_addr[rar_index].high & 0xfffffc00u;
+			high |= 0x00000018;
+		}
+
+		/*
+		 * Now program the register using the Lincroft message
+		 * bus interface.
+		 */
+		result = memrar_set_rar_addr(my_rar_device.rar_dev,
+					     my_rar_device.rar_offsets[rar_index].low,
+					     low);
+
+		if (result == 0)
+			result =
+				memrar_set_rar_addr(
+					my_rar_device.rar_dev,
+					my_rar_device.rar_offsets[rar_index].high,
+					high);
+	}
+
+	spin_unlock_irqrestore(&rar_spinlock_lock, my_rar_device.rar_flags);
+
+exit_rar_lock:
+
+	return result;
+}
+EXPORT_SYMBOL(rar_lock);
+
+/* The register_rar function is to used by other device drivers
+ * to ensure that this driver is ready. As we cannot be sure of
+ * the compile/execute order of dirvers in ther kernel, it is 
+ * best to give this driver a callback function to call when
+ * it is ready to give out addresses. The callback function 
+ * would have those steps that continue the initialization of
+ * a driver that do require a valid RAR address. One of those
+ * steps would be to call get_rar_address()
+ * This function return 0 on success an -1 on failure.
+ */
+int register_rar(int (*callback)(void *yourparameter), void *yourparameter)
+{
+
+	int result;
+
+	result = 0;
+
+	if (driver_registered) {
+
+		/* if the driver already registered, then we can simply
+		   call the callback right now */
+		
+		result = (*callback)(yourparameter);
+		if (result) {
+			dev_dbg(&my_rar_device.rar_dev->dev, "Immediate Callback failed: %x\n",
+			  result);
+		}
+		else {
+			dev_dbg(&my_rar_device.rar_dev->dev, "Immediate Callback ran okay\n");
+		}
+	
+		return result;
+	}
+
+	else if (num_clients >= MRST_NUM_RAR) {
+		return -ENODEV;
+	}
+
+	else {
+
+		clients[num_clients].client_callback = callback;
+		clients[num_clients].customer_data = yourparameter;
+		clients[num_clients].client_called = 0;
+		num_clients += 1;
+		dev_dbg(&my_rar_device.rar_dev->dev, "Callback registered\n");
+	}
+
+return result;
+
+}
+
+EXPORT_SYMBOL(register_rar);
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
diff --git a/include/linux/rar/memrar.h b/include/linux/rar/memrar.h
new file mode 100644
index 0000000..844d315
--- /dev/null
+++ b/include/linux/rar/memrar.h
@@ -0,0 +1,172 @@
+/*
+ *      RAR Handler (/dev/memrar) internal driver API.
+ *      Copyright (C) 2009 Intel Corporation. All rights reserved.
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
+#ifndef _MEMRAR_H
+#define _MEMRAR_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+
+/*
+ * Constants that specify different kinds of RAR regions that could be
+ * set up.
+ */
+static __u32 const RAR_TYPE_VIDEO;  /* 0 */
+static __u32 const RAR_TYPE_AUDIO = 1;
+static __u32 const RAR_TYPE_IMAGE = 2;
+static __u32 const RAR_TYPE_DATA  = 3;
+
+/*
+ * @struct RAR_stat
+ *
+ * @brief This structure is used for @c RAR_HANDLER_STAT ioctl and for
+ *        @c RAR_get_stat() user space wrapper function.
+ */
+struct RAR_stat {
+	/* Type of RAR memory (e.g., audio vs. video) */
+	__u32 type;
+
+	/*
+	 * Total size of RAR memory region.
+	 */
+	__u32 capacity;
+
+	/* Size of the largest reservable block. */
+	__u32 largest_block_size;
+};
+
+
+/*
+ * @struct RAR_block_info
+ *
+ * @brief The argument for the @c RAR_HANDLER_RESERVE @c ioctl.
+ *
+ */
+struct RAR_block_info {
+	/* Type of RAR memory (e.g., audio vs. video) */
+	__u32 type;
+
+	/* Requested size of a block to be reserved in RAR. */
+	__u32 size;
+
+	/* Handle that can be used to refer to reserved block. */
+	__u32 handle;
+};
+
+/*
+ * @struct RAR_buffer
+ *
+ * Structure that contains all information related to a given block of
+ * memory in RAR.  It is generally only used when retrieving bus
+ * addresses.
+ *
+ * @note This structure is used only by RAR-enabled drivers, and is
+ *       not intended to be exposed to the user space.
+ */
+struct RAR_buffer {
+	/* Structure containing base RAR buffer information */
+	struct RAR_block_info info;
+
+	/* Buffer bus address */
+	__u32 bus_address;
+};
+
+
+#define RAR_IOCTL_BASE 0xE0
+
+/* Reserve RAR block. */
+#define RAR_HANDLER_RESERVE _IOWR(RAR_IOCTL_BASE, 0x00, struct RAR_block_info)
+
+/* Release previously reserved RAR block. */
+#define RAR_HANDLER_RELEASE _IOW(RAR_IOCTL_BASE, 0x01, __u32)
+
+/* Get RAR stats. */
+#define RAR_HANDLER_STAT    _IOWR(RAR_IOCTL_BASE, 0x02, struct RAR_stat)
+
+
+/* -------------------------------------------------------------- */
+/*               Kernel Side RAR Handler Interface                */
+/* -------------------------------------------------------------- */
+
+/*
+ * @function rar_reserve
+ *
+ * @brief Reserve RAR buffers.
+ *
+ * This function will reserve buffers in the restricted access regions
+ * of given types.
+ *
+ * @return Number of successfully reserved buffers.
+ *         Successful buffer reservations will have the corresponding
+ *         @c bus_address field set to a non-zero value in the
+ *         given @a buffers vector.
+ */
+extern size_t rar_reserve(struct RAR_buffer *buffers,
+			  size_t count);
+
+/*
+ * @function rar_release
+ *
+ * @brief Release RAR buffers retrieved through call to
+ *        @c rar_reserve() or @c rar_handle_to_bus().
+ *
+ * This function will release RAR buffers that were retrieved through
+ * a call to @c rar_reserve() or @c rar_handle_to_bus() by
+ * decrementing the reference count.  The RAR buffer will be reclaimed
+ * when the reference count drops to zero.
+ *
+ * @return Number of successfully released buffers.
+ *         Successful releases will have their handle field set to
+ *         zero in the given @a buffers vector.
+ */
+extern size_t rar_release(struct RAR_buffer *buffers,
+			  size_t count);
+
+/*
+ * @function rar_handle_to_bus
+ *
+ * @brief Convert a vector of RAR handles to bus addresses.
+ *
+ * This function will retrieve the RAR buffer bus addresses, type and
+ * size corresponding to the RAR handles provided in the @a buffers
+ * vector.
+ *
+ * @return Number of successfully converted buffers.
+ *         The bus address will be set to @c 0 for unrecognized
+ *         handles.
+ *
+ * @note The reference count for each corresponding buffer in RAR will
+ *       be incremented.  Call @c rar_release() when done with the
+ *       buffers.
+ */
+extern size_t rar_handle_to_bus(struct RAR_buffer *buffers,
+				size_t count);
+
+
+#endif  /* _MEMRAR_H */
+
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
diff --git a/include/linux/rar/rar_register.h b/include/linux/rar/rar_register.h
new file mode 100644
index 0000000..4d23df1
--- /dev/null
+++ b/include/linux/rar/rar_register.h
@@ -0,0 +1,79 @@
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
+/* The register_rar function is to used by other device drivers
+ * to ensure that this driver is ready. As we cannot be sure of
+ * the compile/execute order of dirvers in ther kernel, it is 
+ * best to give this driver a callback function to call when
+ * it is ready to give out addresses. The callback function 
+ * would have those steps that continue the initialization of
+ * a driver that do require a valid RAR address. One of those
+ * steps would be to call get_rar_address()
+ * This function return 0 on success an -1 on failure.
+ */
+int register_rar(int (*callback)(void *yourparameter), void *yourparameter);
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

