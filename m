Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYIQQy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYIQQy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYIQQxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:16 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52855 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbYIQQxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:13 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K7CMW8-03-U8Y-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/23] AMD IOMMU: save pci_dev instead of devid
Date: Wed, 17 Sep 2008 18:52:42 +0200
Message-ID: <1221670377-19295-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0026 (UTC) FILETIME=[D66488A0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need the pci_dev later anyways to enable MSI for the IOMMU hardware.
So remove the devid pointing to the BDF and replace it with the pci_dev
structure where the IOMMU is implemented.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c  |   25 ++++++++++++++++---------
 include/asm-x86/amd_iommu_types.h |    5 +++--
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index aa26e37..da619fc 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -243,9 +243,12 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 /* Function to enable the hardware */
 void __init iommu_enable(struct amd_iommu *iommu)
 {
-	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at ");
-	print_devid(iommu->devid, 0);
-	printk(" cap 0x%hx\n", iommu->cap_ptr);
+	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU "
+	       "at %02x:%02x.%x cap 0x%hx\n",
+	       iommu->dev->bus->number,
+	       PCI_SLOT(iommu->dev->devfn),
+	       PCI_FUNC(iommu->dev->devfn),
+	       iommu->cap_ptr);
 
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
@@ -512,15 +515,14 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
  */
 static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 {
-	int bus = PCI_BUS(iommu->devid);
-	int dev = PCI_SLOT(iommu->devid);
-	int fn  = PCI_FUNC(iommu->devid);
 	int cap_ptr = iommu->cap_ptr;
 	u32 range;
 
-	iommu->cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_CAP_HDR_OFFSET);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
+			      &iommu->cap);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_RANGE_OFFSET,
+			      &range);
 
-	range = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
 	iommu->first_device = calc_devid(MMIO_GET_BUS(range),
 					 MMIO_GET_FD(range));
 	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
@@ -675,7 +677,10 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	/*
 	 * Copy data from ACPI table entry to the iommu struct
 	 */
-	iommu->devid = h->devid;
+	iommu->dev = pci_get_bus_and_slot(PCI_BUS(h->devid), h->devid & 0xff);
+	if (!iommu->dev)
+		return 1;
+
 	iommu->cap_ptr = h->cap_ptr;
 	iommu->pci_seg = h->pci_seg;
 	iommu->mmio_phys = h->mmio_phys;
@@ -696,6 +701,8 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
 
+	pci_enable_device(iommu->dev);
+
 	return 0;
 }
 
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index eb4d47a..58c80f0 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -215,8 +215,9 @@ struct amd_iommu {
 	/* locks the accesses to the hardware */
 	spinlock_t lock;
 
-	/* device id of this IOMMU */
-	u16 devid;
+	/* Pointer to PCI device of this IOMMU */
+	struct pci_dev *dev;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
-- 
1.5.6.4


