Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0COBqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:46:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:36237 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab0COBqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:46:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,639,1262592000"; 
   d="scan'208";a="604362567"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM initialization
Date: Mon, 15 Mar 2010 09:45:09 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com> <1268362647-5317-5-git-send-email-sheng@linux.intel.com> <4B9AA5A9.20609@goop.org>
In-Reply-To: <4B9AA5A9.20609@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003150945.09548.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 March 2010 04:35:53 Jeremy Fitzhardinge wrote:
> On 03/11/2010 06:57 PM, Sheng Yang wrote:
> > The PV extended HVM(once known as Hybrid) is started from real mode like
> > HVM guest, but also with a component based PV feature selection(e.g. PV
> > halt, PV timer, event channel, then PV drivers). So guest can takes the
> > advantages of both H/W virtualization and Para-Virtualization.
> >
> > This patch introduced the PV extension of HVM guest initialization.
> >
> > Guest would detect the capability using CPUID 0x40000002.edx, then call
> > HVMOP_enable_pv hypercall to enable pv support in hypervisor.
> >
> > Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> > Signed-off-by: Yaozu (Eddie) Dong<eddie.dong@intel.com>
> > ---
> >   arch/x86/include/asm/xen/cpuid.h      |    5 +
> >   arch/x86/include/asm/xen/hypervisor.h |   12 +++
> >   arch/x86/xen/Kconfig                  |    4 +
> >   arch/x86/xen/Makefile                 |    1 +
> >   arch/x86/xen/hvmpv.c                  |  135
> > +++++++++++++++++++++++++++++++++ include/xen/interface/hvm/hvm_op.h    |
> >    8 ++
> >   6 files changed, 165 insertions(+), 0 deletions(-)
> >   create mode 100644 arch/x86/xen/hvmpv.c
> >
> > diff --git a/arch/x86/include/asm/xen/cpuid.h
> > b/arch/x86/include/asm/xen/cpuid.h index 8787f03..b3a0b3a 100644
> > --- a/arch/x86/include/asm/xen/cpuid.h
> > +++ b/arch/x86/include/asm/xen/cpuid.h
> > @@ -65,4 +65,9 @@
> >   #define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
> >   #define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
> >
> > +#define _XEN_CPUID_FEAT2_HVM_PV 0
> > +#define XEN_CPUID_FEAT2_HVM_PV (1u<<0)
> > +#define _XEN_CPUID_FEAT2_HVM_PV_CLOCK 1
> > +#define XEN_CPUID_FEAT2_HVM_PV_CLOCK (1u<<1)
> > +
> >   #endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
> > diff --git a/arch/x86/include/asm/xen/hypervisor.h
> > b/arch/x86/include/asm/xen/hypervisor.h index d5b7e90..7569f64 100644
> > --- a/arch/x86/include/asm/xen/hypervisor.h
> > +++ b/arch/x86/include/asm/xen/hypervisor.h
> > @@ -55,6 +55,18 @@ extern enum xen_domain_type xen_domain_type;
> >   #define xen_hvm_domain()	(xen_domain()&&			\
> >   				 xen_domain_type == XEN_HVM_DOMAIN)
> >
> > +#ifdef CONFIG_XEN_HVM_PV
> > +
> > +#define XEN_HVM_PV_CLOCK_ENABLED   (1u<<  0)
> 
> Why is this flag needed?  As far as I understand it, there's no real
> underlying hypervisor change needed to make HVM access to pv clock
> possible; its just a field in the shared_info's vcpu struct after all.
> Even if you enable this feature unconditionally, the user can still
> control whether the Xen clocksource is used with the "clocksource="
> kernel command-line parameter.

But we should make sure Xen have ability to support such kind of operation. 
The CPUID would show if Xen have such ability, and if it does, the feature 
would be enabled unconditionally. Guest kernel always enable all features it 
can do unconditionally, but Xen should offer the support for them.
 
> Also, there's nothing about this which is 64-bit specific is there?

64 bit things are mostly evtchn/interrupt related. I think no such limit here. 
But I think it's better to do it step by step, so leave it after evtchn 
solution settled.

-- 
regards
Yang, Sheng
