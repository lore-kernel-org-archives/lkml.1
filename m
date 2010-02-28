Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab0B1QcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:32:19 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39719 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030247Ab0B1QcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:32:17 -0500
Date: Sun, 28 Feb 2010 08:32:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] more lockdep-RCU and RCU_FAST_NO_HZ
	fixes
Message-ID: <20100228163218.GD6846@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100227225240.GA16515@linux.vnet.ibm.com> <20100228085505.GA2067@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228085505.GA2067@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 09:55:05AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello!
> > 
> > This series (1) makes RCU_FAST_NO_HZ actually do the full number of
> > iterations specified instead of just one and (2) fixes an RCU lockdep
> > splat.
> 
> Thanks, applied.
> 
> This one is pretty stubborn, it still triggers:
> 
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 218 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] allocated 10485760 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] 
> [    0.000000] ===================================================
> [    0.000000] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.000000] ---------------------------------------------------
> [    0.000000] kernel/sched_fair.c:3479 invoked rcu_dereference_check() without protection!
> [    0.000000] 
> [    0.000000] other info that might help us debug this:
> [    0.000000] 
> [    0.000000] no locks held by swapper/0.
> [    0.000000] 
> [    0.000000] stack backtrace:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-tip-01015-g97e7da3-dirty #10753
> [    0.000000] Call Trace:
> [    0.000000]  <IRQ>  [<ffffffff8107f5d1>] lockdep_rcu_dereference+0xa1/0xb0
> [    0.000000]  [<ffffffff8104afd1>] scheduler_tick+0x221/0x2c0
> [    0.000000]  [<ffffffff8105f6d5>] update_process_times+0x55/0x70
> [    0.000000]  [<ffffffff8107ac27>] tick_periodic+0x27/0x70
> [    0.000000]  [<ffffffff8107ac8f>] tick_handle_periodic+0x1f/0x90
> [    0.000000]  [<ffffffff8100e29a>] timer_interrupt+0x1a/0x30
> [    0.000000]  [<ffffffff810a28aa>] handle_IRQ_event+0x3a/0xe0
> [    0.000000]  [<ffffffff810a53ab>] handle_level_irq+0x8b/0x130
> [    0.000000]  [<ffffffff8100da94>] handle_irq+0x44/0x70
> [    0.000000]  [<ffffffff8100cfde>] do_IRQ+0x6e/0xf0
> [    0.000000]  [<ffffffff817eea13>] ret_from_intr+0x0/0x16
> [    0.000000]  <EOI>  [<ffffffff8102dfe6>] ? native_restore_fl+0x6/0x10
> [    0.000000]  [<ffffffff817ee3df>] _raw_spin_unlock_irqrestore+0x6f/0x80
> [    0.000000]  [<ffffffff810a37f3>] __setup_irq+0x1b3/0x3b0
> [    0.000000]  [<ffffffff810a3a18>] setup_irq+0x28/0x40
> [    0.000000]  [<ffffffff81ef2914>] setup_default_timer_irq+0x12/0x14
> [    0.000000]  [<ffffffff81ef292d>] hpet_time_init+0x17/0x19
> [    0.000000]  [<ffffffff81ef28fb>] x86_late_time_init+0xa/0x11
> [    0.000000]  [<ffffffff81eefcf4>] start_kernel+0x25f/0x2e6
> [    0.000000]  [<ffffffff81eef30b>] x86_64_start_reservations+0xf6/0xfa
> [    0.000000]  [<ffffffff81eef409>] x86_64_start_kernel+0xfa/0x109
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2002.507 MHz processor.
> [    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4005.01 BogoMIPS (lpj=2002507)

Ah -- this is a new arrival from my viewpoint.  Patch below!

This won't apply to tip/core/rcu, but does against current tip/master.

							Thanx, Paul

------------------------------------------------------------------------

sched: fix rcu_dereference() for RCU-lockde

Make rcu_dereference() of runqueue data structures be
rcu_dereference_sched().

Located-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3e1fd96..5a5ea2c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3476,7 +3476,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 static inline int on_null_domain(int cpu)
 {
-	return !rcu_dereference(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
 }
 
 /*
