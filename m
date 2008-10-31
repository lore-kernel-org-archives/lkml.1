Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYJaWCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYJaWCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 18:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJaWCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 18:02:24 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37913 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbYJaWCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 18:02:23 -0400
Subject: Re: [PATCH] fix compile breakage caused by
	2ae111cdd8d83ebf9de72e36e68a8c84b6ebbeea
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <aa79d98a0810302315k760ce8e1q1eab3d0c2258baae@mail.gmail.com>
References: <1225400664.19324.16.camel@localhost.localdomain>
	 <20081030220653.GK30303@elte.hu>
	 <aa79d98a0810302228x62519bfes5f68a6b6bfbd10a3@mail.gmail.com>
	 <aa79d98a0810302315k760ce8e1q1eab3d0c2258baae@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 12:46:00 -0500
Message-Id: <1225475160.3264.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 09:15 +0300, Cyrill Gorcunov wrote:
> On Fri, Oct 31, 2008 at 8:28 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Fri, Oct 31, 2008 at 1:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>
> >>> >From bd011c0cc51ce1fbab95403a570a8b47ad6ba500 Mon Sep 17 00:00:00 2001
> >>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>> Date: Wed, 29 Oct 2008 11:19:49 -0500
> >>> Subject: [VOYAGER] x86: Fix subarch compile breakage
> >>>
> >>> commit 2ae111cdd8d83ebf9de72e36e68a8c84b6ebbeea
> >>> Author: Cyrill Gorcunov <gorcunov@gmail.com>
> >>> Date:   Mon Aug 11 18:34:08 2008 +0400
> >>>
> >>>     x86: apic interrupts - move assignments to irqinit_32.c, v2
> >>>
> >>> Wrongly moved irq2 setup out of the mach-default/setup.c file.  This
> >>> causes a breakage on voyager which needs its own version.  Fix by
> >>> moving it back again.
> >>>
> >>> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>> ---
> >>>  arch/x86/kernel/irqinit_32.c  |   12 ------------
> >>>  arch/x86/mach-default/setup.c |   12 ++++++++++++
> >>>  2 files changed, 12 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
> >>> index 845aa98..3928784 100644
> >>> --- a/arch/x86/kernel/irqinit_32.c
> >>> +++ b/arch/x86/kernel/irqinit_32.c
> >>> @@ -81,15 +81,6 @@ void __init init_ISA_irqs (void)
> >>>       }
> >>>  }
> >>>
> >>> -/*
> >>> - * IRQ2 is cascade interrupt to second interrupt controller
> >>> - */
> >>> -static struct irqaction irq2 = {
> >>> -     .handler = no_action,
> >>> -     .mask = CPU_MASK_NONE,
> >>> -     .name = "cascade",
> >>> -};
> >>> -
> >>>  DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
> >>>       [0 ... IRQ0_VECTOR - 1] = -1,
> >>>       [IRQ0_VECTOR] = 0,
> >>> @@ -167,9 +158,6 @@ void __init native_init_IRQ(void)
> >>>       alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
> >>>  #endif
> >>>
> >>> -     if (!acpi_ioapic)
> >>> -             setup_irq(2, &irq2);
> >>> -
> >>>       /* setup after call gates are initialised (usually add in
> >>>        * the architecture specific gates)
> >>>        */
> >>> diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
> >>> index 37b9ae4..53b4202 100644
> >>> --- a/arch/x86/mach-default/setup.c
> >>> +++ b/arch/x86/mach-default/setup.c
> >>> @@ -38,6 +38,15 @@ void __init pre_intr_init_hook(void)
> >>>       init_ISA_irqs();
> >>>  }
> >>>
> >>> +/*
> >>> + * IRQ2 is cascade interrupt to second interrupt controller
> >>> + */
> >>> +static struct irqaction irq2 = {
> >>> +     .handler = no_action,
> >>> +     .mask = CPU_MASK_NONE,
> >>> +     .name = "cascade",
> >>> +};
> >>> +
> >>>  /**
> >>>   * intr_init_hook - post gate setup interrupt initialisation
> >>>   *
> >>> @@ -53,6 +62,9 @@ void __init intr_init_hook(void)
> >>>               if (x86_quirks->arch_intr_init())
> >>>                       return;
> >>>       }
> >>> +     if (!acpi_ioapic)
> >>> +             setup_irq(2, &irq2);
> >>> +
> >>>  }
> >>
> >> hm, this change looks backwards (doubly so ;-).
> >>
> >> Is the build problem caused by the lack of the acpi_ioapic flag on
> >> Voyager?
> >>
> >>        Ingo
> >>
> >
> > Thanks for report, cant get access to sources right now -- will check it later.
> >
> 
> Btw James, what the build bug message was? Could you post it please?

it gives a compile failure because acpi_ioapic isn't defined on
Voyager ... however voyager also currently has its own setup for irq2
which would need to be fixed as well.

James


