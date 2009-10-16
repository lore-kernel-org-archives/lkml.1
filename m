Return-Path: <linux-kernel-owner+w=401wt.eu-S1762538AbZJPPp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762538AbZJPPp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761739AbZJPPp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:45:28 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54421 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760234AbZJPPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:45:15 -0400
Subject: [RFC 8/12][PATCH] SCHED_DEADLINE: wait next instance syscall added.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BOfZaxkreQgg5t1BT88n"
Date: Fri, 16 Oct 2009 17:44:58 +0200
Message-Id: <1255707898.6228.463.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BOfZaxkreQgg5t1BT88n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commit introduces another new SCHED_DEADLINE related syscall. It is
called sched_wait_interval() and it has close-to-clock_nanosleep semantic.

However, for SCHED_DEADLINE tasks, it should be the call with which each
job closes its current instance. In fact, in this case, the task is put to
sleep and, when it wakes up, the scheduler is informed that a new job
arrived, saving the overhead that usually comes with a task activation
to enforce maximum task bandwidth.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 arch/arm/include/asm/unistd.h      |    1 +
 arch/arm/kernel/calls.S            |    1 +
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 +-
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/linux/sched.h              |    1 +
 include/linux/syscalls.h           |    3 ++
 kernel/sched.c                     |   71 ++++++++++++++++++++++++++++++++=
++++
 kernel/sched_deadline.c            |    9 +++++
 10 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 09b927e..769ced1 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -394,6 +394,7 @@
 #define __NR_sched_setscheduler_ex	(__NR_SYSCALL_BASE+365)
 #define __NR_sched_setparam_ex		(__NR_SYSCALL_BASE+366)
 #define __NR_sched_getparam_ex		(__NR_SYSCALL_BASE+367)
+#define __NR_sched_wait_interval	(__NR_SYSCALL_BASE+368)
=20
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 42ad362..8292271 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -377,6 +377,7 @@
 /* 365 */	CALL(sys_sched_setscheduler_ex)
 		CALL(sys_sched_setparam_ex)
 		CALL(sys_sched_getparam_ex)
+		CALL(sys_sched_wait_interval)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 3d04691..9306b80 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -845,4 +845,5 @@ ia32_sys_call_table:
 	.quad sys_sched_setscheduler_ex
 	.quad sys_sched_setparam_ex
 	.quad sys_sched_getparam_ex
+	.quad sys_sched_wait_interval		/* 340 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd=
_32.h
index 3928c04..63954cb 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -345,10 +345,11 @@
 #define __NR_sched_setscheduler_ex	337
 #define __NR_sched_setparam_ex		338
 #define __NR_sched_getparam_ex		339
+#define __NR_sched_wait_interval	340
=20
 #ifdef __KERNEL__
=20
-#define NR_syscalls 340
+#define NR_syscalls 341
=20
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd=
_64.h
index 84b0743..63cccc7 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -667,6 +667,8 @@ __SYSCALL(__NR_sched_setscheduler_ex, sys_sched_setsche=
duler_ex)
 __SYSCALL(__NR_sched_setparam_ex, sys_sched_setparam_ex)
 #define __NR_sched_getparam_ex			301
 __SYSCALL(__NR_sched_getparam_ex, sys_sched_getparam_ex)
+#define __NR_sched_wait_interval		302
+__SYSCALL(__NR_sched_wait_interval, sys_sched_wait_interval)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_t=
able_32.S
index 38f056c..bd2cc8e 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -339,3 +339,4 @@ ENTRY(sys_call_table)
 	.long sys_sched_setscheduler_ex
 	.long sys_sched_setparam_ex
 	.long sys_sched_getparam_ex
+	.long sys_sched_wait_interval	/* 340 */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 16668f9..478e07c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1088,6 +1088,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
+	void (*wait_interval) (struct task_struct *p);
=20
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int fla=
gs);
=20
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index dad0b33..e01f59c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -407,6 +407,9 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsign=
ed int len,
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_yield(void);
+asmlinkage long sys_sched_wait_interval(int flags,
+					const struct timespec __user *rqtp,
+					struct timespec __user *rmtp);
 asmlinkage long sys_sched_get_priority_max(int policy);
 asmlinkage long sys_sched_get_priority_min(int policy);
 asmlinkage long sys_sched_rr_get_interval(pid_t pid,
diff --git a/kernel/sched.c b/kernel/sched.c
index 2c974fd..3c3e834 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6832,6 +6832,77 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
=20
+/**
+ * sys_sched_wait_interval - sleep according to the scheduling class rules=
.
+ *
+ * This function makes the task sleep for an absolute or relative interval
+ * (clock_nanosleep semantic). The only difference is that, before stoppin=
g
+ * the task, it asks its scheduling class if some class specific logic nee=
ds
+ * to be triggered right after the wakeup.
+ */
+SYSCALL_DEFINE3(sched_wait_interval, int, flags,
+		const struct timespec __user *, rqtp,
+		struct timespec __user *, rmtp)
+{
+	struct timespec lrqtp;
+	struct hrtimer_sleeper t;
+	enum hrtimer_mode mode =3D flags & TIMER_ABSTIME ?
+				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
+	int ret =3D 0;
+
+	if (copy_from_user(&lrqtp, rqtp, sizeof(lrqtp)))
+		return -EFAULT;
+
+	if (!timespec_valid(&lrqtp))
+		return -EINVAL;
+
+	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
+	hrtimer_set_expires(&t.timer, timespec_to_ktime(*rqtp));
+	hrtimer_init_sleeper(&t, current);
+	do {
+		set_current_state(TASK_INTERRUPTIBLE);
+		hrtimer_start_expires(&t.timer, mode);
+		if (!hrtimer_active(&t.timer))
+			t.task =3D NULL;
+
+		if (likely(t.task)) {
+			if (t.task->sched_class->wait_interval)
+				t.task->sched_class->wait_interval(t.task);
+			schedule();
+		}
+
+		hrtimer_cancel(&t.timer);
+		mode =3D HRTIMER_MODE_ABS;
+	} while (t.task && !signal_pending(current));
+	__set_current_state(TASK_RUNNING);
+
+	if (t.task =3D=3D NULL)
+		goto out;
+
+	/* Absolute timers don't need this to be restarted. */
+	if (mode =3D=3D HRTIMER_MODE_ABS) {
+		ret =3D -ERESTARTNOHAND;
+		goto out;
+	}
+
+	if (rmtp) {
+		ktime_t rmt;
+		struct timespec rmt_ts;
+
+		rmt =3D hrtimer_expires_remaining(&t.timer);
+		if (rmt.tv64 > 0)
+			goto out;
+		rmt_ts =3D ktime_to_timespec(rmt);
+		if (!timespec_valid(&rmt_ts))
+			goto out;
+		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+			ret =3D -EFAULT;
+	}
+out:
+	destroy_hrtimer_on_stack(&t.timer);
+	return ret;
+}
+
 static inline int should_resched(void)
 {
 	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
diff --git a/kernel/sched_deadline.c b/kernel/sched_deadline.c
index 7b57bb0..82c0192 100644
--- a/kernel/sched_deadline.c
+++ b/kernel/sched_deadline.c
@@ -401,6 +401,14 @@ static void yield_task_deadline(struct rq *rq)
 {
 }
=20
+/*
+ * Informs the scheduler that an instance ended.
+ */
+static void wait_interval_deadline(struct task_struct *p)
+{
+	p->dl.flags |=3D DL_NEW;
+}
+
 #ifdef CONFIG_SCHED_HRTICK
 static void start_hrtick_deadline(struct rq *rq, struct task_struct *p)
 {
@@ -538,6 +546,7 @@ static const struct sched_class deadline_sched_class =
=3D {
 	.enqueue_task		=3D enqueue_task_deadline,
 	.dequeue_task		=3D dequeue_task_deadline,
 	.yield_task		=3D yield_task_deadline,
+	.wait_interval		=3D wait_interval_deadline,
=20
 	.check_preempt_curr	=3D check_preempt_curr_deadline,
=20
--=20
1.6.0.4


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-BOfZaxkreQgg5t1BT88n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlPoACgkQk4XaBE3IOsRlkwCfaRu6yAuXmfkLDD1C9/vzRRRu
t2gAoIvrIeBlyzUUnjIl5UWLoNVnmV3Q
=1LFV
-----END PGP SIGNATURE-----

--=-BOfZaxkreQgg5t1BT88n--

