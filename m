Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZFXHIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZFXHIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZFXHIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:08:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49575 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZFXHIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:08:31 -0400
Date: Wed, 24 Jun 2009 09:07:19 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-reply-to: <200906230952.37592.david-b@pacbell.net>
To: "'David Brownell'" <david-b@pacbell.net>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002101c9f49a$6cfcaf50$46f60df0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: Acn0IwYXttPIQ7WoRXy5YzcK6Yt3fAAddGkw
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
 <200906230022.39040.david-b@pacbell.net>
 <002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
 <200906230952.37592.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 23, 2009 6:53 PM David Brownell wrote:

> > /* low_latency means ldiscs work in tasklet context, without
> >  * needing a workqueue schedule ... easier to keep up.
> >  */
> >
> > So in low latency mode calls are made from a tasklet.
> 
> ... and that has, at some point since 2.6.26 or so, become a
> problem that caused oopsing.
> 
> > This is not true in
> > my case, as the S3C OTG UDC driver does all its job in interrupts. This
> > way also a (usb) packet_done callback is done from an interrupt. I expect
> > that g_serial driver interacts with tty layer in that packet_done callback,
> > so this is the source of the problems. I noticed that some other UDC
> > drivers also does all its job from an interrupt, so they also might be
> > affected. How this bug should be properly resolved?
> 
> Change the u_serial.c code so that this newish tty behavior
> stops causing problems:  don't set low_latency.
> 
> But also try and sort through any consequences of that, and
> don't forget to update the comments which talk about how the
> low_latency setting is affecting code flow.

I did some additional tests and found another bug. When I enabled debug in my
low level udc driver then I can easily trigger the following bug:

[   55.630000] Unable to handle kernel NULL pointer dereference at virtual address 00000014
[   55.630000] pgd = c0004000
[   55.630000] [00000014] *pgd=00000000
[   55.630000] Internal error: Oops: 17 [#1] PREEMPT
[   55.630000] Modules linked in:
[   55.630000] CPU: 0    Not tainted  (2.6.30 #355)
[   55.630000] PC is at __lock_acquire+0xa0/0xa6c
[   55.630000] LR is at lock_acquire+0x58/0x6c
[   55.630000] pc : [<c005786c>]    lr : [<c0058290>]    psr: 60000093
[   55.630000] sp : c6c39da8  ip : c6c22080  fp : c6546524
[   55.630000] r10: c6546128  r9 : 00000010  r8 : 0000001f
[   55.630000] r7 : 00000000  r6 : c6c38000  r5 : 60000093  r4 : 00000001
[   55.630000] r3 : 60000093  r2 : 00000000  r1 : 00000000  r0 : 00000000
[   55.630000] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   55.630000] Control: 00c5387d  Table: 565c4008  DAC: 00000017
[   55.630000] Process events/0 (pid: 5, stack limit = 0xc6c38268)
[   55.630000] Stack: (0xc6c39da8 to 0xc6c3a000)
[   55.630000] 9da0:                   00000000 00000000 00000000 00000000 c6c22080 00000000
[   55.630000] 9dc0: 60000013 00000080 60000093 c6c38000 00000000 0000001f c6546168 c6546128
[   55.630000] 9de0: c6546524 c0058290 00000001 00000080 00000000 c019d608 c6546524 00000000
[   55.630000] 9e00: 00000000 c019d608 a0000013 c0274e74 00000001 00000000 c019d608 22222222
[   55.630000] 9e20: 22222222 00000000 0000000a 00001500 c6546000 c019d608 c6546000 0000000a
[   55.630000] 9e40: 00001500 c0156058 c6546524 c01538e0 c6546000 c65464e4 c0155a38 00000000
[   55.630000] 9e60: 0000000a 00001500 c6546000 0000001f c6546168 c6546128 c654656c c0155a40
[   55.630000] 9e80: c65c241d c65c253a 00000000 00000003 c65461d8 c65461bc c6546124 c654624c
[   55.630000] 9ea0: c6546108 c654621c c6546524 0000001c c6c22080 0000000c 00000000 00000000
[   55.630000] 9ec0: 00000000 00000000 c6c22080 00000000 00000000 00000000 c6c22080 c6c38000
[   55.630000] 9ee0: 00000000 00000080 60000093 c6c38000 00000000 00000000 c6546168 c6546128
[   55.630000] 9f00: c0158070 c0058290 00000001 00000000 c6546168 c01580a0 a0000013 00000000
[   55.630000] 9f20: c6546168 c6546128 c0158070 c0274e7c c6546168 c65c241d c65c251d c65c2400
[   55.630000] 9f40: c6546000 0000001f c6546168 c6546128 c6546108 c0158174 c0158070 c6d5dc80
[   55.630000] 9f60: 00000001 c654612c c6c38000 c6c1c180 c6546128 00000000 c6c39fb4 00000001
[   55.630000] 9f80: c0158070 c00498e0 00000001 00000000 c0049874 c035f870 c6c1c1a4 c6c1c19c
[   55.630000] 9fa0: 00000000 c6c22080 c004d7e0 c6c39fac c6c39fac c076e76c 00000000 c0314cba
[   55.630000] 9fc0: c6c1c180 c6c38000 c6c1c180 c0049710 00000000 00000000 00000000 00000000
[   55.630000] 9fe0: 00000000 c004d55c 00000000 00000000 00000000 c003c03c c0335f20 ffffffff
[   55.630000] [<c005786c>] (__lock_acquire+0xa0/0xa6c) from [<c0058290>] (lock_acquire+0x58/0x6c)
[   55.630000] [<c0058290>] (lock_acquire+0x58/0x6c) from [<c0274e74>] (_spin_lock_irqsave+0x44/0x58)
[   55.630000] [<c0274e74>] (_spin_lock_irqsave+0x44/0x58) from [<c019d608>] (gs_write_room+0x10/0x58)
[   55.630000] [<c019d608>] (gs_write_room+0x10/0x58) from [<c0156058>] (tty_write_room+0x20/0x28)
[   55.630000] [<c0156058>] (tty_write_room+0x20/0x28) from [<c01538e0>] (process_echoes+0x4c/0x288)
[   55.630000] [<c01538e0>] (process_echoes+0x4c/0x288) from [<c0155a40>] (n_tty_receive_buf+0x9ec/0xecc)
[   55.630000] [<c0155a40>] (n_tty_receive_buf+0x9ec/0xecc) from [<c0158174>] (flush_to_ldisc+0x104/0x1b0)
[   55.630000] [<c0158174>] (flush_to_ldisc+0x104/0x1b0) from [<c00498e0>] (worker_thread+0x1d0/0x2cc)
[   55.630000] [<c00498e0>] (worker_thread+0x1d0/0x2cc) from [<c004d55c>] (kthread+0x58/0x90)
[   55.630000] [<c004d55c>] (kthread+0x58/0x90) from [<c003c03c>] (do_exit+0x0/0x5d0)
[   55.630000] [<c003c03c>] (do_exit+0x0/0x5d0) from [<c6c26180>] (0xc6c26180)
[   55.630000] Code: ea000076 e59d100c e3510000 1a000002 (e5994004)
[   55.640000] ---[ end trace f9a4499d9482c504 ]---
[   55.650000] note: events/0[5] exited with preempt_count 1

The low latency mode is disabled. I've tested different ways of gathering
the debug output from my lowlevel udc driver: in first attempt it was 
printk(KERN_INFO ...) then I switched to use lowlevel printascii() to remove
possible interaction with console/tty framework at all. In both cases I got
the above NULL pointer exception. It only worked fine when I switched to
printk(KERN_DEBUG ...) with debug level above KERN_DEBUG, so all the
messages were only buffered in dmesg buffer. This looks like a timing issue
in tty framework...
 
Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


