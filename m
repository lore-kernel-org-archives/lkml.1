Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbXHQHTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbXHQHTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXHQHTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:19:23 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:55274 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753213AbXHQHTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:19:22 -0400
Subject: Re: [PATCH 00/23] per device dirty throttling -v9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org, pj@sgi.com
In-Reply-To: <Pine.LNX.4.64.0708161424010.18861@schroedinger.engr.sgi.com>
References: <20070816074525.065850000@chello.nl>
	 <Pine.LNX.4.64.0708161424010.18861@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NFkielK47NSqUScl3aI7"
Date: Fri, 17 Aug 2007 09:19:17 +0200
Message-Id: <1187335158.6114.119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NFkielK47NSqUScl3aI7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 14:29 -0700, Christoph Lameter wrote:
> Is there any way to make the global limits on which the dirty rate=20
> calculations are based cpuset specific?
>=20
> A process is part of a cpuset and that cpuset has only a fraction of=20
> memory of the whole system.=20
>=20
> And only a fraction of that fraction can be dirtied. We do not currently=20
> enforce such limits which can cause the amount of dirty pages in=20
> cpusets to become excessively high. I have posted several patchsets that=20
> deal with that issue. See http://lkml.org/lkml/2007/1/16/5
>=20
> It seems that limiting dirty pages in cpusets may be much easier to=20
> realize in the context of this patchset. The tracking of the dirty pages=20
> per node is not necessary if one would calculate the maximum amount of=20
> dirtyable pages in a cpuset and use that as a base, right?


Currently we do:=20
  dirty =3D total_dirty * bdi_completions_p * task_dirty_p

As dgc pointed out before, there is the issue of bdi/task correlation,
that is, we do not track task dirty rates per bdi, so now a task that
heavily dirties on one bdi will also get penalised on the others (and
similar issues).

If we were to change it so:
  dirty =3D cpuset_dirty * bdi_completions_p * task_dirty_p

We get additional correlation issues: cpuset/bdi, cpuset/task.
Which could yield surprising results if some bdis are strictly per
cpuset.

The cpuset/task correlation has a strict mapping and could be solved by
keeping the vm_dirties counter per cpuset. However, this would seriously
complicate the code and I'm not sure if it would gain us much.

Anyway, things to ponder. But overall it should be quite doable.


--=-NFkielK47NSqUScl3aI7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGxUv1XA2jU0ANEf4RAhauAJ9CaAFbM558IzUrIRsxkDo0ItzpWwCfZQDZ
Ce5wnissKbfHNdG1rGTkbuI=
=nvts
-----END PGP SIGNATURE-----

--=-NFkielK47NSqUScl3aI7--

