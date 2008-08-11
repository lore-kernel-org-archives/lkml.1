Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYHKNOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYHKNOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYHKNN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:13:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34449 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYHKNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:13:58 -0400
Message-ID: <48A03A8D.2050502@novell.com>
Date: Mon, 11 Aug 2008 09:11:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: mingo@elte.hu
CC: Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, dmitry.adamushko@gmail.com,
       torvalds@linux-foundation.org, pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug,	sched:Introduce	cpu_active_map	and	redoscheddomainmanagment
 (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com> <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com> <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com> <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com> <487F6972.BA47.005A.0@novell.com> <1216382024.28405.26.camel@twins> <488052D5.BA47.005A.0@novell.com> <48856BA9.6050609@qualcomm.com> <4885E952.8020708@novell.com>
In-Reply-To: <4885E952.8020708@novell.com>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB425336D945B671D5DE6A128"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB425336D945B671D5DE6A128
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Ingo,
  Here is another patch submitted that has not been acked/nacked yet. =20
If you get a free moment, please let me know your thoughts.  Here is the =

full thread for your convenience:

http://lkml.org/lkml/2008/7/22/281

(and FYI it was ACKed by Peter here: http://lkml.org/lkml/2008/7/22/286)

-Greg

Gregory Haskins wrote:
> Max Krasnyansky wrote:
>> Greg, correct me if I'm wrong but we seem to have exact same issue=20
>> with the
>> rq->rq->online map. Lets take "cpu going down" for example. We're=20
>> clearing
>> rq->rd->online bit on DYING event, but nothing AFAICS prevents=20
>> another cpu
>> calling rebuild_sched_domains()->partition_sched_domains() in the=20
>> middle of
>> the hotplug sequence.
>> partition_sched_domains() will happily reset rd->rq->online mask and=20
>> things
>> will fail. I'm talking about this path
>>
>> __build_sched_domains() -> cpu_attach_domain() -> rq_attach_root()
>>     ...
>>     cpu_set(rq->cpu, rd->span);
>>     if (cpu_isset(rq->cpu, cpu_online_map))
>>         set_rq_online(rq);
>>     ...
>>
>>  =20
>
> I think you are right, but wouldn't s/online/active above fix that as=20
> well?  The active_map didnt exist at the time that code went in=20
> initially ;)
>
>> --=20
>>
>> btw Why didn't we convert sched*.c to use rq->rd->online when it was
>> introduced ? ie Instead of using cpu_online_map directly.
>>  =20
> I think things were converted where they made sense to convert.  But=20
> we also had a different goal at that time, so perhaps something was=20
> missed.  If you think something else should be converted, please point =

> it out.
>
> In the meantime, I would suggest we consider this patch on top of=20
> yours (applies to tip/sched/devel):
>
> ----------------------
>
> sched: Fully integrate cpus_active_map and root-domain code
>   Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 62b1b8e..99ba70d 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6611,7 +6611,7 @@ static void rq_attach_root(struct rq *rq, struct =

> root_domain *rd)
>     rq->rd =3D rd;
>
>     cpu_set(rq->cpu, rd->span);
> -    if (cpu_isset(rq->cpu, cpu_online_map))
> +    if (cpu_isset(rq->cpu, cpu_active_map))
>         set_rq_online(rq);
>
>     spin_unlock_irqrestore(&rq->lock, flags);
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 7f70026..2bae8de 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1004,7 +1004,7 @@ static void yield_task_fair(struct rq *rq)
>  * search starts with cpus closest then further out as needed,
>  * so we always favor a closer, idle cpu.
>  * Domains may include CPUs that are not usable for migration,
> - * hence we need to mask them out (cpu_active_map)
> + * hence we need to mask them out (rq->rd->online)
>  *
>  * Returns the CPU we should wake onto.
>  */
> @@ -1032,7 +1032,7 @@ static int wake_idle(int cpu, struct task_struct =

> *p)
>             || ((sd->flags & SD_WAKE_IDLE_FAR)
>             && !task_hot(p, task_rq(p)->clock, sd))) {
>             cpus_and(tmp, sd->span, p->cpus_allowed);
> -            cpus_and(tmp, tmp, cpu_active_map);
> +            cpus_and(tmp, tmp, task_rq(p)->rd->online);
>             for_each_cpu_mask(i, tmp) {
>                 if (idle_cpu(i)) {
>                     if (i !=3D task_cpu(p)) {
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 24621ce..d93169d 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -936,13 +936,6 @@ static int find_lowest_rq(struct task_struct *task=
)
>         return -1; /* No targets found */
>
>     /*
> -     * Only consider CPUs that are usable for migration.
> -     * I guess we might want to change cpupri_find() to ignore those
> -     * in the first place.
> -     */
> -    cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
> -
> -    /*
>      * At this point we have built a mask of cpus representing the
>      * lowest priority tasks in the system.  Now we want to elect
>      * the best one based on our affinity and topology.
>
> --------------
>
> Regards,
> -Greg
>



--------------enigB425336D945B671D5DE6A128
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkigOo0ACgkQlOSOBdgZUxmY+ACeI9BojR+IKsJYQUnwIP33x6TX
b8EAoIxcVfFEhAmb1pztBjNJAf9MN0eX
=qdGJ
-----END PGP SIGNATURE-----

--------------enigB425336D945B671D5DE6A128--
