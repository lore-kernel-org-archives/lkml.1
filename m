Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYDNEBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYDNEBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYDNEB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:01:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58702 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYDNEB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:01:28 -0400
Date: Sun, 13 Apr 2008 21:01:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: [PATCH 2/5] Add memory barriers and comments to rcu_check_callbacks()
Message-ID: <20080414040119.GB30495@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080414035848.GA30005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414035848.GA30005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments to the logic that infers quiescent states when interrupting
from either user mode or the idle loop.  Also add a memory barrier: it
appears that James Huang was in fact onto something, as the scheduler
is much less synchronization happy than it once was, so we can no longer
rely on its memory barriers in all cases.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: James Huang <jamesclhuang@yahoo.com>
---

 rcuclassic.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.25-rc6-C1-call_rcu_sched/kernel/rcuclassic.c linux-2.6.25-rc6-C2-rcuclassic-fixes/kernel/rcuclassic.c
--- linux-2.6.25-rc6-C1-call_rcu_sched/kernel/rcuclassic.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-C2-rcuclassic-fixes/kernel/rcuclassic.c	2008-04-08 09:30:16.000000000 -0700
@@ -502,10 +502,38 @@ void rcu_check_callbacks(int cpu, int us
 	if (user ||
 	    (idle_cpu(cpu) && !in_softirq() &&
 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+
+		/*
+		 * Get here if this CPU took its interrupt from user
+		 * mode or from the idle loop, and if this is not a
+		 * nested interrupt.  In this case, the CPU is in
+		 * a quiescent state, so count it.
+		 *
+		 * Also do a memory barrier.  This is needed to handle
+		 * the case where writes from a preempt-disable section
+		 * of code get reordered into schedule() by this CPU's
+		 * write buffer.  The memory barrier makes sure that
+		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
+		 * by other CPUs to happen after any such write.
+		 */
+
+		smp_mb();  /* See above block comment. */
 		rcu_qsctr_inc(cpu);
 		rcu_bh_qsctr_inc(cpu);
-	} else if (!in_softirq())
+
+	} else if (!in_softirq()) {
+
+		/*
+		 * Get here if this CPU did not take its interrupt from
+		 * softirq, in other words, if it is not interrupting
+		 * a rcu_bh read-side critical section.  This is an _bh
+		 * critical section, so count it.  The memory barrier
+		 * is needed for the same reason as is the above one.
+		 */
+
+		smp_mb();  /* See above block comment. */
 		rcu_bh_qsctr_inc(cpu);
+	}
 	raise_rcu_softirq();
 }
 
