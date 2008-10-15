Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYJOXnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYJOXnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYJOXmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:42:55 -0400
Received: from gw.goop.org ([64.81.55.164]:49259 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYJOXmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:42:54 -0400
Message-ID: <48F67FF5.8010501@goop.org>
Date: Wed, 15 Oct 2008 16:42:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Oops in UHCI when encountering "host controller process error"
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to get UHCI working in a Xen dom0.  This is essentially akin 
to making it work with an iommu, as physical memory pages are not 
contiguous, and their kernel-visible addresses are not directly usable 
as DMA addresses.  I'm not too surprised that I'm seeing driver errors 
(though e1000 and mpt fusion work fine), so the fact that I'm getting 
this error probably isn't a reflection on  the UHCI driver.

The problem I'm seeing is this:

xen_create_contiguous_region: vstart=ffff880073ff0000 order=0 addr_bits=20
uhci_hcd 0000:00:1d.0:  -> ret ffff880073ff0000 dma 79b6c000
uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
uhci_hcd 0000:00:1d.0: host controller halted, very bad!
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff803acb56>] uhci_scan_schedule+0xa8/0x85f
PGD 0 
Thread overran stack, or stack corrupted
Oops: 0000 [#1] SMP 
Dumping ftrace buffer:
   (ftrace buffer empty)
CPU 0 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27-tip #233
RIP: e030:[<ffffffff803acb56>]  [<ffffffff803acb56>] uhci_scan_schedule+0xa8/0x85f
RSP: e02b:ffffffff80657da8  EFLAGS: 00010006
RAX: fffffffffffffff0 RBX: ffff8800738921e0 RCX: ffff880073892158
RDX: ffff880073892158 RSI: 0000000000000000 RDI: ffff880073892158
RBP: ffffffff80657e18 R08: ffffffffffffffff R09: 0000000000008f00
R10: ffff8800738921e0 R11: 0000000000000246 R12: fffffffffffffff0
R13: 0000000000000000 R14: ffff880073892158 R15: ffff880073892000
FS:  0000000000000000(0000) GS:ffffffff805adf40(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805b2000, task ffffffff8056e3a0)
Stack:
 ffffffff80657db8 ffff8800738921a8 ffffffff80657e08 ffffffff80243df5
 ffffffff80657dd8 ffffffff803253c3 ffff880073892158 ffffffff80328d89
 ffff8800738921e0 ffff8800738921e0 ffff880073892158 0000000000000000
Call Trace:
 <IRQ> <0> [<ffffffff80243df5>] ? __mod_timer+0xb8/0xca
 [<ffffffff803253c3>] ? __const_udelay+0x44/0x46
 [<ffffffff80328d89>] ? _raw_spin_lock+0x68/0x10b
 [<ffffffff803aef89>] uhci_irq+0x13f/0x158
 [<ffffffff8039744a>] usb_hcd_irq+0x42/0x90
 [<ffffffff80251a7e>] ? __update_sched_clock+0x1e/0x93
 [<ffffffff8026164a>] handle_IRQ_event+0x2e/0x65
 [<ffffffff80262b35>] handle_level_irq+0x91/0xe2
 [<ffffffff80214a6d>] handle_irq+0x27/0x36
 [<ffffffff80365f05>] xen_evtchn_do_upcall+0x198/0x1be
 [<ffffffff8045f8be>] xen_do_hypervisor_callback+0x1e/0x30
 <EOI> <0> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
 [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
 [<ffffffff8020e5e0>] ? xen_safe_halt+0x10/0x1a
 [<ffffffff8020be00>] ? xen_idle+0x34/0x48
 [<ffffffff80211188>] ? cpu_idle+0x51/0x92
 [<ffffffff8044f018>] ? rest_init+0x5c/0x5e
 [<ffffffff805dbd64>] ? start_kernel+0x409/0x414
 [<ffffffff805db2ba>] ? x86_64_start_reservations+0xa5/0xa9
 [<ffffffff805df532>] ? xen_start_kernel+0x96f/0x981
Code: c8 00 00 00 4c 89 75 c0 41 89 86 d4 00 00 00 48 8b 55 c0 48 8b 42 28 48 8b 40 10 48 83 e8 10 49 89 86 80 00 00 00 e9 e0 06 00 00 <49> 8b 44 24 10 48 83 e8 10 49 89 86 80 00 00 00 41 83 7c 24 74 


I'm not too surprised its getting hardware errors, and I wouldn't assume 
its a USB-level bug at this point (though if its misusing the DMA API, 
it could be a driver bug; I think I saw an iommu-related bug go past, 
which could be a clue).

But the crash as a result of the "host controller process error" does 
look like a UHCI driver bug.

The RIP corresponds to:
0xffffffff803acb56 is in uhci_scan_schedule 
(/home/jeremy/hg/xen/paravirt/linux/drivers/usb/host/uhci-q.c:1740).

1740                uhci->next_qh = list_entry(qh->node.next,
1741                        struct uhci_qh, node);


If you have any hints as to what's causing the host controller process 
error and how I might go about debugging it, that would be very useful.

Thanks,
    J
