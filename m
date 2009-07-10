Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZGJEFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZGJEFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 00:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZGJEFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 00:05:42 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37437 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZGJEFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 00:05:41 -0400
Message-ID: <4A56BE07.9050104@novell.com>
Date: Fri, 10 Jul 2009 00:05:27 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, zengzm.kernel@gmail.com
Subject: Re: [PATCH] sched_rt: fix overload bug on rt group scheduling -v2
References: <1238604015.8530.3666.camel@twins> <49D40DBF.8030507@novell.com>	 <1238654901.8530.5373.camel@twins>  <49D49FB6.3000101@novell.com> <1247067476.9777.57.camel@twins>
In-Reply-To: <1247067476.9777.57.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0F72B5396014887E3BB032C3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0F72B5396014887E3BB032C3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> Greg, how's this?
>  =20

Hi Peter,
  Sorry for the delay getting back to you.

I can't vouch specifically for the rt-group specific part, but as far as
the general balancer modifications to the migration code, it looks good. =


> ---
> Subject: sched_rt: fix overload bug on rt group scheduling
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 01 Apr 2009 18:40:15 +0200
>
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
>  =20

Acked-by: Gregory Haskins <ghaskins@novell.com>

> ---
>  kernel/sched_rt.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/kernel/sched_rt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -10,6 +10,8 @@ static inline struct task_struct *rt_tas
> =20
>  #ifdef CONFIG_RT_GROUP_SCHED
> =20
> +#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
> +
>  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
>  {
>  	return rt_rq->rq;
> @@ -22,6 +24,8 @@ static inline struct rt_rq *rt_rq_of_se(
> =20
>  #else /* CONFIG_RT_GROUP_SCHED */
> =20
> +#define rt_entity_is_task(rt_se) (1)
> +
>  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
>  {
>  	return container_of(rt_rq, struct rq, rt);
> @@ -73,7 +77,7 @@ static inline void rt_clear_overload(str
> =20
>  static void update_rt_migration(struct rt_rq *rt_rq)
>  {
> -	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
> +	if (rt_rq->rt_nr_migratory && rt_rq->rt_nr_total > 1) {
>  		if (!rt_rq->overloaded) {
>  			rt_set_overload(rq_of_rt_rq(rt_rq));
>  			rt_rq->overloaded =3D 1;
> @@ -86,6 +90,12 @@ static void update_rt_migration(struct r
> =20
>  static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_=
rq *rt_rq)
>  {
> +	if (!rt_entity_is_task(rt_se))
> +		return;
> +
> +	rt_rq =3D &rq_of_rt_rq(rt_rq)->rt;
> +
> +	rt_rq->rt_nr_total++;
>  	if (rt_se->nr_cpus_allowed > 1)
>  		rt_rq->rt_nr_migratory++;
> =20
> @@ -94,6 +104,12 @@ static void inc_rt_migration(struct sche
> =20
>  static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_=
rq *rt_rq)
>  {
> +	if (!rt_entity_is_task(rt_se))
> +		return;
> +
> +	rt_rq =3D &rq_of_rt_rq(rt_rq)->rt;
> +
> +	rt_rq->rt_nr_total--;
>  	if (rt_se->nr_cpus_allowed > 1)
>  		rt_rq->rt_nr_migratory--;
> =20
> diff --git a/kernel/sched.c b/kernel/sched.c
> index fd3ac58..a07d520 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -493,6 +493,7 @@ struct rt_rq {
>  #endif
>  #ifdef CONFIG_SMP
>  	unsigned long rt_nr_migratory;
> +	unsigned long rt_nr_total;
>  	int overloaded;
>  	struct plist_head pushable_tasks;
>  #endif
>
>  =20



--------------enig0F72B5396014887E3BB032C3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpWvgsACgkQlOSOBdgZUxnxNACdGiUzpGL/+Yn3Za0480xf+mA8
LrMAn1VG5JzrzMRiPleMtecGjEnao52D
=QFQA
-----END PGP SIGNATURE-----

--------------enig0F72B5396014887E3BB032C3--
