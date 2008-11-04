Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYKDDtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYKDDtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 22:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYKDDtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 22:49:23 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:34734 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYKDDtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 22:49:22 -0500
Message-ID: <490FC735.1070405@novell.com>
Date: Mon, 03 Nov 2008 22:53:25 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins>
In-Reply-To: <1225751603.7803.1640.camel@twins>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE48413D46071B3255D1178AA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE48413D46071B3255D1178AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
>  =20
>> When load balancing gets switched off for a set of cpus via the
>> sched_load_balance flag in cpusets, those cpus wind up with the
>> globally defined def_root_domain attached.  The def_root_domain is
>> attached when partition_sched_domains calls detach_destroy_domains().
>> A new root_domain is never allocated or attached as a sched domain
>> will never be attached by __build_sched_domains() for the non-load
>> balanced processors.
>>
>> The problem with this scenario is that on systems with a large number
>> of processors with load balancing switched off, we start to see the
>> cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
>> This starts to become much more apparent above 8 waking RT threads
>> (with each RT thread running on it's own cpu, blocking and waking up
>> continuously).
>>
>> I'm wondering if this is, in fact, the way things were meant to work,
>> or should we have a root domain allocated for each cpu that is not to
>> be part of a sched domain?  Note the the def_root_domain spans all of
>> the non-load-balanced cpus in this case.  Having it attached to cpus
>> that should not be load balancing doesn't quite make sense to me.
>>    =20
>
> It shouldn't be like that, each load-balance domain (in your case a
> single cpu) should get its own root domain. Gregory?
>  =20

Yeah, this sounds broken.  I know that the root-domain code was being
developed coincident to some upheaval with the cpuset code, so I suspect
something may have been broken from the original intent.  I will take a
look.

-Greg

>  =20
>> Here's where we've often seen this lock contention occur:
>>    =20
>
> what's this horrible output from?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>  =20



--------------enigE48413D46071B3255D1178AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkPxzUACgkQlOSOBdgZUxlavwCfRjRfXXOvf++JGTtau9Ygc1UD
k2oAnizpc8fr6oxcgdVBbpjj//tk90g5
=sSiT
-----END PGP SIGNATURE-----

--------------enigE48413D46071B3255D1178AA--
