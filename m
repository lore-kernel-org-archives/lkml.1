Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0CEHrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:47:40 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:35269 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab0CEHri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:47:38 -0500
Date: Fri, 5 Mar 2010 08:47:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
In-Reply-To: <4B900250.8020100@kernel.org>
Message-ID: <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
 <1267697339-5491-7-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will look at it tomorrow.

julia


On Thu, 4 Mar 2010, Yinghai Lu wrote:

> On 03/04/2010 06:31 AM, Thomas Gleixner wrote:
> > On Thu, 4 Mar 2010, Yinghai Lu wrote:
> > 
> >>  /*
> >>   * Fixup enable/disable function pointers
> >>   */
> >>  void irq_chip_set_defaults(struct irq_chip *chip)
> >>  {
> >> +	if (!chip->desc_enable)
> >> +		chip->desc_enable = default_enable_desc;
> >> +	if (!chip->desc_disable)
> >> +		chip->desc_disable = default_disable_desc;
> >> +	if (!chip->desc_startup)
> >> +		chip->desc_startup = default_startup_desc;
> > 
> >   This will break all irq_chips which implement enable, disable or
> >   startup. so the check needs to be:
> > 
> >   	   if (!chip->enable && !chip->desc_enable) 
> yes.
> > 
> >> +	/*
> >> +	 * We use chip->disable, when the user provided its own. When
> >> +	 * we have default_disable set for chip->disable, then we need
> >> +	 * to use default_shutdown, otherwise the irq line is not
> >> +	 * disabled on free_irq():
> >> +	 */
> >> +	if (!chip->desc_shutdown)
> >> +		chip->desc_shutdown = chip->desc_disable != default_disable_desc ?
> >> +			chip->desc_disable : default_shutdown_desc;
> >> +	if (!chip->desc_end)
> >> +		chip->desc_end = dummy_irq_chip.desc_end;
> > 
> >   Same  here.
> > 
> >> @@ -295,10 +295,14 @@ void clear_kstat_irqs(struct irq_desc *desc)
> >>  static void ack_bad(unsigned int irq)
> > 
> >   Why do we keep that function around ?
> 
> that is for other arch...
> 
> /*
>  * Generic no controller implementation
>  */
> struct irq_chip no_irq_chip = {
>         .name           = "none",
>         .startup        = noop_ret,
>         .shutdown       = noop,
>         .enable         = noop,
>         .disable        = noop,
>         .ack            = ack_bad,
>         .end            = noop,
> 
>         .desc_startup   = noop_ret_desc,
>         .desc_shutdown  = noop_desc,
>         .desc_enable    = noop_desc,
>         .desc_disable   = noop_desc,
>         .desc_ack       = ack_bad_desc,
>         .desc_end       = noop_desc,
> };
> 
> 
> > 
> >>  {
> >>  	struct irq_desc *desc = irq_to_desc(irq);
> >> -
> >> -	print_irq_desc(irq, desc);
> >> +	print_irq_desc(desc);
> >>  	ack_bad_irq(irq);
> >>  }
> > 
> >   
> >>  /*
> >>   * Generic no controller implementation
> >> @@ -323,6 +334,13 @@ struct irq_chip no_irq_chip = {
> >>  	.disable	= noop,
> >>  	.ack		= ack_bad,
> >>  	.end		= noop,
> > 
> >   We can remove the old ones right away, can't we ?
> > 
> >> diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
> > 
> > Yinghai, thanks for doing that. It's halfways reviewable now, but if
> > we go that way it needs to be split further, really.
> > 
> > But to be honest I have to say that the code churn of that patch
> > scares me. I expected it to be less horrible.
> > 
> > So I started twisting my brain around a fully automated method of
> > solving this conversion problem with almost zero risk. It just occured
> > to me that Julia might be able to help and whip up semantic patch
> > rules for doing the conversion automagically on a flag day. That would
> > be one rule and one resulting patch for each of the chip->functions.
> > 
> > So the task would be:
> > 
> > In include/linux/irq.h
> > 
> >   struct irq_chip {
> >         const char      *name;
> > - 	unsigned int    startup(unsigned int irq);
> > + 	unsigned int    startup(struct irq_desc *desc);
> > 
> > Then finding all irq_chip implementations which set that function
> > pointer and fix up the function e.g.:
> > 
> > arch/x86/kernel/apic/io_apic.c: 
> > 
> > static struct irq_chip ioapic_chip __read_mostly = {
> >         .name           = "IO-APIC",
> >         .startup        = startup_ioapic_irq,
> > 
> > -->
> > 
> > -static unsigned int startup_ioapic_irq(unsigned int irq)
> > +static unsigned int startup_ioapic_irq(struct irq_desc *desc)
> >  {
> > +	unsigned int irq = desc->irq;
> >         int was_pending = 0;
> >         unsigned long flags;
> >         struct irq_cfg *cfg;
> > 
> >         raw_spin_lock_irqsave(&ioapic_lock, flags);
> > ...
> > 
> > To make it simple, we just can put that right after the opening
> > bracket of the function.
> > 
> > The code which uses the chip functions needs to be changed:
> > 
> > -	desc->chip->fun(irq);
> > +	desc->chip->fun(desc);
> > 
> > That's mostly in kernel/irq/* but there are some users in arch/*
> > lowlevel irq handling code as well.
> 
> that is our -v2 version.
> 
> YH
> 
