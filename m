Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbYFZT2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbYFZT2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759141AbYFZT20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:26 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:23750 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbYFZT2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:25 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K334QX-04-UN8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/34] AMD IOMMU: add detect code for AMD IOMMU hardware
Date: Thu, 26 Jun 2008 21:27:48 +0200
Message-ID: <1214508490-29683-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0690 (UTC) FILETIME=[C57BA0A0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the detection of AMD IOMMU hardware provided on information
from ACPI provided by the BIOS.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   78 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8ec48f1..3f4f7b8 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -478,3 +478,81 @@ static int __init init_iommu_devices(struct amd_iommu *iommu)
 	return 0;
 }
 
+static void __init free_iommu_one(struct amd_iommu *iommu)
+{
+	free_command_buffer(iommu);
+	iommu_unmap_mmio_space(iommu);
+}
+
+static void __init free_iommu_all(void)
+{
+	struct amd_iommu *iommu, *next;
+
+	list_for_each_entry_safe(iommu, next, &amd_iommu_list, list) {
+		list_del(&iommu->list);
+		free_iommu_one(iommu);
+		kfree(iommu);
+	}
+}
+
+static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
+{
+	spin_lock_init(&iommu->lock);
+	list_add_tail(&iommu->list, &amd_iommu_list);
+
+	/*
+	 * Copy data from ACPI table entry to the iommu struct
+	 */
+	iommu->devid = h->devid;
+	iommu->cap_ptr = h->cap_ptr;
+	iommu->mmio_phys = h->mmio_phys;
+	iommu->mmio_base = iommu_map_mmio_space(h->mmio_phys);
+	if (!iommu->mmio_base)
+		return -ENOMEM;
+
+	iommu_set_device_table(iommu);
+	iommu->cmd_buf = alloc_command_buffer(iommu);
+	if (!iommu->cmd_buf)
+		return -ENOMEM;
+
+	init_iommu_from_pci(iommu);
+	init_iommu_from_acpi(iommu, h);
+	init_iommu_devices(iommu);
+
+	return 0;
+}
+
+static int __init init_iommu_all(struct acpi_table_header *table)
+{
+	u8 *p = (u8 *)table, *end = (u8 *)table;
+	struct ivhd_header *h;
+	struct amd_iommu *iommu;
+	int ret;
+
+	INIT_LIST_HEAD(&amd_iommu_list);
+
+	end += table->length;
+	p += IVRS_HEADER_LENGTH;
+
+	while (p < end) {
+		h = (struct ivhd_header *)p;
+		switch (*p) {
+		case ACPI_IVHD_TYPE:
+			iommu = kzalloc(sizeof(struct amd_iommu), GFP_KERNEL);
+			if (iommu == NULL)
+				return -ENOMEM;
+			ret = init_iommu_one(iommu, h);
+			if (ret)
+				return ret;
+			break;
+		default:
+			break;
+		}
+		p += h->length;
+
+	}
+	WARN_ON(p != end);
+
+	return 0;
+}
+
-- 
1.5.3.7


