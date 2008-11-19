Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYKSUVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYKSUVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYKSUV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:21:29 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49397 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYKSUV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:21:28 -0500
Message-ID: <4924762B.8000108@novell.com>
Date: Wed, 19 Nov 2008 15:25:15 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com>
In-Reply-To: <49246DD0.3010509@qualcomm.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7F5CFF9763A16BE85CB48402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7F5CFF9763A16BE85CB48402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Max Krasnyansky wrote:
> Gregory Haskins wrote:
>  =20
>> If you tried creating different cpusets and it still had them all end =
up
>> in the def_root_domain, something is very broken indeed.  I will take =
a
>> look.
>>    =20
>
> I beleive that's the intended behaviour.
Heh...well, as the guy that wrote root-domans, I can definitively say
that is not the behavior that I personally intended ;)



>  We always put cpus that are not
> balanced into null sched domains. This was done since day one (ie when
> cpuisol=3D option was introduced) and cpusets just followed the same co=
nvention.
>  =20

It sounds like the problem with my code is that "null sched domain"
translates into "default root-domain" which is understandably unexpected
by Dimitri (and myself).  Really I intended root-domains to become
associated with each exclusive/disjoint cpuset that is created.  In a
way, non-balanced/isolated cpus could be modeled as an exclusive cpuset
with one member, but that is somewhat beyond the scope of the
root-domain code as it stands today.  My primary concern was that
Dimitri reports that even creating a disjoint cpuset per cpu does not
yield an isolated root-domain per cpu.  Rather they all end up in the
default root-domain, and this is not what I intended at all.

However, as a secondary goal it would be nice to somehow directly
support the "no-load-balance" option without requiring explicit
exclusive per-cpu cpusets to do it.  The proper mechanism (IMHO) to
scope the scheduler to a subset of cpus (including only "self") is
root-domains so I would prefer to see the solution based on that.=20
However, today there is a rather tight coupling of root-domains and
cpusets, so this coupling would likely have to be relaxed a little bit
to get there.

There are certainly other ways to solve the problem as well.  But seeing
as how I intended root-domains to represent the effective partition
scope of the scheduler, this seems like a natural fit in my mind until
its proven to me otherwise.

Regards,
-Greg



--------------enig7F5CFF9763A16BE85CB48402
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkkdisACgkQlOSOBdgZUxnHVgCgjBwhVi+xIKfesvUlD5H5oquN
cpgAnisFweg1IstIN8b5G8pkh7qBf7Bz
=a6If
-----END PGP SIGNATURE-----

--------------enig7F5CFF9763A16BE85CB48402--
