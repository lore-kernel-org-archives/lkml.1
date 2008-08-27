Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYH0MNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYH0MNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYH0MNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:13:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42947 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbYH0MNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:13:04 -0400
Message-ID: <48B54443.3000001@novell.com>
Date: Wed, 27 Aug 2008 08:10:43 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
Subject: Re: [PATCH 3/5] sched: make double-lock-balance fair
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <200808271636.09243.nickpiggin@yahoo.com.au> <48B53D86.8080806@novell.com> <200808272153.32007.nickpiggin@yahoo.com.au>
In-Reply-To: <200808272153.32007.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig53EFEF0AF747B58B8D1A1A42"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig53EFEF0AF747B58B8D1A1A42
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> On Wednesday 27 August 2008 21:41, Gregory Haskins wrote:
>  =20
>> Nick Piggin wrote:
>>    =20
>>> On Tuesday 26 August 2008 22:23, Gregory Haskins wrote:
>>>      =20
>>>> Nick Piggin wrote:
>>>>        =20
>>>>> On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
>>>>>          =20
>>>>>> double_lock balance() currently favors logically lower cpus since =
they
>>>>>> often do not have to release their own lock to acquire a second lo=
ck.
>>>>>> The result is that logically higher cpus can get starved when ther=
e is
>>>>>> a lot of pressure on the RQs.  This can result in higher latencies=
 on
>>>>>> higher cpu-ids.
>>>>>>
>>>>>> This patch makes the algorithm more fair by forcing all paths to h=
ave
>>>>>> to release both locks before acquiring them again.  Since callsite=
s to
>>>>>> double_lock_balance already consider it a potential
>>>>>> preemption/reschedule point, they have the proper logic to recheck=
 for
>>>>>> atomicity violations.
>>>>>>
>>>>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>>>>> ---
>>>>>>
>>>>>>  kernel/sched.c |   17 +++++------------
>>>>>>  1 files changed, 5 insertions(+), 12 deletions(-)
>>>>>>
>>>>>> diff --git a/kernel/sched.c b/kernel/sched.c
>>>>>> index 6e0bde6..b7326cd 100644
>>>>>> --- a/kernel/sched.c
>>>>>> +++ b/kernel/sched.c
>>>>>> @@ -2790,23 +2790,16 @@ static int double_lock_balance(struct rq
>>>>>> *this_rq, struct rq *busiest) __acquires(busiest->lock)
>>>>>>  	__acquires(this_rq->lock)
>>>>>>  {
>>>>>> -	int ret =3D 0;
>>>>>> -
>>>>>>  	if (unlikely(!irqs_disabled())) {
>>>>>>  		/* printk() doesn't work good under rq->lock */
>>>>>>  		spin_unlock(&this_rq->lock);
>>>>>>  		BUG_ON(1);
>>>>>>  	}
>>>>>> -	if (unlikely(!spin_trylock(&busiest->lock))) {
>>>>>> -		if (busiest < this_rq) {
>>>>>> -			spin_unlock(&this_rq->lock);
>>>>>> -			spin_lock(&busiest->lock);
>>>>>> -			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
>>>>>> -			ret =3D 1;
>>>>>> -		} else
>>>>>> -			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
>>>>>> -	}
>>>>>> -	return ret;
>>>>>> +
>>>>>> +	spin_unlock(&this_rq->lock);
>>>>>> +	double_rq_lock(this_rq, busiest);
>>>>>>            =20
>>>>> Rather than adding the extra atomic operation, can't you just put t=
his
>>>>> into the unlikely spin_trylock failure path rather than the unfair
>>>>> logic there?
>>>>>          =20
>>>> The trick is that we *must* first release this_rq before proceeding =
or
>>>> the new proposal doesn't work as intended.  This patch effectively
>>>> breaks up the this_rq->lock critical section evenly across all CPUs =
as
>>>> if it hit the case common for higher cpus.
>>>>        =20
>>> I don't exactly see why my proposal would introduce any more latency,=

>>> because we only trylock while holding the existing lock -- this is wi=
ll
>>> only ever add a small ~constant time to the critical section, regardl=
ess
>>> of whether it is a high or low CPU runqueue.
>>>      =20
>> Its because we are trying to create a break in the critical section of=

>> this_rq->lock, not improve the acquisition of busiest->lock.  So wheth=
er
>> you do spin_lock or spin_trylock on busiest does not matter.  Busiest
>> will not be contended in the case that I am concerned with.  If you us=
e
>> my example below: rq[N] will not be contended because cpuN is blocked =
on
>> rq[0] after already having released rq[N].  So its the contention
>> against this_rq that is the problem.
>>
>> Or am I missing your point completely?
>>    =20
>
> Well my point is just that after my change, there may be some windows
> of "unfair" behaviour where one CPU gets to go ahead early, but AFAIKS
> now there is no systemic bias against higher numbered CPUs (except the
> small issue of taking lowered numbered locks first which is also presen=
t
> in any solution).
>
> As such, I would actually like to see my proposal implemented in the
> !lowlatency case as well... unless my reasoning has a hole in it?
>
> But if you are _also_ wanting to eliminate the long lock hold time and
> strictly improve fairness for lowlatency kernels, then I agree that you=
r
> patch goes much further than mine, so I don't object to putting that
> under CONFIG_PREEMPT.
>  =20

Ok, I understand what you are saying now, and that makes sense.

-Greg


--------------enig53EFEF0AF747B58B8D1A1A42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki1REMACgkQlOSOBdgZUxkq7wCgiR0WYe1fY7jYWc8SgaOCK/E3
YqoAn3xSe/1ocYEgs4VygiwF4L88ChMs
=QnvT
-----END PGP SIGNATURE-----

--------------enig53EFEF0AF747B58B8D1A1A42--
