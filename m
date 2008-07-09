Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYGIT37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYGIT37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYGIT3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:29:51 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:3315 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751272AbYGIT3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:29:50 -0400
Date: Wed, 9 Jul 2008 23:29:43 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2] serial: 8250: fix shared interrupts issues with SMP
	and RT kernels
Message-ID: <20080709192943.GA12278@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623232957.GA5111@polina.dev.rtsoft.ru> <20080624001221.GA20685@elte.hu> <20080701134343.GA1865@polina.dev.rtsoft.ru> <20080701144353.7285805d@lxorguk.ukuu.org.uk> <20080701150254.GA13390@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080701150254.GA13390@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 07:02:54PM +0400, Anton Vorontsov wrote:
[...]
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> 
> On Tue, Jul 01, 2008 at 02:43:53PM +0100, Alan Cox wrote:
[...]
> > It looks correct to me except that you cannot use spin_lock/disable_irq
> > in that way safely. You must always disable_irq before taking the lock,
> > or prove it is safe and use disable_irq_nosync
> > 
> > The reason:
> > 		CPU#0 spin_lock_... [taken]
> > 		CPU#1 IRQ
> > 		CPU#1 spin_lock [waits]
> > 		CPU#0 disable_irq (deadlock)
> 
> This deadlock possibility is interesting by itself, thanks for
> mentioning it.
> 
> But this can't happen here. IRQ will not grab the up->port.lock,
> because port isn't registered in the 8250 IRQ handling chain (yet).

Alan, are there any issues with the proof or the patch itself?

Thanks,

> As for _nosync, probably this is good idea indeed, and should be safe
> AFAICS.
> 
>  drivers/serial/8250.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 76ccef7..cad0c2d 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -1831,7 +1831,9 @@ static int serial8250_startup(struct uart_port *port)
>  		 * the interrupt is enabled.  Delays are necessary to
>  		 * allow register changes to become visible.
>  		 */
> -		spin_lock_irqsave(&up->port.lock, flags);
> +		spin_lock(&up->port.lock);
> +		if (up->port.flags & UPF_SHARE_IRQ)
> +			disable_irq_nosync(up->port.irq);
>  
>  		wait_for_xmitr(up, UART_LSR_THRE);
>  		serial_out_sync(up, UART_IER, UART_IER_THRI);
> @@ -1843,7 +1845,9 @@ static int serial8250_startup(struct uart_port *port)
>  		iir = serial_in(up, UART_IIR);
>  		serial_out(up, UART_IER, 0);
>  
> -		spin_unlock_irqrestore(&up->port.lock, flags);
> +		if (up->port.flags & UPF_SHARE_IRQ)
> +			enable_irq(up->port.irq);
> +		spin_unlock(&up->port.lock);
>  
>  		/*
>  		 * If the interrupt is not reasserted, setup a timer to
> -- 
> 1.5.5.4
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
