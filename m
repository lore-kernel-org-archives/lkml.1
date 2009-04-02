Return-Path: <linux-kernel-owner+w=401wt.eu-S935923AbZDBLT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923AbZDBLT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZDBLTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:19:16 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55236 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763082AbZDBLTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:19:14 -0400
Message-ID: <49D49FB6.3000101@novell.com>
Date: Thu, 02 Apr 2009 07:21:26 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_rt: fix overload bug on rt group scheduling
References: <1238604015.8530.3666.camel@twins> <49D40DBF.8030507@novell.com> <1238654901.8530.5373.camel@twins>
In-Reply-To: <1238654901.8530.5373.camel@twins>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0BBED9FBAC05E15BA912EA88"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0BBED9FBAC05E15BA912EA88
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Wed, 2009-04-01 at 20:58 -0400, Gregory Haskins wrote:
>  =20
>> Hi Peter,
>>
>> Peter Zijlstra wrote:
>>    =20
>>> Fixes an easily triggerable BUG() when setting process affinities.
>>>
>>> Make sure to count the number of migratable tasks in the same place:
>>> the root rt_rq. Otherwise the number doesn't make sense and we'll hit=

>>> the BUG in set_cpus_allowed_rt().
>>>
>>> Also, make sure we only count tasks, not groups (this is probably
>>> already taken care of by the fact that rt_se->nr_cpus_allowed will be=
 0
>>> for groups, but be more explicit)
>>>
>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> Tested-by: Thomas Gleixner <tglx@linutronix.de>
>>> CC: stable@kernel.org
>>> ---
>>>  kernel/sched_rt.c |   16 +++++++++++++++-
>>>  1 files changed, 15 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>>> index de4469a..c1ee8dc 100644
>>> --- a/kernel/sched_rt.c
>>> +++ b/kernel/sched_rt.c
>>> @@ -10,6 +10,8 @@ static inline struct task_struct *rt_task_of(struct=
 sched_rt_entity *rt_se)
>>> =20
>>>  #ifdef CONFIG_RT_GROUP_SCHED
>>> =20
>>> +#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
>>> +
>>>  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
>>>  {
>>>  	return rt_rq->rq;
>>> @@ -22,6 +24,8 @@ static inline struct rt_rq *rt_rq_of_se(struct sche=
d_rt_entity *rt_se)
>>> =20
>>>  #else /* CONFIG_RT_GROUP_SCHED */
>>> =20
>>> +#define rt_entity_is_task(rt_se) (1)
>>> +
>>>  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
>>>  {
>>>  	return container_of(rt_rq, struct rq, rt);
>>> @@ -73,7 +77,7 @@ static inline void rt_clear_overload(struct rq *rq)=

>>> =20
>>>  static void update_rt_migration(struct rt_rq *rt_rq)
>>>  {
>>> -	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
>>> +	if (rt_rq->rt_nr_migratory > 1) {
>>>  =20
>>>      =20
>> The rest of the patch is making sense to me, but I am a little concern=
ed
>> about this change.
>>
>> The original logic was designed to catch the condition when you might
>> have a non-migratory task running, and a migratory task queued.   This=

>> would mean nr_running =3D=3D 2, and nr_migratory =3D=3D 1, which is el=
igible for
>> overload handling.  (Of course, the opposite could be true..the
>> migratory is running and the non-migratory is queued...we cannot disce=
rn
>> the difference here and we go into overload anyway.  This is just
>> suboptimal but functionally correct).
>>
>> What can happen now is you could have that above condition but we will=

>> not go into overload unless there is at least two migratory tasks
>> queued.  This will undoubtedly allow a potential scheduling latency on=

>> task #2.
>>
>> I think we really need to qualify overload on both running > 1 and at
>> least one migratory task.  Is there a way to get this state, even if b=
y
>> other means?
>>    =20
>
> Ah, yes, I missed that bit. I ripped out the rt_nr_running because I 1)=

> didn't think of this, and 2) rt_nr_running is accounted per rt_rq, not
> per-cpu, so it doesn't match.
>
> Since rt_nr_running is also used in a per rt_rq setting, changing that
> isn't possible and we'd need to introduce another per-cpu variant is yo=
u
> want to re-instate this.
>  =20
Yeah, I actually don't care if its literally a nr_running stat
reinstated, or some other way to restore "correctness" ;)

Double bonus if you can solve that problem I mentioned above where I
can't tell if its really eligible for overload in all cases (but goes
into overload anyway to be conservative).  I had been thinking of doing
something like subtracting the nr_migration number when a migratory task
is put on the cpu.  But this is kind of messy because you need to handle
all the places that can manipulate nr_migratory to make sure it doesnt
break.

Thanks Peter!
-Greg




--------------enig0BBED9FBAC05E15BA912EA88
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknUn7YACgkQlOSOBdgZUxkHpQCePp7XipTNSnc1h5T4UpSdJZ4g
PZoAn1mHlKZZJY7IBj234YaUA5hDk5GZ
=YOcf
-----END PGP SIGNATURE-----

--------------enig0BBED9FBAC05E15BA912EA88--
