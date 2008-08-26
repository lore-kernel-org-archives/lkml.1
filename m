Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYHZMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYHZMZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYHZMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:25:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34576 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYHZMZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:25:39 -0400
Message-ID: <48B3F5AF.9060205@novell.com>
Date: Tue, 26 Aug 2008 08:23:11 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
Subject: Re: [PATCH 3/5] sched: make double-lock-balance fair
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <20080825201534.23217.14936.stgit@dev.haskins.net> <200808261614.49662.nickpiggin@yahoo.com.au>
In-Reply-To: <200808261614.49662.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig70220B40011E425C7E38E5BA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig70220B40011E425C7E38E5BA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
>  =20
>> double_lock balance() currently favors logically lower cpus since they=

>> often do not have to release their own lock to acquire a second lock.
>> The result is that logically higher cpus can get starved when there is=

>> a lot of pressure on the RQs.  This can result in higher latencies on
>> higher cpu-ids.
>>
>> This patch makes the algorithm more fair by forcing all paths to have
>> to release both locks before acquiring them again.  Since callsites to=

>> double_lock_balance already consider it a potential preemption/resched=
ule
>> point, they have the proper logic to recheck for atomicity violations.=

>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  kernel/sched.c |   17 +++++------------
>>  1 files changed, 5 insertions(+), 12 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 6e0bde6..b7326cd 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2790,23 +2790,16 @@ static int double_lock_balance(struct rq *this=
_rq,
>> struct rq *busiest) __acquires(busiest->lock)
>>  	__acquires(this_rq->lock)
>>  {
>> -	int ret =3D 0;
>> -
>>  	if (unlikely(!irqs_disabled())) {
>>  		/* printk() doesn't work good under rq->lock */
>>  		spin_unlock(&this_rq->lock);
>>  		BUG_ON(1);
>>  	}
>> -	if (unlikely(!spin_trylock(&busiest->lock))) {
>> -		if (busiest < this_rq) {
>> -			spin_unlock(&this_rq->lock);
>> -			spin_lock(&busiest->lock);
>> -			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
>> -			ret =3D 1;
>> -		} else
>> -			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
>> -	}
>> -	return ret;
>> +
>> +	spin_unlock(&this_rq->lock);
>> +	double_rq_lock(this_rq, busiest);
>>    =20
>
> Rather than adding the extra atomic operation, can't you just put this
> into the unlikely spin_trylock failure path rather than the unfair logi=
c
> there?
>  =20

The trick is that we *must* first release this_rq before proceeding or
the new proposal doesn't work as intended.  This patch effectively
breaks up the this_rq->lock critical section evenly across all CPUs as
if it hit the case common for higher cpus.  This modification decreased
latency by over 800% (went from > 400us to < 50us) on cpus 6 and 7 in my
8-way box namely because they were not forced to wait for all the other
lower cores to finish, but rather completions of double_lock_balance
were handled in true FIFO w.r.t. to other calls to
double_lock_balance().  It has to do with the positioning within your
FIFO ticket locks (though even if ticket locks are not present on a
given architecture we should still see an improvement.)

When a low cpu wants to double lock, it tends to hold this_rq and gets
in line for busiest_rq with no bearing on how long it held this_rq.=20
Therefore the following scenario can occur:

cpu 0                     cpu N
----------------------------------
rq[0] locked
=2E.
=2E.
=2E.
                               double_lock(N, 0)
                               rq[N] released
                               blocked on rq[0]
=2E.
=2E.
=2E.
=2E.
double_lock(0, N)
rq[N] locked
double_lock returns
=2E.
=2E.
=2E.
=2E.
rq[0] released         rq[0] locked
                                  double_lock returns
                                  ...
                                  ...
                                  ...

---------------------------------

So double lock acquisition favors the lower cpus unfairly.  They will
always win, even if they were not first.  Now with the combination of my
patch plus your ticket locks, entry into the double lock becomes FIFO
because the "blocked on rq[0]" would have inserted it in the
time-ordered head of rq[0].  The later call to double_lock(0, N)
performed by cpu0 would be forced to queue up behind cpuN trying to
reacquire its own lock.

Effectively, double_lock_balance becomes as fair as the underlying
spinlock governing the RQ.  If we have ticket locks, double_lock_balance
is FIFO.  Lack of ticket locks means we have arbitrary fairness.  And
lack of this patch means we have favor for the lower cpus.

To your point about the extra atomic ops:  Perhaps I should predicate
this change on CONFIG_PREEMPT so as to not slow down mainline where
throughput is more valued.

> FWIW, this is always going to be a *tiny* bit unfair, because of double=

> rq lock taking the lower lock first.

While this is technically true, I am not as concerned about the fairness
while acquiring the locks. =20



--------------enig70220B40011E425C7E38E5BA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiz9a8ACgkQlOSOBdgZUxlLNwCeJax0KSr5XSACXUmBL4k8LZ9U
OisAnjYHnUsf3lEXvci8v14uk/zrA8fw
=taVv
-----END PGP SIGNATURE-----

--------------enig70220B40011E425C7E38E5BA--
