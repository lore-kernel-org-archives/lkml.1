Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZLNDmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZLNDmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZLNDmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:42:52 -0500
Received: from sh.osrg.net ([192.16.179.4]:54268 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbZLNDmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:42:46 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/2] x86: move swiotlb initialization before dma32_free_bootmem
Date: Mon, 14 Dec 2009 11:52:14 +0900
Message-Id: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1260759135-6450-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1260759135-6450-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 14 Dec 2009 12:41:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 75f1cdf1dda92cae037ec848ae63690d91913eac introduced a bug
that we initialize SWIOTLB right after dma32_free_bootmem so we
wrongly steal memory area allocated for GART with broken BIOS earlier.

This moves swiotlb initialization before dma32_free_bootmem().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index afcc58b..fcc2f2b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -120,11 +120,14 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
+	int use_swiotlb;
+
+	use_swiotlb = pci_swiotlb_init();
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (pci_swiotlb_init())
+	if (use_swiotlb)
 		return;
 
 	gart_iommu_hole_init();
-- 
1.5.6.5

