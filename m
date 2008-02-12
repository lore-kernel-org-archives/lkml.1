Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbYBLPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbYBLPP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbYBLPPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:15:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46315 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbYBLPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:15:16 -0500
Date: Tue, 12 Feb 2008 07:14:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>
Subject: Re: [ata crash] Re: Linux 2.6.25-rc1
Message-ID: <20080212071452.5c58ae6d@laptopd505.fenrus.org>
In-Reply-To: <20080212081816.GA17820@elte.hu>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
	<20080212081816.GA17820@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 09:18:16 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> hm, ata_port_wait_eh() started crashing on a testsystem (8-way box):
> 
> [   39.324116] Calling initcall 0xc09f41eb: legacy_init+0x0/0x888()
> [   39.331868] BUG: unable to handle kernel NULL pointer dereference
> at 000000e4 [   39.338811] IP: [<c04a4e11>] ata_port_wait_eh+0x77/0xa2
> [   39.344115] *pde = 00000000
> [   39.347778] Oops: 0000 [#1] SMP
> [   39.350769]
> [   39.350769] Pid: 1, comm: swapper Not tainted (2.6.25-rc1 #5)
> [   39.350769] EIP: 0060:[<c04a4e11>] EFLAGS: 00010246 CPU: 1
> [   39.350769] EIP is at ata_port_wait_eh+0x77/0xa2
> [   39.350769] EAX: f72e5d9c EBX: f7340000 ECX: c035eb18 EDX: 00000000
> [   39.350769] ESI: f73424f0 EDI: 00000246 EBP: f7c63efc ESP: f7c63edc
> [   39.350769]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   39.350769] Process swapper (pid: 1, ti=f7c62000 task=f7c60000
> task.ti=f7c62) [   39.350769] Stack: 00000000 f7c60000 c012fd31
> f7c63ee8 f7c63ee8 f7340000 f73 [   39.350769]        f7c63f18
> c049c4b1 f72e5d9c 00000000 f7340000 00810001 000
> [   39.350769]        c09f4a60 00000000 00000000 c0b79a9c 00000001
> 00000001 000 [   39.350769] Call Trace: [   39.350769]
> [<c012fd31>] ? autoremove_wake_function+0x0/0x30 [   39.350769]
> [<c049c4b1>] ? ata_host_detach+0x4c/0x13b [   39.350769]
> [<c09f4a60>] ? legacy_init+0x875/0x888 [   39.350769]  [<c0133fa6>] ?
> getnstimeofday+0x35/0xc0 [   39.350769]  [<c09d7465>] ?
> kernel_init+0x12a/0x277 [   39.350769]  [<c09d7300>] ?
> do_early_param+0x34/0x6f [   39.350769]  [<c09d733b>] ?
> kernel_init+0x0/0x277 [   39.350769]  [<c0104b17>] ?
> kernel_thread_helper+0x7/0x10 [   39.350769]  =======================
> [   39.350769] Code: e8 82 0f 21 00 8b 43 08 e8 28 2c 21 00 89 c7 f6
> 43 10 03 8 [   39.350769] EIP: [<c04a4e11>]
> ata_port_wait_eh+0x77/0xa2 SS:ESP 0068:f7c63edc[   39.350793]
> ---[ end trace 07a6e399b623c9d0 ]--- [   39.354119] Kernel panic -
> not syncing: Attempted to kill init!
> 
> no particular commit stands out at me - so i Cc:-ed various PATA
> folks. Config attached [it's randconfig generated so might have weird
> option combinations in it]. [ Note: the box uses BLK_CPQ_DA as its
> primary storage, ATA is just a CDROM side-thing - so it was never
> heavily tested here. It never crashed the bootup before though. ]
> 
> On a second attempt to boot the same bzImage, another ATA related 
> weirdness showed up:
> 
> [    8.226144] Calling initcall 0xc09f3d8e: isapnp_init+0x0/0xf()
> [    8.232017] Bad IO access at port 0x0 (outb(val,port))
> [    8.232799] ------------[ cut here ]------------
> [    8.232799] WARNING: at lib/iomap.c:44 bad_io_access+0x2f/0x34()
> [    8.232799] Pid: 1, comm: swapper Not tainted 2.6.25-rc1 #5
> [    8.232799]  [<c011fd63>] warn_on_slowpath+0x3c/0x4c
> [    8.232799]  [<c0358e9d>] ? serial8250_console_write+0x0/0x14e
> [    8.232799]  [<c01200a5>] ? __call_console_drivers+0x56/0x63
> [    8.232799]  [<c06b7acf>] ? _spin_unlock_irqrestore+0x15/0x21
> [    8.232799]  [<c0120556>] ? release_console_sem+0x1c1/0x1c9
> [    8.232799]  [<c015c400>] ? print_trailer+0x6e/0xfc
> [    8.232799]  [<c015c77f>] ? check_object+0x10b/0x181
> [    8.232799]  [<c01209a0>] ? printk+0x15/0x17
> [    8.232799]  [<c02cc2ce>] bad_io_access+0x2f/0x34
> [    8.232799]  [<c02cc48a>] iowrite8+0x31/0x34
> [    8.232799]  [<c04a1c8d>] ata_bmdma_freeze+0x1d/0x30

btw this one was featured in the weekly bug top 10.. it's a rather popular thing to happen.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
