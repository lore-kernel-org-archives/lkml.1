Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbXKQRk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbXKQRk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXKQRkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:40:16 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:51094 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755466AbXKQRkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:40:13 -0500
Message-Id: <473EE01F.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Sat, 17 Nov 2007 12:35:43 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH v3 10/17] Remove some CFS specific code from the
	wakeup path of RT tasks
References: <20071117062104.177779113@goodmis.org>
 <20071117062404.672976284@goodmis.org>
In-Reply-To: <20071117062404.672976284@goodmis.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part496F3C7F.5__="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=__Part496F3C7F.5__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>>> On Sat, Nov 17, 2007 at  1:21 AM, in message
<20071117062404.672976284@goodmis.org>, Steven Rostedt <rostedt@goodmis.org=
>
wrote:=20

> -/*
> - * wake_idle() will wake a task on an idle cpu if task->cpu is
> - * not idle and an idle cpu is available.  The span of cpus to
> - * search starts with cpus closest then further out as needed,
> - * so we always favor a closer, idle cpu.
> - *
> - * Returns the CPU we should wake onto.
> - */
> -#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
> -static int wake_idle(int cpu, struct task_struct *p)
> -{
> -	cpumask_t tmp;
> -	struct sched_domain *sd;
> -	int i;
> -
> -	/*
> -	 * If it is idle, then it is the best cpu to run this task.
> -	 *
> -	 * This cpu is also the best, if it has more than one task =
already.
> -	 * Siblings must be also busy(in most cases) as they didn't =
already
> -	 * pickup the extra load from this cpu and hence we need not check
> -	 * sibling runqueue info. This will avoid the checks and cache =
miss
> -	 * penalities associated with that.
> -	 */
> -	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
> -		return cpu;
> -
> -	for_each_domain(cpu, sd) {
> -		if (sd->flags & SD_WAKE_IDLE) {
> -			cpus_and(tmp, sd->span, p->cpus_allowed);
> -			for_each_cpu_mask(i, tmp) {
> -				if (idle_cpu(i)) {
> -					if (i !=3D task_cpu(p)) {
> -						schedstat_inc(p,
> -							se.nr_wakeups_idle)=
;
                                                                           =
               ^^^^^^^^^^^^^^^^^^^^^

[...]


> --- linux-compile.git.orig/kernel/sched_fair.c	2007-11-16 =
11:16:38.000000000 -0500
> +++ linux-compile.git/kernel/sched_fair.c	2007-11-16 22:23:39.0000000=
00 -0500
> @@ -564,6 +564,137 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
>  }
> =20
>  /*
> + * wake_idle() will wake a task on an idle cpu if task->cpu is
> + * not idle and an idle cpu is available.  The span of cpus to
> + * search starts with cpus closest then further out as needed,
> + * so we always favor a closer, idle cpu.
> + *
> + * Returns the CPU we should wake onto.
> + */
> +#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
> +static int wake_idle(int cpu, struct task_struct *p)
> +{
> +	cpumask_t tmp;
> +	struct sched_domain *sd;
> +	int i;
> +
> +	/*
> +	 * If it is idle, then it is the best cpu to run this task.
> +	 *
> +	 * This cpu is also the best, if it has more than one task =
already.
> +	 * Siblings must be also busy(in most cases) as they didn't =
already
> +	 * pickup the extra load from this cpu and hence we need not check
> +	 * sibling runqueue info. This will avoid the checks and cache =
miss
> +	 * penalities associated with that.
> +	 */
> +	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
> +		return cpu;
> +
> +	for_each_domain(cpu, sd) {
> +		if (sd->flags & SD_WAKE_IDLE) {
> +			cpus_and(tmp, sd->span, p->cpus_allowed);
> +			for_each_cpu_mask(i, tmp) {
> +				if (idle_cpu(i))
> +					return i;
                                                                        =
^^^^^^^^^^^^^^^^

Looks like some stuff that was added in 24 was inadvertently lost in the =
move when you merged the patches up from 23.1-rt11.  The attached patch is =
updated to move the new logic as well.

Regards,
-Greg
                                   =20


--=__Part496F3C7F.5__=
Content-Type: text/plain; name="sched-de-cfsize-rt-path.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="sched-de-cfsize-rt-path.patch"

RT: Remove some CFS specific code from the wakeup path of RT tasks

From: Gregory Haskins <ghaskins@novell.com>

The current wake-up code path tries to determine if it can optimize the
wake-up to "this_cpu" by computing load calculations.  The problem is that
these calculations are only relevant to CFS tasks where load is king.  For =
RT
tasks, priority is king.  So the load calculation is completely wasted
bandwidth.

Therefore, we create a new sched_class interface to help with
pre-wakeup routing decisions and move the load calculation as a function
of CFS task's class.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h   |    1=20
 kernel/sched.c          |  167 ++++++++-----------------------------------=
----
 kernel/sched_fair.c     |  148 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_idletask.c |    9 +++
 kernel/sched_rt.c       |   10 +++
 5 files changed, 195 insertions(+), 140 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e9e74de..253517b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -823,6 +823,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int =
wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int =
sleep);
 	void (*yield_task) (struct rq *rq);
+	int  (*select_task_rq)(struct task_struct *p, int sync);
=20
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
=20
diff --git a/kernel/sched.c b/kernel/sched.c
index f089f41..bb92ec4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -861,6 +861,13 @@ iter_move_one_task(struct rq *this_rq, int this_cpu, =
struct rq *busiest,
 		   struct rq_iterator *iterator);
 #endif
=20
+#ifdef CONFIG_SMP
+static unsigned long source_load(int cpu, int type);
+static unsigned long target_load(int cpu, int type);
+static unsigned long cpu_avg_load_per_task(int cpu);
+static int task_hot(struct task_struct *p, u64 now, struct sched_domain =
*sd);
+#endif /* CONFIG_SMP */
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -1040,7 +1047,7 @@ static inline void __set_task_cpu(struct task_struct =
*p, unsigned int cpu)
 /*
  * Is this task likely cache-hot:
  */
-static inline int
+static int
 task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 {
 	s64 delta;
@@ -1265,7 +1272,7 @@ static unsigned long target_load(int cpu, int type)
 /*
  * Return the average load per task on the cpu's run queue
  */
-static inline unsigned long cpu_avg_load_per_task(int cpu)
+static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq =3D cpu_rq(cpu);
 	unsigned long total =3D weighted_cpuload(cpu);
@@ -1422,58 +1429,6 @@ static int sched_balance_self(int cpu, int flag)
=20
 #endif /* CONFIG_SMP */
=20
-/*
- * wake_idle() will wake a task on an idle cpu if task->cpu is
- * not idle and an idle cpu is available.  The span of cpus to
- * search starts with cpus closest then further out as needed,
- * so we always favor a closer, idle cpu.
- *
- * Returns the CPU we should wake onto.
- */
-#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
-static int wake_idle(int cpu, struct task_struct *p)
-{
-	cpumask_t tmp;
-	struct sched_domain *sd;
-	int i;
-
-	/*
-	 * If it is idle, then it is the best cpu to run this task.
-	 *
-	 * This cpu is also the best, if it has more than one task =
already.
-	 * Siblings must be also busy(in most cases) as they didn't =
already
-	 * pickup the extra load from this cpu and hence we need not check
-	 * sibling runqueue info. This will avoid the checks and cache =
miss
-	 * penalities associated with that.
-	 */
-	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
-		return cpu;
-
-	for_each_domain(cpu, sd) {
-		if (sd->flags & SD_WAKE_IDLE) {
-			cpus_and(tmp, sd->span, p->cpus_allowed);
-			for_each_cpu_mask(i, tmp) {
-				if (idle_cpu(i)) {
-					if (i !=3D task_cpu(p)) {
-						schedstat_inc(p,
-							se.nr_wakeups_idle)=
;
-					}
-					return i;
-				}
-			}
-		} else {
-			break;
-		}
-	}
-	return cpu;
-}
-#else
-static inline int wake_idle(int cpu, struct task_struct *p)
-{
-	return cpu;
-}
-#endif
-
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -1495,8 +1450,6 @@ static int try_to_wake_up(struct task_struct *p, =
unsigned int state, int sync)
 	long old_state;
 	struct rq *rq;
 #ifdef CONFIG_SMP
-	struct sched_domain *sd, *this_sd =3D NULL;
-	unsigned long load, this_load;
 	int new_cpu;
 #endif
=20
@@ -1516,90 +1469,7 @@ static int try_to_wake_up(struct task_struct *p, =
unsigned int state, int sync)
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
=20
-	new_cpu =3D cpu;
-
-	schedstat_inc(rq, ttwu_count);
-	if (cpu =3D=3D this_cpu) {
-		schedstat_inc(rq, ttwu_local);
-		goto out_set_cpu;
-	}
-
-	for_each_domain(this_cpu, sd) {
-		if (cpu_isset(cpu, sd->span)) {
-			schedstat_inc(sd, ttwu_wake_remote);
-			this_sd =3D sd;
-			break;
-		}
-	}
-
-	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
-		goto out_set_cpu;
-
-	/*
-	 * Check for affine wakeup and passive balancing possibilities.
-	 */
-	if (this_sd) {
-		int idx =3D this_sd->wake_idx;
-		unsigned int imbalance;
-
-		imbalance =3D 100 + (this_sd->imbalance_pct - 100) / 2;
-
-		load =3D source_load(cpu, idx);
-		this_load =3D target_load(this_cpu, idx);
-
-		new_cpu =3D this_cpu; /* Wake to this CPU if we can */
-
-		if (this_sd->flags & SD_WAKE_AFFINE) {
-			unsigned long tl =3D this_load;
-			unsigned long tl_per_task;
-
-			/*
-			 * Attract cache-cold tasks on sync wakeups:
-			 */
-			if (sync && !task_hot(p, rq->clock, this_sd))
-				goto out_set_cpu;
-
-			schedstat_inc(p, se.nr_wakeups_affine_attempts);
-			tl_per_task =3D cpu_avg_load_per_task(this_cpu);
-
-			/*
-			 * If sync wakeup then subtract the (maximum =
possible)
-			 * effect of the currently running task from the =
load
-			 * of the current CPU:
-			 */
-			if (sync)
-				tl -=3D current->se.load.weight;
-
-			if ((tl <=3D load &&
-				tl + target_load(cpu, idx) <=3D tl_per_task=
) ||
-			       100*(tl + p->se.load.weight) <=3D imbalance*=
load) {
-				/*
-				 * This domain has SD_WAKE_AFFINE and
-				 * p is cache cold in this domain, and
-				 * there is no bad imbalance.
-				 */
-				schedstat_inc(this_sd, ttwu_move_affine);
-				schedstat_inc(p, se.nr_wakeups_affine);
-				goto out_set_cpu;
-			}
-		}
-
-		/*
-		 * Start passive balancing when half the imbalance_pct
-		 * limit is reached.
-		 */
-		if (this_sd->flags & SD_WAKE_BALANCE) {
-			if (imbalance*this_load <=3D 100*load) {
-				schedstat_inc(this_sd, ttwu_move_balance);
-				schedstat_inc(p, se.nr_wakeups_passive);
-				goto out_set_cpu;
-			}
-		}
-	}
-
-	new_cpu =3D cpu; /* Could not wake to this_cpu. Wake to cpu =
instead */
-out_set_cpu:
-	new_cpu =3D wake_idle(new_cpu, p);
+	new_cpu =3D p->sched_class->select_task_rq(p, sync);
 	if (new_cpu !=3D cpu) {
 		set_task_cpu(p, new_cpu);
 		task_rq_unlock(rq, &flags);
@@ -1615,6 +1485,23 @@ out_set_cpu:
 		cpu =3D task_cpu(p);
 	}
=20
+#ifdef CONFIG_SCHEDSTATS
+	schedstat_inc(rq, ttwu_count);
+	if (cpu =3D=3D this_cpu)
+		schedstat_inc(rq, ttwu_local);
+	else {
+		struct sched_domain *sd;
+		for_each_domain(this_cpu, sd) {
+			if (cpu_isset(cpu, sd->span)) {
+				schedstat_inc(sd, ttwu_wake_remote);
+				break;
+			}
+		}
+	}
+
+#endif
+
+
 out_activate:
 #endif /* CONFIG_SMP */
 	schedstat_inc(p, se.nr_wakeups);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d3c0307..9e30c96 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -830,6 +830,151 @@ static void yield_task_fair(struct rq *rq)
 }
=20
 /*
+ * wake_idle() will wake a task on an idle cpu if task->cpu is
+ * not idle and an idle cpu is available.  The span of cpus to
+ * search starts with cpus closest then further out as needed,
+ * so we always favor a closer, idle cpu.
+ *
+ * Returns the CPU we should wake onto.
+ */
+#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
+static int wake_idle(int cpu, struct task_struct *p)
+{
+	cpumask_t tmp;
+	struct sched_domain *sd;
+	int i;
+
+	/*
+	 * If it is idle, then it is the best cpu to run this task.
+	 *
+	 * This cpu is also the best, if it has more than one task =
already.
+	 * Siblings must be also busy(in most cases) as they didn't =
already
+	 * pickup the extra load from this cpu and hence we need not check
+	 * sibling runqueue info. This will avoid the checks and cache =
miss
+	 * penalities associated with that.
+	 */
+	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
+		return cpu;
+
+	for_each_domain(cpu, sd) {
+		if (sd->flags & SD_WAKE_IDLE) {
+			cpus_and(tmp, sd->span, p->cpus_allowed);
+			for_each_cpu_mask(i, tmp) {
+				if (idle_cpu(i)) {
+					if (i !=3D task_cpu(p)) {
+						schedstat_inc(p,
+						       se.nr_wakeups_idle);=

+					}
+					return i;
+				}
+			}
+		} else {
+			break;
+		}
+	}
+	return cpu;
+}
+#else
+static inline int wake_idle(int cpu, struct task_struct *p)
+{
+	return cpu;
+}
+#endif
+
+#ifdef CONFIG_SMP
+static int select_task_rq_fair(struct task_struct *p, int sync)
+{
+	int cpu, this_cpu;
+	struct rq *rq;
+	struct sched_domain *sd, *this_sd =3D NULL;
+	int new_cpu;
+
+	cpu      =3D task_cpu(p);
+	rq       =3D task_rq(p);
+	this_cpu =3D smp_processor_id();
+	new_cpu  =3D cpu;
+
+	for_each_domain(this_cpu, sd) {
+		if (cpu_isset(cpu, sd->span)) {
+			this_sd =3D sd;
+			break;
+		}
+	}
+
+	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
+		goto out_set_cpu;
+
+	/*
+	 * Check for affine wakeup and passive balancing possibilities.
+	 */
+	if (this_sd) {
+		int idx =3D this_sd->wake_idx;
+		unsigned int imbalance;
+		unsigned long load, this_load;
+
+		imbalance =3D 100 + (this_sd->imbalance_pct - 100) / 2;
+
+		load =3D source_load(cpu, idx);
+		this_load =3D target_load(this_cpu, idx);
+
+		new_cpu =3D this_cpu; /* Wake to this CPU if we can */
+
+		if (this_sd->flags & SD_WAKE_AFFINE) {
+			unsigned long tl =3D this_load;
+			unsigned long tl_per_task;
+
+			/*
+			 * Attract cache-cold tasks on sync wakeups:
+			 */
+			if (sync && !task_hot(p, rq->clock, this_sd))
+				goto out_set_cpu;
+
+			schedstat_inc(p, se.nr_wakeups_affine_attempts);
+			tl_per_task =3D cpu_avg_load_per_task(this_cpu);
+
+			/*
+			 * If sync wakeup then subtract the (maximum =
possible)
+			 * effect of the currently running task from the =
load
+			 * of the current CPU:
+			 */
+			if (sync)
+				tl -=3D current->se.load.weight;
+
+			if ((tl <=3D load &&
+				tl + target_load(cpu, idx) <=3D tl_per_task=
) ||
+			       100*(tl + p->se.load.weight) <=3D imbalance*=
load) {
+				/*
+				 * This domain has SD_WAKE_AFFINE and
+				 * p is cache cold in this domain, and
+				 * there is no bad imbalance.
+				 */
+				schedstat_inc(this_sd, ttwu_move_affine);
+				schedstat_inc(p, se.nr_wakeups_affine);
+				goto out_set_cpu;
+			}
+		}
+
+		/*
+		 * Start passive balancing when half the imbalance_pct
+		 * limit is reached.
+		 */
+		if (this_sd->flags & SD_WAKE_BALANCE) {
+			if (imbalance*this_load <=3D 100*load) {
+				schedstat_inc(this_sd, ttwu_move_balance);
+				schedstat_inc(p, se.nr_wakeups_passive);
+				goto out_set_cpu;
+			}
+		}
+	}
+
+	new_cpu =3D cpu; /* Could not wake to this_cpu. Wake to cpu =
instead */
+out_set_cpu:
+	return wake_idle(new_cpu, p);
+}
+#endif /* CONFIG_SMP */
+
+
+/*
  * Preempt the current task with a newly woken task if needed:
  */
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
@@ -1102,6 +1247,9 @@ static const struct sched_class fair_sched_class =3D =
{
 	.enqueue_task		=3D enqueue_task_fair,
 	.dequeue_task		=3D dequeue_task_fair,
 	.yield_task		=3D yield_task_fair,
+#ifdef CONFIG_SMP
+	.select_task_rq		=3D select_task_rq_fair,
+#endif /* CONFIG_SMP */
=20
 	.check_preempt_curr	=3D check_preempt_wakeup,
=20
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index bf9c25c..ca53748 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -5,6 +5,12 @@
  *  handled in sched_fair.c)
  */
=20
+#ifdef CONFIG_SMP
+static int select_task_rq_idle(struct task_struct *p, int sync)
+{
+	return task_cpu(p); /* IDLE tasks as never migrated */
+}
+#endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
  */
@@ -72,6 +78,9 @@ const struct sched_class idle_sched_class =3D {
=20
 	/* dequeue is not valid, we print a debug message there: */
 	.dequeue_task		=3D dequeue_task_idle,
+#ifdef CONFIG_SMP
+	.select_task_rq		=3D select_task_rq_idle,
+#endif /* CONFIG_SMP */
=20
 	.check_preempt_curr	=3D check_preempt_curr_idle,
=20
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 4a469c5..0e408dc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -147,6 +147,13 @@ yield_task_rt(struct rq *rq)
 	requeue_task_rt(rq, rq->curr);
 }
=20
+#ifdef CONFIG_SMP
+static int select_task_rq_rt(struct task_struct *p, int sync)
+{
+	return task_cpu(p);
+}
+#endif /* CONFIG_SMP */
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -669,6 +676,9 @@ const struct sched_class rt_sched_class =3D {
 	.enqueue_task		=3D enqueue_task_rt,
 	.dequeue_task		=3D dequeue_task_rt,
 	.yield_task		=3D yield_task_rt,
+#ifdef CONFIG_SMP
+	.select_task_rq		=3D select_task_rq_rt,
+#endif /* CONFIG_SMP */
=20
 	.check_preempt_curr	=3D check_preempt_curr_rt,
=20

--=__Part496F3C7F.5__=--
