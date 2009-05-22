Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZEVMOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZEVMOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZEVMNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:18 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:33202
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757124AbZEVMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:15 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KK1OLL-03-92S-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/7] amd-iommu: print ivhd information to dmesg when requested
Date: Fri, 22 May 2009 14:12:45 +0200
Message-ID: <1242994369-28697-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
References: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:12:49.0918 (UTC) FILETIME=[A00309E0:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: be able to show in dmesg whats in the acpi ivhd fields ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   73 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 2816590..fe3e645 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -598,32 +598,83 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	p += sizeof(struct ivhd_header);
 	end += h->length;
 
+
 	while (p < end) {
 		e = (struct ivhd_entry *)p;
 		switch (e->type) {
 		case IVHD_DEV_ALL:
+
+			DUMP_printk("  DEV_ALL\t\t\t first devid: %02x:%02x.%x"
+				    " last device %02x:%02x.%x flags: %02x\n",
+				    PCI_BUS(iommu->first_device),
+				    PCI_SLOT(iommu->first_device),
+				    PCI_FUNC(iommu->first_device),
+				    PCI_BUS(iommu->last_device),
+				    PCI_SLOT(iommu->last_device),
+				    PCI_FUNC(iommu->last_device),
+				    e->flags);
+
 			for (dev_i = iommu->first_device;
 					dev_i <= iommu->last_device; ++dev_i)
 				set_dev_entry_from_acpi(iommu, dev_i,
 							e->flags, 0);
 			break;
 		case IVHD_DEV_SELECT:
+
+			DUMP_printk("  DEV_SELECT\t\t\t devid: %02x:%02x.%x "
+				    "flags: %02x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags);
+
 			devid = e->devid;
 			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
 			break;
 		case IVHD_DEV_SELECT_RANGE_START:
+
+			DUMP_printk("  DEV_SELECT_RANGE_START\t "
+				    "devid: %02x:%02x.%x flags: %02x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags);
+
 			devid_start = e->devid;
 			flags = e->flags;
 			ext_flags = 0;
 			alias = false;
 			break;
 		case IVHD_DEV_ALIAS:
+
+			DUMP_printk("  DEV_ALIAS\t\t\t devid: %02x:%02x.%x "
+				    "flags: %02x devid_to: %02x:%02x.%x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags,
+				    PCI_BUS(e->ext >> 8),
+				    PCI_SLOT(e->ext >> 8),
+				    PCI_FUNC(e->ext >> 8));
+
 			devid = e->devid;
 			devid_to = e->ext >> 8;
 			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
 			amd_iommu_alias_table[devid] = devid_to;
 			break;
 		case IVHD_DEV_ALIAS_RANGE:
+
+			DUMP_printk("  DEV_ALIAS_RANGE\t\t "
+				    "devid: %02x:%02x.%x flags: %02x "
+				    "devid_to: %02x:%02x.%x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags,
+				    PCI_BUS(e->ext >> 8),
+				    PCI_SLOT(e->ext >> 8),
+				    PCI_FUNC(e->ext >> 8));
+
 			devid_start = e->devid;
 			flags = e->flags;
 			devid_to = e->ext >> 8;
@@ -631,17 +682,39 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			alias = true;
 			break;
 		case IVHD_DEV_EXT_SELECT:
+
+			DUMP_printk("  DEV_EXT_SELECT\t\t devid: %02x:%02x.%x "
+				    "flags: %02x ext: %08x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags, e->ext);
+
 			devid = e->devid;
 			set_dev_entry_from_acpi(iommu, devid, e->flags,
 						e->ext);
 			break;
 		case IVHD_DEV_EXT_SELECT_RANGE:
+
+			DUMP_printk("  DEV_EXT_SELECT_RANGE\t devid: "
+				    "%02x:%02x.%x flags: %02x ext: %08x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags, e->ext);
+
 			devid_start = e->devid;
 			flags = e->flags;
 			ext_flags = e->ext;
 			alias = false;
 			break;
 		case IVHD_DEV_RANGE_END:
+
+			DUMP_printk("  DEV_RANGE_END\t\t devid: %02x:%02x.%x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid));
+
 			devid = e->devid;
 			for (dev_i = devid_start; dev_i <= devid; ++dev_i) {
 				if (alias)
-- 
1.6.3.1


