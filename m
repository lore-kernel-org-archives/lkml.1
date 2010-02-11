Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0BKQw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:52:59 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59345 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab0BKQw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:52:58 -0500
Date: Thu, 11 Feb 2010 08:52:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: rcu_dereference() without protection in select_task_rq_fair()
Message-ID: <20100211165246.GA8329@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter,

My lockdep-ified RCU complains about the for_each_domain() in
select_task_rq_fair(), see below for the lockdep complaint.  I added
rcu_dereference_check() annotations as follows:

#define for_each_domain_rd(p) \
	rcu_dereference_check((p), \
			      rcu_read_lock_sched_held() || \
			      lockdep_is_held(&sched_domains_mutex))

#define for_each_domain(cpu, __sd) \
	for (__sd = for_each_domain_rd(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)

In other words, I believe (perhaps incorrectly) that for_each_domain()
can be called either within an RCU-sched read-side critical section or
with sched_domains_mutex held.  Lockdep claims that no locks of any
kind, RCU or otherwise, were held.  I considered the possibility that
this was an initialization-time thing, but the code traverses CPU
structures rather than task structures.

One other possibility is that this is safe due to the fact that we are
booting up, before the second CPU has come online.  Are you relying on
this?

For reference, here is the definition of rcu_read_lock_sched_held():

static inline int rcu_read_lock_sched_held(void)
{
	int lockdep_opinion = 0;

	if (debug_locks)
		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
	return lockdep_opinion || preempt_count() != 0;
}

Help?

							Thanx, Paul

==============================================
[ BUG: Unsafe rcu_dereference_check() usage! ]
----------------------------------------------
kernel/sched_fair.c:1464 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

no locks held by swapper/0.

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.33-rc7-autokern1 #1
Call Trace:
 [<ffffffff81060c30>] lockdep_rcu_dereference+0x8a/0x92
 [<ffffffff81033ec4>] select_task_rq_fair+0xc1/0x686
 [<ffffffff8105173d>] ? __task_pid_nr_ns+0x0/0xb2
 [<ffffffff810353f4>] wake_up_new_task+0x1e/0x13e
 [<ffffffff8105173d>] ? __task_pid_nr_ns+0x0/0xb2
 [<ffffffff810389a2>] do_fork+0x2ad/0x329
 [<ffffffff8152c7ae>] ? kernel_init+0x0/0x199
 [<ffffffff81009cc3>] kernel_thread+0x7d/0x8d
 [<ffffffff8152c7ae>] ? kernel_init+0x0/0x199
 [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
 [<ffffffff81033513>] ? nr_context_switches+0x3f/0x51
 [<ffffffff812e4aad>] rest_init+0x21/0xc2
 [<ffffffff8152ccc9>] start_kernel+0x382/0x38f
 [<ffffffff8152c299>] x86_64_start_reservations+0xa9/0xad
 [<ffffffff8152c383>] x86_64_start_kernel+0xe6/0xed
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5440  @ 2.83GHz stepping 06
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1lockdep: fixing up alternatives.
 #2lockdep: fixing up alternatives.
 #3lockdep: fixing up alternatives.
 #4lockdep: fixing up alternatives.
 #5lockdep: fixing up alternatives.
 #6lockdep: fixing up alternatives.
 #7 Ok.
Brought up 8 CPUs
Total of 8 processors activated (45335.31 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
