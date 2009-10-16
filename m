Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbZJPPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbZJPPqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932732AbZJPPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:46:21 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54536 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932729AbZJPPqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:46:20 -0400
Subject: [RFC 9/12][PATCH] SCHED_DEADLINE: system wide bandwidth management
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lfGBOYR9MC0oq/3NeQcX"
Date: Fri, 16 Oct 2009 17:45:40 +0200
Message-Id: <1255707940.6228.464.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lfGBOYR9MC0oq/3NeQcX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commit adds the capability of controlling the maximum, system wide,
CPU bandwidth that is devoted to SCHED_DEADLINE tasks.

This is done by means of two files:
 - /proc/sys/kernel/sched_deadline_runtime_us,
 - /proc/sys/kernel/sched_deadline_period_us.
The ratio runtime/period is the total bandwidth all the SCHED_DEADLINE task=
s
can use in the system as a whole.
Trying to create tasks in such a way that they exceed this limitation will
fail, as soon as the bandwidth cap would be overcome.

Default value is _zero_ bandwidth available, thus write some numbers in tho=
se
files before trying to start some SCHED_DEADLINE task. Setting runtime > pe=
riod
is allowed (i.e., more than 100% bandwidth available for -deadline tasks),
since it makes more than sense in SMP systems.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 include/linux/sched.h |    7 ++
 kernel/sched.c        |  149 +++++++++++++++++++++++++++++++++++++++++++++=
+++-
 kernel/sysctl.c       |   16 +++++
 3 files changed, 171 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 478e07c..4de72eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1984,6 +1984,13 @@ int sched_rt_handler(struct ctl_table *table, int wr=
ite,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
=20
+extern unsigned int sysctl_sched_deadline_period;
+extern int sysctl_sched_deadline_runtime;
+
+int sched_deadline_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 extern unsigned int sysctl_sched_compat_yield;
=20
 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c3e834..d8b6354 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -870,6 +870,34 @@ static inline u64 global_rt_runtime(void)
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
=20
+/*
+ * deadline_runtime/deadline_period is the maximum bandwidth
+ * -deadline tasks can use. It is system wide, i.e., the sum
+ * of the bandwidths of all the tasks, inside every group and
+ * running on any CPU, has to stay below this value!
+ *
+ * default: 0s (=3D no bandwidth for -deadline tasks)
+ */
+unsigned int sysctl_sched_deadline_period =3D 0;
+int sysctl_sched_deadline_runtime =3D 0;
+
+static inline u64 global_deadline_period(void)
+{
+	return (u64)sysctl_sched_deadline_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_deadline_runtime(void)
+{
+	return (u64)sysctl_sched_deadline_runtime * NSEC_PER_USEC;
+}
+
+/*
+ * locking for the system wide deadline bandwidth management.
+ */
+static DEFINE_MUTEX(deadline_constraints_mutex);
+static DEFINE_SPINLOCK(__sysctl_sched_deadline_lock);
+static u64 __sysctl_sched_deadline_total_bw;
+
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
@@ -2606,6 +2634,66 @@ static unsigned long to_ratio(u64 period, u64 runtim=
e)
 	return div64_u64(runtime << 20, period);
 }
=20
+static inline
+void __deadline_clear_task_bw(struct task_struct *p, u64 tsk_bw)
+{
+	__sysctl_sched_deadline_total_bw -=3D tsk_bw;
+}
+
+static inline
+void __deadline_add_task_bw(struct task_struct *p, u64 tsk_bw)
+{
+	__sysctl_sched_deadline_total_bw +=3D tsk_bw;
+}
+
+/*
+ * update the total allocated bandwidth, if a new -deadline task arrives,
+ * leaves or stays, but modifies its bandwidth.
+ */
+static int __deadline_check_task_bw(struct task_struct *p, int policy,
+				    struct sched_param_ex *param_ex)
+{
+	u64 bw, tsk_bw;
+	int ret =3D 0;
+
+	spin_lock(&__sysctl_sched_deadline_lock);
+
+	if (sysctl_sched_deadline_period <=3D 0)
+		goto unlock;
+
+	bw =3D to_ratio(sysctl_sched_deadline_period,
+		      sysctl_sched_deadline_runtime);
+	if (bw <=3D 0)
+		return 0;
+
+	if (deadline_policy(policy))
+		tsk_bw =3D to_ratio(timespec_to_ns(&param_ex->sched_deadline),
+				  timespec_to_ns(&param_ex->sched_runtime));
+
+	/*
+	 * Either if a task, enters, leave, or stays deadline but chanes
+	 * its parameters, we need to update accordingly the global
+	 * deadline allocated bandwidth.
+	 */
+	if (task_has_deadline_policy(p) && !deadline_policy(policy)) {
+		__deadline_clear_task_bw(p, p->dl.bw);
+		ret =3D 1;
+	} else if (task_has_deadline_policy(p) && deadline_policy(policy) &&
+		  bw >=3D __sysctl_sched_deadline_total_bw - p->dl.bw + tsk_bw) {
+		__deadline_clear_task_bw(p, p->dl.bw);
+		__deadline_add_task_bw(p, tsk_bw);
+		ret =3D 1;
+	} else if (deadline_policy(policy) && !task_has_deadline_policy(p) &&
+		   bw >=3D __sysctl_sched_deadline_total_bw + tsk_bw) {
+		__deadline_add_task_bw(p, tsk_bw);
+		ret =3D 1;
+	}
+unlock:
+	spin_unlock(&__sysctl_sched_deadline_lock);
+
+	return ret;
+}
+
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
@@ -2765,8 +2853,10 @@ static void finish_task_switch(struct rq *rq, struct=
 task_struct *prev)
 		mmdrop(mm);
 	if (unlikely(prev_state =3D=3D TASK_DEAD)) {
 		/* a deadline task is dying: stop the bandwidth timer */
-		if (deadline_task(prev))
+		if (deadline_task(prev)) {
+			__deadline_clear_task_bw(prev, prev->dl.bw);
 			hrtimer_cancel(&prev->dl.dl_timer);
+		}
=20
 		/*
 		 * Remove function-return probe instances associated with this
@@ -6372,6 +6462,19 @@ recheck:
 		spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
+	/*
+	 * If changing to SCHED_DEADLINE (or changing the parameters of a
+	 * SCHED_DEADLINE task) we need to check if enough bandwidth is
+	 * available, which might be not true!
+	 */
+	if (deadline_policy(policy) || deadline_task(p)) {
+		if (!__deadline_check_task_bw(p, policy, param_ex)) {
+			__task_rq_unlock(rq);
+			spin_unlock_irqrestore(&p->pi_lock, flags);
+			return -EPERM;
+		}
+	}
+
 	update_rq_clock(rq);
 	on_rq =3D p->se.on_rq;
 	running =3D task_current(rq, p);
@@ -10569,6 +10672,25 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+static int sched_deadline_global_constraints(void)
+{
+	u64 bw;
+	int ret =3D 1;
+
+	spin_lock_irq(&__sysctl_sched_deadline_lock);
+	if (sysctl_sched_deadline_period <=3D 0)
+		bw =3D 0;
+	else
+		bw =3D to_ratio(global_deadline_period(),
+			      global_deadline_runtime());
+
+	if (bw < __sysctl_sched_deadline_total_bw)
+		ret =3D 0;
+	spin_unlock_irq(&__sysctl_sched_deadline_lock);
+
+	return ret;
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
@@ -10599,6 +10721,31 @@ int sched_rt_handler(struct ctl_table *table, int =
write,
 	return ret;
 }
=20
+int sched_deadline_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	int old_period, old_runtime;
+
+	mutex_lock(&deadline_constraints_mutex);
+	old_period =3D sysctl_sched_deadline_period;
+	old_runtime =3D sysctl_sched_deadline_runtime;
+
+	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		if (!sched_deadline_global_constraints()) {
+			sysctl_sched_deadline_period =3D old_period;
+			sysctl_sched_deadline_runtime =3D old_runtime;
+			ret =3D -EINVAL;
+		}
+	}
+	mutex_unlock(&deadline_constraints_mutex);
+
+	return ret;
+}
+
 #ifdef CONFIG_CGROUP_SCHED
=20
 /* return corresponding task_group object of a cgroup */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..34117f9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -373,6 +373,22 @@ static struct ctl_table kern_table[] =3D {
 	},
 	{
 		.ctl_name	=3D CTL_UNNUMBERED,
+		.procname	=3D "sched_deadline_period_us",
+		.data		=3D &sysctl_sched_deadline_period,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &sched_deadline_handler,
+	},
+	{
+		.ctl_name	=3D CTL_UNNUMBERED,
+		.procname	=3D "sched_deadline_runtime_us",
+		.data		=3D &sysctl_sched_deadline_runtime,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &sched_deadline_handler,
+	},
+	{
+		.ctl_name	=3D CTL_UNNUMBERED,
 		.procname	=3D "sched_compat_yield",
 		.data		=3D &sysctl_sched_compat_yield,
 		.maxlen		=3D sizeof(unsigned int),
--=20
1.6.0.4


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-lfGBOYR9MC0oq/3NeQcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlSQACgkQk4XaBE3IOsTWgACfW02UH8R70llL2SexEuKiKDCk
F24AmwcmOCrhsOygz5RlKocKiIiyPVt5
=utGW
-----END PGP SIGNATURE-----

--=-lfGBOYR9MC0oq/3NeQcX--

