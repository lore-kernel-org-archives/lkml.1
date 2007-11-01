Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbXKAP37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbXKAP37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXKAP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:29:49 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:57127 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761376AbXKAP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:29:48 -0400
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <20071101150049.GB4044@elte.hu>
References: <20071026112307.GA30406@elte.hu>
	 <1193624538.3019.189.camel@ymzhang> <1193650626.3019.198.camel@ymzhang>
	 <1193710325.3019.203.camel@ymzhang> <20071030072658.GB20372@elte.hu>
	 <1193733390.3019.210.camel@ymzhang> <1193824668.3019.236.camel@ymzhang>
	 <1193826639.27652.113.camel@twins> <20071101085824.GA12721@elte.hu>
	 <1193922687.27652.279.camel@twins>  <20071101150049.GB4044@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hlg6cIr8YdefXKCZwXjc"
Date: Thu, 01 Nov 2007 16:29:43 +0100
Message-Id: <1193930983.27652.300.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hlg6cIr8YdefXKCZwXjc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

(restoring CCs which I inadvertly dropped)

On Thu, 2007-11-01 at 16:00 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>=20
> > > could we instead justmake sched_nr_latency non-tunable, and=20
> > > recalculate it from the sysctl handler whenever sched_latency or=20
> > > sched_min_granularity changes? That would avoid not only the=20
> > > division by zero bug but also other out-of-spec tunings.
> >=20
> > We don't have min_granularity anymore.
>=20
> i think we should reintroduce it in the SCHED_DEBUG case and make it the=20
> main tunable item - sched_nr is a nice performance optimization but=20
> quite unintuitive as a tuning knob.

ok, I don't particularly care either way, could be because I wrote the
stuff :-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/include/linux/sched.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1466,12 +1466,16 @@ extern void sched_idle_next(void);
=20
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_latency;
-extern unsigned int sysctl_sched_nr_latency;
+extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
+
+int sched_nr_latency_handler(struct ctl_table *table, int write,
+		struct file *file, void __user *buffer, size_t *length,
+		loff_t *ppos);
 #endif
=20
 extern unsigned int sysctl_sched_compat_yield;
Index: linux-2.6/kernel/sched_debug.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -210,7 +210,7 @@ static int sched_debug_show(struct seq_f
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
 	PN(sysctl_sched_latency);
-	PN(sysctl_sched_nr_latency);
+	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
 	PN(sysctl_sched_batch_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
Index: linux-2.6/kernel/sched_fair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -35,16 +35,21 @@
 const_debug unsigned int sysctl_sched_latency =3D 20000000ULL;
=20
 /*
- * After fork, child runs first. (default) If set to 0 then
- * parent will (try to) run first.
+ * Minimal preemption granularity for CPU-bound tasks:
+ * (default: 1 msec, units: nanoseconds)
  */
-const_debug unsigned int sysctl_sched_child_runs_first =3D 1;
+const_debug unsigned int sysctl_sched_min_granularity =3D 1000000ULL;
=20
 /*
- * Minimal preemption granularity for CPU-bound tasks:
- * (default: 2 msec, units: nanoseconds)
+ * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
+ */
+const_debug unsigned int sched_nr_latency =3D 20;
+
+/*
+ * After fork, child runs first. (default) If set to 0 then
+ * parent will (try to) run first.
  */
-const_debug unsigned int sysctl_sched_nr_latency =3D 20;
+const_debug unsigned int sysctl_sched_child_runs_first =3D 1;
=20
 /*
  * sys_sched_yield() compat mode
@@ -301,6 +306,21 @@ static inline struct sched_entity *__pic
  * Scheduling class statistics methods:
  */
=20
+#ifdef CONFIG_SCHED_DEBUG
+int sched_nr_latency_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret =3D proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		sched_nr_latency =3D
+			sysctl_sched_latency / sysctl_sched_min_granularity;
+	}
+
+	return ret;
+}
+#endif
=20
 /*
  * The idea is to set a period in which each task runs once.
@@ -313,7 +333,7 @@ static inline struct sched_entity *__pic
 static u64 __sched_period(unsigned long nr_running)
 {
 	u64 period =3D sysctl_sched_latency;
-	unsigned long nr_latency =3D sysctl_sched_nr_latency;
+	unsigned long nr_latency =3D sched_nr_latency;
=20
 	if (unlikely(nr_running > nr_latency)) {
 		period *=3D nr_running;
Index: linux-2.6/kernel/sysctl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -235,11 +235,14 @@ static struct ctl_table kern_table[] =3D {
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.ctl_name	=3D CTL_UNNUMBERED,
-		.procname	=3D "sched_nr_latency",
-		.data		=3D &sysctl_sched_nr_latency,
+		.procname	=3D "sched_min_granularity_ns",
+		.data		=3D &sysctl_sched_min_granularity,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D &proc_dointvec,
+		.proc_handler	=3D &sched_nr_latency_handler,
+		.strategy	=3D &sysctl_intvec,
+		.extra1		=3D &min_sched_granularity_ns,
+		.extra2		=3D &max_sched_granularity_ns,
 	},
 	{
 		.ctl_name	=3D CTL_UNNUMBERED,
@@ -247,7 +250,7 @@ static struct ctl_table kern_table[] =3D {
 		.data		=3D &sysctl_sched_latency,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D &proc_dointvec_minmax,
+		.proc_handler	=3D &sched_nr_latency_handler,
 		.strategy	=3D &sysctl_intvec,
 		.extra1		=3D &min_sched_granularity_ns,
 		.extra2		=3D &max_sched_granularity_ns,


--=-hlg6cIr8YdefXKCZwXjc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKfDnXA2jU0ANEf4RArDtAJ46Ygz9cocv+o/6z8A489hoI2iXMQCfQ2FL
EvQnQhDZNjQW0zuPzr1WsTE=
=pTvZ
-----END PGP SIGNATURE-----

--=-hlg6cIr8YdefXKCZwXjc--

