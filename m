Return-Path: <linux-kernel-owner+w=401wt.eu-S933742AbXLNQBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbXLNQBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXLNQBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:01:31 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:35463 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754648AbXLNQBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:01:30 -0500
Subject: [PATCH] lib: proportion: fix underflow in prop_norm_percpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: zhejiang <zhe.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1197620803.22733.13.camel@localhost.localdomain>
References: <1197516632.18076.5.camel@localhost.localdomain>
	 <1197582871.3430.1.camel@lappy>
	 <1197620803.22733.13.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ArkZcr3Pk6ZQlIjDCRET"
Date: Fri, 14 Dec 2007 17:01:26 +0100
Message-Id: <1197648086.21927.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ArkZcr3Pk6ZQlIjDCRET
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Subject: lib: proportion: fix underflow in prop_norm_percpu()

Zhe Jiang noticed that its possible to underflow pl->events in
prop_norm_percpu() when the value returned by percpu_counter_read() is less
than the error on that read and the period delay > 1. In that case half mig=
ht
not trigger the batch increment and the value will be identical on the next
iteration, causing the same half to be subtracted again and again.

Fix this by rewriting the division as a single subtraction instead of a
subtraction loop and using percpu_counter_sum() when the value returned
by percpu_counter_read() is smaller than the error.

The latter is still needed if we want pl->events to shrink properly in the
error region.

Jiang, can I get a Reviewed-by from you? - if you agree that is :-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: zhejiang <zhe.jiang@intel.com>
---
 lib/proportions.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

Index: linux-2.6/lib/proportions.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/lib/proportions.c
+++ linux-2.6/lib/proportions.c
@@ -190,6 +190,8 @@ prop_adjust_shift(int *pl_shift, unsigne
  * PERCPU
  */
=20
+#define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
+
 int prop_local_init_percpu(struct prop_local_percpu *pl)
 {
 	spin_lock_init(&pl->lock);
@@ -230,31 +232,23 @@ void prop_norm_percpu(struct prop_global
=20
 	spin_lock_irqsave(&pl->lock, flags);
 	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
+
 	/*
 	 * For each missed period, we half the local counter.
 	 * basically:
 	 *   pl->events >> (global_period - pl->period);
-	 *
-	 * but since the distributed nature of percpu counters make division
-	 * rather hard, use a regular subtraction loop. This is safe, because
-	 * the events will only every be incremented, hence the subtraction
-	 * can never result in a negative number.
 	 */
-	while (pl->period !=3D global_period) {
-		unsigned long val =3D percpu_counter_read(&pl->events);
-		unsigned long half =3D (val + 1) >> 1;
-
-		/*
-		 * Half of zero won't be much less, break out.
-		 * This limits the loop to shift iterations, even
-		 * if we missed a million.
-		 */
-		if (!val)
-			break;
-
-		percpu_counter_add(&pl->events, -half);
-		pl->period +=3D period;
-	}
+	period =3D (global_period - pl->period) >> (pg->shift - 1);
+	if (period < BITS_PER_LONG) {
+		s64 val =3D percpu_counter_read(&pl->events);
+
+		if (val < (nr_cpu_ids * PROP_BATCH))
+			val =3D percpu_counter_sum(&pl->events);
+
+		__percpu_counter_add(&pl->events, -val + (val >> period), PROP_BATCH);
+	} else
+		percpu_counter_set(&pl->events, 0);
+
 	pl->period =3D global_period;
 	spin_unlock_irqrestore(&pl->lock, flags);
 }
@@ -267,7 +261,7 @@ void __prop_inc_percpu(struct prop_descr
 	struct prop_global *pg =3D prop_get_global(pd);
=20
 	prop_norm_percpu(pg, pl);
-	percpu_counter_add(&pl->events, 1);
+	__percpu_counter_add(&pl->events, 1, PROP_BATCH);
 	percpu_counter_add(&pg->events, 1);
 	prop_put_global(pd, pg);
 }


--=-ArkZcr3Pk6ZQlIjDCRET
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHYqjWXA2jU0ANEf4RAuTgAJ9CZ4jx5BWZteR7Iv1s2ZVFeUwSMACgibp0
1hKpP6D+ObeHLWJJDMp6jgo=
=YzUQ
-----END PGP SIGNATURE-----

--=-ArkZcr3Pk6ZQlIjDCRET--

