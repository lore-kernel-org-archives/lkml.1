Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXJVLst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXJVLst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXJVLsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:48:41 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14500 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbXJVLsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:48:40 -0400
Subject: [RFC/PATCH 4/3] rt: PI-workqueue: fixup the barrier prio
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20071022095659.005996000@chello.nl>
References: <20071022095054.393085000@chello.nl>
	 <20071022095659.005996000@chello.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1QmJTX84l+naO5dyrDYV"
Date: Mon, 22 Oct 2007 13:48:33 +0200
Message-Id: <1193053713.27435.172.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1QmJTX84l+naO5dyrDYV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

small fix to the PI stuff,
we lost the prio of the barrier waiter.
---

Index: linux-2.6/kernel/workqueue.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -264,6 +264,7 @@ struct wq_full_barrier {
 	struct plist_head		worklist;
 	struct wq_full_barrier 		*prev_barrier;
 	int				prev_prio;
+	int				waiter_prio;
 	struct cpu_workqueue_struct 	*cwq;
 	struct completion		done;
 };
@@ -291,6 +292,7 @@ again:
 		prio =3D work->entry.prio;
 		if (unlikely(worklist !=3D &cwq->worklist)) {
 			prio =3D min(prio, cwq->barrier->prev_prio);
+			prio =3D min(prio, cwq->barrier->waiter_prio);
 			prio =3D min(prio, plist_first(&cwq->worklist)->prio);
 		}
=20
@@ -393,14 +395,15 @@ static void wq_full_barrier_func(struct=20
 	struct wq_full_barrier *barrier =3D
 		container_of(work, struct wq_full_barrier, work);
 	struct cpu_workqueue_struct *cwq =3D barrier->cwq;
+	int prio =3D MAX_PRIO;
=20
 	spin_lock_irq(&cwq->lock);
 	barrier->prev_barrier =3D cwq->barrier;
 	if (cwq->barrier) {
-		barrier->prev_prio =3D min(cwq->barrier->prev_prio,
-				plist_first(&cwq->barrier->worklist)->prio);
-	} else
-		barrier->prev_prio =3D MAX_PRIO;
+		prio =3D min(prio, cwq->barrier->waiter_prio);
+		prio =3D min(prio, plist_first(&cwq->barrier->worklist)->prio);
+	}
+	barrier->prev_prio =3D prio;
 	cwq->barrier =3D barrier;
 	spin_unlock_irq(&cwq->lock);
 }
@@ -415,6 +418,7 @@ static void insert_wq_full_barrier(struc
 	plist_head_splice(&cwq->worklist, &barr->worklist);
 	barr->cwq =3D cwq;
 	init_completion(&barr->done);
+	barr->waiter_prio =3D current->normal_prio;
=20
 	insert_work(cwq, &barr->work, 0, current->normal_prio, 1);
 }


--=-1QmJTX84l+naO5dyrDYV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHHI4RXA2jU0ANEf4RAipHAJ9DW3gKwdWXIwPw1phzl6H/9YXN2wCdFuaL
4GexuR4HfxGl3JxlGC7x1f4=
=GZTk
-----END PGP SIGNATURE-----

--=-1QmJTX84l+naO5dyrDYV--

