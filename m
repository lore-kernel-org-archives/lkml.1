Return-Path: <linux-kernel-owner+w=401wt.eu-S1751314AbXBMWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbXBMWLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXBMWLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:11:24 -0500
Received: from mother.pmc-sierra.com ([216.241.224.12]:61829 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751314AbXBMWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:11:23 -0500
Message-ID: <45D23785.6060502@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	er
Date: Tue, 13 Feb 2007 14:11:17 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 13 Feb 2007 22:11:18.0467 (UTC) FILETIME=[E2BA0930:01C74FBB]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 12 Feb 2007 12:04:08 -0600 Marc St-Jean 
> <stjeanma@pmc-sierra.com> wrote:
> 
>  > There are three different fixes:
>  > 1. Fix for DesignWare THRE errata
>  > - Dropped our fix since the "8250-uart-backup-timer.patch" in the "mm"
>  > tree also fixes it. This patch needs to be applied on top of "mm" patch.
>  >
>  > 2. Fix for Busy Detect on LCR write
>  > - No changes since last patch.
>  >
>  > 3. Workaround for interrupt/data concurrency issue
>  > - No changes since last patch.
> 
> A couple of things.
> 
> - When preparing a changelog, please just tell us what the patch does.
>   The information about how this patch differes from a previous version of
>   the patch is irrelevant when the patch hits the mainline repository hence
>   I must edit it all.
> 
>   It's OK to add the what-i-changed-since-last-time details, but please 
> make
>   that separate and remember that it will be removed for when the patch 
> goes
>   upstream.
> 
> - When fixing a bug, please tell us in detail what that bug *is*.  None
>   of the above three items tell us any of this, which is essential
>   information for those who are to review the change.

Understood, I'm adding the original description here and I'll add to the
next patch update.

1. Fix for DesignWare APB THRE errata:
In brief, this is a non-standard 16550 in that the THRE interrupt
will not re-assert itself simply by disabling and re-enabling the
THRI bit in the IER, it is only re-enabled if a character is actually
sent out.
It appears that the "8250-uart-backup-timer.patch" in the "mm" tree also
fixes it so we have dropped our initial workaround.
This patch now needs to be applied on top of that "mm" patch.

2. Fix for Busy Detect on LCR write:
The DesignWare APB UART has a feature which causes a new Busy Detect
interrupt to be generated if it's busy when the LCR is written. This
fix saves the value of the LCR and rewrites it after clearing the
interrupt.

3. Workaround for interrupt/data concurrency issue:
The SoC needs to ensure that writes that can cause interrupts to be
cleared reach the UART before returning from the ISR. This fix reads
a non-destructive register on the UART so the read transaction
completion ensures the previously queued write transaction has
also completed.


>  > 
>  > +     case UPIO_DWAPB:
>  > +             /* Save the LCR value so it can be re-written when a
>  > +              * Busy Detect interrupt occurs. */
>  > +             if (save_offset == UART_LCR)
>  > +                     up->lcr = value;
>  > +             writeb(value, up->port.membase + offset);
>  > +             /* Read the IER to ensure any interrupt is cleared before
>  > +              * returning from ISR. */
>  > +             if ((save_offset == UART_TX || save_offset == UART_IER) 
> && in_irq())
> 
> The in_irq() is a worry.  If the serial driver is used as the system
> console, then it can be called from _any_ interrupt handler.  eg a printk()
> in the sata code.
> 
> What happens then?

The in_irq() is there to improve performance. The logic being that
writing to registers outside the interrupt context will not require
the fix for issue 3.
There should be no issues if called from other interrupt context
as the read is non-destructive. I can remove the call to in_irq() if
you prefer.


>  > @@ -1383,6 +1399,19 @@ static irqreturn_t serial8250_interrupt(
>  >                       handled = 1;
>  > 
>  >                       end = NULL;
>  > +             } else if (up->port.iotype == UPIO_DWAPB &&
>  > +                       (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
>  > +                     /* The DesignWare APB UART has an Busy Detect 
> (0x07)
>  > +                      * interrupt meaning an LCR write attempt 
> occured while the
>  > +                      * UART was busy. The interrupt must be cleared 
> by reading
>  > +                      * the UART status register (USR) and the LCR 
> re-written. */
>  > +                     unsigned int status;
>  > +                     status = *(volatile u32 *)up->port.private_data;
> 
> Are you sure this is right?  The use of volatile is generally discouraged
> and is a sign that something is wrong.  What is the driver attempting to
> read here?  Should it be using readl()?

The driver is reading the UART's USR (UART Status Register) which is
a non-standard register at a non-fixed offset, hence the need for
private_data. This was discussed in detail in the patch thread and the
goal was to avoid using platform specific #ifdefs as part of the fix

The register is accessed in kseg1 (unmapped on the mips architecture) so
readl is not needed. The register definitions in this space are all marked
volatile but since it's now accessed through private_data, the read had
to be made explicitly volatile.


> Also, the newly-added private_data field is not being initialised to
> anything anywhere in this patch.

private_data is initialized in the platform specific initialization code
which will be submitted to the l-m.o That patch contains only code which
lives in arch/mips and include/asm-mips so I was not planning on
submitting to the main kernel list. This level of procedural detail is
not in the maillist FAQ, I'm assuming that is normal procedure?

Marc
