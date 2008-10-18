Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbYJRVvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbYJRVvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 17:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYJRVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 17:51:44 -0400
Received: from home.keithp.com ([63.227.221.253]:39591 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYJRVvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 17:51:44 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081018203741.GA23396@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ipMZtKK8XAikoekP2bU4"
Date: Sat, 18 Oct 2008 14:51:30 -0700
Message-Id: <1224366690.4384.89.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ipMZtKK8XAikoekP2bU4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-18 at 22:37 +0200, Ingo Molnar wrote:

> But i think the direction of the new GEM code is subtly wrong here,=20
> because it tries to manage memory even on 64-bit systems. IMO it should=20
> just map the _whole_ graphics aperture (non-cached) and be done with it.=20
> There's no faster method at managing pages than the CPU doing a TLB fill=20
> from pagetables.

Yeah, we're stuck thinking that we "can't" map the aperture because it's
too large, but with a 64-bit kernel, we should be able to keep it mapped
permanently.

Of course, the io_reserve_pci_resource and io_map_atomic functions could
do precisely that, as kmap_atomic does on non-HIGHMEM systems today.

> The only real API need i see is on 32-bit: with a 1GB or 2GB graphics=20
> aperture we just cannot map that permanently, so kmap_atomic() is a=20
> necessity. We can certainly extend that to non-highmem as well.

Yes, this is where exposing an io-specific atomic mapping function will
remain necessary for some time.

> And if i understood your=20
> workload correctly you want to do tens of thousand of map/unmap/remap=20
> events per frame generated - depending on the type of the 3D app/engine.

Yeah, data transfer from CPU to GPU is through a pwrite interface, and
we perform the transfer within the kernel using map/unmap operations on
the aperture as those are WC and hence do not require clflush.

> Or am i missing something subtle? Why do you want the overhead of kmap=20
> on 64-bit?

We don't, but I think it would be nice to have a common API that works
across all 32-bit configurations as well as 64-bit systems.

--=20
keith.packard@intel.com

--=-ipMZtKK8XAikoekP2bU4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+lpiQp8BWwlsTdMRAquWAKCDszQUKV7Y+6RnMNZcYDkORy0AsgCeNWbR
iNa+sYBm6DFGy7Pf7ma3Czo=
=KPEY
-----END PGP SIGNATURE-----

--=-ipMZtKK8XAikoekP2bU4--

