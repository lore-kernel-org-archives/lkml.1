Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYJaQ7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYJaQ7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYJaQ7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:59:38 -0400
Received: from home.keithp.com ([63.227.221.253]:43508 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbYJaQ7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:59:37 -0400
Subject: Re: [PATCH] Add io-mapping functions to dynamically map large
	device apertures
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081031092125.GC14127@elte.hu>
References: <1225392985-6832-1-git-send-email-eric@anholt.net>
	 <1225392985-6832-2-git-send-email-eric@anholt.net>
	 <20081031092125.GC14127@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pFA0zaySzDBYGjviTbxg"
Date: Fri, 31 Oct 2008 09:59:29 -0700
Message-Id: <1225472369.10543.27.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pFA0zaySzDBYGjviTbxg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 10:21 +0100, Ingo Molnar wrote:

> it's ugly and inflexible to put x86 dependencies into generic headers.=20
> (even though with a high likelyhood 32-bit x86 will be the only arch=20
> to ever implement the iomap_atomic() APIs)
>=20
> Instead please add a HAVE_ATOMIC_IOMAP define to arch/x86/Kconfig:
>=20
>  config HAVE_ATOMIC_IOMAP
>          def_bool y
>          depends on X86_32
>=20
> ... and use #ifndef HAVE_ATOMIC_IOMAP in include/linux/io-mapping.h=20
> instead of #ifdef CONFIG_X86_64.

Just to clarify the issue here: there are two separate implementations
of the io_mapping API -- one for 'large address space' machines where
ioremap_wc can handle the typical graphics aperture within the kernel
virtual map, and the other using iomap_atomic_prot_pfn for machines with
puny address spaces.

All large address space machines can provide the io_mapping API without
any archtecture-specific support. For efficient 32-bit io_mapping
support, we require the new iomap_atomic_prot_pfn function.

So, it seems like what I want to do is use the large address space code
on any machine which supports it, and then use the iomap_atomic_prot_pfn
version for small address space machines which have the
iomap_atomic_prot_pfn function.

What I think you're suggesting is to just assume that machines without
iomap_atomic_prot_pfn have address spaces large enough to support the
ioremap_wc path. The alternative is to create a third (slow) path (which
I did before the iomap_atomic_prot_pfn API was introduced) that uses
ioremap_wc at run time for small address space machines without
iomap_atomic_prot_pfn.

Let me know which you'd prefer and I'll get a patch out ASAP.

--=20
keith.packard@intel.com

--=-pFA0zaySzDBYGjviTbxg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJCzlxQp8BWwlsTdMRArB+AKCL846YX33OTFM8OX4swXaZZJrJlgCgu85r
s19cgbwNPRHKyUMezx6V8HU=
=F+ny
-----END PGP SIGNATURE-----

--=-pFA0zaySzDBYGjviTbxg--

