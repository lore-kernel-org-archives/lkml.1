Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYLOOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYLOOXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYLOOTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:11 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:25693 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbYLOOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:07 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBX938-03-00F-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/22] AMD IOMMU: add statistics about allocated io memory
Date: Mon, 15 Dec 2008 15:18:04 +0100
Message-ID: <1229350685-3816-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0526 (UTC) FILETIME=[F2FDE5E0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see amount of allocated io memory in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index be6d107..9c34902 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -73,6 +73,7 @@ DECLARE_STATS_COUNTER(cnt_free_coherent);
 DECLARE_STATS_COUNTER(cross_page);
 DECLARE_STATS_COUNTER(domain_flush_single);
 DECLARE_STATS_COUNTER(domain_flush_all);
+DECLARE_STATS_COUNTER(alloced_io_mem);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -109,6 +110,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&cross_page);
 	amd_iommu_stats_add(&domain_flush_single);
 	amd_iommu_stats_add(&domain_flush_all);
+	amd_iommu_stats_add(&alloced_io_mem);
 }
 
 #endif
@@ -1245,6 +1247,8 @@ static dma_addr_t __map_single(struct device *dev,
 	}
 	address += offset;
 
+	ADD_STATS_COUNTER(alloced_io_mem, size);
+
 	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
 		iommu_flush_tlb(iommu, dma_dom->domain.id);
 		dma_dom->need_flush = false;
@@ -1281,6 +1285,8 @@ static void __unmap_single(struct amd_iommu *iommu,
 		start += PAGE_SIZE;
 	}
 
+	SUB_STATS_COUNTER(alloced_io_mem, size);
+
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-- 
1.5.6.4


