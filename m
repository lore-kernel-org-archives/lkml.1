Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbYFZTlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbYFZTlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761060AbYFZT32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:28 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14611 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760581AbYFZT3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:21 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K334RU-04-UOO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/34] AMD IOMMU: add address allocation and deallocation functions
Date: Thu, 26 Jun 2008 21:27:57 +0200
Message-ID: <1214508490-29683-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0949 (UTC) FILETIME=[C5A325D0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the address allocator to the AMD IOMMU code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 1d70f5e..69d8d02 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -266,3 +266,51 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
 	return 0;
 }
 
+static unsigned long dma_mask_to_pages(unsigned long mask)
+{
+	return (mask >> PAGE_SHIFT) +
+		(PAGE_ALIGN(mask & ~PAGE_MASK) >> PAGE_SHIFT);
+}
+
+static unsigned long dma_ops_alloc_addresses(struct device *dev,
+					     struct dma_ops_domain *dom,
+					     unsigned int pages)
+{
+	unsigned long limit = dma_mask_to_pages(*dev->dma_mask);
+	unsigned long address;
+	unsigned long size = dom->aperture_size >> PAGE_SHIFT;
+	unsigned long boundary_size;
+
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+			PAGE_SIZE) >> PAGE_SHIFT;
+	limit = limit < size ? limit : size;
+
+	if (dom->next_bit >= limit)
+		dom->next_bit = 0;
+
+	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
+			0 , boundary_size, 0);
+	if (address == -1)
+		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
+				0, boundary_size, 0);
+
+	if (likely(address != -1)) {
+		set_bit_string(dom->bitmap, address, pages);
+		dom->next_bit = address + pages;
+		address <<= PAGE_SHIFT;
+	} else
+		address = bad_dma_address;
+
+	WARN_ON((address + (PAGE_SIZE*pages)) > dom->aperture_size);
+
+	return address;
+}
+
+static void dma_ops_free_addresses(struct dma_ops_domain *dom,
+				   unsigned long address,
+				   unsigned int pages)
+{
+	address >>= PAGE_SHIFT;
+	iommu_area_free(dom->bitmap, address, pages);
+}
+
-- 
1.5.3.7


