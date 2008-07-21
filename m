Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYGUWIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYGUWIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYGUWI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:08:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52209 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYGUWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:08:25 -0400
Message-ID: <48850860.3030402@novell.com>
Date: Mon, 21 Jul 2008 18:06:24 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users@vger.kernel.org, rostedt@goodmis.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sched: remove extraneous load manipulations
References: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>	 <20080703213711.1275.56107.stgit@lsg.lsg.lab.novell.com> <1216384754.28405.31.camel@twins>
In-Reply-To: <1216384754.28405.31.camel@twins>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig970FE799E19270BD83C409C9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig970FE799E19270BD83C409C9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Thu, 2008-07-03 at 15:37 -0600, Gregory Haskins wrote:
>  =20
>> commit 62fb185130e4d420f71a30ff59d8b16b74ef5d2b reverted some patches
>> in the scheduler, but it looks like it may have left a few redundant
>> calls to inc_load/dec_load remain in set_user_nice (since the
>>  dequeue_task/enqueue_task take care of the load.  This could result
>> in the load values being off since the load may change while dequeued.=

>>    =20
>
> I just checked out v2.6.25.10 but cannot see dequeue_task() do it.
>  =20

Indeed.  I think my eyes glazed over the dequeue vs deactivate, and=20
enqueue vs activate.   Good catch, and sorry for the noise.  I was wrong.=
=2E

Please ignore this patch.

-Greg


> deactivate_task() otoh does do it.
>
> static void dequeue_task(struct rq *rq, struct task_struct *p, int slee=
p)
> {
> 	p->sched_class->dequeue_task(rq, p, sleep);
> 	p->se.on_rq =3D 0;
> }
>
> vs
>
> static void deactivate_task(struct rq *rq, struct task_struct *p, int s=
leep)
> {
> 	if (task_contributes_to_load(p))
> 		rq->nr_uninterruptible++;
>
> 	dequeue_task(rq, p, sleep);
> 	dec_nr_running(p, rq);
> }
>
> where
>
> static void dec_nr_running(struct task_struct *p, struct rq *rq)
> {
> 	rq->nr_running--;
> 	dec_load(rq, p);
> }
>
> And since set_user_nice() actually changes the load we'd better not
> forget to do this dec/inc load stuff.
>
> So I'm thinking this patch would actually break stuff.
>
>  =20
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Ingo Molnar <mingo@elte.hu>
>> ---
>>
>>  kernel/sched.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 31f91d9..b046754 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -4679,10 +4679,8 @@ void set_user_nice(struct task_struct *p, long =
nice)
>>  		goto out_unlock;
>>  	}
>>  	on_rq =3D p->se.on_rq;
>> -	if (on_rq) {
>> +	if (on_rq)
>>  		dequeue_task(rq, p, 0);
>> -		dec_load(rq, p);
>> -	}
>> =20
>>  	p->static_prio =3D NICE_TO_PRIO(nice);
>>  	set_load_weight(p);
>> @@ -4692,7 +4690,7 @@ void set_user_nice(struct task_struct *p, long n=
ice)
>> =20
>>  	if (on_rq) {
>>  		enqueue_task(rq, p, 0);
>> -		inc_load(rq, p);
>> +
>>  		/*
>>  		 * If the task increased its priority or is running and
>>  		 * lowered its priority, then reschedule its CPU:
>>
>>    =20
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-user=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig970FE799E19270BD83C409C9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiFCGAACgkQlOSOBdgZUxmGGACfTSs8tE2wCfg+tXO/LfnQp7FJ
3+gAn39DUzcZ6Pm1BoRqoQVbalKY6vd8
=Ivmp
-----END PGP SIGNATURE-----

--------------enig970FE799E19270BD83C409C9--
