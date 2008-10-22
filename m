Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYJVJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYJVJkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYJVJi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:38:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:51483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbYJVJiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:38:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,463,1220252400"; 
   d="scan'208";a="454255510"
Date: Wed, 22 Oct 2008 16:43:24 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 9/16 v6] PCI: add boot option to align MMIO resources
Message-ID: <20081022084324.GI3773@yzhao12-linux.sh.intel.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds boot option to align MMIO resource for a device.
The alignment is a bigger value between the PAGE_SIZE and the
resource size.

The boot option can be used as:
	pci=align-mmio=0000:01:02.3
'[0000:]01:02.3' is the domain, bus, device and function number
of the device.

Cc: Alex Chiang <achiang@hp.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 arch/x86/pci/common.c |   37 +++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.c     |   20 ++++++++++++++++++--
 include/linux/pci.h   |    1 +
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 06e1ce0..3c5d230 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -139,6 +139,7 @@ static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
 
 static char *pci_assign_pio;
 static char *pci_assign_mmio;
+static char *pci_align_mmio;
 
 static int pcibios_bus_resource_needs_fixup(struct pci_bus *bus)
 {
@@ -192,6 +193,36 @@ static void __devinit pcibios_fixup_bus_resources(struct pci_bus *bus)
 	}
 }
 
+int pcibios_resource_alignment(struct pci_dev *dev, int resno)
+{
+	int domain, busnr, slot, func;
+	char *str = pci_align_mmio;
+
+	if (dev->resource[resno].flags & IORESOURCE_IO)
+		return 0;
+
+	while (str && *str) {
+		if (sscanf(str, "%04x:%02x:%02x.%d",
+				&domain, &busnr, &slot, &func) != 4) {
+			if (sscanf(str, "%02x:%02x.%d",
+					&busnr, &slot, &func) != 3)
+				break;
+			domain = 0;
+		}
+
+		if (pci_domain_nr(dev->bus) == domain &&
+		    dev->bus->number == busnr &&
+		    dev->devfn == PCI_DEVFN(slot, func))
+			return PAGE_SIZE;
+
+		str = strchr(str, ';');
+		if (str)
+			str++;
+	}
+
+	return 0;
+}
+
 int pcibios_resource_needs_fixup(struct pci_dev *dev, int resno)
 {
 	struct pci_bus *bus;
@@ -200,6 +231,9 @@ int pcibios_resource_needs_fixup(struct pci_dev *dev, int resno)
 		if (pcibios_bus_resource_needs_fixup(bus))
 			return 1;
 
+	if (pcibios_resource_alignment(dev, resno))
+			return 1;
+
 	return 0;
 }
 
@@ -592,6 +626,9 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strncmp(str, "assign-mmio=", 12)) {
 		pci_assign_mmio = str + 12;
 		return NULL;
+	} else if (!strncmp(str, "align-mmio=", 11)) {
+		pci_align_mmio = str + 11;
+		return NULL;
 	}
 	return str;
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b02167a..11ecd6f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1015,6 +1015,20 @@ int __attribute__ ((weak)) pcibios_set_pcie_reset_state(struct pci_dev *dev,
 }
 
 /**
+ * pcibios_resource_alignment - get resource alignment requirement
+ * @dev: the PCI device
+ * @resno: resource number
+ *
+ * Queries the resource alignment from PCI low level code. Returns positive
+ * if there is alignment requirement of the resource, or 0 otherwise.
+ */
+int __attribute__ ((weak)) pcibios_resource_alignment(struct pci_dev *dev,
+						      int resno)
+{
+	return 0;
+}
+
+/**
  * pci_set_pcie_reset_state - set reset state for device dev
  * @dev: the PCI-E device reset
  * @state: Reset state to enter into
@@ -1913,12 +1927,14 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
  */
 int pci_resource_alignment(struct pci_dev *dev, int resno)
 {
-	resource_size_t align;
+	resource_size_t align, bios_align;
 	struct resource *res = dev->resource + resno;
 
+	bios_align = pcibios_resource_alignment(dev, resno);
+
 	align = resource_alignment(res);
 	if (align)
-		return align;
+		return align > bios_align ? align : bios_align;
 
 	dev_err(&dev->dev, "alignment: invalid resource #%d\n", resno);
 	return 0;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2ada2b6..6ac69af 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1121,6 +1121,7 @@ int pcibios_add_platform_entries(struct pci_dev *dev);
 void pcibios_disable_device(struct pci_dev *dev);
 int pcibios_set_pcie_reset_state(struct pci_dev *dev,
 				 enum pcie_reset_state state);
+int pcibios_resource_alignment(struct pci_dev *dev, int resno);
 
 #ifdef CONFIG_PCI_MMCONFIG
 extern void __init pci_mmcfg_early_init(void);
-- 
1.5.6.4

