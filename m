Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZAZOzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZAZOzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZAZOzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:55:40 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:34328 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZAZOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:55:39 -0500
Date: Mon, 26 Jan 2009 15:55:36 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20090126145536.GG7532@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Joel Becker <Joel.Becker@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho <swhiteho@redhat.com>
References: <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com> <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins> <20081218225837.GB21870@mail.oracle.com> <1232973009.4863.76.camel@laptop> <20090126132453.GD7532@hawkmoon.kerlabs.com> <1232977283.4863.79.camel@laptop> <20090126140032.GE7532@hawkmoon.kerlabs.com> <1232979562.4863.101.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-10171-1232981575-0001-2"
Content-Disposition: inline
In-Reply-To: <1232979562.4863.101.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-10171-1232981575-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26/01/09 15:19 +0100, Peter Zijlstra wrote:
> On Mon, 2009-01-26 at 15:00 +0100, Louis Rilling wrote:
>=20
> > > Its not a locking correctness thing, but simply not being able to do =
it
> > > from the vfs calls because those assume locks held?
> > >=20
> > > Can't you simply punt the work to a worklet once you've created/remov=
ed
> > > the non-default group, which can be done from within the vfs callback=
 ?
> >=20
> > I'm not sure to understand your suggestion. Is this:
> > 1) for mkdir(), create the non-default group, but without its default g=
roups,
> > and defer their creation to a worker which won't have constraints on lo=
cks held
> > by any caller;
> > 2) for rmdir(), unlink the non-default group, but without unlinking its=
 default
> > groups, and defer the recursive work to a lock-free context?
> >=20
> > For mkdir(), this may work. Maybe a bit confusing for userspace, since =
mkdir(A)
> > returns as soon as A is created, but A may be populated later and users=
pace may
> > rely on A being populated as soon as it is created (current behavior). =
As a
> > configfs user, this makes my life harder...
>=20
> Right, so that is the whole crux of the matter?

Probably not. I'm not the maintainer of configfs, but I guess that Joel is =
a bit
reluctant to deeply rework parts of something that actually works (conflicts
with lockdep excepted).

>=20
> Initially I understood the whole recursive locking issue to be about
> having to serialize mkdir vs rmdir so that you would know the default
> groups to be empty etc.
>=20
> You could create the subtree before you link it in. i_op->mkdir() only
> has the parent i_mutex held, so you should be able to create your inode,
> and all default groups (some of who will have the non-default group as
> parent, but that's ok, as we don't have that locked yet).
>=20
> Once you've constructed this, you could connect the non-default group to
> its parent.
>=20
> Also, you don't _need_ to have any i_mutex's locked here, because non of
> these inodes are reachable.

True. I already suggested this to Joel (while fixing a race condition), but=
 this
raises other issues (see http://marc.info/?l=3Dlinux-kernel&m=3D12143877662=
6316&w=3D2
for a previous discussion on this).

>=20
> > For rmdir(), is this safe to unlink a non-empty directory, and to empty=
 it
> > afterwards? This looks like going back to the unmount problem.
>=20
> Dunno :-), I think it should be safe. The only guarantee you need is
> that there are no refs to inodes in the decoupled sub-tree (other than
> your own of course.)
>=20
> So you'd only need to punt the rmdir cleanup to eventd or something.

May be. Anyway I can't investigate this right now, and that's why I'm asking
Joel if he is going to accept one of the temporary solutions that I provided
(Note that my second solution
http://marc.info/?l=3Dlinux-kernel&m=3D122962334723834&w=3D2 does not turn =
off
lockdep!). Of course it's better if someone can just do this rework :)

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-10171-1232981575-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJfc7oVKcRuvQ9Q1QRApBcAKDRxgTJkShN1p8D7FhoJE98sWRx7QCeOCJa
XCWqmEbZDJ4neuBlPTjTf3A=
=pzjJ
-----END PGP SIGNATURE-----

--=_bohort-10171-1232981575-0001-2--
