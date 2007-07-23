Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXGWDL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXGWDL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 23:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761235AbXGWDLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 23:11:46 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34747 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761092AbXGWDLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 23:11:46 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 13:11:53 +1000
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       Miklos Szeredi <miklos@szeredi.hu>, nigel@suspend2.net,
       linux-kernel@vger.kernel.org, miltonm@bga.com, ying.huang@intel.com,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707230842.22121.nigel@nigel.suspend2.net> <18083.61595.217126.824924@cargo.ozlabs.ibm.com>
In-Reply-To: <18083.61595.217126.824924@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3061019.5FOuh07jjx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707231311.56398.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3061019.5FOuh07jjx
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Monday 23 July 2007 10:04:43 Paul Mackerras wrote:
> Nigel Cunningham writes:
>=20
> > I guess I want to persist because all of these issues aren't utterly
> > unsolvable. It's just that we don't have the infrastructure yet to
> > figure out the solutions to these issues trivially. Take, for example,
>=20
> Ever heard of the halting problem? :)  It's not just a matter of
> infrastructure.  You very quickly get into questions that are
> mathematically undecideable.

Is this the halting problem, though?

> > the locking issue. If we could call some function to say "What process
> > holds this lock?", then task A could know that it's waiting on task B
> > and put that information somewhere. We could then use the information
> > to freeze task B before task A.
>=20
> But how would that help?  If task B holds the lock, then we can't
> freeze it until it's released the lock.  Then the question is, what
> does task B need in order to get to the point where it releases the
> lock?  And so on.  It rapidly gets not just extremely messy, but
> actually impossible to compute in general.

Take a step back for a second.

The problem we're facing now is that we're getting some userspace threads,=
=20
used in processing I/O, that are functioning as exceptions to the "freeze=20
userspace, then freezeable kernel threads" rule. They are only exceptions=20
because of that role in processing I/O - because they're de facto kernel=20
threads. So, if we orient our thinking more in terms of I/O processing and=
=20
less in terms of the userspace/kernelspace distinction, we'll have a=20
solution:

1) Freeze processes that aren't fs related (ie stop them generating I/O).
2) Flush pending I/O.
3) Freeze filesystems in reverse order of dependency, the primary purpose=20
being to stop them generating further I/O on their metadata.

Locks that are being held are only being held because work is being done. I=
f=20
we progressively focus on threads in terms of their create/process work=20
dependencies, we'll see that the problem isn't at all intractable.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart3061019.5FOuh07jjx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGpBx8N0y+n1M3mo0RAhybAKCZ6JG1LcsYF5DaSS90GYKo5Q8mmwCgneh8
YI3yYVHZsrsq66TLZOMVc/o=
=9J29
-----END PGP SIGNATURE-----

--nextPart3061019.5FOuh07jjx--
