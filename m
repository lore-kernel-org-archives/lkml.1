Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753212AbYLRLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYLRLPx (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYLRLPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:15:40 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:53557 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYLRLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:15:39 -0500
Date: Thu, 18 Dec 2008 12:15:36 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com,
        swhiteho@redhat.com
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20081218111536.GR19128@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com,
	swhiteho@redhat.com
References: <20081212100615.GD19128@hawkmoon.kerlabs.com> <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-17313-1229598779-0001-2"
Content-Disposition: inline
In-Reply-To: <20081218092744.GB30789@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-17313-1229598779-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18/12/08  1:27 -0800, Joel Becker wrote:
>=20
> 	I know it's hard, or I'd have sent you patches :-)  In fact,
> Louis tried to use the subclass bits to make this work to a depth of N
> (where N was probably deep enough in practice).  However, this creates
> subclasses that don't get seen by the regular VFS locking - and the big
> deal here is making sure configfs's use of i_mutex meshes with the VFS.
> That is, his code made the warnings go away, but removed much of
> lockdep's ability to see when we got the locking wrong.
>=20
> > The thing is, in practise it turns out that reworking code to not run
> > into these issues often makes the code better - if only for the fact
> > that taking locks is expensive and doing less is better, and holding
> > locks stifles concurrency, so holding less it better (yes, I said
> > _often_, there likely are counter cases but I don't believe configfs is
> > one of them).
>=20
> 	This isn't about concurrency or speed.  This is about safety
> while configfs is attaching or (especially) detaching config_items from
> the filesystem view it presents.  When the VFS travels down a path, it
> unlocks the trailing directory.  We can't do that when tearing down
> default groups, because we need to lock that small hunk and tear it out
> atomically.
>=20
> > Anyway - I'm against just turning lockdep off, that will make folks
> > complacent and let the stuff rot to bits inside - and I for one will
> > refuse to run anything using it (but since that only seems to be
> > dlm/ocfs and I'm of the believe that centralized cluster stuff sucks
> > rocks anyway that won't be a problem).
>=20
> 	Oh, be nice :-)
> 	You are absolutely right that turning off lockdep leaves the
> possibility of complacency and bitrot.  That's precisely why I didn't
> like Louis' subclass solution - again, bitrot might go unnoticed.
> 	Now, I know that I will be paying attention to the locking and
> going over it with a fine-toothed comb.  But I'd much rather have an
> actual working lockdep analysis.  Whether that means we find a way for
> lockdep to describe what's happening here, or we find another way to
> keep folks out of the tree we're removing, I don't care.

Perhaps I didn't explain myself well. Quoting my original post:

<quote>
I am proposing two solutions:
1) one that wraps recursive mutex_lock()s with
   lockdep_off()/lockdep_on().
2) (as suggested earlier by Peter Zijlstra) one that puts the
   i_mutexes recursively locked in different classes based on their
   depth from the top-level config_group created. This
   induces an arbitrary limit (MAX_LOCK_DEPTH - 2 =3D=3D 46) on the
   nesting of configfs default groups whenever lockdep is activated
   but this limit looks reasonably high. Unfortunately, this alos
   isolates VFS operations on configfs default groups from the others
   and thus lowers the chances to detect locking issues.

This patch implements solution 1).

Solution 2) looks better from lockdep's point of view, but fails with
configfs_depend_item(). This needs to rework the locking
scheme of configfs_depend_item() by removing the variable lock recursion
depth, and I think that it's doable thanks to the configfs_dirent_lock.
For now, let's stick to solution 1).
</quote>

Solution 2) does not play with i_mutex sub-classes as I proposed earlier, b=
ut
instead put default_groups' i_mutex in separate classes (actually one class=
 per
default group depth). This is not worse than putting each run queue lock in=
 a
separate class, as it used to be.

For instance, if a created group A has default groups A/B, A/D, and A/B/C, =
A's
i_mutex class will be the regular i_mutex class used everywhere else in the=
 VFS,
A/B and A/D will have default_group_class[0], and A/B/C will have
default_group_class[1].

Of course those default_group classes will not benefit from locking schemes=
 seen
by lockdep outside configfs, but they still will interact nicely with the V=
FS.
Moreover, a default group depth limit of 46 (MAX_LOCK_DEPTH - 2) looks rath=
er
reasonable, doesn't it?

To me the real drawback of this solution is that it needs to rework locking=
 in
configfs_depend_item(). Peter says it is preferable, I know how it could be
done, but as any code rework this may bring new bugs, and I realize that I'm
spending time to explain this while 1) I don't have much time to just expla=
in
what could be done, 2) I'd prefer having time to code what I am explaining.
Let's see if I can show you something today.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-17313-1229598779-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJSjDYVKcRuvQ9Q1QRAhkQAJ907c3tv7L20vVurRF6Hgi13/JqdwCffmEy
ip8TVaSdSY/+s7dbqYpPRdI=
=4YUH
-----END PGP SIGNATURE-----

--=_bohort-17313-1229598779-0001-2--
