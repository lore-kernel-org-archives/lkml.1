Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZLDUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZLDUPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbZLDUPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:15:48 -0500
Received: from sous-sol.org ([216.99.217.87]:47942 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757147AbZLDUPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:15:47 -0500
Date: Fri, 4 Dec 2009 12:15:21 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: jbarnes@virtuousgeek.org
Cc: Allen Kay <allen.m.kay@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, matthew@wil.cx, chrisw@sous-sol.org,
       jeremy@goop.org, donald.d.dugger@intel.com, joerg.roedel@amd.com,
       dwmw2@infradead.org, iommu@lists.linux-foundation.org
Subject: [PATCH] pci: add pci_request_acs
Message-ID: <20091204201521.GJ21174@sequoia.sous-sol.org>
References: <1254936437-18577-1-git-send-email-allen.m.kay@intel.com> <20091204191754.GI21174@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204191754.GI21174@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ae21ee65e8bc228416bbcc8a1da01c56a847a60c "PCI: acs p2p upsteram
forwarding enabling" doesn't actually enable ACS.

Add a function to pci core to allow an IOMMU to request that ACS
be enabled.  The existing mechanism of using iommu_found() in the pci
core to know when ACS should be enabled doesn't actually work due to
initialization order;  iommu has only been detected not initialized.

Have Intel and AMD IOMMUs request ACS, and Xen does as well during early
init of dom0.

Cc: Allen Kay <allen.m.kay@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Applies against the linux-next branch of Jesse's pci tree.

 arch/x86/kernel/amd_iommu_init.c |    2 ++
 arch/x86/xen/enlighten.c         |    5 +++++
 drivers/pci/dmar.c               |    5 ++++-
 drivers/pci/pci.c                |   13 +++++++++++++
 drivers/pci/probe.c              |    5 +----
 include/linux/pci.h              |    2 ++
 6 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index b4b61d4..e60530a 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1330,6 +1330,8 @@ void __init amd_iommu_detect(void)
 		gart_iommu_aperture_disabled = 1;
 		gart_iommu_aperture = 0;
 #endif
+		/* Make sure ACS will be enabled */
+		pci_request_acs();
 	}
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 5bccd70..e2511bc 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -27,6 +27,7 @@
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
 #include <linux/console.h>
+#include <linux/pci.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -1170,7 +1171,11 @@ asmlinkage void __init xen_start_kernel(void)
 		add_preferred_console("xenboot", 0, NULL);
 		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
+	} else {
+		/* Make sure ACS will be enabled */
+		pci_request_acs();
 	}
+		
 
 	xen_raw_console_write("about to get started...\n");
 
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index e01ca4d..0e98f6b 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -614,8 +614,11 @@ void __init detect_intel_iommu(void)
 #endif
 #ifdef CONFIG_DMAR
 		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
-		    !dmar_disabled)
+		    !dmar_disabled) {
 			iommu_detected = 1;
+			/* Make sure ACS will be enabled */
+			pci_request_acs();
+		}
 #endif
 	}
 	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 453d6ba..fc8fa3f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1550,6 +1550,16 @@ void pci_enable_ari(struct pci_dev *dev)
 	bridge->ari_enabled = 1;
 }
 
+static int pci_acs_enable;
+
+/**
+ * pci_request_acs - ask for ACS to be enabled if supported
+ */
+void pci_request_acs(void)
+{
+	pci_acs_enable = 1;
+}
+
 /**
  * pci_enable_acs - enable ACS if hardware support it
  * @dev: the PCI device
@@ -1560,6 +1570,9 @@ void pci_enable_acs(struct pci_dev *dev)
 	u16 cap;
 	u16 ctrl;
 
+	if (!pci_acs_enable)
+		return;
+
 	if (!pci_is_pcie(dev))
 		return;
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2fdffc0..98ffb2d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -10,9 +10,7 @@
 #include <linux/module.h>
 #include <linux/cpumask.h>
 #include <linux/pci-aspm.h>
-#include <linux/iommu.h>
 #include <acpi/acpi_hest.h>
-#include <xen/xen.h>
 #include "pci.h"
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
@@ -1029,8 +1027,7 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	pci_iov_init(dev);
 
 	/* Enable ACS P2P upstream forwarding */
-	if (iommu_found() || xen_initial_domain())
-		pci_enable_acs(dev);
+	pci_enable_acs(dev);
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2891c3d..04771b9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1328,5 +1328,7 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 	return !!pci_pcie_cap(dev);
 }
 
+void pci_request_acs(void);
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
