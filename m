Return-Path: <linux-kernel-owner+w=401wt.eu-S1751233AbXCCH7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbXCCH7w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXCCH7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:59:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57732 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbXCCH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:59:51 -0500
Date: Fri, 2 Mar 2007 23:59:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1 - build error with CONFIG_NO_HZ=y and
 CONFIG_SMP=n
Message-Id: <20070302235948.a0ffb865.akpm@linux-foundation.org>
In-Reply-To: <1172907952.3088.3.camel@daplas>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<1172907952.3088.3.camel@daplas>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 15:45:52 +0800 "Antonino A. Daplas" <adaplas@gmail.com> wrote:

> On Fri, 2007-03-02 at 03:00 -0800, Andrew Morton wrote:
> 
> I get this with CONFIG_NO_HZ=y, CONFIG_SMP=n
> 
> kernel/sched.c: In function ‘trigger_load_balance’:
> kernel/sched.c:3384: error: ‘struct rq’ has no member named
> ‘in_nohz_recently’
> kernel/sched.c:3384: error: ‘struct rq’ has no member named
> ‘idle_at_tick’
> kernel/sched.c:3385: error: ‘struct rq’ has no member named
> ‘in_nohz_recently’
> kernel/sched.c:3387: error: ‘nohz’ undeclared (first use in this
> function)
> kernel/sched.c:3387: error: (Each undeclared identifier is reported only
> once
> kernel/sched.c:3387: error: for each function it appears in.)
> kernel/sched.c:3404: warning: implicit declaration of function
> ‘resched_cpu’
> kernel/sched.c:3412: error: ‘struct rq’ has no member named
> ‘idle_at_tick’
> kernel/sched.c:3422: error: ‘struct rq’ has no member named
> ‘idle_at_tick’
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 

You'll need this:

From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Move trigger_load_balance() under ifdef CONFIG_SMP.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |  124 +++++++++++++++++++++++------------------------
 1 files changed, 62 insertions(+), 62 deletions(-)

diff -puN kernel/sched.c~sched-dynticks-idle-load-balancing-v3-fix kernel/sched.c
--- a/kernel/sched.c~sched-dynticks-idle-load-balancing-v3-fix
+++ a/kernel/sched.c
@@ -3130,6 +3130,68 @@ static void run_rebalance_domains(struct
 	}
 #endif
 }
+
+/*
+ * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
+ *
+ * In case of CONFIG_NO_HZ, this is the place where we nominate a new
+ * idle load balancing owner or decide to stop the periodic load balancing,
+ * if the whole system is idle.
+ */
+static inline void trigger_load_balance(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If we were in the nohz mode recently and busy at the current
+	 * scheduler tick, then check if we need to nominate new idle
+	 * load balancer.
+	 */
+	if (rq->in_nohz_recently && !rq->idle_at_tick) {
+		rq->in_nohz_recently = 0;
+
+		if (atomic_read(&nohz.load_balancer) == cpu) {
+			cpu_clear(cpu, nohz.cpu_mask);
+			atomic_set(&nohz.load_balancer, -1);
+		}
+
+		if (atomic_read(&nohz.load_balancer) == -1) {
+			/*
+			 * simple selection for now: Nominate the
+			 * first cpu in the nohz list to be the next
+			 * ilb owner.
+			 *
+			 * TBD: Traverse the sched domains and nominate
+			 * the nearest cpu in the nohz.cpu_mask.
+			 */
+			int ilb = first_cpu(nohz.cpu_mask);
+
+			if (ilb != NR_CPUS)
+				resched_cpu(ilb);
+		}
+	}
+
+	/*
+	 * If this cpu is idle and doing idle load balancing for all the
+	 * cpus with ticks stopped, is it time for that to stop?
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
+	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+		resched_cpu(cpu);
+		return;
+	}
+
+	/*
+	 * If this cpu is idle and the idle load balancing is done by
+	 * someone else, then no need raise the SCHED_SOFTIRQ
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
+	    cpu_isset(cpu, nohz.cpu_mask))
+		return;
+#endif
+	if (time_after_eq(jiffies, rq->next_balance))
+		raise_softirq(SCHED_SOFTIRQ);
+}
 #else
 /*
  * on UP we do not need to balance between CPUs:
@@ -3340,68 +3402,6 @@ out_unlock:
 }
 
 /*
- * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
- *
- * In case of CONFIG_NO_HZ, this is the place where we nominate a new
- * idle load balancing owner or decide to stop the periodic load balancing,
- * if the whole system is idle.
- */
-static inline void trigger_load_balance(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If we were in the nohz mode recently and busy at the current
-	 * scheduler tick, then check if we need to nominate new idle
-	 * load balancer.
-	 */
-	if (rq->in_nohz_recently && !rq->idle_at_tick) {
-		rq->in_nohz_recently = 0;
-
-		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpu_clear(cpu, nohz.cpu_mask);
-			atomic_set(&nohz.load_balancer, -1);
-		}
-
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			/*
-			 * simple selection for now: Nominate the
-			 * first cpu in the nohz list to be the next
-			 * ilb owner.
-			 *
-			 * TBD: Traverse the sched domains and nominate
-			 * the nearest cpu in the nohz.cpu_mask.
-			 */
-			int ilb = first_cpu(nohz.cpu_mask);
-
-			if (ilb != NR_CPUS)
-				resched_cpu(ilb);
-		}
-	}
-
-	/*
-	 * If this cpu is idle and doing idle load balancing for all the
-	 * cpus with ticks stopped, is it time for that to stop?
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
-		resched_cpu(cpu);
-		return;
-	}
-
-	/*
-	 * If this cpu is idle and the idle load balancing is done by
-	 * someone else, then no need raise the SCHED_SOFTIRQ
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpu_isset(cpu, nohz.cpu_mask))
-		return;
-#endif
-	if (time_after_eq(jiffies, rq->next_balance))
-		raise_softirq(SCHED_SOFTIRQ);
-}
-
-/*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
  *
_

