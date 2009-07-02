Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZGBJE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZGBJE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZGBJEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:04:49 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:52885 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZGBJEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:04:49 -0400
Date: Thu, 2 Jul 2009 11:04:48 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] [RFC] Remove cgroup_subsys.root pointer
Message-ID: <20090702090447.GD4305@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com> <20090702021118.14469.2107.stgit@menage.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-21710-1246525464-0001-2"
Content-Disposition: inline
In-Reply-To: <20090702021118.14469.2107.stgit@menage.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-21710-1246525464-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 01, 2009 at 07:11:18PM -0700, Paul Menage wrote:
> [RFC] Remove cgroup_subsys.root pointer
>=20
> In preparation for supporting cgroup subsystems that can be bound to
> multiple hierarchies, remove the "root" pointer and associated list
> structures.  Subsystem hierarchy membership is now determined entirely
> through the subsystem bitmasks in struct cgroupfs_root.
>=20
> Minor changes include:
>   - root_list now includes the inactive root
>   - for_each_active_root() -> for_each_root()
>   - for_each_subsys() is now guaranteed to be in subsys_id order
>=20

[...]

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index dede632..8b1b92f 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c

[...]

> @@ -191,13 +182,36 @@ static int notify_on_release(const struct cgroup *c=
grp)
>   * for_each_subsys() allows you to iterate on each subsystem attached to
>   * an active hierarchy
>   */
> +static inline struct cgroup_subsys *nth_ss(int n)
> +{
> +	return (n >=3D CGROUP_SUBSYS_COUNT) ? NULL : subsys[n];
> +}
>  #define for_each_subsys(_root, _ss) \
> -list_for_each_entry(_ss, &_root->subsys_list, sibling)
> +for (_ss =3D nth_ss(find_first_bit(&(_root)->subsys_bits, CGROUP_SUBSYS_=
COUNT));\
> +	    _ss !=3D NULL;						      \
> +    _ss =3D nth_ss(find_next_bit(&(_root)->subsys_bits, CGROUP_SUBSYS_CO=
UNT,    \
> +			       _ss->subsys_id + 1)))
> =20
> -/* for_each_active_root() allows you to iterate across the active hierar=
chies */
> -#define for_each_active_root(_root) \
> +
> +/* for_each_root() allows you to iterate across all hierarchies */
> +#define for_each_root(_root) \
>  list_for_each_entry(_root, &roots, root_list)
> =20
> +/* Find the root for a given subsystem */
> +static struct cgroupfs_root *find_root(struct cgroup_subsys *ss)
> +{
> +	int id =3D ss->subsys_id;
> +	struct cgroupfs_root *root, *res =3D NULL;
> +	for_each_root(root) {
> +		if (root->subsys_bits && (1UL << id)) {
Should be &, not && ------------------^^

Louis

> +			BUG_ON(res);
> +			res =3D root;
> +		}
> +	}
> +	BUG_ON(!res);
> +	return res;
> +}
> +
>  /* the list of cgroups eligible for automatic release. Protected by
>   * release_list_lock */
>  static LIST_HEAD(release_list);

[...]

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-21710-1246525464-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpMeC8ACgkQVKcRuvQ9Q1QALwCdERKaivSiq+ZotPM6H5ndrmxN
p0wAoKDxBWK6jwG/oLQixTBlkDF+kriZ
=D/io
-----END PGP SIGNATURE-----

--=_bohort-21710-1246525464-0001-2--
