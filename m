Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZEVILn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZEVILn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZEVIL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:11:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZEVIL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:11:28 -0400
Subject: Re: INFO: possible circular locking dependency at 
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <d82e647a0905220103s23ad0feejfaa787dcd481a41c@mail.gmail.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
	 <1242802064.31350.12.camel@johannes.local>
	 <d82e647a0905220103s23ad0feejfaa787dcd481a41c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zz0uQJBYH8wu44wUEHSL"
Date: Fri, 22 May 2009 10:11:09 +0200
Message-Id: <1242979869.4212.32.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zz0uQJBYH8wu44wUEHSL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-22 at 16:03 +0800, Ming Lei wrote:
> 2009/5/20 Johannes Berg <johannes@sipsolutions.net>:
> > On Wed, 2009-05-20 at 11:36 +0800, Ming Lei wrote:
> >
> >> > Anyway, you can have a deadlock like this:
> >> >
> >> > CPU 3                   CPU 2                           CPU 1
> >> >                                                        suspend/hiber=
nate
> >> >                        something:
> >> >                        rtnl_lock()                     device_pm_loc=
k()
> >> >                                                        -> mutex_lock=
(&dpm_list_mtx)
> >> >
> >> >                        mutex_lock(&dpm_list_mtx)
> >>
> >> Would you give a explaination why mutex_lock(&dpm_list_mtx) runs in CP=
U2
> >> and depends on rtnl_lock?
> >
> > Why not? Something is registering a hotplugged netdev.
>=20
> It seems dpm_list_mtx is held in kernel_init context, so should not consi=
der
> registering a hotplugged netdev, isn't it?
>=20
> I am still confused, since rtnl_mutex is held before dpm_list_mtx which
> is acquired in kernel_init context.
>=20
> [  562.689476] -> #3 (dpm_list_mtx){+.+.+.}:
> [  562.689480]        [<ffffffff8026eae8>] __lock_acquire+0x13a9/0x171c
> [  562.689484]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
> [  562.689489]        [<ffffffff804ab2f0>] mutex_lock_nested+0x6f/0x36b
> [  562.689493]        [<ffffffff803f6395>] device_pm_add+0x4b/0xf2
> [  562.689499]        [<ffffffff803ef382>] device_add+0x498/0x62a
> [  562.689503]        [<ffffffff8043fd32>] netdev_register_kobject+0x7b/0=
x80
> [  562.689509]        [<ffffffff80434761>] register_netdevice+0x2d0/0x469
> [  562.689514]        [<ffffffff80434939>] register_netdev+0x3f/0x4d
> [  562.689519]        [<ffffffff806f634f>] loopback_net_init+0x40/0x7d
> [  562.689524]        [<ffffffff8042ee79>] register_pernet_device+0x32/0x=
5f
> [  562.689528]        [<ffffffff806fb41a>] net_dev_init+0x143/0x1a1
> [  562.689533]        [<ffffffff80209080>] do_one_initcall+0x75/0x18a
> [  562.689538]        [<ffffffff806d0678>] kernel_init+0x138/0x18e
> [  562.689542]        [<ffffffff8020c33a>] child_rip+0xa/0x20
> [  562.689546]        [<ffffffffffffffff>] 0xffffffffffffffff

You need to stop looking at the lockdep report. We've strayed far enough
from it that it's no longer useful. Anyhow, the kernel_init context here
doesn't matter -- what is relevant is that we have
	device_pm_add
being called somewhere inside
	register_netdev

where register_netdev acquires the rtnl, and device_pm_add acquires
dpm_list_mtx so we get this dependency of the two which I mapped onto
CPU 2.

The fact that this is in kernel_init isn't significant, that's because
the network device is built-in or whatever, if you hotplug a USB network
device you get the same chain of events starting from USB.

johannes

--=-Zz0uQJBYH8wu44wUEHSL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFl4aAAoJEODzc/N7+Qmad8UQAMVUtQ7KF7o2rnkeXtbhyNqr
GL3lnNbc6ThCjh0DNBd5Rz5KA0Ta4xHUDvpQsiQ4wSvsAP6hF9Jx71b8kCTU+sh8
hxBGY0bSj5wkHTDXZojG77T3GyxSGvmqkQr7vYmPUOhczKJR+XdLjQKS8H/CdPrr
sSHqQmYafUgvns/cSDjmwBeJvwIGMOr0ymwTtKHVbB0YTMI4DvffulZtTUg23Rvr
jfaP64H+nyRq8BbAZS8Om0ydPhMB0ge8iBBIAPUJ5Iw7hfQh4rTNmk5S9x6c8925
t48j77ZJwl8h6aTmfckSX/HqDa6Kg7T+LZ0utLVJtJF6mUumZU76Y5f9KkrM+JPF
jnLZoBC76gBR5yIx5LyKXywMjbQEAt//4dTAl9oMZ1LgZH+3oYvTtRhhi4OY0pMB
RvPI68Vyuy6iWfYBw05IRyclLk889+ChQChwonKQr//ZOgjp7M1sqbK3nCt3cJLo
tfpza3dKZiXYkjlvvEP2psdwME5wv4sw7jtEGk+ZFMfulSCnEppc9jDgAYGMUX6t
BbdTfODjkjh37GQW10WloEjT1crLgbHQUDd5bJWLGQwgWtZnXKcQITwHfFn+qCVP
G7xYWq3guGDPLgdtdXvdJksj3UwQu5Z1qWn8YDWvJSJEXzvX+gCWdI/ETgjog7FO
KHcjPfO08sEW2YcmqiTw
=U1JQ
-----END PGP SIGNATURE-----

--=-Zz0uQJBYH8wu44wUEHSL--

