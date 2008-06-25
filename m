Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYFYJzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYFYJzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYFYJza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:55:30 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:51971 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYFYJz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:55:29 -0400
Date: Wed, 25 Jun 2008 11:55:27 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: configfs: Q: item leak in a failing configfs_attach_group()?
Message-ID: <20080625095527.GB32036@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080624141649.GH7621@hawkmoon.kerlabs.com> <20080624171051.GD4184@ca-server1.us.oracle.com> <20080624180456.GA32036@hawkmoon.kerlabs.com> <20080624213439.GB2785@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-4782-1214387634-0001-2"
Content-Disposition: inline
In-Reply-To: <20080624213439.GB2785@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-4782-1214387634-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2008 at 02:34:39PM -0700, Joel Becker wrote:
> On Tue, Jun 24, 2008 at 08:04:56PM +0200, Louis Rilling wrote:
> > On Tue, Jun 24, 2008 at 10:10:51AM -0700, Joel Becker wrote:
> > > On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> > > > Hi,
> > > >=20
> > > > I'd like an opinion on the following scenario:
> > > >=20
> > > > process 1: 					process 2:
> > > > configfs_mkdir("A")
> > > >   attach_group("A")
> > > >     attach_item("A")
> > > >       d_instantiate("A")
> > > >     populate_groups("A")
> > > >       mutex_lock("A")
> > > >       attach_group("A/B")
> > > >         attach_item("A")
> > > >           d_instantiate("A/B")
> > > > 						mkdir("A/B/C")
> > > > 						  do_path_lookup("A/B/C", LOOKUP_PARENT)
> > >=20
> > > 					This has to sleep until
> > > 					configfs_mkdir("A") finishes.
> > > 					It's waiting on A->d_parent's
> > > 					i_mutex, which is held by
> > > 					sys_mkdirat().
> >=20
> > Can you be more precise? I don't see where do_path_lookup() locks an in=
ode
>=20
> 	It doesn't.  It's in lookup_create(), which takes the mutex on the
> parent of 'A'.  Note that the end of sys_mkdirat() explicitly drops that
> mutex - it couldn't do so if it hadn't been taken :-)

So, my scenario is realistic. Process 2 only locks "B"'s inode in
lookup_create() ("B" is the parent of the new directory "C"), and never has=
 to
lock "A" or "A"'s parent. IOW, process 2 does not have to wait on any i_mut=
ex
locked by process 1.

Back to the two solutions that I've suggested (copy-pasted below), which one
would you prefer?

If I'm right, two kinds of solutions for issue 1 (new item created while
attaching a default group hierarchy):
i/ tag new directories with CONFIGFS_USET_NEW before calling d_instantiate,=
 and
validate the whole group+default groups hierarchy in a second pass by clear=
ing
CONFIGFS_USET_NEW

ii/ do not call d_instantiate() immediately in configfs_create() if called =
=66rom
configfs_create_dir(), and d_instantitate() the group+default groups hierar=
chy
in a second pass. Problem: is it correct to add children to a dentry which =
is
not yet instantiated?

For issue 2/ (detach_item() called without locking the detached item's inod=
e),
locking the inode before calling detach_item() (as is done from
configfs_rmdir()), plus a solution for 1/ should be sufficient.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-4782-1214387634-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIYhYPVKcRuvQ9Q1QRAnjlAKCqbpMGotnLwNypj8xr3c+35ZqZuQCglz07
4Y8MW2hzsElT3AGIJ4i0USM=
=qVyp
-----END PGP SIGNATURE-----

--=_bohort-4782-1214387634-0001-2--
