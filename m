Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbZJPPnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbZJPPnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760723AbZJPPnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:43:10 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54260 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760841AbZJPPnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:43:09 -0400
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: added sched-debug support.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DfzzCUX1Z8z/5vNGhBH0"
Date: Fri, 16 Oct 2009 17:42:29 +0200
Message-Id: <1255707749.6228.458.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DfzzCUX1Z8z/5vNGhBH0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commit adds the debugging output support for the SCHED_DEADLINE runque=
ue.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 include/linux/sched.h   |    6 ++++++
 kernel/sched_deadline.c |   21 +++++++++++++++++++++
 kernel/sched_debug.c    |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20e1a6a..fac928a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -167,6 +167,8 @@ extern void proc_sched_show_task(struct task_struct *p,=
 struct seq_file *m);
 extern void proc_sched_set_task(struct task_struct *p);
 extern void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
+extern void
+print_deadline_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
 #else
 static inline void
 proc_sched_show_task(struct task_struct *p, struct seq_file *m)
@@ -179,6 +181,10 @@ static inline void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 }
+static inline void
+print_deadline_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
+{
+}
 #endif
=20
 extern unsigned long long time_sync_thresh;
diff --git a/kernel/sched_deadline.c b/kernel/sched_deadline.c
index b4be178..f2c1b6e 100644
--- a/kernel/sched_deadline.c
+++ b/kernel/sched_deadline.c
@@ -400,6 +400,16 @@ static void start_hrtick_deadline(struct rq *rq, struc=
t task_struct *p)
 }
 #endif
=20
+static struct sched_dl_entity *__pick_deadline_last_entity(struct dl_rq *d=
l_rq)
+{
+	struct rb_node *last =3D rb_last(&dl_rq->rb_root);
+
+	if (!last)
+		return NULL;
+
+	return rb_entry(last, struct sched_dl_entity, rb_node);
+}
+
 static struct sched_dl_entity *pick_next_deadline_entity(struct rq *rq,
 							 struct dl_rq *dl_rq)
 {
@@ -531,3 +541,14 @@ static const struct sched_class deadline_sched_class =
=3D {
 	.switched_to		=3D switched_to_deadline,
 };
=20
+#ifdef CONFIG_SCHED_DEBUG
+static void print_deadline_stats(struct seq_file *m, int cpu)
+{
+	struct dl_rq *dl_rq =3D &cpu_rq(cpu)->dl;
+
+	rcu_read_lock();
+	for_each_leaf_deadline_rq(dl_rq, cpu_rq(cpu))
+		print_deadline_rq(m, cpu, dl_rq);
+	rcu_read_unlock();
+}
+#endif /* CONFIG_SCHED_DEBUG */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index efb8440..809ba55 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -246,6 +246,38 @@ void print_rt_rq(struct seq_file *m, int cpu, struct r=
t_rq *rt_rq)
 #undef P
 }
=20
+void print_deadline_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
+{
+	s64 min_deadline =3D -1, max_deadline =3D -1;
+	struct rq *rq =3D &per_cpu(runqueues, cpu);
+	struct sched_dl_entity *last;
+	unsigned long flags;
+
+	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
+
+	spin_lock_irqsave(&rq->lock, flags);
+	if (dl_rq->rb_leftmost)
+		min_deadline =3D (rb_entry(dl_rq->rb_leftmost,
+					 struct sched_dl_entity,
+					 rb_node))->deadline;
+	last =3D __pick_deadline_last_entity(dl_rq);
+	if (last)
+		max_deadline =3D last->deadline;
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+#define P(x) \
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(x))
+#define PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+
+	P(dl_rq->dl_nr_running);
+	PN(min_deadline);
+	PN(max_deadline);
+
+#undef PN
+#undef P
+}
+
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq =3D cpu_rq(cpu);
@@ -301,6 +333,7 @@ static void print_cpu(struct seq_file *m, int cpu)
 #endif
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
+	print_deadline_stats(m, cpu);
=20
 	print_rq(m, rq, cpu);
 }
--=20
1.6.0.4

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-DfzzCUX1Z8z/5vNGhBH0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlGUACgkQk4XaBE3IOsQyHQCeJmrwXO8bldB5BSGIzSQ/6dZ3
sFgAmwRfobny/+3G/yNAs5fT0G7Fqog+
=iMXn
-----END PGP SIGNATURE-----

--=-DfzzCUX1Z8z/5vNGhBH0--

