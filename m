Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbXLKKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbXLKKLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 05:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXLKKLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 05:11:09 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:64660 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751242AbXLKKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:11:08 -0500
Subject: Re: Reducing the bdi proporion calculation period to speed up disk
	write
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: zhejiang <zhe.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1197354339.668.62.camel@localhost.localdomain>
References: <1197354339.668.62.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AmJ/FqUdFMXmN3g47fDI"
Date: Tue, 11 Dec 2007 11:11:01 +0100
Message-Id: <1197367861.6985.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AmJ/FqUdFMXmN3g47fDI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-11 at 14:25 +0800, zhejiang wrote:
> The patch 04fbfdc14e5f48463820d6b9807daa5e9c92c51f implemented bdi per
> device dirty threshold. It works well.
> However, the period for proportion calculation may be too large.
> For 8G memory, the calc_period_shift() will return 19 as the shift.
>=20
> When we switch writing operation between different disks, there may be
> potential performance issue.
>=20
> For example, we first write to disk A, then write to disk B.
> The proportion for disk B will increase slowly because the denominator
> is too large (It's 2^18 + (global_count & counter_mask)).
> The disk B will get small dirty page quota for a long time,
> it will get blocked frequently though the total dirty page is under the
> dirty page limit.
>=20
> Peter provided a patch to avoid this issue, this patch allow violation
> of bdi limits if there is a lot of room on the system.
> It looks like:
>=20
> +if (nr_reclaimable + nr_writeback < (background_thresh +
> dirty_thresh) / 2)
> +                     break;=20
>=20
> This patch really help to avoid congestion, but if the dirty pages
> exceed about 3/4 of the dirty_thresh, congestion still happens if we
> write to another disk.=20
>=20
> I think that we can reduce the period to speed up the proportion
> adjustment.=20
>=20
> diff -Nur a/page-writeback.c b/page-writeback.c
> --- a/page-writeback.c  2007-12-11 13:46:30.000000000 +0800
> +++ b/page-writeback.c  2007-12-11 13:47:11.000000000 +0800
> @@ -128,10 +128,7 @@
>   */
>  static int calc_period_shift(void)
>  {
> -       unsigned long dirty_total;
> -
> -       dirty_total =3D (vm_dirty_ratio * determine_dirtyable_memory()) /
> 100;
> -       return 2 + ilog2(dirty_total - 1);
> +       return 12;
>  }

Its a heuristic, it might need some tuning, but a static value is wrong.
I think its generally true that the larger the machine memory size, the
faster the storage subsystem. And the more likely it has more disks.

One of the reasons this value isn't static is that with your fixed 12 it
becomes very hard to balance over more than 4096 active devices. Of
course, it takes quite a special set-up to get into that situation.

As it is, it now takes about 2 * dirty limit to switch over, you could
start by making that just a single, or maybe even half a, dirty limit.


Also, I'm not quite convinced your benchmark is all that useful. Do you
really think it matches an actual frequently occurring usage pattern?


--=-AmJ/FqUdFMXmN3g47fDI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXmI1XA2jU0ANEf4RAtREAJ9nOLJ1eUTk2L44JncJ7XFQZClYgQCfezIb
sUljKiXABiZjK1GjqL3dHLM=
=Yjcj
-----END PGP SIGNATURE-----

--=-AmJ/FqUdFMXmN3g47fDI--

