Return-Path: <linux-kernel-owner+w=401wt.eu-S1031540AbXHMO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031540AbXHMO0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759760AbXHML1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:27:44 -0400
Received: from mx10.go2.pl ([193.17.41.74]:57096 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967257AbXHML1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:27:39 -0400
Date: Mon, 13 Aug 2007 13:28:21 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid resend
Message-ID: <20070813112821.GA2863@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de> <20070812152303.177006193@inhelltoy.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812152303.177006193@inhelltoy.tec.linutronix.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 03:46:36PM -0000, Thomas Gleixner wrote:
> Level type interrupts do not need to be resent. It was also found that
> some chipsets get confused in case of the resend. 

IMHO, it's still not proven the chipsets are to blame here
(plus read below).

> 
> Mark the ioapic level type interrupts as such to avoid the resend
> functionality in the generic irq code.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  arch/i386/kernel/io_apic.c   |    7 +++++--
>  arch/x86_64/kernel/io_apic.c |    7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/arch/i386/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/i386/kernel/io_apic.c	2007-08-11 11:09:11.000000000 +0200
> +++ linux-2.6/arch/i386/kernel/io_apic.c	2007-08-11 11:09:12.000000000 +0200
> @@ -1256,12 +1256,15 @@ static struct irq_chip ioapic_chip;
>  static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
>  {
>  	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
> -			trigger == IOAPIC_LEVEL)
> +	    trigger == IOAPIC_LEVEL) {
> +		irq_desc[irq].status |= IRQ_LEVEL;
>  		set_irq_chip_and_handler_name(irq, &ioapic_chip,
>  					 handle_fasteoi_irq, "fasteoi");
> -	else
> +	} else {
> +		irq_desc[irq].status &= ~IRQ_LEVEL;
>  		set_irq_chip_and_handler_name(irq, &ioapic_chip,
>  					 handle_edge_irq, "edge");
> +	}
>  	set_intr_gate(vector, interrupt[irq]);
>  }
>  
> Index: linux-2.6/arch/x86_64/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86_64/kernel/io_apic.c	2007-08-11 11:09:11.000000000 +0200
> +++ linux-2.6/arch/x86_64/kernel/io_apic.c	2007-08-11 11:09:12.000000000 +0200
> @@ -800,12 +800,15 @@ static struct irq_chip ioapic_chip;
>  
>  static void ioapic_register_intr(int irq, unsigned long trigger)
>  {
> -	if (trigger)
> +	if (trigger) {
> +		irq_desc[irq].status |= IRQ_LEVEL;
>  		set_irq_chip_and_handler_name(irq, &ioapic_chip,
>  					      handle_fasteoi_irq, "fasteoi");
> -	else
> +	} else {
> +		irq_desc[irq].status &= ~IRQ_LEVEL;
>  		set_irq_chip_and_handler_name(irq, &ioapic_chip,
>  					      handle_edge_irq, "edge");
> +	}
>  }
>  
>  static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
> 
> -- 
> 

Maybe I miss something, but:
- why it's not done in other places with handle_level_irq or
handle_fasteoi_irq. Are we sure they can never get IRQ_PENDING flag
or we take the risk?
- what about e.g. handle_simple_irq: do we think it needs resending
or simply going to wait for good bug reports?
- is this .status cleared enough on free_irq or during request_irq?

BTW, of course something like this set of patches was needed here,
but I still think this shouldn't be done this way: the bug wasn't
diagnosed nor tested enough, some chips are suspected, and
nevertheless the change is done for everybody, whithout any
possibility to set this back for people who had no problems with
2.6.21 and 2.6.22 (at least for some transition time). Maybe some
other chips get confused now, and we get some notice of this maybe
only in 2.6.25, if we'are lucky enough to have somebody like Marcin
around to do the next git bisection?

Regards,
Jarek P.
