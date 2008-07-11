Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYGKPPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYGKPPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYGKPOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:14:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64318 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYGKPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:14:54 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0K3UL0C-04-EOG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/16] AMD IOMMU: replace HIGH_U32 macro with upper_32_bits function
Date: Fri, 11 Jul 2008 17:14:23 +0200
Message-ID: <1215789275-20975-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0039 (UTC) FILETIME=[D471C970:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes a driver specific macro and replaces it with a generic function already
available in Linux.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c       |    4 ++--
 include/asm-x86/amd_iommu_types.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4bae96c..9098f04 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -109,7 +109,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.data[0] = LOW_U32(ready_phys) | CMD_COMPL_WAIT_STORE_MASK;
-	cmd.data[1] = HIGH_U32(ready_phys);
+	cmd.data[1] = upper_32_bits(ready_phys);
 	cmd.data[2] = 1; /* value written to 'ready' */
 	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
 
@@ -157,7 +157,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	CMD_SET_TYPE(&cmd, CMD_INV_IOMMU_PAGES);
 	cmd.data[1] |= domid;
 	cmd.data[2] = LOW_U32(address);
-	cmd.data[3] = HIGH_U32(address);
+	cmd.data[3] = upper_32_bits(address);
 	if (s) /* size bit - we flush more than one 4kb page */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
 	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 945fd49..14aaffe 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -33,7 +33,6 @@
 
 /* helper macros */
 #define LOW_U32(x) ((x) & ((1ULL << 32)-1))
-#define HIGH_U32(x) (LOW_U32((x) >> 32))
 
 /* Length of the MMIO region for the AMD IOMMU */
 #define MMIO_REGION_LENGTH       0x4000
-- 
1.5.3.7


