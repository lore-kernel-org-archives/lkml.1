Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbXEBLus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbXEBLus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbXEBLus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:50:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbXEBLur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:50:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
To: dipankar@in.ibm.com, rusty@rustcorp.com.au, torvalds@osdl.org,
       akpm@osdl.org
cc: linux-kernel@vger.kernel.org
Subject: Race between RCU and rmmod
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 02 May 2007 12:50:24 +0100
Message-ID: <30958.1178106624@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dipankar, Rusty,

I seem to have found a race between RCU and rmmod.  What I see appears to be
an RCU destructor function that has a call pending but lives in a module, gets
deleted before the RCU callback is processed:

RIP: 0010:[<ffffffff880329b7>]  [<ffffffff880329b7>]
RSP: 0018:ffffffff805a4f08  EFLAGS: 00010296
RAX: 0000000000000026 RBX: ffff81002fe53a38 RCX: 0000000000000026
RDX: ffff810001f730c0 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffffff805a4f18 R08: 0000000000000002 R09: ffffffff80228eab
R10: ffffffff805a4c98 R11: ffffffff805a4e28 R12: ffff81003979e140
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80552000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffff880329b7 CR3: 0000000000201000 CR4: 00000000000006e0
Process ksoftirqd/0 (pid: 3, threadinfo ffff81003e626000, task ffff810001f730c0)
Stack:  ffff81002fe53a38 ffff810001dc5040 ffffffff805a4f48 ffffffff8023946a
 ffff810001dc5140 0000000000000000 000000000000000a 0000000000000000
 ffffffff805a4f58 ffffffff8023952c ffffffff805a4f78 ffffffff8022dca3
Call Trace:
 <IRQ>  [<ffffffff8023946a>] __rcu_process_callbacks+0x15d/0x1fc
 [<ffffffff8023952c>] rcu_process_callbacks+0x23/0x44
 [<ffffffff8022dca3>] tasklet_action+0x5e/0xb2
 [<ffffffff8022db99>] __do_softirq+0x5f/0xe3
 [<ffffffff8022daa9>] ksoftirqd+0x0/0x91
 [<ffffffff8020a94c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020c562>] do_softirq+0x39/0x9f
 [<ffffffff8022dafb>] ksoftirqd+0x52/0x91
 [<ffffffff8023b79e>] kthread+0xd8/0x10e
 [<ffffffff8020a5d8>] child_rip+0xa/0x12
 [<ffffffff8041b100>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff80209cec>] restore_args+0x0/0x30
 [<ffffffff8023b6c6>] kthread+0x0/0x10e
 [<ffffffff8020a5ce>] child_rip+0x0/0x12

I think that rmmod needs to clear the RCU destructor queue, probably inside of
__try_stop_module().

David
