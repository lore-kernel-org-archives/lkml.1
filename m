Return-Path: <linux-kernel-owner+w=401wt.eu-S1760982AbZJPPlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982AbZJPPlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760643AbZJPPlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:41:42 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49657 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755147AbZJPPll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:41:41 -0400
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: fork and terminate task logic
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4I497+v4KXKC9zOhJhpO"
Date: Fri, 16 Oct 2009 17:41:01 +0200
Message-Id: <1255707661.6228.455.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4I497+v4KXKC9zOhJhpO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commits adds the code that make it possible for a SCHED_DEADLINE task
to fork a child and to correctly terminate.

The child of a SCHED_DEADLINE task is (if !reset_on_fork) SCHED_DEADLINE as
well, but it has no bandwidth and it thus can't even start running.
To make it run, some other task (e.g., the parent) should provide it with
valid SCHED_DEADLINE parameters.

Actually, this is one of the simplest alternatives we have here, but it mig=
ht
not be the best one. Therefore, discussion on what the ``most natural''
behaviour is is still open and comments are welcome.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 kernel/sched.c          |   18 +++++++++++++++++-
 kernel/sched_deadline.c |   20 ++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index adf1414..243066e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2561,8 +2561,20 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 	 * Make sure we do not leak PI boosting priority to the child.
 	 */
 	p->prio =3D current->normal_prio;
+	if (deadline_task(p)) {
+		p->sched_class =3D &deadline_sched_class;
=20
-	if (!rt_prio(p->prio))
+		/*
+		 * the child will be SCHED_DEADLINE, but with zero bandwidth.
+		 * The parent (or some other task) must call setscheduler_ex
+		 * on it, or it won't ever start.
+		 */
+		init_deadline_task(p);
+		p->dl.flags &=3D ~DL_NEW;
+		p->dl.flags |=3D DL_THROTTLED;
+	} else if (rt_prio(p->prio))
+		p->sched_class =3D &rt_sched_class;
+	else
 		p->sched_class =3D &fair_sched_class;
=20
 #ifdef CONFIG_SMP
@@ -2744,6 +2756,10 @@ static void finish_task_switch(struct rq *rq, struct=
 task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state =3D=3D TASK_DEAD)) {
+		/* a deadline task is dying: stop the bandwidth timer */
+		if (deadline_task(prev))
+			hrtimer_cancel(&prev->dl.dl_timer);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
diff --git a/kernel/sched_deadline.c b/kernel/sched_deadline.c
index 5430c48..b4be178 100644
--- a/kernel/sched_deadline.c
+++ b/kernel/sched_deadline.c
@@ -213,6 +213,26 @@ unlock:
 	return HRTIMER_NORESTART;
 }
=20
+static void init_deadline_timer(struct hrtimer *timer)
+{
+	if (hrtimer_active(timer)) {
+		hrtimer_try_to_cancel(timer);
+		return;
+	}
+
+	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	timer->function =3D deadline_timer;
+}
+
+static void init_deadline_task(struct task_struct *p)
+{
+	RB_CLEAR_NODE(&p->dl.rb_node);
+	init_deadline_timer(&p->dl.dl_timer);
+	p->dl.sched_runtime =3D p->dl.runtime =3D 0;
+	p->dl.sched_deadline =3D p->dl.deadline =3D 0;
+	p->dl.flags =3D p->dl.bw =3D 0;
+}
+
 static
 int deadline_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se=
)
 {
--=20
1.6.0.4

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-4I497+v4KXKC9zOhJhpO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlA0ACgkQk4XaBE3IOsRBjgCfYvRPRCUf9fmxUEl/yuZJ0sMY
czcAn2YGLetsNvjUa1YlD2QLv4It20A1
=H5Ec
-----END PGP SIGNATURE-----

--=-4I497+v4KXKC9zOhJhpO--

