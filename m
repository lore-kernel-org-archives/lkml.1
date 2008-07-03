Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYGCRgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYGCRgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYGCRfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:35:48 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59123 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbYGCRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:35:46 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K3FY6J-03-NV8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/6] AMD IOMMU: flush domain TLB when there is more than one page to flush
Date: Thu, 3 Jul 2008 19:35:08 +0200
Message-ID: <1215106511-12915-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2008 17:35:12.0107 (UTC) FILETIME=[256D9BB0:01C8DD33]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the domain TLB flushing behavior of the driver. When there
is more than one page to flush it flushes the whole domain TLB instead of every
single page. So we send only a single command to the IOMMU in every case which
is faster to execute.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c       |   14 ++++++++++----
 include/asm-x86/amd_iommu_types.h |    2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 329b2c3..f2766d8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -140,16 +140,22 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		u64 address, size_t size)
 {
-	int i;
+	int s = 0;
 	unsigned pages = to_pages(address, size);
 
 	address &= PAGE_MASK;
 
-	for (i = 0; i < pages; ++i) {
-		iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 0);
-		address += PAGE_SIZE;
+	if (pages > 1) {
+		/*
+		 * If we have to flush more than one page, flush all
+		 * TLB entries for this domain
+		 */
+		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+		s = 1;
 	}
 
+	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, s);
+
 	return 0;
 }
 
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 0f39550..7bfcb47 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -93,6 +93,8 @@
 #define CMD_INV_IOMMU_PAGES_SIZE_MASK	0x01
 #define CMD_INV_IOMMU_PAGES_PDE_MASK	0x02
 
+#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
+
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
 #define DEV_ENTRY_TRANSLATION   0x01
-- 
1.5.3.7


