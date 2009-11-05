Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZKEAU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZKEAU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZKEAU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:20:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45239 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbZKEAU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:20:27 -0500
Date: Thu, 5 Nov 2009 11:20:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Jan Beulich <JBeulich@novell.com>,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
Message-Id: <20091105112020.33f02552.sfr@canb.auug.org.au>
In-Reply-To: <200910201415.34361.rusty@rustcorp.com.au>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	<200910201142.34006.rusty@rustcorp.com.au>
	<1256002193.6546.2.camel@slab>
	<200910201415.34361.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Nov_2009_11_20_20_+1100_+dqOcjvsFQwyL1KA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Nov_2009_11_20_20_+1100_+dqOcjvsFQwyL1KA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Tue, 20 Oct 2009 14:15:33 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> +#ifndef __OPTIMIZE__
> +#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
> +#else
> +extern int __build_bug_on_failed;
> +#define BUILD_BUG_ON(condition)					\
> +	do {							\
> +		((void)sizeof(char[1 - 2*!!(condition)]));	\
> +		if (condition) __build_bug_on_failed =3D 1;	\
> +	} while(0)
> +#endif
> +#define MAYBE_BUILD_BUG_ON(condition) BUILD_BUG_ON(condition)
> +

I decided to try this in linux-next, but an x86_64 allmodconfig build
gave this (gcc 4.4.0):

ERROR: "__build_bug_on_failed" [drivers/net/virtio_net.ko] undefined!
ERROR: "__build_bug_on_failed" [drivers/block/virtio_blk.ko] undefined!

I assume that this is caused by the "MAYBE_BUILD_BUG_ON(fbit >=3D 32)" in
virtio_has_feature() (in include/linux/virtio_config.h) which is called
all over the place.  Unfortunately, virtio_has_feature() gets uninlined
in those two files ...

I have taken the patch back out again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Nov_2009_11_20_20_+1100_+dqOcjvsFQwyL1KA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkryGkQACgkQjjKRsyhoI8yNnwCgqxtqC7HlRrQPSf2/86SIICQx
NNUAn0WTwWtUTvocyofSmByl1KGyiCwd
=1ISe
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Nov_2009_11_20_20_+1100_+dqOcjvsFQwyL1KA--
