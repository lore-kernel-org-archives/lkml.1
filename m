Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbYFZThv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbYFZThv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760527AbYFZT3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:15 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31939 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbYFZT3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:04 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K334RT-04-UOG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/34] AMD IOMMU: add functions for IOMMU hardware initialization from ACPI
Date: Thu, 26 Jun 2008 21:27:47 +0200
Message-ID: <1214508490-29683-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0643 (UTC) FILETIME=[C57474B0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functions to initialize the IOMMU hardware with information
from ACPI and PCI.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |  125 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 4c37abb..8ec48f1 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -353,3 +353,128 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 	}
 }
 
+static void __init init_iommu_from_pci(struct amd_iommu *iommu)
+{
+	int bus = PCI_BUS(iommu->devid);
+	int dev = PCI_SLOT(iommu->devid);
+	int fn  = PCI_FUNC(iommu->devid);
+	int cap_ptr = iommu->cap_ptr;
+	u32 range;
+
+	iommu->cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_CAP_HDR_OFFSET);
+
+	range = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
+	iommu->first_device = DEVID(MMIO_GET_BUS(range), MMIO_GET_FD(range));
+	iommu->last_device = DEVID(MMIO_GET_BUS(range), MMIO_GET_LD(range));
+}
+
+static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
+					struct ivhd_header *h)
+{
+	u8 *p = (u8 *)h;
+	u8 *end = p, flags = 0;
+	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
+	u32 ext_flags = 0;
+	bool alias = 0;
+	struct ivhd_entry *e;
+
+	/*
+	 * First set the recommended feature enable bits from ACPI
+	 * into the IOMMU control registers
+	 */
+	h->flags & IVHD_FLAG_HT_TUN_EN ?
+		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
+		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
+
+	h->flags & IVHD_FLAG_PASSPW_EN ?
+		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
+
+	h->flags & IVHD_FLAG_RESPASSPW_EN ?
+		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
+
+	h->flags & IVHD_FLAG_ISOC_EN ?
+		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
+		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
+
+	/*
+	 * make IOMMU memory accesses cache coherent
+	 */
+	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+
+	/*
+	 * Done. Now parse the device entries
+	 */
+	p += sizeof(struct ivhd_header);
+	end += h->length;
+
+	while (p < end) {
+		e = (struct ivhd_entry *)p;
+		switch (e->type) {
+		case IVHD_DEV_ALL:
+			for (dev_i = iommu->first_device;
+					dev_i <= iommu->last_device; ++dev_i)
+				set_dev_entry_from_acpi(dev_i, e->flags, 0);
+			break;
+		case IVHD_DEV_SELECT:
+			devid = e->devid;
+			set_dev_entry_from_acpi(devid, e->flags, 0);
+			break;
+		case IVHD_DEV_SELECT_RANGE_START:
+			devid_start = e->devid;
+			flags = e->flags;
+			ext_flags = 0;
+			alias = 0;
+			break;
+		case IVHD_DEV_ALIAS:
+			devid = e->devid;
+			devid_to = e->ext >> 8;
+			set_dev_entry_from_acpi(devid, e->flags, 0);
+			amd_iommu_alias_table[devid] = devid_to;
+			break;
+		case IVHD_DEV_ALIAS_RANGE:
+			devid_start = e->devid;
+			flags = e->flags;
+			devid_to = e->ext >> 8;
+			ext_flags = 0;
+			alias = 1;
+			break;
+		case IVHD_DEV_EXT_SELECT:
+			devid = e->devid;
+			set_dev_entry_from_acpi(devid, e->flags, e->ext);
+			break;
+		case IVHD_DEV_EXT_SELECT_RANGE:
+			devid_start = e->devid;
+			flags = e->flags;
+			ext_flags = e->ext;
+			alias = 0;
+			break;
+		case IVHD_DEV_RANGE_END:
+			devid = e->devid;
+			for (dev_i = devid_start; dev_i <= devid; ++dev_i) {
+				if (alias)
+					amd_iommu_alias_table[dev_i] = devid_to;
+				set_dev_entry_from_acpi(
+						amd_iommu_alias_table[dev_i],
+						flags, ext_flags);
+			}
+			break;
+		default:
+			break;
+		}
+
+		p += 0x04 << (e->type >> 6);
+	}
+}
+
+static int __init init_iommu_devices(struct amd_iommu *iommu)
+{
+	u16 i;
+
+	for (i = iommu->first_device; i <= iommu->last_device; ++i)
+		set_iommu_for_device(iommu, i);
+
+	return 0;
+}
+
-- 
1.5.3.7


