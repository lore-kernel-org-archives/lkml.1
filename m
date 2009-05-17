Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZEQLTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZEQLTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZEQLSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:18:55 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZEQLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:18:54 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090517071834.GA8507@elte.hu>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-azjmZOR794pbmTeCJvvr"
Date: Sun, 17 May 2009 13:18:21 +0200
Message-Id: <1242559101.28127.63.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-azjmZOR794pbmTeCJvvr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-17 at 09:18 +0200, Ingo Molnar wrote:
> Cc:s added. This dependency:

Not sure why you're not adding the cfg80211 maintainer if you think
cfg80211 causes the problem...

> > -> #2 (cfg80211_mutex){+.+.+.}:
> >        [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
> >        [<ffffffff80271f38>] lock_acquire+0x98/0x140
> >        [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
> >        [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
> >        [<ffffffffa007e66a>] reg_todo+0x19a/0x590 [cfg80211]
> >        [<ffffffff80258f18>] worker_thread+0x1e8/0x3a0
> >        [<ffffffff8025dc3a>] kthread+0x5a/0xa0
> >        [<ffffffff8020d23a>] child_rip+0xa/0x20
>=20
> is what sets the dependencies upside down.

I'm also not sure how you arrived at that conclusion, I would be
interested to hear how you did. In any case, it's most definitely not
cfg80211 causing it.

Cf. this, almost identical, lockdep report for example:
http://paste.pocoo.org/show/116240/
The logical conclusion here would be to say that the rtnl is responsible
here...

As you can see from the report, the only thing cfg80211_mutex does is
register a device struct while holding it -- claiming cfg80211 (or rtnl
in the other report which behaves the same) responsibility here because
of that is totally ludicrous -- that would mean you've suddenly changed
all the locking rules so that you can no longer register devices under a
lock that you also need from a work struct executed due to
schedule_work().

I'm not entirely sure yet, but I would think the problem might be a
false positive in the workqueue code -- remember this report only
triggers because cleanup_workqueue_thread() acquires the fake lock for
the workqueue. Maybe it shouldn't do that from the CPU_POST_DEAD
notifier? Oleg, can you help me out here?

johannes


--=-azjmZOR794pbmTeCJvvr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKD/J6AAoJEODzc/N7+QmaOlkP/iLNVh7qBVl+Dqb9iD/gKVaX
FICUFRBtbMOh36j/HMfShRWT6GzMb+Mm/hRFx3iJoBVgZqyLDG8p6rBRRmH1rT5t
YsxQPTceSPsrZbAZCSoAqlHe253j5TBU2uDHiPGOzW/Zrvs4ve8BcNExaD2ZL9/r
uvgUG97GfHtnBRV/NNfJU25UpQ2ZhHUOt+CpU2CweGdGW0bBxw8xTfAIDAyg6DX0
mgMnn3IpsR+HPUk8QoBi1L8fORcRjUc9LGmG93nt5OkA8ADtmBYsPHr6kfa0/OzB
CkEYsRTIuM7KttPJetnP93v9TG2+oz1puduheX4oEzVeOcLw8GsrXUFtq6HRIU9I
yihtPAtnSuqYljz+9cvU++m3qkVoKSyPDTiZc2Mf4x0YbXDbj8Rioyl0Zvdadkqc
ga9y1tBl7zB4xV+vLz0v3k2IZKaUQJFgcVJ7JtZ2FSpNxAD27HbpQ9MS194hvWzA
EgqsAJK9uyEzM92g2wkw3W+B1korR66OEA4AJKErW2hqcHxPhueGRk+ivurDe7Ph
mQmdIZ+gAAuHitdRaP4C066reUyu5ascXGDw68mrdxDIWo29JuQdCnOHohQizi7T
lf53jyyZTb4c+okMqbxlg9iSaKZsrST9avVRebkbNQ0aVCLuqxLFocMNB9J8yM8c
b3unAY1UC2LvHwhAxQbv
=37o7
-----END PGP SIGNATURE-----

--=-azjmZOR794pbmTeCJvvr--

