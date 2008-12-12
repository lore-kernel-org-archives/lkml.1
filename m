Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYLLJJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYLLJJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYLLJIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:08:54 -0500
Received: from mail.klingt.org ([86.59.21.178]:56214 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbYLLJIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:08:52 -0500
Subject: Re: [PATCH] [RT] avoid preemption in memory controller code
From: Tim Blechmann <tim@klingt.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <20081212101731.6034a554.kamezawa.hiroyu@jp.fujitsu.com>
References: <preempt_enable_rt();>
	 <1229022045-31670-1-git-send-email-tim@klingt.org>
	 <20081212101731.6034a554.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-p8s1audRejaHzep1P1Hk"
Date: Fri, 12 Dec 2008 10:08:18 +0100
Message-Id: <1229072898.6629.24.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Fri, 12 Dec 2008 10:08:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-p8s1audRejaHzep1P1Hk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > the lru_lock of struct mem_group_per_zone is used to avoid preemption
> > during the mem_cgroup_charge_statistics function. this does not work
> > correctly, when CONFIG_PREEMPT_RT is enabled.
> > therefore, the preemption is disabled using the preempt_disable_rt macr=
o
> > in these cases.
> >=20
> > Signed-off-by: Tim Blechmann <tim@klingt.org>
>=20
> Sorry, memcg's code this function in mmotm kernel is now, following.
> Please give me advice if some more thinking is necessary for RT.

using get_cpu/put_cpu, the preemption is disabled ... so mmotm should
not require any changes. my patch would only be required for an
rt-patch, based on a current kernel version ...
instead of applying my patch, one could also use the specific part of
mmotm for the RT tree ...

tim

> static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>                                          struct page_cgroup *pc,
>                                          bool charge)
> {
>         int val =3D (charge)? 1 : -1;
>         struct mem_cgroup_stat *stat =3D &mem->stat;
>         struct mem_cgroup_stat_cpu *cpustat;
>         int cpu =3D get_cpu();
>=20
>         cpustat =3D &stat->cpustat[cpu];
>         if (PageCgroupCache(pc))
>                 __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_CACHE=
, val);
>         else
>                 __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_RSS, =
val);
>=20
>         if (charge)
>                 __mem_cgroup_stat_add_safe(cpustat,
>                                 MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
>         else
>                 __mem_cgroup_stat_add_safe(cpustat,
>                                 MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
>         put_cpu();
> }

--
tim@klingt.org
http://tim.klingt.org

Silence is only frightening to people who are compulsively
verbalizing.
  William S. Burroughs

--=-p8s1audRejaHzep1P1Hk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAklCKgAACgkQFz+XezW6HD6BoACfXXbZGtTDITPvcZNMq/Ry5WR5
giUAljwm2xO5+No1gf84f5olSNBsXOA=
=1gS5
-----END PGP SIGNATURE-----

--=-p8s1audRejaHzep1P1Hk--

