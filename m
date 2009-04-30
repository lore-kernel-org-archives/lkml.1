Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbZD3JSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbZD3JSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZD3JSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:18:32 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:51622 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZD3JSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:18:31 -0400
Date: Thu, 30 Apr 2009 11:18:28 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 2/2] configfs: Rework configfs_depend_item() locking
	and make lockdep happy
Message-ID: <20090430091828.GB13896@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com> <1233166713-9668-3-git-send-email-louis.rilling@kerlabs.com> <20090429185231.GE4743@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-2007-1241083095-0001-2"
Content-Disposition: inline
In-Reply-To: <20090429185231.GE4743@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-2007-1241083095-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29/04/09 11:52 -0700, Joel Becker wrote:
> On Wed, Jan 28, 2009 at 07:18:33PM +0100, Louis Rilling wrote:
> > configfs_depend_item() recursively locks all inodes mutex from configfs=
 root to
> > the target item, which makes lockdep unhappy. The purpose of this recur=
sive
> > locking is to ensure that the item tree can be safely parsed and that t=
he target
> > item, if found, is not about to leave.
> >=20
> > This patch reworks configfs_depend_item() locking using configfs_dirent=
_lock.
> > Since configfs_dirent_lock protects all changes to the configfs_dirent =
tree, and
> > protects tagging of items to be removed, this lock can be used instead =
of the
> > inodes mutex lock chain.
> > This needs that the check for dependents be done atomically with
> > CONFIGFS_USET_DROPPING tagging.
>=20
> 	These patches are now in the 'lockdep' branch of the configfs
> tree.  I'm planning to send them in the next merge window.  I've made
> one change.
>=20
> > + * Note: items in the middle of attachment start with s_type =3D 0
> > + * (configfs_new_dirent()), and configfs_make_dirent() (called from
> > + * create_dir()) sets s_type =3D CONFIGFS_DIR|CONFIGFS_USET_CREATING. =
In both
> > + * cases the item is ignored. Since s_type is an int, we rely on the C=
PU to
> > + * atomically update the value, without making configfs_make_dirent() =
take
> > + * configfs_dirent_lock.
>=20
> 	I've added configfs_dirent_lock in configfs_make_dirent(),
> because it is not safe at all to rely on the fact that s_type is an int.
> It's an atomic set on one CPU, but there's no guarantee that it's seen
> correctly on other CPUs.  Plus, there's no real need for speed here.  So
> we properly take configfs_dirent_lock around s_type in
> configfs_make_dirent(), and that ensures we see things correctly on SMP.

Agreed, I was going to suggest something like this. Actually I'd push the
initialization of s_type down to configfs_new_dirent(), so that s_type eith=
er
is always NULL, or always shows the correct type of object.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-2007-1241083095-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ+WzkVKcRuvQ9Q1QRAmAQAJ44tboX+Py2+ubfeJtRhoSSYj8r2ACdEeCi
3SSJY2WUHkzwFELyH+ytmrA=
=OU2t
-----END PGP SIGNATURE-----

--=_bohort-2007-1241083095-0001-2--
