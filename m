Return-Path: <linux-kernel-owner+w=401wt.eu-S1751012AbZKVFUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbZKVFUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 00:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZKVFUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 00:20:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:60551 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZKVFUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 00:20:54 -0500
Message-ID: <4B08C9F7.1030704@kernel.org>
Date: Sat, 21 Nov 2009 21:19:51 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix gart iommu using for amd 64 bit system -v2
References: <1257849980-22640-10-git-send-email-fujita.tomonori@lab.ntt.co.jp> <tip-75f1cdf1dda92cae037ec848ae63690d91913eac@git.kernel.org> <4B08BD14.9060102@kernel.org>
In-Reply-To: <4B08BD14.9060102@kernel.org>
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
...
[   12.702822] calling  pci_iommu_init+0x0/0x31 @ 1
[   12.708728] PCI-DMA: Disabling AGP.
[   12.712812] PCI-DMA: aperture base @ 20000000 size 65536 KB
[   12.718384] PCI-DMA: using GART IOMMU.
[   12.722139] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   12.736944] initcall pci_iommu_init+0x0/0x31 returned 0 after 28802 usecs

-v2: call shutdown when no agp is there

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/aperture_64.c |    2 +-
 arch/x86/kernel/pci-dma.c     |    5 +++--
 arch/x86/kernel/pci-gart_64.c |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

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
Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -710,7 +710,8 @@ static void gart_iommu_shutdown(void)
 	struct pci_dev *dev;
 	int i;
 
-	if (no_agp)
+	/* don't shutdown it if there is AGP installed */
+	if (!no_agp)
 		return;
 
 	for (i = 0; i < num_k8_northbridges; i++) {
