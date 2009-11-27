Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZK0Nz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZK0Nz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZK0Nz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:55:56 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:14501
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751577AbZK0Nzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:54 -0500
X-SpamScore: 8
X-BigFish: VPS8(zzzz1202hzz92fbmz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD2-02-34M-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/34] x86/amd-iommu: Make np-cache a global flag
Date: Fri, 27 Nov 2009 14:55:23 +0100
Message-ID: <1259330145-14865-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0107 (UTC) FILETIME=[52929DB0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The non-present cache flag was IOMMU local until now which
doesn't make sense. Make this a global flag so we can remove
the lase user of 'struct iommu' in the map/unmap path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 +++
 arch/x86/kernel/amd_iommu.c            |    8 +-------
 arch/x86/kernel/amd_iommu_init.c       |    6 ++++++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index b332b7f..4899f78 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -211,6 +211,9 @@ extern bool amd_iommu_dump;
 			printk(KERN_INFO "AMD-Vi: " format, ## arg);	\
 	} while(0);
 
+/* global flag if IOMMUs cache non-present entries */
+extern bool amd_iommu_np_cache;
+
 /*
  * Make iterating over all IOMMUs easier
  */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a1bd99d..5ebd24e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -131,12 +131,6 @@ static void amd_iommu_stats_init(void)
 
 #endif
 
-/* returns !0 if the IOMMU is caching non-present entries in its TLB */
-static int iommu_has_npcache(struct amd_iommu *iommu)
-{
-	return iommu->cap & (1UL << IOMMU_CAP_NPCACHE);
-}
-
 /****************************************************************************
  *
  * Interrupt handling functions
@@ -1713,7 +1707,7 @@ retry:
 	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
 		iommu_flush_tlb(&dma_dom->domain);
 		dma_dom->need_flush = false;
-	} else if (unlikely(iommu_has_npcache(iommu)))
+	} else if (unlikely(amd_iommu_np_cache))
 		iommu_flush_pages(&dma_dom->domain, address, size);
 
 out:
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 73d5173..fbe4c3c 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -141,6 +141,9 @@ LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 struct amd_iommu *amd_iommus[MAX_IOMMUS];
 int amd_iommus_present;
 
+/* IOMMUs have a non-present cache? */
+bool amd_iommu_np_cache __read_mostly;
+
 /*
  * List of protection domains - used during resume
  */
@@ -891,6 +894,9 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
 
+	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
+		amd_iommu_np_cache = true;
+
 	return pci_enable_device(iommu->dev);
 }
 
-- 
1.6.5.3


