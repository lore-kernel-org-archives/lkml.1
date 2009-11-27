Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZK0Hqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZK0Hqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 02:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZK0Hqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 02:46:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:34027 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZK0Hqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 02:46:51 -0500
Message-ID: <4B0F839D.5050104@kernel.org>
Date: Thu, 26 Nov 2009 23:45:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
References: <4B0CFCA6.5070708@kernel.org>	<20091125200337I.fujita.tomonori@lab.ntt.co.jp>	<4B0DB0B7.9040004@kernel.org> <20091127162918G.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091127162918G.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 25 Nov 2009 14:33:27 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> in aperture_64.c::gart_iommu_hole_init()
>>         printk(KERN_INFO  "Checking aperture...\n");
>>
>>         if (!fallback_aper_force)
>>                 agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
>>
>>         fix = 0;
>>         node = 0;
>>         for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
>>                 int bus;
>>                 int dev_base, dev_limit;
>>
>>                 bus = bus_dev_ranges[i].bus;
>>                 dev_base = bus_dev_ranges[i].dev_base;
>>                 dev_limit = bus_dev_ranges[i].dev_limit;
>>
>>                 for (slot = dev_base; slot < dev_limit; slot++) {
>>
>>                         if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
>>                                 continue;
>>
>>                         iommu_detected = 1;
>>                         gart_iommu_aperture = 1;
>>
>>                         aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
>>                         aper_size = (32 * 1024 * 1024) << aper_order;
>>                         aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
>>                         aper_base <<= 25;
>>
>>                         printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
>>                                         node, aper_base, aper_size >> 20);
>>                         node++;
>>
>>                         if (!aperture_valid(aper_base, aper_size, 64<<20)) {
>>                                 if (valid_agp && agp_aper_base &&
>>                                     agp_aper_base == aper_base &&
>>                                     agp_aper_order == aper_order) {
>>                                         /* the same between two setting from NB and agp */
>>                                         if (!no_iommu &&
>>                                             max_pfn > MAX_DMA32_PFN &&
>>                                             !printed_gart_size_msg) {
>>                                                 printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
>>                                                 printk(KERN_ERR "please increase GART size in your BIOS setup\n");
>>                                                 printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
>>                                                 printed_gart_size_msg = 1;
>>                                         }
>>                                 } else {
>> POINT A:
>>                                         fix = 1;
>>                                         goto out;
>>                                 }
>>                         }
>>
>>                         if ((last_aper_order && aper_order != last_aper_order) ||
>>                             (last_aper_base && aper_base != last_aper_base)) {
>>                                 fix = 1;
>>                                 goto out;
>>                         }
>>                         last_aper_order = aper_order;
>>                         last_aper_base = aper_base;
>>                 }
>>         }
>>
>> out:
>>         if (!fix && !fallback_aper_force) {
>>                 if (last_aper_base) {
>>                         unsigned long n = (32 * 1024 * 1024) << last_aper_order;
>>
>>                         insert_aperture_resource((u32)last_aper_base, n);
>>                 }
>>                 return;
>>         }
>>
>>         if (!fallback_aper_force) {
>>                 aper_alloc = agp_aper_base;
>>                 aper_order = agp_aper_order;
>>         }
>>
>>         if (aper_alloc) {
>>                 /* Got the aperture from the AGP bridge */
>>         } else if (swiotlb && !valid_agp) {
>> POINT: B
>>                 /* Do nothing */
>>         } else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
>>                    force_iommu ||
>>                    valid_agp ||
>>                    fallback_aper_force) {
>> POINT: C
>>                 printk(KERN_INFO
>>                         "Your BIOS doesn't leave a aperture memory hole\n");
>>                 printk(KERN_INFO
>>                         "Please enable the IOMMU option in the BIOS setup\n");
>>                 printk(KERN_INFO
>>                         "This costs you %d MB of RAM\n",
>>                                 32 << fallback_aper_order);
>>
>>                 aper_order = fallback_aper_order;
>>                 aper_alloc = allocate_aperture();
>>                 if (!aper_alloc) {
>>                         /*
>>                          * Could disable AGP and IOMMU here, but it's
>>                          * probably not worth it. But the later users
>>                          * cannot deal with bad apertures and turning
>>                          * on the aperture over memory causes very
>>                          * strange problems, so it's better to panic
>>                          * early.
>>                          */
>>                         panic("Not enough memory for aperture");
>>                 }
>>         } else {
>>                 return;
>>         }
>>
>> POINT X:
>>
>>         /* Fix up the north bridges */
>>         for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
>>                 int bus;
>>                 int dev_base, dev_limit;
>>
>>                 bus = bus_dev_ranges[i].bus;
>>                 dev_base = bus_dev_ranges[i].dev_base;
>>                 dev_limit = bus_dev_ranges[i].dev_limit;
>>                 for (slot = dev_base; slot < dev_limit; slot++) {
>>                         if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
>>                                 continue;
>>
>>                         /* Don't enable translation yet. That is done later.
>>                            Assume this BIOS didn't initialise the GART so
>>                            just overwrite all previous bits */
>>                         write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
>>                         write_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE, aper_alloc >> 25);
>>                 }
>>         }
>>
>> when AMD64 mem > 4g, no AGP, BIOS set all gart iommu on all nodes size to 32M, and enable bit are set.
> 
> I have such machine (with sane BIOS).
> 
> But if BIOS is broken, early_gart_iommu_check() disables GART_EN bit
> (bits 0)?

not for 32M small size.

that function only clear that bit when different nodes have different setting.

> 
>> 1. iommu=soft, will go through POINT A and POINT B
> 
> Not always. if aperture_valid() is true, it doesn't go POINT A. My
> GART machine doesn't go.

maybe your bios set GART iommu set to 64M?

> 
> 
>> 2. no "iommu=soft", will go through POINT A and POINT C
> 
> As I said, it's not true about POINT A.

maybe your bios set GART iommu set to 64M?

> 
> 
>> and all will reach POINT X to make sure ENABLE bit is not set.
> 
> POINT X doesn't look make sure ENABLE bit is not set. It just fixes up
> (sets) the address and its size.

                        write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);

that bit is that bit 0 of AMD64_GARTAPERTURECTL reg.

YH
