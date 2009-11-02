Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZKBRvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZKBRvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZKBRvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:51:22 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:59719 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbZKBRvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:51:20 -0500
X-Loopcount0: from 10.9.160.253
Date: Mon, 2 Nov 2009 11:51:24 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Huong_Nguyen@dell.com
Subject: Re: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
Message-ID: <20091102175123.GA4028@mock.linuxdev.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@dell.com>
References: <20091006173311.GA15751@auslistsprd01.us.dell.com> <4ACEE220.1020705@jp.fujitsu.com> <20091009182810.GB24889@mock.linuxdev.us.dell.com> <20091009183319.GC24889@mock.linuxdev.us.dell.com> <4AEA4C82.6010604@jp.fujitsu.com> <20091030025313.GA1042@mock.linuxdev.us.dell.com> <4AEA5C52.2030900@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEA5C52.2030900@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 97ec121f91e5c76dc037f8d2abaea84c5476676e Mon Sep 17 00:00:00 2001
From: Matt Domsch <Matt_Domsch@dell.com>
Date: Thu, 8 Oct 2009 23:18:11 -0500
Subject: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode

Feedback from Hidetoshi Seto and Kenji Kaneshige incorporated.  This
correctly handles PCI-X bridges, PCIe root ports and endpoints, and
prints debug messages when invalid/reserved types are found in the
HEST.  PCI devices not in domain/segment 0 are not represented in
HEST, thus will be ignored.

Today, the PCIe Advanced Error Reporting (AER) driver attaches itself
to every PCIe root port for which BIOS reports it should, via ACPI
_OSC.

However, _OSC alone is insufficient for newer BIOSes.  Part of ACPI
4.0 is the new APEI (ACPI Platform Error Interfaces) which is a way
for OS and BIOS to handshake over which errors for which components
each will handle.  One table in ACPI 4.0 is the Hardware Error Source
Table (HEST), where BIOS can define that errors for certain PCIe
devices (or all devices), should be handled by BIOS ("Firmware First
mode"), rather than be handled by the OS.

Dell PowerEdge 11G server BIOS defines Firmware First mode in HEST, so
that it may manage such errors, log them to the System Event Log, and
possibly take other actions.  The aer driver should honor this, and
not attach itself to devices noted as such.

Furthermore, Kenji Kaneshige reminded us to disallow changing the AER
registers when respecting Firmware First mode.  Platform firmware is
expected to manage these, and if changes to them are allowed, it could
break that firmware's behavior.

The HEST parsing code may be replaced in the future by a more
feature-rich implementation.  This patch provides the minimum needed
to prevent breakage until that implementation is available.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
---
 drivers/acpi/Makefile              |    1 +
 drivers/acpi/hest.c                |  135 ++++++++++++++++++++++++++++++++++++
 drivers/pci/pcie/aer/aerdrv_core.c |   24 ++++++-
 drivers/pci/probe.c                |    8 ++
 include/acpi/acpi_hest.h           |   12 +++
 include/linux/pci.h                |    1 +
 6 files changed, 179 insertions(+), 2 deletions(-)
 create mode 100644 drivers/acpi/hest.c
 create mode 100644 include/acpi/acpi_hest.h

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 7702118..c7b10b4 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -19,6 +19,7 @@ obj-y				+= acpi.o \
 
 # All the builtin files are in the "acpi." module_param namespace.
 acpi-y				+= osl.o utils.o reboot.o
+acpi-y				+= hest.o
 
 # sleep related files
 acpi-y				+= wakeup.o
diff --git a/drivers/acpi/hest.c b/drivers/acpi/hest.c
new file mode 100644
index 0000000..4bb18c9
--- /dev/null
+++ b/drivers/acpi/hest.c
@@ -0,0 +1,135 @@
+#include <linux/acpi.h>
+#include <linux/pci.h>
+
+#define PREFIX "ACPI: "
+
+static inline unsigned long parse_acpi_hest_ia_machine_check(struct acpi_hest_ia_machine_check *p)
+{
+	return sizeof(*p) +
+		(sizeof(struct acpi_hest_ia_error_bank) * p->num_hardware_banks);
+}
+
+static inline unsigned long parse_acpi_hest_ia_corrected(struct acpi_hest_ia_corrected *p)
+{
+	return sizeof(*p) +
+		(sizeof(struct acpi_hest_ia_error_bank) * p->num_hardware_banks);
+}
+
+static inline unsigned long parse_acpi_hest_ia_nmi(struct acpi_hest_ia_nmi *p)
+{
+	return sizeof(*p);
+}
+
+static inline unsigned long parse_acpi_hest_generic(struct acpi_hest_generic *p)
+{
+	return sizeof(*p);
+}
+
+static inline unsigned int hest_match_pci(struct acpi_hest_aer_common *p, struct pci_dev *pci)
+{
+	return	(0           == pci_domain_nr(pci->bus) &&
+		 p->bus      == pci->bus->number &&
+		 p->device   == PCI_SLOT(pci->devfn) &&
+		 p->function == PCI_FUNC(pci->devfn));
+}
+
+static unsigned long parse_acpi_hest_aer(void *hdr, int type, struct pci_dev *pci, int *firmware_first)
+{
+	struct acpi_hest_aer_common *p = hdr + sizeof(struct acpi_hest_header);
+	unsigned long rc=0;
+	u8 pcie_type = 0;
+	u8 bridge = 0;
+	switch (type) {
+	case ACPI_HEST_TYPE_AER_ROOT_PORT:
+		rc = sizeof(struct acpi_hest_aer_root);
+		pcie_type = PCI_EXP_TYPE_ROOT_PORT;
+		break;
+	case ACPI_HEST_TYPE_AER_ENDPOINT:
+		rc = sizeof(struct acpi_hest_aer);
+		pcie_type = PCI_EXP_TYPE_ENDPOINT;
+		break;
+	case ACPI_HEST_TYPE_AER_BRIDGE:
+		rc = sizeof(struct acpi_hest_aer_bridge);
+		if ((pci->class >> 16) == PCI_BASE_CLASS_BRIDGE)
+			bridge = 1;
+		break;
+	}
+
+	if (p->flags & ACPI_HEST_GLOBAL) {
+		if ((pci->is_pcie && (pci->pcie_type == pcie_type)) || bridge)
+			*firmware_first = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
+	}
+	else
+		if (hest_match_pci(p, pci))
+			*firmware_first = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
+	return rc;
+}
+
+static int acpi_hest_firmware_first(struct acpi_table_header *stdheader, struct pci_dev *pci)
+{
+	struct acpi_table_hest *hest = (struct acpi_table_hest *)stdheader;
+	void *p = (void *)hest + sizeof(*hest); /* defined by the ACPI 4.0 spec */
+	struct acpi_hest_header *hdr = p;
+
+	int i;
+	int firmware_first = 0;
+	static unsigned char printed_unused = 0;
+	static unsigned char printed_reserved = 0;
+
+	for (i=0, hdr=p; p < (((void *)hest) + hest->header.length) && i < hest->error_source_count; i++) {
+		switch (hdr->type) {
+		case ACPI_HEST_TYPE_IA32_CHECK:
+			p += parse_acpi_hest_ia_machine_check(p);
+			break;
+		case ACPI_HEST_TYPE_IA32_CORRECTED_CHECK:
+			p += parse_acpi_hest_ia_corrected(p);
+			break;
+		case ACPI_HEST_TYPE_IA32_NMI:
+			p += parse_acpi_hest_ia_nmi(p);
+			break;
+		/* These three should never appear */
+		case ACPI_HEST_TYPE_NOT_USED3:
+		case ACPI_HEST_TYPE_NOT_USED4:
+		case ACPI_HEST_TYPE_NOT_USED5:
+			if (!printed_unused) {
+				printk(KERN_DEBUG PREFIX
+				       "HEST Error Source list contains an obsolete type (%d).\n", hdr->type);
+				printed_unused = 1;
+			}
+			break;
+		case ACPI_HEST_TYPE_AER_ROOT_PORT:
+		case ACPI_HEST_TYPE_AER_ENDPOINT:
+		case ACPI_HEST_TYPE_AER_BRIDGE:
+			p += parse_acpi_hest_aer(p, hdr->type, pci, &firmware_first);
+			break;
+		case ACPI_HEST_TYPE_GENERIC_ERROR:
+			p += parse_acpi_hest_generic(p);
+			break;
+		/* These should never appear either */
+		case ACPI_HEST_TYPE_RESERVED:
+		default:
+			if (!printed_reserved) {
+				printk(KERN_DEBUG PREFIX
+				       "HEST Error Source list contains a reserved type (%d).\n", hdr->type);
+				printed_reserved = 1;
+			}
+			break;
+		}
+	}
+	return firmware_first;
+}
+
+int acpi_hest_firmware_first_pci(struct pci_dev *pci)
+{
+	acpi_status status = AE_NOT_FOUND;
+	struct acpi_table_header *hest = NULL;
+	status = acpi_get_table(ACPI_SIG_HEST, 1, &hest);
+
+	if (ACPI_SUCCESS(status)) {
+		if (acpi_hest_firmware_first(hest, pci)) {
+			return 1;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_hest_firmware_first_pci);
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 9f5ccbe..f4512fe 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -35,6 +35,9 @@ int pci_enable_pcie_error_reporting(struct pci_dev *dev)
 	u16 reg16 = 0;
 	int pos;
 
+	if (dev->aer_firmware_first)
+		return -EIO;
+
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 	if (!pos)
 		return -EIO;
@@ -60,6 +63,9 @@ int pci_disable_pcie_error_reporting(struct pci_dev *dev)
 	u16 reg16 = 0;
 	int pos;
 
+	if (dev->aer_firmware_first)
+		return -EIO;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos)
 		return -EIO;
@@ -874,8 +880,22 @@ void aer_delete_rootport(struct aer_rpc *rpc)
  */
 int aer_init(struct pcie_device *dev)
 {
-	if (aer_osc_setup(dev) && !forceload)
-		return -ENXIO;
+	if (dev->port->aer_firmware_first) {
+		dev_printk(KERN_DEBUG, &dev->device,
+			   "PCIe errors handled by platform firmware.\n");
+		goto out;
+	}
+
+	if (aer_osc_setup(dev))
+		goto out;
 
 	return 0;
+out:
+	if (forceload) {
+		dev_printk(KERN_DEBUG, &dev->device,
+			   "aerdrv forceload requested.\n");
+		dev->port->aer_firmware_first = 0;
+		return 0;
+	}
+	return -ENXIO;
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..102995d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/cpumask.h>
 #include <linux/pci-aspm.h>
+#include <acpi/acpi_hest.h>
 #include "pci.h"
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
@@ -714,6 +715,12 @@ static void set_pcie_hotplug_bridge(struct pci_dev *pdev)
 		pdev->is_hotplug_bridge = 1;
 }
 
+static void set_pci_aer_firmware_first(struct pci_dev *pdev)
+{
+	if (acpi_hest_firmware_first_pci(pdev))
+		pdev->aer_firmware_first = 1;
+}
+
 #define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
 
 /**
@@ -742,6 +749,7 @@ int pci_setup_device(struct pci_dev *dev)
 	dev->multifunction = !!(hdr_type & 0x80);
 	dev->error_state = pci_channel_io_normal;
 	set_pcie_port_type(dev);
+	set_pci_aer_firmware_first(dev);
 
 	list_for_each_entry(slot, &dev->bus->slots, list)
 		if (PCI_SLOT(dev->devfn) == slot->number)
diff --git a/include/acpi/acpi_hest.h b/include/acpi/acpi_hest.h
new file mode 100644
index 0000000..63194d0
--- /dev/null
+++ b/include/acpi/acpi_hest.h
@@ -0,0 +1,12 @@
+#ifndef __ACPI_HEST_H
+#define __ACPI_HEST_H
+
+#include <linux/pci.h>
+
+#ifdef CONFIG_ACPI
+extern int acpi_hest_firmware_first_pci(struct pci_dev *pci);
+#else
+static inline int acpi_hest_firmware_first_pci(struct pci_dev *pci) { return 0; }
+#endif
+
+#endif
diff --git a/include/linux/pci.h b/include/linux/pci.h
index da4128f..9d646e6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -280,6 +280,7 @@ struct pci_dev {
 	unsigned int	is_virtfn:1;
 	unsigned int	reset_fn:1;
 	unsigned int    is_hotplug_bridge:1;
+	unsigned int    aer_firmware_first:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
-- 
1.6.2.5

