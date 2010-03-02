Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0CBBzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:55:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:60233 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab0CBBzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:55:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,563,1262592000"; 
   d="scan'208";a="249621956"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Huang Ying <ying.huang@intel.com>
Subject: [PATCH 2/2] ACPI, APEI, PCIE AER, use general HEST table parsing in AER firmware_first setup
Date: Tue,  2 Mar 2010 09:55:02 +0800
Message-Id: <1267494902-7193-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1267494902-7193-1-git-send-email-ying.huang@intel.com>
References: <1267494902-7193-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, a dedicated HEST tabling parsing code is used for PCIE AER
firmware_first setup. It is rebased on general HEST tabling parsing
code of APEI. The firmware_first setup code is moved from PCI core to
AER driver too, because it is only AER related.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/Makefile              |    1 -
 drivers/acpi/hest.c                |  135 ------------------------------------
 drivers/pci/pcie/aer/aerdrv.h      |    6 ++
 drivers/pci/pcie/aer/aerdrv_acpi.c |   70 +++++++++++++++++++
 drivers/pci/pcie/aer/aerdrv_core.c |    2 +
 drivers/pci/probe.c                |    8 --
 include/acpi/acpi_hest.h           |   12 ---
 7 files changed, 78 insertions(+), 156 deletions(-)
 delete mode 100644 drivers/acpi/hest.c
 delete mode 100644 include/acpi/acpi_hest.h

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index c00d683..3ba7feb 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -20,7 +20,6 @@ obj-y				+= acpi.o \
 # All the builtin files are in the "acpi." module_param namespace.
 acpi-y				+= osl.o utils.o reboot.o
 acpi-y				+= atomicio.o
-acpi-y				+= hest.o
 
 # sleep related files
 acpi-y				+= wakeup.o
diff --git a/drivers/acpi/hest.c b/drivers/acpi/hest.c
deleted file mode 100644
index 4bb18c9..0000000
--- a/drivers/acpi/hest.c
+++ /dev/null
@@ -1,135 +0,0 @@
-#include <linux/acpi.h>
-#include <linux/pci.h>
-
-#define PREFIX "ACPI: "
-
-static inline unsigned long parse_acpi_hest_ia_machine_check(struct acpi_hest_ia_machine_check *p)
-{
-	return sizeof(*p) +
-		(sizeof(struct acpi_hest_ia_error_bank) * p->num_hardware_banks);
-}
-
-static inline unsigned long parse_acpi_hest_ia_corrected(struct acpi_hest_ia_corrected *p)
-{
-	return sizeof(*p) +
-		(sizeof(struct acpi_hest_ia_error_bank) * p->num_hardware_banks);
-}
-
-static inline unsigned long parse_acpi_hest_ia_nmi(struct acpi_hest_ia_nmi *p)
-{
-	return sizeof(*p);
-}
-
-static inline unsigned long parse_acpi_hest_generic(struct acpi_hest_generic *p)
-{
-	return sizeof(*p);
-}
-
-static inline unsigned int hest_match_pci(struct acpi_hest_aer_common *p, struct pci_dev *pci)
-{
-	return	(0           == pci_domain_nr(pci->bus) &&
-		 p->bus      == pci->bus->number &&
-		 p->device   == PCI_SLOT(pci->devfn) &&
-		 p->function == PCI_FUNC(pci->devfn));
-}
-
-static unsigned long parse_acpi_hest_aer(void *hdr, int type, struct pci_dev *pci, int *firmware_first)
-{
-	struct acpi_hest_aer_common *p = hdr + sizeof(struct acpi_hest_header);
-	unsigned long rc=0;
-	u8 pcie_type = 0;
-	u8 bridge = 0;
-	switch (type) {
-	case ACPI_HEST_TYPE_AER_ROOT_PORT:
-		rc = sizeof(struct acpi_hest_aer_root);
-		pcie_type = PCI_EXP_TYPE_ROOT_PORT;
-		break;
-	case ACPI_HEST_TYPE_AER_ENDPOINT:
-		rc = sizeof(struct acpi_hest_aer);
-		pcie_type = PCI_EXP_TYPE_ENDPOINT;
-		break;
-	case ACPI_HEST_TYPE_AER_BRIDGE:
-		rc = sizeof(struct acpi_hest_aer_bridge);
-		if ((pci->class >> 16) == PCI_BASE_CLASS_BRIDGE)
-			bridge = 1;
-		break;
-	}
-
-	if (p->flags & ACPI_HEST_GLOBAL) {
-		if ((pci->is_pcie && (pci->pcie_type == pcie_type)) || bridge)
-			*firmware_first = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
-	}
-	else
-		if (hest_match_pci(p, pci))
-			*firmware_first = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
-	return rc;
-}
-
-static int acpi_hest_firmware_first(struct acpi_table_header *stdheader, struct pci_dev *pci)
-{
-	struct acpi_table_hest *hest = (struct acpi_table_hest *)stdheader;
-	void *p = (void *)hest + sizeof(*hest); /* defined by the ACPI 4.0 spec */
-	struct acpi_hest_header *hdr = p;
-
-	int i;
-	int firmware_first = 0;
-	static unsigned char printed_unused = 0;
-	static unsigned char printed_reserved = 0;
-
-	for (i=0, hdr=p; p < (((void *)hest) + hest->header.length) && i < hest->error_source_count; i++) {
-		switch (hdr->type) {
-		case ACPI_HEST_TYPE_IA32_CHECK:
-			p += parse_acpi_hest_ia_machine_check(p);
-			break;
-		case ACPI_HEST_TYPE_IA32_CORRECTED_CHECK:
-			p += parse_acpi_hest_ia_corrected(p);
-			break;
-		case ACPI_HEST_TYPE_IA32_NMI:
-			p += parse_acpi_hest_ia_nmi(p);
-			break;
-		/* These three should never appear */
-		case ACPI_HEST_TYPE_NOT_USED3:
-		case ACPI_HEST_TYPE_NOT_USED4:
-		case ACPI_HEST_TYPE_NOT_USED5:
-			if (!printed_unused) {
-				printk(KERN_DEBUG PREFIX
-				       "HEST Error Source list contains an obsolete type (%d).\n", hdr->type);
-				printed_unused = 1;
-			}
-			break;
-		case ACPI_HEST_TYPE_AER_ROOT_PORT:
-		case ACPI_HEST_TYPE_AER_ENDPOINT:
-		case ACPI_HEST_TYPE_AER_BRIDGE:
-			p += parse_acpi_hest_aer(p, hdr->type, pci, &firmware_first);
-			break;
-		case ACPI_HEST_TYPE_GENERIC_ERROR:
-			p += parse_acpi_hest_generic(p);
-			break;
-		/* These should never appear either */
-		case ACPI_HEST_TYPE_RESERVED:
-		default:
-			if (!printed_reserved) {
-				printk(KERN_DEBUG PREFIX
-				       "HEST Error Source list contains a reserved type (%d).\n", hdr->type);
-				printed_reserved = 1;
-			}
-			break;
-		}
-	}
-	return firmware_first;
-}
-
-int acpi_hest_firmware_first_pci(struct pci_dev *pci)
-{
-	acpi_status status = AE_NOT_FOUND;
-	struct acpi_table_header *hest = NULL;
-	status = acpi_get_table(ACPI_SIG_HEST, 1, &hest);
-
-	if (ACPI_SUCCESS(status)) {
-		if (acpi_hest_firmware_first(hest, pci)) {
-			return 1;
-		}
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(acpi_hest_firmware_first_pci);
diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
index bd833ea..84e9470 100644
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -134,4 +134,10 @@ static inline int aer_osc_setup(struct pcie_device *pciedev)
 }
 #endif
 
+#ifdef CONFIG_ACPI_APEI
+extern void aer_set_firmware_first(struct pcie_device *dev);
+#else
+static inline void aer_set_firmware_first(struct pcie_device *dev) { }
+#endif
+
 #endif /* _AERDRV_H_ */
diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 0481408..cda43cd 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -16,6 +16,7 @@
 #include <linux/acpi.h>
 #include <linux/pci-acpi.h>
 #include <linux/delay.h>
+#include <acpi/apei.h>
 #include "aerdrv.h"
 
 /**
@@ -53,3 +54,72 @@ int aer_osc_setup(struct pcie_device *pciedev)
 
 	return 0;
 }
+
+#ifdef CONFIG_ACPI_APEI
+static inline int hest_match_pci(struct acpi_hest_aer_common *p, struct pci_dev *pci)
+{
+	return	(0           == pci_domain_nr(pci->bus) &&
+		 p->bus      == pci->bus->number &&
+		 p->device   == PCI_SLOT(pci->devfn) &&
+		 p->function == PCI_FUNC(pci->devfn));
+}
+
+struct aer_hest_parse_info
+{
+	struct pci_dev *pci_dev;
+	int firmware_first;
+};
+
+static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
+{
+	struct aer_hest_parse_info *info = data;
+	struct acpi_hest_aer_common *p;
+	u8 pcie_type = 0;
+	u8 bridge = 0;
+	int ff = 0;
+
+	switch (hest_hdr->type) {
+	case ACPI_HEST_TYPE_AER_ROOT_PORT:
+		pcie_type = PCI_EXP_TYPE_ROOT_PORT;
+		break;
+	case ACPI_HEST_TYPE_AER_ENDPOINT:
+		pcie_type = PCI_EXP_TYPE_ENDPOINT;
+		break;
+	case ACPI_HEST_TYPE_AER_BRIDGE:
+		if ((info->pci_dev->class >> 16) == PCI_BASE_CLASS_BRIDGE)
+			bridge = 1;
+		break;
+	default:
+		return 0;
+	}
+
+	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
+	if (p->flags & ACPI_HEST_GLOBAL) {
+		if ((info->pci_dev->is_pcie &&
+		     info->pci_dev->pcie_type == pcie_type) || bridge)
+			ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
+	} else
+		if (hest_match_pci(p, info->pci_dev))
+			ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
+	info->firmware_first = ff;
+
+	return 0;
+}
+
+void aer_set_firmware_first(struct pcie_device *dev)
+{
+	int rc;
+	struct pci_dev *pci_dev = dev->port;
+	struct aer_hest_parse_info info = {
+		.pci_dev	= pci_dev,
+		.firmware_first	= 0,
+	};
+
+	rc = apei_hest_parse(aer_hest_parse, &info);
+
+	if (rc)
+		pci_dev->aer_firmware_first = 0;
+	else
+		pci_dev->aer_firmware_first = info.firmware_first;
+}
+#endif
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index c843a79..cc527c1 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -858,6 +858,8 @@ void aer_delete_rootport(struct aer_rpc *rpc)
  */
 int aer_init(struct pcie_device *dev)
 {
+	aer_set_firmware_first(dev);
+
 	if (dev->port->aer_firmware_first) {
 		dev_printk(KERN_DEBUG, &dev->device,
 			   "PCIe errors handled by platform firmware.\n");
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2a94309..ccfaf19 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/cpumask.h>
 #include <linux/pci-aspm.h>
-#include <acpi/acpi_hest.h>
 #include "pci.h"
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
@@ -900,12 +899,6 @@ void set_pcie_hotplug_bridge(struct pci_dev *pdev)
 		pdev->is_hotplug_bridge = 1;
 }
 
-static void set_pci_aer_firmware_first(struct pci_dev *pdev)
-{
-	if (acpi_hest_firmware_first_pci(pdev))
-		pdev->aer_firmware_first = 1;
-}
-
 #define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
 
 /**
@@ -935,7 +928,6 @@ int pci_setup_device(struct pci_dev *dev)
 	dev->multifunction = !!(hdr_type & 0x80);
 	dev->error_state = pci_channel_io_normal;
 	set_pcie_port_type(dev);
-	set_pci_aer_firmware_first(dev);
 
 	list_for_each_entry(slot, &dev->bus->slots, list)
 		if (PCI_SLOT(dev->devfn) == slot->number)
diff --git a/include/acpi/acpi_hest.h b/include/acpi/acpi_hest.h
deleted file mode 100644
index 63194d0..0000000
--- a/include/acpi/acpi_hest.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __ACPI_HEST_H
-#define __ACPI_HEST_H
-
-#include <linux/pci.h>
-
-#ifdef CONFIG_ACPI
-extern int acpi_hest_firmware_first_pci(struct pci_dev *pci);
-#else
-static inline int acpi_hest_firmware_first_pci(struct pci_dev *pci) { return 0; }
-#endif
-
-#endif
-- 
1.6.6.1

