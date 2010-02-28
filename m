Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936527Ab0B1TSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:18:37 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42338 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936423Ab0B1TSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:18:35 -0500
Subject: [RFC][PATCH 03/11] sched: add extended scheduling interface.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cis59CrWf6kMlqYy2Rpf"
Date: Sun, 28 Feb 2010 20:18:26 +0100
Message-ID: <1267384706.13676.89.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cis59CrWf6kMlqYy2Rpf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add the interface bits needed for supporting scheduling algorithms
with extended parameters (e.g., SCHED_DEADLINE).
In fact, specifying a periodic/sporadic task that executes for a
given amount of runtime at each instance, and that is scheduled
according to the usrgency of their own timing constraints needs,
in general:
 - a (maximum/typical) instance execution time,
 - a minimum interval between consecutive instances,
 - a time constraint by which each instance must be completed.

In order of this model to be useable, both the data structure that
holds the scheduling parameter of tasks and the system calls that
deal with them have to be extended.
Unfortunately, modifying the existing struct sched_param would
break the ABI and result in potentially serious compatibility
issues with legacy binary code.

For these reasons, this patch:
 - defines the new struct sched_param_ex, containing all the fields
   that are necessary for specifying a task in the computational
   model described above;
 - defines and implements the new scheduling related syscalls that
   manipulate it, i.e., sched_setscheduler_ex(), sched_setparam_ex()
   and sched_getparam_ex().

Syscalls are introduced for x86 (32 and 64 bits) and ARM only, as a
proof of concept and for developing and testing purposes. However,
making them available on other archs is straightforward.

The SCHED_DEADLINE policy is, as of now, the only user of this
extended interface.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 arch/arm/include/asm/unistd.h      |    3 +
 arch/arm/kernel/calls.S            |    3 +
 arch/x86/ia32/ia32entry.S          |    3 +
 arch/x86/include/asm/unistd_32.h   |    5 +-
 arch/x86/include/asm/unistd_64.h   |    6 ++
 arch/x86/kernel/syscall_table_32.S |    3 +
 include/linux/sched.h              |   54 +++++++++++
 include/linux/syscalls.h           |    7 ++
 kernel/sched.c                     |  176 ++++++++++++++++++++++++++++++++=
+++-
 9 files changed, 254 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index cf9cdaa..e741cd6 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -392,6 +392,9 @@
 #define __NR_rt_tgsigqueueinfo		(__NR_SYSCALL_BASE+363)
 #define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
 #define __NR_recvmmsg			(__NR_SYSCALL_BASE+365)
+#define __NR_sched_setscheduler_ex	(__NR_SYSCALL_BASE+366)
+#define __NR_sched_setparam_ex		(__NR_SYSCALL_BASE+367)
+#define __NR_sched_getparam_ex		(__NR_SYSCALL_BASE+368)
=20
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 9314a2d..8eeb552 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -375,6 +375,9 @@
 		CALL(sys_rt_tgsigqueueinfo)
 		CALL(sys_perf_event_open)
 /* 365 */	CALL(sys_recvmmsg)
+		CALL(sys_sched_setscheduler_ex)
+		CALL(sys_sched_setparam_ex)
+		CALL(sys_sched_getparam_ex)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 53147ad..f24e9fa 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -842,4 +842,7 @@ ia32_sys_call_table:
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
+	.quad sys_sched_setscheduler_ex
+	.quad sys_sched_setparam_ex
+	.quad sys_sched_getparam_ex		/* 340 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd=
_32.h
index 3baf379..1db148b 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -343,10 +343,13 @@
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
+#define __NR_sched_setscheduler_ex	338
+#define __NR_sched_setparam_ex		339
+#define __NR_sched_getparam_ex		340
=20
 #ifdef __KERNEL__
=20
-#define NR_syscalls 338
+#define NR_syscalls 341
=20
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd=
_64.h
index 4843f7b..d254154 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,12 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinf=
o)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_sched_setscheduler_ex		300
+__SYSCALL(__NR_sched_setscheduler_ex, sys_sched_setscheduler_ex)
+#define __NR_sched_setparam_ex			301
+__SYSCALL(__NR_sched_setparam_ex, sys_sched_setparam_ex)
+#define __NR_sched_getparam_ex			302
+__SYSCALL(__NR_sched_getparam_ex, sys_sched_getparam_ex)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_t=
able_32.S
index 15228b5..e27e002 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -337,3 +337,6 @@ ENTRY(sys_call_table)
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
 	.long sys_recvmmsg
+	.long sys_sched_setscheduler_ex
+	.long sys_sched_setparam_ex
+	.long sys_sched_getparam_ex	/* 340 */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cd24a7a..3c466a6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -95,6 +95,57 @@ struct sched_param {
=20
 #include <asm/processor.h>
=20
+/*
+ * Extended scheduling parameters data structure.
+ *
+ * This is needed because the original struct sched_param can not be
+ * altered without introducing ABI issues with legacy applications
+ * (e.g., in sched_getparam()).
+ *
+ * However, the possibility of specifying more than just a priority for
+ * the tasks may be useful for a wide variety of application fields, e.g.,
+ * multimedia, streaming, automation and control, and many others.
+ *
+ * This variant (sched_param_ex) is meant at describing a so-called
+ * sporadic time-constrained task. In such model a task is specified by:
+ *  - the activation period or minimum instance inter-arrival time;
+ *  - the maximum (or average, depending on the actual scheduling
+ *    discipline) computation time of all instances, a.k.a. runtime;
+ *  - the deadline (relative to the actual activation time) of each
+ *    instance.
+ * Very briefly, a periodic (sporadic) task asks for the execution of
+ * some specific computation --which is typically called an instance--
+ * (at most) every period. Moreover, each instance typically lasts no more
+ * than the runtime and must be completed by time instant t equal to
+ * the instance activation time + the deadline.
+ *
+ * This is reflected by the actual fields of the sched_param_ex structure:
+ *
+ *  @sched_priority:    task's priority (might be still useful)
+ *  @sched_deadline:    representative of the task's deadline
+ *  @sched_runtime:     representative of the task's runtime
+ *  @sched_period:      representative of the task's period
+ *  @sched_flags:       available for specifying some specific
+ *                      task or scheduling behaviour
+ *
+ * Given this task model, there are a multiplicity of scheduling algorithm=
s
+ * and policies, each with its own advantages and drawbacks in having all
+ * the tasks make their timing constraint.
+ *
+ * As of now, the SCHED_DEADLINE policy (sched_dl scheduling class) is the
+ * only user of this new interface. It right now assumes deadlines are
+ * always equal to periods, thus it does not use the sched_period field.
+ * More information about the algorithm are available in the scheduling
+ * class file or in Documentation/.
+ */
+struct sched_param_ex {
+	int sched_priority;
+	struct timespec sched_runtime;
+	struct timespec sched_deadline;
+	struct timespec sched_period;
+	unsigned int sched_flags;
+};
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -2048,6 +2099,9 @@ extern int idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, struct sched_para=
m *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      struct sched_param *);
+extern int sched_setscheduler_ex(struct task_struct *, int,
+				 struct sched_param *,
+				 struct sched_param_ex *);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 207466a..9e3ad66 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -34,6 +34,7 @@ struct pollfd;
 struct rlimit;
 struct rusage;
 struct sched_param;
+struct sched_param_ex;
 struct semaphore;
 struct sembuf;
 struct shmid_ds;
@@ -340,11 +341,17 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_c=
lock, int flags,
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setscheduler_ex(pid_t pid, int policy, unsigned =
len,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setparam_ex(pid_t pid, unsigned len,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_getparam_ex(pid_t pid, unsigned len,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/kernel/sched.c b/kernel/sched.c
index c5ee6f9..19e90fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6288,7 +6288,13 @@ __setscheduler(struct rq *rq, struct task_struct *p,=
 int policy, int prio)
 	p->normal_prio =3D normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio =3D rt_mutex_getprio(p);
-	if (rt_prio(p->prio))
+
+	/*
+	 * FIXME: deadline inheritance needed here!!
+	 */
+	if (dl_policy(policy))
+		p->sched_class =3D &dl_sched_class;
+	else if (rt_prio(p->prio))
 		p->sched_class =3D &rt_sched_class;
 	else
 		p->sched_class =3D &fair_sched_class;
@@ -6296,6 +6302,50 @@ __setscheduler(struct rq *rq, struct task_struct *p,=
 int policy, int prio)
 }
=20
 /*
+ * This function initializes the sched_dl_entity of a newly becoming
+ * SCHED_DEADLINE task.
+ *
+ * Only the static values are considered here, the actual runtime and the
+ * absolute deadline will be properly calculated when the task is enqueued
+ * for the first time with its new policy.
+ */
+static void
+__setparam_dl(struct task_struct *p, struct sched_param_ex *param_ex)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	dl_se->dl_runtime =3D timespec_to_ns(&param_ex->sched_runtime);
+	dl_se->dl_deadline =3D timespec_to_ns(&param_ex->sched_deadline);
+	dl_se->flags =3D param_ex->sched_flags;
+	dl_se->flags &=3D ~DL_THROTTLED;
+	dl_se->flags |=3D DL_NEW;
+}
+
+static void
+__getparam_dl(struct task_struct *p, struct sched_param_ex *param_ex)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	param_ex->sched_priority =3D p->rt_priority;
+	param_ex->sched_runtime =3D ns_to_timespec(dl_se->dl_runtime);
+	param_ex->sched_deadline =3D ns_to_timespec(dl_se->dl_deadline);
+	param_ex->sched_flags =3D dl_se->flags;
+}
+
+/*
+ * This function validates the new parameters of a -deadline task.
+ * We ask for the deadline not being zero, and greater or equal
+ * than the runtime.
+ */
+static bool
+__checkparam_dl(struct sched_param_ex *prm)
+{
+	return prm && timespec_to_ns(&prm->sched_deadline) !=3D 0 &&
+	       timespec_to_ns(&prm->sched_deadline) >=3D
+	       timespec_to_ns(&prm->sched_runtime);
+}
+
+/*
  * check the target process has a UID that matches the current process's
  */
 static bool check_same_owner(struct task_struct *p)
@@ -6312,7 +6362,9 @@ static bool check_same_owner(struct task_struct *p)
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
@@ -6347,7 +6399,8 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if (rt_policy(policy) !=3D (param->sched_priority !=3D 0))
+	if ((dl_policy(policy) && !__checkparam_dl(param_ex)) ||
+	    (rt_policy(policy) !=3D (param->sched_priority !=3D 0)))
 		return -EINVAL;
=20
 	/*
@@ -6431,6 +6484,8 @@ recheck:
 	p->sched_reset_on_fork =3D reset_on_fork;
=20
 	oldprio =3D p->prio;
+	if (dl_policy(policy))
+		__setparam_dl(p, param_ex);
 	__setscheduler(rq, p, policy, param->sched_priority);
=20
 	if (running)
@@ -6459,10 +6514,18 @@ recheck:
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
+EXPORT_SYMBOL_GPL(sched_setscheduler_ex);
+
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT pri=
ority of a thread from kernelspace.
  * @p: the task in question.
@@ -6477,7 +6540,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, false);
+	return __sched_setscheduler(p, policy, param, NULL, false);
 }
=20
 static int
@@ -6502,6 +6565,36 @@ do_sched_setscheduler(pid_t pid, int policy, struct =
sched_param __user *param)
 	return retval;
 }
=20
+static int
+do_sched_setscheduler_ex(pid_t pid, int policy, unsigned len,
+			 struct sched_param_ex __user *param_ex)
+{
+	struct sched_param lparam;
+	struct sched_param_ex lparam_ex;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+	if (len > sizeof(lparam_ex))
+		return -EINVAL;
+
+	memset(&lparam_ex, 0, sizeof(lparam_ex));
+	if (copy_from_user(&lparam_ex, param_ex, len))
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
@@ -6519,6 +6612,22 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int,=
 policy,
 }
=20
 /**
+ * sys_sched_setscheduler_ex - same as above, but with extended sched_para=
m
+ * @pid: the pid in question.
+ * @policy: new policy (could use extended sched_param).
+ * @len: size of data pointed by param_ex.
+ * @param: structure containg the extended parameters.
+ */
+SYSCALL_DEFINE4(sched_setscheduler_ex, pid_t, pid, int, policy,
+		unsigned, len, struct sched_param_ex __user *, param_ex)
+{
+	if (policy < 0)
+		return -EINVAL;
+
+	return do_sched_setscheduler_ex(pid, policy, len, param_ex);
+}
+
+/**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
@@ -6529,6 +6638,18 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct s=
ched_param __user *, param)
 }
=20
 /**
+ * sys_sched_setparam_ex - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @len: size of data pointed by param_ex.
+ * @param_ex: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE3(sched_setparam_ex, pid_t, pid, unsigned, len,
+		struct sched_param_ex __user *, param_ex)
+{
+	return do_sched_setscheduler_ex(pid, -1, len, param_ex);
+}
+
+/**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
  */
@@ -6592,6 +6713,51 @@ out_unlock:
 	return retval;
 }
=20
+/**
+ * sys_sched_getparam_ex - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @len: size of data pointed by param_ex.
+ * @param_ex: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE3(sched_getparam_ex, pid_t, pid, unsigned, len,
+		struct sched_param_ex __user *, param_ex)
+{
+	struct sched_param_ex lp;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+	if (len > sizeof(lp))
+		return -EINVAL;
+
+	rcu_read_lock();
+	p =3D find_process_by_pid(pid);
+	retval =3D -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval =3D security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	if (task_has_dl_policy(p))
+		__getparam_dl(p, &lp);
+	rcu_read_unlock();
+
+	/*
+	 * This one might sleep, we cannot do it with a spinlock held ...
+	 */
+	retval =3D copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
+
+	return retval;
+
+out_unlock:
+	rcu_read_unlock();
+	return retval;
+
+}
+
 long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 {
 	cpumask_var_t cpus_allowed, new_mask;
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-cis59CrWf6kMlqYy2Rpf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKwYEACgkQk4XaBE3IOsRFAgCfbU+H7KLF2yWnN1QEC3MuVAkP
KXcAoKxUo1VwDVXJqxXunyw0KvnLUVMu
=rHaH
-----END PGP SIGNATURE-----

--=-cis59CrWf6kMlqYy2Rpf--

