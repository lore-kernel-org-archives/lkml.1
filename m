Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0CDOea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:34:30 -0500
Received: from www.tglx.de ([62.245.132.106]:57969 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab0CDOe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:34:28 -0500
Date: Thu, 4 Mar 2010 15:31:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
In-Reply-To: <1267697339-5491-7-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org> <1267697339-5491-7-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Yinghai Lu wrote:

>  /*
>   * Fixup enable/disable function pointers
>   */
>  void irq_chip_set_defaults(struct irq_chip *chip)
>  {
> +	if (!chip->desc_enable)
> +		chip->desc_enable = default_enable_desc;
> +	if (!chip->desc_disable)
> +		chip->desc_disable = default_disable_desc;
> +	if (!chip->desc_startup)
> +		chip->desc_startup = default_startup_desc;

  This will break all irq_chips which implement enable, disable or
  startup. so the check needs to be:

  	   if (!chip->enable && !chip->desc_enable) 

> +	/*
> +	 * We use chip->disable, when the user provided its own. When
> +	 * we have default_disable set for chip->disable, then we need
> +	 * to use default_shutdown, otherwise the irq line is not
> +	 * disabled on free_irq():
> +	 */
> +	if (!chip->desc_shutdown)
> +		chip->desc_shutdown = chip->desc_disable != default_disable_desc ?
> +			chip->desc_disable : default_shutdown_desc;
> +	if (!chip->desc_end)
> +		chip->desc_end = dummy_irq_chip.desc_end;

  Same  here.

> @@ -295,10 +295,14 @@ void clear_kstat_irqs(struct irq_desc *desc)
>  static void ack_bad(unsigned int irq)

  Why do we keep that function around ?

>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
> -
> -	print_irq_desc(irq, desc);
> +	print_irq_desc(desc);
>  	ack_bad_irq(irq);
>  }

  
>  /*
>   * Generic no controller implementation
> @@ -323,6 +334,13 @@ struct irq_chip no_irq_chip = {
>  	.disable	= noop,
>  	.ack		= ack_bad,
>  	.end		= noop,

  We can remove the old ones right away, can't we ?

> diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c

Yinghai, thanks for doing that. It's halfways reviewable now, but if
we go that way it needs to be split further, really.

But to be honest I have to say that the code churn of that patch
scares me. I expected it to be less horrible.

So I started twisting my brain around a fully automated method of
solving this conversion problem with almost zero risk. It just occured
to me that Julia might be able to help and whip up semantic patch
rules for doing the conversion automagically on a flag day. That would
be one rule and one resulting patch for each of the chip->functions.

So the task would be:

In include/linux/irq.h

  struct irq_chip {
        const char      *name;
- 	unsigned int    startup(unsigned int irq);
+ 	unsigned int    startup(struct irq_desc *desc);

Then finding all irq_chip implementations which set that function
pointer and fix up the function e.g.:

arch/x86/kernel/apic/io_apic.c: 

static struct irq_chip ioapic_chip __read_mostly = {
        .name           = "IO-APIC",
        .startup        = startup_ioapic_irq,

-->

-static unsigned int startup_ioapic_irq(unsigned int irq)
+static unsigned int startup_ioapic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
        int was_pending = 0;
        unsigned long flags;
        struct irq_cfg *cfg;

        raw_spin_lock_irqsave(&ioapic_lock, flags);
...

To make it simple, we just can put that right after the opening
bracket of the function.

The code which uses the chip functions needs to be changed:

-	desc->chip->fun(irq);
+	desc->chip->fun(desc);

That's mostly in kernel/irq/* but there are some users in arch/*
lowlevel irq handling code as well.

I have not yet checked whether some place set's the function pointers
in the code rather than doing it in the struct definition statically,
but the vast majority should be static initializers.

Julia, can this be done with the semantic patcher magic or are you
already running away screaming ?

Thanks,

	tglx
