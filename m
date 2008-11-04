Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYKDOax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYKDOax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYKDOam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:30:42 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:50531 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYKDOal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:30:41 -0500
Message-ID: <49105D84.8070108@novell.com>
Date: Tue, 04 Nov 2008 09:34:44 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com>
In-Reply-To: <490FC735.1070405@novell.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig589C41B31B7BD2E2B5A4BC9D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig589C41B31B7BD2E2B5A4BC9D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Peter Zijlstra wrote:
>  =20
>> On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
>>  =20
>>    =20
>>> When load balancing gets switched off for a set of cpus via the
>>> sched_load_balance flag in cpusets, those cpus wind up with the
>>> globally defined def_root_domain attached.  The def_root_domain is
>>> attached when partition_sched_domains calls detach_destroy_domains().=

>>> A new root_domain is never allocated or attached as a sched domain
>>> will never be attached by __build_sched_domains() for the non-load
>>> balanced processors.
>>>
>>> The problem with this scenario is that on systems with a large number=

>>> of processors with load balancing switched off, we start to see the
>>> cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
>>> This starts to become much more apparent above 8 waking RT threads
>>> (with each RT thread running on it's own cpu, blocking and waking up
>>> continuously).
>>>
>>> I'm wondering if this is, in fact, the way things were meant to work,=

>>> or should we have a root domain allocated for each cpu that is not to=

>>> be part of a sched domain?  Note the the def_root_domain spans all of=

>>> the non-load-balanced cpus in this case.  Having it attached to cpus
>>> that should not be load balancing doesn't quite make sense to me.
>>>    =20
>>>      =20
>> It shouldn't be like that, each load-balance domain (in your case a
>> single cpu) should get its own root domain. Gregory?
>>  =20
>>    =20
>
> Yeah, this sounds broken.  I know that the root-domain code was being
> developed coincident to some upheaval with the cpuset code, so I suspec=
t
> something may have been broken from the original intent.  I will take a=

> look.
>
> -Greg
>
>  =20

After thinking about it some more, I am not quite sure what to do here.=20
The root-domain code was really designed to be 1:1 with a disjoint
cpuset.  In this case, it sounds like all the non-balanced cpus are
still in one default cpuset.  In that case, the code is correct to place
all those cores in the singleton def_root_domain.  The question really
is: How do we support the sched_load_balance flag better?

I suppose we could go through the scheduler code and have it check that
flag before consulting the root-domain.  Another alternative is to have
the sched_load_balance=3Dfalse flag create a disjoint cpuset.  Any though=
ts?

-Greg


--------------enig589C41B31B7BD2E2B5A4BC9D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkQXYQACgkQlOSOBdgZUxl6qACfdfFT1sx/igKf1OvnGsv0fmKZ
v+AAni5aglADw17rkMDpT3px+TsfYtnL
=OCc0
-----END PGP SIGNATURE-----

--------------enig589C41B31B7BD2E2B5A4BC9D--
