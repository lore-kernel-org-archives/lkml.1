Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbXENTHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbXENTHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXENTG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:06:56 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:45249 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbXENTGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:06:55 -0400
Date: Mon, 14 May 2007 12:04:44 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] serial: set RTS and DTR if flow is 'r'  --- resend
In-reply-to: <20070514181007.GA29682@flint.arm.linux.org.uk>
To: rmk@arm.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, bjorn.helgaas@hp.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <4648B2CC.2020403@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
 <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com> <46489BC2.6040403@sun.com>
 <4648A310.1050908@sun.com> <20070514181007.GA29682@flint.arm.linux.org.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> There may be some sense, however, in allowing DTR to be permanently
> raised for serial consoles.  However, I would err on caution since
> DTR is used to reliably instruct modems to drop the line, so making
> such a change would be undesirable for those folk.
>   
please check following is OK.

YH

[PATCH] serial: set DTR in uart for kernel serial console

Some UARTs on other side need host uart DTR is set, otherwise will not 
receive char from the host that kernel is runing during kernel boot stage.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>

*diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c*
index 48e259a..29c051c 100644
*--- a/drivers/serial/8250.c*
*+++ b/drivers/serial/8250.c*
@@ -2154,6 +2154,12 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		}
 		serial_outp(up, UART_FCR, fcr);		/* set fcr */
 	}
+
+	/* some uarts on other side don't support no flow control. So we set
+	 * DTR in host uart to make them happy
+	 */
+	up->port.mctrl |= TIOCM_DTR;
+
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }

