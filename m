Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZFPI5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZFPI5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbZFPI4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:35 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:25906
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755963AbZFPI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:33 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KLBQ5Y-02-3K6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/6] amd-iommu: flush domain tlb when attaching a new device
Date: Tue, 16 Jun 2009 10:56:12 +0200
Message-ID: <1245142575-7166-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
References: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:56:17.0647 (UTC) FILETIME=[4F9907F0:01C9EE60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

When kexec'ing to a new kernel (for example, when crashing and launching
a kdump session), the AMD IOMMU may have cached translations.  The kexec'd
kernel, during initialization, will invalidate the IOMMU device table
entries, but not the domain translations.  These stale entries can cause
a device's DMA to fail, makes it rough to write a dump to disk when the
disk controller can't DMA ;-)

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 1c60554..9372f04 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -434,6 +434,16 @@ static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
 	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
 }
 
+/* Flush the whole IO/TLB for a given protection domain - including PDE */
+static void iommu_flush_tlb_pde(struct amd_iommu *iommu, u16 domid)
+{
+       u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+
+       INC_STATS_COUNTER(domain_flush_single);
+
+       iommu_queue_inv_iommu_pages(iommu, address, domid, 1, 1);
+}
+
 /*
  * This function is used to flush the IO/TLB for a given protection domain
  * on every IOMMU in the system
@@ -1078,7 +1088,13 @@ static void attach_device(struct amd_iommu *iommu,
 	amd_iommu_pd_table[devid] = domain;
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
+       /*
+        * We might boot into a crash-kernel here. The crashed kernel
+        * left the caches in the IOMMU dirty. So we have to flush
+        * here to evict all dirty stuff.
+        */
 	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_tlb_pde(iommu, domain->id);
 }
 
 /*
-- 
1.6.3.1


