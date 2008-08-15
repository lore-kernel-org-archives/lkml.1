Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYHOOby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYHOOby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYHOObq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:31:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42394 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYHOObp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:31:45 -0400
Date: Fri, 15 Aug 2008 16:24:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@tv-sign.ru,
       manfred@colorfullife.com, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier
	cleanups
Message-ID: <20080815142430.GA20722@elte.hu>
References: <20080805162144.GA8297@linux.vnet.ibm.com> <20080815140902.GE14103@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815140902.GE14103@elte.hu>
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


Paul,

one of your two recent RCU patches caused this lockdep splat in -tip 
testing:

------------------->
Brought up 2 CPUs
Total of 2 processors activated (6850.87 BogoMIPS).
PM: Adding info for No Bus:platform
khelper used greatest stack depth: 3124 bytes left

=================================
[ INFO: inconsistent lock state ]
2.6.27-rc3-tip #1
---------------------------------
inconsistent {softirq-on-W} -> {in-softirq-W} usage.
ksoftirqd/0/4 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&rcu_ctrlblk.lock){-+..}, at: [<c016d91c>] __rcu_process_callbacks+0x1ac/0x1f0
{softirq-on-W} state was registered at:
  [<c01528e4>] __lock_acquire+0x3f4/0x5b0
  [<c0152b29>] lock_acquire+0x89/0xc0
  [<c076142b>] _spin_lock+0x3b/0x70
  [<c016d649>] rcu_init_percpu_data+0x29/0x80
  [<c075e43f>] rcu_cpu_notify+0xaf/0xd0
  [<c076458d>] notifier_call_chain+0x2d/0x60
  [<c0145ede>] __raw_notifier_call_chain+0x1e/0x30
  [<c075db29>] _cpu_up+0x79/0x110
  [<c075dc0d>] cpu_up+0x4d/0x70
  [<c0a769e1>] kernel_init+0xb1/0x200
  [<c01048a3>] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff
irq event stamp: 14
hardirqs last  enabled at (14): [<c01534db>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (13): [<c014dbeb>] trace_hardirqs_off+0xb/0x10
softirqs last  enabled at (0): [<c012b186>] copy_process+0x276/0x1190
softirqs last disabled at (11): [<c0105c0a>] call_on_stack+0x1a/0x30

other info that might help us debug this:
no locks held by ksoftirqd/0/4.

stack backtrace:
Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.27-rc3-tip #1
 [<c01504dc>] print_usage_bug+0x16c/0x1b0
 [<c0152455>] mark_lock+0xa75/0xb10
 [<c0108b75>] ? sched_clock+0x15/0x30
 [<c015289d>] __lock_acquire+0x3ad/0x5b0
 [<c0152b29>] lock_acquire+0x89/0xc0
 [<c016d91c>] ? __rcu_process_callbacks+0x1ac/0x1f0
 [<c076142b>] _spin_lock+0x3b/0x70
 [<c016d91c>] ? __rcu_process_callbacks+0x1ac/0x1f0
 [<c016d91c>] __rcu_process_callbacks+0x1ac/0x1f0
 [<c016d986>] rcu_process_callbacks+0x26/0x50
 [<c0132305>] __do_softirq+0x95/0x120
 [<c0132270>] ? __do_softirq+0x0/0x120
 [<c0105c0a>] call_on_stack+0x1a/0x30
 [<c0132426>] ? ksoftirqd+0x96/0x110
 [<c0132390>] ? ksoftirqd+0x0/0x110
 [<c01411f7>] ? kthread+0x47/0x80
 [<c01411b0>] ? kthread+0x0/0x80
 [<c01048a3>] ? kernel_thread_helper+0x7/0x10
 =======================
calling  init_cpufreq_transition_notifier_list+0x0/0x20
initcall init_cpufreq_transition_notifier_list+0x0/0x20 returned 0 after 0 msecs
calling  net_ns_init+0x0/0x190
net_namespace: 676 bytes
initcall net_ns_init+0x0/0x190 returned 0 after 0 msecs
calling  cpufreq_tsc+0x0/0x20
initcall cpufreq_tsc+0x0/0x20 returned 0 after 0 msecs
calling  reboot_init+0x0/0x20
initcall reboot_init+0x0/0x20 returned 0 after 0 msecs
calling  print_banner+0x0/0x10
Booting paravirtualized kernel on bare hardware

<-----------------------

my guess is on:

 commit 1f7b94cd3d564901f9e04a8bc5832ae7bfd690a0
 Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 Date:   Tue Aug 5 09:21:44 2008 -0700

    rcu: classic RCU locking and memory-barrier cleanups
 
	Ingo
