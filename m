Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZFWGmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZFWGmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZFWGmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:42:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54956 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZFWGmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:42:43 -0400
Date: Tue, 23 Jun 2009 08:41:40 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-reply-to: <200906222026.51511.david-b@pacbell.net>
To: "'David Brownell'" <david-b@pacbell.net>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <001c01c9f3cd$ad02b1d0$07081570$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: AcnzsnWhgutvJSPdQsy6XmaaqIUYGwAGX/XA
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
 <Pine.LNX.4.44L0.0906221004590.2991-100000@iolanthe.rowland.org>
 <001301c9f343$7e16ed80$7a44c880$%szyprowski@samsung.com>
 <200906222026.51511.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 23, 2009 5:27 AM, David Brownell wrote:

> > > This is just a guess...  But there's a good possibility that the
> oops
> > > was caused by recent changes to the serial layer which have not
> been
> > > propagated through to the g_serial driver.
> >
> > How recent these changes are? I did a test on another ARM-based Linux
> > platform with old 2.6.28 kernel and the result was exactly the same
> as
> > above...
> 
> Just for the record, the reworked g_serial code merged in 2.6.27
> and was mostly developed on 2.6.25 and 2.6.26 ... and it included
> a lot of stress testing.  No such mutex_lock() in_irq() bug showed
> up at that time.  And that was running with all practical kernel
> debug options, so it should have showed up if it were that easy.
> 
> I do however recall turning up several regressions in how "sparse"
> lock checking behaved.  As in, it broke when faced with common
> idioms like needing to temporarily drop a lock deep in a call stack.
> 
> Now, the serial layer has been getting a *LONG* overdue incremental
> overhaul since before that started.  So there's been plenty of time
> for incompatible changes to sneak in; I believe Alan Cox focuses on
> host side things, out of defensive necessity.
> 
> Like, oh, changing a spinlock to a mutex.   You might change the
> low_latency setting and review how that's now supposed to behave.

In in gs_open() function in drivers/usb/gadget/u_serial.c, after the 
line 780 I've added:

tty->low_latency = 1;

This helped a bit, but after a few serial transfers I got the same 
bug again.

With mutex debugging and preemptive kernel turned off I got the
following crash:

# ls >/dev/ttyGS0
[   80.070000] BUG: scheduling while atomic: ls/497/0x00000100
[   80.070000] Modules linked in:
[   80.070000]
[   80.070000] Pid: 497, comm:                   ls
[   80.070000] CPU: 0    Not tainted  (2.6.30 #340)
[   80.080000] PC is at n_tty_write+0x1fc/0x39c
[   80.080000] LR is at gs_write_room+0x38/0x54
[   80.090000] pc : [<c013d7d4>]    lr : [<c0184fb0>]    psr: 60000013
[   80.090000] sp : c6573ee0  ip : 00000020  fp : c6505400
[   80.100000] r10: c6505380  r9 : c6f13f00  r8 : c6572000
[   80.100000] r7 : 0000005a  r6 : c6505400  r5 : c6505000  r4 : 00001fff
[   80.110000] r3 : 000000a0  r2 : 00000015  r1 : c6e6eb40  r0 : 0000005a
[   80.120000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment
user
[   80.120000] Control: 00c5387d  Table: 56580008  DAC: 00000015

With preemptive kernel and mutex debuging:

[   26.800000] BUG: sleeping function called from invalid context at
kernel/mutex.c:280
[   26.800000] in_atomic(): 1, irqs_disabled(): 0, pid: 500, name: ls
[   26.810000] no locks held by ls/500.
[   26.810000] [<c0025c30>] (unwind_backtrace+0x0/0xdc) from [<c0272570>]
(mutex_lock_nested+0x28/0x304)
[   26.820000] [<c0272570>] (mutex_lock_nested+0x28/0x304) from [<c0153b0c>]
(echo_set_canon_col+0x20/0x48)
[   26.830000] [<c0153b0c>] (echo_set_canon_col+0x20/0x48) from [<c0155b2c>]
(n_tty_receive_buf+0xbf8/0xecc)
[   26.840000] [<c0155b2c>] (n_tty_receive_buf+0xbf8/0xecc) from
[<c0158054>] (flush_to_ldisc+0x104/0x1b0)
[   26.850000] [<c0158054>] (flush_to_ldisc+0x104/0x1b0) from [<c019e0b8>]
(gs_rx_push+0x118/0x1cc)
[   26.860000] [<c019e0b8>] (gs_rx_push+0x118/0x1cc) from [<c003d794>]
(tasklet_action+0x78/0xc8)
[   26.870000] [<c003d794>] (tasklet_action+0x78/0xc8) from [<c003dc28>]
(__do_softirq+0x6c/0xf4)
[   26.880000] [<c003dc28>] (__do_softirq+0x6c/0xf4) from [<c003dcf4>]
(irq_exit+0x44/0x5c)
[   26.890000] [<c003dcf4>] (irq_exit+0x44/0x5c) from [<c001f054>]
(_text+0x54/0x6c)
[   26.890000] [<c001f054>] (_text+0x54/0x6c) from [<c001fc04>]
(__irq_usr+0x44/0xa0)
[   26.900000] Exception stack(0xc65a9fb0 to 0xc65a9ff8)
[   26.910000] 9fa0:                                     4022e68c 000007b2
40215e98 00000001
[   26.910000] 9fc0: 4022e68c 4022fef8 4022d000 00002f28 00000001 00001688
beb16a34 00000028
[   26.920000] 9fe0: 4022d000 beb1693c 401904e0 4018f620 20000010 ffffffff
[   26.930000] ------------[ cut here ]------------
[   26.930000] WARNING: at kernel/mutex.c:207 mutex_lock_nested+0xa4/0x304()
[   26.940000] Modules linked in:
[   26.940000] [<c0025c30>] (unwind_backtrace+0x0/0xdc) from [<c0038e4c>]
(warn_slowpath_common+0x4c/0x80)
[   26.950000] [<c0038e4c>] (warn_slowpath_common+0x4c/0x80) from
[<c02725ec>] (mutex_lock_nested+0xa4/0x304)
[   26.960000] [<c02725ec>] (mutex_lock_nested+0xa4/0x304) from [<c0153b0c>]
(echo_set_canon_col+0x20/0x48)
[   26.970000] [<c0153b0c>] (echo_set_canon_col+0x20/0x48) from [<c0155b2c>]
(n_tty_receive_buf+0xbf8/0xecc)
[   26.980000] [<c0155b2c>] (n_tty_receive_buf+0xbf8/0xecc) from
[<c0158054>] (flush_to_ldisc+0x104/0x1b0)
[   26.990000] [<c0158054>] (flush_to_ldisc+0x104/0x1b0) from [<c019e0b8>]
(gs_rx_push+0x118/0x1cc)
[   27.000000] [<c019e0b8>] (gs_rx_push+0x118/0x1cc) from [<c003d794>]
(tasklet_action+0x78/0xc8)
[   27.010000] [<c003d794>] (tasklet_action+0x78/0xc8) from [<c003dc28>]
(__do_softirq+0x6c/0xf4)
[   27.020000] [<c003dc28>] (__do_softirq+0x6c/0xf4) from [<c003dcf4>]
(irq_exit+0x44/0x5c)
[   27.030000] [<c003dcf4>] (irq_exit+0x44/0x5c) from [<c001f054>]
(_text+0x54/0x6c)
[   27.030000] [<c001f054>] (_text+0x54/0x6c) from [<c001fc04>]
(__irq_usr+0x44/0xa0)
[   27.040000] Exception stack(0xc65a9fb0 to 0xc65a9ff8)
[   27.050000] 9fa0:                                     4022e68c 000007b2
40215e98 00000001
[   27.050000] 9fc0: 4022e68c 4022fef8 4022d000 00002f28 00000001 00001688
beb16a34 00000028
[   27.060000] 9fe0: 4022d000 beb1693c 401904e0 4018f620 20000010 ffffffff
[   27.070000] ---[ end trace 675aa93c2a01b9b1 ]---

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


