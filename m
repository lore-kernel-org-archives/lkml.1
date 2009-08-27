Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZH0Vhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZH0Vhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZH0Vho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:37:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:53068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZH0Vhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:37:43 -0400
Date: Thu, 27 Aug 2009 21:37:17 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dwmw2@infradead.org, venkatesh.pallipadi@intel.com,
       jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
       fenlason@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, venkatesh.pallipadi@intel.com,
       jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
       fenlason@redhat.com, tglx@linutronix.de
In-Reply-To: <20090804190729.477649000@intel.com>
References: <20090804190729.477649000@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/hpet] intr-remap: generic support for remapping HPET MSIs
Message-ID: <tip-20f3097bfe5fb5ced0b14f9ea2620c4039bf1dde@git.kernel.org>
Git-Commit-ID: 20f3097bfe5fb5ced0b14f9ea2620c4039bf1dde
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 27 Aug 2009 21:37:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20f3097bfe5fb5ced0b14f9ea2620c4039bf1dde
Gitweb:     http://git.kernel.org/tip/20f3097bfe5fb5ced0b14f9ea2620c4039bf1dde
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 4 Aug 2009 12:07:08 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Aug 2009 23:33:20 +0200

intr-remap: generic support for remapping HPET MSIs

Generic support for remapping HPET MSI's by parsing the HPET timer block
device scope in the ACPI DRHD tables. This is needed for platforms
supporting interrupt-remapping and MSI capable HPET timer block.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Jay Fenlason <fenlason@redhat.com>
LKML-Reference: <20090804190729.477649000@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 drivers/pci/intr_remapping.c |   89 ++++++++++++++++++++++++++++++++++++++++--
 drivers/pci/intr_remapping.h |    7 +++
 include/linux/dmar.h         |   10 +++++
 include/linux/hpet.h         |    2 +
 4 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 4f5b871..2cc3f70 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -2,6 +2,7 @@
 #include <linux/dmar.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
+#include <linux/hpet.h>
 #include <linux/pci.h>
 #include <linux/irq.h>
 #include <asm/io_apic.h>
@@ -14,7 +15,8 @@
 #include "pci.h"
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
-static int ir_ioapic_num;
+static struct hpet_scope ir_hpet[MAX_HPET_TBS];
+static int ir_ioapic_num, ir_hpet_num;
 int intr_remapping_enabled;
 
 static int disable_intremap;
@@ -351,6 +353,16 @@ int flush_irte(int irq)
 	return rc;
 }
 
+struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
+{
+	int i;
+
+	for (i = 0; i < MAX_HPET_TBS; i++)
+		if (ir_hpet[i].id == hpet_id)
+			return ir_hpet[i].iommu;
+	return NULL;
+}
+
 struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	int i;
@@ -478,6 +490,36 @@ int set_ioapic_sid(struct irte *irte, int apic)
 	return 0;
 }
 
+int set_hpet_sid(struct irte *irte, u8 id)
+{
+	int i;
+	u16 sid = 0;
+
+	if (!irte)
+		return -1;
+
+	for (i = 0; i < MAX_HPET_TBS; i++) {
+		if (ir_hpet[i].id == id) {
+			sid = (ir_hpet[i].bus << 8) | ir_hpet[i].devfn;
+			break;
+		}
+	}
+
+	if (sid == 0) {
+		pr_warning("Failed to set source-id of HPET block (%d)\n", id);
+		return -1;
+	}
+
+	/*
+	 * Should really use SQ_ALL_16. Some platforms are broken.
+	 * While we figure out the right quirks for these broken platforms, use
+	 * SQ_13_IGNORE_3 for now.
+	 */
+	set_irte_sid(irte, SVT_VERIFY_SID_SQ, SQ_13_IGNORE_3, sid);
+
+	return 0;
+}
+
 int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 {
 	struct pci_dev *bridge;
@@ -711,6 +753,34 @@ error:
 	return -1;
 }
 
+static void ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
+				      struct intel_iommu *iommu)
+{
+	struct acpi_dmar_pci_path *path;
+	u8 bus;
+	int count;
+
+	bus = scope->bus;
+	path = (struct acpi_dmar_pci_path *)(scope + 1);
+	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
+		/ sizeof(struct acpi_dmar_pci_path);
+
+	while (--count > 0) {
+		/*
+		 * Access PCI directly due to the PCI
+		 * subsystem isn't initialized yet.
+		 */
+		bus = read_pci_config_byte(bus, path->dev, path->fn,
+					   PCI_SECONDARY_BUS);
+		path++;
+	}
+	ir_hpet[ir_hpet_num].bus   = bus;
+	ir_hpet[ir_hpet_num].devfn = PCI_DEVFN(path->dev, path->fn);
+	ir_hpet[ir_hpet_num].iommu = iommu;
+	ir_hpet[ir_hpet_num].id    = scope->enumeration_id;
+	ir_hpet_num++;
+}
+
 static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 				      struct intel_iommu *iommu)
 {
@@ -740,8 +810,8 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 	ir_ioapic_num++;
 }
 
-static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
-				 struct intel_iommu *iommu)
+static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
+				      struct intel_iommu *iommu)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_device_scope *scope;
@@ -765,6 +835,17 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 			       drhd->address);
 
 			ir_parse_one_ioapic_scope(scope, iommu);
+		} else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET) {
+			if (ir_hpet_num == MAX_HPET_TBS) {
+				printk(KERN_WARNING "Exceeded Max HPET blocks\n");
+				return -1;
+			}
+
+			printk(KERN_INFO "HPET id %d under DRHD base"
+			       " 0x%Lx\n", scope->enumeration_id,
+			       drhd->address);
+
+			ir_parse_one_hpet_scope(scope, iommu);
 		}
 		start += scope->length;
 	}
@@ -785,7 +866,7 @@ int __init parse_ioapics_under_ir(void)
 		struct intel_iommu *iommu = drhd->iommu;
 
 		if (ecap_ir_support(iommu->ecap)) {
-			if (ir_parse_ioapic_scope(drhd->hdr, iommu))
+			if (ir_parse_ioapic_hpet_scope(drhd->hdr, iommu))
 				return -1;
 
 			ir_supported = 1;
diff --git a/drivers/pci/intr_remapping.h b/drivers/pci/intr_remapping.h
index 63a263c..5662fec 100644
--- a/drivers/pci/intr_remapping.h
+++ b/drivers/pci/intr_remapping.h
@@ -7,4 +7,11 @@ struct ioapic_scope {
 	unsigned int devfn;	/* PCI devfn number */
 };
 
+struct hpet_scope {
+	struct intel_iommu *iommu;
+	u8 id;
+	unsigned int bus;
+	unsigned int devfn;
+};
+
 #define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 4a2b162..69a6fba 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -126,7 +126,9 @@ extern int free_irte(int irq);
 extern int irq_remapped(int irq);
 extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
+extern struct intel_iommu *map_hpet_to_ir(u8 id);
 extern int set_ioapic_sid(struct irte *irte, int apic);
+extern int set_hpet_sid(struct irte *irte, u8 id);
 extern int set_msi_sid(struct irte *irte, struct pci_dev *dev);
 #else
 static inline int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
@@ -158,10 +160,18 @@ static inline struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	return NULL;
 }
+static inline struct intel_iommu *map_hpet_to_ir(unsigned int hpet_id)
+{
+	return NULL;
+}
 static inline int set_ioapic_sid(struct irte *irte, int apic)
 {
 	return 0;
 }
+static inline int set_hpet_sid(struct irte *irte, u8 id)
+{
+	return -1;
+}
 static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 {
 	return 0;
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 79f63a2..219ca4f 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -126,4 +126,6 @@ struct hpet_info {
 #define	HPET_DPI	_IO('h', 0x05)	/* disable periodic */
 #define	HPET_IRQFREQ	_IOW('h', 0x6, unsigned long)	/* IRQFREQ usec */
 
+#define MAX_HPET_TBS	8		/* maximum hpet timer blocks */
+
 #endif				/* !__HPET__ */
