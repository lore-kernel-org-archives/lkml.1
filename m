Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbZFPI56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbZFPI56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZFPI4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:43 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:24924 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169AbZFPI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:40 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLBQ5W-03-9VQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/6] amd-iommu: disable IOMMU hardware on shutdown
Date: Tue, 16 Jun 2009 10:56:10 +0200
Message-ID: <1245142575-7166-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
References: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:56:17.0600 (UTC) FILETIME=[4F91DC00:01C9EE60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the IOMMU stays enabled the BIOS may not be able to finish the
machine shutdown properly. So disable the hardware on shutdown.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h |    2 ++
 arch/x86/kernel/amd_iommu_init.c |    5 +++++
 arch/x86/kernel/pci-dma.c        |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 262e028..bdf96f1 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -29,9 +29,11 @@ extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
+extern void amd_iommu_shutdown(void);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
+static inline void amd_iommu_shutdown(void) { }
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 238989e..575ca46 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1273,6 +1273,11 @@ free:
 	goto out;
 }
 
+void amd_iommu_shutdown(void)
+{
+	disable_iommus();
+}
+
 /****************************************************************************
  *
  * Early detect code. This code runs at IOMMU detection time in the DMA
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 745579b..328592f 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -290,6 +290,8 @@ static int __init pci_iommu_init(void)
 void pci_iommu_shutdown(void)
 {
 	gart_iommu_shutdown();
+
+	amd_iommu_shutdown();
 }
 /* Must execute after PCI subsystem */
 fs_initcall(pci_iommu_init);
-- 
1.6.3.1


