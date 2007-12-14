Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbXLNIsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbXLNIsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbXLNIsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:48:10 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:51490 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757072AbXLNIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:48:08 -0500
Subject: Re: [PATCH]Avoid the overflow when calculate the proportion of bdi
	quota
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: zhejiang <zhe.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
In-Reply-To: <1197620803.22733.13.camel@localhost.localdomain>
References: <1197516632.18076.5.camel@localhost.localdomain>
	 <1197582871.3430.1.camel@lappy>
	 <1197620803.22733.13.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TUBml7NkddvrbYOX0QhJ"
Date: Fri, 14 Dec 2007 09:47:50 +0100
Message-Id: <1197622070.6895.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TUBml7NkddvrbYOX0QhJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-12-14 at 16:26 +0800, zhejiang wrote:
> On Thu, 2007-12-13 at 22:54 +0100, Peter Zijlstra wrote:
> > On Thu, 2007-12-13 at 11:30 +0800, zhejiang wrote:
> > > __percpu_counter_add() cache the result in percpu variable until it
> > > exceeds the batch.
> > > The prop_norm_percpu() use the percpu_counter_read(&pl->events) to re=
ad
> > > the counter ,and use percpu_counter_add(&pl->events, -half) to half t=
he
> > > counter.
> > >=20
> > > There are potential problems:
> > > 1.The counter may be negative=20
> > > 2.After some calculation, it may be converted to a big positive numbe=
r.
> > >=20
> > > 1.
> > > For example, the batch is 32, when the bdi add 32 to the pl->events,
> > > the pl->events->count will be 32.Suppose one of the percpu counter is=
 1.
> > >=20
> > > In the prop_norm_percpu(),the half will be 16.Because it is under the
> > > batch, the pl->events->count won't be modified and one of the percpu
> > > counter may be -15. If call the prop_norm_percpu() again, the half wi=
ll
> > > still be 16,though it should be 8.The percpu counter may be -31.
> > > Now, there pl->events->count is still 32.
> > > If do the third calculation, the percpu counter will be -47, it will
> > > be merged into the pl->evnets->count.Then pl->events->count will be
> > > negative.
> > >=20
> > > 2.When the pl->events->count is negative,
> > > unsigned long val =3D percpu_counter_read(&pl->events);
> > > This statement may return a negative number, so the val would be a bi=
g
> > > number.Because of the overflow, the pl->events->count will be convert=
ed
> > > into a big positive number after some calculation.
> > >=20
> > > Because of the overflow, I catch some very big numerators when call t=
he
> > > prop_fraction_percpu().
> > >=20
> > > I think that it should use percpu_counter_sum() instead of the
> > > percpu_counter_read() to be more robust.
> > >=20
> > > diff -Nur a/proportions.c b/proportions.c
> > > --- a/proportions.c     2007-12-12 11:05:59.000000000 +0800
> > > +++ b/proportions.c     2007-12-13 11:05:40.000000000 +0800
> > > @@ -241,7 +241,7 @@
> > >          * can never result in a negative number.
> > >          */
> > >         while (pl->period !=3D global_period) {
> > > -               unsigned long val =3D percpu_counter_read(&pl->events=
);
> > > +               unsigned long val =3D percpu_counter_sum(&pl->events)=
;
> > >                 unsigned long half =3D (val + 1) >> 1;
> > > =20
> > >                 /*
> > >=20
> >=20
> > _sum is unacceptably slow here. I'm thinking something like
> > bdi_stat_error() as used in balance_dirty_pages() would also solve this
> > issue, no?
>=20
> _sum is slow, but it can avoid over-subtraction when the counter is less
> than 2 * BDI_STAT_BATCH.
>=20
> How about do the calculation like this patch?
>=20
> Change the val and half into long type, if we found the val is negative,
> it means that we did subtraction too much.
> So we actually add some value to it.
>=20
> diff -Nur a/proportions.c b/proportions.c
> --- a/proportions.c     2007-12-12 11:05:59.000000000 +0800
> +++ b/proportions.c     2007-12-14 16:21:08.000000000 +0800
> @@ -241,8 +241,18 @@
>          * can never result in a negative number.
>          */
>         while (pl->period !=3D global_period) {
> -               unsigned long val =3D percpu_counter_read(&pl->events);
> -               unsigned long half =3D (val + 1) >> 1;
> +               long val =3D percpu_counter_read(&pl->events);
> +               long half;
> +
> +               if (val >=3D 0) {
> +                       half =3D (val + 1) >> 1;
> +               } else {
> +                       /*
> +                        *If val is negative, the counter has been
> subtracted too much.
> +                        *Do some compensation here.
> +                        */
> +                       half =3D (val - 1) / 2;
> +               }
> =20
>                 /*
>                  * Half of zero won't be much less, break out.

How about something like this:

diff --git a/lib/proportions.c b/lib/proportions.c
index 332d8c5..4afb330 100644
--- a/lib/proportions.c
+++ b/lib/proportions.c
@@ -190,6 +190,8 @@ prop_adjust_shift(int *pl_shift, unsigned long *pl_peri=
od, int new_shift)
  * PERCPU
  */
=20
+#define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
+
 int prop_local_init_percpu(struct prop_local_percpu *pl)
 {
 	spin_lock_init(&pl->lock);
@@ -203,6 +205,16 @@ void prop_local_destroy_percpu(struct prop_local_percp=
u *pl)
 	percpu_counter_destroy(&pl->events);
 }
=20
+static unsigned long prop_percpu_read(struct prop_local_percpu *pl)
+{
+	unsigned long val =3D percpu_counter_read(&pl->events);
+
+	if (val < (nr_cpu_ids * PROP_BATCH))
+		val =3D percpu_counter_sum(&pl->events);
+
+	return val;
+}
+
 /*
  * Catch up with missed period expirations.
  *
@@ -241,7 +253,7 @@ void prop_norm_percpu(struct prop_global *pg, struct pr=
op_local_percpu *pl)
 	 * can never result in a negative number.
 	 */
 	while (pl->period !=3D global_period) {
-		unsigned long val =3D percpu_counter_read(&pl->events);
+		unsigned long val =3D prop_percpu_read(pl);
 		unsigned long half =3D (val + 1) >> 1;
=20
 		/*
@@ -252,7 +264,7 @@ void prop_norm_percpu(struct prop_global *pg, struct pr=
op_local_percpu *pl)
 		if (!val)
 			break;
=20
-		percpu_counter_add(&pl->events, -half);
+		__percpu_counter_add(&pl->events, -half, PROP_BATCH);
 		pl->period +=3D period;
 	}
 	pl->period =3D global_period;
@@ -267,7 +279,7 @@ void __prop_inc_percpu(struct prop_descriptor *pd, stru=
ct prop_local_percpu *pl)
 	struct prop_global *pg =3D prop_get_global(pd);
=20
 	prop_norm_percpu(pg, pl);
-	percpu_counter_add(&pl->events, 1);
+	__percpu_counter_add(&pl->events, 1, PROP_BATCH);
 	percpu_counter_add(&pg->events, 1);
 	prop_put_global(pd, pg);
 }


--=-TUBml7NkddvrbYOX0QhJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHYkM2XA2jU0ANEf4RAiH6AJ9wdmph1Rn3BkYp+uK8KlkApL1DRACgj+Og
C2hDiZb+fo0HrGz8V7drxk4=
=FG5L
-----END PGP SIGNATURE-----

--=-TUBml7NkddvrbYOX0QhJ--

