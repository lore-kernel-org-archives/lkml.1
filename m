Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXKNN1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXKNN1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXKNN1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:27:44 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:58280 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540AbXKNN1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:27:43 -0500
Subject: Re: Divide-by-zero in the 2.6.23 scheduler code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <473A4C0F.6070504@redhat.com>
References: <473A4C0F.6070504@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t0+ia4lZifnYQKGqMCMf"
Date: Wed, 14 Nov 2007 14:27:36 +0100
Message-Id: <1195046856.6924.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t0+ia4lZifnYQKGqMCMf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-13 at 20:14 -0500, Chuck Ebbert wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D340161

While I see the user has a divide by zero, I'm not understanding it.

> The problem code has been removed in 2.6.24. The below patch disables
> SCHED_FEAT_PRECISE_CPU_LOAD which causes the offending code to be skipped
> but does not prevent the user from enabling it.
>=20
> The divide-by-zero is here in kernel/sched.c:
>=20
> static void update_cpu_load(struct rq *this_rq)
> {
> 	u64 fair_delta64, exec_delta64, idle_delta64, sample_interval64, tmp64;
> 	unsigned long total_load =3D this_rq->ls.load.weight;
> 	unsigned long this_load =3D  total_load;
> 	struct load_stat *ls =3D &this_rq->ls;
> 	int i, scale;
>=20
> 	this_rq->nr_load_updates++;
> 	if (unlikely(!(sysctl_sched_features & SCHED_FEAT_PRECISE_CPU_LOAD)))
> 		goto do_avg;
>=20
> 	/* Update delta_fair/delta_exec fields first */
> 	update_curr_load(this_rq);
>=20
> 	fair_delta64 =3D ls->delta_fair + 1;

Shouldn't that +1 avoid fair_delta64 from being 0?

> 	ls->delta_fair =3D 0;
>=20
> 	exec_delta64 =3D ls->delta_exec + 1;
> 	ls->delta_exec =3D 0;
>=20
> 	sample_interval64 =3D this_rq->clock - ls->load_update_last;
> 	ls->load_update_last =3D this_rq->clock;
>=20
> 	if ((s64)sample_interval64 < (s64)TICK_NSEC)
> 		sample_interval64 =3D TICK_NSEC;

This avoids sample_interval64 from being 0.

> 	if (exec_delta64 > sample_interval64)
> 		exec_delta64 =3D sample_interval64;
>=20
> 	idle_delta64 =3D sample_interval64 - exec_delta64;
>=20
> =3D=3D=3D=3D=3D=3D>	tmp64 =3D div64_64(SCHED_LOAD_SCALE * exec_delta64, f=
air_delta64);
> 	tmp64 =3D div64_64(tmp64 * exec_delta64, sample_interval64);
>=20
> 	this_load =3D (unsigned long)tmp64;
>=20
> do_avg:
>=20
> 	/* Update our load: */
> 	for (i =3D 0, scale =3D 1; i < CPU_LOAD_IDX_MAX; i++, scale +=3D scale) =
{
> 		unsigned long old_load, new_load;
>=20
> 		/* scale is effectively 1 << i now, and >> i divides by scale */
>=20
> 		old_load =3D this_rq->cpu_load[i];
> 		new_load =3D this_load;
>=20
> 		this_rq->cpu_load[i] =3D (old_load*(scale-1) + new_load) >> i;
> 	}
> }
>=20

As for the patch, better to just rip out the entire feature..

--=-t0+ia4lZifnYQKGqMCMf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHOvfIXA2jU0ANEf4RAsb+AJ0RK77WeP5678vrXrrj6wj0xec7dQCdGtCX
DFNFrlQ5uTXpepNd18OTXAU=
=bd0Z
-----END PGP SIGNATURE-----

--=-t0+ia4lZifnYQKGqMCMf--

