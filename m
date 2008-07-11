Return-Path: <linux-kernel-owner+w=401wt.eu-S1761799AbYGKPTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761799AbYGKPTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYGKPQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:16:05 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:44396 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYGKPQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:16:03 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UL24-03-1QC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/16] AMD IOMMU: replace DEVID macro with a function
Date: Fri, 11 Jul 2008 17:14:35 +0200
Message-ID: <1215789275-20975-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0383 (UTC) FILETIME=[D4A646F0:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the DEVID macro with a function and uses them where
apropriate (also in the core code).

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c       |    2 +-
 arch/x86/kernel/amd_iommu_init.c  |    9 +++++----
 include/asm-x86/amd_iommu_types.h |    7 +++++++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index dec10e1..8c3deb0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -664,7 +664,7 @@ static int get_device_resources(struct device *dev,
 	BUG_ON(!dev || dev->bus != &pci_bus_type || !dev->dma_mask);
 
 	pcidev = to_pci_dev(dev);
-	_bdf = (pcidev->bus->number << 8) | pcidev->devfn;
+	_bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
 
 	/* device not translated by any IOMMU in the system? */
 	if (_bdf >= amd_iommu_last_bdf) {
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index e0ff940..9bf1b81 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -30,7 +30,6 @@
 /*
  * definitions for the ACPI scanning code
  */
-#define DEVID(bus, devfn) (((bus) << 8) | (devfn))
 #define PCI_BUS(x) (((x) >> 8) & 0xff)
 #define IVRS_HEADER_LENGTH 48
 
@@ -295,7 +294,7 @@ static int __init find_last_devid_on_pci(int bus, int dev, int fn, int cap_ptr)
 	u32 cap;
 
 	cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
-	update_last_devid(DEVID(MMIO_GET_BUS(cap), MMIO_GET_LD(cap)));
+	update_last_devid(calc_devid(MMIO_GET_BUS(cap), MMIO_GET_LD(cap)));
 
 	return 0;
 }
@@ -494,8 +493,10 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 	iommu->cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_CAP_HDR_OFFSET);
 
 	range = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
-	iommu->first_device = DEVID(MMIO_GET_BUS(range), MMIO_GET_FD(range));
-	iommu->last_device = DEVID(MMIO_GET_BUS(range), MMIO_GET_LD(range));
+	iommu->first_device = calc_devid(MMIO_GET_BUS(range),
+					 MMIO_GET_FD(range));
+	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
+					MMIO_GET_LD(range));
 }
 
 /*
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 2e8601b..22aa58c 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -332,4 +332,11 @@ static inline void print_devid(u16 devid, int nl)
 		printk("\n");
 }
 
+/* takes bus and device/function and returns the device id
+ * FIXME: should that be in generic PCI code? */
+static inline u16 calc_devid(u8 bus, u8 devfn)
+{
+	return (((u16)bus) << 8) | devfn;
+}
+
 #endif
-- 
1.5.3.7


