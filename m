Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbYFZTh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbYFZTh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbYFZT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:13 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:13765 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761306AbYFZT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:05 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K334RU-03-2Z6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/34] AMD IOMMU: add functions for programming IOMMU MMIO space
Date: Thu, 26 Jun 2008 21:27:44 +0200
Message-ID: <1214508490-29683-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0565 (UTC) FILETIME=[C5688DD0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions required to programm the IOMMU with the MMIO
space.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   60 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3147e69..ffb8ac8 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -117,6 +117,66 @@ static u32 dev_table_size;
 static u32 alias_table_size;
 static u32 rlookup_table_size;
 
+static void __init iommu_set_exclusion_range(struct amd_iommu *iommu)
+{
+	u64 start = iommu->exclusion_start & PAGE_MASK;
+	u64 limit = (start + iommu->exclusion_length) & PAGE_MASK;
+	u64 entry;
+
+	if (!iommu->exclusion_start)
+		return;
+
+	entry = start | MMIO_EXCL_ENABLE_MASK;
+	memcpy_toio(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET,
+			&entry, sizeof(entry));
+
+	entry = limit;
+	memcpy_toio(iommu->mmio_base + MMIO_EXCL_LIMIT_OFFSET,
+			&entry, sizeof(entry));
+}
+
+static void __init iommu_set_device_table(struct amd_iommu *iommu)
+{
+	u32 entry;
+
+	BUG_ON(iommu->mmio_base == NULL);
+
+	entry = virt_to_phys(amd_iommu_dev_table);
+	entry |= (dev_table_size >> 12) - 1;
+	memcpy_toio(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET,
+			&entry, sizeof(entry));
+}
+
+static void __init iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
+{
+	u32 ctrl;
+
+	ctrl = readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
+	ctrl |= (1 << bit);
+	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
+}
+
+static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
+{
+	u32 ctrl;
+
+	ctrl = (u64)readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
+	ctrl &= ~(1 << bit);
+	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
+}
+
+void __init iommu_enable(struct amd_iommu *iommu)
+{
+	u32 ctrl;
+
+	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at ");
+	print_devid(iommu->devid, 0);
+	printk(" cap 0x%hx\n", iommu->cap_ptr);
+
+	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
+	ctrl = readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
+}
+
 static u8 * __init iommu_map_mmio_space(u64 address)
 {
 	u8 *ret;
-- 
1.5.3.7


