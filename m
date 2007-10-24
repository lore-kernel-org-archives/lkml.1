Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbXJXQL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbXJXQL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXJXQLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:11:20 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:39233 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXJXQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:11:20 -0400
Subject: Re: 2.6.24-rc1 fails with lockup and BUG:
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Romano Giannetti <romanol@upcomillas.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071024155521.GA16690@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	 <1193232344.32208.0.camel@localhost> <20071024142759.GA13657@elte.hu>
	 <1193241191.14314.8.camel@localhost>  <20071024155521.GA16690@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D6W2ZNuSxTtBaDsutZSs"
Date: Wed, 24 Oct 2007 18:11:07 +0200
Message-Id: <1193242267.6914.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D6W2ZNuSxTtBaDsutZSs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 17:55 +0200, Ingo Molnar wrote:
> * Romano Giannetti <romanol@upcomillas.es> wrote:
>=20
> > Done. The results are at:
> >=20
> > http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_2/
> >=20
> > in the syslog-after-failed-suspend.txt file. After the failed suspend=20
> > (at line 15766) there where the bunch of things in D-state. I have=20
> > left the file intact.
> >=20
> > At line 17646 there is:
> >=20
> > WARNING: at kernel/lockdep.c:2033 trace_hardirqs_on()
>=20
> hm, this lockdep warning caused lockdep to turn itself off - hence we=20
> wont get to the really interesting warnings. We'll try to come up with a=20
> solution for this.

Does this help?

---
Subject: lockdep: invalid irq usage

this function can be called from hardirq context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux-2.6-2/kernel/sched_debug.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -80,6 +80,7 @@ print_task(struct seq_file *m, struct rq
 static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 {
 	struct task_struct *g, *p;
+	unsigned long flags;
=20
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
@@ -88,7 +89,7 @@ static void print_rq(struct seq_file *m,
 	"------------------------------------------------------"
 	"----------------------------------------------------\n");
=20
-	read_lock_irq(&tasklist_lock);
+	read_lock_irqsave(&tasklist_lock, flags);
=20
 	do_each_thread(g, p) {
 		if (!p->se.on_rq || task_cpu(p) !=3D rq_cpu)
@@ -97,7 +98,7 @@ static void print_rq(struct seq_file *m,
 		print_task(m, rq, p);
 	} while_each_thread(g, p);
=20
-	read_unlock_irq(&tasklist_lock);
+	read_unlock_irqrestore(&tasklist_lock, flags);
 }
=20
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)


--=-D6W2ZNuSxTtBaDsutZSs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHH26bXA2jU0ANEf4RAquPAJ9IRF0fF8Eyp1URxmOLabvIOukbGACfRxS0
1ER1AZXdEDf4N8r10Xa5z38=
=+RUp
-----END PGP SIGNATURE-----

--=-D6W2ZNuSxTtBaDsutZSs--

