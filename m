Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYA3Jl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYA3Jl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbYA3JlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:41:19 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56694 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479AbYA3JlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:41:16 -0500
Date: Wed, 30 Jan 2008 10:41:13 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: michael <trimarchi@gandalf.sssup.it>
Cc: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
In-Reply-To: <479FB2D7.4020804@gandalf.sssup.it>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 00:12:23 +0100
michael <trimarchi@gandalf.sssup.it> wrote:

> I'm testing this patch on an at91sam9260 on 2.6.24-rt. I'm using this
> patch with the tclib support for hrtimer and the clocksource pit_clk.
> These are the results:
> 
> - Voluntary Kernel Preemption the system (crash)
> - Preemptible  Kernel (crash)

Ouch. I'm assuming this is with DMA disabled?

> /*
>  * Drop the lock here since it might end up calling
>  * uart_start(), which takes the lock.
>    spin_unlock(&port->lock);
>  */
>     tty_flip_buffer_push(port->info->tty);
> /*
>     spin_lock(&port->lock);
>  */
> The same code with this comments out runs

Now, _that_ is strange. I can't see anything that needs protection
across that call; in fact, I think we can lock a lot less than what we
currently do.

> Complete Preemption (Real-Time) ok but the serials is just unusable due
> to too many overruns (just using lrz)

Is it worse than before? IIRC Remy mentioned something about
IRQF_NODELAY being the reason for moving all this code to softirq
context in the first place; does the interrupt handler run in hardirq
context?

> The system is stable and doesn't crash reverting this patch.
> I don't test with the thread hardirqs active.

Ok.

> >> +	ret = -ENOMEM;
> >> +	data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
> >> +	if (!data)
> >> +		goto err_alloc_ring;
> >> +	port->rx_ring.buf = data;
> >> +
> >>  	ret = uart_add_one_port(&atmel_uart, &port->uart);
> >>     
> Is the kmalloc correct?
> maybe:
> data = kmalloc(ATMEL_SERIAL_RINGSIZE * sizeof(struct atmel_uart_char), 
> GFP_KERNEL);

I think you're right. Can you change it and see if it helps?

I guess I didn't test it thoroughly enough with DMA
disabled...slub_debug ought to catch such things, but not until we
receive enough data to actually overflow the buffer.

> >> @@ -1033,6 +1165,9 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
> >>  
> >>  	ret = uart_remove_one_port(&atmel_uart, port);
> >>  
> >> +	tasklet_kill(&atmel_port->tasklet);
> >> +	kfree(atmel_port->rx_ring.buf);
> >> +
> >>     
> Why the tasklet_kill is not done in atmel_shutdown?

Why should it be? If it should, we must move the call to tasklet_init
into atmel_startup too, and I don't really see the point.

Haavard
