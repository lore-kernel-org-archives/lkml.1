Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbXEDPP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbXEDPP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbXEDPP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:15:26 -0400
Received: from home.keithp.com ([63.227.221.253]:2526 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbXEDPPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:15:25 -0400
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
From: Keith Packard <keithp@keithp.com>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <463AE9AE.7070806@tungstengraphics.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <1178137279.53297.114.camel@vonnegut>
	 <46391860.3070409@tungstengraphics.com>
	 <1178251621.27028.9.camel@neko.keithp.com>
	 <463AE9AE.7070806@tungstengraphics.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I9n3YtLBr5/EryuOz7g+"
Date: Fri, 04 May 2007 08:15:02 -0700
Message-Id: <1178291702.27028.30.camel@neko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I9n3YtLBr5/EryuOz7g+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-04 at 10:07 +0200, Thomas Hellstr=C3=B6m wrote:
> =20
> It's rare to have two clients access the same buffer at the same time.=20
> In what situation will this occur?

Right, what I'm trying to avoid is having any contention for
applications *not* sharing the same objects.=20

If there is any locking for mapping, we can either attempt to define a
locking order, or we can have a single global lock. The former leaves us
prone to deadlocks, the latter eliminates the ability for un-contended
parallel access.

>     * It will encourage different DRI clients to simultaneously access
>       the same buffer.

Sure. Separate 'DRI' from 'GL' and this may be a sensible plan. If you
want to prevent this *that's not DRI's problem*.

>     * Inter-client and GPU data coherence can be guaranteed if we issue
>       a mb() / write-combining flush with the unmap operation (which,
>       BTW, I'm not sure is done today). Otherwise it is up to the
>       clients, and very easy to forget.

CPU-GPU coherence is ensured by the mutual exclusion between mapping and
submitting. You may either have data available to the CPU or to the GPU.
I think that's a basic requirement for any solution in this space.
Keying the submit and map as to whether writing will occur means that
appropriate flushing and fencing can be automatically applied within the
kernel.

> OTOH, letting DRM resolve the deadlock by unmapping and remapping shared=20
> buffers in the correct order might not be the best one either. It will=20
> certainly mean some CPU overhead and what if we have to do the same with=20
> buffer validation? (Yes for some operations with thousands and thousands=20
> of relocations, the user space validation might need to stay).

I do not want to do relocations in user space. I don't see why doing
thousands of these requires moving this operation out of the kernel.

--=20
keith.packard@intel.com

--=-I9n3YtLBr5/EryuOz7g+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGO032Qp8BWwlsTdMRAhyVAJ973bJdDw7i93mNjk5uehBlOvjLHACeOz8o
nUG+I42rZm8pLOAV5at61gI=
=zCPz
-----END PGP SIGNATURE-----

--=-I9n3YtLBr5/EryuOz7g+--
