Return-Path: <linux-kernel-owner+w=401wt.eu-S1762406AbZDBA4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762406AbZDBA4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZDBA4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:56:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59020 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZDBA4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:56:33 -0400
Message-ID: <49D40DBF.8030507@novell.com>
Date: Wed, 01 Apr 2009 20:58:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_rt: fix overload bug on rt group scheduling
References: <1238604015.8530.3666.camel@twins>
In-Reply-To: <1238604015.8530.3666.camel@twins>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig65797DE3AB34A71006E12212"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig65797DE3AB34A71006E12212
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Peter,

Peter Zijlstra wrote:
> Fixes an easily triggerable BUG() when setting process affinities.
>
> Make sure to count the number of migratable tasks in the same place:
> the root rt_rq. Otherwise the number doesn't make sense and we'll hit
> the BUG in set_cpus_allowed_rt().
>
> Also, make sure we only count tasks, not groups (this is probably
> already taken care of by the fact that rt_se->nr_cpus_allowed will be 0=

> for groups, but be more explicit)
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Tested-by: Thomas Gleixner <tglx@linutronix.de>
> CC: stable@kernel.org
> ---
>  kernel/sched_rt.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index de4469a..c1ee8dc 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -10,6 +10,8 @@ static inline struct task_struct *rt_task_of(struct s=
ched_rt_entity *rt_se)
> =20
>  #ifdef CONFIG_RT_GROUP_SCHED
> =20
> +#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
> +
>  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
>  {
>  	return rt_rq->rq;
> @@ -22,6 +24,8 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_=
rt_entity *rt_se)
> =20
>  #else /* CONFIG_RT_GROUP_SCHED */
> =20
> +#define rt_entity_is_task(rt_se) (1)
> +
>  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
>  {
>  	return container_of(rt_rq, struct rq, rt);
> @@ -73,7 +77,7 @@ static inline void rt_clear_overload(struct rq *rq)
> =20
>  static void update_rt_migration(struct rt_rq *rt_rq)
>  {
> -	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
> +	if (rt_rq->rt_nr_migratory > 1) {
>  =20

The rest of the patch is making sense to me, but I am a little concerned
about this change.

The original logic was designed to catch the condition when you might
have a non-migratory task running, and a migratory task queued.   This
would mean nr_running =3D=3D 2, and nr_migratory =3D=3D 1, which is eligi=
ble for
overload handling.  (Of course, the opposite could be true..the
migratory is running and the non-migratory is queued...we cannot discern
the difference here and we go into overload anyway.  This is just
suboptimal but functionally correct).

What can happen now is you could have that above condition but we will
not go into overload unless there is at least two migratory tasks
queued.  This will undoubtedly allow a potential scheduling latency on
task #2.

I think we really need to qualify overload on both running > 1 and at
least one migratory task.  Is there a way to get this state, even if by
other means?

>  		if (!rt_rq->overloaded) {
>  			rt_set_overload(rq_of_rt_rq(rt_rq));
>  			rt_rq->overloaded =3D 1;
> @@ -86,6 +90,11 @@ static void update_rt_migration(struct rt_rq *rt_rq)=

> =20
>  static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_=
rq *rt_rq)
>  {
> +	if (!rt_entity_is_task(rt_se))
> +		return;
> +
> +	rt_rq =3D &rq_of_rt_rq(rt_rq)->rt;
> +
>  	if (rt_se->nr_cpus_allowed > 1)
>  		rt_rq->rt_nr_migratory++;
> =20
> @@ -94,6 +103,11 @@ static void inc_rt_migration(struct sched_rt_entity=
 *rt_se, struct rt_rq *rt_rq)
> =20
>  static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_=
rq *rt_rq)
>  {
> +	if (!rt_entity_is_task(rt_se))
> +		return;
> +
> +	rt_rq =3D &rq_of_rt_rq(rt_rq)->rt;
> +
>  	if (rt_se->nr_cpus_allowed > 1)
>  		rt_rq->rt_nr_migratory--;
> =20
>
>  =20



--------------enig65797DE3AB34A71006E12212
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknUDb8ACgkQlOSOBdgZUxnU1gCffjIEYRVSminWUj+SFWZPB4jj
ZnYAniCpKD+p2E412HYDeYvOTuU/grPE
=oKBw
-----END PGP SIGNATURE-----

--------------enig65797DE3AB34A71006E12212--
