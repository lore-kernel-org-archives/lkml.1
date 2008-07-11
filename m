Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbYGKPSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbYGKPSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbYGKPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:15 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:39556 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbYGKPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:08 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K3UL0F-03-1OU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/16] AMD IOMMU: replace memset with __GFP_ZERO for table allocation
Date: Fri, 11 Jul 2008 17:14:32 +0200
Message-ID: <1215789275-20975-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0289 (UTC) FILETIME=[D497EF10:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the memset from the data structure initialization code and
allocate the structures with the __GFP_ZERO flag.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0c24703..2efc3d5 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -890,7 +890,7 @@ int __init amd_iommu_init(void)
 	ret = -ENOMEM;
 
 	/* Device table - directly used by all IOMMUs */
-	amd_iommu_dev_table = (void *)__get_free_pages(GFP_KERNEL,
+	amd_iommu_dev_table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 				      get_order(dev_table_size));
 	if (amd_iommu_dev_table == NULL)
 		goto out;
@@ -914,27 +914,23 @@ int __init amd_iommu_init(void)
 	 * Protection Domain table - maps devices to protection domains
 	 * This table has the same size as the rlookup_table
 	 */
-	amd_iommu_pd_table = (void *)__get_free_pages(GFP_KERNEL,
+	amd_iommu_pd_table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 				     get_order(rlookup_table_size));
 	if (amd_iommu_pd_table == NULL)
 		goto free;
 
-	amd_iommu_pd_alloc_bitmap = (void *)__get_free_pages(GFP_KERNEL,
+	amd_iommu_pd_alloc_bitmap = (void *)__get_free_pages(
+					    GFP_KERNEL | __GFP_ZERO,
 					    get_order(MAX_DOMAIN_ID/8));
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto free;
 
 	/*
-	 * memory is allocated now; initialize the device table with all zeroes
-	 * and let all alias entries point to itself
+	 * let all alias entries point to itself
 	 */
-	memset(amd_iommu_dev_table, 0, dev_table_size);
 	for (i = 0; i < amd_iommu_last_bdf; ++i)
 		amd_iommu_alias_table[i] = i;
 
-	memset(amd_iommu_pd_table, 0, rlookup_table_size);
-	memset(amd_iommu_pd_alloc_bitmap, 0, MAX_DOMAIN_ID / 8);
-
 	/*
 	 * never allocate domain 0 because its used as the non-allocated and
 	 * error value placeholder
-- 
1.5.3.7


