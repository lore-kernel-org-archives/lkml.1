Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZKNLsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZKNLsb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 06:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZKNLsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 06:48:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:52998 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbZKNLsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 06:48:15 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/3] x86: set dma_ops to nommu_dma_ops by default
Date: Sat, 14 Nov 2009 20:46:36 +0900
Message-Id: <1258199198-16657-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1258199198-16657-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258199198-16657-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Nov 2009 20:48:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we set dma_ops to nommu_dma_ops at two different places for x86_32 and
x86_64. This unifies them by setting dma_ops to nommu_dma_ops by
default.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c     |    4 +---
 arch/x86/kernel/pci-swiotlb.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 20c3dc3..bf621b9 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -15,7 +15,7 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_map_ops *dma_ops;
+struct dma_map_ops *dma_ops = &nommu_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -126,8 +126,6 @@ void __init pci_iommu_alloc(void)
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
-#else
-	dma_ops = &nommu_dma_ops;
 #endif
 	if (pci_swiotlb_init())
 		return;
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index a6e5d0f..e36e71d 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -61,8 +61,7 @@ int __init pci_swiotlb_init(void)
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
-	} else
-		dma_ops = &nommu_dma_ops;
+	}
 
 	return swiotlb_force;
 }
-- 
1.5.6.5

