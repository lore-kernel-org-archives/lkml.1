Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXJKU6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXJKU6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 16:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbXJKU6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 16:58:32 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59009 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbXJKU6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 16:58:31 -0400
Date: Thu, 11 Oct 2007 16:58:30 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Greg KH <greg@kroah.com>, Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/2] X86: Introduce and enable PCI domain support
Message-ID: <20071011205830.GB29376@havoc.gtf.org>
References: <20071011205727.GA29222@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011205727.GA29222@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* fix bug in pci_read() and pci_write() which prevented PCI domain
  support from working (hardcoded domain 0).

* unconditionally enable CONFIG_PCI_DOMAINS

* implement pci_domain_nr() and pci_proc_domain(), as required of
  all arches when CONFIG_PCI_DOMAINS is enabled.

* store domain in struct pci_sysdata, as assigned by ACPI

* support "pci=nodomains"

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Revised per Andi's comments, and split into two patches.

As found in jgarzik/misc-2.6.git#ALL and jgarzik/misc-2.6.git#pciseg.

 arch/i386/Kconfig        |    5 +++++
 arch/i386/pci/acpi.c     |   13 +++++++------
 arch/i386/pci/common.c   |    6 ++++--
 arch/x86_64/Kconfig      |    5 +++++
 include/asm-i386/pci.h   |   12 ++++++++++++
 include/asm-x86_64/pci.h |   12 ++++++++++++
 6 files changed, 45 insertions(+), 8 deletions(-)

d2978874ffb1a980238ab68aa528b700a1ec2b30
diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 97b64d7..5237791 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -1137,6 +1137,11 @@ config PCI_MMCONFIG
 	depends on PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
 	default y
 
+config PCI_DOMAINS
+	bool
+	depends on PCI
+	default y
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/arch/i386/pci/acpi.c b/arch/i386/pci/acpi.c
index bc8a44b..5c9827b 100644
--- a/arch/i386/pci/acpi.c
+++ b/arch/i386/pci/acpi.c
@@ -11,6 +11,12 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 	struct pci_sysdata *sd;
 	int pxm;
 
+	if (domain && !pci_domains_supported) {
+		printk(KERN_WARNING "PCI: Multiple domains not supported "
+		       "(dom %d, bus %d)\n", domain, busnum);
+		return NULL;
+	}
+
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
 	 * It's arguable whether it's worth the trouble to care.
@@ -21,12 +27,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 		return NULL;
 	}
 
-	if (domain != 0) {
-		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
-		kfree(sd);
-		return NULL;
-	}
-
+	sd->domain = domain;
 	sd->node = -1;
 
 	pxm = acpi_get_pxm(device->handle);
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index ebc6f3c..6d7a274 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -29,12 +29,14 @@ struct pci_raw_ops *raw_pci_ops;
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
-	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
+	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+				 devfn, where, size, value);
 }
 
 static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
 {
-	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
+	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+				  devfn, where, size, value);
 }
 
 struct pci_ops pci_root_ops = {
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index b4d9089..f3ea9e0 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -724,6 +724,11 @@ config PCI_MMCONFIG
 	bool "Support mmconfig PCI config space access"
 	depends on PCI && ACPI
 
+config PCI_DOMAINS
+	bool
+	depends on PCI
+	default y
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/include/asm-i386/pci.h b/include/asm-i386/pci.h
index 4fcacc7..0d91605 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -5,12 +5,24 @@
 #ifdef __KERNEL__
 
 struct pci_sysdata {
+	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 };
 
 /* scan a bus after allocating a pci_sysdata for it */
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->domain;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+
 #include <linux/mm.h>		/* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff --git a/include/asm-x86_64/pci.h b/include/asm-x86_64/pci.h
index 5da8cb0..0a123d6 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -6,12 +6,24 @@
 #ifdef __KERNEL__
 
 struct pci_sysdata {
+	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 	void*		iommu;		/* IOMMU private data */
 };
 
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->domain;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
 {
