Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbZJPPss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbZJPPss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762251AbZJPPsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:48:47 -0400
Received: from ms01.sssup.it ([193.205.80.99]:47058 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760234AbZJPPsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:48:46 -0400
Subject: [RFC 12/12][PATCH] SCHED_DEADLINE: modified sched_*_ex API
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7Sck6jxDB2erbtV4Ug+d"
Date: Fri, 16 Oct 2009 17:48:06 +0200
Message-Id: <1255708086.6228.469.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7Sck6jxDB2erbtV4Ug+d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commit amends the new API introduced to deal with the new sched_param_=
ex
scheduling parameter data structure.

What we add is one more parameter to all the functions, containing the size=
 of
sched_param_ex. It might turn out useful in possible future extensions of
sched_param_ex itself, to avoid issue with ABI of legacy applications.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 include/linux/syscalls.h |    6 +++---
 kernel/sched.c           |   25 ++++++++++++++++---------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e01f59c..60a99a7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -391,16 +391,16 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_c=
lock, int flags,
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
-asmlinkage long sys_sched_setscheduler_ex(pid_t pid, int policy,
+asmlinkage long sys_sched_setscheduler_ex(pid_t pid, int policy, unsigned =
len,
 					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
-asmlinkage long sys_sched_setparam_ex(pid_t pid,
+asmlinkage long sys_sched_setparam_ex(pid_t pid, unsigned len,
 					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
-asmlinkage long sys_sched_getparam_ex(pid_t pid,
+asmlinkage long sys_sched_getparam_ex(pid_t pid, unsigned len,
 					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
diff --git a/kernel/sched.c b/kernel/sched.c
index a8ebfa2..d3a61f5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6662,7 +6662,7 @@ do_sched_setscheduler(pid_t pid, int policy, struct s=
ched_param __user *param)
 }
=20
 static int
-do_sched_setscheduler_ex(pid_t pid, int policy,
+do_sched_setscheduler_ex(pid_t pid, int policy, unsigned int len,
 			 struct sched_param_ex __user *param_ex)
 {
 	struct sched_param lparam;
@@ -6672,8 +6672,9 @@ do_sched_setscheduler_ex(pid_t pid, int policy,
=20
 	if (!param_ex || pid < 0)
 		return -EINVAL;
-	if (copy_from_user(&lparam_ex, param_ex,
-	    sizeof(struct sched_param_ex)))
+	if (len > sizeof(struct sched_param_ex))
+		return -EINVAL;
+	if (copy_from_user(&lparam_ex, param_ex,len))
 		return -EFAULT;
=20
 	rcu_read_lock();
@@ -6708,15 +6709,17 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int=
, policy,
  * sys_sched_setscheduler_ex - set/change the scheduler policy to SCHED_DE=
ADLINE
  * @pid: the pid in question.
  * @policy: new policy (should be SCHED_DEADLINE).
+ * @len: size of data pointed by param_ex.
  * @param: structure containg the extended deadline parameters.
  */
-SYSCALL_DEFINE3(sched_setscheduler_ex, pid_t, pid, int, policy,
+SYSCALL_DEFINE4(sched_setscheduler_ex, pid_t, pid,
+		int, policy, unsigned, len,
 		struct sched_param_ex __user *, param_ex)
 {
 	if (policy < 0)
 		return -EINVAL;
=20
-	return do_sched_setscheduler_ex(pid, policy, param_ex);
+	return do_sched_setscheduler_ex(pid, policy, len, param_ex);
 }
=20
 /**
@@ -6732,12 +6735,13 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct =
sched_param __user *, param)
 /**
  * sys_sched_setparam - set/change the DEADLINE parameters of a thread
  * @pid: the pid in question.
+ * @len: size of data pointed by param_ex.
  * @param_ex: structure containing the new parameters (deadline, runtime, =
etc.).
  */
-SYSCALL_DEFINE2(sched_setparam_ex, pid_t, pid,
+SYSCALL_DEFINE3(sched_setparam_ex, pid_t, pid, unsigned, len,
 		struct sched_param_ex __user *, param_ex)
 {
-	return do_sched_setscheduler_ex(pid, -1, param_ex);
+	return do_sched_setscheduler_ex(pid, -1, len, param_ex);
 }
=20
 /**
@@ -6807,9 +6811,10 @@ out_unlock:
 /**
  * sys_sched_getparam - get the DEADLINE task parameters of a thread
  * @pid: the pid in question.
+ * @len: size of data pointed by param_ex.
  * @param_ex: structure containing the new parameters (deadline, runtime, =
etc.).
  */
-SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
+SYSCALL_DEFINE3(sched_getparam_ex, pid_t, pid, unsigned, len,
 		struct sched_param_ex __user *, param_ex)
 {
 	struct sched_param_ex lp;
@@ -6818,6 +6823,8 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
=20
 	if (!param_ex || pid < 0)
 		return -EINVAL;
+	if (len < sizeof(struct sched_param_ex))
+		return -EINVAL;
=20
 	read_lock(&tasklist_lock);
 	p =3D find_process_by_pid(pid);
@@ -6837,7 +6844,7 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
 	/*
 	 * This one might sleep, we cannot do it with a spinlock held ...
 	 */
-	retval =3D copy_to_user(param_ex, &lp, sizeof(*param_ex)) ? -EFAULT : 0;
+	retval =3D copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
=20
 	return retval;
=20
--=20
1.6.0.4

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-7Sck6jxDB2erbtV4Ug+d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlbYACgkQk4XaBE3IOsSh/wCcCRYQO35w+NmEt0A2tUckKYZ+
dM4AnilT+lai81rp8uvI/fXnaJTwRGLw
=rr7T
-----END PGP SIGNATURE-----

--=-7Sck6jxDB2erbtV4Ug+d--

