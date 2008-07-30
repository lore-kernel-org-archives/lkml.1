Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYG3BoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYG3BoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYG3Bny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:43:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYG3Bnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:43:52 -0400
Message-Id: <20080730014351.037013056@goodmis.org>
References: <20080730012939.885172468@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 21:29:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 3/5] ftrace: do not trace nmi callers in RCU
Content-Disposition: inline; filename=ftrace-no-trace-rcu-nmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic ftrace code performs run time modification of the code text
section. This is not safe to do unless all other CPUS are halted. Because
there is no good way to halt NMIs while doing the modification, we must
make sure that the NMIs will not execute code that will be modified.

This patch adds notrace annotation to functions called by NMIs in RCU.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupreempt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-tip.git/kernel/rcupreempt.c
===================================================================
--- linux-tip.git.orig/kernel/rcupreempt.c	2008-07-29 20:12:05.000000000 -0400
+++ linux-tip.git/kernel/rcupreempt.c	2008-07-29 20:13:52.000000000 -0400
@@ -240,7 +240,7 @@ long rcu_batches_completed(void)
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
-void __rcu_read_lock(void)
+notrace void __rcu_read_lock(void)
 {
 	int idx;
 	struct task_struct *t = current;
@@ -306,7 +306,7 @@ void __rcu_read_lock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
 
-void __rcu_read_unlock(void)
+notrace void __rcu_read_unlock(void)
 {
 	int idx;
 	struct task_struct *t = current;
@@ -448,7 +448,7 @@ static DEFINE_PER_CPU(int, rcu_update_fl
  * rcu_dyntick_sched.dynticks to let the RCU handling know that the
  * CPU is active.
  */
-void rcu_irq_enter(void)
+notrace void rcu_irq_enter(void)
 {
 	int cpu = smp_processor_id();
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
@@ -518,7 +518,7 @@ void rcu_irq_enter(void)
  * rcu_dyntick_sched.dynticks to put let the RCU handling be
  * aware that the CPU is going back to idle with no ticks.
  */
-void rcu_irq_exit(void)
+notrace void rcu_irq_exit(void)
 {
 	int cpu = smp_processor_id();
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);

-- 
