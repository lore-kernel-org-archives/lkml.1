Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYKJWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYKJWcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYKJWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:31:07 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:47341 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYKJWbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:31:03 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 3/7] ACPI,
	PCI: PCI extended config _OSC support called when root bridge added
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: andrew.patterson@hp.com, matthew@wil.cx, kaneshige.kenji@jp.fujitsu.com,
       bjorn.helgaas@hp.com
Date: Mon, 10 Nov 2008 15:30:50 -0700
Message-ID: <20081110223050.30539.52713.stgit@bob.kio>
In-Reply-To: <20081110223035.30539.88942.stgit@bob.kio>
References: <20081110223035.30539.88942.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI, PCI: PCI extended config _OSC support called when root bridge added

The _OSC capability OSC_EXT_PCI_CONFIG_SUPPORT is set when the root bridge
is added with pci_acpi_osc_support() if we can access PCI extended
config space.

Added the function pci_ext_cfg_avail which returns true if we can
access PCI extended config space (offset greater than 0xff). It
currently only returns false if arch=x86 and raw_pci_ext_ops is not set
(which might happen if pci=nommcfg is set on the kernel command-line).

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index b67732b..bf017bb 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -546,6 +546,14 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
+int pci_ext_cfg_avail(struct pci_dev *dev)
+{
+	if (raw_pci_ext_ops)
+		return 1;
+	else
+		return 0;
+}
+
 struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 {
 	struct pci_bus *bus = NULL;
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 7ca153e..191a510 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -194,7 +194,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	unsigned long long value = 0;
 	acpi_handle handle = NULL;
 	struct acpi_device *child;
-	u32 flags;
+	u32 flags, base_flags;
 
 
 	if (!device)
@@ -216,7 +216,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	 * All supported architectures that use ACPI have support for
 	 * PCI domains, so we indicate this in _OSC support capabilities.
 	 */
-	flags = OSC_PCI_SEGMENT_GROUPS_SUPPORT;
+	flags = base_flags = OSC_PCI_SEGMENT_GROUPS_SUPPORT;
 	pci_acpi_osc_support(device->handle, flags);
 
 	/* 
@@ -344,6 +344,12 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	list_for_each_entry(child, &device->children, node)
 		acpi_pci_bridge_scan(child);
 
+	/* Indicate support for various _OSC capabilities. */
+	if (pci_ext_cfg_avail(root->bus->self))
+		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
+	if (flags != base_flags)
+		pci_acpi_osc_support(device->handle, flags);
+
       end:
 	if (result) {
 		if (!list_empty(&root->node))
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 21f2ac6..70a8c74 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2029,6 +2029,19 @@ static void __devinit pci_no_domains(void)
 #endif
 }
 
+/**
+ * pci_ext_cfg_enabled - can we access extended PCI config space?
+ * @dev: The PCI device of the root bridge.
+ *
+ * Returns 1 if we can access PCI extended config space (offsets
+ * greater than 0xff). This is the default implementation. Architecture
+ * implementations can override this.
+ */
+int __attribute__ ((weak)) pci_ext_cfg_avail(struct pci_dev *dev)
+{
+	return 1;
+}
+
 static int __devinit pci_init(void)
 {
 	struct pci_dev *dev = NULL;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c75b82b..c5d40ba 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1135,6 +1135,8 @@ static inline void pci_mmcfg_early_init(void) { }
 static inline void pci_mmcfg_late_init(void) { }
 #endif
 
+int pci_ext_cfg_avail(struct pci_dev *dev);
+
 #ifdef CONFIG_HAS_IOMEM
 static inline void * pci_ioremap_bar(struct pci_dev *pdev, int bar)
 {

