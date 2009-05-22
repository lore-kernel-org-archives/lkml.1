Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbZEVMRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbZEVMRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbZEVMQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:16:15 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:42917
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758065AbZEVMQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:16:13 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KK1OQH-03-94F-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/9] amd-iommu: add function to flush tlb for all devices
Date: Fri, 22 May 2009 14:15:38 +0200
Message-ID: <1242994540-28799-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0470 (UTC) FILETIME=[06DC6260:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: be able to flush cache for all devtable entries ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h |    1 +
 arch/x86/kernel/amd_iommu.c      |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 1750e1f..262e028 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -28,6 +28,7 @@ extern int amd_iommu_init_dma_ops(void);
 extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
+extern void amd_iommu_flush_all_devices(void);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 826ad07..92b0e18 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -460,6 +460,24 @@ void amd_iommu_flush_all_domains(void)
 	}
 }
 
+void amd_iommu_flush_all_devices(void)
+{
+	struct amd_iommu *iommu;
+	int i;
+
+	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
+		if (amd_iommu_pd_table[i] == NULL)
+			continue;
+
+		iommu = amd_iommu_rlookup_table[i];
+		if (!iommu)
+			continue;
+
+		iommu_queue_inv_dev_entry(iommu, i);
+		iommu_completion_wait(iommu);
+	}
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
-- 
1.6.3.1


