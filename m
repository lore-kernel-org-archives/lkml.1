Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbZJFRdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbZJFRdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932644AbZJFRdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:33:51 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:15433 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbZJFRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:33:49 -0400
X-Loopcount0: from 143.166.82.43
Date: Tue, 6 Oct 2009 12:33:11 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
Message-ID: <20091006173311.GA15751@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For review and comment.

Today, the PCIe Advanced Error Reporting (AER) driver attaches itself
to every PCIe root port for which BIOS reports it should, via ACPI
_OSC.

However, _OSC alone is insufficient for newer BIOSes.  Part of ACPI
4.0 is the new Platform Environment Control Interface (PECI), which is
a way for OS and BIOS to handshake over which errors for which
components each will handle.  One table in ACPI 4.0 is the Hardware
Error Source Table (HEST), where BIOS can define that errors for
certain PCIe devices (or all devices), should be handled by BIOS
("Firmware First mode"), rather than be handled by the OS.

Dell PowerEdge 11G server BIOS defines Firmware First mode in HEST, so
that it may manage such errors, log them to the System Event Log, and
possibly take other actions.  The aer driver should honor this, and
not attach itself to devices noted as such.


Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux


---
 drivers/pci/pcie/aer/aerdrv.h      |    4 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c |  106 +++++++++++++++++++++++++++++++++++-
 drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
 include/acpi/actbl1.h              |    8 ++-
 4 files changed, 112 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
index bbd7428..2e00a22 100644
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -128,9 +128,9 @@ extern void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
 extern irqreturn_t aer_irq(int irq, void *context);
 
 #ifdef CONFIG_ACPI
-extern int aer_osc_setup(struct pcie_device *pciedev);
+extern int aer_osc_setup(struct pcie_device *pciedev, int forceload);
 #else
-static inline int aer_osc_setup(struct pcie_device *pciedev)
+static inline int aer_osc_setup(struct pcie_device *pciedev, int forceload)
 {
 	return 0;
 }
diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 8edb2f3..10bd83c 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -18,20 +18,112 @@
 #include <linux/delay.h>
 #include "aerdrv.h"
 
+static unsigned long parse_aer_hest_xpf_machine_check(struct acpi_hest_xpf_machine_check *p)
+{
+	return sizeof(*p) +
+		(sizeof(struct acpi_hest_xpf_error_bank) * p->num_hardware_banks);
+}
+
+static unsigned long parse_aer_hest_xpf_corrected_machine_check(struct acpi_table_hest_xpf_corrected *p)
+{
+	return sizeof(*p) +
+		(sizeof(struct acpi_hest_xpf_error_bank) * p->num_hardware_banks);
+}
+
+static unsigned long parse_aer_hest_xpf_nmi(struct acpi_hest_xpf_nmi *p)
+{
+	return sizeof(*p);
+}
+
+static unsigned long parse_hest_generic(struct acpi_hest_generic *p)
+{
+	return sizeof(*p);
+}
+
+static unsigned long parse_hest_aer(void *hdr, int type, struct pcie_device *pciedev, int *firmware_first)
+{
+	struct acpi_hest_aer_common *p = hdr + sizeof(struct acpi_hest_header);
+	unsigned long rc=0;
+	switch (type) {
+	case ACPI_HEST_TYPE_AER_ROOT_PORT:
+		rc = sizeof(struct acpi_hest_aer_root);
+		break;
+	case ACPI_HEST_TYPE_AER_ENDPOINT:
+		rc = sizeof(struct acpi_hest_aer);
+		break;
+	case ACPI_HEST_TYPE_AER_BRIDGE:
+		rc = sizeof(struct acpi_hest_aer_bridge);
+		break;
+	}
+
+	if (p->flags & ACPI_HEST_AER_FIRMWARE_FIRST &&
+	    (p->flags & ACPI_HEST_AER_GLOBAL ||
+	     (p->bus      == pciedev->port->bus->number &&
+	      p->device   == PCI_SLOT(pciedev->port->devfn) &&
+	      p->function == PCI_FUNC(pciedev->port->devfn))))
+		*firmware_first = 1;
+	return rc;
+}
+
+static int aer_hest_firmware_first(struct acpi_table_header *stdheader, struct pcie_device *pciedev)
+{
+	struct acpi_table_hest *hest = (struct acpi_table_hest *)stdheader;
+	void *p = (void *)hest + sizeof(*hest); /* defined by the ACPI 4.0 spec */
+	struct acpi_hest_header *hdr = p;
+
+	int i;
+	int firmware_first = 0;
+
+	for (i=0, hdr=p; p < (((void *)hest) + hest->header.length) && i < hest->error_source_count; i++) {
+		switch (hdr->type) {
+		case ACPI_HEST_TYPE_XPF_MACHINE_CHECK:
+			p += parse_aer_hest_xpf_machine_check(p);
+			break;
+		case ACPI_HEST_TYPE_XPF_CORRECTED_MACHINE_CHECK:
+			p += parse_aer_hest_xpf_corrected_machine_check(p);
+			break;
+		case ACPI_HEST_TYPE_XPF_NON_MASKABLE_INTERRUPT:
+			p += parse_aer_hest_xpf_nmi(p);
+			break;
+		/* These three should never appear */
+		case ACPI_HEST_TYPE_XPF_UNUSED:
+		case ACPI_HEST_TYPE_IPF_CORRECTED_MACHINE_CHECK:
+		case ACPI_HEST_TYPE_IPF_CORRECTED_PLATFORM_ERROR:
+			break;
+		case ACPI_HEST_TYPE_AER_ROOT_PORT:
+		case ACPI_HEST_TYPE_AER_ENDPOINT:
+		case ACPI_HEST_TYPE_AER_BRIDGE:
+			p += parse_hest_aer(p, hdr->type, pciedev, &firmware_first);
+			break;
+		case ACPI_HEST_TYPE_GENERIC_HARDWARE_ERROR_SOURCE:
+			p += parse_hest_generic(p);
+			break;
+		/* These should never appear either */
+		case ACPI_HEST_TYPE_RESERVED:
+		default:
+			break;
+		}
+	}
+	return firmware_first;
+}
+
 /**
  * aer_osc_setup - run ACPI _OSC method
  * @pciedev: pcie_device which AER is being enabled on
  *
  * @return: Zero on success. Nonzero otherwise.
  *
- * Invoked when PCIE bus loads AER service driver. To avoid conflict with
- * BIOS AER support requires BIOS to yield AER control to OS native driver.
+ * Invoked when PCIE bus loads AER service driver. To avoid conflict
+ * with BIOS AER support requires BIOS to yield AER control to OS
+ * native driver.  If HEST is found, and BIOS requires FIRMWARE FIRST
+ * mode, expect the BIOS to continue managing AER.
  **/
-int aer_osc_setup(struct pcie_device *pciedev)
+int aer_osc_setup(struct pcie_device *pciedev, int forceload)
 {
 	acpi_status status = AE_NOT_FOUND;
 	struct pci_dev *pdev = pciedev->port;
 	acpi_handle handle = NULL;
+	struct acpi_table_header *hest = NULL;
 
 	if (acpi_pci_disabled)
 		return -1;
@@ -51,5 +143,13 @@ int aer_osc_setup(struct pcie_device *pciedev)
 		return -1;
 	}
 
+	status = acpi_get_table(ACPI_SIG_HEST, 1, &hest);
+	if (ACPI_SUCCESS(status)) {
+		if (aer_hest_firmware_first(hest, pciedev) && !forceload) {
+			dev_printk(KERN_DEBUG, &pciedev->device,
+				   "PCIe device errors handled by platform firmware\n");
+			return -1;
+		}
+	}
 	return 0;
 }
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 3d88727..cbd959b 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -860,7 +860,7 @@ void aer_delete_rootport(struct aer_rpc *rpc)
  */
 int aer_init(struct pcie_device *dev)
 {
-	if (aer_osc_setup(dev) && !forceload)
+	if (aer_osc_setup(dev, forceload) && !forceload)
 		return -ENXIO;
 
 	return AER_SUCCESS;
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 59ade07..5919d4c 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -558,8 +558,8 @@ struct acpi_hest_header {
 enum acpi_hest_types {
 	ACPI_HEST_TYPE_XPF_MACHINE_CHECK = 0,
 	ACPI_HEST_TYPE_XPF_CORRECTED_MACHINE_CHECK = 1,
-	ACPI_HEST_TYPE_XPF_UNUSED = 2,
-	ACPI_HEST_TYPE_XPF_NON_MASKABLE_INTERRUPT = 3,
+	ACPI_HEST_TYPE_XPF_NON_MASKABLE_INTERRUPT = 2,
+	ACPI_HEST_TYPE_XPF_UNUSED = 3,
 	ACPI_HEST_TYPE_IPF_CORRECTED_MACHINE_CHECK = 4,
 	ACPI_HEST_TYPE_IPF_CORRECTED_PLATFORM_ERROR = 5,
 	ACPI_HEST_TYPE_AER_ROOT_PORT = 6,
@@ -630,6 +630,10 @@ struct acpi_hest_aer_common {
 	u32 advanced_error_capabilities;
 };
 
+/* Flags */
+#define ACPI_HEST_AER_FIRMWARE_FIRST (1)
+#define ACPI_HEST_AER_GLOBAL         (1<<1)
+
 /* Hardware Error Notification */
 
 struct acpi_hest_notify {
-- 
1.6.2.5

