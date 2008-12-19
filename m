Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYLSK3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYLSK3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYLSK3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:29:15 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:39553 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYLSK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:29:15 -0500
Date: Fri, 19 Dec 2008 11:29:11 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20081219102911.GU19128@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho <swhiteho@redhat.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com> <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com> <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins> <20081218225837.GB21870@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-21594-1229682394-0001-2"
Content-Disposition: inline
In-Reply-To: <20081218225837.GB21870@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-21594-1229682394-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18/12/08 14:58 -0800, Joel Becker wrote:
> On Thu, Dec 18, 2008 at 01:28:28PM +0100, Peter Zijlstra wrote:
> > In fact, both (configfs) mkdir and rmdir seem to synchronize on
> > su_mutex..
> >=20
> >  mkdir B/C/bar
> >=20
> >    C.i_mutex
> >      su_mutex
> >=20
> > vs
> >=20
> >  rmdir foo
> >=20
> >    parent(foo).i_mutex
> >      foo.i_mutex
> >        su_mutex
> >=20
> >=20
> > once holding the rmdir su_mutex you can check foo's user-content, since
> > any mkdir will be blocked. All you have to do is then re-validate in
> > mkdir's su_mutex that !IS_DEADDIR(C).
>=20
> 	We explicitly do not take any i_mutex locks after taking
> su_mutex.  That's an ABBA risk.  su_mutex protects the hierarchy of
> config_items.  i_mutex protects the vfs view thereof.
> 	If you look in mkdir, we take su_mutex, get a new item from the
> client subsystem, then drop su_mutex.  After that, we go about building
> our filesystem structure, using i_mutex where appropriate.  More
> importantly is rmdir(2), where we use i_mutex in
> configfs_detach_group(), but are not holding su_sem.  Only when
> configfs_detach_group() has successfully returned and we have torn down
> the filesystem structure do we take su_mutex and tear down the
> config_item structure.
> 	In fact, we're part of the way there.  Check out that
> USET_DROPPING flag we set in detach_prep() while scanning for user
> objects.  That flags us racing mkdir(2).  When we are done with
> detach_prep(), we know that mkdir(2) calls racing behind us will do
> nothing until we safely lock them out with the locking in
> detach_group().  All mkdir(2) calls will have exited by the time we get
> the mutex, and no new mkdir(2) call can start because we have the mutex.
> 	Now look in detach_groups().  We drop the groups children before
> marking them DEAD.  Louis' plan, I think, is to perhaps mark a group
> DEAD, disconnect it from the vfs, and then operate on its children.  In
> this fashion, perhaps we can unlock the trailing lock like a normal VFS
> operation.
> 	This will require some serious auditing, however, because now
> vfs functions can get into the vfs objects behind us.  And more vfs
> changes affect us.  Whereas the current locking relies on the vfs's
> parent->child lock ordering only, something that isn't likely to be
> changed.

I've thought about such plan, but I'm not comfortable enough with the VFS to
tell how it could be done precisely, and whether it is safe to remove a who=
le
tree from the dcache by just unlinking its root. In particular, how could we
deal with racing operations under default groups? Should we setup a link fr=
om
any default group to its youngest non-default group ancestor? As Steven
suggested, looking at unmount might be interesting, but not today as far as=
 I
am concerned.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-21594-1229682394-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJS3d3VKcRuvQ9Q1QRAlF5AKCxsw0f4XWG8M3M6cNZhx7ZXUBz6ACfWOi9
SPRAlYrHuIh8gRlyJvEYQa4=
=OIiQ
-----END PGP SIGNATURE-----

--=_bohort-21594-1229682394-0001-2--
