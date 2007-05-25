Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbXEYEdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbXEYEdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbXEYEdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:33:13 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:44992 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991AbXEYEdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:33:11 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost>
	 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
	 <20070524200435.GA9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
	 <20070524220017.GC9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
	 <20070524221743.GD9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
	 <20070524231852.GG9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
	 <1180058123.3997.91.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
	 <1180059605.3997.100.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
	 <1180062040.3997.112.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p9/lme5urVDwN64ibFlD"
Date: Fri, 25 May 2007 14:33:07 +1000
Message-Id: <1180067587.3997.136.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-p9/lme5urVDwN64ibFlD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Howdy.

On Thu, 2007-05-24 at 20:31 -0700, Linus Torvalds wrote:
>=20
> On Fri, 25 May 2007, Nigel Cunningham wrote:
> > >=20
> > > That said, I think freezing is crap even for snapshotting/suspend-to-=
disk,=20
> > > but the point of the above rant is to show how insane it is to think =
that=20
> > > problems and complexity in one area should translate into problems an=
d=20
> > > complexity in another area.
> >=20
> > Does that imply that you'd prefer to see filesystem checkpointing code,
> > that you think freezing can be done better, or do you have some other
> > solution that hasn't occurred to me?
>=20
> I actually don't think that processes should be frozen really at all.
>=20
> I agree that filesystems have to be frozen (and I think that checkpointin=
g=20
> of the filesystem or block device is "too clever"), but I just don't thin=
k=20
> that has anything to do with freezing processes.
>=20
> So I'd actually much prefer to freeze at the VFS (and socket layers, etc)=
,=20
> and make sure that anybody who tries to write or do something else that w=
e=20
> cannot do until resuming, will just be blocked (or perhaps just buffered)=
!
>=20
> See? I actually think that this process-based thing is barking up the=20
> wrong tree. After all, it's really not the case that we need to stop=20
> processes, and stopping processes really does have some problems. It's=20
> simpler in some ways, but I think a more directed solution would actually=
=20
> be better.

That does sound doable.

I'm sorry to say it, but dropping process freezing still seems to me
like the better way though. I prefer it because of the reliability
aspect. With the current code, having frozen processes, I can look at
the state of memory, calculate how much I'll need for this or that and
know that I'll have sufficient memory for the atomic copy and for doing
the I/O  (making assumptions about how much memory drivers will
allocate) before I start to do either. If we stop freezing processes,
that predictability will go away. There'll always be a possibility that
some process will get memory hungry and stop me from being able to get
the image on disk, and I'll have to either abort or give up and try
again and again until I can complete writing the image, the battery runs
out or whatever...=20

> >bviously we _do_ want to actually try to quiesce normal user processes.=20
> >But by "normal user", I'd be willing to limit it to non-uid-zero things,=
=20
> >for example. Exactly because it does turn out that the kernel kind of=20
> >depends on user-land things for stuff like network filesystem connection=
=20
> >setup etc (ie we tend to do things like the mount encryption stuff in=20
> >userland!).

Not sure who you're quoting here, but it's not me. Pavel maybe? I was
unsub'd for a couple of weeks, so guess it's from during that period.

> But I really don't care that deeply per se, exactly because I don't use i=
t=20
> myself. I think people are going down the wrong rabbit-hole, but it=20
> wouldn't _irritate_ me that much except for the fact that it now also=20
> impacts suspend-to-RAM.

Does that mean you never ever power off your laptop (assuming you have
one), and the battery never runs out? Surely you must power it off
completely sometimes? If you do, doesn't that ever happen at a time when
you're part way through something and you'd like to be able to pick up
your merge or whatever later without having to say "Now, where was I up
to?" *shrug* Maybe you're just exceptional :) (Yeah, we know you are in
other ways, but this way?...)

Regards,

Nigel

--=-p9/lme5urVDwN64ibFlD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVmcDN0y+n1M3mo0RAl/rAJ9q6uP+vRNHkJu12dAxsODaG8PCnQCgo5ce
u9rWbg205t/NEyRWRpiS1Ak=
=HpTm
-----END PGP SIGNATURE-----

--=-p9/lme5urVDwN64ibFlD--

