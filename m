Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYFXSFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYFXSFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYFXSE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:04:59 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:44215 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYFXSE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:04:58 -0400
Date: Tue, 24 Jun 2008 20:04:56 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: configfs: Q: item leak in a failing configfs_attach_group()?
Message-ID: <20080624180456.GA32036@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080624141649.GH7621@hawkmoon.kerlabs.com> <20080624171051.GD4184@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-29171-1214330603-0001-2"
Content-Disposition: inline
In-Reply-To: <20080624171051.GD4184@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-29171-1214330603-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2008 at 10:10:51AM -0700, Joel Becker wrote:
> On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> > Hi,
> >=20
> > I'd like an opinion on the following scenario:
> >=20
> > process 1: 					process 2:
> > configfs_mkdir("A")
> >   attach_group("A")
> >     attach_item("A")
> >       d_instantiate("A")
> >     populate_groups("A")
> >       mutex_lock("A")
> >       attach_group("A/B")
> >         attach_item("A")
> >           d_instantiate("A/B")
> > 						mkdir("A/B/C")
> > 						  do_path_lookup("A/B/C", LOOKUP_PARENT)
>=20
> 					This has to sleep until
> 					configfs_mkdir("A") finishes.
> 					It's waiting on A->d_parent's
> 					i_mutex, which is held by
> 					sys_mkdirat().

Can you be more precise? I don't see where do_path_lookup() locks an inode
outside of real_lookup(), and what I understand is that real_lookup() is ne=
ither
called for "A", nor called for "A/B" because __d_lookup() will find positive
dentries (they were d_instantiated). Since do_path_lookup() is called with
LOOKUP_PARENT, it stops here. Then lookup_create() locks "A/B"'s inode, wit=
hout
waiting, and calls lookup_hash("A/B", "C"), which ends calling
configfs_lookup("A/B", "C") because "A/B" has no child "C" in the dcache.

What am I missing?

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-29171-1214330603-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIYTdIVKcRuvQ9Q1QRAlReAKC07GTRaRqTDb2KSZMSpWq3Hx3U8QCdGUjN
MOLKW6TfZ0JjkuG/DeMceL8=
=N7sH
-----END PGP SIGNATURE-----

--=_bohort-29171-1214330603-0001-2--
