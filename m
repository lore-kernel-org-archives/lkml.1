Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYGUNbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYGUNbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYGUNbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:31:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57755 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbYGUNbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:31:13 -0400
Date: Mon, 21 Jul 2008 15:30:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [crash, bisected] Kernel BUG at ffffffff8079afb1
	(__netif_schedule())
Message-ID: <20080721133059.GA30637@elte.hu>
References: <20080720.104411.81744468.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720.104411.81744468.davem@davemloft.net>
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


David,

-tip testing on latest -git (v2.6.26-5253-g14b395e) triggered the 
following boot crash on a Core2Duo 64-bit testsystem:

ADDRCONF(NETDEV_UP): eth0: link is not ready
eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
------------[ cut here ]------------
Kernel BUG at ffffffff8079afb1 [verbose debug info unavailable]
invalid opcode: 0000 [1] SMP 
CPU 0 
Pid: 7, comm: events/0 Not tainted 2.6.26-rc8 #21302
RIP: 0010:[<ffffffff8079afb1>]  [<ffffffff8079afb1>] __netif_schedule+0xd/0x64
RSP: 0018:ffff81003fa4be30  EFLAGS: 00010246
RAX: 00000000ffffffff RBX: ffff81003e9f49f0 RCX: ffffffff80c38fe0
RDX: ffff81003e9e7940 RSI: ffffffff80c3fdc0 RDI: ffffffff80c3fdc0
RBP: ffff81003e9f49f0 R08: 0000000000001607 R09: ffff810003b1c380
R10: 0000000000000005 R11: 00000100ffffffff R12: 0000000000000000
R13: ffff81003e9f49f0 R14: ffff81003e9f4000 R15: ffff81003e9f46c0
FS:  0000000000000000(0000) GS:ffffffff80c7c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000de7ef0 CR3: 000000003e5f1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/0 (pid: 7, threadinfo ffff81003fa4a000, task ffff81003fa20c30)
Stack:  ffff81003e9f49f0 ffffffff805083a4 ffffffff80d19840 ffff81003e9f4a08
 ffff81003e9e7880 0000000000000000 0000000000000000 0000000000000202
 000000003f9f5f10 ffff81003fa06a40 ffffffff80507f5c ffff81003fa06a48
Call Trace:
 [<ffffffff805083a4>] ? e1000_watchdog_task+0x448/0x635
 [<ffffffff80507f5c>] ? e1000_watchdog_task+0x0/0x635
 [<ffffffff8023e11b>] ? run_workqueue+0x80/0x112
 [<ffffffff8023e9f6>] ? worker_thread+0xd9/0xe8
 [<ffffffff802410af>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8023e91d>] ? worker_thread+0x0/0xe8
 [<ffffffff80240f58>] ? kthread+0x47/0x73
 [<ffffffff8022d557>] ? schedule_tail+0x28/0x5d
 [<ffffffff8020c288>] ? child_rip+0xa/0x12
 [<ffffffff80240f11>] ? kthread+0x0/0x73
 [<ffffffff8020c27e>] ? child_rip+0x0/0x12

Code: c2 48 8b 42 30 48 89 06 48 89 72 30 e8 30 ab a9 ff 48 89 df 57 9d 66 0f 1f 44 00 00 5b c3 48 81 ff c0 fd c3 80 53 48 89 fe 75 04 <0f> 0b eb fe f0 0f ba 6f 30 01 19 c0 85 c0 75 45 9c 58 66 0f 1f 
RIP  [<ffffffff8079afb1>] __netif_schedule+0xd/0x64
 RSP <ffff81003fa4be30>
Kernel panic - not syncing: Fatal exception

i've bisected it back to:

| 37437bb2e1ae8af470dfcd5b4ff454110894ccaf is first bad commit
| commit 37437bb2e1ae8af470dfcd5b4ff454110894ccaf
| Author: David S. Miller <davem@davemloft.net>
| Date:   Wed Jul 16 02:15:04 2008 -0700
|
|    pkt_sched: Schedule qdiscs instead of netdev_queue.

bisection log:

 # bad:  [14b395e1] Merge branch 'for-2.6.27' of git://linux-nfs.org/~
 # good: [bce7f795] Linux 2.6.26
 # good: [cadc7236] Merge branch 'bkl-removal' into next
 # bad:  [a0c80b8d] pkt_sched: Make default qdisc nonshared-multiqueue
 # good: [30902dc4] ax25: Fix std timer socket destroy handling.
 # good: [fbd8f13a] net-sched: sch_htb: move hash and sibling list rem
 # good: [83aa2e9b] netlabel: return msg overflow error from netlbl_ci
 # good: [0388b002] icmp: add struct net argument to icmp_out_count
 # good: [ca12a1ac] inet: prepare net on the stack for NET accounting
 # good: [8f0f2227] net: Implement simple sw TX hashing.
 # bad:  [17715e68] pkt_sched: Use per-queue locking in shutdown_sched
 # good: [e2627c85] pkt_sched: Make QDISC_RUNNING a qdisc state.
 # bad:  [37437bbf] pkt_sched: Schedule qdiscs instead of netdev_queue
 # good: [7698b4ff] pkt_sched: Add and use qdisc_root() and qdisc_root

config and crashlog:

  http://redhat.com/~mingo/misc/config-Mon_Jul_21_13_59_54_CEST_2008.bad
  http://redhat.com/~mingo/misc/crash-Mon_Jul_21_13_59_54_CEST_2008.log

[ Note: the bootlog says 2.6.26-rc8 - that's because bisection dived
  back to when you cut that devel tree of yours. ]

As the bug is reproducible i can test patches, etc. Let me know if you 
need more info than this.

Thanks,

	Ingo
