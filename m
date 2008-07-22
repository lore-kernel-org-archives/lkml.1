Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYGVOUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYGVOUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYGVOTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:19:53 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50809 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYGVOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:19:52 -0400
Message-ID: <4885EC11.2050906@novell.com>
Date: Tue, 22 Jul 2008 10:17:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Max Krasnyansky <maxk@qualcomm.com>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu	hotplug,	sched:Introduce	cpu_active_map	and	redoscheddomainmanagment
 (take	2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>	 <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com>	 <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com>	 <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com>	 <487F6972.BA47.005A.0@novell.com> <1216382024.28405.26.camel@twins>	 <488052D5.BA47.005A.0@novell.com> <48856BA9.6050609@qualcomm.com>	 <4885E952.8020708@novell.com> <1216736160.7257.97.camel@twins>
In-Reply-To: <1216736160.7257.97.camel@twins>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig875E24E0E1081C2B52BADDBA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig875E24E0E1081C2B52BADDBA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Tue, 2008-07-22 at 10:06 -0400, Gregory Haskins wrote:
>  =20
>> Max Krasnyansky wrote:
>>    =20
>>> Greg, correct me if I'm wrong but we seem to have exact same issue wi=
th the
>>> rq->rq->online map. Lets take "cpu going down" for example. We're cle=
aring
>>> rq->rd->online bit on DYING event, but nothing AFAICS prevents anothe=
r cpu
>>> calling rebuild_sched_domains()->partition_sched_domains() in the mid=
dle of
>>> the hotplug sequence.
>>> partition_sched_domains() will happily reset rd->rq->online mask and =
things
>>> will fail. I'm talking about this path
>>>
>>> __build_sched_domains() -> cpu_attach_domain() -> rq_attach_root()
>>> 	...
>>> 	cpu_set(rq->cpu, rd->span);
>>> 	if (cpu_isset(rq->cpu, cpu_online_map))
>>> 		set_rq_online(rq);
>>> 	...
>>>
>>>  =20
>>>      =20
>> I think you are right, but wouldn't s/online/active above fix that as =

>> well?  The active_map didnt exist at the time that code went in initia=
lly ;)
>>
>>    =20
>>> --
>>>
>>> btw Why didn't we convert sched*.c to use rq->rd->online when it was
>>> introduced ? ie Instead of using cpu_online_map directly.
>>>  =20
>>>      =20
>> I think things were converted where they made sense to convert.  But w=
e=20
>> also had a different goal at that time, so perhaps something was=20
>> missed.  If you think something else should be converted, please point=
=20
>> it out.
>>
>> In the meantime, I would suggest we consider this patch on top of your=
s=20
>> (applies to tip/sched/devel):
>>
>> ----------------------
>>
>> sched: Fully integrate cpus_active_map and root-domain code
>>   =20
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>    =20
>
>
> Right, makes sense.
>
> ACK
>  =20

Thanks Peter.

BTW: I should mention that this was just an RFC.  I haven't even build=20
tested it yet.  I will do this now.

Regards,
-Greg
>  =20
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 62b1b8e..99ba70d 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -6611,7 +6611,7 @@ static void rq_attach_root(struct rq *rq, struct=
=20
>> root_domain *rd)
>>      rq->rd =3D rd;
>> =20
>>      cpu_set(rq->cpu, rd->span);
>> -    if (cpu_isset(rq->cpu, cpu_online_map))
>> +    if (cpu_isset(rq->cpu, cpu_active_map))
>>          set_rq_online(rq);
>> =20
>>      spin_unlock_irqrestore(&rq->lock, flags);
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 7f70026..2bae8de 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1004,7 +1004,7 @@ static void yield_task_fair(struct rq *rq)
>>   * search starts with cpus closest then further out as needed,
>>   * so we always favor a closer, idle cpu.
>>   * Domains may include CPUs that are not usable for migration,
>> - * hence we need to mask them out (cpu_active_map)
>> + * hence we need to mask them out (rq->rd->online)
>>   *
>>   * Returns the CPU we should wake onto.
>>   */
>> @@ -1032,7 +1032,7 @@ static int wake_idle(int cpu, struct task_struct=
 *p)
>>              || ((sd->flags & SD_WAKE_IDLE_FAR)
>>              && !task_hot(p, task_rq(p)->clock, sd))) {
>>              cpus_and(tmp, sd->span, p->cpus_allowed);
>> -            cpus_and(tmp, tmp, cpu_active_map);
>> +            cpus_and(tmp, tmp, task_rq(p)->rd->online);
>>              for_each_cpu_mask(i, tmp) {
>>                  if (idle_cpu(i)) {
>>                      if (i !=3D task_cpu(p)) {
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index 24621ce..d93169d 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -936,13 +936,6 @@ static int find_lowest_rq(struct task_struct *tas=
k)
>>          return -1; /* No targets found */
>> =20
>>      /*
>> -     * Only consider CPUs that are usable for migration.
>> -     * I guess we might want to change cpupri_find() to ignore those
>> -     * in the first place.
>> -     */
>> -    cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
>> -
>> -    /*
>>       * At this point we have built a mask of cpus representing the
>>       * lowest priority tasks in the system.  Now we want to elect
>>       * the best one based on our affinity and topology.
>>
>> --------------
>>
>> Regards,
>> -Greg
>>
>>    =20
>
>  =20



--------------enig875E24E0E1081C2B52BADDBA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiF7BEACgkQlOSOBdgZUxn4PgCfT9SGhXOozHI2U8onlvkqTx08
JtoAnjI7+RDEomJ4z16AVNdSiJCxRhrC
=L3n2
-----END PGP SIGNATURE-----

--------------enig875E24E0E1081C2B52BADDBA--
