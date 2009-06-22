Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZFVOHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZFVOHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbZFVOGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:06:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59864 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756912AbZFVOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:06:53 -0400
Date: Mon, 22 Jun 2009 10:06:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <kyungmin.park@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-Reply-To: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
Message-ID: <Pine.LNX.4.44L0.0906221004590.2991-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Marek Szyprowski wrote:

> Hello,
> 
> On Monday, June 22, 2009 2:34 PM, Peter Korsgaard wrote:
> 
> >  Marek> I would like to ask if someone has successfully used g_serial
> >  Marek> USB gadget driver with kernel 2.6.29 or 2.6.30? I'm developing
> >  Marek> a low level hardware driver for USB gadgets on ARM S3C6410
> >  Marek> platform. This driver is working quite fine (I've used it a
> >  Marek> lot with g_ether CDC/RNDIS ethernet gadget driver). During my
> >  Marek> development I've found the following bug in g_serial driver:
> > 
> > You are aware that Ben Dooks has written an UDC driver for the OTG
> > controller on the s3c6410 which is now in mainline, right?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-
> > 2.6.git;a=commit;h=5b7d70c6dbf2db786395cbd21750a1a4ce222f84
> 
> Yes, I am aware. That driver does not work well for me (but this is the
> other case). However I did a test with his driver and the result was also
> a kernel oops:
> 
> [  162.520000] BUG: sleeping function called from invalid context at
> kernel/mutex.c:94
> [  162.530000] in_atomic(): 1, irqs_disabled(): 0, pid: 504, name: cat
> [  162.540000] [<c0024afc>] (unwind_backtrace+0x0/0xdc) from [<c0268a28>]
> (mutex_lock+0x14/0x30)
> [  162.540000] [<c0268a28>] (mutex_lock+0x14/0x30) from [<c014ceb4>]
> (echo_set_canon_col+0x1c/0x44)
> [  162.550000] [<c014ceb4>] (echo_set_canon_col+0x1c/0x44) from [<c014eeb0>]
> (n_tty_receive_buf+0xbf0/0xec4)
> [  162.560000] [<c014eeb0>] (n_tty_receive_buf+0xbf0/0xec4) from
> [<c015137c>] (flush_to_ldisc+0x104/0x1b0)
> [  162.570000] [<c015137c>] (flush_to_ldisc+0x104/0x1b0) from [<bf002238>]
> (gs_rx_push+0x118/0x1cc [g_serial])
> [  162.580000] [<bf002238>] (gs_rx_push+0x118/0x1cc [g_serial]) from
> [<c003c780>] (tasklet_action+0x78/0xc8)
> [  162.590000] [<c003c780>] (tasklet_action+0x78/0xc8) from [<c003cc14>]
> (__do_softirq+0x6c/0xf4)
> [  162.600000] [<c003cc14>] (__do_softirq+0x6c/0xf4) from [<c003cce0>]
> (irq_exit+0x44/0x5c)
> [  162.610000] [<c003cce0>] (irq_exit+0x44/0x5c) from [<c001e054>]
> (_text+0x54/0x6c)
> [  162.610000] [<c001e054>] (_text+0x54/0x6c) from [<c001ea28>]
> (__irq_svc+0x48/0x9c)
> [  162.620000] Exception stack(0xc6567e78 to 0xc6567ec0)
> [  162.630000] 7e60:
> c6c883c0 00000013
> [  162.640000] 7e80: ffffffff 00000001 00000013 00000004 c64df800 00000013
> c6566000 c659c0a0
> [  162.640000] 7ea0: c6526c30 c64df800 c6567e80 c6567ec0 c02699bc c02699d0
> 60000013 ffffffff
> [  162.650000] [<c001ea28>] (__irq_svc+0x48/0x9c) from [<c02699bc>]
> (_spin_unlock_irqrestore+0xc/0x44)
> [  162.660000] [<c02699bc>] (_spin_unlock_irqrestore+0xc/0x44) from
> [<bf000d24>] (gs_write+0x5c/0x68 [g_serial])
> [  162.670000] [<bf000d24>] (gs_write+0x5c/0x68 [g_serial]) from
> [<c014d870>] (n_tty_write+0x240/0x39c)
> [  162.680000] [<c014d870>] (n_tty_write+0x240/0x39c) from [<c014b078>]
> (tty_write+0x180/0x21c)
> [  162.690000] [<c014b078>] (tty_write+0x180/0x21c) from [<c008c4d4>]
> (vfs_write+0xac/0x158)
> [  162.700000] [<c008c4d4>] (vfs_write+0xac/0x158) from [<c008c638>]
> (sys_write+0x40/0x6c)
> [  162.700000] [<c008c638>] (sys_write+0x40/0x6c) from [<c001ede0>]
> (ret_fast_syscall+0x0/0x2c)
> [  162.710000] ------------[ cut here ]------------
> [  162.720000] WARNING: at kernel/mutex.c:207
> __mutex_lock_slowpath+0x6c/0x2c8()
> [  162.720000] Modules linked in: g_serial
> [  162.730000] [<c0024afc>] (unwind_backtrace+0x0/0xdc) from [<c0037e94>]
> (warn_slowpath_common+0x4c/0x80)
> [  162.740000] [<c0037e94>] (warn_slowpath_common+0x4c/0x80) from
> [<c026808c>] (__mutex_lock_slowpath+0x6c/0x2c8)
> [  162.750000] [<c026808c>] (__mutex_lock_slowpath+0x6c/0x2c8) from
> [<c0268a30>] (mutex_lock+0x1c/0x30)
> [  162.760000] [<c0268a30>] (mutex_lock+0x1c/0x30) from [<c014ceb4>]
> (echo_set_canon_col+0x1c/0x44)
> [  162.770000] [<c014ceb4>] (echo_set_canon_col+0x1c/0x44) from [<c014eeb0>]
> (n_tty_receive_buf+0xbf0/0xec4)
> [  162.780000] [<c014eeb0>] (n_tty_receive_buf+0xbf0/0xec4) from
> [<c015137c>] (flush_to_ldisc+0x104/0x1b0)
> [  162.780000] [<c015137c>] (flush_to_ldisc+0x104/0x1b0) from [<bf002238>]
> (gs_rx_push+0x118/0x1cc [g_serial])
> [  162.790000] [<bf002238>] (gs_rx_push+0x118/0x1cc [g_serial]) from
> [<c003c780>] (tasklet_action+0x78/0xc8)
> [  162.800000] [<c003c780>] (tasklet_action+0x78/0xc8) from [<c003cc14>]
> (__do_softirq+0x6c/0xf4)
> [  162.810000] [<c003cc14>] (__do_softirq+0x6c/0xf4) from [<c003cce0>]
> (irq_exit+0x44/0x5c)
> [  162.820000] [<c003cce0>] (irq_exit+0x44/0x5c) from [<c001e054>]
> (_text+0x54/0x6c)
> [  162.830000] [<c001e054>] (_text+0x54/0x6c) from [<c001ea28>]
> (__irq_svc+0x48/0x9c)
> [  162.840000] Exception stack(0xc6567e78 to 0xc6567ec0)
> [  162.840000] 7e60:
> c6c883c0 00000013
> [  162.850000] 7e80: ffffffff 00000001 00000013 00000004 c64df800 00000013
> c6566000 c659c0a0
> [  162.860000] 7ea0: c6526c30 c64df800 c6567e80 c6567ec0 c02699bc c02699d0
> 60000013 ffffffff
> [  162.870000] [<c001ea28>] (__irq_svc+0x48/0x9c) from [<c02699bc>]
> (_spin_unlock_irqrestore+0xc/0x44)
> [  162.870000] [<c02699bc>] (_spin_unlock_irqrestore+0xc/0x44) from
> [<bf000d24>] (gs_write+0x5c/0x68 [g_serial])
> [  162.880000] [<bf000d24>] (gs_write+0x5c/0x68 [g_serial]) from
> [<c014d870>] (n_tty_write+0x240/0x39c)
> [  162.890000] [<c014d870>] (n_tty_write+0x240/0x39c) from [<c014b078>]
> (tty_write+0x180/0x21c)
> [  162.900000] [<c014b078>] (tty_write+0x180/0x21c) from [<c008c4d4>]
> (vfs_write+0xac/0x158)
> [  162.910000] [<c008c4d4>] (vfs_write+0xac/0x158) from [<c008c638>]
> (sys_write+0x40/0x6c)
> [  162.920000] [<c008c638>] (sys_write+0x40/0x6c) from [<c001ede0>]
> (ret_fast_syscall+0x0/0x2c)
> [  162.930000] ---[ end trace aa3ca3a4bfa49b54 ]---
> [  162.930000] BUG: scheduling while atomic: cat/504/0x00000104
> [  162.940000] Modules linked in: g_serial
> [  162.940000]
> [  162.940000] Pid: 504, comm:                  cat
> [  162.950000] CPU: 0    Tainted: G        W   (2.6.30 #334)
> [  162.950000] PC is at _spin_unlock_irqrestore+0x20/0x44
> [  162.960000] LR is at _spin_unlock_irqrestore+0xc/0x44
> [  162.960000] pc : [<c02699d0>]    lr : [<c02699bc>]    psr: 60000013
> [  162.960000] sp : c6567ec0  ip : c6567e80  fp : c64df800
> [  162.970000] r10: c6526c30  r9 : c659c0a0  r8 : c6566000
> [  162.980000] r7 : 00000013  r6 : c64df800  r5 : 00000004  r4 : 00000013
> [  162.990000] r3 : 00000001  r2 : ffffffff  r1 : 00000013  r0 : c6c883c0
> [  162.990000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment
> user
> [  163.000000] Control: 00c5387d  Table: 565d0008  DAC: 00000015
> 
> When I disabled Preemptive kernel and disabled debugs in Kernel Hacking
> section I only got the following message:
> 
> [   69.810000] BUG: scheduling while atomic: cat/499/0x00000100
> [   69.820000] Modules linked in: g_serial
> [   69.820000]
> [   69.820000] Pid: 499, comm:                  cat
> [   69.830000] CPU: 0    Not tainted  (2.6.30 #336)
> [   69.830000] PC is at gs_write+0x50/0x58 [g_serial]
> [   69.840000] LR is at check_preempt_wakeup+0x24/0x114
> [   69.840000] pc : [<bf000a48>]    lr : [<c002fc5c>]    psr: 60000013
> [   69.840000] sp : c6553ed0  ip : c64698e0  fp : c6469c00
> [   69.850000] r10: c6469b80  r9 : c6ffd300  r8 : c6552000
> [   69.860000] r7 : 00000005  r6 : 00000004  r5 : 00000013  r4 : c6ffd980
> [   69.860000] r3 : 00000004  r2 : 00000000  r1 : 00000001  r0 : 00000000
> [   69.870000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment
> user
> [   69.880000] Control: 00c5387d  Table: 56580008  DAC: 00000015
> 
> > I've used the g_serial driver on 2.6.29 without problems (not on
> > s3c6410 though).
> 
> On what hardware you use the g_serial driver? It is ARM-based? I
> understand that this might be also related to the way that low level
> hardware gadget driver is implemented, but I really have no idea how
> to hunt for this bug.

This is just a guess...  But there's a good possibility that the oops
was caused by recent changes to the serial layer which have not been
propagated through to the g_serial driver.

Alan Stern

