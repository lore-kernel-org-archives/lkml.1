Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0CBBh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:37:59 -0500
Received: from mga05.intel.com ([192.55.52.89]:42613 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603Ab0CBBh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:37:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,563,1262592000"; 
   d="scan'208";a="777067579"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 3/7] xen/hvm: Xen PV extension of 
 =?iso-8859-15?q?HVM=09initialization?=
Date: Tue, 2 Mar 2010 09:38:53 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-4-git-send-email-sheng@linux.intel.com> <4B8C63B0.2090507@goop.org>
In-Reply-To: <4B8C63B0.2090507@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003020938.53630.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010 09:02:40 Jeremy Fitzhardinge wrote:
> On 03/01/2010 01:38 AM, Sheng Yang wrote:
> > The PV extension of HVM(once known as Hybrid) is started from real mode
> > like HVM guest, but also with a component based PV feature selection(e.g.
> > PV halt, PV timer, event channel, then PV drivers). So guest can takes
> > the advantages of both H/W virtualization and Para-Virtualization.
> >
> > This patch introduced the PV extension of HVM guest initialization.
> >
> > Guest would detect the capability using CPUID 0x40000002.edx, then call
> > HVMOP_enable_pv hypercall to enable pv support in hypervisor.
> >
> > Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> > Signed-off-by: Yaozu (Eddie) Dong<eddie.dong@intel.com>
> > ---
> >   arch/x86/include/asm/xen/cpuid.h   |    5 ++
> >   arch/x86/xen/enlighten.c           |  115
> > ++++++++++++++++++++++++++++++++++++ arch/x86/xen/irq.c                 |
> >   21 +++++++
> >   arch/x86/xen/xen-head.S            |    6 ++
> >   arch/x86/xen/xen-ops.h             |    1 +
> >   include/xen/interface/hvm/hvm_op.h |    7 ++
> >   include/xen/xen.h                  |    9 +++
> >   7 files changed, 164 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/xen/cpuid.h
> > b/arch/x86/include/asm/xen/cpuid.h index 8787f03..a93c851 100644
> > --- a/arch/x86/include/asm/xen/cpuid.h
> > +++ b/arch/x86/include/asm/xen/cpuid.h
> > @@ -65,4 +65,9 @@
> >   #define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
> >   #define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
> >
> > +#define _XEN_CPUID_FEAT2_HVM_PV 0
> > +#define XEN_CPUID_FEAT2_HVM_PV (1u<<0)
> > +#define _XEN_CPUID_FEAT2_HVM_PV_EVTCHN 1
> > +#define XEN_CPUID_FEAT2_HVM_PV_EVTCHN (1u<<1)
> > +
> >   #endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 36daccb..fdb9664 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -34,6 +34,8 @@
> >   #include<xen/interface/version.h>
> >   #include<xen/interface/physdev.h>
> >   #include<xen/interface/vcpu.h>
> > +#include<xen/interface/memory.h>
> > +#include<xen/interface/hvm/hvm_op.h>
> >   #include<xen/features.h>
> >   #include<xen/page.h>
> >   #include<xen/hvc-console.h>
> > @@ -43,6 +45,7 @@
> >   #include<asm/page.h>
> >   #include<asm/xen/hypercall.h>
> >   #include<asm/xen/hypervisor.h>
> > +#include<asm/xen/cpuid.h>
> >   #include<asm/fixmap.h>
> >   #include<asm/processor.h>
> >   #include<asm/proto.h>
> > @@ -1198,3 +1201,115 @@ asmlinkage void __init xen_start_kernel(void)
> >   	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
> >   #endif
> >   }
> > +
> > +static void __init xen_hvm_pv_banner(void)
> > +{
> > +	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
> > +	struct xen_extraversion extra;
> > +	HYPERVISOR_xen_version(XENVER_extraversion,&extra);
> > +
> > +	printk(KERN_INFO "Booting PV featured HVM kernel on %s\n",
> > +		pv_info.name);
> > +	printk(KERN_INFO "Xen version: %d.%d%s\n",
> > +		version>>  16, version&  0xffff, extra.extraversion);
> > +}
> > +
> > +static int xen_para_available(void)
> > +{
> > +	uint32_t eax, ebx, ecx, edx;
> > +	cpuid(XEN_CPUID_LEAF(0),&eax,&ebx,&ecx,&edx);
> > +
> > +	if (ebx == XEN_CPUID_SIGNATURE_EBX&&
> > +	    ecx == XEN_CPUID_SIGNATURE_ECX&&
> > +	    edx == XEN_CPUID_SIGNATURE_EDX&&
> > +	    ((eax - XEN_CPUID_LEAF(0))>= 2))
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> > +u32 xen_hvm_pv_status;
> > +EXPORT_SYMBOL_GPL(xen_hvm_pv_status);
> > +
> > +static int enable_hvm_pv(u64 flags)
> > +{
> > +	struct xen_hvm_pv_type a;
> > +
> > +	a.domid = DOMID_SELF;
> > +	a.flags = flags;
> > +	return HYPERVISOR_hvm_op(HVMOP_enable_pv,&a);
> > +}
> > +
> > +static int init_hvm_pv_info(void)
> > +{
> > +	uint32_t ecx, edx, pages, msr;
> > +	u64 pfn;
> > +
> > +	if (!xen_para_available())
> > +		return -EINVAL;
> > +
> > +	cpuid(XEN_CPUID_LEAF(2),&pages,&msr,&ecx,&edx);
> > +
> > +	/* Check if hvm_pv mode is supported */
> > +	if (!(edx&  XEN_CPUID_FEAT2_HVM_PV))
> > +		return -ENODEV;
> > +
> > +	xen_hvm_pv_status = XEN_HVM_PV_ENABLED;
> 
> Why use this?  Why not just set the domain type to HVM, and leave the
> "status" field as a bitset of available paravirtualizations?

A annoy thing in pv drivers is that it would test if the domain type is _NOT_ 
XEN_NATIVE. So set the domain to XEN_HVM_DOMAIN would result in PV driver 
initialization then probably panic. Maybe we can do something to PV drivers, 
as patch 6 and a part of patch 7.
> 
> > +
> > +	/* We only support 1 page of hypercall for now */
> > +	if (pages != 1)
> > +		return -ENOMEM;
> > +
> > +	pfn = __pa(hypercall_page);
> > +	wrmsrl(msr, pfn);
> > +
> > +	xen_setup_features();
> > +
> > +	x86_init.oem.banner = xen_hvm_pv_banner;
> > +	pv_info = xen_info;
> > +	pv_info.kernel_rpl = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +extern struct shared_info shared_info_page;
> > +
> > +static void __init init_shared_info(void)
> > +{
> > +	struct xen_add_to_physmap xatp;
> > +
> > +	xatp.domid = DOMID_SELF;
> > +	xatp.idx = 0;
> > +	xatp.space = XENMAPSPACE_shared_info;
> > +	xatp.gpfn = __pa(&shared_info_page)>>  PAGE_SHIFT;
> > +	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap,&xatp))
> > +		BUG();
> > +
> > +	HYPERVISOR_shared_info = (struct shared_info *)&shared_info_page;
> > +
> > +	/* Don't do the full vcpu_info placement stuff until we have a
> > +	   possible map and a non-dummy shared_info. */
> 
> Is this comment meaningful here?  This is the real shared info at this
> point, no?  Are you going to support vcpu_info placement?

Would discard this..
 
> > +	per_cpu(xen_vcpu, 0) =&HYPERVISOR_shared_info->vcpu_info[0];
> > +}
> > +
> > +void __init xen_guest_init(void)
> > +{
> > +#ifdef CONFIG_X86_32
> > +	return;
> > +#else
> > +	int r;
> > +
> > +	/* Ensure the we won't confused with PV */
> > +	if (xen_domain_type == XEN_PV_DOMAIN)
> > +		return;
> 
> Aren't you specifically testing for xen_domain_type == NATIVE here?  If
> its anything else, then it means we're either PV, or have become an HVM
> domain some other way (like probing for the Xen platform PCI device).

Yes, that's better.

> > +
> > +	r = init_hvm_pv_info();
> > +	if (r<  0)
> > +		return;
> > +
> > +	init_shared_info();
> > +
> > +	xen_hvm_pv_init_irq_ops();
> > +#endif
> > +}
> 
> Can you split all this off into a new file.  It doesn't seem to have any
> dependencies on the rest of enlighten.c, and I've been trying to
> disaggregate it anyway.

Part of pv_ops are overlapped. I would try if a new file would bring much 
duplicate.
 
> > +
> > diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> > index 9d30105..fadaa97 100644
> > --- a/arch/x86/xen/irq.c
> > +++ b/arch/x86/xen/irq.c
> > @@ -131,3 +131,24 @@ void __init xen_init_irq_ops()
> >   	pv_irq_ops = xen_irq_ops;
> >   	x86_init.irqs.intr_init = xen_init_IRQ;
> >   }
> > +
> > +static void xen_hvm_pv_safe_halt(void)
> > +{
> > +	/* Do local_irq_enable() explicitly in hvm_pv guest */
> > +	local_irq_enable();
> > +	xen_safe_halt();
> > +}
> > +
> > +static void xen_hvm_pv_halt(void)
> > +{
> > +	if (irqs_disabled())
> > +		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
> > +	else
> > +		xen_hvm_pv_safe_halt();
> > +}
> > +
> > +void __init xen_hvm_pv_init_irq_ops(void)
> > +{
> > +	pv_irq_ops.safe_halt = xen_hvm_pv_safe_halt;
> > +	pv_irq_ops.halt = xen_hvm_pv_halt;
> > +}
> 
> It would be better to make this patch purely common infrastructure, and
> make specific features (like hvm+pv halt) separate patches (one per patch).

OK. (In fact I merged them in second edition...)
> 
> > diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> > index 1a5ff24..26041ce 100644
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -33,6 +33,12 @@ ENTRY(hypercall_page)
> >   	.skip PAGE_SIZE_asm
> >   .popsection
> >
> > +.pushsection .data
> > +	.align PAGE_SIZE_asm
> > +ENTRY(shared_info_page)
> > +	.skip PAGE_SIZE_asm
> > +.popsection
> 
> Why does this need to be defined in asm?  Can't it be either allocated
> or defined in C?

I think we need a aligned page, as hypercall page.
> 
> > +
> >   	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
> >   	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
> >   	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
> > diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> > index f9153a3..cc00760 100644
> > --- a/arch/x86/xen/xen-ops.h
> > +++ b/arch/x86/xen/xen-ops.h
> > @@ -41,6 +41,7 @@ void xen_vcpu_restore(void);
> >   void __init xen_build_dynamic_phys_to_machine(void);
> >
> >   void xen_init_irq_ops(void);
> > +void xen_hvm_pv_init_irq_ops(void);
> >   void xen_setup_timer(int cpu);
> >   void xen_setup_runstate_info(int cpu);
> >   void xen_teardown_timer(int cpu);
> > diff --git a/include/xen/interface/hvm/hvm_op.h
> > b/include/xen/interface/hvm/hvm_op.h index 7c74ba4..0ce8a26 100644
> > --- a/include/xen/interface/hvm/hvm_op.h
> > +++ b/include/xen/interface/hvm/hvm_op.h
> > @@ -69,4 +69,11 @@
> > DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_set_pci_link_route); /* Flushes all
> > VCPU TLBs: @arg must be NULL. */
> >   #define HVMOP_flush_tlbs          5
> >
> > +#define HVMOP_enable_pv 9
> > +struct xen_hvm_pv_type {
> > +	domid_t domid;
> > +	uint32_t flags;
> > +#define HVM_PV_EVTCHN (1ull<<1)
> > +};
> > +
> >   #endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
> > diff --git a/include/xen/xen.h b/include/xen/xen.h
> > index a164024..9bb92e5 100644
> > --- a/include/xen/xen.h
> > +++ b/include/xen/xen.h
> > @@ -9,6 +9,7 @@ enum xen_domain_type {
> >
> >   #ifdef CONFIG_XEN
> >   extern enum xen_domain_type xen_domain_type;
> > +extern void xen_guest_init(void);
> >   #else
> >   #define xen_domain_type		XEN_NATIVE
> >   #endif
> > @@ -19,6 +20,14 @@ extern enum xen_domain_type xen_domain_type;
> >   #define xen_hvm_domain()	(xen_domain()&&			\
> >   				 xen_domain_type == XEN_HVM_DOMAIN)
> >
> > +#define XEN_HVM_PV_ENABLED	    (1u<<  0)
> 
> Why have this?  We already have xen_domain_type which will either be
> XEN_NATIVE (ie, either real native, or on some fully emulated
> environment we have no specific optimisations for), or XEN_HVM_DOMAIN
> (we know we're running under Xen as an HVM domain).

Something may need to change in pv driver, as I said above.
> 
> > +#define XEN_HVM_PV_EVTCHN_ENABLED   (1u<<  1)
> > +extern u32 xen_hvm_pv_status;
> 
> I think "status" is a misnomer here.  Isn't it specifically a set of PV
> features which are active?

Could you give a suggestion of the name? I am not a native English speaker...
> 
> > +
> > +#define xen_hvm_pv_enabled() (xen_hvm_pv_status&  XEN_HVM_PV_ENABLED)
> > +#define xen_hvm_pv_evtchn_enabled() (xen_hvm_pv_enabled()&&  \
> > +		(xen_hvm_pv_status&  XEN_HVM_PV_EVTCHN_ENABLED))
> 
> Testing for xen_hvm_pv_enabled() should be redundant; surely the
> status/feature flag won't be set unless the environment supports the
> feature, and if it does it doesn't really matter what the domain type is.

Sure

-- 
regards
Yang, Sheng

> > +
> >   #ifdef CONFIG_XEN_DOM0
> >   #include<xen/interface/xen.h>
> >   #include<asm/xen/hypervisor.h>
> 
>      J
> 
