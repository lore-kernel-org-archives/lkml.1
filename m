Return-Path: <linux-kernel-owner+w=401wt.eu-S1031480AbXDZUIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031480AbXDZUIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031490AbXDZUIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:08:06 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:46087 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031480AbXDZUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:08:03 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <1177607026.30284.197.camel@frg-rhel40-em64t-04>
	 <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-brzrIl+bq3hWgwp+p2Pq"
Date: Fri, 27 Apr 2007 06:08:01 +1000
Message-Id: <1177618081.4737.42.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-brzrIl+bq3hWgwp+p2Pq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 10:34 -0700, Linus Torvalds wrote:
>=20
> On Thu, 26 Apr 2007, Xavier Bestel wrote:
> >=20
> > Won't there be problems if e.g. X tries to write something to its
> > logfile after snapshot ?
>=20
> Sure. But that's a user-level issue.
>=20
> You do have to allow writing after snapshotting, since at a minimum, you'=
d=20
> want the snapshot itself to be written. So the kernel has to be fully=20
> running, and support full user space. No "degraded mode" like now.

It doesn't need a fully functional userspace (unless you want to write
to a fuse device, and even then that could be worked around - make it
like uswsusp or userui).... can I deverge for a second and say that from
this point of view, fuse is the lamest idea ever invented. Guaranteed to
break your ability to suspend^Wsnapshot.... Anyhow, if the kernel has
bmapped the pages it's going to write to beforehand, it knows where the
image needs to go. No need for userspace at all.

> So when I said "fully running user mode", I really meant it from the=20
> perspective of the kernel - not necessarily from the perspective of the=20
> "user". You do want to limit _what_ user mode does, but you must not limi=
t=20
> it by making the kernel less capable.
>=20
> Remounting mounted filesystems read-only sounds like a good idea, for=20
> example. We can do that. We have the technology. But we shouldn't limit=20
> user space from doing other things (for example, it might want to actuall=
y=20
> *mount* a new filesystem for writing the snapshot image).

We tried that. It would need some work. IIRC remounting filesystems
read-only makes files become marked read-only. Perfectly sensible,
except that if you then remount the filesystem rw at resume time, all
those files are still marked ro and userspace crashes and burns. Not
unfixable, I'll agree, but there is more work to do there.

As to the example, mounting a new filesystem for writing the snapshot
image should probably be done before we do the snapshot. Then it won't
be in danger of triggering anything that might require one of the other
fses to be rw (eg syslog).

> For example, right now we try to "fix" that with the whole process freeze=
r=20
> thing. And that code has *caused* more problems than it fixed, since it=20
> tries to freeze all the kernel threads etc, and you simply don't have a=20
> truly *working*system*.

Yes, it has been difficult. But so is bringing up a child.

> I think it's fine to freeze processes if that is what you want to do (for=
=20
> example, send them SIGSTOP), but we freeze them *too*much* right now, and=
=20
> the suspend stuff has taken over policy way too much. We don't actually=20
> leave the system in a runnable state. I can almost guarantee that you'd b=
e=20
> *better* off having the snapshot taking thing do a
>=20
> 	kill(-1, SIGSTOP);
>=20
> in user space than our current broken process freezer. At least that=20
> wouldn't have screwed up those kernel threads as badly as swsusp did.

I don't think it's fair to blame swsusp there. Maybe cpu hotplugging...

> And no, I'm not saying that my suggestion is the only way to do it. Go=20
> wild. But the *current* situation is just broken. Three different things,=
=20
> none of which people can agree on. I'd *much* rather see a conceptually=20
> simpler approach that then required, but even more important is that righ=
t=20
> now people aren't even discussing alternatives, they're just pushing one=20
> of the three existing things, and that's simply not viable. Because I'm=20
> not merging another one.
>=20
> In fact, I personally feel that I shouldn't even have merged=20
> userspace-swsusp, but if Andrew thinks it needs to be merged, my personal=
=20
> feelings simply don't matter that much. I have to trust people. But yes,=20
> as far as *I* am personally concerned, I think it was a mistake to merge=20
> it.

Perhaps you should try to make an alternative yourself instead of
pushing us into making something we don't believe will work (my case) or
have already done but in a way you don't like (Rafael). Don't talk about
Pavel cutting code. He's just acking/nacking what Rafael sends him.

Nigel

--=-brzrIl+bq3hWgwp+p2Pq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMQahN0y+n1M3mo0RAjntAKDsUYXr66/y/VhHxD/WkgWmtaW5lwCg9kUx
di0ap8JCupvhKVRZ1ohRrSg=
=DhGo
-----END PGP SIGNATURE-----

--=-brzrIl+bq3hWgwp+p2Pq--

