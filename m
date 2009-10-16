Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbZJPPm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbZJPPm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761107AbZJPPm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:42:27 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49711 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761075AbZJPPmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:42:25 -0400
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: added sched_*_ex syscalls
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZH8o0FFENsSSlPTrKffh"
Date: Fri, 16 Oct 2009 17:41:45 +0200
Message-Id: <1255707705.6228.457.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZH8o0FFENsSSlPTrKffh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commits adds the new syscalls needed to set/get the parameters for
SCHED_DEADLINE scheduling policy. As it can be expected, they all deal with
sched_param_ex.

The new syscalls are:
 * sched_setscheduler_ex,
 * sched_setparam_ex,
 * sched_getparam_ex.

They have been added to x86, x86-64 and ARM only for now, since these are
the only architectures we are able to test... But adding the bits needed fo=
r
supporting other archs is more than straightforward...

Signed-off-by: Raistlin <raistlin@linux.it>
---
 arch/arm/include/asm/unistd.h      |    3 +
 arch/arm/kernel/calls.S            |    3 +
 arch/x86/ia32/ia32entry.S          |    3 +
 arch/x86/include/asm/unistd_32.h   |    5 +-
 arch/x86/include/asm/unistd_64.h   |    6 ++
 arch/x86/kernel/syscall_table_32.S |    3 +
 include/linux/syscalls.h           |    7 ++
 kernel/sched.c                     |  168 ++++++++++++++++++++++++++++++++=
+---
 8 files changed, 185 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 7020217..09b927e 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -391,6 +391,9 @@
 #define __NR_pwritev			(__NR_SYSCALL_BASE+362)
 #define __NR_rt_tgsigqueueinfo		(__NR_SYSCALL_BASE+363)
 #define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
+#define __NR_sched_setscheduler_ex	(__NR_SYSCALL_BASE+365)
+#define __NR_sched_setparam_ex		(__NR_SYSCALL_BASE+366)
+#define __NR_sched_getparam_ex		(__NR_SYSCALL_BASE+367)
=20
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index fafce1b..42ad362 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -374,6 +374,9 @@
 		CALL(sys_pwritev)
 		CALL(sys_rt_tgsigqueueinfo)
 		CALL(sys_perf_event_open)
+/* 365 */	CALL(sys_sched_setscheduler_ex)
+		CALL(sys_sched_setparam_ex)
+		CALL(sys_sched_getparam_ex)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 1733f9f..3d04691 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -842,4 +842,7 @@ ia32_sys_call_table:
 	.quad compat_sys_pwritev
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
+	.quad sys_sched_setscheduler_ex
+	.quad sys_sched_setparam_ex
+	.quad sys_sched_getparam_ex
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd=
_32.h
index 6fb3c20..3928c04 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -342,10 +342,13 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_sched_setscheduler_ex	337
+#define __NR_sched_setparam_ex		338
+#define __NR_sched_getparam_ex		339
=20
 #ifdef __KERNEL__
=20
-#define NR_syscalls 337
+#define NR_syscalls 340
=20
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd=
_64.h
index 8d3ad0a..84b0743 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -661,6 +661,12 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open			298
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_sched_setscheduler_ex		299
+__SYSCALL(__NR_sched_setscheduler_ex, sys_sched_setscheduler_ex)
+#define __NR_sched_setparam_ex			300
+__SYSCALL(__NR_sched_setparam_ex, sys_sched_setparam_ex)
+#define __NR_sched_getparam_ex			301
+__SYSCALL(__NR_sched_getparam_ex, sys_sched_getparam_ex)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_t=
able_32.S
index 0157cd2..38f056c 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -336,3 +336,6 @@ ENTRY(sys_call_table)
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
+	.long sys_sched_setscheduler_ex
+	.long sys_sched_setparam_ex
+	.long sys_sched_getparam_ex
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a990ace..dad0b33 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -33,6 +33,7 @@ struct pollfd;
 struct rlimit;
 struct rusage;
 struct sched_param;
+struct sched_param_ex;
 struct semaphore;
 struct sembuf;
 struct shmid_ds;
@@ -390,11 +391,17 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_c=
lock, int flags,
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setscheduler_ex(pid_t pid, int policy,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setparam_ex(pid_t pid,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_getparam_ex(pid_t pid,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/kernel/sched.c b/kernel/sched.c
index 243066e..2c974fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2598,6 +2598,14 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 	put_cpu();
 }
=20
+static unsigned long to_ratio(u64 period, u64 runtime)
+{
+	if (runtime =3D=3D RUNTIME_INF)
+		return 1ULL << 20;
+
+	return div64_u64(runtime << 20, period);
+}
+
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
@@ -6192,6 +6200,9 @@ __setscheduler(struct rq *rq, struct task_struct *p, =
int policy, int prio)
 	case SCHED_RR:
 		p->sched_class =3D &rt_sched_class;
 		break;
+	case SCHED_DEADLINE:
+		p->sched_class =3D &deadline_sched_class;
+		break;
 	}
=20
 	p->rt_priority =3D prio;
@@ -6202,6 +6213,28 @@ __setscheduler(struct rq *rq, struct task_struct *p,=
 int policy, int prio)
 }
=20
 /*
+ * initialize all the fields of the deadline scheduling entity.
+ * The absolute deadline and the actual task runtime will be set at the
+ * activation.
+ */
+static void
+__setscheduler_ex(struct rq *rq, struct task_struct *p,
+		  struct sched_param_ex *param_ex)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	init_deadline_task(p);
+	dl_se->flags |=3D DL_NEW;
+	dl_se->flags &=3D ~DL_THROTTLED;
+
+	dl_se->flags =3D param_ex->sched_flags;
+	dl_se->sched_runtime =3D timespec_to_ns(&param_ex->sched_runtime);
+	dl_se->sched_deadline =3D timespec_to_ns(&param_ex->sched_deadline);
+	dl_se->sched_period =3D timespec_to_ns(&param_ex->sched_period);
+	dl_se->bw =3D to_ratio(dl_se->sched_deadline, dl_se->sched_runtime);
+}
+
+/*
  * check the target process has a UID that matches the current process's
  */
 static bool check_same_owner(struct task_struct *p)
@@ -6218,7 +6251,9 @@ static bool check_same_owner(struct task_struct *p)
 }
=20
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				struct sched_param *param, bool user)
+				struct sched_param *param,
+				struct sched_param_ex *param_ex,
+				bool user)
 {
 	int retval, oldprio, oldpolicy =3D -1, on_rq, running;
 	unsigned long flags;
@@ -6237,7 +6272,8 @@ recheck:
 		reset_on_fork =3D !!(policy & SCHED_RESET_ON_FORK);
 		policy &=3D ~SCHED_RESET_ON_FORK;
=20
-		if (policy !=3D SCHED_FIFO && policy !=3D SCHED_RR &&
+		if (policy !=3D SCHED_DEADLINE &&
+				policy !=3D SCHED_FIFO && policy !=3D SCHED_RR &&
 				policy !=3D SCHED_NORMAL && policy !=3D SCHED_BATCH &&
 				policy !=3D SCHED_IDLE)
 			return -EINVAL;
@@ -6254,6 +6290,17 @@ recheck:
 		return -EINVAL;
 	if (rt_policy(policy) !=3D (param->sched_priority !=3D 0))
 		return -EINVAL;
+	/*
+	 * Validate the parameters for a SCHED_DEADLINE task.
+	 * We need relative deadline to be different than zero and
+	 * greater or equal than the runtime.
+	 */
+	if (deadline_policy(policy) && (!param_ex ||
+	    param_ex->sched_priority !=3D 0 ||
+	    timespec_to_ns(&param_ex->sched_deadline) =3D=3D 0 ||
+	    timespec_to_ns(&param_ex->sched_deadline) <
+	    timespec_to_ns(&param_ex->sched_runtime)))
+		return -EINVAL;
=20
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
@@ -6336,6 +6383,8 @@ recheck:
 	p->sched_reset_on_fork =3D reset_on_fork;
=20
 	oldprio =3D p->prio;
+	if (deadline_policy(policy))
+		__setscheduler_ex(rq, p, param_ex);
 	__setscheduler(rq, p, policy, param->sched_priority);
=20
 	if (running)
@@ -6364,10 +6413,17 @@ recheck:
 int sched_setscheduler(struct task_struct *p, int policy,
 		       struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, true);
+	return __sched_setscheduler(p, policy, param, NULL, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
=20
+int sched_setscheduler_ex(struct task_struct *p, int policy,
+			  struct sched_param *param,
+			  struct sched_param_ex *param_ex)
+{
+	return __sched_setscheduler(p, policy, param, param_ex, true);
+}
+
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT pri=
ority of a thread from kernelspace.
  * @p: the task in question.
@@ -6382,7 +6438,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, false);
+	return __sched_setscheduler(p, policy, param, NULL, false);
 }
=20
 static int
@@ -6407,6 +6463,33 @@ do_sched_setscheduler(pid_t pid, int policy, struct =
sched_param __user *param)
 	return retval;
 }
=20
+static int
+do_sched_setscheduler_ex(pid_t pid, int policy,
+			 struct sched_param_ex __user *param_ex)
+{
+	struct sched_param lparam;
+	struct sched_param_ex lparam_ex;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+	if (copy_from_user(&lparam_ex, param_ex,
+	    sizeof(struct sched_param_ex)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval =3D -ESRCH;
+	p =3D find_process_by_pid(pid);
+	if (p !=3D NULL) {
+		lparam.sched_priority =3D lparam_ex.sched_priority;
+		retval =3D sched_setscheduler_ex(p, policy, &lparam, &lparam_ex);
+	}
+	rcu_read_unlock();
+
+	return retval;
+}
+
 /**
  * sys_sched_setscheduler - set/change the scheduler policy and RT priorit=
y
  * @pid: the pid in question.
@@ -6424,6 +6507,21 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int,=
 policy,
 }
=20
 /**
+ * sys_sched_setscheduler_ex - set/change the scheduler policy to SCHED_DE=
ADLINE
+ * @pid: the pid in question.
+ * @policy: new policy (should be SCHED_DEADLINE).
+ * @param: structure containg the extended deadline parameters.
+ */
+SYSCALL_DEFINE3(sched_setscheduler_ex, pid_t, pid, int, policy,
+		struct sched_param_ex __user *, param_ex)
+{
+	if (policy < 0)
+		return -EINVAL;
+
+	return do_sched_setscheduler_ex(pid, policy, param_ex);
+}
+
+/**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
@@ -6434,6 +6532,17 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct s=
ched_param __user *, param)
 }
=20
 /**
+ * sys_sched_setparam - set/change the DEADLINE parameters of a thread
+ * @pid: the pid in question.
+ * @param_ex: structure containing the new parameters (deadline, runtime, =
etc.).
+ */
+SYSCALL_DEFINE2(sched_setparam_ex, pid_t, pid,
+		struct sched_param_ex __user *, param_ex)
+{
+	return do_sched_setscheduler_ex(pid, -1, param_ex);
+}
+
+/**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
  */
@@ -6497,6 +6606,49 @@ out_unlock:
 	return retval;
 }
=20
+/**
+ * sys_sched_getparam - get the DEADLINE task parameters of a thread
+ * @pid: the pid in question.
+ * @param_ex: structure containing the new parameters (deadline, runtime, =
etc.).
+ */
+SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
+		struct sched_param_ex __user *, param_ex)
+{
+	struct sched_param_ex lp;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+
+	read_lock(&tasklist_lock);
+	p =3D find_process_by_pid(pid);
+	retval =3D -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval =3D security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	lp.sched_priority =3D p->rt_priority;
+	lp.sched_runtime =3D ns_to_timespec(p->dl.sched_runtime);
+	lp.sched_deadline =3D ns_to_timespec(p->dl.sched_deadline);
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * This one might sleep, we cannot do it with a spinlock held ...
+	 */
+	retval =3D copy_to_user(param_ex, &lp, sizeof(*param_ex)) ? -EFAULT : 0;
+
+	return retval;
+
+out_unlock:
+	read_unlock(&tasklist_lock);
+	return retval;
+
+}
+
 long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 {
 	cpumask_var_t cpus_allowed, new_mask;
@@ -10112,14 +10264,6 @@ unsigned long sched_group_shares(struct task_group=
 *tg)
  */
 static DEFINE_MUTEX(rt_constraints_mutex);
=20
-static unsigned long to_ratio(u64 period, u64 runtime)
-{
-	if (runtime =3D=3D RUNTIME_INF)
-		return 1ULL << 20;
-
-	return div64_u64(runtime << 20, period);
-}
-
 /* Must be called with tasklist_lock held */
 static inline int tg_has_rt_tasks(struct task_group *tg)
 {
--=20
1.6.0.4

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ZH8o0FFENsSSlPTrKffh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlDkACgkQk4XaBE3IOsSkIQCgl/3FhDFkjSJl2L1/xr0HlrNW
qtYAnjXApCq9HzSgiP0AaCsAopVe/twd
=uEJ4
-----END PGP SIGNATURE-----

--=-ZH8o0FFENsSSlPTrKffh--

