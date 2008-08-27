Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYH0MFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYH0MFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYH0ME4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:04:56 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57484 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYH0MEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:04:55 -0400
Message-ID: <48B54251.5040408@novell.com>
Date: Wed, 27 Aug 2008 08:02:25 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, srostedt@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
References: <20080826173131.16413.17862.stgit@dev.haskins.net>	 <20080826173500.16413.40514.stgit@dev.haskins.net> <1219825295.6462.54.camel@twins>
In-Reply-To: <1219825295.6462.54.camel@twins>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE44FCC5FB60858AB9446658F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE44FCC5FB60858AB9446658F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Tue, 2008-08-26 at 13:35 -0400, Gregory Haskins wrote:
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
>>  kernel/sched.c |   52 +++++++++++++++++++++++++++++++++++++++++++++--=
-----
>>  1 files changed, 45 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index df6b447..850b454 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2782,21 +2782,43 @@ static void double_rq_unlock(struct rq *rq1, s=
truct rq *rq2)
>>  		__release(rq2->lock);
>>  }
>> =20
>> +#ifdef CONFIG_PREEMPT
>> +
>>  /*
>> - * double_lock_balance - lock the busiest runqueue, this_rq is locked=
 already.
>> + * fair double_lock_balance: Safely acquires both rq->locks in a fair=

>> + * way at the expense of forcing extra atomic operations in all
>> + * invocations.  This assures that the double_lock is acquired using =
the
>> + * same underlying policy as the spinlock_t on this architecture, whi=
ch
>> + * reduces latency compared to the unfair variant below.  However, it=

>> + * also adds more overhead and therefore may reduce throughput.
>>   */
>> -static int double_lock_balance(struct rq *this_rq, struct rq *busiest=
)
>> +static inline int _double_lock_balance(struct rq *this_rq, struct rq =
*busiest)
>> +	__releases(this_rq->lock)
>> +	__acquires(busiest->lock)
>> +	__acquires(this_rq->lock)
>> +{
>> +	spin_unlock(&this_rq->lock);
>> +	double_rq_lock(this_rq, busiest);
>> +
>> +	return 1;
>> +}
>>    =20
>
> Right - so to belabour Nick's point:
>
>   if (!spin_trylock(&busiest->lock)) {
>     spin_unlock(&this_rq->lock);
>     double_rq_lock(this_rq, busiest);
>   }
>
> might unfairly treat someone who is waiting on this_rq if I understand
> it right?
>
> I suppose one could then write it like:
>
>   if (spin_is_contended(&this_rq->lock) || !spin_trylock(&busiest->lock=
)) {
>     spin_unlock(&this_rq->lock);
>     double_rq_lock(this_rq, busiest);
>   }
>  =20

Indeed.  This does get to the heart of the problem: contention against
this_rq->lock.

> But, I'm not sure that's worth the effort at that point..
>
> Anyway - I think all this is utterly defeated on CONFIG_PREEMPT by the
> spin with IRQs enabled logic in kernel/spinlock.c.
>  =20

I submitted some patches related to this a while back.  The gist of it
is that the presence of ticketlocks for a given config *should* defeat
the preemptible version of the generic spinlocks or there is no point.=20
Let me see if I can dig it up.

-Greg



--------------enigE44FCC5FB60858AB9446658F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki1QlIACgkQlOSOBdgZUxnSDgCfb4347EcaaxNwsCqp0bNnQ/8H
0UEAnRWtU4ZCzmp+6KxvEyhjUlBPxynF
=jgIW
-----END PGP SIGNATURE-----

--------------enigE44FCC5FB60858AB9446658F--
