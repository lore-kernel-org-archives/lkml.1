Return-Path: <linux-kernel-owner+w=401wt.eu-S1762315AbYFZTdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315AbYFZTdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbYFZT2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:45 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2802 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760508AbYFZT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:41 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K334QX-04-UN1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/34] AMD IOMMU: add functions for mapping/unmapping the MMIO space
Date: Thu, 26 Jun 2008 21:27:43 +0200
Message-ID: <1214508490-29683-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0533 (UTC) FILETIME=[C563ABD0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains two functions to map and unmap the MMIO region of an IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index ee0b2da..3147e69 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -117,6 +117,29 @@ static u32 dev_table_size;
 static u32 alias_table_size;
 static u32 rlookup_table_size;
 
+static u8 * __init iommu_map_mmio_space(u64 address)
+{
+	u8 *ret;
+
+	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu"))
+		return NULL;
+
+	ret = ioremap_nocache(address, MMIO_REGION_LENGTH);
+	if (ret != NULL)
+		return ret;
+
+	release_mem_region(address, MMIO_REGION_LENGTH);
+
+	return NULL;
+}
+
+static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
+{
+	if (iommu->mmio_base)
+		iounmap(iommu->mmio_base);
+	release_mem_region(iommu->mmio_phys, MMIO_REGION_LENGTH);
+}
+
 static int __init find_last_devid_on_pci(int bus, int dev, int fn, int cap_ptr)
 {
 	u32 cap;
-- 
1.5.3.7


