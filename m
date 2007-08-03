Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbXHCSE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbXHCSE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbXHCSEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:04:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756113AbXHCSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:04:50 -0400
Date: Fri, 3 Aug 2007 11:04:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp =?ISO-8859-1?Q?T=F6lke?= <philipptoelke@web.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Christophe Saout <christophe@saout.de>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: PROBLEM: Oops when using dm-crypt with dpt_i2o
Message-Id: <20070803110430.88a4b543.akpm@linux-foundation.org>
In-Reply-To: <46B0D4B4.2040809@web.de>
References: <46B0D4B4.2040809@web.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 20:45:08 +0200
Philipp T__lke <philipptoelke@web.de> wrote:

> Hello everybody,
> 
> if I mount a dm-crypt-encrypted Harddisk/RAID-Array on an Adaptec 3200S,
> and produce load (for example with bonnie++) the kernel crashes.
> 
> This is always reproducible. To reproduce simply mount an dm-crypt
> encrypted device and produce load -- I always used bonnie++.
> 
> Unencrypted volumes work fine. Every kind of load I threw at the System
> worked fine.
> 
> I would be very glad, if some kind of solution for this can be found.
> 

Gee we get a lot of bug reports involving dm-crypt.

> 
> The oopses:
> 
> #v+
> BUG: unable to handle kernel paging request at virtual address 14001000
> printing eip:
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in: dm_crypt dm_mod capability commoncap ipv6 pcspkr
> ppdev lp parport_pc parport rtc_cmos ppp_generic rtc_core rtc_lib
> i2c_viapro i2o_core i2c_core via_ircc irda crc_ccitt sg shpchp
> pci_hotplug evdev thermal processor fan button battery ac slhc r8169
> usbcore jfs sr_mod cdrom sd_mod sym53c8xx dpt_i2o ata_generic pata_via
> libata
> CPU:    0
> EIP:    0060:[<14001000>]    Not tainted VLI
> EFLAGS: 00010082   (2.6.22.1 #2)
> EIP is at 0x14001000
> eax: 00000000   ebx: 14001000   ecx: 00000000   edx: 0002bc00
> esi: 5b51c000   edi: 14001000   ebp: 5b51b000   esp: dfe21f08
> ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> Process kblockd/0 (pid: 31, ti=dfe20000 task=c1cfca50 task.ti=dfe20000)
> 
> Stack: 5b51a000 14001000 5b519000 14001000 5b518000 d4001000 5b517000
> 00000086
> c1d0b534 c1d0b424 c1d0b490 c1da7834 c1da7834 c1da7834 00000000 07000000
> c022aac5 c1da78b8 c022b696 c022c762 00000046 c1d0b534 c1d0b424 c1d0b490
> 
> Call Trace:
> [<c022aac5>] __generic_unplug_device+0x25/0x30
> [<c022b696>] generic_unplug_device+0x6/0x10
> [<c022c762>] blk_unplug_work+0x42/0xa0
> [<c022c720>] blk_unplug_work+0x0/0xa0
> [<c012a307>] run_workqueue+0x97/0x110
> [<c012aa00>] worker_thread+0x0/0xe0
> [<c012aa7d>] worker_thread+0x7d/0xe0
> [<c012d5e0>] autoremove_wake_function+0x0/0x40
> [<c012aa00>] worker_thread+0x0/0xe0
> [<c012d292>] kthread+0x42/0x70
> [<c012d250>] kthread+0x0/0x70
> [<c01041df>] kernel_thread_helper+0x7/0x18
> =======================
> Code:  Bad EIP value.
> EIP: [<14001000>] 0x14001000 SS:ESP 0068:dfe21f08
> 

So it looks like q->request_fn points at 0x14001000, which is in outer
space.

I wonder how that could happen, in the middle of heavy IO operations. 
Possibly a memory scribble.  I'd suggest you enable CONFIG_SLAB,
CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC.  You could also try switching
from CONFIG_SLAB to CONFIG_SLUB, then enable CONFIG_SLUB_DEBUG.



