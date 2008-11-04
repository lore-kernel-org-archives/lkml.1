Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYKDO6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYKDO6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYKDOz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:55:26 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:51916 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbYKDOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:55:24 -0500
Message-ID: <4910634C.1020207@novell.com>
Date: Tue, 04 Nov 2008 09:59:24 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com>
In-Reply-To: <20081104144017.GB30855@sgi.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB4EB07801CDB3C3D7394D9B5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB4EB07801CDB3C3D7394D9B5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dimitri Sivanich wrote:
> On Tue, Nov 04, 2008 at 03:36:33PM +0100, Peter Zijlstra wrote:
>  =20
>> On Tue, 2008-11-04 at 09:34 -0500, Gregory Haskins wrote:
>>    =20
>>> Gregory Haskins wrote:
>>>      =20
>>>> Peter Zijlstra wrote:
>>>>  =20
>>>>        =20
>>>>> On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
>>>>>  =20
>>>>>    =20
>>>>>          =20
>>>>>> When load balancing gets switched off for a set of cpus via the
>>>>>> sched_load_balance flag in cpusets, those cpus wind up with the
>>>>>> globally defined def_root_domain attached.  The def_root_domain is=

>>>>>> attached when partition_sched_domains calls detach_destroy_domains=
().
>>>>>> A new root_domain is never allocated or attached as a sched domain=

>>>>>> will never be attached by __build_sched_domains() for the non-load=

>>>>>> balanced processors.
>>>>>>
>>>>>> The problem with this scenario is that on systems with a large num=
ber
>>>>>> of processors with load balancing switched off, we start to see th=
e
>>>>>> cpupri->pri_to_cpu->lock in the def_root_domain becoming contended=
=2E
>>>>>> This starts to become much more apparent above 8 waking RT threads=

>>>>>> (with each RT thread running on it's own cpu, blocking and waking =
up
>>>>>> continuously).
>>>>>>
>>>>>> I'm wondering if this is, in fact, the way things were meant to wo=
rk,
>>>>>> or should we have a root domain allocated for each cpu that is not=
 to
>>>>>> be part of a sched domain?  Note the the def_root_domain spans all=
 of
>>>>>> the non-load-balanced cpus in this case.  Having it attached to cp=
us
>>>>>> that should not be load balancing doesn't quite make sense to me.
>>>>>>    =20
>>>>>>      =20
>>>>>>            =20
>>>>> It shouldn't be like that, each load-balance domain (in your case a=

>>>>> single cpu) should get its own root domain. Gregory?
>>>>>  =20
>>>>>    =20
>>>>>          =20
>>>> Yeah, this sounds broken.  I know that the root-domain code was bein=
g
>>>> developed coincident to some upheaval with the cpuset code, so I sus=
pect
>>>> something may have been broken from the original intent.  I will tak=
e a
>>>> look.
>>>>
>>>> -Greg
>>>>
>>>>  =20
>>>>        =20
>>> After thinking about it some more, I am not quite sure what to do her=
e.=20
>>> The root-domain code was really designed to be 1:1 with a disjoint
>>> cpuset.  In this case, it sounds like all the non-balanced cpus are
>>> still in one default cpuset.  In that case, the code is correct to pl=
ace
>>> all those cores in the singleton def_root_domain.  The question reall=
y
>>> is: How do we support the sched_load_balance flag better?
>>>
>>> I suppose we could go through the scheduler code and have it check th=
at
>>> flag before consulting the root-domain.  Another alternative is to ha=
ve
>>> the sched_load_balance=3Dfalse flag create a disjoint cpuset.  Any th=
oughts?
>>>      =20
>> Hmm, but you cannot disable load-balance on a cpu without placing it i=
n
>> an cpuset first, right?
>>
>> Or are folks disabling load-balance bottom-up, instead of top-down?
>>
>> In that case, I think we should dis-allow that.
>>    =20
>
> When I see this behavior, I am creating cpusets containing these non lo=
ad balancing cpus.  Whether I create a single cpuset for each one, or one=
 cpuset for all of them, the root domain ends up being the def_root_domai=
n with no sched domain attached once I set both the root cpuset and creat=
ed cpuset's sched_load_balance flags to 0.
>
>  =20

If you tried creating different cpusets and it still had them all end up
in the def_root_domain, something is very broken indeed.  I will take a
look.

-Greg




--------------enigB4EB07801CDB3C3D7394D9B5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkQY0wACgkQlOSOBdgZUxn6eACeJOMxC1jBXb9AwOX5a8hyXHTE
t0EAn3/WoO2GBJo2Qq89FxvPqOWdedOa
=jE8q
-----END PGP SIGNATURE-----

--------------enigB4EB07801CDB3C3D7394D9B5--
