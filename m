Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbYAOMk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbYAOMk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYAOMkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:40:14 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:45666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYAOMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:40:12 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1200399661.26045.13.camel@twins>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>  <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>  <1200307896.5887.42.camel@johannes.berg>
	 <1200393685.5887.113.camel@johannes.berg> <1200399661.26045.13.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AZ4UJ0MUJ3YSg/edUqMu"
Date: Tue, 15 Jan 2008 13:39:47 +0100
Message-Id: <1200400787.5887.129.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AZ4UJ0MUJ3YSg/edUqMu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > To make sure now:
> > 	same key - different name	- BAD
> > 	same key - same name		- OK
> > 	different key - same name	- OK
>=20
> Strictly speaking one can do that, although I would recommend against it
> - it leads to confusion as to which lock got into trouble when looking
> at lockdep/stat output.

True, but I don't see a good way to avoid that. Similar things also
happen with

	mutex_init(&priv->mtx);

for example, no?

> > The root problem here seems to be that I use the same name as for the
> > workqueue for the lockdep_map and other code uses a non-static workqueu=
e
> > name. Using the workqueue name for the lock is good for knowing which
> > workqueue ran into trouble though.
>=20
> Indeed, and also using a different key allows the workqueue to have
> different lock dependencies as well. The trouble is, lockdep works at
> the class level, a class with multiple names just doesn't make sense,
> and reporting will get it wrong (although it may appear to work
> correctly in the trivial cases).

Right.

> > mac80211 for example wants to allocate a (single-threaded) workqueue fo=
r
> > each hardware that is plugged in and wants to call it by the hardware
> > name.
>=20
> Right, that would require a new key for each instance.

Except, how could I do that though? Keys are required to be static, so I
can't have the object as the key. In any case, I don't think it matters
much because the workqueues are per-hardware but all have similar users,
I think that the other users here probably behave similarly.

> > If you think the patch is a correct way to solve the problem I'll submi=
t
> > it formally and it should then be included in 2.6.24 to avoid
> > regressions with the workqueue API (the workqueue lockup detection was
> > merged early in 2.6.24.)
>=20
> The patch looks ok, one important thing to note is that it means that
> all workqueues instantiated by the same __create_workqueue() call-site
> share lock dependency chains - I'm unsure if that might get us into
> trouble or not.

It doesn't seem to have so far ;) I don't think it should. If some code
allocates a per-instance workqueue that's much like having an inode lock
or so.

The scenario to get into trouble with this would require having a
per-instance lock and a per-instance workqueue and flushing the
workqueue (that can contain functions taking the lock of instance A) of
instance A under the lock of instance B, but unless that is nested in a
way that it cannot happen in order BA as well it's actually a possible
ABBA deadlock.

> > Who should I send it to in that case?
>=20
> Me and Ingo :-)

Alright, I'll write a patch description and send it in a minute.

johannes

--=-AZ4UJ0MUJ3YSg/edUqMu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4ypkqVg1VMiehFYAQID0xAAhPFMktiSayFKqX6nI/lw6i6csmKVwT4/
ZeYNIvUIB8e8dL9kBdDR9fbqUQXnPkC6ie9EaPx4BRpUEO6gz7jtEGahVkrNe3xX
EXqEEig6kXVYqvL/9frfbeqhU1PnGpYXnEY1+SsgAd1avct4n1NZABgYLM2ohIMg
Vw8Aht2m91aTqG2eAsIzwYhGkLIOpjzluOIqDLANmQLyOcn2Gj1nKQCtXqWy8e63
2Yrc/NjLPii/c/xTIHSklJeEgiRBlY6HF3LURWqkFfQCKQcGmGMCU7uXRnqxGft6
I9g8c2jhSn0j8j0O60zrlhsXRbiCk+bk20KL68G6FZLNJWZ99bW+UrFDhamGwP65
gdFZBVe+/Mm+YC1vzhjN6VGqM6+poySIhadTRrAoG1lktnjOiLJ3a71SD2DOkV3B
YvHJv+5s9G+0vPvlFzUbflwiZqfI73yrZbSrlPL3rpkXsl8kMSHWjd86UEp1Hiwv
MwG5tvZqX73/mQ5FS00G11+utfu7nuT68wi7tKCJNzM+QYENO9N+WIJlLcq6kLOD
yDZi3bRmvgigJoqeWeJi9wgBfF7HbdzoIupXGYnGC+zS8oIB9kTIonfGw9CvC7Do
20hieBYm8KCdneA4KcfXRiX7GoRgQlgAOBB+pdt7uH0wIsz1NCoJbOykRNqPVSDO
p6xi/o9dWxI=
=geCA
-----END PGP SIGNATURE-----

--=-AZ4UJ0MUJ3YSg/edUqMu--

