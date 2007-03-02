Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXCBVdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXCBVdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030177AbXCBVdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:33:52 -0500
Received: from mga05.intel.com ([192.55.52.89]:22766 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965673AbXCBVdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:33:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,244,1170662400"; 
   d="scan'208"; a="206099001:sNHT29230131"
Date: Fri, 2 Mar 2007 12:57:29 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.21-rc2-mm1: what about CONFIG_NO_HZ and !CONFIG_SMP ?
Message-ID: <20070302125729.A27368@unix-os.sc.intel.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <45E89339.1050504@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <45E89339.1050504@free.fr>; from laurent.riffard@free.fr on Fri, Mar 02, 2007 at 10:12:25PM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 10:12:25PM +0100, Laurent Riffard wrote:
> Le 02.03.2007 12:00, Andrew Morton a écrit :
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> 
> Got this when CONFIG_NO_HZ=y and CONFIG_SMP=n:
> 
>   CC      kernel/sched.o
> kernel/sched.c: In function 'trigger_load_balance':
> kernel/sched.c:3384: error: 'struct rq' has no member named 'in_nohz_recently'
> kernel/sched.c:3384: error: 'struct rq' has no member named 'idle_at_tick'
> kernel/sched.c:3385: error: 'struct rq' has no member named 'in_nohz_recently'
> kernel/sched.c:3387: error: 'nohz' undeclared (first use in this function)
> kernel/sched.c:3387: error: (Each undeclared identifier is reported only once
> kernel/sched.c:3387: error: for each function it appears in.)
> kernel/sched.c:3404: warning: implicit declaration of function 'resched_cpu'
> kernel/sched.c:3412: error: 'struct rq' has no member named 'idle_at_tick'
> kernel/sched.c:3422: error: 'struct rq' has no member named 'idle_at_tick'
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 
> Looking at kernel/sched.c, it seems CONFIG_NO_HZ should depend on CONFIG_SMP...

No. There is no such dependency. Can you please check if the below patch fixes
the compilation issue. Thanks.

---

Move trigger_load_balance() under ifdef CONFIG_SMP.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff -pNru linux-2.6.21-rc2/kernel/sched.c linux-mm/kernel/sched.c
--- linux-2.6.21-rc2/kernel/sched.c	2007-03-02 13:23:46.000000000 -0800
+++ linux-mm/kernel/sched.c	2007-03-02 13:26:38.000000000 -0800
@@ -3156,6 +3156,68 @@ static void run_rebalance_domains(struct
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
@@ -3366,68 +3428,6 @@ out_unlock:
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
