Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZIQF6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZIQF6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZIQF6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:58:48 -0400
Received: from mga05.intel.com ([192.55.52.89]:59923 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752616AbZIQF6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,401,1249282800"; 
   d="scan'208";a="494269306"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [RFC][PATCH 09/10] xen/hybrid: Make event channel 
 =?iso-8859-15?q?work=09with_QEmu_emulated?= devices
Date: Thu, 17 Sep 2009 13:58:45 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       Jun Nakajima <jun.nakajima@intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <1253090551-7969-10-git-send-email-sheng@linux.intel.com> <4AB14BFA.4010509@goop.org>
In-Reply-To: <4AB14BFA.4010509@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909171358.46388.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009 04:35:06 Jeremy Fitzhardinge wrote:
> On 09/16/09 01:42, Sheng Yang wrote:
> > We mapped each IOAPIC pin to a VIRQ, so that we can deliver interrupt
> > through these VIRQs.
> >
> > We also use GENERIC_INTERRUPT_VECTOR as the noficiation vector for
> > hypervisor to notify guest about the event.
> >
> > Then we don't need IOAPIC/LAPIC now...
>
> I commented a bit more below, but this patch is pretty unpleasant.  It
> certainly can't be used in this form.

Thanks for the comments. I would try to limit the modification into Xen 
specific files as much as possible.

> > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> > ---
> >  arch/x86/kernel/smpboot.c   |   14 ++++++++++++
> >  arch/x86/xen/enlighten.c    |   49
> > +++++++++++++++++++++++++++++++++++++++++++ arch/x86/xen/irq.c          |
> >   15 +++++++++++-
> >  drivers/xen/events.c        |   47
> > +++++++++++++++++++++++++++++++++++++++++ include/xen/events.h        |  
> >  1 +
> >  include/xen/hvm.h           |    5 ++++
> >  include/xen/interface/xen.h |    6 ++++-
> >  7 files changed, 134 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index 58d24ef..39c1890 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -67,6 +67,10 @@
> >
> >  #include <asm/smpboot_hooks.h>
> >
> > +#ifdef CONFIG_XEN
> > +#include <asm/xen/hypervisor.h>
> > +#endif
> > +
> >  #ifdef CONFIG_X86_32
> >  u8 apicid_2_node[MAX_APICID];
> >  static int low_mappings;
> > @@ -1062,6 +1066,11 @@ void __init native_smp_prepare_cpus(unsigned int
> > max_cpus) }
> >  	set_cpu_sibling_map(0);
> >
> > +#ifdef CONFIG_XEN
> > +	if (xen_hybrid_evtchn_enabled())
> > +		goto out;
> > +#endif
> > +
> >  	enable_IR_x2apic();
> >  #ifdef CONFIG_X86_64
> >  	default_setup_apic_routing();
> > @@ -1131,6 +1140,11 @@ void __init native_smp_cpus_done(unsigned int
> > max_cpus) {
> >  	pr_debug("Boot done.\n");
> >
> > +#ifdef CONFIG_XEN
> > +	if (xen_hybrid_evtchn_enabled())
> > +		return;
> > +#endif
>
> These changes will never fly. I'm aggressively moving away from making
> any Xen-specific changes in core files for dom0; I don't want to add any
> more for a hybrid mode.  (I'd really prefer not to have a hybrid mode at
> all.)

Yes... I would add a pv_ops func for this, though would duplicate the code.
>
> > +
> >  	impress_friends();
> >  #ifdef CONFIG_X86_IO_APIC
> >  	setup_ioapic_dest();
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 18aba22..f515584 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -54,6 +54,10 @@
> >  #include <asm/reboot.h>
> >
> >  #include <xen/hvm.h>
> > +#include <xen/events.h>
> > +#include <asm/acpi.h>
> > +#include <asm/irq_vectors.h>
> > +#include <asm/irq.h>
> >
> >  #include "xen-ops.h"
> >  #include "mmu.h"
> > @@ -1055,6 +1059,8 @@ static void __init xen_hybrid_banner(void)
> >
> >  	if (xen_hybrid_timer_enabled())
> >  		printk(KERN_INFO "Hybrid feature: PV Timer enabled\n");
> > +	if (xen_hybrid_evtchn_enabled())
> > +		printk(KERN_INFO "Hybrid feature: Event channel enabled\n");
> >  }
> >
> >  static int xen_para_available(void)
> > @@ -1102,6 +1108,10 @@ static int init_hybrid_info(void)
> >  		xen_hybrid_status |= XEN_HYBRID_TIMER_ENABLED;
> >  		flags |= HVM_HYBRID_TIMER;
> >  	}
> > +	if (edx & XEN_CPUID_FEAT2_HYBRID_EVTCHN) {
> > +		xen_hybrid_status |= XEN_HYBRID_EVTCHN_ENABLED;
> > +		flags |= HVM_HYBRID_EVTCHN;
> > +	}
> >
> >  	/* We only support 1 page of hypercall for now */
> >  	if (pages != 1)
> > @@ -1144,9 +1154,27 @@ static int __init init_shared_info(void)
> >  	return 0;
> >  }
> >
> > +static int set_callback_via(uint64_t via)
> > +{
> > +	struct xen_hvm_param a;
> > +
> > +	a.domid = DOMID_SELF;
> > +	a.index = HVM_PARAM_CALLBACK_IRQ;
> > +	a.value = via;
> > +	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
> > +}
> > +
> > +void do_hybrid_intr(void)
> > +{
> > +	per_cpu(irq_count, smp_processor_id())++;
> > +	xen_evtchn_do_upcall(get_irq_regs());
> > +	per_cpu(irq_count, smp_processor_id())--;
> > +}
> > +
> >  void __init xen_start_hybrid(void)
> >  {
> >  	int r;
> > +	uint64_t callback_via;
> >
> >  	if (!xen_para_available())
> >  		return;
> > @@ -1163,5 +1191,26 @@ void __init xen_start_hybrid(void)
> >  		pv_time_ops = xen_time_ops;
> >  		pv_apic_ops = xen_apic_ops;
> >  	}
> > +
> > +	if (xen_hybrid_evtchn_enabled()) {
> > +		pv_apic_ops = xen_apic_ops;
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +		/*
> > +		 * set up the basic apic ops.
> > +		 */
> > +		set_xen_basic_apic_ops();
> > +#endif
> > +
> > +		callback_via = HVM_CALLBACK_VECTOR(GENERIC_INTERRUPT_VECTOR);
> > +		set_callback_via(callback_via);
> > +
> > +		generic_interrupt_extension = do_hybrid_intr;
> > +
> > +		disable_acpi();
> > +		disable_apic = 1;
> > +
> > +		machine_ops = xen_machine_ops;
> > +		smp_ops.smp_send_stop = paravirt_nop;
> > +	}
> >  }
> >
> > diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> > index 52885c1..edca1c4 100644
> > --- a/arch/x86/xen/irq.c
> > +++ b/arch/x86/xen/irq.c
> > @@ -66,6 +66,9 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_restore_fl);
> >
> >  static void xen_irq_disable(void)
> >  {
> > +	if (xen_hybrid_evtchn_enabled())
> > +		asm volatile("cli" : : : "memory");
>
> !!! We have pvops for a reason.  If you want to override irq_disable,
> define a new pvop function.

OK. (I just think it's inside Xen file, and code is somehow duplicated...)

-- 
regards
Yang, Sheng

>
>     J


