Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbZJPPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbZJPPoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbZJPPoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:44:16 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54361 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753977AbZJPPoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:44:15 -0400
Subject: [RFC 6/12][PATCH] SCHED_DEADLINE: added scheduling latency tracer
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ME1Af5xhCfypVEcN9yjB"
Date: Fri, 16 Oct 2009 17:43:35 +0200
Message-Id: <1255707815.6228.460.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ME1Af5xhCfypVEcN9yjB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commit adds a new ftrace tracer 'wakeup_deadline', to trace the maximu=
m
wakeup latency of SCHED_DEADLINE tasks.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 kernel/trace/trace_sched_wakeup.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index 26185d7..180948c 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -27,6 +27,7 @@ static int			wakeup_cpu;
 static int			wakeup_current_cpu;
 static unsigned			wakeup_prio =3D -1;
 static int			wakeup_rt;
+static int			wakeup_deadline;
=20
 static raw_spinlock_t wakeup_lock =3D
 	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
@@ -214,6 +215,9 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int =
success)
 	tracing_record_cmdline(p);
 	tracing_record_cmdline(current);
=20
+	if (wakeup_deadline && !deadline_task(p))
+		return;
+
 	if ((wakeup_rt && !rt_task(p)) ||
 			p->prio >=3D wakeup_prio ||
 			p->prio >=3D current->prio)
@@ -340,16 +344,25 @@ static int __wakeup_tracer_init(struct trace_array *t=
r)
=20
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	wakeup_deadline =3D 0;
 	wakeup_rt =3D 0;
 	return __wakeup_tracer_init(tr);
 }
=20
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	wakeup_deadline =3D 0;
 	wakeup_rt =3D 1;
 	return __wakeup_tracer_init(tr);
 }
=20
+static int wakeup_deadline_tracer_init(struct trace_array *tr)
+{
+	wakeup_deadline =3D 1;
+	wakeup_rt =3D 0;
+	return __wakeup_tracer_init(tr);
+}
+
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
 	stop_wakeup_tracer(tr);
@@ -398,6 +411,20 @@ static struct tracer wakeup_rt_tracer __read_mostly =
=3D
 #endif
 };
=20
+static struct tracer wakeup_deadline_tracer __read_mostly =3D
+{
+	.name		=3D "wakeup_deadline",
+	.init		=3D wakeup_deadline_tracer_init,
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
@@ -410,6 +437,10 @@ __init static int init_wakeup_tracer(void)
 	if (ret)
 		return ret;
=20
+	ret =3D register_tracer(&wakeup_deadline_tracer);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 device_initcall(init_wakeup_tracer);
--=20
1.6.0.4


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ME1Af5xhCfypVEcN9yjB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlKcACgkQk4XaBE3IOsSOnACfWg4NZXsbUCzX/ZVoBjJRMEDR
dq0AnR8Yak9ev8ELX3a+JQBJgyiADE0i
=Z7QR
-----END PGP SIGNATURE-----

--=-ME1Af5xhCfypVEcN9yjB--

