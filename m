Return-Path: <linux-kernel-owner+w=401wt.eu-S965500AbXAWWhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965500AbXAWWhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965509AbXAWWhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:37:36 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:36260 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965502AbXAWWhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:37:34 -0500
Message-ID: <45B68E23.7080800@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	er
Date: Tue, 23 Jan 2007 14:37:23 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 23 Jan 2007 22:37:24.0032 (UTC) FILETIME=[0D338C00:01C73F3F]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alan wrote:
>  > There are three different fixes:
>  > 1. Fix for THRE errata
> 
> That should be handled anyway. The current code actually spots this and
> uses a backup timer for dodgy UARTS

Thanks, I'll retest without this fix on the current l-m.o git master and see
if it still solves our errata.

>  > 2. Fix for Busy Detect on LCR write
>  > 3. Workaround for interrupt/data concurrency issue
> 
>  >       case UPIO_MEM:
>  > +#ifdef CONFIG_PMC_MSP
>  > +             /* Save the LCR value so it can be re-written when a
>  > +              * Busy Detect interrupt occurs. */
>  > +             if (dwapb_offset == UART_LCR)
>  > +                     up->dwapb_lcr = value;
>  > +#endif
>  >               writeb(value, up->port.membase + offset);
>  > +#ifdef CONFIG_PMC_MSP
>  > +             /* Re-read the IER to ensure any interrupt disabling has
>  > +              * completed before proceeding with ISR. */
>  > +             if (dwapb_offset == UART_IER)
>  > +                     value = serial_in(up, dwapb_offset);
>  > +#endif
>  >               break;
> 
> This I would hope you can hide in the platform specific
> serial_in/serial_out functions. If you write the UART_LCR save it in
> serial_out(), if you read IER etc.

I couldn't find hooks for platform specific serial_in/out functions.
Do you mean using the up->port.iotype's in serial_in/out from 8250.c?

> 
>  > +#ifdef CONFIG_PMC_MSP
>  > +             } else if ((iir & UART_IER_BUSY) == UART_IER_BUSY) {
>  > +                     /*
>  > +                      * The MSP (DesignWare APB UART) serial 
> subsystem has a
>  > +                      * non-standard interrupt condition (0x7) which 
> means
>  > +                      * that the LCR was written while the UART was 
> busy, so
>  > +                      * the LCR was not actually written.  It is 
> cleared by
>  > +                      * reading the special non-standard extended 
> UART status
>  > +                      * register.
> 
> Ditto... spot this case and whack it in your serial methods.

A serial_in(up, UART_IIR) calls occur in more places that just the interrupt
handler (i.e. autoconfig*, serial8250_start_tx, etc). We will need to check
if we are in an interrupt on each IIR read, hopefully that won't be too much
overhead!

> 
> And we might want to add a void * for board specific insanity to the 8250
> structures if we really have to so you can hang your brain damage
> privately off that ?

Sounds good to me, it would give us a location to store the address of the
UART_STATUS_REG required by this UART variant.

Marc
