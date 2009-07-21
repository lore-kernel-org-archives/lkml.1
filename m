Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZGUB3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZGUB3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZGUB3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:29:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:27936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbZGUB3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:29:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,237,1246863600"; 
   d="scan'208,223";a="534498181"
From: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>
To: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@linux.intel.com>
Date: Tue, 21 Jul 2009 06:58:47 +0530
Subject: x86: IPC driver patch for Intel Moorestown platform
Thread-Topic: x86: IPC driver patch for Intel Moorestown platform
Thread-Index: AcoJopgtVOAbtEK0QoWJEn1Cx+Xy4w==
Message-ID: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BhpK B+ZE FKYJ G6cA I5ii JYXR KytQ OPdO O+O1 WK27 XbK3
 XfEO ZbLg awRB cY2O
 cdNA;3;YQBsAGEAbgBAAGwAaQBuAHUAeAAuAGkAbgB0AGUAbAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHgAOAA2AEAAawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{1B02AF3F-1560-4E8F-861F-38F153C60526};cwByAGUAZQBuAGkAZABoAGkALgBiAC4AZwB1AHIAdQBkAGEAdAB0AEAAaQBuAHQAZQBsAC4AYwBvAG0A;Tue,
 21 Jul 2009 01:28:47
 GMT;eAA4ADYAOgAgAEkAUABDACAAZAByAGkAdgBlAHIAIABwAGEAdABjAGgAIABmAG8AcgAgAEkAbgB0AGUAbAAgAE0AbwBvAHIAZQBzAHQAbwB3AG4AIABwAGwAYQB0AGYAbwByAG0A
x-cr-puzzleid: {1B02AF3F-1560-4E8F-861F-38F153C60526}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c77d58ad07fbedb5de478bff21eb48c62b399cf1 Mon Sep 17 00:00:00 2001
From: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>
Date: Mon, 20 Jul 2009 15:41:10 +0530
Subject: [PATCH] x86: IPC driver patch for Intel Moorestown platform.

The Inter-Processor-Communication driver provides interfaces to host
drivers in kernel to access various Langwell ICH blocks such as PMIC,
GPIO and Battery for Intel Moorestown platform.
The IPC driver for Intel Moorestown platform communicates via SCU
firmware to access these registers.

Signed-off-by: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>

        modified:   arch/x86/Kconfig
        new file:   arch/x86/include/asm/mrst_ipcdefs.h
        modified:   arch/x86/kernel/Makefile
        new file:   arch/x86/kernel/mrst_ipc.c
        new file:   arch/x86/kernel/mrst_ipc.h
---
 arch/x86/Kconfig                    |   10 +-
 arch/x86/include/asm/mrst_ipcdefs.h |  205 +++++++
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/mrst_ipc.c          | 1058 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/mrst_ipc.h          |  238 ++++++++
 5 files changed, 1510 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/mrst_ipcdefs.h
 create mode 100644 arch/x86/kernel/mrst_ipc.c
 create mode 100644 arch/x86/kernel/mrst_ipc.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 738bdc6..2c607b8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -570,8 +570,14 @@ config HPET_EMULATE_RTC
        def_bool y
        depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)

-# Mark as embedded because too many people got it wrong.
-# The code disables itself when not needed.
+config LANGWELL_IPC
+       def_bool n
+       prompt "Langwell IPC Support" if (X86_32)
+       help
+         Langwell Inter Processor Communication block is used in Intel
+         Moorestown MID platform to bridge the communications between IA CPU
+         and System Controller Unit via SCU firmware.
+
 config DMI
        default y
        bool "Enable DMI scanning" if EMBEDDED
diff --git a/arch/x86/include/asm/mrst_ipcdefs.h b/arch/x86/include/asm/mrst_ipcdefs.h
new file mode 100644
index 0000000..cab8899
--- /dev/null
+++ b/arch/x86/include/asm/mrst_ipcdefs.h
@@ -0,0 +1,205 @@
+/*
+ * mrst_ipc_defs.h: Driver for Langwell MRST IPC1
+ * Copyright (C) 2009  Intel Corp
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Sreenidhi Gurudatt
+ * Contact information: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>
+ */
+
+#ifndef __MRST_IPCDEFS_H__
+#define  __MRST_IPCDEFS_H__
+
+#include <linux/init.h>
+#include <linux/module.h>
+
+#define MAX_PMICREGS           5
+#define MAX_PMIC_MOD_REGS      4
+
+/*
+ * List of commands sent by calling host
+ * drivers to MRST_IPCDriver
+*/
+
+/* CCA battery driver specific commands.
+ * Thise commands are shared across MRST_IPCdriver
+ * and calling host driver
+ */
+
+#define IPC_WATCHDOG           0xA0
+#define IPC_PROGRAM_BUS_MASTER 0xA1
+#define DEVICE_FW_UPGRADE      0xA2
+
+#define IPC_BATT_CCA_READ      0xB0
+#define IPC_BATT_CCA_WRITE     0xB1
+#define IPC_BATT_GET_PROP      0xB2
+
+/* VRTC IPC CMD ID and sub id */
+#define IPC_VRTC_CMD                   0xFA
+#define IPC_VRTC_SET_TIME              0x01
+#define IPC_VRTC_SET_ALARM             0x02
+
+/**
+ * struct mrst_ipc_cmd_val - user-date for command.
+ * @u32 mrst_ipc_cmd_data - User specified command data.;
+ */
+struct mrst_ipc_cmd_val {
+       u32 mrst_ipc_cmd_data;
+};
+
+/**
+ * struct mrst_ipc_cmd_type
+ * @u8 cmd - Command type
+ * @u32 data - Command data
+ * @u8 value - Command value
+ * @u8 ioc - IOC/MSI field.;
+ */
+struct mrst_ipc_cmd_type {
+       u8 cmd;
+       u32 data;
+       u8 value;
+       u8 ioc;
+};
+
+/**
+ * struct mrst_ipc_batt_cca_data
+ * @int cca_val - IPC_BATT_CCA_READ and IPC_BATT_CCA_WRITE
+ */
+struct mrst_ipc_batt_cca_data {
+       int cca_val;
+};
+
+/**
+ * struct mrst_ipc_batt_prop_data - Structures defined for
+ * battery PMIC driver This structure is used by IPC_BATT_GET_PROP
+ * @u32 batt_value1 - Battery value.
+ * @u8 batt_value2[5] - battery value for PMIC specific regs.;
+ */
+struct mrst_ipc_batt_prop_data {
+       u32 batt_value1;
+       u8 batt_value2[5];
+       u32 ipc_cmd_len;
+       u8 ioc;
+};
+
+/**
+ * struct mrst_ipc_reg_data - PMIC register structure.
+ * @u8 ioc - MSI or IOC bit.
+ * @u32 address - PMIC register address.
+ * @u32 data - PMIC register data.
+*/
+struct mrst_ipc_reg_data {
+       u8 ioc;
+       u32 address;
+       u32 data;
+};
+
+/**
+ * struct mrst_ipc_cmd - PMIC IPC command structure.
+ * @u8 cmd - Commmand -  bit.
+ * @u32 data - Command data.
+*/
+struct mrst_ipc_cmd {
+       u8 cmd;
+       u32 data;
+};
+
+/**
+ * struct pmicmodreg - PMIC IPC command structure.
+ * @u16 register_address - register address.
+ * @u8 value - register value.
+ * @u8 bit_map - register bit_map.
+ */
+struct pmicmodreg {
+       u16 register_address;
+       u8 value;
+       u8 bit_map;
+};
+
+/**
+ * struct pmicreg - PMIC IPC command structure.
+ * @u16 register_address - register address.
+ * @u8 value - register value.
+ */
+struct pmicreg {
+       u16 register_address;
+       u8 value;
+};
+
+/**
+ * struct mrst_pmic_reg_data - Moorestown specific PMIC IPC register structure.
+ * @bool ioc;
+ * @struct pmicreg pmic_reg_data[MAX_PMICREGS];
+ * @u8 num_entries - Number of register entries.
+ */
+struct mrst_pmic_reg_data {
+       bool ioc;
+       struct pmicreg pmic_reg_data[MAX_PMICREGS];
+       u8 num_entries;
+};
+
+/**
+ * struct mrst_pmic_mod_reg_data - Moorestown specific PMIC IPC register structure
+ * @bool ioc - MSI Bit enabled/disabled.
+ * @struct pmicmodreg pmic_mod_reg_data[MAX_PMIC_MOD_REGS]
+ * @u8 num_entries - Number of entries
+ */
+struct mrst_pmic_mod_reg_data {
+       bool ioc;
+       struct pmicmodreg pmic_mod_reg_data[MAX_PMIC_MOD_REGS];
+       u8 num_entries;
+};
+
+/**
+ * struct watchdog_reg_data - Moorestown specific PMIC IPC register structure
+ * @int payload1 - payload - u32.
+ * @int payload2 - payload - u32.
+ * @bool ioc - MSI or IOC bit.
+*/
+struct watchdog_reg_data {
+       int payload1;
+       int payload2;
+       bool ioc;
+};
+
+/**
+ * struct mrst_ipc_io_bus_master_regs - Moorestown specific PMIC IPC register structure
+ * @u32 ctrl_reg_addr - control register address -u32.
+ * @u32 ctrl_reg_data - control register data -u32.
+*/
+struct mrst_ipc_io_bus_master_regs {
+       u32 ctrl_reg_addr;
+       u32 ctrl_reg_data;
+};
+
+u8 mrst_pmic_ioreadb(u16 addr, bool ioc_notify, int *err);
+int mrst_pmic_iowriteb(u16 addr, bool ioc_notify, u8 data);
+int mrst_pmic_iowrite(struct mrst_pmic_reg_data *p_write_reg_data);
+int mrst_pmic_ioread(struct mrst_pmic_reg_data *p_read_reg_data);
+int mrst_pmic_ioread_modify(struct mrst_pmic_mod_reg_data
+                                 *p_read_mod_reg_data);
+int mrst_ipc_read32(struct mrst_ipc_reg_data *p_reg_data);
+int mrst_ipc_write32(struct mrst_ipc_reg_data *p_reg_data);
+u32 mrst_ipc_batt_read(u8 ioc, int *err);
+int mrst_ipc_batt_write(u8 ioc, u32 value);
+int mrst_ipc_get_batt_properties(struct mrst_ipc_batt_prop_data *prop_data);
+int mrst_ipc_set_watchdog(struct watchdog_reg_data *p_watchdog_data);
+int mrst_ipc_program_io_bus_master(struct mrst_ipc_io_bus_master_regs
+                       *p_reg_data);
+int lnw_ipc_single_cmd(u8 cmd_id, u8 sub_id, int size, int msi);
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 430d5b2..da56864 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_VM86)            += vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)     += early_printk.o

 obj-$(CONFIG_HPET_TIMER)       += hpet.o
+obj-$(CONFIG_LANGWELL_IPC)     += mrst_ipc.o

 obj-$(CONFIG_K8_NB)            += k8.o
 obj-$(CONFIG_MGEODE_LX)                += geode_32.o mfgpt_32.o
diff --git a/arch/x86/kernel/mrst_ipc.c b/arch/x86/kernel/mrst_ipc.c
new file mode 100644
index 0000000..ed40632
--- /dev/null
+++ b/arch/x86/kernel/mrst_ipc.c
@@ -0,0 +1,1058 @@
+/*
+ * mrst_ipc.c: Driver for Langwell IPC1
+ * Copyright (C) 2009 Intel Corp
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Sreenidhi Gurudatt
+ * Contact information: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/sysdev.h>
+#include <linux/pm.h>
+#include <linux/pci.h>
+#include <asm/mrst_ipcdefs.h>
+#include <linux/workqueue.h>
+
+#include "mrst_ipc.h"
+
+/*virtual memory address for IPC base returned by IOREMAP().*/
+static void __iomem *p_mrst_ipc_base;
+static void __iomem *p_mrst_i2c_ser_bus;
+static struct pci_dev *mrst_ipc_pci_dev;
+static wait_queue_head_t mrst_cmd_wait;
+static int scu_cmd_completed;
+static void __iomem *lnw_ipc_virt_address;
+static unsigned short cmdid_pool = 0xffff;
+static DEFINE_MUTEX(mrst_ipc_mutex);
+
+static inline int lnw_ipc_set_mapping(struct pci_dev *dev)
+{
+       unsigned long cadr;
+
+       cadr = pci_resource_start(dev, 0);
+       if (!cadr) {
+               dev_info(&dev->dev, "No PCI resource for IPC\n");
+               return -ENODEV;
+       }
+       lnw_ipc_virt_address = ioremap_nocache(cadr, 0x1000);
+       if (lnw_ipc_virt_address != NULL) {
+               dev_info(&dev->dev, "lnw ipc base found 0x%lup: 0x%p\n",
+                        cadr, lnw_ipc_virt_address);
+               return 0;
+       }
+       dev_err(&dev->dev, "Failed map LNW IPC1 phy address at %lu\n", cadr);
+       return -ENODEV;
+}
+
+static inline void lnw_ipc_clear_mapping(void)
+{
+       iounmap(lnw_ipc_virt_address);
+       lnw_ipc_virt_address = NULL;
+}
+
+static u32 lnw_ipc_readl(u32 a)
+{
+       return readl(lnw_ipc_virt_address + a);
+}
+
+static inline void lnw_ipc_writel(u32 d, u32 a)
+{
+       writel(d, lnw_ipc_virt_address + a);
+}
+
+/**
+ * int lnw_ipc_single_cmd() - Function to execute "one" IPC command
+ * @u8 cmd_id :        Command ID to send.
+ * @u8 sub_id :        Type of command. Subset of command ID.
+ * @int msi    Message Signal Interrupt flag : true/false
+ *
+ * This function provides and interface to send an IPC command to
+ * SCU Firmware and recieve a response.
+ */
+int lnw_ipc_single_cmd(u8 cmd_id, u8 sub_id, int size, int msi)
+{
+       u32 cmdreg, stsreg, retry;
+
+       if (size >= 16) {
+               WARN_ON(1);
+               printk(KERN_ERR
+                       "lnw_ipc_single_cmd: message size too big %d\n", size);
+               goto err_ipccmd;
+       }
+
+       WARN_ON(msi != 0 && msi != 1);
+
+       cmdreg = cmd_id | (sub_id << 12) | (size << 16) | (msi << 8);
+
+       lnw_ipc_writel(cmdreg, LNW_IPC_CMD);
+
+       /* check status make sure the command is received by SCU */
+       retry = 1000;
+       stsreg = lnw_ipc_readl(LNW_IPC_STS);
+       if (stsreg & LNW_IPC_STS_ERR) {
+               lnw_ipc_dbg("MRST IPC command ID %d error\n", cmd_id);
+               goto err_ipccmd;
+       }
+       while ((stsreg & LNW_IPC_STS_BUSY) && retry) {
+               lnw_ipc_dbg("MRST IPC command ID %d busy\n", cmd_id);
+               stsreg = lnw_ipc_readl(LNW_IPC_STS);
+               udelay(10);
+               retry--;
+       }
+
+       if (!retry)
+               printk(KERN_ERR "lnw_ipc_single_cmd: cmd %d failed/timeout",
+                                                               cmd_id);
+       else
+               lnw_ipc_dbg("MRST IPC command ID %d completed\n", cmd_id);
+
+       return 0;
+
+err_ipccmd:
+       return -1;
+}
+EXPORT_SYMBOL(lnw_ipc_single_cmd);
+
+/*
+ * Interrupt handler for the command completion interrupt from SCU firmware.
+ * This IRQ line is not shared.
+ * The command processing is sequential, SCU Firmware does not process a
+ * new command untill it recieves an EOI from IPC driver.
+ */
+static irqreturn_t mrst_ipc_irq(int irq, void *dev_id)
+{
+       union mrst_ipc_sts ipc_sts_reg;
+
+       ipc_sts_reg.ipc_sts_data = readl(p_mrst_ipc_base + IPC_STS);
+
+       if (!ipc_sts_reg.ipc_sts_parts.busy) {
+               scu_cmd_completed = true;
+               wake_up_interruptible(&mrst_cmd_wait);
+       } else
+               /*This IRQ is private.*/
+               dev_err(&mrst_ipc_pci_dev->dev,
+                               "Spurious IPC Interrupt recieved\n");
+
+       return IRQ_HANDLED;
+}
+
+static const struct mrst_ipc_driver ipc_mrst_driver = {
+       .name = "MRST IPC Controller",
+       /*
+        * generic hardware linkage
+        */
+       .irq = mrst_ipc_irq,
+       .flags = 0,
+};
+
+static int ipc_mrst_pci_probe(struct pci_dev *dev,
+                                       const struct pci_device_id *id)
+{
+       int err, retval = 0, i;
+
+       mrst_ipc_pci_dev = dev;
+       lnw_ipc_dbg("Attempt to enable IPC irq 0x%x, pin %d\n",
+               dev->irq, dev->pin);
+       err = pci_enable_device(dev);
+       if (err) {
+               dev_err(&dev->dev, "Failed to enable MSRT IPC(%d)\n", err);
+               goto fail;
+       }
+       retval = pci_request_regions(dev, "ipc_mrst");
+       if (retval) {
+               dev_err(&dev->dev, "Failed to allocate resource\
+                                       for MRST IPC(%d)\n", retval);
+               return -ENOMEM;
+       }
+       init_mrst_ipc_driver();
+
+       /* 0 means cmd ID is in use */
+       cmdid_pool = 0xffff;
+       /* initialize mapping */
+       retval = lnw_ipc_set_mapping(dev);
+       if (retval)
+               goto fail;
+
+       /* clear buffer */
+       for (i = 0; i < LNW_IPC_RWBUF_SIZE; i = i + 4) {
+               lnw_ipc_writel(0, LNW_IPC_WBUF + i);
+               lnw_ipc_writel(0, LNW_IPC_RBUF + i);
+       }
+       retval = request_irq(dev->irq, mrst_ipc_irq, 0, "ipc_mrst",
+                                               (void *)&ipc_mrst_driver);
+       if (retval == 0)
+               return 0;
+
+       dev_err(&dev->dev, "ipc_mrst_pci_probe: cannot register ISR %p irq %d\
+                               ret %d\n", mrst_ipc_irq, dev->irq, retval);
+fail:
+       pci_release_regions(dev);
+       return retval;
+
+}
+
+static void ipc_mrst_pci_remove(struct pci_dev *pdev)
+{
+       pci_release_regions(pdev);
+}
+
+/* PCI driver selection metadata; PCI hotplugging uses this */
+static const struct pci_device_id pci_ids[] = {
+       {PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080e)}
+};
+
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
+/* pci driver glue; this is a "new style" PCI driver module */
+static struct pci_driver ipc_mrst_pci_driver = {
+       .name = "ipc_mrst",
+       .id_table = pci_ids,
+       .probe = ipc_mrst_pci_probe,
+       .remove = ipc_mrst_pci_remove,
+};
+
+static int __init ipc_mrst_init(void)
+{
+       int retval;
+       retval = pci_register_driver(&ipc_mrst_pci_driver);
+       if (retval < 0) {
+               printk(KERN_ERR "ipc_mrst_init: Failed to register %s\n",
+                       ipc_mrst_pci_driver.name);
+               pci_unregister_driver(&ipc_mrst_pci_driver);
+       } else {
+               printk(KERN_INFO "****Loaded %s driver version %s****\n",
+               ipc_mrst_pci_driver.name, MRST_IPC_DRIVER_VERSION);
+       }
+       return retval;
+}
+
+static void __exit ipc_mrst_exit(void)
+{
+       free_irq(mrst_ipc_pci_dev->irq, mrst_ipc_irq);
+       iounmap(p_mrst_ipc_base);
+       iounmap(p_mrst_i2c_ser_bus);
+       pci_unregister_driver(&ipc_mrst_pci_driver);
+       de_init_mrst_ipc_driver();
+}
+
+/**
+ * u8 mrst_ipc_batt_read() - This function reads the data from Coulumb counter
+ * registers in SCU firmware for Moorestown platform.
+ * @u8 ioc: ioc bit to enable/disable command completion interrupt from SCU.
+ * @int *err: negative if an error occurred
+ *
+ * This is used by Intel Moorestown Battery driver to read Coulumb counters.
+ */
+u32 mrst_ipc_batt_read(u8 ioc, int *err)
+{
+       u32 data = 0;
+
+       mutex_lock(&mrst_ipc_mutex);
+       *err = do_mrst_ipc_battery(CCA_REG_READ, ioc, NULL);
+       if (*err == 0)
+               data = readl(p_mrst_ipc_base + IPC_RBUF);
+       mutex_unlock(&mrst_ipc_mutex);
+
+       return data;
+}
+EXPORT_SYMBOL(mrst_ipc_batt_read);
+
+/**
+ * int mrst_ipc_batt_write() - This function reads the data from Coulumb counter
+ * registers in SCU firmware for Moorestown platform.
+ * @u8 ioc: ioc bit to enable/disable command completion interrupt from SCU.
+ * @u32 value: Data value to be written.
+ *
+ * This is used by Intel Moorestown Battery driver to write to Coulumb counters.
+ */
+int mrst_ipc_batt_write(u8 ioc, u32 value)
+{
+       int ret;
+       mutex_lock(&mrst_ipc_mutex);
+       ret = do_mrst_ipc_battery(CCA_REG_WRITE, ioc, &value);
+       mutex_unlock(&mrst_ipc_mutex);
+       return ret;
+}
+EXPORT_SYMBOL(mrst_ipc_batt_write);
+
+/**
+ * int mrst_ipc_get_batt_properties() - This function reads the data
+ * from Coulumb counter registers in SCU firmware for Moorestown platform.
+ * @struct mrst_ipc_batt_prop_data *mrst_batt_prop:
+ *
+ * This is used by Intel Moorestown Battery driver to get the battery
+ * properties.
+ */
+int mrst_ipc_get_batt_properties(struct mrst_ipc_batt_prop_data *mrst_batt_prop)
+{
+       int ret;
+       u32 rbuf_offset = 2;
+       u32 ipc_wbuf;
+       u8 cbuf[MAX_NUM_ENTRIES] = { '\0' };
+       u32 i;
+
+       if (mrst_batt_prop == NULL) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+       if (mrst_batt_prop->ipc_cmd_len < 4 ||
+                               mrst_batt_prop->ipc_cmd_len > 9) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+       ret = do_mrst_ipc_battery(CCA_REG_GET_PROP, mrst_batt_prop->ioc, NULL);
+       if (ret)
+               return ret; /*return error*/
+
+       /* On wake-up fill the user buffer with IPC_RBUF data.*/
+       rbuf_offset = 0;
+
+       if (mrst_batt_prop->ipc_cmd_len >= 4) {
+               ipc_wbuf = readl(p_mrst_ipc_base + IPC_RBUF);
+               rbuf_offset += 4;
+               for (i = 0; i < (mrst_batt_prop->ipc_cmd_len - 4); i++) {
+                       cbuf[i] = readb(p_mrst_ipc_base + IPC_RBUF +
+                                                               rbuf_offset);
+                       mrst_batt_prop->batt_value2[i] = cbuf[i];
+                       rbuf_offset++;
+               }
+       }
+       mutex_unlock(&mrst_ipc_mutex);
+       return ret;
+}
+EXPORT_SYMBOL(mrst_ipc_get_batt_properties);
+
+int init_mrst_ipc_driver(void)
+{
+       mutex_lock(&mrst_ipc_mutex);
+       init_waitqueue_head(&mrst_cmd_wait);
+
+       /* Map the memory of ipc1 PMIC reg base */
+       p_mrst_ipc_base = ioremap_nocache(IPC_BASE_ADDRESS, IPC_MAX_ADDRESS);
+       if (p_mrst_ipc_base == NULL) {
+               dev_err(&mrst_ipc_pci_dev->dev, "ERR:IPC Address Map Failed\n");
+               mutex_unlock(&mrst_ipc_mutex);
+               return -ENOMEM;
+       }
+
+       p_mrst_i2c_ser_bus = ioremap_nocache(I2C_SER_BUS, I2C_MAX_ADDRESS);
+       if (p_mrst_i2c_ser_bus == NULL) {
+               iounmap(p_mrst_ipc_base);
+               dev_err(&mrst_ipc_pci_dev->dev, "ERR:IPC Address Map Failed\n");
+               mutex_unlock(&mrst_ipc_mutex);
+               return -ENOMEM;
+       }
+
+       mutex_unlock(&mrst_ipc_mutex);
+
+       return 0;
+}
+
+static int de_init_mrst_ipc_driver(void)
+{
+       mutex_lock(&mrst_ipc_mutex);
+
+       lnw_ipc_dbg(
+                       "ipc_driver: in <%s> -> <%s> file at line no = <%d>\n",
+                       __func__, __FILE__, __LINE__);
+               iounmap(p_mrst_ipc_base);
+               iounmap(p_mrst_i2c_ser_bus);
+               mutex_unlock(&mrst_ipc_mutex);
+
+               return 0;
+       }
+
+/**
+ * u8 mrst_pmic_ioreadb() - This function reads the data from PMIC
+ * registers and fills the user specified buffer with data.
+ * @u16 addr: 16 Bit PMIC register offset address.
+ * @bool ioc_notify: boolean_value to speicify Interrupt On Completion bit.
+ * @int *err: negative if an error occurred
+ *
+ * This function reads 1byte of data data from specified PMIC register offset.
+ * It returns 8 bits of PMIC register data
+ */
+u8 mrst_pmic_ioreadb(u16 addr, bool ioc_notify, int *err)
+{
+       struct mrst_pmic_reg_data r_data;
+       int ret_val;
+
+       r_data.ioc = ioc_notify;
+       r_data.num_entries = 1;
+       r_data.pmic_reg_data[0].register_address = addr;
+
+       ret_val = mrst_pmic_ioread(&r_data);
+       *err = ret_val;
+       if (ret_val) {
+               printk(KERN_ERR "mrst_pmic_ioreadb: ioreadb failed! \n");
+               return 0xFF;
+       }
+       return r_data.pmic_reg_data[0].value;
+}
+EXPORT_SYMBOL(mrst_pmic_ioreadb);
+
+/**
+ * int mrst_pmic_iowriteb() - This function reads the data from PMIC
+ * registers and fills the user specified buffer with data.
+ * @u16 addr: 16 Bit PMIC register offset address.
+ * @bool ioc_notify: boolean_value to speicify Interrupt On Completion bit.
+ * @u8 data: 8 Bit PMIC register data..
+ *
+ * This function reads 1byte of data data from specified PMIC register offset.
+ * It returns 0 on success and returns -1 or an appropriate error-code.
+ */
+int mrst_pmic_iowriteb(u16 addr, bool ioc_notify, u8 data)
+{
+       struct mrst_pmic_reg_data w_data;
+       int ret_val;
+
+       w_data.ioc = ioc_notify;
+       w_data.num_entries = 1;
+       w_data.pmic_reg_data[0].register_address = addr;
+       w_data.pmic_reg_data[0].value = data;
+
+       ret_val = mrst_pmic_iowrite(&w_data);
+       if (ret_val) {
+               printk(KERN_ERR "MRST IPC writeb failed! \n");
+               return ret_val;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(mrst_pmic_iowriteb);
+
+/**
+ * int mrst_pmic_ioread() - This function reads the data from PMIC
+ * registers and fills the user specified buffer with data.
+ * @struct mrst_pmic_reg_data *p_read_reg_data: pointer to user-defined
+ * structure containing PMIC register address and data fields.
+ *
+ * This function reads requested data from PMIC registers and fills the user
+ * specified buffer with data. It returns 0 on success and returns -1 or
+ * an appropriate error-code if the function failed to read IPC data.
+ */
+int mrst_pmic_ioread(struct mrst_pmic_reg_data *p_read_reg_data)
+{
+       union mrst_ipc_fw_cmd ipc_cmd;
+       u32 *ipc_wbuf;
+       u8 cbuf[IPC_BUF_LEN] = { '\0' };
+       u32 cnt = 0;
+       u32 i = 0;
+       u32 rbuf_offset = 2;
+       ipc_wbuf = (u32 *)&cbuf;
+
+
+       if (p_read_reg_data == NULL) {
+               printk(KERN_ERR "mrst_pmic_ioread: No reg data\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+       if (p_read_reg_data->num_entries > MAX_NUM_ENTRIES) {
+               printk(KERN_ERR "mrst_pmic_ioread: num_entries too high\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+
+       mrst_set_ipc_cmd_fields(&ipc_cmd, p_read_reg_data->ioc,
+                               3*p_read_reg_data->num_entries, PMIC_REG_READ);
+
+       for (i = 0; i < p_read_reg_data->num_entries; i++) {
+               cbuf[cnt] = p_read_reg_data->pmic_reg_data[i].register_address;
+               cbuf[cnt + 1] =
+               p_read_reg_data->pmic_reg_data[i].register_address >> 8;
+               cbuf[cnt + 2] = p_read_reg_data->pmic_reg_data[i].value;
+               cnt = cnt + 3;
+       }
+
+       /*MRST SCU Busy-Bit check*/
+       if (is_mrst_scu_busy()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+       rbuf_offset = 0;
+       for (i = 0; i < p_read_reg_data->num_entries; i++) {
+               writel(ipc_wbuf[i], p_mrst_ipc_base + IPC_WBUF + rbuf_offset);
+               rbuf_offset += 4;
+               if (i >= 3)
+                       break;
+       }
+
+       mrst_ipc_send_cmd(ipc_cmd.cmd_data);
+
+       /* Wait for command completion from SCU firmware */
+       if (wait_for_scu_cmd_completion(ipc_cmd.cmd_parts.ioc)) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       /* IPC driver expects interrupt when IOC is set to 1.*/
+       if (ipc_cmd.cmd_parts.ioc == 1 && scu_cmd_completed == false) {
+               printk(KERN_ERR "mrst_pmic: No interrupt on timeout\n");
+               mutex_unlock(&mrst_ipc_mutex);
+               return -ETIMEDOUT;
+       }
+       /* Read RBUF if there is no error*/
+       if (is_mrst_scu_error()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+
+       rbuf_offset = 2;
+       for (i = 0; i < p_read_reg_data->num_entries; i++) {
+               p_read_reg_data->pmic_reg_data[i].value =
+               readb(p_mrst_ipc_base + IPC_RBUF + rbuf_offset);
+               rbuf_offset += 3;
+       }
+
+       mutex_unlock(&mrst_ipc_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(mrst_pmic_ioread);
+
+/**
+ * int mrst_pmic_iowrite() - PMIC register write API.
+ * @struct mrst_pmic_reg_data *p_write_reg_data: pointer to PMIC write
+ * data structure.
+ *
+ * This function writes the user-specified data to the PMIC registers. The
+ * function returns 0 on success and returns -1 or an appropriate error-code
+ * if the function failed to process the write request.
+ */
+int mrst_pmic_iowrite(struct mrst_pmic_reg_data *p_write_reg_data)
+{
+       union mrst_ipc_fw_cmd ipc_cmd;
+       u32 *ipc_wbuf;
+       u8 cbuf[IPC_BUF_LEN] = { '\0' };
+       u32 cnt = 0;
+       u32 i = 0;
+       u32 rbuf_offset = 2;
+
+       ipc_wbuf = (u32 *)&cbuf;
+
+       if (p_write_reg_data == NULL) {
+               printk(KERN_ERR "mrst_pmic_write: write_reg_data is NULL\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+       if (p_write_reg_data->num_entries > MAX_NUM_ENTRIES) {
+               printk(KERN_ERR "mrst_pmic_write: num entries too high\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+
+       mrst_set_ipc_cmd_fields(&ipc_cmd, p_write_reg_data->ioc,
+                       3*p_write_reg_data->num_entries, PMIC_REG_WRITE);
+
+       for (i = 0; i < p_write_reg_data->num_entries; i++) {
+               cbuf[cnt] = p_write_reg_data->pmic_reg_data[i].register_address;
+               cbuf[cnt + 1] =
+               p_write_reg_data->pmic_reg_data[i].register_address >> 8;
+               cbuf[cnt + 2] = p_write_reg_data->pmic_reg_data[i].value;
+               cnt = cnt + 3;
+       }
+       /*MRST SCU Busy-Bit check*/
+       if (is_mrst_scu_busy()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       rbuf_offset = 0;
+       for (i = 0; i < p_write_reg_data->num_entries; i++) {
+               writel(ipc_wbuf[i], p_mrst_ipc_base + IPC_WBUF
+                                                        + rbuf_offset);
+               rbuf_offset += 4;
+               if (i >= 3)
+                       break;
+       }
+       mrst_ipc_send_cmd(ipc_cmd.cmd_data);
+
+       /* Wait for command completion from SCU firmware */
+       if (wait_for_scu_cmd_completion(ipc_cmd.cmd_parts.ioc)) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       /*Check for error in command processing*/
+       if (is_mrst_scu_error()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+       mutex_unlock(&mrst_ipc_mutex);
+       return 0;
+}
+EXPORT_SYMBOL(mrst_pmic_iowrite);
+
+/**
+ * int mrst_pmic_ioread_modify() - Performs PMIC register read modified
+ * writes.
+ * @struct mrst_pmic_mod_reg_data *p_read_mod_reg_data: pointer to user-defined
+ * structure containing PMIC register address and data fields.
+ *
+ * This function reads the requested data from PMIC registers after a bit-map
+ * modification as defined by the calling host driver.
+ */
+int mrst_pmic_ioread_modify(struct mrst_pmic_mod_reg_data
+                               *p_read_mod_reg_data)
+{
+       union mrst_ipc_fw_cmd ipc_cmd;
+       u32 *ipc_wbuf;
+       u8 cbuf[IPC_BUF_LEN] = { '\0' };
+       u32 cnt = 0;
+       u32 i = 0;
+       u32 rbuf_offset = 2;
+       ipc_wbuf = (u32 *)&cbuf;
+
+
+       if (p_read_mod_reg_data == NULL) {
+               printk(KERN_ERR "mrst_pmic_ioread_modify: reg_data is NULL\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+       if (p_read_mod_reg_data->num_entries > MAX_NUM_RMW_ENTRIES) {
+               printk(KERN_ERR "mrst_pic_ioread_modify: num_entries too high\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+
+       mrst_set_ipc_cmd_fields(&ipc_cmd, p_read_mod_reg_data->ioc,
+                       4*p_read_mod_reg_data->num_entries,
+                                       PMIC_REG_READ_MODIFY);
+
+       for (i = 0; i < p_read_mod_reg_data->num_entries; i++) {
+               cbuf[cnt] =
+               p_read_mod_reg_data->pmic_mod_reg_data[i].register_address;
+               cbuf[cnt + 1] = p_read_mod_reg_data->
+                               pmic_mod_reg_data[i].register_address >> 8;
+               cbuf[cnt + 2] = p_read_mod_reg_data->
+                               pmic_mod_reg_data[i].value;
+               cbuf[cnt + 3] = p_read_mod_reg_data->
+                               pmic_mod_reg_data[i].bit_map;
+               cnt = cnt + 4;
+       }
+
+       /*MRST SCU Busy-Bit check*/
+       if (is_mrst_scu_busy()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       rbuf_offset = 0;
+       for (i = 0; i < p_read_mod_reg_data->num_entries; i++) {
+               writel(ipc_wbuf[i],
+                       p_mrst_ipc_base + IPC_WBUF + rbuf_offset);
+               if (i >= 3)
+                       break;
+       }
+       mrst_ipc_send_cmd(ipc_cmd.cmd_data);
+
+       /* Wait for command completion from SCU firmware */
+       if (wait_for_scu_cmd_completion(ipc_cmd.cmd_parts.ioc)) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       /* IPC driver expects interrupt when IOC is set to 1.*/
+       if (ipc_cmd.cmd_parts.ioc == 1 && scu_cmd_completed == false) {
+               mutex_unlock(&mrst_ipc_mutex);
+               printk(KERN_ERR "ERROR! IPC: No Interrupt got on Timeout\n");
+               return -ETIMEDOUT;
+       }
+
+       /* Read RBUF if there is no error*/
+       if (is_mrst_scu_error()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+
+       /* On wake-up fill the user buffer with IPC_RBUF data.*/
+       rbuf_offset = 2;
+       for (i = 0; i < p_read_mod_reg_data->num_entries; i++) {
+               p_read_mod_reg_data->pmic_mod_reg_data[i].value =
+                       readb(p_mrst_ipc_base + IPC_RBUF + rbuf_offset);
+               rbuf_offset += 4;
+       }
+       mutex_unlock(&mrst_ipc_mutex);
+       return 0;
+}
+EXPORT_SYMBOL(mrst_pmic_ioread_modify);
+
+/**
+ * int mrst_ipc_read32() - This function is used by any host driver to request
+ * for IPC driver to process an indirect read operation.
+ * @struct mrst_ipc_reg_data *p_reg_data: Pointer to register data for indirect
+ * reads.
+ *
+ * This API provides mechanism to read a 32bit data from a user-specified
+ * valid 32bit address.
+ */
+int mrst_ipc_read32(struct mrst_ipc_reg_data *p_reg_data)
+{
+       union mrst_ipc_fw_cmd ipc_cmd;
+
+       if (p_reg_data == NULL) {
+               printk(KERN_ERR "mrst_ipc_read32: p_reg_data is NULL\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+
+       mrst_set_ipc_cmd_fields(&ipc_cmd, p_reg_data->ioc, 4, 0);
+       /* Override with INDIRECT_READ and size command */
+       ipc_cmd.cmd_parts.cmd = INDIRECT_READ;
+
+       /*MRST SCU Busy-Bit check*/
+       if (is_mrst_scu_busy()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+       writel(p_reg_data->address, (p_mrst_ipc_base + IPC_SPTR));
+       mrst_ipc_send_cmd(ipc_cmd.cmd_data);
+
+       /* Wait for command completion from SCU firmware */
+       if (wait_for_scu_cmd_completion(ipc_cmd.cmd_parts.ioc)) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       /* IPC driver expects interrupt when IOC is set to 1.*/
+       if (ipc_cmd.cmd_parts.ioc == 1 && scu_cmd_completed == false) {
+               mutex_unlock(&mrst_ipc_mutex);
+               printk(KERN_ERR "mrst_ipc_read32: No Interrupt on Timeout\n");
+               return -ETIMEDOUT;
+       }
+
+       /* Read RBUF if there is no error*/
+       if (is_mrst_scu_error()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+       /* Command completed successfully Read the data */
+       p_reg_data->data = readl(p_mrst_ipc_base + IPC_RBUF);
+
+       mutex_unlock(&mrst_ipc_mutex);
+       return 0;
+}
+EXPORT_SYMBOL(mrst_ipc_read32);
+
+/**
+ * int mrst_ipc_write32 - function is used by any host driver to request
+ * for IPC driver to process an indirect write operation.
+ * @struct mrst_ipc_reg_data *p_reg_data: Pointer to register data for indirect
+ * writes.
+ *
+ * This API provides mechanism to write a 32bit data from a user-specified
+ * valid 32bit address.
+ */
+int mrst_ipc_write32(struct mrst_ipc_reg_data *p_reg_data)
+{
+       union mrst_ipc_fw_cmd ipc_cmd;
+
+       if (p_reg_data == NULL) {
+               printk(KERN_ERR "mrst_ipc_write32: p_reg_data is NULL\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+
+       mrst_set_ipc_cmd_fields(&ipc_cmd, p_reg_data->ioc, 4, 0);
+       /*Override this function specific fields*/
+       ipc_cmd.cmd_parts.cmd = INDIRECT_WRITE;
+
+       /*MRST SCU Busy-Bit check*/
+       if (is_mrst_scu_busy()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+       writel(p_reg_data->address, (p_mrst_ipc_base + IPC_DPTR));
+       writel(p_reg_data->data, (p_mrst_ipc_base + IPC_WBUF));
+       mrst_ipc_send_cmd(ipc_cmd.cmd_data);
+
+       /* Wait for command completion from SCU firmware */
+       if (wait_for_scu_cmd_completion(ipc_cmd.cmd_parts.ioc)) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       /*Check for error in command processing*/
+       if (is_mrst_scu_error()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+       mutex_unlock(&mrst_ipc_mutex);
+       return 0;
+}
+EXPORT_SYMBOL(mrst_ipc_write32);
+
+/**
+ * int mrst_ipc_set_watchdog() - Function provides interface to set kernel watch
+ * dog timer using the SCU firmware command.
+ * @struct watchdog_reg_data *p_watchdog_reg_data: Pointer to data user
+ * defined data structure.
+ *
+ * This function provides and interface to to set kernel watch-dog
+ * timer using the SCU firmware command.
+ */
+int mrst_ipc_set_watchdog(struct watchdog_reg_data *p_watchdog_reg_data)
+{
+       union mrst_ipc_fw_cmd ipc_cmd;
+       u32 *ipc_wbuf;
+       u8 cbuf[16] = { '\0' };
+       u32 rbuf_offset = 2;
+
+       ipc_wbuf = (u32 *)&cbuf;
+
+       if (p_watchdog_reg_data == NULL) {
+               printk(KERN_ERR "mrst_ipc_set_watchdog: reg_data is NULL\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+
+       mrst_set_ipc_cmd_fields(&ipc_cmd, p_watchdog_reg_data->ioc, 2, 0x0);
+       /*Override this function specific fields*/
+       ipc_cmd.cmd_parts.cmd = IPC_SET_WATCHDOG_TIMER;
+
+       /*MRST SCU Busy-Bit check*/
+       if (is_mrst_scu_busy()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+       ipc_wbuf[0] = p_watchdog_reg_data->payload1;
+       writel(ipc_wbuf[0], p_mrst_ipc_base + IPC_WBUF + rbuf_offset);
+
+       ipc_wbuf[1] = p_watchdog_reg_data->payload2;
+       writel(ipc_wbuf[1], p_mrst_ipc_base + IPC_WBUF + rbuf_offset);
+
+       /*execute the command by writing to IPC_CMD registers*/
+       mrst_ipc_send_cmd(ipc_cmd.cmd_data);
+
+       /* Wait for command completion from SCU firmware */
+       if (wait_for_scu_cmd_completion(ipc_cmd.cmd_parts.ioc)) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EBUSY;
+       }
+
+       /* IPC driver expects interrupt when IOC is set to 1.*/
+       if (ipc_cmd.cmd_parts.ioc == 1 && scu_cmd_completed == false) {
+               mutex_unlock(&mrst_ipc_mutex);
+               printk(KERN_ERR
+                       "mrst_ipc_set_watchdog: No Interrupt on timeout\n");
+               return -ETIMEDOUT;
+       }
+
+       /*Check for error in command processing*/
+       if (is_mrst_scu_error()) {
+               mutex_unlock(&mrst_ipc_mutex);
+               return -EINVAL;
+       }
+       mutex_unlock(&mrst_ipc_mutex);
+       return 0;
+}
+EXPORT_SYMBOL(mrst_ipc_set_watchdog);
+
+/**
+ * int mrst_ipc_program_io_bus_master(): This function will be used by calling
+ * host driver to access registers located in the DFT shims.
+ * @ipc_io_bus_master_regs *p_reg_data: inputstructure containing
+ * ctrl_reg_addr and data_reg_addr.
+ * This function will be used by the calling host driver to access registers
+ * located in the DFT shims. The API reads or writes to DFT shims based on the
+ * operation specified by the CTRL_REG_ADDR register.
+ */
+int mrst_ipc_program_io_bus_master(struct mrst_ipc_io_bus_master_regs
+                                                               *p_reg_data)
+{
+       u32 io_bus_master_cmd = 0;
+
+       if (p_reg_data == NULL) {
+               printk(KERN_ERR
+               "mrst_ipc_program_io_bus_master: p_reg_data is NULL\n");
+               WARN_ON(1);
+               return -EINVAL;
+       }
+
+       mutex_lock(&mrst_ipc_mutex);
+       /* Read the first byte for command*/
+       io_bus_master_cmd = (p_reg_data->ctrl_reg_addr)&(0xFF000000);
+       io_bus_master_cmd = (io_bus_master_cmd >> 24);
+
+       if (io_bus_master_cmd == NOP_CMD) {
+               lnw_ipc_dbg("NOP_CMD = 0x%x\n", io_bus_master_cmd);
+       } else if (io_bus_master_cmd == READ_CMD) {
+               lnw_ipc_dbg("Address %#xp = data = %#x\n",
+                       (unsigned int)(p_mrst_i2c_ser_bus + CTRL_REG_ADDR),
+                                               p_reg_data->ctrl_reg_addr);
+               writel(p_reg_data->ctrl_reg_addr, (p_mrst_i2c_ser_bus
+                                                       + CTRL_REG_ADDR));
+               p_reg_data->ctrl_reg_data =
+                       readl(p_mrst_i2c_ser_bus + CTRL_REG_DATA);
+       } else if (io_bus_master_cmd == WRITE_CMD) {
+               writel(p_reg_data->ctrl_reg_data, (p_mrst_i2c_ser_bus
+                                                       + CTRL_REG_DATA));
+               writel(p_reg_data->ctrl_reg_addr, p_mrst_i2c_ser_bus
+                                                       + CTRL_REG_ADDR);
+       } else {
+               printk(KERN_ERR
+                       "mrst_program_io_bus_master: invalid cmd = 0x%x\n",
+                                                       io_bus_master_cmd);
+               mutex_unlock(&mrst_ipc_mutex);
+               WARN_ON(1);
+               return -EINVAL;
+       }
+       mutex_unlock(&mrst_ipc_mutex);
+       return 0;
+}
+EXPORT_SYMBOL(mrst_ipc_program_io_bus_master);
+
+/* Set the command fields for IPC_CMD */
+static inline int mrst_set_ipc_cmd_fields(union mrst_ipc_fw_cmd *ipc_cmd,
+                                       u8 ioc, u32 size, u8 cmd_id)
+{
+       ipc_cmd->cmd_parts.cmd = IPC_PMIC_CMD_READ_WRITE;
+       ipc_cmd->cmd_parts.ioc = ioc;
+       ipc_cmd->cmd_parts.rfu1 = 0x0;
+       ipc_cmd->cmd_parts.cmd_ID = cmd_id;
+       ipc_cmd->cmd_parts.size = size;
+       return 0;
+}
+/* Wait for command completion from SCU firmware */
+static inline int wait_for_scu_cmd_completion(u8 mrst_ipc_ioc_bit)
+{
+       union mrst_ipc_sts ipc_sts_reg;
+       u64 time_to_wait = 0xFF;
+
+       if (mrst_ipc_ioc_bit) {
+               /*wait for 10ms do not tie to kernel timer_ticks*/
+               time_to_wait = msecs_to_jiffies(IPC_TIMEOUT);
+               /* Wait for command completion from SCU firmware */
+               wait_event_interruptible_timeout(mrst_cmd_wait,
+                               scu_cmd_completed, time_to_wait);
+               return 0;
+       } else {
+               udelay(IPC_WAIT_TIME);
+               ipc_sts_reg.ipc_sts_data = readl(p_mrst_ipc_base + IPC_STS);
+               if (ipc_sts_reg.ipc_sts_parts.busy) {
+                       printk(KERN_ERR "wait_for_scu_cmd_completion:\
+                                       Timeout ioc = 0 and SCU is busy%d\n",
+                                       ipc_sts_reg.ipc_sts_parts.busy);
+                       return -EBUSY;
+               }
+       }
+       return 0; /*SCU Not busy*/
+}
+
+/*MRST SCU Error-Bit check*/
+static inline int is_mrst_scu_error(void)
+{
+       union mrst_ipc_sts ipc_sts_reg;
+
+       ipc_sts_reg.ipc_sts_data = readl(p_mrst_ipc_base + IPC_STS);
+       if (ipc_sts_reg.ipc_sts_parts.error) {
+               printk(KERN_ERR "is_mrst_scu_error: Command failed Error\
+                       code = %#x\n", ipc_sts_reg.ipc_sts_parts.error);
+               WARN_ON(1);
+               return -EINVAL;
+       }
+       return 0; /*No error*/
+}
+
+/*MRST SCU Busy-Bit check*/
+static inline int is_mrst_scu_busy(void)
+{
+       union mrst_ipc_sts ipc_sts_reg;
+       u32 retry = MAX_RETRY_CNT;
+
+       while (retry--) {
+               ipc_sts_reg.ipc_sts_data = readl(p_mrst_ipc_base + IPC_STS);
+               if (!ipc_sts_reg.ipc_sts_parts.busy)
+                       break;
+               udelay(USLEEP_STS_TIMEOUT); /*10usec*/
+       }
+       if (ipc_sts_reg.ipc_sts_parts.busy) {
+               printk(KERN_DEBUG "is_mrst_scu_busy: SCU is busy %d\n",
+                                       ipc_sts_reg.ipc_sts_parts.busy);
+               return -EBUSY;
+       }
+       return 0; /*SCU Not busy*/
+}
+
+/*Send the command to SCU */
+static void mrst_ipc_send_cmd(u32 cmd_data)
+{
+       scu_cmd_completed = false;
+       writel(cmd_data, p_mrst_ipc_base + IPC_CMD);
+}
+
+static int do_mrst_ipc_battery(u32 cmd, u8 ioc, u32 *data)
+{
+       union mrst_ipc_fw_cmd ipc_cca_cmd;
+       union mrst_ipc_sts ipc_sts_reg;
+
+       /* Fill in the common fields */
+       ipc_cca_cmd.cmd_parts.cmd = IPC_CCA_CMD_READ_WRITE;
+       ipc_cca_cmd.cmd_parts.rfu1 = 0x0;
+       ipc_cca_cmd.cmd_parts.size = 0;
+       ipc_cca_cmd.cmd_parts.rfu2 = 0x0;
+
+       /* Caller dependant fields */
+       ipc_cca_cmd.cmd_parts.ioc = ioc;
+       ipc_cca_cmd.cmd_parts.cmd_ID = cmd;
+
+       /* MRST SCU busy bit check */
+       if (is_mrst_scu_busy())
+               return -EBUSY;
+
+       scu_cmd_completed = false;
+
+       /* If we have data write the data field */
+       if (data)
+               writel(*data, p_mrst_ipc_base + IPC_WBUF + 4);
+       /* and the command */
+       writel(ipc_cca_cmd.cmd_data, p_mrst_ipc_base + IPC_CMD);
+
+       /* Wait for command completion from SCU firmware */
+       if (wait_for_scu_cmd_completion(ioc))
+               return -EBUSY;
+
+       /*Check for error in command processing*/
+       ipc_sts_reg.ipc_sts_data = readl(p_mrst_ipc_base + IPC_STS);
+       if (is_mrst_scu_error())
+               return -EINVAL;
+
+       return 0;
+}
+
+MODULE_AUTHOR("Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>");
+MODULE_DESCRIPTION("Intel Moorestown IPC driver");
+MODULE_LICENSE("GPL V2");
+
+module_init(ipc_mrst_init);
+module_exit(ipc_mrst_exit);
diff --git a/arch/x86/kernel/mrst_ipc.h b/arch/x86/kernel/mrst_ipc.h
new file mode 100644
index 0000000..d234d68
--- /dev/null
+++ b/arch/x86/kernel/mrst_ipc.h
@@ -0,0 +1,238 @@
+/*
+ * ipc_mrst.h: Driver for Langwell IPC1
+ * Copyright (C) 2009  Intel Corp
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Sreenidhi Gurudatt
+ * Contact information: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>
+ */
+
+#ifndef __IPC_MRST_H__
+#define __IPC_MRST_H__
+
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
+#ifdef LNW_IPC_DEBUG
+
+#define lnw_ipc_dbg(fmt, args...) \
+       do { printk(KERN_INFO fmt, ## args); } while (0)
+#else
+#define lnw_ipc_dbg(fmt, args...) do { } while (0)
+#endif
+
+#define MRST_IPC_DRIVER_VERSION "0.01.005"
+#define IPC_TIMEOUT            100     /*Wait in msecs*/
+#define IPC_WAIT_TIME          5000    /*Wait in usecs*/
+#define MAX_RETRY_CNT          10
+#define MAX_NB_BUF_SIZE                100
+#define IPC_BUF_LEN            16
+#define MAX_NUM_ENTRIES                5
+#define MAX_NUM_RMW_ENTRIES    4
+#define USLEEP_STS_TIMEOUT     100
+
+#define LNW_IPC1_BASE          0xff11c000
+#define LNW_IPC1_MMAP_SIZE     1024
+
+#define LNW_IPC1
+#define LNW_IPC_CMD            0x00
+#define LNW_IPC_STS            0x04
+#define LNW_IPC_DPTR           0x08
+#define LNW_IPC_WBUF           0x80
+#define LNW_IPC_RBUF           0x90
+#define LNW_IPC_RWBUF_SIZE     16
+
+/* IPC status register layout */
+#define LNW_IPC_STS_BUSY       (1<<0)
+#define LNW_IPC_STS_ERR                (1<<1)
+#define LNW_IPC_STS_CMDID      (0xF<<4)
+#define LNW_IPC_STS_INITID     (0xFF<<8)
+#define LNW_IPC_STS_ERR_CODE   (0xFF<<16)
+
+/* IPC command register layout */
+#define LNW_IPC_CMD_CMD                (0xFF<<0)
+#define LNW_IPC_CMD_MSI                (1<<8)
+#define LNW_IPC_CMD_ID         (0xF<<12)
+#define LNW_IPC_CMD_SIZE       (0xFF<<16)
+
+enum IPC_CMD {
+       NORMAL_WRITE,           /*0x00 Normal Write */
+       MSG_WRITE,              /*0x01 Message Write */
+       INDIRECT_READ,          /*0x02 Indirect Read */
+       RSVD,                   /*0x03 Reserved */
+       READ_DMA,               /*0x04 Read DMA */
+       INDIRECT_WRITE,         /*0x05 Indirect write */
+};
+
+int lnw_ipc_send_cmd(unsigned char cmd, int size, int msi);
+
+/**
+ *  struct mrst_ipc_driver - the basic blah structure
+ *  @const char *name: Name of the driver (mrst_ipc_mrst).
+ *  @irq : Pointer to irq function.
+ *  @flags: Flags.
+ */
+struct mrst_ipc_driver {
+       const char *name;
+       irqreturn_t(*irq) (int irq, void *ipc);
+       int flags;
+};
+
+/*
+ * defines specific to mrst_ipc_driver and
+ * not exposed outside
+ */
+
+/*cmd_ID fields for CCA Read/Writes*/
+
+#define CCA_REG_WRITE                  0x0000
+#define CCA_REG_READ                   0x0001
+#define CCA_REG_GET_PROP               0x0002
+
+#define IPC_SET_WATCHDOG_TIMER         0xF8
+#define IPC_CCA_CMD_READ_WRITE         0xEF
+#define IPC_DEVICE_FIRMWARE_UPGRADE    0xFE
+#define IPC_PMIC_CMD_READ_WRITE                0xFF
+
+/*cmd_ID fields for CCA Read/Writes*/
+#define PMIC_REG_WRITE                 0x0000
+#define PMIC_REG_READ                  0x0001
+#define PMIC_REG_READ_MODIFY           0x0002
+#define LPE_READ                       0x0003
+#define LPE_WRITE                      0x0004
+
+#define IPC_CMD_GO_TO_DFU_MODE         0x0001
+#define IPC_CMD_UPDATE_FW              0x0002
+#define IPC_CMD_FORCE_UPDATE_FW        0x0003
+
+#define NORMAL_WRITE                   0x00
+#define MESSAGE_WRITE                  0x01
+#define INDIRECT_READ                  0x02
+#define INDIRECT_WRITE                 0x05
+#define READ_DMA                       0x04
+
+
+/* Used to override user option        */
+#define IOC                            1
+
+#define IPC_REG_ISR_FAILED             0xFF
+
+/*********************************************
+ * Define IPC_Base_Address and offsets
+ ********************************************/
+#define IPC_BASE_ADDRESS       0xFF11C000
+#define I2C_SER_BUS            0xFF12B000
+#define DFU_LOAD_ADDR          0xFFFC0000
+#define NOP_CMD                0x00
+#define WRITE_CMD      0x01
+#define READ_CMD       0x02
+
+/*256K storage size for loading the FW image.*/
+#define MAX_FW_SIZE            262144
+
+/* IPC2 offset addresses */
+#define IPC_MAX_ADDRESS        0x100
+/* I2C offset addresses - Confirm this */
+#define I2C_MAX_ADDRESS        0x10
+/* Offsets for CTRL_REG_ADDR and CTRL_REG_DATA */
+#define CTRL_REG_ADDR          0x00
+#define CTRL_REG_DATA          0x04
+#define I2C_MAX_ADDRESS        0x10
+
+#define IPC_CMD                        0x00
+#define IPC_STS                        0x04
+#define IPC_SPTR               0x08
+#define IPC_DPTR               0x0C
+#define IPC_WBUF               0x80
+#define IPC_RBUF               0x90
+
+/**
+ *  union  mrst_ipc_sts - IPC_STS register data structure.
+ *  @u32 busy:1 - busy field.
+ *  @u32 error:1 - error field.
+ *  @u32 rfu1:2 - reserved field.
+ *  @u32 cmd_id:4 - command_id field.
+ *  @u32 initiator_id:8 - initiater_id field.
+ *  @u32 error_code:8 - error_code field.
+ *  @u32 rfu3:8 - reserved field.
+ */
+union mrst_ipc_sts {
+       struct {
+               u32 busy:1;
+               u32 error:1;
+               u32 rfu1:2;
+               u32 cmd_id:4;
+               u32 initiator_id:8;
+               u32 error_code:8;
+               u32 rfu3:8;
+       } ipc_sts_parts;
+       u32 ipc_sts_data;
+};
+
+/**
+ *  union  mrst_ipc_fw_cmd - IPC_CMD register data structure.
+ *  @u32 cmd:8 - busy field.
+ *  @u32 ioc:1 - error field.
+ *  @u32 rfu1:3 - reserved field.
+ *  @u32 cmd_id:4 - command_id field.
+ *  @u32 size:8 - initiater_id field.
+ *  @u32 rfu2:8 - reserved field.
+ */
+union mrst_ipc_fw_cmd {
+       struct {
+               u32 cmd:8;
+               u32 ioc:1;
+               u32 rfu1:3;
+               u32 cmd_ID:4;
+               u32 size:8;
+               u32 rfu2:8;
+       } cmd_parts;
+       u32 cmd_data;
+};
+
+/**
+ *  struct mrst_ipc_intr - IPC_CMD register data structure.
+ *  @u8 cmd - cmd field.
+ *  @u32 data - data field.
+ */
+struct mrst_ipc_intr {
+       u8 cmd;
+       u32 data;
+
+};
+
+/**
+ *  struct mrst_ipc_work_struct - IPC work structure with command_id.
+ *  @struct work_struct mrst_ipc_work - work data structure.
+ *  @u32 cmd_id - command_id field.
+ */
+struct mrst_ipc_work_struct{
+       struct work_struct ipc_work;
+       u32 cmd_id;
+};
+
+int init_mrst_ipc_driver(void);
+static inline int is_mrst_scu_busy(void);
+static inline int mrst_set_ipc_cmd_fields(union mrst_ipc_fw_cmd *ipc_cmd,
+                                       u8 ioc, u32 size, u8 cmd_id);
+static int do_mrst_ipc_battery(u32 cmd, u8 ioc, u32 *data);
+static void mrst_ipc_send_cmd(u32 cmd_data);
+static inline int wait_for_scu_cmd_completion(u8 mrst_ipc_ioc_bit);
+static inline int is_mrst_scu_error(void);
+static int de_init_mrst_ipc_driver(void);
+
+#endif
--
1.5.4.5

