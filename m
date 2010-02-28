Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936568Ab0B1TTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:19:45 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42382 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936423Ab0B1TTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:19:44 -0500
Subject: [RFC][PATCH 04/11] sched: add resource limits for -deadline tasks.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JdKEVXRsrQrnePXFOWok"
Date: Sun, 28 Feb 2010 20:19:34 +0100
Message-ID: <1267384774.13676.91.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JdKEVXRsrQrnePXFOWok
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add resource limits for non-root tasks in using the SCHED_DEADLINE
policy, very similarly to what already exists for RT policies.

In fact, this patch:
 - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
   a user task can use as its own deadline;
 - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
   a user task can use as it own runtime.

Notice that to exploit these, a modified version of the ulimit
utility and a modified resource.h header file are needed. They
both will be available on the website of the project.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/asm-generic/resource.h |    7 ++++++-
 kernel/sched.c                 |   25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.=
h
index 587566f..4a1d0e2 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -45,7 +45,10 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+
+#define RLIMIT_DLDLINE		16	/* minimum deadline in us */
+#define RLIMIT_DLRTIME		17	/* maximum runtime in us */
+#define RLIM_NLIMITS		18
=20
 /*
  * SuS says limits have to be unsigned.
@@ -87,6 +90,8 @@
 	[RLIMIT_NICE]		=3D { 0, 0 },				\
 	[RLIMIT_RTPRIO]		=3D { 0, 0 },				\
 	[RLIMIT_RTTIME]		=3D {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_DLDLINE]	=3D { ULONG_MAX, ULONG_MAX },		\
+	[RLIMIT_DLRTIME]	=3D { 0, 0 },				\
 }
=20
 #endif	/* __KERNEL__ */
diff --git a/kernel/sched.c b/kernel/sched.c
index 19e90fc..61b1561 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6407,6 +6407,31 @@ recheck:
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
+		if (dl_policy(policy)) {
+			u64 rlim_dline, rlim_rtime;
+			u64 dline, rtime;
+
+			if (!lock_task_sighand(p, &flags))
+				return -ESRCH;
+			rlim_dline =3D p->signal->rlim[RLIMIT_DLDLINE].rlim_cur;
+			rlim_rtime =3D p->signal->rlim[RLIMIT_DLRTIME].rlim_cur;
+			unlock_task_sighand(p, &flags);
+
+			/* can't set/change -deadline policy */
+			if (policy !=3D p->policy && !rlim_rtime)
+				return -EPERM;
+
+			/* can't decrease the deadline */
+			rlim_dline *=3D NSEC_PER_USEC;
+			dline =3D timespec_to_ns(&param_ex->sched_deadline);
+			if (dline < p->dl.dl_deadline && dline < rlim_dline)
+				return -EPERM;
+			/* can't increase the runtime */
+			rlim_rtime *=3D NSEC_PER_USEC;
+			rtime =3D timespec_to_ns(&param_ex->sched_runtime);
+			if (rtime > p->dl.dl_runtime && rtime > rlim_rtime)
+				return -EPERM;
+		}
 		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio;
=20
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-JdKEVXRsrQrnePXFOWok
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKwcUACgkQk4XaBE3IOsQ0EQCfcu9ciMKDRbXAH293OxAbnbl0
9w8AnRHrhi6GPWmCeqYBbStLUhWdGpl/
=EegS
-----END PGP SIGNATURE-----

--=-JdKEVXRsrQrnePXFOWok--

