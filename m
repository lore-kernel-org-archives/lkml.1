Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0CHRHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:07:04 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:57536 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0CHRGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:06:55 -0500
X-IronPort-AV: E=Sophos;i="4.49,603,1262563200"; 
   d="scan'208";a="9839673"
Date: Mon, 8 Mar 2010 17:10:56 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension
 of HVM
In-Reply-To: <1268032732-8025-8-git-send-email-sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1003081701160.16237@kaball-desktop>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <1268032732-8025-8-git-send-email-sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that mapping interrupts into VIRQs is a bad idea: you should map
interrupts into pirqs instead, the code exists already on the kernel
side so we don't need to do any (ugly) change there.
Look at xen_setup_pirqs() to get an idea about how it works, in my patch
series enabling pirq\interrupt mappings is basically a one line change.
Besides pirqs and interrupts can coexist without problems and even make
pv on hvm work out of the box.

Even though you don't seem interested, I am still open on collaborating
with you to complete this patch series.

On Mon, 8 Mar 2010, Sheng Yang wrote:
> @@ -944,3 +958,51 @@ void __init xen_init_IRQ(void)
> 
>         irq_ctx_init(smp_processor_id());
>  }
> +
> +void __init xen_hvm_pv_evtchn_init_IRQ(void)
> +{
> +       int i;
> +
> +       xen_init_IRQ();
> +       for (i = 0; i < NR_IRQS_LEGACY; i++) {
> +               struct evtchn_bind_virq bind_virq;
> +               struct irq_desc *desc = irq_to_desc(i);
> +               int virq, evtchn;
> +
> +               virq = i + VIRQ_EMUL_PIN_START;
> +               bind_virq.virq = virq;
> +               bind_virq.vcpu = 0;
> +
> +               if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
> +                                               &bind_virq) != 0)
> +                       BUG();
> +
> +               evtchn = bind_virq.port;
> +               evtchn_to_irq[evtchn] = i;
> +               irq_info[i] = mk_virq_info(evtchn, virq);
> +
> +               desc->status = IRQ_DISABLED;
> +               desc->action = NULL;
> +               desc->depth = 1;
> +
> +               /*
> +                * 16 old-style INTA-cycle interrupts:
> +                */
> +               set_irq_chip_and_handler_name(i, &xen_dynamic_chip,
> +                                       handle_level_irq, "event");
> +       }
> +
> +       /*
> +        * Cover the whole vector space, no vector can escape
> +        * us. (some of these will be overridden and become
> +        * 'special' SMP interrupts)
> +        */
> +       for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
> +               int vector = FIRST_EXTERNAL_VECTOR + i;
> +               if (vector != IA32_SYSCALL_VECTOR)
> +                       set_intr_gate(vector, interrupt[i]);
> +       }
> +
> +       /* generic IPI for platform specific use, now used for HVM evtchn */
> +       alloc_intr_gate(X86_PLATFORM_IPI_VECTOR, x86_platform_ipi);
> +}

