Return-Path: <linux-kernel-owner+w=401wt.eu-S1422732AbXBGUvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422732AbXBGUvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 15:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422734AbXBGUvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 15:51:09 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:55077 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422695AbXBGUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 15:51:06 -0500
Message-ID: <45CA3BAF.8070905@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	er
Date: Wed, 7 Feb 2007 12:50:55 -0800 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 07 Feb 2007 20:50:56.0183 (UTC) FILETIME=[A9F16470:01C74AF9]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Marc St-Jean wrote:
>  > Third attempt at the serial driver patch for the PMC-Sierra MSP71xx 
> device.
>  >
>  > There are three different fixes:
>  > 1. Fix for DesignWare THRE errata
>  > - Dropped our fix since the "8250-uart-backup-timer.patch" in the "mm"
>  > tree also fixes it. This patch needs to be applied on top of it.
>  >
>  > 2. Fix for Busy Detect on LCR write
>  > - Dropped the addition of UPIO_DWAPB iotype to 8250_early.c as Sergei
>  > pointed out the fix wasn't complete and we don't require it.
>  >
>  > 3. Workaround for interrupt/data concurrency issue
>  > - Fix must remain serial8250_interrupt() in order to mark interrupt as
>  > handled.
>  >
>  > Thanks,
>  > Marc
>  >
>  > Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
>  >
>  > diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
...
>  >               break;
>  > @@ -1383,6 +1399,19 @@ static irqreturn_t serial8250_interrupt(
>  >                       handled = 1;
>  >
>  >                       end = NULL;
>  > +             } else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY &&
>  > +                             up->port.iotype == UPIO_DWAPB) {
> 
>     Makes sense to swap the checks, i.e. to only test for UART_IIR_BUSY is
> this is UPIO_DWAPB.

I had left in the other order for readability with the previous test.
I agree this will save a few cycles so I've reordered.


> [...]
> 
>  > @@ -2454,9 +2485,12 @@ int __init serial8250_start_console(stru
>  >
>  >       add_preferred_console("ttyS", line, options);
>  >       printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
>  > -             line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
>  > -             port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
>  > -                 (unsigned long) port->iobase, options);
>  > +             line,
>  > +             (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>  > +                     ? "MMIO" : "I/O port",
>  > +             (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>  > +                     ? (unsigned long) port->mapbase : (unsigned 
> long) port->iobase,
>  > +             options);
> 
>     Please turn this check into port->iotype >= UPIO_MEM, since this 
> would be
> the Right Thing (RM).  All iotypes beyond UPIO_MEM are memory mapped.  
> And I
> thought I fixed that -- was wrong, obviously... :-/

This is news to me, I thought the numbering was of no particular importance.
I've made the change.


>  > diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
>  > index 3c8a6aa..b3550cc 100644
>  > --- a/include/linux/serial_reg.h
>  > +++ b/include/linux/serial_reg.h
>  > @@ -37,6 +37,7 @@ #define UART_IIR_MSI                0x00 /* Modem stat
>  >   #define UART_IIR_THRI               0x02 /* Transmitter holding 
> register empty */
>  >   #define UART_IIR_RDI                0x04 /* Receiver data interrupt */
>  >   #define UART_IIR_RLSI               0x06 /* Receiver line status 
> interrupt */
>  > +#define UART_IIR_BUSY                0x07 /* DesignWare APB Busy 
> Detect */
> 
>     Alan already said about this one... :-)

Yes, changed.

>     BTW, your patches are still corrupt by your mailer (space added to 
> lines
> starting with space)

Argh! There were no spaces in the message window before sending, I swear!
I've solved the problem for the next patch.

Marc
