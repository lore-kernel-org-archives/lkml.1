Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYHNL1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYHNL1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYHNL06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:26:58 -0400
Received: from ozlabs.org ([203.10.76.45]:58786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYHNL06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:26:58 -0400
Subject: Re: bug in lmb_enforce_memory_limit()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080814.012004.193702132.davem@davemloft.net>
References: <20080814.012004.193702132.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aLS6oDwPpRamzVL68u51"
Date: Thu, 14 Aug 2008 21:26:53 +1000
Message-Id: <1218713213.10673.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aLS6oDwPpRamzVL68u51
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-14 at 01:20 -0700, David Miller wrote:
> I just mentioned this to Ben H. on IRC and promised I would report it
> here. :-)
>=20
> The first loop over lmb.memory in this function interprets the
> memory_limit as a raw size limit, and that's fine so far.
>=20
> But the second loop over lmb.reserved interprets this value
> instead as an "address limit."
>
> I haven't cobbled together a fix myself, but probably the way to do
> this is, when we're about break out of the first loop over lmb.memory,
> walk through the now-trimmed memory blobs and trim those from
> lmb.reserved, one by one.

Perhaps after the first loop we should set memory_limit to equal
lmb_end_of_DRAM(), then the second loop should work as it is.

I think that actually makes memory_limit (the variable) more useful, and
avoids more code like we have in numa_enforce_memory_limit(), which
doesn't use memory_limit exactly because it isn't the value we're
actually interested in (because of holes).


> This bug got introduced by:
>=20
>    commit 2babf5c2ec2f2d5de3e38d20f7df7fd815fd10c9
>    Author: Michael Ellerman <michael@ellerman.id.au>
>    Date:   Wed May 17 18:00:46 2006 +1000
>=20
>        [PATCH] powerpc: Unify mem=3D handling
>=20
> back when LMB was still a powerpc local item. :-)

Guilty as charged. I have some tests for that code, but clearly not
enough - and it gets very little exercise otherwise.

> This led me to another bug which probably a lot of platforms are
> effected by.
>=20
> If you do this command line memory limiting, and the kernel was placed
> by the boot loader into physical ram (say at the end of the available
> physical memory) that gets trimmed out by the command line option, we
> hang or crash right as we boot into userspace because freeing up
> initmem ends up freeing invalid page structs.
>=20
> I think, on sparc64, instead of adding all kinds of complicated logic
> to free_initmem() I'm simply going to only poison the pages and
> not free them at all if cmdline_memory_size has been set.

Would it be that much extra logic to check that the address is less than
the limit? Especially if we changed memory_limit to incorporate holes.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-aLS6oDwPpRamzVL68u51
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIpBZ9dSjSd0sB4dIRAmuRAJ9j/YhApVRVEiB7zL3v7C0ZC7NcbACdE7NW
ITwV6zwMMX+z1HseQ2KIsJ0=
=X0Dr
-----END PGP SIGNATURE-----

--=-aLS6oDwPpRamzVL68u51--

