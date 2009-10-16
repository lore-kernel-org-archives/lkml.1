Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbZJPPpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbZJPPpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761159AbZJPPpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:45:00 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54421 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761348AbZJPPo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:44:58 -0400
Subject: [RFC 7/12][PATCH] SCHED_DEADLINE: signal delivery when overrunning
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255707324.6228.448.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yi4i88eMERXYpC4he7Np"
Date: Fri, 16 Oct 2009 17:44:16 +0200
Message-Id: <1255707856.6228.461.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yi4i88eMERXYpC4he7Np
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Starting from this commit, the user can ask to receive a SIGXCPU signal
every time the task runtime is overrun or a scheduling deadline is missed.
This is done by means of the sched_flags field already present in
sched_param_ex.

A runtime overrun will be quite common, e.g. due to coarse execution time
accounting, wrong parameter assignement, etc.
A deadline miss --since the deadlines the scheduler sees are ``scheduling
deadlines'' which have not necessarily to be equal to task's deadlines-- is
much more unlikely, and should only happen in an overloaded system.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 include/linux/sched.h     |    5 ++++
 kernel/posix-cpu-timers.c |   52 +++++++++++++++++++++++++++++++++++++++++=
++-
 kernel/sched_deadline.c   |   18 +++++++++++++++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fac928a..16668f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -95,6 +95,9 @@ struct sched_param {
=20
 #include <asm/processor.h>
=20
+#define SCHED_SIG_RORUN		0x80000000
+#define SCHED_SIG_DMISS		0x40000000
+
 struct sched_param_ex {
 	int sched_priority;
 	struct timespec sched_runtime;
@@ -1229,6 +1232,8 @@ struct sched_rt_entity {
 #define DL_NEW			0x00000001
 #define DL_THROTTLED		0x00000002
 #define DL_BOOSTED		0x00000004
+#define DL_RORUN		0x00000008
+#define DL_DMISS		0x00000010
=20
 struct sched_dl_entity {
 	struct rb_node	rb_node;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 5c9dc22..4caa5bf 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1029,8 +1029,28 @@ static void check_thread_timers(struct task_struct *=
tsk,
 	}
=20
 	/*
-	 * Check for the special case thread timers.
+	 * Check for the special case thread timers:
+	 *  - sched_deadline runtime/deadline overrun notification
+	 *  - sched_rt rlimit overrun notification
 	 */
+	if (deadline_task(tsk) && (tsk->dl.flags & SCHED_SIG_RORUN ||
+	    tsk->dl.flags & SCHED_SIG_DMISS)) {
+		if (tsk->dl.flags & SCHED_SIG_RORUN &&
+		    tsk->dl.flags & DL_RORUN) {
+			tsk->dl.flags &=3D ~DL_RORUN;
+			printk(KERN_INFO "runtime overrun: %s[%d]\n",
+			       tsk->comm, task_pid_nr(tsk));
+			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
+		}
+		if (tsk->dl.flags & SCHED_SIG_DMISS &&
+		    tsk->dl.flags & DL_DMISS) {
+			tsk->dl.flags &=3D ~DL_DMISS;
+			printk(KERN_INFO "scheduling deadline miss: %s[%d]\n",
+			       tsk->comm, task_pid_nr(tsk));
+			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
+		}
+	}
+
 	if (sig->rlim[RLIMIT_RTTIME].rlim_cur !=3D RLIM_INFINITY) {
 		unsigned long hard =3D sig->rlim[RLIMIT_RTTIME].rlim_max;
 		unsigned long *soft =3D &sig->rlim[RLIMIT_RTTIME].rlim_cur;
@@ -1129,6 +1149,9 @@ static void check_process_timers(struct task_struct *=
tsk,
 	if (list_empty(&timers[CPUCLOCK_PROF]) &&
 	    cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) &&
 	    sig->rlim[RLIMIT_CPU].rlim_cur =3D=3D RLIM_INFINITY &&
+	    !(deadline_task(tsk) && ((tsk->dl.flags & SCHED_SIG_RORUN &&
+	    tsk->dl.flags & DL_RORUN) || (tsk->dl.flags & SCHED_SIG_DMISS &&
+	    tsk->dl.flags & DL_DMISS))) &&
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
@@ -1188,8 +1211,28 @@ static void check_process_timers(struct task_struct =
*tsk,
 	}
=20
 	/*
-	 * Check for the special case process timers.
+	 * Check for the special case thread timers:
+	 *  - sched_deadline runtime/deadline overrun notification
+	 *  - sched_rt rlimit overrun notification
 	 */
+	if (deadline_task(tsk) && (tsk->dl.flags & SCHED_SIG_RORUN ||
+	    tsk->dl.flags & SCHED_SIG_DMISS)) {
+		if (tsk->dl.flags & SCHED_SIG_RORUN &&
+		    tsk->dl.flags & DL_RORUN) {
+			tsk->dl.flags &=3D ~DL_RORUN;
+			printk(KERN_INFO "runtime overrun: %s[%d]\n",
+			       tsk->comm, task_pid_nr(tsk));
+			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
+		}
+		if (tsk->dl.flags & SCHED_SIG_DMISS &&
+		    tsk->dl.flags & DL_DMISS) {
+			tsk->dl.flags &=3D ~DL_DMISS;
+			printk(KERN_INFO "scheduling deadline miss: %s[%d]\n",
+			       tsk->comm, task_pid_nr(tsk));
+			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
+		}
+	}
+
 	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_PROF], &prof_expires, ptime,
 			 SIGPROF);
 	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
@@ -1383,6 +1426,11 @@ static inline int fastpath_timer_check(struct task_s=
truct *tsk)
 			return 1;
 	}
=20
+	if (deadline_task(tsk) &&
+	    ((tsk->dl.flags & SCHED_SIG_RORUN && tsk->dl.flags & DL_RORUN) ||
+	    (tsk->dl.flags & SCHED_SIG_DMISS && tsk->dl.flags & DL_DMISS)))
+		return 1;
+
 	return sig->rlim[RLIMIT_CPU].rlim_cur !=3D RLIM_INFINITY;
 }
=20
diff --git a/kernel/sched_deadline.c b/kernel/sched_deadline.c
index f2c1b6e..7b57bb0 100644
--- a/kernel/sched_deadline.c
+++ b/kernel/sched_deadline.c
@@ -236,9 +236,27 @@ static void init_deadline_task(struct task_struct *p)
 static
 int deadline_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se=
)
 {
+	/*
+	 * if the user asked for that, we have to inform him about
+	 * a (scheduling) deadline miss ...
+	 */
+	if (unlikely(dl_se->flags & SCHED_SIG_DMISS &&
+	    deadline_time_before(dl_se->deadline, rq->clock)))
+		dl_se->flags |=3D DL_DMISS;
+
 	if (dl_se->runtime >=3D 0 || deadline_se_boosted(dl_se))
 		return 0;
=20
+	/*
+	 * ... and the same appies to runtime overruns.
+	 *
+	 * Note that (hopefully small) runtime overruns are very likely
+	 * to occur, mainly due to accounting resolution, while missing a
+	 * scheduling deadline should happen only on oversubscribed systems.
+	 */
+	if (dl_se->flags & SCHED_SIG_RORUN)
+		dl_se->flags |=3D DL_RORUN;
+
 	dequeue_deadline_entity(dl_se);
 	if (!start_deadline_timer(dl_se, dl_se->deadline)) {
 		replenish_deadline_entity(dl_se);
--=20
1.6.0.4


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-yi4i88eMERXYpC4he7Np
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlNAACgkQk4XaBE3IOsQuIACeOfthAU7fgPUO8y8paC9WMB9g
Q9wAmwbiS61hRfyyuy0oxk8Zd1ca+goA
=5WeL
-----END PGP SIGNATURE-----

--=-yi4i88eMERXYpC4he7Np--

