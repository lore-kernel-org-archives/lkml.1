Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0CIBwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:52:17 -0500
Received: from mga12.intel.com ([143.182.124.36]:4278 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756495Ab0CIBwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:52:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,605,1262592000"; 
   d="scan'208";a="252346510"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension of HVM
Date: Tue, 9 Mar 2010 09:53:16 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <1268032732-8025-8-git-send-email-sheng@linux.intel.com> <alpine.DEB.2.00.1003081701160.16237@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003081701160.16237@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003090953.16985.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010 01:10:56 Stefano Stabellini wrote:
> I think that mapping interrupts into VIRQs is a bad idea: you should map
> interrupts into pirqs instead, the code exists already on the kernel
> side so we don't need to do any (ugly) change ther.

The code existed in the pv_ops dom0 side, but not in the upstream Linux. The 
latter is our target. We want this work to be accepted by upstream Linux soon.

Thanks.

-- 
regards
Yang, Sheng

> Look at xen_setup_pirqs() to get an idea about how it works, in my patch
> series enabling pirq\interrupt mappings is basically a one line change.
> Besides pirqs and interrupts can coexist without problems and even make
> pv on hvm work out of the box.
> 
> Even though you don't seem interested, I am still open on collaborating
> with you to complete this patch series.
> 
> On Mon, 8 Mar 2010, Sheng Yang wrote:
> > @@ -944,3 +958,51 @@ void __init xen_init_IRQ(void)
> >
> >         irq_ctx_init(smp_processor_id());
> >  }
> > +
> > +void __init xen_hvm_pv_evtchn_init_IRQ(void)
> > +{
> > +       int i;
> > +
> > +       xen_init_IRQ();
> > +       for (i = 0; i < NR_IRQS_LEGACY; i++) {
> > +               struct evtchn_bind_virq bind_virq;
> > +               struct irq_desc *desc = irq_to_desc(i);
> > +               int virq, evtchn;
> > +
> > +               virq = i + VIRQ_EMUL_PIN_START;
> > +               bind_virq.virq = virq;
> > +               bind_virq.vcpu = 0;
> > +
> > +               if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
> > +                                               &bind_virq) != 0)
> > +                       BUG();
> > +
> > +               evtchn = bind_virq.port;
> > +               evtchn_to_irq[evtchn] = i;
> > +               irq_info[i] = mk_virq_info(evtchn, virq);
> > +
> > +               desc->status = IRQ_DISABLED;
> > +               desc->action = NULL;
> > +               desc->depth = 1;
> > +
> > +               /*
> > +                * 16 old-style INTA-cycle interrupts:
> > +                */
> > +               set_irq_chip_and_handler_name(i, &xen_dynamic_chip,
> > +                                       handle_level_irq, "event");
> > +       }
> > +
> > +       /*
> > +        * Cover the whole vector space, no vector can escape
> > +        * us. (some of these will be overridden and become
> > +        * 'special' SMP interrupts)
> > +        */
> > +       for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
> > +               int vector = FIRST_EXTERNAL_VECTOR + i;
> > +               if (vector != IA32_SYSCALL_VECTOR)
> > +                       set_intr_gate(vector, interrupt[i]);
> > +       }
> > +
> > +       /* generic IPI for platform specific use, now used for HVM evtchn
> > */ +       alloc_intr_gate(X86_PLATFORM_IPI_VECTOR, x86_platform_ipi); +}
> 
