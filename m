Return-Path: <linux-kernel-owner+w=401wt.eu-S937055AbZDCWCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937055AbZDCWCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936749AbZDCWBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:01:41 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:9845 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762491AbZDCWBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:01:38 -0400
Subject: [PATCH v2] PCI: Add support for turning PCIe ECRC on or off
To: linux-pci@vger.kernel.org
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Date: Fri, 03 Apr 2009 16:01:36 -0600
Message-ID: <20090403220136.22113.83729.stgit@bob.kio>
In-Reply-To: <20090403220131.22113.56040.stgit@bob.kio>
References: <20090403220131.22113.56040.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: Add support for turning PCIe ECRC on or off

Adds support for PCI Express transaction layer end-to-end CRC checking
(ECRC).  This patch will enable/disable ECRC checking by setting/clearing
the ECRC Check Enable and/or ECRC Generation Enable bits for devices that
support ECRC.

The ECRC setting is controlled by the "pci=ecrc=<policy>" command-line
option. If this option is not set or is set to 'bios", the enable and
generation bits are left in whatever state that firmware/BIOS set them to.
The "off" setting turns them off, and the "on" option turns them on (if the
device supports it).

Turning ECRC on or off can be a data integrity versus performance
tradeoff.  In theory, turning it on will catch more data errors, turning
it off means possibly better performance since CRC does not need to be
calculated by the PCIe hardware and packet sizes are reduced.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1754fed..56cdd5f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1769,6 +1769,12 @@ and is between 256 and 4096 characters. It is defined in the file
 				PAGE_SIZE is used as alignment.
 				PCI-PCI bridge can be specified, if resource
 				windows need to be expanded.
+		ecrc=		Enable/disable PCIe ECRC (transaction layer
+				end-to-end CRC checking).
+				bios: Use BIOS/firmware settings. This is the
+				the default.
+				off: Turn ECRC off
+				on: Turn ECRC on.
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 59569b8..65e8a53 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2555,6 +2555,8 @@ static int __init pci_setup(char *str)
 			} else if (!strncmp(str, "resource_alignment=", 19)) {
 				pci_set_resource_alignment_param(str + 19,
 							strlen(str + 19));
+			} else if (!strncmp(str, "ecrc=", 5)) {
+				pcie_ecrc_get_policy(str + 5);
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 5a0c6ad..a79e52b 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -46,3 +46,15 @@ config PCIEASPM_DEBUG
 	help
 	  This enables PCI Express ASPM debug support. It will add per-device
 	  interface to control ASPM.
+
+#
+# PCI Express ECRC
+#
+config PCIE_ECRC
+	bool "PCI Express ECRC support"
+	depends on PCI
+	help
+	  Enables PCI Express ECRC (transaction layer end-to-end CRC
+	  checking)
+
+	  When in doubt, say N.
diff --git a/drivers/pci/pcie/Makefile b/drivers/pci/pcie/Makefile
index 11f6bb1..2f8ce01 100644
--- a/drivers/pci/pcie/Makefile
+++ b/drivers/pci/pcie/Makefile
@@ -5,6 +5,8 @@
 # Build PCI Express ASPM if needed
 obj-$(CONFIG_PCIEASPM)		+= aspm.o
 
+obj-$(CONFIG_PCIE_ECRC)		+= ecrc.o
+
 pcieportdrv-y			:= portdrv_core.o portdrv_pci.o portdrv_bus.o
 
 obj-$(CONFIG_PCIEPORTBUS)	+= pcieportdrv.o
diff --git a/drivers/pci/pcie/ecrc.c b/drivers/pci/pcie/ecrc.c
new file mode 100644
index 0000000..d8dd6b6
--- /dev/null
+++ b/drivers/pci/pcie/ecrc.c
@@ -0,0 +1,91 @@
+/*
+ *    Enables/disables PCIe ECRC checking.
+ *
+ *    (C) Copyright 2009 Hewlett-Packard Development Company, L.P.
+ *    Andrew Patterson <andrew.patterson@hp.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; version 2 of the License.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ *    General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ *    02111-1307, USA.
+ *
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+#include <linux/errno.h>
+#include "../pci.h"
+
+#define ECRC_POLICY_DEFAULT 0		/* ECRC set by BIOS */
+#define ECRC_POLICY_OFF     1		/* ECRC off */
+#define ECRC_POLICY_ON      2		/* ECRC on */
+
+static int ecrc_policy = ECRC_POLICY_DEFAULT;
+
+static const char *ecrc_policy_str[] = {
+	[ECRC_POLICY_DEFAULT] = "bios",
+	[ECRC_POLICY_OFF] = "off",
+	[ECRC_POLICY_ON] = "on"
+};
+
+/**
+ * pcie_set_ercr_checking - enable/disable PCIe ECRC checking
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pcie_set_ecrc_checking(struct pci_dev *dev)
+{
+	int pos;
+	u32 reg32;
+
+	if (!dev->is_pcie)
+		return -ENODEV;
+
+	/* Use firmware/BIOS setting if default */
+	if (ecrc_policy == ECRC_POLICY_DEFAULT)
+		return 0;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return -ENODEV;
+
+	pci_read_config_dword(dev, pos + PCI_ERR_CAP, &reg32);
+	if (ecrc_policy == ECRC_POLICY_OFF) {
+		reg32 &= ~(PCI_ERR_CAP_ECRC_GENE | PCI_ERR_CAP_ECRC_CHKE);
+	} else if (ecrc_policy == ECRC_POLICY_ON) {
+		if (reg32 & PCI_ERR_CAP_ECRC_GENC)
+			reg32 |= PCI_ERR_CAP_ECRC_GENE;
+		if (reg32 & PCI_ERR_CAP_ECRC_CHKC)
+			reg32 |= PCI_ERR_CAP_ECRC_CHKE;
+	}
+	pci_write_config_dword(dev, pos + PCI_ERR_CAP, reg32);
+	return 0;
+}
+
+void pcie_ecrc_get_policy(char *str)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ecrc_policy_str); i++)
+		if (!strncmp(str, ecrc_policy_str[i],
+			     strlen(ecrc_policy_str[i])))
+			break;
+	if (i >= ARRAY_SIZE(ecrc_policy_str))
+		return;
+
+	ecrc_policy = i;
+}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e2f3dd0..df8f909 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -984,6 +984,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	/* Single Root I/O Virtualization */
 	pci_iov_init(dev);
+
+	/* PCIe end-to-end CRC checking */
+	pcie_set_ecrc_checking(dev);
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6fb335b..4275e2f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -874,6 +874,17 @@ static inline int pcie_aspm_enabled(void)
 extern int pcie_aspm_enabled(void);
 #endif
 
+#ifndef CONFIG_PCIE_ECRC
+static inline int pcie_set_ecrc_checking(struct pci_dev *dev)
+{
+	return 0;
+}
+static inline void pcie_ecrc_get_policy(char *str) {};
+#else
+extern int pcie_set_ecrc_checking(struct pci_dev *dev);
+extern void pcie_ecrc_get_policy(char *str);
+#endif
+
 #define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
 
 #ifdef CONFIG_HT_IRQ

