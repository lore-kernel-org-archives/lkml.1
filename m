Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936583Ab0B1TWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:22:19 -0500
Received: from ms01.sssup.it ([193.205.80.99]:58384 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936491Ab0B1TWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:22:18 -0500
Subject: [RFC][PATCH 06/11] sched: add the sched-debug bits for sched_dl.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5HNHV0FeCDzzUxBj/ekw"
Date: Sun, 28 Feb 2010 20:22:09 +0100
Message-ID: <1267384929.13676.95.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5HNHV0FeCDzzUxBj/ekw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add the typical debugging output provided by sched_deug (if enabled)
also to the sched_dl class.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 kernel/sched_debug.c |   33 +++++++++++++++++++++++++++++++++
 kernel/sched_dl.c    |   26 ++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 67f95aa..407a761 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -246,6 +246,38 @@ void print_rt_rq(struct seq_file *m, int cpu, struct r=
t_rq *rt_rq)
 #undef P
 }
=20
+void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
+{
+	s64 min_deadline =3D -1, max_deadline =3D -1;
+	struct rq *rq =3D &per_cpu(runqueues, cpu);
+	struct sched_dl_entity *last;
+	unsigned long flags;
+
+	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	if (dl_rq->rb_leftmost)
+		min_deadline =3D (rb_entry(dl_rq->rb_leftmost,
+					 struct sched_dl_entity,
+					 rb_node))->deadline;
+	last =3D __pick_dl_last_entity(dl_rq);
+	if (last)
+		max_deadline =3D last->deadline;
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
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
@@ -305,6 +337,7 @@ static void print_cpu(struct seq_file *m, int cpu)
 #endif
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
+	print_dl_stats(m, cpu);
=20
 	print_rq(m, rq, cpu);
 }
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index a1202ac..dee2668 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -44,6 +44,9 @@ static inline int dl_time_before(u64 a, u64 b)
 	return (s64)(a - b) < 0;
 }
=20
+#define for_each_leaf_dl_rq(dl_rq, rq) \
+	for (dl_rq =3D &rq->dl; dl_rq; dl_rq =3D NULL)
+
 static void enqueue_dl_entity(struct sched_dl_entity *dl_se);
 static void dequeue_dl_entity(struct sched_dl_entity *dl_se);
 static void check_dl_preempt_curr(struct task_struct *p, struct rq *rq);
@@ -512,6 +515,16 @@ static void start_hrtick_dl(struct rq *rq, struct task=
_struct *p)
 }
 #endif
=20
+static struct sched_dl_entity *__pick_dl_last_entity(struct dl_rq *dl_rq)
+{
+	struct rb_node *last =3D rb_last(&dl_rq->rb_root);
+
+	if (!last)
+		return NULL;
+
+	return rb_entry(last, struct sched_dl_entity, rb_node);
+}
+
 static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 						   struct dl_rq *dl_rq)
 {
@@ -676,3 +689,16 @@ static const struct sched_class dl_sched_class =3D {
 	.switched_to		=3D switched_to_dl,
 };
=20
+#ifdef CONFIG_SCHED_DEBUG
+extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
+
+static void print_dl_stats(struct seq_file *m, int cpu)
+{
+	struct dl_rq *dl_rq =3D &cpu_rq(cpu)->dl;
+
+	rcu_read_lock();
+	for_each_leaf_dl_rq(dl_rq, cpu_rq(cpu))
+		print_dl_rq(m, cpu, dl_rq);
+	rcu_read_unlock();
+}
+#endif /* CONFIG_SCHED_DEBUG */
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-5HNHV0FeCDzzUxBj/ekw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKwmAACgkQk4XaBE3IOsR/kgCfQvOYmznf4hlgipuCLxjKx1/E
RRIAn0bfNiLnXTmFuszJPGk4QM1LUoVH
=0yho
-----END PGP SIGNATURE-----

--=-5HNHV0FeCDzzUxBj/ekw--

