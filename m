Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZESPe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZESPe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZESPeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:34:19 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZESPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:34:19 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090519120010.GA14782@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SEnDeE0gzPiCaRVOLoF8"
Date: Tue, 19 May 2009 17:33:23 +0200
Message-Id: <1242747203.4797.39.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SEnDeE0gzPiCaRVOLoF8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-19 at 14:00 +0200, Oleg Nesterov wrote:

> > I'm not familiar enough with the code -- but what are we really trying
> > to do in CPU_POST_DEAD? It seems to me that at that time things must
> > already be off the CPU, so ...?
>=20
> Yes, this cpu is dead, we should do cleanup_workqueue_thread() to kill
> cwq->thread.
>=20
> > On the other hand that calls
> > flush_cpu_workqueue() so it seems it would actually wait for the work t=
o
> > be executed on some other CPU, within the CPU_POST_DEAD notification?
>=20
> Yes. Because we can't just kill cwq->thread, we can have the pending
> work_structs so we have to flush.
>=20
> Why can't we move these works to another CPU? We can, but this doesn't
> really help. Because in any case we should at least wait for
> cwq->current_work to complete.
>=20
> Why do we use CPU_POST_DEAD, and not (say) CPU_DEAD to flush/kill ?
> Because work->func() can sleep in get_online_cpus(), we can't flush
> until we drop cpu_hotplug.lock.

Right. But exactly this happens in the hibernate case -- the hibernate
code calls kernel/cpu.c:disable_nonboot_cpus() which calls _cpu_down()
which calls raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD... Sadly,
it does so while holding the cpu_add_remove_lock, which is happens to
have the dependencies outlined in the original email...

The same happens in cpu_down() (without leading _) which you can trigger
from sysfs by manually removing the CPU, so it's not hibernate specific.

Anyway, you can have a deadlock like this:

CPU 3			CPU 2				CPU 1
							suspend/hibernate
			something:
			rtnl_lock()			device_pm_lock()
							-> mutex_lock(&dpm_list_mtx)

			mutex_lock(&dpm_list_mtx)

linkwatch_work
 -> rtnl_lock()
							disable_nonboot_cpus()
							-> flush CPU 3 workqueue

johannes


--=-SEnDeE0gzPiCaRVOLoF8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEtE/AAoJEODzc/N7+Qma3+EP/2Rc5E4elKkY5fyaR9w9iR4A
YYnbnWls3pqe8+j1xQXu9+mhnM++sb4XCuacShOe3AEYFG/ZFpGBu2Mi/eKh4rZV
HQ/mgeF+gz59QWb/mKwGDUVZM8lNDLosZOJQAzH0kM4Ir2H0BoSzXJcSk2/V58Ux
wkjTqQ+FPfZUkEg9FDh8hC9oJCIix2L5xcx8QMfzTN0Ur+LIJiPuWt17SZty/aEy
2LRPj/wF4qANZjtcGYRrF05qqM7YNa6ueh6+7TtYrGy6qF8s3Be3MGEfc8V22g6n
Zac4KaqeqV8UoN5jlkNSzNnq6FdhvgOx5/X1m/Ta7hrw+OgChDXfdSFwVttaruk1
QHO6cqU4jEYXN8wyUivDp3BjmxVdvasO1oQnYI0x4VqNsHVx6hwcLpw3eisefbHx
M9Rg8OYigvTOH1C/NQwWPrYVhRNJaJHLYZQTFbGkqibDLGnFmR5ps5qaSE0RQ+J1
saCkIp/jkSJa8mJzHt2En4y14lYycans3LX6/XI+UzBy2acbuavSUw9F6JjarInf
06WrVZP59mQ3VOJofiLI8aLWWxt5Vvtc46yEA+SoYEeYOT/aAffQcTu1kwdcplcI
sbIhn2AHixJLEx/R8nlVW9TsMr7u78vvJId/aTtOdZ2doiT/QGiTzdAVfyeStiRv
Zjxfci4RiqOjhyL4O02i
=ADHR
-----END PGP SIGNATURE-----

--=-SEnDeE0gzPiCaRVOLoF8--

