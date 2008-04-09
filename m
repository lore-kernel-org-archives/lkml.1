Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYDJOkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYDJOkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYDJOjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:39:55 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYDJOjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:39:54 -0400
Subject: Re: Using sparse to catch invalid RCU dereferences?
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-sparse <linux-sparse@vger.kernel.org>
In-Reply-To: <20080408155259.GA8381@linux.vnet.ibm.com>
References: <1207605856.12481.35.camel@johannes.berg>
	 <20080408155259.GA8381@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zGX7g5zuk9rIfinKQi5/"
Date: Wed, 09 Apr 2008 22:09:46 +0200
Message-Id: <1207771787.7442.45.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zGX7g5zuk9rIfinKQi5/
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> It might be.  There are a number of places where it is legal to access
> RCU-protected pointers directly, and all of these would need to be
> changed.  For example, in the example above, one could do:
>=20
> 	foo =3D NULL;

Ok, that I understand, but sparse always treats NULL specially anyway.

> I recently tried to modify rcu_assign_pointer() to issue the memory
> memory barrier only when the pointer was non-NULL, but this ended badly.

Hm? I thought that's in the current tree.

> Probably because I am not the greatest gcc expert around...  We ended
> up having to define an rcu_assign_index() to handle the possibility of
> assigning a zero-value array index, but my attempts to do type-checking
> backfired, and I eventually gave it up.  Again, someone a bit more clued
> in to gcc than I am could probably pull it off.

Ah, ok.

> In addition, it is legal to omit rcu_dereference() and rcu_assign_pointer=
()
> when holding the update-side lock.

That I don't understand. Well, I do understand that omitting
rcu_dereference() is ok, but it seems to me that the memory and compiler
barrier in rcu_assign_pointer() is actually needed.

I've been playing a bit, see below for my play rcupdate.h and test.c
test program.

Unfortunately, sparse doesn't have the ability to declare
"=EF=BB=BF__attribute__((force_bitwise)) typeof(p)" or even
"=EF=BB=BF__attribute__((force)) typeof(p)" which makes this force more tha=
n
necessary and causes it to not catch when incompatible pointers are
used. gcc notices that because I only do a cast at all for sparse, but
that doesn't help, since e.g. list_for_each_entry_rcu() requires that
the correct type is returned. So without sparse supporting the latter
notation, we don't stand a chance.

Also, I wouldn't know how to declare that an array or so needs
rcu-access to the members.

johannes


rcupdate.h:

#define USE_BITWISE

#ifdef __CHECKER__
#ifdef USE_BITWISE
#define __rcu __attribute__((bitwise))
#define __force_rcu_cast(p) (*((__attribute__((force)) void **)&(p)))
// would like instead:
//#define __force_rcu_cast(p) ((__attribute__((force_bitwise)) typeof(p)) (=
p))
#else /* not bitwise */
#define __rcu __attribute__((address_space(3)))
#define __force_rcu_cast(p) (*((__attribute__((force)) void **)&(p)))
// would like instead:
//#define __force_rcu_cast(p) ((__attribute__((force_address_space)) typeof=
(p)) (p))
#endif

#else /* not checker */
#define __rcu
#define __force_rcu_cast(p) (p)
#endif

#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))

#define rcu_dereference(p)     ({ \
				typeof(p) _________p1 =3D ACCESS_ONCE(p); \
				smp_read_barrier_depends(); \
				__force_rcu_cast(_________p1); \
				})

/**
 * rcu_fetch - fetch an RCU-protected pointer in the update-locked
 * critical section.
 *
 * This macro exists for documentation and code checking purposes.
 */
#define rcu_fetch(p)     __force_rcu_cast(p);

#define rcu_assign_pointer(p, v) \
	({ \
		if (!__builtin_constant_p(v) || \
		    ((v) !=3D NULL)) \
			smp_wmb(); \
		__force_rcu_cast(p) =3D (v); \
	})


test.c:

#include <stdlib.h>
#include "rcupdate.h"

/* my rcu protected variables */
static unsigned int __rcu *prot;
static unsigned int __rcu *prot_same;
static unsigned char __rcu *prot2;

// dummies
static smp_read_barrier_depends(void) {}
static smp_wmb(void) {}

int main(void)
{
	unsigned int *tmp;

	// no warnings from sparse due to forced cast
	rcu_assign_pointer(prot, tmp);
	// but gcc warns
	rcu_assign_pointer(prot2, tmp);

	// no warnings
	rcu_assign_pointer(prot, NULL);
	rcu_assign_pointer(prot2, NULL);

	// no warnings
	prot =3D NULL;
	prot2 =3D NULL;

	// no warnings from sparse due to forced cast
	tmp =3D rcu_dereference(prot);
	// but gcc warns
	tmp =3D rcu_dereference(prot2);

	/* now within locked section rcu_dereference isn't required */

	// no warnings from sparse due to forced cast
	tmp =3D rcu_fetch(prot);
	// but gcc warns
	tmp =3D rcu_fetch(prot2);

	/* not caught with address_space, but is caught with bitwise */
	prot =3D prot_same;
}


--=-zGX7g5zuk9rIfinKQi5/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/0iiaVg1VMiehFYAQKBQw/+ObJPHF3OQNai7a/yaYleFi22KC+fZ0Am
qcm9jPC1kl9N/nQFxmbY0nUQyo/8282U7KjESFoT3IWF3Y8iPa6kwb8Os5YQn1jG
uhnnwgQwmUJ7EEckE5TAGJn7mGF25lcOowXI6xM31WA5XAXgBsOuXHDk7DOQQQkr
pjoawJg/R64bKjVDk97cXNUqHWysajAgRg0jZZr9EGO0OY1dbwqfdUfY5TUJEHvv
2zJvmgbiSrLeHRA1FwzDDrftTtwjgvEPU59nYhpd5sb0eetf5GK6yARaiI8MpJkA
Ikl7Cpc9A1EzuBKMDnh1j7XLAwgwkru/iLSe3Lh58VpqfblM5ITTtx3buQFDW3FN
zljDgKrOxGuRygEmkZX8vzEBeKtzxGCIFp/OHbJlaZSfus8TPHTEgCh7hYH2JeF+
Ccmdxo/8IGdfw2yP8FONFsSirLc1IAshnuLZszH3wvVd4ZfQ1f+QNK2uMWZTQrAV
DDuYCPrKWGc4FA/IK8vbTo36ndZeKRCIPBXywJAWxO6gLQ+sSV1mG1yNt2CUApRN
ghZu+AIhhA7wsTnlyKxtP4tZk+dj8oY/5LSKGIGJRW+a8YgzCp+89pLEFNXmuk+E
jxjQbWmGBjgOINHbAjevt0lbtjyI1hkJIU9a+17LaHFJdgBhNdJMji/MHw0qZycA
BRDmI9CMPCQ=
=7XsJ
-----END PGP SIGNATURE-----

--=-zGX7g5zuk9rIfinKQi5/--

