Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYH0Lob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYH0Lob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYH0LoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:44:22 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53260 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbYH0LoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:44:21 -0400
Message-ID: <48B53D86.8080806@novell.com>
Date: Wed, 27 Aug 2008 07:41:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
Subject: Re: [PATCH 3/5] sched: make double-lock-balance fair
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <200808261614.49662.nickpiggin@yahoo.com.au> <48B3F5AF.9060205@novell.com> <200808271636.09243.nickpiggin@yahoo.com.au>
In-Reply-To: <200808271636.09243.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBE0889CF41D72D5CB49B9765"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE0889CF41D72D5CB49B9765
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> On Tuesday 26 August 2008 22:23, Gregory Haskins wrote:
>  =20
>> Nick Piggin wrote:
>>    =20
>>> On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
>>>      =20
>>>> double_lock balance() currently favors logically lower cpus since th=
ey
>>>> often do not have to release their own lock to acquire a second lock=
=2E
>>>> The result is that logically higher cpus can get starved when there =
is
>>>> a lot of pressure on the RQs.  This can result in higher latencies o=
n
>>>> higher cpu-ids.
>>>>
>>>> This patch makes the algorithm more fair by forcing all paths to hav=
e
>>>> to release both locks before acquiring them again.  Since callsites =
to
>>>> double_lock_balance already consider it a potential
>>>> preemption/reschedule point, they have the proper logic to recheck f=
or
>>>> atomicity violations.
>>>>
>>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>>> ---
>>>>
>>>>  kernel/sched.c |   17 +++++------------
>>>>  1 files changed, 5 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/kernel/sched.c b/kernel/sched.c
>>>> index 6e0bde6..b7326cd 100644
>>>> --- a/kernel/sched.c
>>>> +++ b/kernel/sched.c
>>>> @@ -2790,23 +2790,16 @@ static int double_lock_balance(struct rq
>>>> *this_rq, struct rq *busiest) __acquires(busiest->lock)
>>>>  	__acquires(this_rq->lock)
>>>>  {
>>>> -	int ret =3D 0;
>>>> -
>>>>  	if (unlikely(!irqs_disabled())) {
>>>>  		/* printk() doesn't work good under rq->lock */
>>>>  		spin_unlock(&this_rq->lock);
>>>>  		BUG_ON(1);
>>>>  	}
>>>> -	if (unlikely(!spin_trylock(&busiest->lock))) {
>>>> -		if (busiest < this_rq) {
>>>> -			spin_unlock(&this_rq->lock);
>>>> -			spin_lock(&busiest->lock);
>>>> -			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
>>>> -			ret =3D 1;
>>>> -		} else
>>>> -			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
>>>> -	}
>>>> -	return ret;
>>>> +
>>>> +	spin_unlock(&this_rq->lock);
>>>> +	double_rq_lock(this_rq, busiest);
>>>>        =20
>>> Rather than adding the extra atomic operation, can't you just put thi=
s
>>> into the unlikely spin_trylock failure path rather than the unfair lo=
gic
>>> there?
>>>      =20
>> The trick is that we *must* first release this_rq before proceeding or=

>> the new proposal doesn't work as intended.  This patch effectively
>> breaks up the this_rq->lock critical section evenly across all CPUs as=

>> if it hit the case common for higher cpus.
>>    =20
>
> I don't exactly see why my proposal would introduce any more latency, b=
ecause
> we only trylock while holding the existing lock -- this is will only ev=
er add
> a small ~constant time to the critical section, regardless of whether i=
t is a
> high or low CPU runqueue.
>  =20

Its because we are trying to create a break in the critical section of
this_rq->lock, not improve the acquisition of busiest->lock.  So whether
you do spin_lock or spin_trylock on busiest does not matter.  Busiest
will not be contended in the case that I am concerned with.  If you use
my example below: rq[N] will not be contended because cpuN is blocked on
rq[0] after already having released rq[N].  So its the contention
against this_rq that is the problem.

Or am I missing your point completely?


>
>  =20
>> This modification decreased=20
>> latency by over 800% (went from > 400us to < 50us) on cpus 6 and 7 in =
my
>> 8-way box namely because they were not forced to wait for all the othe=
r
>> lower cores to finish, but rather completions of double_lock_balance
>> were handled in true FIFO w.r.t. to other calls to
>> double_lock_balance().  It has to do with the positioning within your
>> FIFO ticket locks (though even if ticket locks are not present on a
>> given architecture we should still see an improvement.)
>>
>> When a low cpu wants to double lock, it tends to hold this_rq and gets=

>> in line for busiest_rq with no bearing on how long it held this_rq.
>> Therefore the following scenario can occur:
>>
>> cpu 0                     cpu N
>> ----------------------------------
>> rq[0] locked
>> ..
>> ..
>> ..
>>                                double_lock(N, 0)
>>                                rq[N] released
>>                                blocked on rq[0]
>> ..
>> ..
>> ..
>> ..
>> double_lock(0, N)
>> rq[N] locked
>> double_lock returns
>> ..
>> ..
>> ..
>> ..
>> rq[0] released         rq[0] locked
>>                                   double_lock returns
>>                                   ...
>>                                   ...
>>                                   ...
>>
>> ---------------------------------
>>
>> So double lock acquisition favors the lower cpus unfairly.  They will
>> always win, even if they were not first.  Now with the combination of =
my
>> patch plus your ticket locks, entry into the double lock becomes FIFO
>> because the "blocked on rq[0]" would have inserted it in the
>> time-ordered head of rq[0].
>>    =20
>
> Right, but I don't think it is particularly wrong to allow a given
> CPU to double_lock_balance ahead of another guy if we're already holdin=
g
> the lock.

Its not "wrong".  Its just a latency source ;)

>  _So long as_ the lock we are trying to acquire is uncontended,
> and we don't introduce this skewed unfairness due to lower CPUs being
> allowed to hold their lower lock while higher CPUs have to release thei=
r
> lock and first queue on the lower.
>
> The difference is that with my patch, there is a small window where the=

> guy who asks for the double lock first will go through second. I don't
> think this really adds a fundamental amount of latency, and the
> performance benefit should not be ignored.
>
> Linux's traditional and I suppose much largest user base does not requi=
re
> realtime or really strict fairness, so IMO it is always questionable to=

> make changes like this.
>  =20
Please take a look at the v2 series that I sent out yesterday.  I have
now predicated this on CONFIG_PREEMPT, per your comments.

-Greg


--------------enigBE0889CF41D72D5CB49B9765
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki1PYYACgkQlOSOBdgZUxmAhwCdFtJjI6UlC4ul6SSNJOJaOPJe
vw8An3RvhjsJAURJLdli5RHMQvDpt52k
=nbW6
-----END PGP SIGNATURE-----

--------------enigBE0889CF41D72D5CB49B9765--
