Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0BCPPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:15:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36363 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755014Ab0BCPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:15:48 -0500
Date: Wed, 3 Feb 2010 10:15:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andreas Mohr <andi@lisas.de>
cc: Catalin Marinas <catalin.marinas@arm.com>,
       Oliver Neukum <oliver@neukum.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
In-Reply-To: <20100202215251.GA18570@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.44L0.1002031011010.1540-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010, Andreas Mohr wrote:

> Any ideas? To my uncaring mind this would look like __flush_dcache_page()
> not being quite so happy with a NULL pointer that it is being served
> (although I haven't managed to precisely investigate yet where the
> dereferencing offset 0000041c is coming from).
> 
> Yes, crash is reproducible (three times on boot already, although some bootup
> does make it successfully).
> 
> My ehci-q.c has:
> 
>        if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) != PIPE_CONTROL) {
>                void *ptr;
>                for (ptr = urb->transfer_buffer;
>                     ptr < urb->transfer_buffer + urb->transfer_buffer_length;
>                     ptr += PAGE_SIZE)
>                        flush_dcache_page(virt_to_page(ptr));
>        }
> 
> Hmm, OTOH this code seems to postulate that urb->transfer_buffer_length
> is that 0x41c from above...
> (IOW the code is simply missing an urb->transfer_buffer NULL check)
> OTOH there would also be the question whether flush_dcache_page() should
> have caught the NULL pointer input...
> And then there's the question whether urb->transfer_buffer is allowed to end
> up as NULL anyway...

Have you looked at the code in qh_urb_transaction() in ehci-q.c
involving this_sg_len and buf?  It's quite possible that
urb->transfer_buffer is a NULL pointer and that the actual buffer is
not a contiguous set of pages -- but only if DMA is used.

Alan Stern

