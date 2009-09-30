Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZI3M60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZI3M60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZI3M6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:58:25 -0400
Received: from www.tglx.de ([62.245.132.106]:54399 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZI3M6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:58:25 -0400
Date: Wed, 30 Sep 2009 14:57:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rt11 freeze on userland start on ARM
In-Reply-To: <3efb10970909211136g4e74c8b3vc339d548cdd0959f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0909301448030.2518@nanos>
References: <3efb10970909211136g4e74c8b3vc339d548cdd0959f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Remy Bohmer wrote:
> So, as workaround/test I made this change:
> 
> Index: linux-2.6.31/drivers/serial/atmel_serial.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/serial/atmel_serial.c	2009-09-21
> 19:44:48.000000000 +0200
> +++ linux-2.6.31/drivers/serial/atmel_serial.c	2009-09-21
> 19:45:15.000000000 +0200
> @@ -808,7 +808,8 @@ static int atmel_startup(struct uart_por
>  	/*
>  	 * Allocate the IRQ
>  	 */
> -	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED,
> +	retval = request_irq(port->irq, atmel_interrupt,
> +			IRQF_SHARED | IRQF_NODELAY,
>  			tty ? tty->name : "atmel_serial", port);
>  	if (retval) {
>  		printk("atmel_serial: atmel_startup - Can't get irq\n");

The serial irq cannot run in hard irq context.

There are two solutions to this problem:

1) Use the other timer which is available on AT91.

2) Make the serial driver explicitely threaded and check in the
hardirq handler whether the irq originated from the serial driver. If
yes, disable it in the serial device and return IRQ_WAKE_THREAD
otherwise return IRQ_NONE.

Thanks,

	tglx
