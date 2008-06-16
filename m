Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYFPLa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYFPLa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYFPLaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:30:16 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:34417 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYFPLaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:30:14 -0400
Date: Mon, 16 Jun 2008 13:30:11 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 1/3][BUGFIX] configfs: Introduce configfs_dirent_lock
Message-ID: <20080616113011.GQ30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080612133126.335618468@kerlabs.com> <20080612134203.763166823@kerlabs.com> <20080612191348.GE5377@mail.oracle.com> <20080612222558.GA4012@localdomain> <20080613024130.GD20581@mail.oracle.com> <20080613104513.GI30804@localhost> <20080613201746.GB20576@mail.oracle.com> <20080613215401.GA4153@localdomain> <20080613223441.GE20576@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-12397-1213615724-0001-2"
Content-Disposition: inline
In-Reply-To: <20080613223441.GE20576@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-12397-1213615724-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2008 at 03:34:41PM -0700, Joel Becker wrote:
> > To me it's an issue only if we want to provide some atomic view to
> > userspace: either userspace sees a group with all of its default groups,
> > or it sees none. So the question is: does userspace need such atomicity?
> > Currently configfs provides it, so this would be a userspace visible
> > change if we break it.
>=20
> 	People *won't* see that.  default groups are populated and
> cleaned under i_mutex.  The race of mkdir vs rmdir isn't about seeing
> partial default groups, it's about the ENOMEM racing the ENOTEMPTY.  It
> doesn't impact lookup or other operations.  We can fix it.  I'm just not
> sure it's worth the complexity (and this is an open question).

It's not that difficult to implement, you may just find it a bit ugly... I =
hope
to send you a corrected "rename fix" today.

>=20
> > Sure, my only concern is the atomic view of userspace: can userspace
> > tolerate that (pwd=3DA/B, with B a default group of A, B having default=
 groups C
> > and D, and A being removed) 'ls C' returns error because default group =
C is
> > already removed and 'ls D' is ok because default group D is not removed=
 yet?
>=20
> 	They can't see that.  We take i_mutex in detach_group.  This
> locks out lookup and readdir.  When we're done with detach_group, all
> default groups are gone.

If I understand correctly, lookup() is not called each time userspace does =
ls,
and in configfs case, it is never called for existing items since the d_cac=
he is
populated as soon as the user creates items. So lookup() does not block 'ls'
during rmdir() (unless it is a lookup for a never accessed attribute). I th=
ink
that this is the point that invalidates all my theory about atomicity :)

>=20
> > > > 2/ the existence of default group trees that are tagged as USET_DRO=
PPING and
> > > >    should be treated as not existing anymore.
> > >=20
> > > 	This is not an issue.  USET_DROPPING does *not* mean it went
> > > away.  It means we're safe to make it go away.  We protect the actual
> > > going-away with i_mutex.  And that's normal VFS behavior.
> >=20
> > Again this is the concern of atomicity from userspace point of view: to
> > provide such atomic view, mkdir(), lookup(), readdir(), and probably
> > attributes open() should just fail when done in a default group flagged=
 with
> > USET_DROPPING.
>=20
> 	It's not atomic, though, and never has been.  I'm not quite sure
> what you are unsure of here.  Let me try to clarify a little.
> 	Are you worried about two separate runs of the ls(1) command?
>=20
>   # ls A/B/C
>   # ls A/B/D
>=20
> These can't be atomic, because someone else could rmdir(1) in the
> middle:
>=20
>   # ls A/B/C
>   # rmdir A/B
>   # ls A/B/D
>   ls: No such file or directory
>=20
> This is perfectly normal, and there is no way to prevent it - it is
> separate entrances to the system call.
> 	Do you mean inside one call?  That is "ls A/B" would print "C"
> but not "D"?  That cannot happen, because we hold B's i_mutex during
> detach_group.  So, if readdir beat us to i_mutex, it lists "C D".  If we
> win, we remove both before releasing B's i_Mutex, and readdir errors
> with ENOENT - we removed B.
> 	I'm not quite sure what inconsistency you are asking about here.

The scenario that made me worry was more:
process 1:
/* PWD=3DA/B */
# ls C
ls: No such file or directory
/* some sync between process 1 and 2 */
process 2:
/* PWD=3DA/D */
# ls E
/* ok */
# ls E
ls: No such file or directory

=46rom a user's point of view, this looks as if somebody did 'rmdir A; mkdi=
r A;
rmdir A', while there actually were only 'rmdir A'.

If there were no d_cache, this would be impossible with the current
implementation of detach_prep() locking all default groups. But with the d_=
cache
this has always been possible.

Anyway, I give up with this (wrong) atomicity concern.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-12397-1213615724-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIVk7DVKcRuvQ9Q1QRAvJ5AJ9mtWY2Werq+2BN3hV3rnQFMYXogQCg0t5o
NVhwTPKKcz6/y4JBQruUtcY=
=vnod
-----END PGP SIGNATURE-----

--=_bohort-12397-1213615724-0001-2--
