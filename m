Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZKVE0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZKVE0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 23:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZKVE0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 23:26:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:46671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZKVE0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 23:26:37 -0500
Message-ID: <4B08BD14.9060102@kernel.org>
Date: Sat, 21 Nov 2009 20:24:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix gart iommu using for amd 64 bit system
References: <1257849980-22640-10-git-send-email-fujita.tomonori@lab.ntt.co.jp> <tip-75f1cdf1dda92cae037ec848ae63690d91913eac@git.kernel.org>
In-Reply-To: <tip-75f1cdf1dda92cae037ec848ae63690d91913eac@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


after
|commit 75f1cdf1dda92cae037ec848ae63690d91913eac
|Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
|Date:   Tue Nov 10 19:46:20 2009 +0900
|
|    x86: Handle HW IOMMU initialization failure gracefully
|    
|    If HW IOMMU initialization fails (Intel VT-d often does this,
|    typically due to BIOS bugs), we fall back to nommu. It doesn't
|    work for the majority since nowadays we have more than 4GB
|    memory so we must use swiotlb instead of nommu.
...

amd 64 systems that
1. do not have  AGP
2. do not have IOMMU
3. mem > 4g
4. BIOS do not allocate  correct gart in NB.
will leave them to use SWIOTLB forcely.

also in pci_iommu_alloc()
pci_swiotlb_init is stealing the preallocate range that is for
gart_iommu_hole workaround.

so restore the sequence...

will get back
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/aperture_64.c |    2 +-
 arch/x86/kernel/pci-dma.c     |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -458,7 +458,7 @@ out:
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
-	} else if (!valid_agp) {
+	} else if (swiotlb && !valid_agp) {
 		/* Do nothing */
 	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -124,11 +124,12 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
+	if (!swiotlb_force)
+		gart_iommu_hole_init();
+
 	if (pci_swiotlb_init())
 		return;
 
-	gart_iommu_hole_init();
-
 	detect_calgary();
 
 	detect_intel_iommu();
