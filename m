Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYGDLMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYGDLMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYGDLMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:12:32 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:49006 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYGDLMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:12:31 -0400
Date: Fri, 4 Jul 2008 13:12:29 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [BUGFIX][PATCH 1/2] configfs: Prevent userspace
	from creating new entries under attaching directories
Message-ID: <20080704111229.GG30545@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com> <1214503549-15678-2-git-send-email-louis.rilling@kerlabs.com> <20080703215856.GG1502@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-5271-1215169849-0001-2"
Content-Disposition: inline
In-Reply-To: <20080703215856.GG1502@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-5271-1215169849-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2008 at 02:58:56PM -0700, Joel Becker wrote:
> On Thu, Jun 26, 2008 at 08:05:48PM +0200, Louis Rilling wrote:
> > This commit fixes 1/, tagging new directories with CONFIGFS_USET_CREATI=
NG before
> > building the inode and instantiating the dentry, and validating the who=
le
> > group+default groups hierarchy in a second pass by clearing
> > CONFIGFS_USET_CREATING.
>=20
> 	Man, I'm wary of all these in-flight flags.  I hope they are all
> orthogonal :-)

Yes they are :)

>=20
> > 	mkdir(), symlink(), lookup(), and dir_open() simply return -ENOENT if
> > called in (or linking to) a directory tagged with CONFIGFS_USET_CREATIN=
G. This
>=20
> 	Why not block until the create is done?

Hm, I think that we can't without risking deadlocks.

- mkdir(): we can only hit CONFIGFS_USET_CREATING when called inside a defa=
ult
  group A/.../B of a new group A being attached. We hold B's i_mutex from
  sys_mkdirat(). We must not block because this could deadlock with
  detach_groups() in case the new group A fails to attach all its default
  groups.
- symlink(): same issue as mkdir(), plus the fact that it is not possible to
  block on the target of symlink(), because of potential deadlocks with
  lock_rename().
- lookup(): same issue as mkdir().
- dir_open(): same issue as mkdir().

>=20
> > +	/*
> > +	 * Fake invisibility if dir belongs to a group/default groups hierarc=
hy
> > +	 * being attached
> > +	 *
> > +	 * This forbids userspace to read/write attributes of items which may
> > +	 * not complete their initialization, since the dentries of the
> > +	 * attributes won't be instantiated.
> > +	 */
> int configfs_dirent_is_ready(struct configfs_dirent *sd)
> {
> 	int err =3D 0;
> > +	spin_lock(&configfs_dirent_lock);
> > +	if (parent_sd->s_type & CONFIGFS_USET_CREATING)
> > +		err =3D -ENOENT;
> > +	spin_unlock(&configfs_dirent_lock);
> 	return err;
> }
>=20
> 	Then use is_ready() in the five places you check it ;-)  Perhaps
> change configfs_validate_dir() to configfs_dir_set_ready().  I do like
> the way validate_dir() is coded.

Ok. I'll resend the patchset with this change.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-5271-1215169849-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIbgWdVKcRuvQ9Q1QRAo41AKCgxm0VytUj6+k+UG8XM+H6R1tjQgCfepKN
crcG2mCzQxgHTt/ZzAhd2gs=
=aLZy
-----END PGP SIGNATURE-----

--=_bohort-5271-1215169849-0001-2--
