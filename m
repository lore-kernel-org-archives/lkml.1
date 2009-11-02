Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZKBV5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZKBV5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZKBV5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:57:30 -0500
Received: from relais.videotron.ca ([24.201.245.36]:10689 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbZKBV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:57:29 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 02 Nov 2009 16:57:34 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-mmc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
In-reply-to: <20091102191604.010acbc9@lxorguk.ukuu.org.uk>
Message-id: <alpine.LFD.2.00.0911021542520.13333@xanadu.home>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
 <alpine.LFD.2.00.0911021243040.13333@xanadu.home>
 <20091102191604.010acbc9@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Alan Cox wrote:

> > However I have problems applying your patches.  Most of them require 
> > fuzzy patching to apply, and one of them even doesn't apply that way.  
> > What is your base tree?
> 
> Linux-next, but there is a patch I posted afterwards that goes before the
> sdio_uart patches.

Yep, picked it as well.

> Want me to send you a set with all the patches
> including the other one ?

It all applied fine now on top of linux-next, with these warnings:

Applying: sdio_uart: Switch to the open/close helpers
/home/nico/kernels/linux-2.6/.git/rebase-apply/patch:90: trailing whitespace.
/home/nico/kernels/linux-2.6/.git/rebase-apply/patch:156: trailing whitespace.
/home/nico/kernels/linux-2.6/.git/rebase-apply/patch:260: trailing whitespace.
warning: 3 lines add whitespace errors.

Now... testing reveals that the very first patch "sdio_uart: use 
tty_port" causes a segmentation fault in sdio_uart_open():

Unable to handle kernel NULL pointer dereference at virtual address 00000084
pgd = dfb44000 [00000084] *pgd=1fb99031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT
last sysfs file: 
/sys/devices/platform/mvsdio/mmc_host/mmc0/mmc0:f111/uevent
Modules linked in:
CPU: 0    Not tainted  (2.6.32-rc5-next-20091102-00001-gb36eae9 #10)
PC is at sdio_uart_open+0x204/0x2cc
[...]

This is fixed by this patch:

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index c2759db..671fe5e 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -608,7 +608,7 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 		if (!(sdio_uart_get_mctrl(port) & TIOCM_CTS))
 			tty->hw_stopped = 1;
 
-	clear_bit(TTY_IO_ERROR, &port->tty->flags);
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 
 	/* Kick the IRQ handler once while we're still holding the host lock */
 	sdio_uart_irq(port->func);

With this folded in, the card does work with the full series applied.  
However the kernel is now crashing when the card is pulled out while 
some process is reading from the device.  This used to behave well 
before. I don't have time to investigate that one right now though.


Nicolas
