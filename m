Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbYGVNlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbYGVNlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYGVNlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:41:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYGVNlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:41:02 -0400
Date: Tue, 22 Jul 2008 15:40:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>, David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [USB boot crash, -git] ecm_do_notify(), list_add corruption.
	prev->next should be next (ffff88003b8f82f8)
Message-ID: <20080722134042.GA14315@elte.hu>
References: <20080721223038.GA2051@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721223038.GA2051@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Greg, David,

-tip randconfig boot testing just found this USB boot crash regression:

dummy_udc dummy_udc: enabled ep-a (ep1in-bulk) maxpacket 512
dummy_udc dummy_udc: enabled ep-b (ep2out-bulk) maxpacket 512
usb0: qlen 10
g_cdc gadget: notify connect false
list_add corruption. prev->next should be next (ffff88003b8f82f8), but was ffff88003b8f8e80. (prev=ffff88003b8f8e80).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0 
Pid: 0, comm: swapper Not tainted 2.6.26-tip-06162-g2ef4b1e-dirty #13411
RIP: 0010:[<ffffffff8045ed64>]  [<ffffffff8045ed64>] __list_add+0x54/0x60
RSP: 0018:ffffffff80ef8c40  EFLAGS: 00010086
RAX: 0000000000000079 RBX: ffff88003b96a1f0 RCX: 0000000000000000
RDX: 0000000000004831 RSI: 0000000000000001 RDI: ffffffff80bc4240
RBP: ffffffff80ef8c40 R08: 0000000000000001 R09: ffffffff80259b1e
R10: ffffffff80259b1e R11: 0000000000000020 R12: ffff88003b8f8320
R13: ffff88003b96a1e0 R14: ffff88003b8f81a0 R15: ffff88003b8f82f8
FS:  0000000000000000(0000) GS:ffffffff80cfcb00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff80d3c000, task ffffffff80bbb6c0)
Stack:  ffffffff80ef8c90 ffffffff8073de15 ffffffff80ef8cd0 ffff88003b8f8e80
 0000000000000082 ffffffff80aefa57 ffff88003b904688 ffff88003b96a240
 ffff88003b96a1f0 ffff88003b8f8ae0 ffffffff80ef8cd0 ffffffff8073f3b6
Call Trace:
 <IRQ>  [<ffffffff8073de15>] dummy_queue+0xd5/0x1d0
 [<ffffffff8073f3b6>] ecm_do_notify+0x116/0x1f0
 [<ffffffff8073f4a5>] ecm_notify+0x15/0x20
 [<ffffffff8073f851>] ecm_set_alt+0x111/0x1d0
 [<ffffffff807418d7>] composite_setup+0x127/0x900
 [<ffffffff80261136>] ? lock_release_holdtime+0x66/0x80
 [<ffffffff8073d31b>] ? dummy_timer+0x65b/0xac0
 [<ffffffff8073ccc0>] ? dummy_timer+0x0/0xac0
 [<ffffffff8073d334>] dummy_timer+0x674/0xac0
 [<ffffffff8073ccc0>] ? dummy_timer+0x0/0xac0
 [<ffffffff80248c7b>] run_timer_softirq+0x1db/0x250
 [<ffffffff80244936>] __do_softirq+0x66/0xd0
 [<ffffffff8020ce8c>] call_softirq+0x1c/0x30
 [<ffffffff8020f7a5>] do_softirq+0x45/0x80
 [<ffffffff802447d5>] irq_exit+0xa5/0xb0
 [<ffffffff8021ce0d>] smp_apic_timer_interrupt+0x8d/0xd0
 [<ffffffff8020c8d6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff80214395>] ? mwait_idle+0x45/0x50
 [<ffffffff80209f97>] ? enter_idle+0x27/0x30
 [<ffffffff8020a4f6>] ? cpu_idle+0x46/0xd0
 [<ffffffff808fbe36>] ? rest_init+0x86/0x90
 [<ffffffff80d4af5f>] ? start_kernel+0x31f/0x360
 [<ffffffff80d4a284>] ? x86_64_start_reservations+0x84/0x90
 [<ffffffff80d4a39f>] ? x86_64_start_kernel+0xdf/0xf0

Code: 89 d1 48 c7 c7 88 1c b1 80 48 89 c2 31 c0 e8 54 0b de ff 0f 0b eb fe 48 89 c1 4c 89 c6 48 c7 c7 d8 1c b1 80 31 c0 e8 3c 0b de ff <0f> 0b eb fe 66 66 66 90 66 66 66 90 55 48 8b 16 48 89 e5 e8 94 
RIP  [<ffffffff8045ed64>] __list_add+0x54/0x60
 RSP <ffffffff80ef8c40>
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 0, comm: swapper Tainted: G      D   2.6.26-tip-06162-g2ef4b1e-dirty #13411
    
With this config:
    
   http://redhat.com/~mingo/misc/config-Tue_Jul_22_13_44_45_CEST_2008.bad
    
i tried to do a blind revert of da741b8c5 ("usb ethernet gadget: split 
CDC Ethernet function") where this crash originates from - but the 
resulting kernel would not build. (it has followup dependencies)

upstream base is v2.6.26-5752-g93ded9b.

The crash is reproducible, can try any patch or suggestion. More info on 
request.

I can try a bisection if really necessary although given the crash site 
i suspect it will arrive to this bloc of commits:

 0391c82: usb ethernet gadget: use composite gadget framework
 19e2068: usb gadget: new "CDC Composite" gadget driver
 45fe3b8: usb ethernet gadget: split RNDIS function
 da741b8: usb ethernet gadget: split CDC Ethernet function
 8a40819: usb ethernet gadget: split CDC Subset function
 2b3d942: usb ethernet gadget: split out network core

	Ingo
