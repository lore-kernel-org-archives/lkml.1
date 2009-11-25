Return-Path: <linux-kernel-owner+w=401wt.eu-S964968AbZKYWfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbZKYWfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964930AbZKYWfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:35:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:40866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964916AbZKYWfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:35:03 -0500
Message-ID: <4B0DB0B7.9040004@kernel.org>
Date: Wed, 25 Nov 2009 14:33:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
References: <20091125180517P.fujita.tomonori@lab.ntt.co.jp>	<20091125091026.GA11117@elte.hu>	<4B0CFCA6.5070708@kernel.org> <20091125200337I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091125200337I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 25 Nov 2009 01:45:10 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Ingo Molnar wrote:
>>> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>>
>>>> On Wed, 25 Nov 2009 00:54:34 -0800
>>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>>
>>>>> only remember that SLES 9 SP3 (?) at some point has problem with AMD 
>>>>> 10h ( quad core version) when memory > 4 g (with USB controller ?) 
>>>>> because the gart code only check K8 device id, and didn't check 10h 
>>>>> device id. so gart iommu is not used. and happenly swiotlb code has 
>>>>> problem with that kernel version.
>>>>>
>>>>> thinking we should keep old behavior, until some day we can remove 
>>>>> them all.
>>>> Why? We are talking about changing 2.6.33 behavior. swiotlb in 2.6.33 
>>>> should be the safe option.
>>> If that behavior was relied on for suspected (or real) bugs in the 
>>> swiotlb code then i agree that we should do this change. (and fix any 
>>> bugs if they still occur.)
>> after look at gart_iommu_hole_init() closely,
>>
>> should be
>>
>> for AMD 64bit, MEM > 4g, no AGP, iommu=soft
>> 1. if BIOS have correct gart setting, Kernel will use swiotlb
>> 2. if BIOS does not have correct gart setting, Kernel will use swiotlb
>>
>> and for the all the cases, the codes after that 
>> /* Fix up the north bridges */
>> ...
>>
>> will disable the translation...
> 
> What code are you talking about? GART translation is disabled at boot
> time (if not, we are dead because some GART hardware are broken so we
> need to fix things before enabling them).
> 
> 
>> so even swiotlb=soft is used, gart_iommu_hole_init() still need to
>> be called. to make sure aperture is disabled somehow.
> 
> I don't think so.

in aperture_64.c::gart_iommu_hole_init()
        printk(KERN_INFO  "Checking aperture...\n");

        if (!fallback_aper_force)
                agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);

        fix = 0;
        node = 0;
        for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
                int bus;
                int dev_base, dev_limit;

                bus = bus_dev_ranges[i].bus;
                dev_base = bus_dev_ranges[i].dev_base;
                dev_limit = bus_dev_ranges[i].dev_limit;

                for (slot = dev_base; slot < dev_limit; slot++) {

                        if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
                                continue;

                        iommu_detected = 1;
                        gart_iommu_aperture = 1;

                        aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
                        aper_size = (32 * 1024 * 1024) << aper_order;
                        aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
                        aper_base <<= 25;

                        printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
                                        node, aper_base, aper_size >> 20);
                        node++;

                        if (!aperture_valid(aper_base, aper_size, 64<<20)) {
                                if (valid_agp && agp_aper_base &&
                                    agp_aper_base == aper_base &&
                                    agp_aper_order == aper_order) {
                                        /* the same between two setting from NB and agp */
                                        if (!no_iommu &&
                                            max_pfn > MAX_DMA32_PFN &&
                                            !printed_gart_size_msg) {
                                                printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
                                                printk(KERN_ERR "please increase GART size in your BIOS setup\n");
                                                printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
                                                printed_gart_size_msg = 1;
                                        }
                                } else {
POINT A:
                                        fix = 1;
                                        goto out;
                                }
                        }

                        if ((last_aper_order && aper_order != last_aper_order) ||
                            (last_aper_base && aper_base != last_aper_base)) {
                                fix = 1;
                                goto out;
                        }
                        last_aper_order = aper_order;
                        last_aper_base = aper_base;
                }
        }

out:
        if (!fix && !fallback_aper_force) {
                if (last_aper_base) {
                        unsigned long n = (32 * 1024 * 1024) << last_aper_order;

                        insert_aperture_resource((u32)last_aper_base, n);
                }
                return;
        }

        if (!fallback_aper_force) {
                aper_alloc = agp_aper_base;
                aper_order = agp_aper_order;
        }

        if (aper_alloc) {
                /* Got the aperture from the AGP bridge */
        } else if (swiotlb && !valid_agp) {
POINT: B
                /* Do nothing */
        } else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
                   force_iommu ||
                   valid_agp ||
                   fallback_aper_force) {
POINT: C
                printk(KERN_INFO
                        "Your BIOS doesn't leave a aperture memory hole\n");
                printk(KERN_INFO
                        "Please enable the IOMMU option in the BIOS setup\n");
                printk(KERN_INFO
                        "This costs you %d MB of RAM\n",
                                32 << fallback_aper_order);

                aper_order = fallback_aper_order;
                aper_alloc = allocate_aperture();
                if (!aper_alloc) {
                        /*
                         * Could disable AGP and IOMMU here, but it's
                         * probably not worth it. But the later users
                         * cannot deal with bad apertures and turning
                         * on the aperture over memory causes very
                         * strange problems, so it's better to panic
                         * early.
                         */
                        panic("Not enough memory for aperture");
                }
        } else {
                return;
        }

POINT X:

        /* Fix up the north bridges */
        for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
                int bus;
                int dev_base, dev_limit;

                bus = bus_dev_ranges[i].bus;
                dev_base = bus_dev_ranges[i].dev_base;
                dev_limit = bus_dev_ranges[i].dev_limit;
                for (slot = dev_base; slot < dev_limit; slot++) {
                        if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
                                continue;

                        /* Don't enable translation yet. That is done later.
                           Assume this BIOS didn't initialise the GART so
                           just overwrite all previous bits */
                        write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
                        write_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE, aper_alloc >> 25);
                }
        }

when AMD64 mem > 4g, no AGP, BIOS set all gart iommu on all nodes size to 32M, and enable bit are set.
1. iommu=soft, will go through POINT A and POINT B
2. no "iommu=soft", will go through POINT A and POINT C
and all will reach POINT X to make sure ENABLE bit is not set.

please check

[PATCH] x86: fix gart iommu using for amd 64 bit system -v3

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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/swiotlb.h |    8 ++++++--
 arch/x86/kernel/aperture_64.c  |   17 ++++++++++++++---
 arch/x86/kernel/pci-dma.c      |   11 +++++++++--
 arch/x86/kernel/pci-gart_64.c  |    3 ++-
 arch/x86/kernel/pci-swiotlb.c  |   11 +++++++----
 5 files changed, 38 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -375,6 +375,9 @@ void __init gart_iommu_hole_init(void)
 	u64 aper_base, last_aper_base = 0;
 	int fix, slot, valid_agp = 0;
 	int i, node;
+	int iommu_detected_old = iommu_detected;
+	int gart_iommu_aperture_old = gart_iommu_aperture;
+	int (*iommu_init_old)(void) = x86_init.iommu.iommu_init;
 
 	if (gart_iommu_aperture_disabled || !fix_aperture ||
 	    !early_pci_allowed())
@@ -448,7 +451,7 @@ out:
 
 			insert_aperture_resource((u32)last_aper_base, n);
 		}
-		return;
+		goto check_restore;
 	}
 
 	if (!fallback_aper_force) {
@@ -458,7 +461,7 @@ out:
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
-	} else if (!valid_agp) {
+	} else if (swiotlb && !valid_agp) {
 		/* Do nothing */
 	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
@@ -486,7 +489,7 @@ out:
 			panic("Not enough memory for aperture");
 		}
 	} else {
-		return;
+		goto check_restore;
 	}
 
 	/* Fix up the north bridges */
@@ -510,4 +513,12 @@ out:
 	}
 
 	set_up_gart_resume(aper_order, aper_alloc);
+
+check_restore:
+	if (swiotlb) {
+		/* restore the setting */
+		iommu_detected = iommu_detected_old;
+		gart_iommu_aperture = gart_iommu_aperture_old;
+		x86_init.iommu.iommu_init = iommu_init_old;
+	}
 }
Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -120,21 +120,28 @@ static void __init dma32_free_bootmem(vo
 
 void __init pci_iommu_alloc(void)
 {
+	int ret;
+
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (pci_swiotlb_init())
-		return;
+	ret = pci_swiotlb_detect();
 
 	gart_iommu_hole_init();
 
+	if (ret)
+		goto out;
+
 	detect_calgary();
 
 	detect_intel_iommu();
 
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


