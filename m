Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbZFEThS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbZFEThS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZFEThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:37:04 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:51318 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754114AbZFEThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:37:03 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191852.373830111@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:30 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 11/11] RCU: Use this_cpu operations
Content-Disposition: inline; filename=this_cpu_rcu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU does not do dynamic allocations but it increments per cpu variables
a lot. These instructions results in a move to a register and then back
to memory. This patch will make it use the inc/dec instructions on x86
that do not need a register.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 kernel/rcupreempt.c |    4 ++--
 kernel/rcutorture.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c	2009-06-04 14:26:42.000000000 -0500
+++ linux-2.6/kernel/rcutorture.c	2009-06-04 14:38:05.000000000 -0500
@@ -709,13 +709,13 @@ static void rcu_torture_timer(unsigned l
 		/* Should not happen, but... */
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
-	++__get_cpu_var(rcu_torture_count)[pipe_count];
+	__this_cpu_inc(per_cpu_var(rcu_torture_count)[pipe_count]);
 	completed = cur_ops->completed() - completed;
 	if (completed > RCU_TORTURE_PIPE_LEN) {
 		/* Should not happen, but... */
 		completed = RCU_TORTURE_PIPE_LEN;
 	}
-	++__get_cpu_var(rcu_torture_batch)[completed];
+	__this_cpu_inc(per_cpu_var(rcu_torture_batch)[completed]);
 	preempt_enable();
 	cur_ops->readunlock(idx);
 }
@@ -764,13 +764,13 @@ rcu_torture_reader(void *arg)
 			/* Should not happen, but... */
 			pipe_count = RCU_TORTURE_PIPE_LEN;
 		}
-		++__get_cpu_var(rcu_torture_count)[pipe_count];
+		__this_cpu_inc(per_cpu_var(rcu_torture_count)[pipe_count]);
 		completed = cur_ops->completed() - completed;
 		if (completed > RCU_TORTURE_PIPE_LEN) {
 			/* Should not happen, but... */
 			completed = RCU_TORTURE_PIPE_LEN;
 		}
-		++__get_cpu_var(rcu_torture_batch)[completed];
+		__this_cpu_inc(per_cpu_var(rcu_torture_batch)[completed]);
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
Index: linux-2.6/kernel/rcupreempt.c
===================================================================
--- linux-2.6.orig/kernel/rcupreempt.c	2009-06-04 14:28:53.000000000 -0500
+++ linux-2.6/kernel/rcupreempt.c	2009-06-04 14:39:35.000000000 -0500
@@ -173,7 +173,7 @@ void rcu_enter_nohz(void)
 	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
 
 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	__this_cpu_inc(per_cpu_var(rcu_dyntick_sched).dynticks);
 	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
 }
 
@@ -181,7 +181,7 @@ void rcu_exit_nohz(void)
 {
 	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
 
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	__this_cpu_inc(per_cpu_var(rcu_dyntick_sched).dynticks);
 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
 				&rs);

-- 
