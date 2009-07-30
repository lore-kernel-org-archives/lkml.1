Return-Path: <linux-kernel-owner+w=401wt.eu-S1751162AbZG3PBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbZG3PBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZG3PBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:01:53 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42432 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZG3PBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:01:53 -0400
Message-ID: <4A71B5DD.4010503@novell.com>
Date: Thu, 30 Jul 2009 11:01:49 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
       maxk@qualcomm.com, mingo@elte.hu
Subject: Re: [PATCH 1/2] [RESEND] sched: Fully integrate cpus_active_map and
 root-domain code
References: <20090730145623.25226.29033.stgit@dev.haskins.net> <20090730145723.25226.24493.stgit@dev.haskins.net>
In-Reply-To: <20090730145723.25226.24493.stgit@dev.haskins.net>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3C48D8532B0F5183A0D68823"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3C48D8532B0F5183A0D68823
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (Applies to 2.6.31-rc4)
>=20
> [
> 	This patch was originaly sent about a year ago, but got dropped
> 	presumably by accident.  Here is the original thread.
>=20
> 	http://lkml.org/lkml/2008/7/22/281
>=20
> 	At that time, Peter and Max acked it.  It has now been forward
> 	ported to the new cpumask interface.  I will be so bold as to
> 	carry their acks forward since the basic logic is the same.
> 	However, a new acknowledgement, if they have the time to review,
> 	would be ideal.
>=20
> 	I have tested this patch on a 4-way system using Max's recommended
> 	"echo 0|1 > cpu1/online" technique and it appears to work properly
> ]
>=20
> What: Reflect "active" cpus in the rq->rd->online field, instead of the=

> online_map.
>=20
> Motivation:  Things that use the root-domain code (such as cpupri) only=

> care about cpus classified as "active" anyway.  By synchronizing the
> root-domain state with the active map, we allow several optimizations.
>=20
> For instance, we can remove an extra cpumask_and from the scheduler
> hotpath by utilizing rq->rd->online (since it is now a cached version
> of cpu_active_map & rq->rd->span).
>=20
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Max Krasnyansky <maxk@qualcomm.com>
> ---
>=20
>  kernel/sched.c      |    2 +-
>  kernel/sched_fair.c |   10 +++++++---
>  kernel/sched_rt.c   |    7 -------
>  3 files changed, 8 insertions(+), 11 deletions(-)
>=20
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1a104e6..38a1526 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7874,7 +7874,7 @@ static void rq_attach_root(struct rq *rq, struct =
root_domain *rd)
>  	rq->rd =3D rd;
> =20
>  	cpumask_set_cpu(rq->cpu, rd->span);
> -	if (cpumask_test_cpu(rq->cpu, cpu_online_mask))
> +	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
>  		set_rq_online(rq);
> =20
>  	spin_unlock_irqrestore(&rq->lock, flags);
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9ffb2b2..2b9cae6 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1040,17 +1040,21 @@ static void yield_task_fair(struct rq *rq)
>   * search starts with cpus closest then further out as needed,
>   * so we always favor a closer, idle cpu.
>   * Domains may include CPUs that are not usable for migration,
> - * hence we need to mask them out (cpu_active_mask)
> + * hence we need to mask them out (rq->rd->online)
>   *
>   * Returns the CPU we should wake onto.
>   */
>  #if defined(ARCH_HAS_SCHED_WAKE_IDLE)
> +
> +#define cpu_rd_active(cpu, rq) cpumask_test_cpu(cpu, rq->rd->online)
> +
>  static int wake_idle(int cpu, struct task_struct *p)
>  {
>  	struct sched_domain *sd;
>  	int i;
>  	unsigned int chosen_wakeup_cpu;
>  	int this_cpu;
> +	struct rq *task_rq =3D task_rq(p);
> =20
>  	/*
>  	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cp=
u
> @@ -1083,10 +1087,10 @@ static int wake_idle(int cpu, struct task_struc=
t *p)
>  	for_each_domain(cpu, sd) {
>  		if ((sd->flags & SD_WAKE_IDLE)
>  		    || ((sd->flags & SD_WAKE_IDLE_FAR)
> -			&& !task_hot(p, task_rq(p)->clock, sd))) {
> +			&& !task_hot(p, task_rq->clock, sd))) {
>  			for_each_cpu_and(i, sched_domain_span(sd),
>  					 &p->cpus_allowed) {

Hmm, something got suboptimal in translation from the original patch.

This would be better expressed as:

for_each_cpu_and(i, rq->rd->online, &p->cpus_allowed) {
	if (idle_cpu(i)...
}

> -				if (cpu_active(i) && idle_cpu(i)) {
> +				if (cpu_rd_active(i, task_rq) && idle_cpu(i)) {
>  					if (i !=3D task_cpu(p)) {
>  						schedstat_inc(p,
>  						       se.nr_wakeups_idle);
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index a8f89bc..13f728e 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1173,13 +1173,6 @@ static int find_lowest_rq(struct task_struct *ta=
sk)
>  		return -1; /* No targets found */
> =20
>  	/*
> -	 * Only consider CPUs that are usable for migration.
> -	 * I guess we might want to change cpupri_find() to ignore those
> -	 * in the first place.
> -	 */
> -	cpumask_and(lowest_mask, lowest_mask, cpu_active_mask);
> -
> -	/*
>  	 * At this point we have built a mask of cpus representing the
>  	 * lowest priority tasks in the system.  Now we want to elect
>  	 * the best one based on our affinity and topology.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--------------enig3C48D8532B0F5183A0D68823
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkpxtd0ACgkQP5K2CMvXmqFl8gCfXrQsJn9oL5FfQZFA7WmCiDgd
4nIAnioMJ18tI0Iw1MslHoq1gZAIEh3D
=oNJT
-----END PGP SIGNATURE-----

--------------enig3C48D8532B0F5183A0D68823--
