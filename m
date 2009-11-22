Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZKVDRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZKVDRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 22:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZKVDRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 22:17:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52321 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbZKVDRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 22:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HIyU+kprLqFw9O9zyiYs93jhOBTmj6qRGqLFVrizkKHbtTDBsD97Fi4OIxmfG9WHgF
         RGvZ3dLz8iSvdBhSHgNtE8gU6ESk9I1vl6suTlWF8MB21lRbLQAIUREUGyPtRchywn7t
         UAJLRm1+Bx++Xo1prnXTqbWEvP62CqSZSrhRE=
MIME-Version: 1.0
In-Reply-To: <20091110111919.GA20353@elte.hu>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <20091110111919.GA20353@elte.hu>
Date: Sat, 21 Nov 2009 19:17:37 -0800
Message-ID: <86802c440911211917s64fb8f92g718fc80367c55985@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] x86: handle HW IOMMU initialization failure 
	gracefully
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 3:19 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>> This patchset is against tip/master.
>>
>> The first version is:
>>
>> http://marc.info/?l=linux-kernel&m=125671300920411&w=2
>>
>> The changes since v1 are:
>>
>> - replaced Chris' bootmem patches with the 6/9 patch to implement
>>   free_bootmem_late in a simple way (thanks to Pekka).
>>
>> - fixed the bug to break 'iommu=soft' boot opiton (found by Joerg).
>>
>> - moved iommu_init_noop() to x86_init.c
>>
>> - added Muli's Acked-by to Calgary patch.
>>
>>
>> ==
>>  arch/ia64/kernel/pci-swiotlb.c   |    4 +-
>>  arch/powerpc/kernel/setup_32.c   |    2 +-
>>  arch/powerpc/kernel/setup_64.c   |    2 +-
>>  arch/x86/include/asm/amd_iommu.h |    2 -
>>  arch/x86/include/asm/calgary.h   |    2 -
>>  arch/x86/include/asm/gart.h      |    5 +---
>>  arch/x86/include/asm/iommu.h     |    1 -
>>  arch/x86/include/asm/x86_init.h  |    9 +++++++
>>  arch/x86/kernel/amd_iommu.c      |    2 +-
>>  arch/x86/kernel/amd_iommu_init.c |   19 +++-----------
>>  arch/x86/kernel/aperture_64.c    |    4 ++-
>>  arch/x86/kernel/pci-calgary_64.c |   19 ++++-----------
>>  arch/x86/kernel/pci-dma.c        |   27 ++++++++++-----------
>>  arch/x86/kernel/pci-gart_64.c    |   16 ++++-------
>>  arch/x86/kernel/pci-nommu.c      |    9 -------
>>  arch/x86/kernel/pci-swiotlb.c    |   10 +++----
>>  arch/x86/kernel/x86_init.c       |    5 ++++
>>  drivers/pci/dmar.c               |    7 ++++-
>>  drivers/pci/intel-iommu.c        |    4 +-
>>  include/linux/bootmem.h          |    1 +
>>  include/linux/dmar.h             |   10 -------
>>  include/linux/swiotlb.h          |    5 ++-
>>  lib/swiotlb.c                    |   49 +++++++++++++++++++++++++++++++------
>>  mm/bootmem.c                     |   24 ++++++++++++++++++
>>  24 files changed, 131 insertions(+), 107 deletions(-)
>
> Nice changes! I've applied them to tip:core/iommu (with the small build
> fix i mentioned in the previous mail) and will push them out later
> today.
>

this patch set will break some AMD system

amd 64 systems that
1. do not have  AGP
2. do not have IOMMU
3. mem > 4g
4. BIOS do not allocate  correct gart in NB.

will leave them to use SWIOTLB forcely.

following code that allocate some RAM as aperture will be called
anymore for them
        } else if (!valid_agp) {
                /* Do nothing */
        } else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
                   force_iommu ||
                   valid_agp ||
                   fallback_aper_force) {
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

also in

 void __init pci_iommu_alloc(void)
{
#ifdef CONFIG_X86_64
        /* free the range so iommu could get some range less than 4G */
        dma32_free_bootmem();
#endif
        if (pci_swiotlb_init())
                return;

        gart_iommu_hole_init();

        detect_calgary();

        detect_intel_iommu();

        /* needs to be called after gart_iommu_hole_init */
        amd_iommu_detect();
}

pci_swiotlb_init is stealing the preallocate range that is
gart_iommu_hole workaround.

so please move back swiotlb_init to the end.

there is no point to allocate swiotlb at first and then free it if
some iommu is there.

YH
