Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZAZXER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZAZXER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZAZXEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:04:04 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:60361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZAZXEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:04:02 -0500
Subject: Re: [PATCH] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1233010786.4344.1.camel@johannes.local>
References: <1233010786.4344.1.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xo1scVtL/2i4IgUQf/qS"
Date: Tue, 27 Jan 2009 00:03:56 +0100
Message-Id: <1233011036.4869.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xo1scVtL/2i4IgUQf/qS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 23:59 +0100, Johannes Berg wrote:
> This modifies the timer code in a way to allow lockdep to detect
> deadlocks resulting from a lock being taken in the timer function
> as well as around the del_timer_sync() call.
>=20
> Validated with this module, otherwise bootup was clean.

Not having a proper stack trace in there is a little confusing:

[   81.547455]=20
[   81.547457] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   81.547657] [ INFO: possible circular locking dependency detected ]
[   81.547759] 2.6.29-rc2-wl-11979-gc32422d-dirty #24
[   81.547857] -------------------------------------------------------
[   81.547956] rmmod/3857 is trying to acquire lock:
[   81.548055]  (&t){-+..}, at: [<ffffffff80252960>] del_timer_sync+0x0/0xa=
0
[   81.548303]=20
[   81.548303] but task is already holding lock:
[   81.548491]  (&l){.+..}, at: [<ffffffffa11f9010>] e+0x10/0x30 [test]
[   81.548736]=20
[   81.548736] which lock already depends on the new lock.
[   81.548737]=20
[   81.549023]=20
[   81.549023] the existing dependency chain (in reverse order) is:
[   81.549212]=20
[   81.549213] -> #1 (&l){.+..}:
[   81.549544]        [<ffffffffffffffff>] 0xffffffffffffffff
[   81.549697]=20
[   81.549697] -> #0 (&t){-+..}:
[   81.550028]        [<ffffffff802737b7>] check_prev_add+0x57/0x770
[   81.550178]        [<ffffffff802744d6>] validate_chain+0x606/0x6c0
[   81.550322]        [<ffffffff802749cf>] __lock_acquire+0x43f/0xa10
[   81.550471]        [<ffffffff80275031>] lock_acquire+0x91/0xc0
[   81.550619]        [<ffffffff8025299d>] del_timer_sync+0x3d/0xa0
[   81.550767]        [<ffffffffa11f901c>] e+0x1c/0x30 [test]
[   81.550911]        [<ffffffff80281d9b>] sys_delete_module+0x27b/0x2e0
[   81.551062]        [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[   81.551213]        [<ffffffffffffffff>] 0xffffffffffffffff
[   81.551361]=20
[   81.551361] other info that might help us debug this:
[   81.551362]=20
[   81.551646] 1 lock held by rmmod/3857:
[   81.551743]  #0:  (&l){.+..}, at: [<ffffffffa11f9010>] e+0x10/0x30 [test=
]
[   81.552035]=20
[   81.552035] stack backtrace:
[   81.552222] Pid: 3857, comm: rmmod Not tainted 2.6.29-rc2-wl-11979-gc324=
22d-dirty #24
[   81.552371] Call Trace:
[   81.552469]  [<ffffffff80273260>] print_circular_bug_tail+0xe0/0xf0
[   81.552571]  [<ffffffff802737b7>] check_prev_add+0x57/0x770
[   81.552672]  [<ffffffff802744d6>] validate_chain+0x606/0x6c0
[   81.552773]  [<ffffffff802749cf>] __lock_acquire+0x43f/0xa10
[   81.552876]  [<ffffffff8026fb04>] ? get_lock_stats+0x34/0x70
[   81.552979]  [<ffffffff8026fb04>] ? get_lock_stats+0x34/0x70
[   81.553080]  [<ffffffff80275031>] lock_acquire+0x91/0xc0
[   81.553181]  [<ffffffff80252960>] ? del_timer_sync+0x0/0xa0
[   81.553284]  [<ffffffff8025299d>] del_timer_sync+0x3d/0xa0
[   81.553383]  [<ffffffff80252960>] ? del_timer_sync+0x0/0xa0
[   81.553487]  [<ffffffffa11f901c>] e+0x1c/0x30 [test]
[   81.553588]  [<ffffffff80281d9b>] sys_delete_module+0x27b/0x2e0
[   81.553690]  [<ffffffff8020c76d>] ? retint_swapgs+0xe/0x13
[   81.553792]  [<ffffffff80272c52>] ? trace_hardirqs_on_caller+0x182/0x1e0
[   81.553895]  [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b


--=-Xo1scVtL/2i4IgUQf/qS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfkFaAAoJEKVg1VMiehFYUoIP/if6kML8vv4/5sasNCA2tU6J
F9PIFTH8Q6ru86YdnSBV4qaP5TeRgNvTZZXGMwduQEYAj8PQo1/SMH0bWoV9ACrd
oB5uZByuohZB/u0H60DgRgeqBwZld4+xmhItJfKMboH0unMN6G/eG1ZCt05FgJea
NHY7qhWhm4dJEfcOnWlX1/5gLzKyqH/LhLljzykpdx6XABXMqYN1Zm321/jd1yPG
DuNwv6zThFJn5nkdPSCKCp5Xx1tw8X7FcvMSUhn6876amvpykMEndFLIrvgFccyt
Q95956/HQJ4xoWp6uQIKBZoc0d3BMYiurz0/wrxUToOs9zFd8/hmJ1kNU4SB1zay
xK4/l3MHh2rapwPM4291J+CNTVD0PsoVh4kbSc+DrS7PwkO+lv6KYcZE2Z9OKr2r
71E5u5WUDKEZm08yJ+ZKIA8yXQbcfV1gyDhAeqJhzPYsmvqAjzV9qRk9nmrDt7jz
ep60AA4oQ3vIhdUBt0vgk8Lvkvp8LusZSGSTLft3Ftwj3V8Rfo2at+lLT5TSQ0xW
9hquV+0dtsQ2d8+VqUyFO4by5uIoNOBzaf8zGdCB5FofNHHw8CYVXhDhCsIF00Z6
qFEDw7Jfc7PQ1BDYj/jsiXeh52PTb4uKapN1W/4QItJsGqndyOkPrp9tlxJHhThl
1hn9MxMHeUyKS4X+D6U7
=g1b1
-----END PGP SIGNATURE-----

--=-Xo1scVtL/2i4IgUQf/qS--

