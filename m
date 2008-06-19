Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYFSJ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYFSJ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYFSJ2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:28:45 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:39296 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYFSJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:28:44 -0400
Date: Thu, 19 Jun 2008 11:28:42 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH 3/3] configfs: Fix failing symlink() making
	rmdir() fail
Message-ID: <20080619092842.GK30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com> <1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com> <20080617221528.GA29091@mail.oracle.com> <20080618114043.GB30804@localhost> <20080618201107.GF16780@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-23497-1213867632-0001-2"
Content-Disposition: inline
In-Reply-To: <20080618201107.GF16780@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-23497-1213867632-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2008 at 01:11:07PM -0700, Joel Becker wrote:
> On Wed, Jun 18, 2008 at 01:40:43PM +0200, Louis Rilling wrote:
> > The problem is rmdir() of the target item (see below). ATTACHING only p=
rotects
> > us from rmdir() of the parent. This is the exact reason why I attach th=
e link to
> > the target in last place, where we know that we won't have to rollback.
>=20
> 	Why wouldn't it protect the target, given that detach_prep()
> will be called against the target if it's being rmdir'd?

Because
1/ setting and clearing ATTACHING could badly interact with mkdir()/symlink=
()
inside the target item (for instance clear the flag before mkdir() has fini=
shed
attaching a new item); to avoid this we could use a different flag, but
2/ rmdir() of the target cannot lock the inode of the new symlink's parent =
like
it does for mkdir(), otherwise we would risk a deadlock with other symlink(=
) and
sys_rename(). This means that rmdir() should retry aggressively, in a busy
waiting loop, or replacing mutex_lock()/mutex_unlock() with yield().

>=20
> > 	And AFAICS, creating a VFS object can not hurt as long as we hold the
> > parent i_mutex, right? Otherwise there already is a problem in
> > configfs_attach_item() where a failure in populate_attrs() leads to rol=
lback the
> > creation of the VFS object already created for the item.
>=20
> 	We *can* do that, but we try to isolate it - hand-building VFS
> objects is complex and error prone, and I try to isolate that to
> specific cases.  I'd rather avoid it when not necessary.

In the case of symlink(), building a new inode is what all filesystems must=
 do.
The only "bad" side-effect I can figure out of having to rollback is that t=
he
new entry will be visible for a short time until it is removed.

Anyway, do you think that the "solutions" above are more acceptable?

>=20
> > > 		spin_lock(&configfs_dirent_lock);
> > > 		parent_sd->s_type &=3D ~CONFIGFS_USET_ATTACHING;
> > > 		if (ret) {
> >=20
> > Here, if detach_prep() of the target failed because of the link attache=
d above,
> > it had no means to retry. rmdir() of the target fails because of this
> > temporary link, which results in a failing symlink() making rmdir() of =
the
> > target fail.
>=20
> 	How so?  It sees ATTACHING, it gets -EAGAIN, it tries again,
> just like before.  What's different?

See above the reasons for not using ATTACHING on the target.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-23497-1213867632-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIWibKVKcRuvQ9Q1QRAvYKAJ0Td13sLHxqTC15Z053MUdj/dO4PwCcCOrx
Xctu7LQhb2IkwUOiKqyQjfY=
=0x6/
-----END PGP SIGNATURE-----

--=_bohort-23497-1213867632-0001-2--
