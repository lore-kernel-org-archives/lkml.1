Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZCJRkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZCJRkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZCJRkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:40:43 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:49781 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbZCJRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:40:42 -0400
Subject: Re: [PATCH] drm/i915: Fix lock order reversal in GTT pwrite path.
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1236648831-18230-2-git-send-email-eric@anholt.net>
References: <1236648831-18230-1-git-send-email-eric@anholt.net>
	 <1236648831-18230-2-git-send-email-eric@anholt.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zKaMcrqZI6h8j2GljM04"
Date: Tue, 10 Mar 2009 10:40:38 -0700
Message-Id: <1236706838.10190.72.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zKaMcrqZI6h8j2GljM04
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-09 at 18:33 -0700, Eric Anholt wrote:
> Since the pagefault path determines that the lock order we use has to be
> mmap_sem -> struct_mutex, we can't allow page faults to occur while the
> struct_mutex is held.  To fix this in pwrite, we first try optimistically=
 to
> see if we can copy from user without faulting.  If it fails, fall back to
> allocating memory, copying, then taking the lock and copying it to the GP=
U.
>=20
> Thanks to Linus for suggesting this (in retrospect) obvious way of doing =
it.

Simple, obvious, and wrong, I guess:

[  114.016013] BUG: scheduling while atomic: oglconform/4555/0x10000001
[  114.016015] 1 lock held by oglconform/4555:
[  114.016017]  #0:  (&dev->struct_mutex){--..}, at: [<f8a99cad>] i915_gem_=
pwrite_
ioctl+0x3be/0x5f5 [i915]
[  114.016033] Modules linked in: i915 drm i2c_algo_bit cfbcopyarea cfbimgb=
lt cfbfillrect 8250_pnp
[  114.016042] Pid: 4555, comm: oglconform Not tainted 2.6.29-rc6drm-intel-=
next #175
[  114.016044] Call Trace:
[  114.016048]  [<c0128e02>] __schedule_bug+0x5e/0x65
[  114.016051]  [<c07ccbe8>] schedule+0x9f/0x9e4
[  114.016055]  [<c012904f>] __cond_resched+0x25/0x3b
[  114.016058]  [<c07cd5bf>] _cond_resched+0x24/0x2f
[  114.016062]  [<c07cdfa9>] mutex_lock_nested+0x22/0x254
[  114.016065]  [<c014a631>] ? mark_held_locks+0x53/0x6a
[  114.016068]  [<c07cf66d>] ? _spin_unlock_irq+0x22/0x26
[  114.016072]  [<c014a7c8>] ? trace_hardirqs_on_caller+0xf3/0x12d
[  114.016075]  [<c0167ced>] generic_file_aio_write+0x54/0xbd
[  114.016079]  [<c0184cc5>] do_sync_write+0xab/0xe9
[  114.016082]  [<c0130ce9>] ? __do_softirq+0x135/0x13d
[  114.016086]  [<c013d1b3>] ? autoremove_wake_function+0x0/0x33
[  114.016089]  [<c0102f1c>] ? restore_nocheck_notrace+0x0/0xe
[  114.016093]  [<c014007b>] ? hrtimer_interrupt+0x53/0x146
[  114.016097]  [<c02a5662>] ? security_file_permission+0xf/0x11
[  114.016100]  [<c0184c1a>] ? do_sync_write+0x0/0xe9
[  114.016103]  [<c018549b>] vfs_write+0x8a/0x104
[  114.016116]  [<f8a99cfb>] i915_gem_pwrite_ioctl+0x40c/0x5f5 [i915]

Peter, it seems that pagefault_disable() implies not just disabling
pagefaults, but also scheduling.  I'm just trying to avoid taking
mmap_sem through the use of pagefault_disable(), while I'd like to still
be able to schedule if that's what it takes to get the work done.
Should I be able to do this, or should I just rewrite things to not use
vfs_write() and do my sleeping outside the lock?  I'm not opposed to
that, I just want to know if you needed an excuse to fix this.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-zKaMcrqZI6h8j2GljM04
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm2phYACgkQHUdvYGzw6vfrUACfb4QdtRgSmSzVuM4U9cz5DcuT
viYAn0Nu5xu8vkI/EnknjfP/MGZe/Ba2
=x2lu
-----END PGP SIGNATURE-----

--=-zKaMcrqZI6h8j2GljM04--
