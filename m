Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZFXIly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZFXIly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZFXIlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:41:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44357 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752374AbZFXIln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:41:43 -0400
Date: Wed, 24 Jun 2009 09:42:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'David Brownell'" <david-b@pacbell.net>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Message-ID: <20090624094240.4097db11@lxorguk.ukuu.org.uk>
In-Reply-To: <002101c9f49a$6cfcaf50$46f60df0$%szyprowski@samsung.com>
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
	<200906230022.39040.david-b@pacbell.net>
	<002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
	<200906230952.37592.david-b@pacbell.net>
	<002101c9f49a$6cfcaf50$46f60df0$%szyprowski@samsung.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [   55.630000] [<c0274e74>] (_spin_lock_irqsave+0x44/0x58) from [<c019d608>] (gs_write_room+0x10/0x58)
> [   55.630000] [<c019d608>] (gs_write_room+0x10/0x58) from [<c0156058>] (tty_write_room+0x20/0x28)
> [   55.630000] [<c0156058>] (tty_write_room+0x20/0x28) from [<c01538e0>] (process_echoes+0x4c/0x288)
> [   55.630000] [<c01538e0>] (process_echoes+0x4c/0x288) from [<c0155a40>] (n_tty_receive_buf+0x9ec/0xecc)
> [   55.630000] [<c0155a40>] (n_tty_receive_buf+0x9ec/0xecc) from [<c0158174>] (flush_to_ldisc+0x104/0x1b0)
> [   55.630000] [<c0158174>] (flush_to_ldisc+0x104/0x1b0) from [<c00498e0>] (worker_thread+0x1d0/0x2cc)
> [   55.630000] [<c00498e0>] (worker_thread+0x1d0/0x2cc) from [<c004d55c>] (kthread+0x58/0x90)
> [   55.630000] [<c004d55c>] (kthread+0x58/0x90) from [<c003c03c>] (do_exit+0x0/0x5d0)
> [   55.630000] [<c003c03c>] (do_exit+0x0/0x5d0) from [<c6c26180>] (0xc6c26180)
> [   55.630000] Code: ea000076 e59d100c e3510000 1a000002 (e5994004)
> [   55.640000] ---[ end trace f9a4499d9482c504 ]---
> [   55.650000] note: events/0[5] exited with preempt_count 1
> 
> The low latency mode is disabled. I've tested different ways of gathering
> the debug output from my lowlevel udc driver: in first attempt it was 
> printk(KERN_INFO ...) then I switched to use lowlevel printascii() to remove
> possible interaction with console/tty framework at all. In both cases I got
> the above NULL pointer exception. It only worked fine when I switched to
> printk(KERN_DEBUG ...) with debug level above KERN_DEBUG, so all the
> messages were only buffered in dmesg buffer. This looks like a timing issue
> in tty framework...

Looks to me like the gs_write_room function takes a lock already held
when the driver calls tty_flip_buffer_push() - which will and can call
back into the driver (eg for echo processing)
