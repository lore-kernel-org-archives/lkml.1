Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYLPDYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYLPDYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYLPDYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:24:31 -0500
Received: from bender.home.grueneberg.de ([82.139.255.106]:49767 "EHLO
	bender.home.grueneberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYLPDYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:24:31 -0500
Date: Tue, 16 Dec 2008 04:24:06 +0100
From: Andre Grueneberg <list.lguest@grueneberg.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org
Message-ID: <20081216032405.GB19686@leela.home.grueneberg.de>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>, lguest@ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20081212194728.GE29143@leela.home.grueneberg.de> <200812151101.08670.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <200812151101.08670.rusty@rustcorp.com.au>
X-message-flag: Please send plain text messages only. Thank you.
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [Lguest] lguest, virtio_blk, id is not a head!
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Rusty Russell wrote:
> > Lately I upgraded my host and guest from kernel 2.6.25 (Debian) to
> > vanilla 2.6.27.8. I have two virtual machines and in both I recognised
> > the same issue after a while.
> >=20
> > After running for some hours the first guest showed the following
> > message on the console:
> > virtio_blk virtio1: id 1 is not a head!
>    This is interesting.  There hasn't been a great deal of change between
> those versions on the lguest side.  This sounds like a race, and the only
> thing I can see which would have introduced this is the change below.

I removed the "lguest: turn Waker into a thread, not a process" patch as
proposed. Short result: The problem still exists.

Longer story:
As this issue is extremly hard to reproduce, I made an attempt to cause
many file system reads. If I understood things correctly this is when
the guest side of virtio_blk is likely to call vring_get_buf?! I did so
by creating a large file (300MiB vs. 256MiB memory) in the guest and
reading it multiple times in 1k pieces (dd).

To verify that it works, I ran this loop on 2.6.27.8 guest with the
original launcher: failure after ~200 iterations.

So I went on with the patched version of lguest (launcher with waker
process) and the same 2.6.27.8 guest: failure after ~600 iterations.

Next step was a 2.6.25 guest with the original launcher: I stopped it
after ~1600 iterations did not show a fault.

As it occured to me that using a file in a guest's file system might not
be the optimal target, I have now modified my loop to use the first
300MiB of the block device itself. With the original combination, I now
got the failure after ~750 iterations.

I am now running this test with 2.6.25 guest again. As the host is also
serving some serious purpose, I can only run this kind of long lasting
tests during night time. So I'll be forced to stop this test soon (but
I'll move into bed first).

My next step will be to use some non-root block device, to have a chance
to access the guest after the crash. Do you have any idea what to look
at then?

One thing, I just recognised:
While my 2.6.25 guest kernel is configured with "NOHz mode", the=20
2.6.27.8 guest is using "high resolution mode".

Thanks so far,
Andr=E9
--=20
Reality is a crutch for people who can't handle drugs.

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklHH1UACgkQLPeb7q968GBvNwCgodxIrg2M7fPvif8rkLyMNkEK
IS0AnjHqza9T9YgdQMKNmW2xoq6mIsqq
=1qmB
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
