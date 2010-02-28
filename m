Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936579Ab0B1T0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:26:16 -0500
Received: from ms01.sssup.it ([193.205.80.99]:37103 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936463Ab0B1T0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:26:15 -0500
Subject: [RFC][PATCH 09/11] sched: first draft of deadline inheritance.
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267383976.13676.79.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LPuUWzXz+6UT+r/qvrwr"
Date: Sun, 28 Feb 2010 20:26:05 +0100
Message-ID: <1267385165.13676.99.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LPuUWzXz+6UT+r/qvrwr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Some method to deal with rt-mutexes and make sched_dl interact with
the current PI-coded is needed. The issues this raises are not at all
trivial, but a simple enough implementation is possible, avoiding
completely restructuring any of the two.
Such solution, that we are proposing here, is based on two key
concepts: (i) relative deadline inheritance, and (ii) inheriting
task's bandwidth boosting.

In some more details.

  (i) relative deadline is representative of how "urgent" each
      instance of a task is and, while executing, the absolute
      deadline --according to which all scheduling decision are
      undertaken-- is calculated right by adding such value to the
      instance activation time. Therefore, a task inheriting a
      relative deadline smaller than its original one will likely
      have a smaller absolute deadline too, which all looks very
      similar to what happens when priority inheritance (e.g.,
      because of rt-mutexes) take place among RT tasks. Moreover,
      relative deadline are meaningful on a per task basis
      independently from the CPU tasks are running on (and from
      any kind of clock synchronization issues among the different
      CPUs).
 (ii) in order of having the inheriting task finishing quickly its
      "operation" we also want it to be temporarily insensitive from
      the bandwidth enforcing mechanism, that would slow it down
      and provides another mean of priority inversion.
      It is true that this opens the door to situations during
      which the system is more loaded than we expected (and perhaps
      even oversubscribed), but if the fundamental assumption of
      these time intervals being small enough, this won't be
      anything unbearable.

This is not 100% theoretically correct solution, although some kind
of analysis can be tried. The main flaw is that it breaks the
bandwidth isolation property the sched_dl policy (also) strives for.
Different solutions exist, that do a better job in preserving such
important feature, but they're way more complicated, and their
implementation strategy is under consideration and studying.

Therefore, as of now, this patch:
 - implements priority inheritance for -deadline tasks, according to
   what described above;
 - to make this possible without rewriting outstanding chunks of
   code of both -deadline scheduling and existing PI, the task's
   relative deadline is stored in the prio field of the task_struct.
   This is done in such a way that:
    * prio is always < 0 for -deadline tasks,
    * p1->prio < p2->prio still means p1 has higher priority than
      p2, i.e., in our case, p1 has smaller relative deadline.
 - the point above means that, since prio is of int type, a relative
   deadline has to be smaller than INT_MAX. This is about 2sec,
   which is a something (we think! :-)) we can afford, at least
   for now.
 - disables bandwidth throttling for tasks while they are deadline
   boosted. It also tries to make them pay back for runtime overrun
   and deadline misses in this phase, but it's only "local", in the
   sense that instances farther than the one right next to the
   overrun are not going to be direcly affected.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |   30 ++++++++++++++++++++--
 kernel/sched.c        |   64 +++++++++++++++++++++++++++++----------------=
----
 kernel/sched_dl.c     |   57 +++++++++++++++++++++++++++++++++++++++----
 3 files changed, 116 insertions(+), 35 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 64a7df2..0b3a302 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1723,16 +1723,40 @@ static inline int rt_task(struct task_struct *p)
 	return rt_prio(p->prio);
 }
=20
-static inline int dl_policy(int policy)
+/*
+ * Relative deadline of a process is a time interval representative
+ * of how "urgent" each instance of such a process is. During actual
+ * execution the absolute deadline of the process --i.e., the value
+ * according to which all scheduling decision are undertaken-- is
+ * calculated by adding to the instance activation time the process'
+ * relative deadline.
+ * Therefore, a process that inherits a smaller relative deadline will
+ * likely have a smaller absolute deadline than its original one, which
+ * means something very similar to the priority boosting that occurs
+ * when priority inheritance (e.g., because of rt-mutexes) take place
+ * among RT tasks.
+ * Thus we can somehow treat relative deadline as priorities and have all
+ * the priority inheritance seamlessy code working even for -deadline
+ * tasks.
+ *
+ * This is how the current implementation of deadline inheritance works
+ * and, in order of this to be possible, we need that the relative deadlin=
e
+ * value can be represented on the integer field "prio" of the process'
+ * task_struct.
+ */
+
+#define MAX_SCHED_DEADLINE	INT_MAX
+
+static inline int dl_prio(int prio)
 {
-	if (unlikely(policy =3D=3D SCHED_DEADLINE))
+	if (unlikely(prio < 0))
 		return 1;
 	return 0;
 }
=20
 static inline int dl_task(struct task_struct *p)
 {
-	return dl_policy(p->policy);
+	return dl_prio(p->prio);
 }
=20
 static inline struct pid *task_pid(struct task_struct *task)
diff --git a/kernel/sched.c b/kernel/sched.c
index d5e8b6c..87782a3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -131,6 +131,13 @@ static inline int task_has_rt_policy(struct task_struc=
t *p)
 	return rt_policy(p->policy);
 }
=20
+static inline int dl_policy(int policy)
+{
+	if (unlikely(policy =3D=3D SCHED_DEADLINE))
+		return 1;
+	return 0;
+}
+
 static inline int task_has_dl_policy(struct task_struct *p)
 {
 	return dl_policy(p->policy);
@@ -1940,17 +1947,20 @@ static inline int __normal_prio(struct task_struct =
*p)
  * boosted by interactivity modifiers. Changes upon fork,
  * setprio syscalls, and whenever the interactivity
  * estimator recalculates.
+ *
+ * For -deadline tasks the relative deadline is used as
+ * priority but in such a way that:
+ *  - prio is always < 0,
+ *  - p1->prio < p2->prio means p1's rel. deadline is smaller
+ *    than p2's one.
  */
 static inline int normal_prio(struct task_struct *p)
 {
 	int prio;
=20
-	if (task_has_dl_policy(p)) {
-		/*
-		 * FIXME: horrible hack here... Deadline inheritance needed!!
-		 */
-		prio =3D -(1<<7);
-	} else if (task_has_rt_policy(p))
+	if (task_has_dl_policy(p))
+		prio =3D -(MAX_SCHED_DEADLINE - p->dl.dl_deadline);
+	else if (task_has_rt_policy(p))
 		prio =3D MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio =3D __normal_prio(p);
@@ -1960,19 +1970,20 @@ static inline int normal_prio(struct task_struct *p=
)
 /*
  * Calculate the current priority, i.e. the priority
  * taken into account by the scheduler. This value might
- * be boosted by RT tasks, or might be boosted by
- * interactivity modifiers. Will be RT if the task got
- * RT-boosted. If not then it returns p->normal_prio.
+ * be boosted by deadline/RT tasks, or might be boosted by
+ * interactivity modifiers. Will be deadline if the task got
+ * deadline-boosted (and the same for RT). If not then it
+ * returns p->normal_prio.
  */
 static int effective_prio(struct task_struct *p)
 {
 	p->normal_prio =3D normal_prio(p);
 	/*
-	 * If we are RT tasks or we were boosted to RT priority,
+	 * If we are deadline/RT tasks or we were boosted to such priority,
 	 * keep the priority unchanged. Otherwise, update priority
 	 * to the normal priority:
 	 */
-	if (!rt_prio(p->prio))
+	if (!dl_prio(p->prio) && !rt_prio(p->prio))
 		return p->normal_prio;
 	return p->prio;
 }
@@ -2633,10 +2644,7 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 	 */
 	p->prio =3D current->normal_prio;
=20
-	/*
-	 * FIXME: deadline inheritance needed here!!
-	 */
-	if (dl_task(p))
+	if (dl_prio(p->prio))
 		p->sched_class =3D &dl_sched_class;
 	else if (rt_prio(p->prio))
 		p->sched_class =3D &rt_sched_class;
@@ -6086,8 +6094,6 @@ void rt_mutex_setprio(struct task_struct *p, int prio=
)
 	struct rq *rq;
 	const struct sched_class *prev_class =3D p->sched_class;
=20
-	BUG_ON(prio < 0 || prio > MAX_PRIO);
-
 	rq =3D task_rq_lock(p, &flags);
 	update_rq_clock(rq);
=20
@@ -6099,12 +6105,20 @@ void rt_mutex_setprio(struct task_struct *p, int pr=
io)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
=20
-	/*
-	 * FIXME: deadline inheritance needed here!!
-	 */
-	if (dl_task(p))
+	if (dl_prio(prio)) {
+		/*
+		 * If we are boosting p to -deadline its static runtime and
+		 * relative deadline are both set to the relative deadline
+		 * being inherited, which means the maximum boosting we are
+		 * able to provide as of now!
+		 */
+		if (!task_has_dl_policy(p)) {
+			p->dl.dl_runtime =3D dl_se_prio_to_deadline(prio);
+			p->dl.dl_deadline =3D dl_se_prio_to_deadline(prio);
+			p->dl.flags =3D DL_NEW;
+		}
 		p->sched_class =3D &dl_sched_class;
-	else if (rt_prio(prio))
+	} else if (rt_prio(prio))
 		p->sched_class =3D &rt_sched_class;
 	else
 		p->sched_class =3D &fair_sched_class;
@@ -6289,10 +6303,7 @@ __setscheduler(struct rq *rq, struct task_struct *p,=
 int policy, int prio)
 	/* we are holding p->pi_lock already */
 	p->prio =3D rt_mutex_getprio(p);
=20
-	/*
-	 * FIXME: deadline inheritance needed here!!
-	 */
-	if (dl_policy(policy))
+	if (dl_prio(p->prio))
 		p->sched_class =3D &dl_sched_class;
 	else if (rt_prio(p->prio))
 		p->sched_class =3D &rt_sched_class;
@@ -6341,6 +6352,7 @@ static bool
 __checkparam_dl(struct sched_param_ex *prm)
 {
 	return prm && timespec_to_ns(&prm->sched_deadline) !=3D 0 &&
+	       timespec_to_ns(&prm->sched_deadline) <=3D MAX_SCHED_DEADLINE &&
 	       timespec_to_ns(&prm->sched_deadline) >=3D
 	       timespec_to_ns(&prm->sched_runtime);
 }
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index b5dde44..3613cbd 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -39,6 +39,31 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se=
)
 	return !RB_EMPTY_NODE(&dl_se->rb_node);
 }
=20
+static inline int dl_se_boosted(struct sched_dl_entity *dl_se)
+{
+	struct task_struct *p =3D dl_task_of(dl_se);
+
+	return p->prio !=3D p->normal_prio;
+}
+
+/*
+ * Decodes the task's priority value and returns the corresponding
+ * relative deadline value.
+ */
+static inline int dl_se_prio_to_deadline(int prio)
+{
+	return MAX_SCHED_DEADLINE + prio;
+}
+
+/*
+ * Retuns the actual relative deadline of the scheduling entity,
+ * i.e., its own one or the earliest it has inherited since now.
+ */
+static inline int dl_se_deadline(struct sched_dl_entity *dl_se)
+{
+	return dl_se_prio_to_deadline(dl_task_of(dl_se)->prio);
+}
+
 static inline int dl_time_before(u64 a, u64 b)
 {
 	return (s64)(a - b) < 0;
@@ -70,7 +95,7 @@ static inline void setup_new_dl_entity(struct sched_dl_en=
tity *dl_se)
=20
 	WARN_ON(!(dl_se->flags & DL_NEW) || dl_se->flags & DL_THROTTLED);
=20
-	dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
+	dl_se->deadline =3D rq->clock + dl_se_deadline(dl_se);
 	dl_se->runtime =3D dl_se->dl_runtime;
 	dl_se->flags &=3D ~DL_NEW;
 }
@@ -103,7 +128,7 @@ static void replenish_dl_entity(struct sched_dl_entity =
*dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <=3D 0) {
-		dl_se->deadline +=3D dl_se->dl_deadline;
+		dl_se->deadline +=3D dl_se_deadline(dl_se);
 		dl_se->runtime +=3D dl_se->dl_runtime;
 	}
=20
@@ -129,7 +154,7 @@ static bool dl_check_bandwidth(struct sched_dl_entity *=
dl_se, u64 t)
 	 * after a bit of shuffling to use multiplications instead
 	 * of divisions.
 	 */
-	left =3D dl_se->dl_deadline * dl_se->runtime;
+	left =3D dl_se_deadline(dl_se) * dl_se->runtime;
 	right =3D (dl_se->deadline - t) * dl_se->dl_runtime;
=20
 	return dl_time_before(left, right);
@@ -165,7 +190,7 @@ static void update_dl_entity(struct sched_dl_entity *dl=
_se)
=20
 	if (!dl_check_bandwidth(dl_se, rq->clock)) {
 update:
-		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
+		dl_se->deadline =3D rq->clock + dl_se_deadline(dl_se);
 		dl_se->runtime =3D dl_se->dl_runtime;
 	}
 }
@@ -190,6 +215,26 @@ static int start_dl_timer(struct sched_dl_entity *dl_s=
e, u64 wakeup)
 	s64 delta;
=20
 	/*
+	 * This is the second part of the boosting logic (the first one
+	 * being relative deadline inheritance through the prio field).
+	 * In fact, this function is called when a task is overrunning its
+	 * runtime (or missing its deadline) in order to put it to sleep
+	 * for a while, thus enforcing its bandwidth limitation.
+	 * However, if such a task is boosted, we tell the caller (by
+	 * returning 0) to immediately give the task new scheduling
+	 * parameters and enqueue it back without waiting for the next abs.
+	 * deadline.
+	 *
+	 * This means tasks _are_ able to overcome their bandwidth wile
+	 * boosted. For what concerns paying back for these overruns, this
+	 * is done at this time, in terms of smaller runtime replenishment
+	 * (and perhaps farther deadline postponement), but subsequent
+	 * instances _won't_ be affected.
+	 */
+	if (dl_se_boosted(dl_se))
+		return 0;
+
+	/*
 	 * Arm the timer to fire at wakeup, tying to compensate for
 	 * the fact that wakeup is actually coming from rq->clock and
 	 * not from hrtimer's time base reading.
@@ -485,7 +530,7 @@ long wait_interval_dl(struct task_struct *p, struct tim=
espec *rqtp,
=20
 		WARN_ON(rorun_ratio =3D=3D 0);
=20
-		wakeup =3D dl_se->deadline + dl_se->dl_deadline * rorun_ratio;
+		wakeup =3D dl_se->deadline + dl_se_deadline(dl_se) * rorun_ratio;
 		goto unlock;
 	}
=20
@@ -508,7 +553,7 @@ long wait_interval_dl(struct task_struct *p, struct tim=
espec *rqtp,
 	wakeup =3D timespec_to_ns(rqtp);
 	if (dl_time_before(wakeup, dl_se->deadline) &&
 	    dl_check_bandwidth(dl_se, wakeup)) {
-		u64 ibw =3D (u64)dl_se->runtime * dl_se->dl_deadline;
+		u64 ibw =3D (u64)dl_se->runtime * dl_se_deadline(dl_se);
=20
 		ibw =3D div_u64(ibw, dl_se->dl_runtime);
 		wakeup =3D dl_se->deadline - ibw;
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-LPuUWzXz+6UT+r/qvrwr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKw00ACgkQk4XaBE3IOsSACwCeO7wHe0YYUqJVX0v5eVsQX+wL
wOgAn2SpH1tsRRsVu6sBAWVpV54gigPD
=Iz4T
-----END PGP SIGNATURE-----

--=-LPuUWzXz+6UT+r/qvrwr--

