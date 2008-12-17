Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756698AbYLQDdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYLQDdx (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYLQDdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:33:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:16926 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYLQDdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:33:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,234,1228118400"; 
   d="asc'?scan'208";a="474627609"
Subject: Re: [RFC PATCH crypto] AES: Add support to
	Intel	AES-NI	instructions
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-crypto@ml.breakpoint.cc" <linux-crypto@ml.breakpoint.cc>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <E1LClB3-0006WP-9J@gondolin.me.apana.org.au>
References: <E1LClB3-0006WP-9J@gondolin.me.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KmrgkliXSkUKqDuWbkyH"
Date: Wed, 17 Dec 2008 11:33:39 +0800
Message-Id: <1229484819.5936.337.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KmrgkliXSkUKqDuWbkyH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-17 at 09:26 +0800, Herbert Xu wrote:
> Huang Ying <ying.huang@intel.com> wrote:
> >
> > f. if TS is clear, then use x86_64 implementation. Otherwise if
> > user-space has touched the FPU, we save the state, if not then simply
> > clear TS.
>=20
> Well I'd rather avoid using the x86_64 implementation ever because
> unless the chip guys have really screwed up we should be looking at
> a difference of at least a factor of 10.
>=20
> BTW I wasn't very clear in the original email.  You'd only do the
> asynchronous operation for CBC/ECB.  For the simple AES case I
> suppose we'll just have to stick to the x86_64 fallback.  This'll
> really suck for disk encryption but I guess you could always add
> an LRW/XTS mode to your code.

It seems that asynchronous operations are only provided in blkcipher
level not cipher level. So the situation may be as follow:

- Now an AES core block algorithm is implemented with AES-NI as
CRYPTO_ALG_TYPE_CIPHER, which can benefit all modes (CBC, LRW, etc). But
because it seems that there is no asynchronous interface for
CRYPTO_ALG_TYPE_CIPHER, the AES core block algorithm can not use a
thread to defer real operations.

- To take full advantage of AES-NI pipeline implementation, at least
"cbc(aes)", "ecb(aes)" and "ctr(aes)" should be implemented as
CRYPTO_ALG_TYPE_ABLKCIPHER. So a thread can be used to defer real
operation upon soft_irq.

Because the combination that kernel process context FPU usage + soft_irq
AES usage is fairly rare, I think the above combination is acceptable.
That is,

- In AES core block algorithm implementation with AES-NI, use x86_64
implementation for the combination above.

- In "cbc(aes)", "ecb(aes)" and "ctr(aes)", use thread deferring for the
combination above.

Best Regards,
Huang Ying


--=-KmrgkliXSkUKqDuWbkyH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklIcwcACgkQKhFGF+eHlphuAACgpZzxjDiwSuFxF84p2eIHFEot
DPUAn0Yn0fcJORJk3W9HhTzULovzRVVl
=kdOh
-----END PGP SIGNATURE-----

--=-KmrgkliXSkUKqDuWbkyH--

