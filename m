Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbZBLLKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbZBLLKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZBLLKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:10:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33906 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbZBLLKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:10:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Date: Thu, 12 Feb 2009 11:09:52 +0000
Message-ID: <27421.1234436992@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Aha!  I reproduced it myself (with my patch to check atomic_dec_and_test() in
there, but not Serge's patch).  Ironically, 13 hours of running Vegard's
setreuid() program didn't show anything, but halting the box whilst someone
was trying to SSH-crack it did.

Shutting down ntpd: ------------[ cut here ]------------
kernel BUG at mm/slab.c:591!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:19.0/irq
CPU 1 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.29-rc4-cachefs #35
RIP: 0010:[<ffffffff8028c192>]  [<ffffffff8028c192>] kfree+0x65/0xd1
RSP: 0018:ffff88003dc9fe50  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffff80625a00 RCX: 0000000000000059
RDX: ffffe20000015818 RSI: 0000000000000059 RDI: ffffffff80625a00
RBP: ffffffff8025d238 R08: 0000000000000000 R09: ffff88003cffc9c8
R10: ffff88003cd4e000 R11: 09f911029d74e35b R12: ffffffff80625a00
R13: 0000000000000286 R14: 0000000000000009 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88003dc64268(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f2bbb54f7f8 CR3: 000000003d2fe000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88003dc98000, task ffff88003dc95290)
Stack:
 09f911029d74e35b ffffffff80625a00 ffffffff8025d238 ffff88003cc82338
 0000000000000202 ffffffff803820bd 0000000000000286 ffff88003d2fcec0
 0000000000000286 ffffffff8023a488 ffff88003cc823b8 ffff88003cffc9c8
Call Trace:
 <IRQ> <0> [<ffffffff8025d238>] ? free_user_ns+0x0/0x19
 [<ffffffff803820bd>] ? kref_put+0x51/0x5c
 [<ffffffff8023a488>] ? free_uid+0x4c/0x99
 [<ffffffff80246cd1>] ? put_cred_rcu+0x70/0x83
 [<ffffffff802691d9>] ? __rcu_process_callbacks+0x157/0x1d2
 [<ffffffff8026927a>] ? rcu_process_callbacks+0x26/0x4b
 [<ffffffff802362e7>] ? __do_softirq+0x7a/0x13d
 [<ffffffff8020c2bc>] ? call_softirq+0x1c/0x28
 [<ffffffff8020d7e4>] ? do_softirq+0x2c/0x6c
 [<ffffffff8021a893>] ? smp_apic_timer_interrupt+0x93/0xac
 [<ffffffff8020bcf3>] ? apic_timer_interrupt+0x13/0x20
 <EOI> <0> [<ffffffff80447cce>] ? datagram_poll+0x0/0xc2
 [<ffffffff802119d0>] ? mwait_idle+0x41/0x44
 [<ffffffff8020a018>] ? cpu_idle+0x40/0x5e
Code: 48 8d 14 10 48 8b 02 25 00 00 01 00 48 85 c0 74 15 48 8b 52 10 48 8b 02 25 00 00 01 00 48 85 c0 74 04 48 8b 52 10 80 3a 00 78 04 <0f> 0b eb fe 48 8b 5a 28 65 8b 04 25 24 00 00 00 89 c0 48 8b 2c 
RIP  [<ffffffff8028c192>] kfree+0x65/0xd1
 RSP <ffff88003dc9fe50>
---[ end trace 36e0423a3db60c4b ]---
Kernel panic - not syncing: Fatal exception in interrupt


This is due to the BUG_ON() in the following:

	static inline struct kmem_cache *page_get_cache(struct page *page)
	{
		page = compound_head(page);
		BUG_ON(!PageSlab(page));
		return (struct kmem_cache *)page->lru.next;
	}

This is due to the user_namespace being released being init_user_ns.  RDI and
R12 both hold the parameter to kfree() at this point, and gdb says:

	(gdb) i sym 0xffffffff80625a00
	init_user_ns in section .data

David
