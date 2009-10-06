Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbZJGCFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbZJGCFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933067AbZJGCFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:05:16 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43313 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933903AbZJGCFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:05:13 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091006233731.604034035@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:37:05 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 11/19] RCU: Use this_cpu operations
Content-Disposition: inline; filename=this_cpu_rcu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU does not do dynamic allocations but it increments per cpu variables
a lot. These instructions results in a move to a register and then back
to memory. This patch will make it use the inc/dec instructions on x86
that do not need a register.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 kernel/rcutorture.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c	2009-09-28 10:08:10.000000000 -0500
+++ linux-2.6/kernel/rcutorture.c	2009-09-29 09:02:00.000000000 -0500
@@ -731,13 +731,13 @@ static void rcu_torture_timer(unsigned l
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
@@ -786,13 +786,13 @@ rcu_torture_reader(void *arg)
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

-- 
