Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbYFMMJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbYFMMJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYFMMJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:09:26 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:44774 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYFMMJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:09:25 -0400
Date: Fri, 13 Jun 2008 14:09:23 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 1/3][BUGFIX] configfs: Introduce configfs_dirent_lock
Message-ID: <20080613120923.GJ30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080612133126.335618468@kerlabs.com> <20080612134203.763166823@kerlabs.com> <20080612191348.GE5377@mail.oracle.com> <20080612222558.GA4012@localdomain> <20080613024130.GD20581@mail.oracle.com> <20080613104513.GI30804@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-15080-1213358877-0001-2"
Content-Disposition: inline
In-Reply-To: <20080613104513.GI30804@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-15080-1213358877-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2008 at 12:45:13PM +0200, Louis Rilling wrote:
>=20
> Unfortunately, thinking a bit more about it I found some issues with
> i_mutex lock free detach_prep(), but nothing that can't be fixed ;)
> 	Between detach_prep() in A and mkdir() in a default group A/B:
> detach_prep() can be called in the middle of attach_group(), for instance=
 after
> having attached A/B/C, but attach_group() may then fail (because of memory
> pressure for instance) while attaching C's default group A/B/C/D. This wo=
uld
> lead to both mkdir(A/B/C) and rmdir(A) failing, the reason for rmdir fail=
ure
> being at best obscure: the user would have expected to either see mkdir s=
ucceed
> and rmdir fail because of the new A/B/C group, or see mkdir fail and rmdir
> succeed because no user-created group lived under A. Solution: tag A/B wi=
th
> USET_IN_MKDIR on mkdir entrance, remove that tag on mkdir exit, and retry
> detach_prep() as long as USET_IN_MKDIR is found under A/*.
> 	Between rmdir() and readdir(): dir_open() might add a configfs_dirent
> to a default group A/B that detach_prep() already marked with USET_DROPPI=
NG.
> This could result in detach_groups() dropping the dirent and make readdir=
() in
> A/B crash afterwards. Solution: check USET_DROPPING in dir_open() and fai=
l if
> it is set.
> 	Between rmdir() and lookup(): several lookup() called under A/* while
> rmdir(A) in the middle of detach_groups() could return inconsistent resul=
ts (for
> instance some default groups being there and some other ones not). Soluti=
on:
> lock dirent_lock for the whole lookup() duration, check USET_DROPPING of =
current
> dir, and fail with ENOENT if it is set.

Oh, should probably provide some d_revalidate() also, which would return
-ENOENT for a dentry under a directory flagged with USET_DROPPING. But I'm
realizing that such "inconsistencies" (some default groups being valid in t=
he
d_cache and some other ones not) already happen between the time detach_pre=
p()
has flagged a default group with USET_DROPPING and the default
group is actually detached. Am I wrong?

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-15080-1213358877-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIUmNzVKcRuvQ9Q1QRAkSeAKCdgOah+4X0snXXqkOSR/xM7uUaLgCfZxbS
HvBcdqO5xK6dSmyOQe5Codc=
=7o0w
-----END PGP SIGNATURE-----

--=_bohort-15080-1213358877-0001-2--
