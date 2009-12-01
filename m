Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZLAHnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZLAHnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZLAHnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:43:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:33053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZLAHnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:43:21 -0500
Message-ID: <4B14C8C8.9020604@kernel.org>
Date: Mon, 30 Nov 2009 23:42:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
References: <4B0DB0B7.9040004@kernel.org>	<20091127162918G.fujita.tomonori@lab.ntt.co.jp>	<4B0F839D.5050104@kernel.org> <20091127170347O.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091127170347O.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Thu, 26 Nov 2009 23:45:33 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>>> when AMD64 mem > 4g, no AGP, BIOS set all gart iommu on all nodes size to 32M, and enable bit are set.
>>> I have such machine (with sane BIOS).
>>>
>>> But if BIOS is broken, early_gart_iommu_check() disables GART_EN bit
>>> (bits 0)?
>> not for 32M small size.
>>
>> that function only clear that bit when different nodes have different setting.
>>
>>>> 1. iommu=soft, will go through POINT A and POINT B
>>> Not always. if aperture_valid() is true, it doesn't go POINT A. My
>>> GART machine doesn't go.
>> maybe your bios set GART iommu set to 64M?
> 
> Yeah, my machine has sane BIOS.
> 
> 
>>>> 2. no "iommu=soft", will go through POINT A and POINT C
>>> As I said, it's not true about POINT A.
>> maybe your bios set GART iommu set to 64M?
>>
>>>
>>>> and all will reach POINT X to make sure ENABLE bit is not set.
>>> POINT X doesn't look make sure ENABLE bit is not set. It just fixes up
>>> (sets) the address and its size.
>>                         write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
>>
>> that bit is that bit 0 of AMD64_GARTAPERTURECTL reg.
> 
> Oops, thanks.
> 
> But as I wrote in the previous mail, can you tell me why we need this?
> With 2.6.31 my machine uses swiotlb with GART_EN bit enabled.
> 
> My another question is that why can't early_gart_iommu_check()
> _always_ disable GART_EN bit?

please check

[PATCH] x86: fix gart iommu using for amd 64 bit system -v4

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
-v3: add check_store to restore state for swiotlb
     separate pci_swiotlb_detect and pci_swiotlb_init from FUJITA
-v4: disable translating in early_gart_iommu_check according to FUJITA

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/swiotlb.h |    8 ++++++--
 arch/x86/kernel/aperture_64.c  |   11 ++++++-----
 arch/x86/kernel/pci-dma.c      |    8 ++++++--
 arch/x86/kernel/pci-gart_64.c  |    3 ++-
 arch/x86/kernel/pci-swiotlb.c  |   11 +++++++----
 5 files changed, 27 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -280,7 +280,8 @@ void __init early_gart_iommu_check(void)
 	 * or BIOS forget to put that in reserved.
 	 * try to update e820 to make that region as reserved.
 	 */
-	int i, fix, slot;
+	u32 agp_aper_base = 0, agp_aper_order = 0;
+	int i, fix, slot, valid_agp = 0;
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base = 0, last_aper_base = 0;
@@ -290,6 +291,8 @@ void __init early_gart_iommu_check(void)
 		return;
 
 	/* This is mostly duplicate of iommu_hole_init */
+	agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
+
 	fix = 0;
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
@@ -342,10 +345,10 @@ void __init early_gart_iommu_check(void)
 		}
 	}
 
-	if (!fix)
+	if (valid_agp)
 		return;
 
-	/* different nodes have different setting, disable them all at first*/
+	/* disable them all at first */
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
 		int dev_base, dev_limit;
@@ -458,8 +461,6 @@ out:
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
-	} else if (!valid_agp) {
-		/* Do nothing */
 	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
 		   valid_agp ||
Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -124,8 +124,9 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (pci_swiotlb_init())
-		return;
+
+	if (pci_swiotlb_detect())
+		goto out;
 
 	gart_iommu_hole_init();
 
@@ -135,6 +136,9 @@ void __init pci_iommu_alloc(void)
 
 	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
+
+out:
+	pci_swiotlb_init();
 }
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
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
Index: linux-2.6/arch/x86/include/asm/swiotlb.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/swiotlb.h
+++ linux-2.6/arch/x86/include/asm/swiotlb.h
@@ -5,13 +5,17 @@
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern int pci_swiotlb_init(void);
+int pci_swiotlb_detect(void);
+void pci_swiotlb_init(void);
 #else
 #define swiotlb 0
-static inline int pci_swiotlb_init(void)
+static inline int pci_swiotlb_detect(void)
 {
 	return 0;
 }
+static inline void pci_swiotlb_init(void)
+{
+}
 #endif
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
Index: linux-2.6/arch/x86/kernel/pci-swiotlb.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-swiotlb.c
+++ linux-2.6/arch/x86/kernel/pci-swiotlb.c
@@ -43,12 +43,12 @@ static struct dma_map_ops swiotlb_dma_op
 };
 
 /*
- * pci_swiotlb_init - initialize swiotlb if necessary
+ * pci_swiotlb_detect - initialize swiotlb if necessary
  *
  * This returns non-zero if we are forced to use swiotlb (by the boot
  * option).
  */
-int __init pci_swiotlb_init(void)
+int __init pci_swiotlb_detect(void)
 {
 	int use_swiotlb = swiotlb | swiotlb_force;
 
@@ -60,10 +60,13 @@ int __init pci_swiotlb_init(void)
 	if (swiotlb_force)
 		swiotlb = 1;
 
+	return use_swiotlb;
+}
+
+void __init pci_swiotlb_init(void)
+{
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	}
-
-	return use_swiotlb;
 }
