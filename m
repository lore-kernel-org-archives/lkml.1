Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYIEQ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYIEQ7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYIEQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:59:45 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54699 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbYIEQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:59:44 -0400
Message-ID: <48C164E8.6000504@novell.com>
Date: Fri, 05 Sep 2008 12:57:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [rfc][patch] queueing spinlocks?
References: <20080828073428.GA19638@wotan.suse.de>
In-Reply-To: <20080828073428.GA19638@wotan.suse.de>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0640E72822C4CCF78BE4A653"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0640E72822C4CCF78BE4A653
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[resend, as the first had a problem going out]

Hi Nick,
  Cool stuff...see inline

Nick Piggin wrote:
> I've implemented a sort of spin local, queueing MCS lock that uses per-=
cpu
> nodes that can be shared by multiple locks. I guess it is preferable to=

> remove global locks, but some don't seem to be going anywhere soon.
>
> The only issue is that only one set of nodes can be actively used for a=
 lock
> at once, so if we want to nest these locks, we have to use different
> sets for each one. This shouldn't be much of a problem because we don't=
 have
> too many "big" locks, and yet fewer ones that are nested in one another=
=2E
>
> With this modification to MCS locks, each lock is pretty small in size,=
 so it
> could even be used for some per-object locks if we really wanted.
>
> I've converted dcache lock as well... it shows improved results on a 64=
-way
> Altix. Unfortunately this adds an extra atomic to the unlock path. I di=
dn't
> look too hard at array based queue locks, there might be a a type of th=
ose
> that would work better.
>
> Index: linux-2.6/include/linux/mcslock.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6/include/linux/mcslock.h
> @@ -0,0 +1,76 @@
> +/*
> + *	"Shared-node" MCS lock.
> + *	Nick Piggin <npiggin@suse.de>
> + */
> +#ifndef _LINUX_MCSLOCK_H
> +#define _LINUX_MCSLOCK_H
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/irqflags.h>
> +#include <asm/atomic.h>
> +#include <asm/system.h>
> +#include <asm/processor.h>
> +
> +#ifndef CONFIG_SMP
> +typdef struct {
> +} mcslock_t;
> +
> +static inline void mcs_lock_init(mcslock_t *lock)
> +{
> +}
> +
> +static inline int mcs_is_locked(mcslock_t *lock)
> +{
> +	return 0;
> +}
> +
> +static inline void mcs_unlock_wait(mcslock_t *lock)
> +{
> +}
> +
> +static inline void mcs_lock(mcslock_t *lock, int nest)
> +{
> +}
> +static inline int mcs_trylock(mcslock_t *lock, int nest)
> +{
> +	return 1;
> +}
> +static inline void mcs_unlock(mcslock_t *lock, int nest)
> +{
> +}
> +
> +#else /*!CONFIG_SMP*/
> +
> +typedef struct {
> +	atomic_t cpu;
> +} mcslock_t;
> +
> +#define MCS_CPU_NONE	0x7fffffff
> +
> +#define DEFINE_MCS_LOCK(name) mcslock_t name =3D { .cpu =3D ATOMIC_INI=
T(MCS_CPU_NONE) }
> +static inline void mcs_lock_init(mcslock_t *lock)
> +{
> +	atomic_set(&lock->cpu, MCS_CPU_NONE); /* unlocked */
> +}
> +
> +static inline int mcs_is_locked(mcslock_t *lock)
> +{
> +	return atomic_read(&lock->cpu) !=3D MCS_CPU_NONE;
> +}
> +
> +static inline void mcs_unlock_wait(mcslock_t *lock)
> +{
> +	while (mcs_is_locked(lock))
> +		cpu_relax();
> +}
> +
> +extern void mcs_lock(mcslock_t *lock, int nest);
> +extern int mcs_trylock(mcslock_t *lock, int nest);
> +extern void mcs_unlock(mcslock_t *lock, int nest);
> +
> +#endif /*!CONFIG_SMP*/
> +
> +extern int atomic_dec_and_mcslock(atomic_t *atomic, mcslock_t *lock, i=
nt nest);
>  =20

I would prefer to see this done as a polymorhpic atomic_dec_and_lock()
call with something like Ingo's "PICK_OP" method (currently used in -rt)
rather than expanding the atomic_X namespace.  I haven't looked into it
to make sure its plausible, but I do not see any reasons from 30k feet
why it would not.  Its not a huge deal either way, but just something to
consider.

-Greg




--------------enig0640E72822C4CCF78BE4A653
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjBZOgACgkQlOSOBdgZUxk42ACeMAY+gm1DjJU2kZ2itYPkny1P
7MMAn2QkUK+HZqg7tjQe9RCxnoxD8LFk
=Kspk
-----END PGP SIGNATURE-----

--------------enig0640E72822C4CCF78BE4A653--
