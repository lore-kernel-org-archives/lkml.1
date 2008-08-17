Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYHQOh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYHQOh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 10:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYHQOhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 10:37:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33973 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbYHQOhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 10:37:19 -0400
Date: Sun, 17 Aug 2008 07:37:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@tv-sign.ru,
       manfred@colorfullife.com, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: [PATCH tip/core/rcu] classic RCU locking cleanup fix lockdep
	problem
Message-ID: <20080817143715.GA1455@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080805162144.GA8297@linux.vnet.ibm.com> <20080815140902.GE14103@elte.hu> <20080815142430.GA20722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815142430.GA20722@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 04:24:30PM +0200, Ingo Molnar wrote:
> 
> Paul,
> 
> one of your two recent RCU patches caused this lockdep splat in -tip 
> testing:
> 
> ------------------->
> Brought up 2 CPUs
> Total of 2 processors activated (6850.87 BogoMIPS).
> PM: Adding info for No Bus:platform
> khelper used greatest stack depth: 3124 bytes left
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.27-rc3-tip #1
> ---------------------------------
> inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> ksoftirqd/0/4 [HC0[0]:SC1[1]:HE1:SE0] takes:
>  (&rcu_ctrlblk.lock){-+..}, at: [<c016d91c>] __rcu_process_callbacks+0x1ac/0x1f0
> {softirq-on-W} state was registered at:
>   [<c01528e4>] __lock_acquire+0x3f4/0x5b0
>   [<c0152b29>] lock_acquire+0x89/0xc0
>   [<c076142b>] _spin_lock+0x3b/0x70
>   [<c016d649>] rcu_init_percpu_data+0x29/0x80
>   [<c075e43f>] rcu_cpu_notify+0xaf/0xd0
>   [<c076458d>] notifier_call_chain+0x2d/0x60
>   [<c0145ede>] __raw_notifier_call_chain+0x1e/0x30
>   [<c075db29>] _cpu_up+0x79/0x110
>   [<c075dc0d>] cpu_up+0x4d/0x70
>   [<c0a769e1>] kernel_init+0xb1/0x200
>   [<c01048a3>] kernel_thread_helper+0x7/0x10
>   [<ffffffff>] 0xffffffff
> irq event stamp: 14
> hardirqs last  enabled at (14): [<c01534db>] trace_hardirqs_on+0xb/0x10
> hardirqs last disabled at (13): [<c014dbeb>] trace_hardirqs_off+0xb/0x10
> softirqs last  enabled at (0): [<c012b186>] copy_process+0x276/0x1190
> softirqs last disabled at (11): [<c0105c0a>] call_on_stack+0x1a/0x30
> 
> other info that might help us debug this:
> no locks held by ksoftirqd/0/4.
> 
> stack backtrace:
> Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.27-rc3-tip #1
>  [<c01504dc>] print_usage_bug+0x16c/0x1b0
>  [<c0152455>] mark_lock+0xa75/0xb10
>  [<c0108b75>] ? sched_clock+0x15/0x30
>  [<c015289d>] __lock_acquire+0x3ad/0x5b0
>  [<c0152b29>] lock_acquire+0x89/0xc0
>  [<c016d91c>] ? __rcu_process_callbacks+0x1ac/0x1f0
>  [<c076142b>] _spin_lock+0x3b/0x70
>  [<c016d91c>] ? __rcu_process_callbacks+0x1ac/0x1f0
>  [<c016d91c>] __rcu_process_callbacks+0x1ac/0x1f0
>  [<c016d986>] rcu_process_callbacks+0x26/0x50
>  [<c0132305>] __do_softirq+0x95/0x120
>  [<c0132270>] ? __do_softirq+0x0/0x120
>  [<c0105c0a>] call_on_stack+0x1a/0x30
>  [<c0132426>] ? ksoftirqd+0x96/0x110
>  [<c0132390>] ? ksoftirqd+0x0/0x110
>  [<c01411f7>] ? kthread+0x47/0x80
>  [<c01411b0>] ? kthread+0x0/0x80
>  [<c01048a3>] ? kernel_thread_helper+0x7/0x10
>  =======================
> calling  init_cpufreq_transition_notifier_list+0x0/0x20
> initcall init_cpufreq_transition_notifier_list+0x0/0x20 returned 0 after 0 msecs
> calling  net_ns_init+0x0/0x190
> net_namespace: 676 bytes
> initcall net_ns_init+0x0/0x190 returned 0 after 0 msecs
> calling  cpufreq_tsc+0x0/0x20
> initcall cpufreq_tsc+0x0/0x20 returned 0 after 0 msecs
> calling  reboot_init+0x0/0x20
> initcall reboot_init+0x0/0x20 returned 0 after 0 msecs
> calling  print_banner+0x0/0x10
> Booting paravirtualized kernel on bare hardware
> 
> <-----------------------
> 
> my guess is on:
> 
>  commit 1f7b94cd3d564901f9e04a8bc5832ae7bfd690a0
>  Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>  Date:   Tue Aug 5 09:21:44 2008 -0700
> 
>     rcu: classic RCU locking and memory-barrier cleanups
> 
> 	Ingo

Fixes a problem detected by lockdep in which rcu->lock was acquired
both in irq context and in process context, but without disabling from
process context.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcuclassic.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 5de1266..fb1f1cc 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -700,7 +700,9 @@ void rcu_check_callbacks(int cpu, int user)
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
-	spin_lock(&rcp->lock);
+	long flags;
+
+	spin_lock_irqsave(&rcp->lock, flags);
 	memset(rdp, 0, sizeof(*rdp));
 	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
 	rdp->donetail = &rdp->donelist;
@@ -708,7 +710,7 @@ static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 	rdp->qs_pending = 0;
 	rdp->cpu = cpu;
 	rdp->blimit = blimit;
-	spin_unlock(&rcp->lock);
+	spin_unlock_irqrestore(&rcp->lock, flags);
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
