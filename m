Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbZDVWwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbZDVWwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZDVWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:52:12 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:25461 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZDVWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:52:09 -0400
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH v3] PCI: Add support for turning PCIe ECRC on or off
To: linux-pci@vger.kernel.org
Cc: andrew.patterson@hp.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kaneshige.kenji@jp.fujitsu.com
Date: Wed, 22 Apr 2009 16:52:09 -0600
Message-ID: <20090422225208.16081.73220.stgit@bluto.andrew>
In-Reply-To: <20090422225203.16081.94717.stgit@bluto.andrew>
References: <20090422225203.16081.94717.stgit@bluto.andrew>
User-Agent: StGIT/0.14.3
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
diff --git a/drivers/pci/pcie/aer/Kconfig b/drivers/pci/pcie/aer/Kconfig
index c3bde58..db4cb95 100644
--- a/drivers/pci/pcie/aer/Kconfig
+++ b/drivers/pci/pcie/aer/Kconfig
@@ -10,3 +10,16 @@ config PCIEAER
 	  This enables PCI Express Root Port Advanced Error Reporting
 	  (AER) driver support. Error reporting messages sent to Root
 	  Port will be handled by PCI Express AER driver.
+
+
+#
+# PCI Express ECRC
+#
+config PCIE_ECRC
+	bool "PCI Express ECRC settings control"
+	depends on PCIEAER
+	help
+	  Used to override firmware/bios settings for PCI Express ECRC
+	  (transaction layer end-to-end CRC checking).
+
+	  When in doubt, say N.
diff --git a/drivers/pci/pcie/aer/Makefile b/drivers/pci/pcie/aer/Makefile
index 8da3bd8..7f93411 100644
--- a/drivers/pci/pcie/aer/Makefile
+++ b/drivers/pci/pcie/aer/Makefile
@@ -4,6 +4,8 @@
 
 obj-$(CONFIG_PCIEAER) += aerdriver.o
 
+obj-$(CONFIG_PCIE_ECRC)	+= ecrc.o
+
 aerdriver-objs := aerdrv_errprint.o aerdrv_core.o aerdrv.o
 aerdriver-$(CONFIG_ACPI) += aerdrv_acpi.o
 
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 307452f..dd3829e 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -113,15 +113,17 @@ static void set_device_error_reporting(struct pci_dev *dev, void *data)
 {
 	bool enable = *((bool *)data);
 
-	if (dev->pcie_type != PCIE_RC_PORT &&
-	    dev->pcie_type != PCIE_SW_UPSTREAM_PORT &&
-	    dev->pcie_type != PCIE_SW_DOWNSTREAM_PORT)
-		return;
+	if (dev->pcie_type == PCIE_RC_PORT ||
+	    dev->pcie_type == PCIE_SW_UPSTREAM_PORT ||
+	    dev->pcie_type == PCIE_SW_DOWNSTREAM_PORT) {
+		if (enable)
+			pci_enable_pcie_error_reporting(dev);
+		else
+			pci_disable_pcie_error_reporting(dev);
+	}
 
 	if (enable)
-		pci_enable_pcie_error_reporting(dev);
-	else
-		pci_disable_pcie_error_reporting(dev);
+		pcie_set_ecrc_checking(dev);
 }
 
 /**
diff --git a/drivers/pci/pcie/aer/ecrc.c b/drivers/pci/pcie/aer/ecrc.c
new file mode 100644
index 0000000..ece97df
--- /dev/null
+++ b/drivers/pci/pcie/aer/ecrc.c
@@ -0,0 +1,131 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+#include <linux/errno.h>
+#include "../../pci.h"
+
+#define ECRC_POLICY_DEFAULT 0		/* ECRC set by BIOS */
+#define ECRC_POLICY_OFF     1		/* ECRC off for performance */
+#define ECRC_POLICY_ON      2		/* ECRC on for data integrity */
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
+ * enable_ercr_checking - enable PCIe ECRC checking for a device
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+static int enable_ecrc_checking(struct pci_dev *dev)
+{
+	int pos;
+	u32 reg32;
+
+	if (!dev->is_pcie)
+		return -ENODEV;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return -ENODEV;
+
+	pci_read_config_dword(dev, pos + PCI_ERR_CAP, &reg32);
+	if (reg32 & PCI_ERR_CAP_ECRC_GENC)
+		reg32 |= PCI_ERR_CAP_ECRC_GENE;
+	if (reg32 & PCI_ERR_CAP_ECRC_CHKC)
+		reg32 |= PCI_ERR_CAP_ECRC_CHKE;
+	pci_write_config_dword(dev, pos + PCI_ERR_CAP, reg32);
+
+	return 0;
+}
+
+/**
+ * disable_ercr_checking - disables PCIe ECRC checking for a device
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+static int disable_ecrc_checking(struct pci_dev *dev)
+{
+	int pos;
+	u32 reg32;
+
+	if (!dev->is_pcie)
+		return -ENODEV;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return -ENODEV;
+
+	pci_read_config_dword(dev, pos + PCI_ERR_CAP, &reg32);
+	reg32 &= ~(PCI_ERR_CAP_ECRC_GENE | PCI_ERR_CAP_ECRC_CHKE);
+	pci_write_config_dword(dev, pos + PCI_ERR_CAP, reg32);
+
+	return 0;
+}
+
+/**
+ * pcie_set_ecrc_checking - set/unset PCIe ECRC checking for a device based on global policy
+ * @dev: the PCI device
+ */
+void pcie_set_ecrc_checking(struct pci_dev *dev)
+{
+	switch (ecrc_policy) {
+	case ECRC_POLICY_DEFAULT:
+		return;
+	case ECRC_POLICY_OFF:
+		disable_ecrc_checking(dev);
+		break;
+	case ECRC_POLICY_ON:
+		enable_ecrc_checking(dev);;
+		break;
+	default:
+		return;
+	}
+}
+
+/**
+ * pcie_ecrc_get_policy - parse kernel command-line ecrc option
+ */
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
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6fb335b..0a25ccc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -874,6 +874,17 @@ static inline int pcie_aspm_enabled(void)
 extern int pcie_aspm_enabled(void);
 #endif
 
+#ifndef CONFIG_PCIE_ECRC
+static inline void pcie_set_ecrc_checking(struct pci_dev *dev)
+{
+	return;
+}
+static inline void pcie_ecrc_get_policy(char *str) {};
+#else
+extern void pcie_set_ecrc_checking(struct pci_dev *dev);
+extern void pcie_ecrc_get_policy(char *str);
+#endif
+
 #define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
 
 #ifdef CONFIG_HT_IRQ

