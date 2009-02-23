Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZBWGIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZBWGIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 01:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZBWGIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 01:08:04 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51807 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZBWGIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 01:08:01 -0500
Date: Sun, 22 Feb 2009 21:17:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223051709.GA5990@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com> <20090221014056.GU6960@linux.vnet.ibm.com> <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com> <20090221174703.GA6860@linux.vnet.ibm.com> <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com> <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com> <20090222030030.GD6860@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222030030.GD6860@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 07:00:30PM -0800, Paul E. McKenney wrote:
> On Sat, Feb 21, 2009 at 07:37:20PM +0100, Vegard Nossum wrote:
> > 2009/2/21 Vegard Nossum <vegard.nossum@gmail.com>:

[ . . . ]

> > Okay, I don't really think it's an error. The if (user) test happens
> > at the very beginning and gcc decides to reuse %edx. GDB doesn't know
> > this, so it thinks the parameter changed, but at this point the
> > parameter simply won't be used anymore.
> > 
> > So you're right: The value can't be trusted (after entry, anyway).
> 
> OK.  So at least the compiler is sane.  ;-)
> 
> And the fact that RCU Classic behaves the same as hierarchical RCU
> pretty clearly points at some issue with the quiescent-state check code:
> 
> void rcu_check_callbacks(int cpu, int user)
> {
> 	if (user ||
> 	    (idle_cpu(cpu) && !in_softirq() &&
> 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> 		rcu_qsctr_inc(cpu);
> 		rcu_bh_qsctr_inc(cpu);
> 	} else if (!in_softirq()) {
> 		rcu_bh_qsctr_inc(cpu);
> 	}
> 	raise_softirq(RCU_SOFTIRQ);
> }
> 
> In the case you traced earlier, we interrupted out of kernel code, yet
> somehow arrived at rcu_qsctr_inc().  We know that "user" really was 0,
> thanks to your careful analysis, so the issue must be in the other
> clause.  Since we interrupted out of mainline kernel code, in_softirq()
> should have returned 0, and hardirq_count() should also have met the
> above condition.
> 
> You mentioned some concern about idle_cpu() separately, and if idle_cpu()
> was returning 1, then RCU would most certainly decide that it was in a
> quiescent state and that it could end the current grace period.

Hello, Vegard,

Could you please try out the following patch?  I am not 100% confident
of it on non-x86 architectures, nor during the time that non-boot CPUs
start up (though this patch should not break non-boot CPUs any more than
they might already be broken).

							Thanx, Paul

------------------------------------------------------------------------

The boot CPU runs in the context of its idle thread during boot-up.
During this time, idle_cpu(0) will always return nonzero, which will
fool Classic and Hierarchical RCU into deciding that a large chunk of
the boot-up sequence is a big long quiescent state.  This in turn causes
RCU to prematurely end grace periods during this time.

This patch creates a new global variable that is set to 1 just before
the boot CPU first enters the scheduler, after which the idle task
really is idle.

Located-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 init/main.c         |    3 +++
 kernel/rcuclassic.c |    4 +++-
 kernel/rcutree.c    |    4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 8442094..51f4b71 100644
--- a/init/main.c
+++ b/init/main.c
@@ -121,6 +121,8 @@ static char *static_command_line;
 static char *execute_command;
 static char *ramdisk_execute_command;
 
+int idle_task_is_really_idle;	/* set to 1 late in boot. */
+
 #ifdef CONFIG_SMP
 /* Setup configured maximum number of CPUs to activate */
 unsigned int __initdata setup_max_cpus = NR_CPUS;
@@ -463,6 +465,7 @@ static noinline void __init_refok rest_init(void)
 	 * at least once to get things moving:
 	 */
 	init_idle_bootup_task(current);
+	idle_task_is_really_idle = 1;
 	preempt_enable_no_resched();
 	schedule();
 	preempt_disable();
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index bd5a900..a758fa6 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -678,8 +678,10 @@ int rcu_needs_cpu(int cpu)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	extern int idle_task_is_really_idle;
+
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
+	    (idle_cpu(cpu) && idle_task_is_really_idle && !in_softirq() &&
 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b2fd602..e996d85 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -947,8 +947,10 @@ static void rcu_do_batch(struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	extern int idle_task_is_really_idle;
+
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
+	    (idle_cpu(cpu) && idle_task_is_really_idle && !in_softirq() &&
 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
