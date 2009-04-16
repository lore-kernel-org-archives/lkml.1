Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZDPCOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZDPCOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZDPCO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:14:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:31516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZDPCO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:14:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,196,1239001200"; 
   d="scan'208";a="448316616"
From: "Han, Weidong" <weidong.han@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       IOMMU <iommu@lists.linux-foundation.org>
Date: Thu, 16 Apr 2009 10:13:24 +0800
Subject: RE: [PATCH] Intel IOMMU Pass Through Support
Thread-Topic: [PATCH] Intel IOMMU Pass Through Support
Thread-Index: Acm+KRU1/saWyRDURNyjTkuNgliQmQAD6d9Q
Message-ID: <715D42877B251141A38726ABF5CABF2C01A300549D@pdsmsx503.ccr.corp.intel.com>
References: <20090327212241.234500000@intel.com>>
 <20090327212321.070229000@intel.com>
 <20090416001957.GA1527@linux-os.sc.intel.com>
In-Reply-To: <20090416001957.GA1527@linux-os.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Weidong Han <weidong@intel.com>

Yu, Fenghua wrote:
> The patch adds kernel parameter intel_iommu=pt to set up pass through
> mode in
> context mapping entry. This disables DMAR in linux kernel; but KVM
> still runs on
> VT-d and interrupt remapping still works.
>
> In this mode, kernel uses swiotlb for DMA API functions but other VT-d
> functionalities are enabled for KVM. KVM always uses multi level
> translation
> page table in VT-d. By default, pass though mode is disabled in
> kernel.
>
> This is useful when people don't want to enable VT-d DMAR in kernel
> but still
> want to use KVM and interrupt remapping for reasons like DMAR
> performance
> concern or debug purpose.
>
> Thanks.
>
> -Fenghua
>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>
> ---
>
>  Documentation/kernel-parameters.txt |    5
>  arch/ia64/include/asm/iommu.h       |    1
>  arch/ia64/kernel/pci-swiotlb.c      |    2
>  arch/x86/include/asm/iommu.h        |    1
>  arch/x86/kernel/pci-swiotlb.c       |    3
>  drivers/pci/dmar.c                  |    9 +
>  drivers/pci/intel-iommu.c           |  187
>  ++++++++++++++++++++++++++---------- include/linux/dma_remapping.h
>  |    8 + include/linux/intel-iommu.h         |    2
>  9 files changed, 167 insertions(+), 51 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index 6172e43..5594cdb 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -915,6 +915,11 @@ and is between 256 and 4096 characters. It is
>                       defined in the file With this option on every unmap_single
>                       operation will result in a hardware IOTLB flush operation as
>                       opposed to batching them for performance.
> +             pt      [Default no Pass Through]
> +                     This option enables Pass Through in context mapping if
> +                     Pass Through is supported in hardware. With this option
> +                     DMAR is disabled in kernel and kernel uses swiotlb, but
> +                     KVM can still uses VT-d IOTLB hardware.
>
>       inttest=        [IA64]
>
> diff --git a/arch/ia64/include/asm/iommu.h
> b/arch/ia64/include/asm/iommu.h
> index 0490794..37d41ca 100644
> --- a/arch/ia64/include/asm/iommu.h
> +++ b/arch/ia64/include/asm/iommu.h
> @@ -9,6 +9,7 @@ extern void pci_iommu_shutdown(void);
>  extern void no_iommu_init(void);
>  extern int force_iommu, no_iommu;
>  extern int iommu_detected;
> +extern int iommu_pass_through;
>  extern void iommu_dma_init(void);
>  extern void machvec_init(const char *name);
>
> diff --git a/arch/ia64/kernel/pci-swiotlb.c
> b/arch/ia64/kernel/pci-swiotlb.c
> index 285aae8..223abb1 100644
> --- a/arch/ia64/kernel/pci-swiotlb.c
> +++ b/arch/ia64/kernel/pci-swiotlb.c
> @@ -46,7 +46,7 @@ void __init swiotlb_dma_init(void)
>
>  void __init pci_swiotlb_init(void)
>  {
> -     if (!iommu_detected) {
> +     if (!iommu_detected || iommu_pass_through) {
>  #ifdef CONFIG_IA64_GENERIC
>               swiotlb = 1;
>               printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
> diff --git a/arch/x86/include/asm/iommu.h
> b/arch/x86/include/asm/iommu.h
> index af326a2..fd6d21b 100644
> --- a/arch/x86/include/asm/iommu.h
> +++ b/arch/x86/include/asm/iommu.h
> @@ -6,6 +6,7 @@ extern void no_iommu_init(void);
>  extern struct dma_map_ops nommu_dma_ops;
>  extern int force_iommu, no_iommu;
>  extern int iommu_detected;
> +extern int iommu_pass_through;
>
>  /* 10 seconds */
>  #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
> diff --git a/arch/x86/kernel/pci-swiotlb.c
> b/arch/x86/kernel/pci-swiotlb.c
> index 34f12e9..42a0eb1 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -71,7 +71,8 @@ void __init pci_swiotlb_init(void)
>  {
>       /* don't initialize swiotlb if iommu=off (no_iommu=1) */
>  #ifdef CONFIG_X86_64
> -     if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
> +     if ((!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN) ||
> +             iommu_pass_through)
>              swiotlb = 1;
>  #endif
>       if (swiotlb_force)
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index fa3a113..1ef1a19 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -515,6 +515,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
>       u32 ver;
>       static int iommu_allocated = 0;
>       int agaw = 0;
> +     int msagaw = 0;
>
>       iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
>       if (!iommu)
> @@ -539,8 +540,16 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
>                       iommu->seq_id);
>               goto error;
>       }
> +     msagaw = iommu_calculate_max_sagaw(iommu);
> +     if (msagaw < 0) {
> +             printk(KERN_ERR
> +                     "Cannot get a valid max agaw for iommu (seq_id = %d)\n",
> +                     iommu->seq_id);
> +             goto error;
> +     }
>  #endif
>       iommu->agaw = agaw;
> +     iommu->msagaw = msagaw;
>
>       /* the registers might be more than one page */
>       map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 001b328..205e4a1 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -53,6 +53,8 @@
>
>  #define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
>
> +#define MAX_AGAW_WIDTH 64
> +
>  #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
>
>  #define IOVA_PFN(addr)               ((addr) >> PAGE_SHIFT)
> @@ -127,8 +129,6 @@ static inline void
>       context_set_fault_enable(struct context_entry *context) context->lo
>  &= (((u64)-1) << 2) | 1; }
>
> -#define CONTEXT_TT_MULTI_LEVEL 0
> -
>  static inline void context_set_translation_type(struct context_entry
>                                               *context, unsigned long value)
>  {
> @@ -288,6 +288,7 @@ int dmar_disabled = 1;
>  static int __initdata dmar_map_gfx = 1;
>  static int dmar_forcedac;
>  static int intel_iommu_strict;
> +int iommu_pass_through;
>
>  #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
>  static DEFINE_SPINLOCK(device_domain_lock);
> @@ -318,6 +319,9 @@ static int __init intel_iommu_setup(char *str)
>                       printk(KERN_INFO
>                               "Intel-IOMMU: disable batched IOTLB flush\n");
>                       intel_iommu_strict = 1;
> +             } else if (!strncmp(str, "pt", 2)) {
> +                     iommu_pass_through = 1;
> +                     printk(KERN_INFO "Intel-IOMMU: Pass Through enabled\n");
>               }
>
>               str += strcspn(str, ",");
> @@ -397,17 +401,13 @@ void free_iova_mem(struct iova *iova)
>
>  static inline int width_to_agaw(int width);
>
> -/* calculate agaw for each iommu.
> - * "SAGAW" may be different across iommus, use a default agaw, and
> - * get a supported less agaw for iommus that don't support the
> default agaw.
> - */
> -int iommu_calculate_agaw(struct intel_iommu *iommu)
> +static int __iommu_calculate_agaw(struct intel_iommu *iommu, int
>  max_gaw) {
>       unsigned long sagaw;
>       int agaw = -1;
>
>       sagaw = cap_sagaw(iommu->cap);
> -     for (agaw = width_to_agaw(DEFAULT_DOMAIN_ADDRESS_WIDTH);
> +     for (agaw = width_to_agaw(max_gaw);
>            agaw >= 0; agaw--) {
>               if (test_bit(agaw, &sagaw))
>                       break;
> @@ -416,6 +416,24 @@ int iommu_calculate_agaw(struct intel_iommu
>       *iommu) return agaw;
>  }
>
> +/*
> + * Calculate max SAGAW for each iommu.
> + */
> +int iommu_calculate_max_sagaw(struct intel_iommu *iommu)
> +{
> +     return __iommu_calculate_agaw(iommu, MAX_AGAW_WIDTH);
> +}
> +
> +/*
> + * calculate agaw for each iommu.
> + * "SAGAW" may be different across iommus, use a default agaw, and
> + * get a supported less agaw for iommus that don't support the
> default agaw. + */
> +int iommu_calculate_agaw(struct intel_iommu *iommu)
> +{
> +     return __iommu_calculate_agaw(iommu, DEFAULT_DOMAIN_ADDRESS_WIDTH);
> +}
> +
>  /* in native case, each domain is related to only one iommu */
>  static struct intel_iommu *domain_get_iommu(struct dmar_domain
>  *domain) {
> @@ -1321,8 +1339,8 @@ static void domain_exit(struct dmar_domain
>       *domain) free_domain_mem(domain);
>  }
>
> -static int domain_context_mapping_one(struct dmar_domain *domain,
> -                                   int segment, u8 bus, u8 devfn)
> +static int domain_context_mapping_one(struct dmar_domain *domain,
> int segment, +                                 u8 bus, u8 devfn, int translation)
>  {
>       struct context_entry *context;
>       unsigned long flags;
> @@ -1335,7 +1353,10 @@ static int domain_context_mapping_one(struct
> dmar_domain *domain,
>
>       pr_debug("Set context mapping for %02x:%02x.%d\n",
>               bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
> +
>       BUG_ON(!domain->pgd);
> +     BUG_ON(translation != CONTEXT_TT_PASS_THROUGH &&
> +             translation != CONTEXT_TT_MULTI_LEVEL);
>
>       iommu = device_to_iommu(segment, bus, devfn);
>       if (!iommu)
> @@ -1395,9 +1416,18 @@ static int domain_context_mapping_one(struct
>       dmar_domain *domain, }
>
>       context_set_domain_id(context, id);
> -     context_set_address_width(context, iommu->agaw);
> -     context_set_address_root(context, virt_to_phys(pgd));
> -     context_set_translation_type(context, CONTEXT_TT_MULTI_LEVEL);
> +
> +     /*
> +      * In pass through mode, AW must be programmed to indicate the
> largest +      * AGAW value supported by hardware. And ASR is ignored by
> hardware. +    */
> +     if (likely(translation == CONTEXT_TT_MULTI_LEVEL)) {
> +             context_set_address_width(context, iommu->agaw);
> +             context_set_address_root(context, virt_to_phys(pgd));
> +     } else
> +             context_set_address_width(context, iommu->msagaw);
> +
> +     context_set_translation_type(context, translation);
>       context_set_fault_enable(context);
>       context_set_present(context);
>       domain_flush_cache(domain, context, sizeof(*context));
> @@ -1422,13 +1452,15 @@ static int domain_context_mapping_one(struct
>  dmar_domain *domain, }
>
>  static int
> -domain_context_mapping(struct dmar_domain *domain, struct pci_dev
> *pdev) +domain_context_mapping(struct dmar_domain *domain, struct
> pci_dev *pdev, +                      int translation)
>  {
>       int ret;
>       struct pci_dev *tmp, *parent;
>
>       ret = domain_context_mapping_one(domain, pci_domain_nr(pdev->bus),
> -                                      pdev->bus->number, pdev->devfn);
> +                                     pdev->bus->number, pdev->devfn,
> +                                     translation);
>       if (ret)
>               return ret;
>
> @@ -1440,9 +1472,9 @@ domain_context_mapping(struct dmar_domain
>       *domain, struct pci_dev *pdev) parent = pdev->bus->self;
>       while (parent != tmp) {
>               ret = domain_context_mapping_one(domain,
> -                                              pci_domain_nr(parent->bus),
> -                                              parent->bus->number,
> -                                              parent->devfn);
> +                                             pci_domain_nr(parent->bus),
> +                                             parent->bus->number,
> +                                             parent->devfn, translation);
>               if (ret)
>                       return ret;
>               parent = parent->bus->self;
> @@ -1450,12 +1482,14 @@ domain_context_mapping(struct dmar_domain
>       *domain, struct pci_dev *pdev) if (tmp->is_pcie) /* this is a
>               PCIE-to-PCI bridge */ return domain_context_mapping_one(domain,
>                                       pci_domain_nr(tmp->subordinate),
> -                                     tmp->subordinate->number, 0);
> +                                     tmp->subordinate->number, 0,
> +                                     translation);
>       else /* this is a legacy PCI bridge */
>               return domain_context_mapping_one(domain,
>                                                 pci_domain_nr(tmp->bus),
>                                                 tmp->bus->number,
> -                                               tmp->devfn);
> +                                               tmp->devfn,
> +                                               translation);
>  }
>
>  static int domain_context_mapped(struct pci_dev *pdev)
> @@ -1752,7 +1786,7 @@ static int iommu_prepare_identity_map(struct
>               pci_dev *pdev, goto error;
>
>       /* context entry init */
> -     ret = domain_context_mapping(domain, pdev);
> +     ret = domain_context_mapping(domain, pdev, CONTEXT_TT_MULTI_LEVEL);
>       if (!ret)
>               return 0;
>  error:
> @@ -1853,6 +1887,23 @@ static inline void iommu_prepare_isa(void)
>  }
>  #endif /* !CONFIG_DMAR_FLPY_WA */
>
> +/* Initialize each context entry as pass through.*/
> +static int __init init_context_pass_through(void)
> +{
> +     struct pci_dev *pdev = NULL;
> +     struct dmar_domain *domain;
> +     int ret;
> +
> +     for_each_pci_dev(pdev) {
> +             domain = get_domain_for_dev(pdev, DEFAULT_DOMAIN_ADDRESS_WIDTH);
> +             ret = domain_context_mapping(domain, pdev,
> +                                             CONTEXT_TT_PASS_THROUGH);
> +             if (ret)
> +                     return ret;
> +     }
> +     return 0;
> +}
> +
>  static int __init init_dmars(void)
>  {
>       struct dmar_drhd_unit *drhd;
> @@ -1860,6 +1911,7 @@ static int __init init_dmars(void)
>       struct pci_dev *pdev;
>       struct intel_iommu *iommu;
>       int i, ret;
> +     int pass_through = 1;
>
>       /*
>        * for each drhd
> @@ -1913,7 +1965,15 @@ static int __init init_dmars(void)
>                       printk(KERN_ERR "IOMMU: allocate root entry failed\n");
>                       goto error;
>               }
> +             if (!ecap_pass_through(iommu->ecap))
> +                     pass_through = 0;
>       }
> +     if (iommu_pass_through)
> +             if (!pass_through) {
> +                     printk(KERN_INFO
> +                             "Pass Through is not supported by hardware.\n");
> +                     iommu_pass_through = 0;
> +             }
>
>       /*
>        * Start from the sane iommu hardware state.
> @@ -1976,37 +2036,57 @@ static int __init init_dmars(void)
>                              "IOMMU: enable interrupt remapping failed\n");
>       }
>  #endif
> +     /*
> +      * If pass through is set and enabled, context entries of all pci
> +      * devices are intialized by pass through translation type.
> +      */
> +     if (iommu_pass_through) {
> +             ret = init_context_pass_through();
> +             if (ret) {
> +                     printk(KERN_ERR "IOMMU: Pass through init failed.\n");
> +                     iommu_pass_through = 0;
> +             }
> +     }
>
>       /*
> -      * For each rmrr
> -      *   for each dev attached to rmrr
> -      *   do
> -      *     locate drhd for dev, alloc domain for dev
> -      *     allocate free domain
> -      *     allocate page table entries for rmrr
> -      *     if context not allocated for bus
> -      *           allocate and init context
> -      *           set present in root table for this bus
> -      *     init context with domain, translation etc
> -      *    endfor
> -      * endfor
> +      * If pass through is not set or not enabled, setup context entries
> for +  * identity mappings for rmrr, gfx, and isa.
>        */
> -     for_each_rmrr_units(rmrr) {
> -             for (i = 0; i < rmrr->devices_cnt; i++) {
> -                     pdev = rmrr->devices[i];
> -                     /* some BIOS lists non-exist devices in DMAR table */
> -                     if (!pdev)
> -                             continue;
> -                     ret = iommu_prepare_rmrr_dev(rmrr, pdev);
> -                     if (ret)
> -                             printk(KERN_ERR
> +     if (!iommu_pass_through) {
> +             /*
> +              * For each rmrr
> +              *   for each dev attached to rmrr
> +              *   do
> +              *     locate drhd for dev, alloc domain for dev
> +              *     allocate free domain
> +              *     allocate page table entries for rmrr
> +              *     if context not allocated for bus
> +              *           allocate and init context
> +              *           set present in root table for this bus
> +              *     init context with domain, translation etc
> +              *    endfor
> +              * endfor
> +              */
> +             for_each_rmrr_units(rmrr) {
> +                     for (i = 0; i < rmrr->devices_cnt; i++) {
> +                             pdev = rmrr->devices[i];
> +                             /*
> +                              * some BIOS lists non-exist devices in DMAR
> +                              * table.
> +                              */
> +                             if (!pdev)
> +                                     continue;
> +                             ret = iommu_prepare_rmrr_dev(rmrr, pdev);
> +                             if (ret)
> +                                     printk(KERN_ERR
>                                "IOMMU: mapping reserved region failed\n");
> +                     }
>               }
> -     }
>
> -     iommu_prepare_gfx_mapping();
> +             iommu_prepare_gfx_mapping();
>
> -     iommu_prepare_isa();
> +             iommu_prepare_isa();
> +     }
>
>       /*
>        * for each drhd
> @@ -2117,7 +2197,8 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
>
>       /* make sure context mapping is ok */
>       if (unlikely(!domain_context_mapped(pdev))) {
> -             ret = domain_context_mapping(domain, pdev);
> +             ret = domain_context_mapping(domain, pdev,
> +                                              CONTEXT_TT_MULTI_LEVEL);
>               if (ret) {
>                       printk(KERN_ERR
>                               "Domain context map for %s failed",
> @@ -2786,7 +2867,7 @@ int __init intel_iommu_init(void)
>        * Check the need for DMA-remapping initialization now.
>        * Above initialization will also be used by Interrupt-remapping.
>        */
> -     if (no_iommu || swiotlb || dmar_disabled)
> +     if (no_iommu || (swiotlb && !iommu_pass_through) || dmar_disabled)
>               return -ENODEV;
>
>       iommu_init_mempool();
> @@ -2806,7 +2887,15 @@ int __init intel_iommu_init(void)
>
>       init_timer(&unmap_timer);
>       force_iommu = 1;
> -     dma_ops = &intel_dma_ops;
> +
> +     if (!iommu_pass_through) {
> +             printk(KERN_INFO
> +                     "Multi-level page-table translation for DMAR.\n");
> +             dma_ops = &intel_dma_ops;
> +     } else
> +             printk(KERN_INFO
> +                     "DMAR: Pass through translation for DMAR.\n");
> +
>       init_iommu_sysfs();
>
>       register_iommu(&intel_iommu_ops);
> @@ -3146,7 +3235,7 @@ static int intel_iommu_attach_device(struct
>               iommu_domain *domain, return -EFAULT;
>       }
>
> -     ret = domain_context_mapping(dmar_domain, pdev);
> +     ret = domain_context_mapping(dmar_domain, pdev,
>       CONTEXT_TT_MULTI_LEVEL); if (ret)
>               return ret;
>
> diff --git a/include/linux/dma_remapping.h
> b/include/linux/dma_remapping.h
> index 1a455f1..e0a03af 100644
> --- a/include/linux/dma_remapping.h
> +++ b/include/linux/dma_remapping.h
> @@ -13,6 +13,9 @@
>  #define DMA_PTE_WRITE (2)
>  #define DMA_PTE_SNP (1 << 11)
>
> +#define CONTEXT_TT_MULTI_LEVEL       0
> +#define CONTEXT_TT_PASS_THROUGH 2
> +
>  struct intel_iommu;
>  struct dmar_domain;
>  struct root_entry;
> @@ -21,11 +24,16 @@ extern void free_dmar_iommu(struct intel_iommu
> *iommu);
>
>  #ifdef CONFIG_DMAR
>  extern int iommu_calculate_agaw(struct intel_iommu *iommu);
> +extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
>  #else
>  static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
>  {
>       return 0;
>  }
> +static inline int iommu_calculate_max_sagaw(struct intel_iommu
> *iommu) +{
> +     return 0;
> +}
>  #endif
>
>  extern int dmar_disabled;
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index aa8c531..7246971 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -120,6 +120,7 @@ static inline void dmar_writeq(void __iomem
>       *addr, u64 val) (ecap_iotlb_offset(e) + ecap_niotlb_iunits(e) * 16)
>  #define ecap_coherent(e)     ((e) & 0x1)
>  #define ecap_qis(e)          ((e) & 0x2)
> +#define ecap_pass_through(e) ((e >> 6) & 0x1)
>  #define ecap_eim_support(e)  ((e >> 4) & 0x1)
>  #define ecap_ir_support(e)   ((e >> 3) & 0x1)
>  #define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
> @@ -302,6 +303,7 @@ struct intel_iommu {
>       spinlock_t      register_lock; /* protect register handling */
>       int             seq_id; /* sequence id of the iommu */
>       int             agaw; /* agaw of this iommu */
> +     int             msagaw; /* max sagaw of this iommu */
>       unsigned int    irq;
>       unsigned char   name[13];    /* Device Name */

