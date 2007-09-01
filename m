Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbXIAOcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbXIAOcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 10:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXIAOcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 10:32:24 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51757 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXIAOcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 10:32:23 -0400
Date: Sat, 1 Sep 2007 10:32:23 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86/x86-64 PCI domain support
Message-ID: <20070901143223.GA32216@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the dust has settled and the prep work is upstream, adding PCI
domain support to x86 is a lot more straightforward.

Targetted for 2.6.24.



commit c7b14cf6aa39e09aef89a0cd08c553dba1ee7e98
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Sep 1 07:36:25 2007 -0400

    PCI domain support for x86[-64]
    
    aka "PCI segment" support, in ACPI lingo.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 arch/i386/pci/acpi.c     |   15 ++++++++++-----
 arch/i386/pci/common.c   |    6 ++++--
 arch/x86_64/Kconfig      |    4 ++++
 include/asm-i386/pci.h   |   14 ++++++++++++++
 include/asm-x86_64/pci.h |   14 ++++++++++++++
 5 files changed, 46 insertions(+), 7 deletions(-)

c7b14cf6aa39e09aef89a0cd08c553dba1ee7e98
diff --git a/arch/i386/pci/acpi.c b/arch/i386/pci/acpi.c
index bc8a44b..6beb789 100644
--- a/arch/i386/pci/acpi.c
+++ b/arch/i386/pci/acpi.c
@@ -11,6 +11,13 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 	struct pci_sysdata *sd;
 	int pxm;
 
+#ifndef CONFIG_PCI_DOMAINS
+	if (domain != 0) {
+		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
+		return NULL;
+	}
+#endif
+
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
 	 * It's arguable whether it's worth the trouble to care.
@@ -21,11 +28,9 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 		return NULL;
 	}
 
-	if (domain != 0) {
-		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
-		kfree(sd);
-		return NULL;
-	}
+#ifdef CONFIG_PCI_DOMAINS
+	sd->domain = domain;
+#endif
 
 	sd->node = -1;
 
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
index ffa0364..1cb16c6 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -732,6 +732,10 @@ config PCI_MMCONFIG
 	bool "Support mmconfig PCI config space access"
 	depends on PCI && ACPI
 
+config PCI_DOMAINS
+	bool "PCI domain support"
+	depends on PCI
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/include/asm-i386/pci.h b/include/asm-i386/pci.h
index 4fcacc7..37d3322 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -5,12 +5,26 @@
 #ifdef __KERNEL__
 
 struct pci_sysdata {
+	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 };
 
 /* scan a bus after allocating a pci_sysdata for it */
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
+#ifdef CONFIG_PCI_DOMAINS
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
+#endif /* CONFIG_PCI_DOMAINS */
+
 #include <linux/mm.h>		/* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff --git a/include/asm-x86_64/pci.h b/include/asm-x86_64/pci.h
index 5da8cb0..6ce2731 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -6,12 +6,26 @@
 #ifdef __KERNEL__
 
 struct pci_sysdata {
+	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 	void*		iommu;		/* IOMMU private data */
 };
 
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
+#ifdef CONFIG_PCI_DOMAINS
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
+#endif /* CONFIG_PCI_DOMAINS */
+
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
 {
