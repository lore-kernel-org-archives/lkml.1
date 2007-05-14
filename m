Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXENTTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXENTTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXENTTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:19:23 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3970 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbXENTTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:19:22 -0400
Date: Mon, 14 May 2007 20:19:05 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       bjorn.helgaas@hp.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: set RTS and DTR if flow is 'r'  --- resend
Message-ID: <20070514191905.GE29682@flint.arm.linux.org.uk>
Mail-Followup-To: Yinghai Lu <Yinghai.Lu@Sun.COM>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	bjorn.helgaas@hp.com, Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com> <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com> <46489BC2.6040403@sun.com> <4648A310.1050908@sun.com> <20070514181007.GA29682@flint.arm.linux.org.uk> <4648B2CC.2020403@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4648B2CC.2020403@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:04:44PM -0700, Yinghai Lu wrote:
> Russell King wrote:
> >There may be some sense, however, in allowing DTR to be permanently
> >raised for serial consoles.  However, I would err on caution since
> >DTR is used to reliably instruct modems to drop the line, so making
> >such a change would be undesirable for those folk.
> >  
> please check following is OK.

Still wrong, and unfortunately you haven't understood what I was saying
at all because this is worse. ;(

Do not put the code in serial8250_set_termios.  It is the wrong place.

> 
> YH
> 
> [PATCH] serial: set DTR in uart for kernel serial console
> 
> Some UARTs on other side need host uart DTR is set, otherwise will not 
> receive char from the host that kernel is runing during kernel boot stage.
> 
> BTW:
> earlyprintk and early_uart are hard coded to set DTR/RTS.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> *diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c*
> index 48e259a..29c051c 100644
> *--- a/drivers/serial/8250.c*
> *+++ b/drivers/serial/8250.c*
> @@ -2154,6 +2154,12 @@ serial8250_set_termios(struct uart_port *port, 
> struct ktermios *termios,
> 		}
> 		serial_outp(up, UART_FCR, fcr);		/* set fcr */
> 	}
> +
> +	/* some uarts on other side don't support no flow control. So we set
> +	 * DTR in host uart to make them happy
> +	 */
> +	up->port.mctrl |= TIOCM_DTR;
> +
> 	serial8250_set_mctrl(&up->port, up->port.mctrl);
> 	spin_unlock_irqrestore(&up->port.lock, flags);
> }
> 

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
