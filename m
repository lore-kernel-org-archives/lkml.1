Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0CDSYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:24:21 -0500
Received: from claw.goop.org ([74.207.240.146]:37853 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab0CDSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:24:20 -0500
Message-ID: <4B8FFAD2.8060205@goop.org>
Date: Thu, 04 Mar 2010 10:24:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>
Subject: Re: [PATCH 4/7] xen/hvm: Xen PV extension of HVM initialization
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com> <1267695416-14988-5-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1267695416-14988-5-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 01:36 AM, Sheng Yang wrote:
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index b83e119..af3c7a0 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -36,3 +36,11 @@ config XEN_DEBUG_FS
>   	help
>   	  Enable statistics output and various tuning options in debugfs.
>   	  Enabling this option may incur a significant performance overhead.
> +
> +config XEN_HVM_PV
> +	bool "PV extension of HVM"
> +	depends on XEN&&  X86_64
> +	default n
> +	help
> +	  Enable the PV extension of HVM, so that HVM guest would benefit from
> +	  PV features like PV timer and evtchn.
>    

Unless there's a strong reason to make this a user-visible setting, I'd 
make it a hidden option which is enabled by default when the 
dependencies are correct.

> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 3bb4fc2..73bd5db 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -17,4 +17,5 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>   obj-$(CONFIG_SMP)		+= smp.o
>   obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
>   obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
> +obj-$(CONFIG_XEN_HVM_PV)	+= hvmpv.o
>
> diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
> new file mode 100644
> index 0000000..7a741ed
> --- /dev/null
> +++ b/arch/x86/xen/hvmpv.c
> @@ -0,0 +1,133 @@
> +/*
> + * PV extension of HVM implementation.
> + *
> + * Sheng Yang<sheng@linux.intel.com>, Intel Corporation, 2010
> + *
> + */
> +#include<linux/kernel.h>
> +#include<linux/init.h>
> +#include<linux/percpu.h>
> +#include<linux/module.h>
> +
> +#include<xen/xen.h>
> +#include<xen/features.h>
> +#include<xen/events.h>
> +#include<xen/hvm.h>
> +#include<xen/interface/xen.h>
> +#include<xen/interface/version.h>
> +#include<xen/interface/memory.h>
> +
> +#include<asm/xen/cpuid.h>
> +#include<asm/xen/hypercall.h>
> +#include<asm/xen/hypervisor.h>
> +
> +#include "xen-ops.h"
> +
> +u32 xen_hvm_pv_features;
> +EXPORT_SYMBOL_GPL(xen_hvm_pv_features);
> +
> +static const struct pv_info xen_hvm_pv_info __initdata = {
> +	.paravirt_enabled = 1,
> +	.shared_kernel_pmd = 0,
> +	.kernel_rpl = 0,
> +	.name = "Xen",
> +};
> +
> +static void __init xen_hvm_pv_banner(void)
> +{
> +	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
> +	struct xen_extraversion extra;
> +	HYPERVISOR_xen_version(XENVER_extraversion,&extra);
> +
> +	printk(KERN_INFO "Booting PV extended HVM kernel on %s\n",
> +		pv_info.name);
> +	printk(KERN_INFO "Xen version: %d.%d%s\n",
> +		version>>  16, version&  0xffff, extra.extraversion);
> +}
> +
> +static int __init xen_para_available(void)
> +{
> +	uint32_t eax, ebx, ecx, edx;
> +	cpuid(XEN_CPUID_LEAF(0),&eax,&ebx,&ecx,&edx);
> +
> +	if (ebx == XEN_CPUID_SIGNATURE_EBX&&
> +	    ecx == XEN_CPUID_SIGNATURE_ECX&&
> +	    edx == XEN_CPUID_SIGNATURE_EDX&&
> +	    ((eax - XEN_CPUID_LEAF(0))>= 2))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int __init enable_hvm_pv(u64 flags)
> +{
> +	struct xen_hvm_pv_type a;
> +
> +	a.domid = DOMID_SELF;
> +	a.flags = flags;
> +	return HYPERVISOR_hvm_op(HVMOP_enable_pv,&a);
> +}
> +
> +static int __init init_hvm_pv_info(void)
> +{
> +	uint32_t ecx, edx, pages, msr;
> +	u64 pfn;
> +
> +	if (!xen_para_available())
> +		return -EINVAL;
> +
> +	cpuid(XEN_CPUID_LEAF(2),&pages,&msr,&ecx,&edx);
> +
> +	/* Check if hvm_pv mode is supported */
> +	if (!(edx&  XEN_CPUID_FEAT2_HVM_PV))
> +		return -ENODEV;
> +
> +	/* We only support 1 page of hypercall for now */
> +	if (pages != 1)
> +		return -ENOMEM;
>    

Why does it matter?  If you're only using hypercalls in the first page, 
it doesn't matter whether Xen exports more pages beyond that.

> +
> +	pfn = __pa(hypercall_page);
> +	wrmsrl(msr, pfn);
>    
wrmsr_safe() with error check, just in case it fails?

> +
> +	xen_setup_features();
> +
> +	x86_init.oem.banner = xen_hvm_pv_banner;
> +	pv_info = xen_hvm_pv_info;
> +
> +	xen_domain_type = XEN_HVM_DOMAIN;
>    

Set this very last, once everything else has successfully set up.

> +
> +	return 0;
> +}
> +
> +static struct shared_info shared_info_page __page_aligned_bss;
> +
> +static void __init init_shared_info(void)
> +{
> +	struct xen_add_to_physmap xatp;
> +
> +	xatp.domid = DOMID_SELF;
> +	xatp.idx = 0;
> +	xatp.space = XENMAPSPACE_shared_info;
> +	xatp.gpfn = __pa(&shared_info_page)>>  PAGE_SHIFT;
> +	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap,&xatp))
> +		BUG();
>    
It isn't too late to back out if it fails; just return an error code.
> +
> +	HYPERVISOR_shared_info = (struct shared_info *)&shared_info_page;
> +
> +	per_cpu(xen_vcpu, 0) =&HYPERVISOR_shared_info->vcpu_info[0];
> +}
> +
> +void __init xen_guest_init(void)
> +{
> +	int r;
> +
> +	/* Ensure the we won't confused with others */
> +	if (xen_domain_type != XEN_NATIVE)
>    
Just use xen_domain()?

> +		return;
> +
> +	r = init_hvm_pv_info();
> +	if (r<  0)
> +		return;
> +
> +	init_shared_info();
> +}
> diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
> index 7c74ba4..3f0b118 100644
> --- a/include/xen/interface/hvm/hvm_op.h
> +++ b/include/xen/interface/hvm/hvm_op.h
> @@ -69,4 +69,12 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_set_pci_link_route);
>   /* Flushes all VCPU TLBs: @arg must be NULL. */
>   #define HVMOP_flush_tlbs          5
>
> +#define HVMOP_enable_pv 9
> +struct xen_hvm_pv_type {
> +	domid_t domid;
> +	uint32_t flags;
> +#define HVM_PV_CLOCK  (1ull<<0)
> +#define HVM_PV_EVTCHN (1ull<<1)
> +};
> +
>   #endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
> diff --git a/include/xen/xen.h b/include/xen/xen.h
> index a164024..11f5ced 100644
> --- a/include/xen/xen.h
> +++ b/include/xen/xen.h
> @@ -19,6 +19,15 @@ extern enum xen_domain_type xen_domain_type;
>   #define xen_hvm_domain()	(xen_domain()&&			\
>   				 xen_domain_type == XEN_HVM_DOMAIN)
>
> +#ifdef CONFIG_XEN_HVM_PV
> +
> +#define XEN_HVM_PV_EVTCHN_ENABLED   (1u<<  1)
> +extern u32 xen_hvm_pv_features;
> +
> +#define xen_hvm_pv_evtchn_enabled() \
> +		(xen_hvm_pv_features&  XEN_HVM_PV_EVTCHN_ENABLED)
> +#endif /* CONFIG_XEN_HVM_PV */
>    

Did you compile test this with !CONFIG_XEN_HVM_PV?  I think it would 
fail with xen_hvm_pv_evtchn_enabled() undefined.  Fortunately making 
xen_hvm_pv_evtchn_enabled() evaluate to constant 0 in the !configed case 
will clean things up.

     J
