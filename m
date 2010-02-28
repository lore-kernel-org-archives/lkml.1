Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936576Ab0B1TVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:21:10 -0500
Received: from ms01.sssup.it ([193.205.80.99]:58356 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936455Ab0B1TVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:21:08 -0500
Subject: [RFC][PATCH 05/11] sched: add a syscall to wait for the next
 instance.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Za7WkWIBz0fcOHQgJOC6"
Date: Sun, 28 Feb 2010 20:20:57 +0100
Message-ID: <1267384857.13676.93.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Za7WkWIBz0fcOHQgJOC6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Introduce sched_wait_interval() syscall (and scheduling class
interface call). In general, this aims at providing each scheduling
class with a mean of making one of its own task sleep for some time
according to some specific rule of the scheduling class itself.

As of now, the sched_dl scheduling class is the only one that needs
this kind of service, and thus the only one that implements the
class-specific logic. For other classes, calling it will result in
the same effect than calling clock_nanosleep with CLOCK_MONOTONIC
clockid and the TIMER_ABSTIME flag on.

For -deadline task, the idea is to give them the possibility of
notifying the scheduler a periodic/sporadic instance just ended and
ask it to wake up them at the beginning of the next one, with:
 - fully replenished runtime and
 - the absolute deadline set just one relative deadline interval
   away from the wakeup time.
This is an effective mean of synchronizing the task's behaviour with
the scheduler one, which might be useful in some situations.

This patch:
 - adds the new syscall (x83-32, x86-64 and ARM, but extension to all
   archs is strightforward);
 - implements the class-specific logic for -deadline tasks, making it
   impossible for them to exploit this call to use more bandwidth than
   they are given.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 arch/arm/include/asm/unistd.h      |    1 +
 arch/arm/kernel/calls.S            |    1 +
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 +-
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/linux/sched.h              |    2 +
 include/linux/syscalls.h           |    2 +
 kernel/sched.c                     |   39 +++++++++++++++++++
 kernel/sched_dl.c                  |   74 ++++++++++++++++++++++++++++++++=
+++-
 10 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index e741cd6..8ca0ece 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -395,6 +395,7 @@
 #define __NR_sched_setscheduler_ex	(__NR_SYSCALL_BASE+366)
 #define __NR_sched_setparam_ex		(__NR_SYSCALL_BASE+367)
 #define __NR_sched_getparam_ex		(__NR_SYSCALL_BASE+368)
+#define __NR_sched_wait_interval	(__NR_SYSCALL_BASE+369)
=20
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 8eeb552..6cb3842 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -378,6 +378,7 @@
 		CALL(sys_sched_setscheduler_ex)
 		CALL(sys_sched_setparam_ex)
 		CALL(sys_sched_getparam_ex)
+		CALL(sys_sched_wait_interval)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index f24e9fa..85d383b 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -845,4 +845,5 @@ ia32_sys_call_table:
 	.quad sys_sched_setscheduler_ex
 	.quad sys_sched_setparam_ex
 	.quad sys_sched_getparam_ex		/* 340 */
+	.quad sys_sched_wait_interval
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd=
_32.h
index 1db148b..83c8a3f 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,11 @@
 #define __NR_sched_setscheduler_ex	338
 #define __NR_sched_setparam_ex		339
 #define __NR_sched_getparam_ex		340
+#define __NR_sched_wait_interval	341
=20
 #ifdef __KERNEL__
=20
-#define NR_syscalls 341
+#define NR_syscalls 342
=20
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd=
_64.h
index d254154..b9e3356 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,8 @@ __SYSCALL(__NR_sched_setscheduler_ex, sys_sched_setsche=
duler_ex)
 __SYSCALL(__NR_sched_setparam_ex, sys_sched_setparam_ex)
 #define __NR_sched_getparam_ex			302
 __SYSCALL(__NR_sched_getparam_ex, sys_sched_getparam_ex)
+#define __NR_sched_wait_interval		303
+__SYSCALL(__NR_sched_wait_interval, sys_sched_wait_interval)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_t=
able_32.S
index e27e002..1609ba9 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,4 @@ ENTRY(sys_call_table)
 	.long sys_sched_setscheduler_ex
 	.long sys_sched_setparam_ex
 	.long sys_sched_getparam_ex	/* 340 */
+	.long sys_sched_wait_interval
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3c466a6..e6c1cda 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1139,6 +1139,8 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
+	long (*wait_interval) (struct task_struct *p, struct timespec *rqtp,
+			       struct timespec __user *rmtp);
=20
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int fla=
gs);
=20
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 9e3ad66..97eb7c4 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -357,6 +357,8 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsign=
ed int len,
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_yield(void);
+asmlinkage long sys_sched_wait_interval(const struct timespec __user *rqtp=
,
+					struct timespec *rmtp);
 asmlinkage long sys_sched_get_priority_max(int policy);
 asmlinkage long sys_sched_get_priority_min(int policy);
 asmlinkage long sys_sched_rr_get_interval(pid_t pid,
diff --git a/kernel/sched.c b/kernel/sched.c
index 61b1561..d5e8b6c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6966,6 +6966,45 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
=20
+/**
+ * sys_sched_wait_interval - sleep according to the scheduling class rules=
.
+ *
+ * This function is implemented inside each scheduling class, in case it
+ * wants to provide its tasks a mean of waiting a specific instant in
+ * time, while also honouring some specific rule of itself.
+ */
+SYSCALL_DEFINE2(sched_wait_interval,
+	const struct timespec __user *, rqtp,
+	struct timespec __user *, rmtp)
+{
+	struct timespec lrq, lrm;
+	int ret;
+
+	if (rqtp !=3D NULL) {
+		if (copy_from_user(&lrq, rqtp, sizeof(struct timespec)))
+			return -EFAULT;
+		if (!timespec_valid(&lrq))
+			return -EINVAL;
+	}
+
+	if (current->sched_class->wait_interval)
+		ret =3D current->sched_class->wait_interval(current,
+							  rqtp ? &lrq : NULL,
+							  &lrm);
+	else {
+		if (!rqtp)
+			return -EINVAL;
+
+		ret =3D hrtimer_nanosleep(&lrq, &lrm, HRTIMER_MODE_ABS,
+					CLOCK_MONOTONIC);
+	}
+
+	if (rmtp && copy_to_user(rmtp, &lrm, sizeof(struct timespec)))
+		return -EFAULT;
+
+	return ret;
+}
+
 static inline int should_resched(void)
 {
 	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 7585227..a1202ac 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -268,7 +268,7 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_=
entity *dl_se)
 	int dmiss =3D dl_time_before(dl_se->deadline, rq->clock);
 	int rorun =3D dl_se->runtime <=3D 0;
=20
-	if (!rorun && !dmiss)
+	if (dl_se->flags & DL_NEW || (!rorun && !dmiss))
 		return 0;
=20
 	/*
@@ -424,6 +424,77 @@ static void yield_task_dl(struct rq *rq)
 {
 }
=20
+/*
+ * This function makes the task sleep until at least the absolute time
+ * instant specified in @rqtp.
+ * The _at_least_ part comes from the fact that we want to be able
+ * to give the task --as soon as it wakes-up-- its full runtime.
+ * Therefore, if e.g. it is in overrun when this function is invoked,
+ * of if @rqtp is too early, the sleeping time might be longer than asked.
+ * It is intended to be used at the end of a periodic -deadline task
+ * instance.
+ */
+long wait_interval_dl(struct task_struct *p, struct timespec *rqtp,
+		      struct timespec *rmtp)
+{
+	unsigned long flags;
+	struct sched_dl_entity *dl_se =3D &p->dl;
+	struct rq *rq =3D task_rq_lock(p, &flags);
+	struct timespec lrqtp;
+	u64 wakeup;
+
+	p->dl.flags |=3D DL_NEW;
+	update_curr_dl(rq);
+
+	/*
+	 * Task is asking for a new instance with full runtime but, since
+	 * it is in overrun, the only thing we can do is putting it to sleep
+	 * until the time it will have payed back for that (which could
+	 * be its next deadline or farther).
+	 */
+	if (dl_se->runtime < 0) {
+		u64 runtime_exec =3D dl_se->dl_runtime - dl_se->runtime;
+		u64 rorun_ratio =3D runtime_exec / dl_se->dl_runtime;
+
+		WARN_ON(rorun_ratio =3D=3D 0);
+
+		wakeup =3D dl_se->deadline + dl_se->dl_deadline * rorun_ratio;
+		goto unlock;
+	}
+
+	if (!rqtp) {
+		wakeup =3D p->dl.deadline;
+		goto unlock;
+	}
+
+	/*
+	 * If the tasks wants to wake up _before_ its absolute deadline
+	 * we must be sure that reusing its (actual) runtime and deadline
+	 * at that time _would_ overcome its bandwidth limitation, so
+	 * that we know it will be given new parameters.
+	 *
+	 * If this is not true, we postpone the wake-up time up to the right
+	 * instant. This involves a division (to calculate the reverse of the
+	 * task's bandwidth), but it is worth to notice that it is quite
+	 * unlikely that we get into here very often.
+	 */
+	wakeup =3D timespec_to_ns(rqtp);
+	if (dl_time_before(wakeup, dl_se->deadline) &&
+	    dl_check_bandwidth(dl_se, wakeup)) {
+		u64 ibw =3D (u64)dl_se->runtime * dl_se->dl_deadline;
+
+		ibw =3D div_u64(ibw, dl_se->dl_runtime);
+		wakeup =3D dl_se->deadline - ibw;
+	}
+
+unlock:
+	task_rq_unlock(rq, &flags);
+	lrqtp =3D ns_to_timespec(wakeup);
+
+	return hrtimer_nanosleep(&lrqtp, rmtp, HRTIMER_MODE_ABS,
+				 CLOCK_MONOTONIC);
+}
+
 #ifdef CONFIG_SCHED_HRTICK
 static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
@@ -580,6 +651,7 @@ static const struct sched_class dl_sched_class =3D {
 	.enqueue_task		=3D enqueue_task_dl,
 	.dequeue_task		=3D dequeue_task_dl,
 	.yield_task		=3D yield_task_dl,
+	.wait_interval		=3D wait_interval_dl,
=20
 	.check_preempt_curr	=3D check_preempt_curr_dl,
=20
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-Za7WkWIBz0fcOHQgJOC6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKwhgACgkQk4XaBE3IOsR5ugCgpfdIX+3RZjMVtDkq3Z+eE92k
A3YAn2FVkOVx9H7petWbJC0CSEjUOwIq
=FihU
-----END PGP SIGNATURE-----

--=-Za7WkWIBz0fcOHQgJOC6--

