Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbZJOQJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbZJOQJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932872AbZJOQJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:09:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:45712 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871AbZJOQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:09:33 -0400
Date: Thu, 15 Oct 2009 11:09:06 -0500
From: Scott Wood <scottwood@freescale.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Timur Tabi <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
Message-ID: <20091015160906.GA3730@loki.buserror.net>
References: <1255557226-4403-1-git-send-email-timur@freescale.com> <200910151305.47100.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910151305.47100.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 01:05:47PM +0200, Christian Borntraeger wrote:
> The fact that struct console->write returns void indicates that the console 
> layer is not interested in errors. We have two policies we can implement:
> 
> 1. drop console messages if case of congestion but keep the system going
> 2. dont drop messages and wait, even if the system might come to a complete stop 
> 
> Looking at drivers/char/vt.c 
>         /* console busy or not yet initialized */
>         if (!printable)
>                 return;
>         if (!spin_trylock(&printing_lock))
>                 return;
> could mean that  Linux consoles should not block.

That's a bit different -- the code above is testing for potential deadlocks
within Linux (or a not-yet-initialized console), not a device that has yet
to process the last batch of characters we threw at it.  Plus, given the
"console must be locked when we get here" comment, I'm not sure that you'll
ever see contention on printing_lock?

Serial consoles currently block when waiting for the buffer to drain:

static void serial8250_console_putchar(struct uart_port *port, int ch)
{
	struct uart_8250_port *up = (struct uart_8250_port *)port;

	wait_for_xmitr(up, UART_LSR_THRE);
	serial_out(up, UART_TX, ch);
}


-Scott
