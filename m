Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbXENTsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbXENTsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXENTsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:48:39 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:47327 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXENTsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:48:38 -0400
Date: Mon, 14 May 2007 12:46:27 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] serial: set RTS and DTR if flow is 'r'  --- resend
In-reply-to: <20070514191905.GE29682@flint.arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, bjorn.helgaas@hp.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <4648BC93.8080909@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
 <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com> <46489BC2.6040403@sun.com>
 <4648A310.1050908@sun.com> <20070514181007.GA29682@flint.arm.linux.org.uk>
 <4648B2CC.2020403@sun.com> <20070514191905.GE29682@flint.arm.linux.org.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> Still wrong, and unfortunately you haven't understood what I was saying
> at all because this is worse. ;(
>
> Do not put the code in serial8250_set_termios.  It is the wrong place.
>   

I don't want to put that there. the problem is serial8250_set_mctrl 
called by will clear DTR bit.

uart_set_options==>serial8250_set_termios ==> serial8250_set_mctrl will 
clear DTR bit

YH


static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
{
struct uart_8250_port *up = (struct uart_8250_port *)port;
unsigned char mcr = 0;

if (mctrl & TIOCM_RTS)
mcr |= UART_MCR_RTS;
if (mctrl & TIOCM_DTR)
mcr |= UART_MCR_DTR;
if (mctrl & TIOCM_OUT1)
mcr |= UART_MCR_OUT1;
if (mctrl & TIOCM_OUT2)
mcr |= UART_MCR_OUT2;
if (mctrl & TIOCM_LOOP)
mcr |= UART_MCR_LOOP;

mcr = (mcr & up->mcr_mask) | up->mcr_force | up->mcr;

serial_out(up, UART_MCR, mcr);
}

