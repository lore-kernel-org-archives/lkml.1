Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936588Ab0B1TXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:23:21 -0500
Received: from ms01.sssup.it ([193.205.80.99]:58423 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936491Ab0B1TXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:23:19 -0500
Subject: [RFC][PATCH 07/11] sched: add latency tracing for -deadline tasks.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-u+RzNI/L3+9std6cOzY1"
Date: Sun, 28 Feb 2010 20:23:06 +0100
Message-ID: <1267384986.13676.96.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u+RzNI/L3+9std6cOzY1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It is very likely that systems that wants/needs to use the new
SCHED_DEADLINE policy also want to have the scheduling latency of
the -deadline tasks under control.

For this reason a new version of the scheduling wakeup latency,
called "wakeup_dl", is introduced.

As a consequence of applying this patch there will be three wakeup
latency tracer:
 * "wakeup", that deals with all tasks in the system;
 * "wakeup_rt", that deals with -rt and -deadline tasks only;
 * "wakeup_dl", that deals with -deadline tasks only.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 kernel/trace/trace_sched_wakeup.c |   44 +++++++++++++++++++++++++++++++++=
---
 kernel/trace/trace_selftest.c     |   30 +++++++++++++++----------
 2 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index 0271742..a02ce04 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -27,6 +27,7 @@ static int			wakeup_cpu;
 static int			wakeup_current_cpu;
 static unsigned			wakeup_prio =3D -1;
 static int			wakeup_rt;
+static int			wakeup_dl;
=20
 static arch_spinlock_t wakeup_lock =3D
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
@@ -214,9 +215,17 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int=
 success)
 	tracing_record_cmdline(p);
 	tracing_record_cmdline(current);
=20
-	if ((wakeup_rt && !rt_task(p)) ||
-			p->prio >=3D wakeup_prio ||
-			p->prio >=3D current->prio)
+	/*
+	 * Semantic is like this:
+	 *  - wakeup tracer handles all tasks in the system, independently
+	 *    from their scheduling class;
+	 *  - wakeup_rt tracer handles tasks belonging to sched_dl and
+	 *    sched_rt class;
+	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
+	 */
+	if ((wakeup_dl && !dl_task(p)) ||
+	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
+	    (p->prio >=3D wakeup_prio || p->prio >=3D current->prio))
 		return;
=20
 	pc =3D preempt_count();
@@ -228,7 +237,7 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int =
success)
 	arch_spin_lock(&wakeup_lock);
=20
 	/* check for races. */
-	if (!tracer_enabled || p->prio >=3D wakeup_prio)
+	if (!tracer_enabled || (!dl_task(p) && p->prio >=3D wakeup_prio))
 		goto out_locked;
=20
 	/* reset the trace */
@@ -340,16 +349,25 @@ static int __wakeup_tracer_init(struct trace_array *t=
r)
=20
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl =3D 0;
 	wakeup_rt =3D 0;
 	return __wakeup_tracer_init(tr);
 }
=20
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl =3D 0;
 	wakeup_rt =3D 1;
 	return __wakeup_tracer_init(tr);
 }
=20
+static int wakeup_dl_tracer_init(struct trace_array *tr)
+{
+	wakeup_dl =3D 1;
+	wakeup_rt =3D 0;
+	return __wakeup_tracer_init(tr);
+}
+
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
 	stop_wakeup_tracer(tr);
@@ -398,6 +416,20 @@ static struct tracer wakeup_rt_tracer __read_mostly =
=3D
 #endif
 };
=20
+static struct tracer wakeup_dl_tracer __read_mostly =3D
+{
+	.name		=3D "wakeup_dl",
+	.init		=3D wakeup_dl_tracer_init,
+	.reset		=3D wakeup_tracer_reset,
+	.start		=3D wakeup_tracer_start,
+	.stop		=3D wakeup_tracer_stop,
+	.wait_pipe	=3D poll_wait_pipe,
+	.print_max	=3D 1,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest    =3D trace_selftest_startup_wakeup,
+#endif
+};
+
 __init static int init_wakeup_tracer(void)
 {
 	int ret;
@@ -410,6 +442,10 @@ __init static int init_wakeup_tracer(void)
 	if (ret)
 		return ret;
=20
+	ret =3D register_tracer(&wakeup_dl_tracer);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 device_initcall(init_wakeup_tracer);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 280fea4..4834411 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -558,11 +558,17 @@ trace_selftest_startup_nop(struct tracer *trace, stru=
ct trace_array *tr)
 #ifdef CONFIG_SCHED_TRACER
 static int trace_wakeup_test_thread(void *data)
 {
-	/* Make this a RT thread, doesn't need to be too high */
-	struct sched_param param =3D { .sched_priority =3D 5 };
+	/* Make this a -deadline thread */
+	struct sched_param param =3D { .sched_priority =3D 0 };
+	struct sched_param_ex paramx =3D {
+		.sched_priority =3D 0,
+		.sched_runtime =3D { .tv_sec =3D 0, .tv_nsec =3D 100000 },
+		.sched_deadline =3D { .tv_sec =3D 0, .tv_nsec =3D 10000000 },
+		.sched_flags =3D 0
+	};
 	struct completion *x =3D data;
=20
-	sched_setscheduler(current, SCHED_FIFO, &param);
+	sched_setscheduler_ex(current, SCHED_DEADLINE, &param, &paramx);
=20
 	/* Make it know we have a new prio */
 	complete(x);
@@ -574,8 +580,8 @@ static int trace_wakeup_test_thread(void *data)
 	/* we are awake, now wait to disappear */
 	while (!kthread_should_stop()) {
 		/*
-		 * This is an RT task, do short sleeps to let
-		 * others run.
+		 * This will likely be the system top priority
+		 * task, do short sleeps to let others run.
 		 */
 		msleep(100);
 	}
@@ -588,21 +594,21 @@ trace_selftest_startup_wakeup(struct tracer *trace, s=
truct trace_array *tr)
 {
 	unsigned long save_max =3D tracing_max_latency;
 	struct task_struct *p;
-	struct completion isrt;
+	struct completion is_ready;
 	unsigned long count;
 	int ret;
=20
-	init_completion(&isrt);
+	init_completion(&is_ready);
=20
-	/* create a high prio thread */
-	p =3D kthread_run(trace_wakeup_test_thread, &isrt, "ftrace-test");
+	/* create a -deadline thread */
+	p =3D kthread_run(trace_wakeup_test_thread, &is_ready, "ftrace-test");
 	if (IS_ERR(p)) {
 		printk(KERN_CONT "Failed to create ftrace wakeup test thread ");
 		return -1;
 	}
=20
-	/* make sure the thread is running at an RT prio */
-	wait_for_completion(&isrt);
+	/* make sure the thread is running at -deadline policy */
+	wait_for_completion(&is_ready);
=20
 	/* start the tracing */
 	ret =3D tracer_init(trace, tr);
@@ -614,7 +620,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, str=
uct trace_array *tr)
 	/* reset the max latency */
 	tracing_max_latency =3D 0;
=20
-	/* sleep to let the RT thread sleep too */
+	/* sleep to let the thread sleep too */
 	msleep(100);
=20
 	/*
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-u+RzNI/L3+9std6cOzY1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKwpoACgkQk4XaBE3IOsQPHgCeIcobB2i7c06xgbzK/mj8ut5l
26IAn3ocHWTa/45l0rx9yM0DztJCoMQL
=DdGs
-----END PGP SIGNATURE-----

--=-u+RzNI/L3+9std6cOzY1--

