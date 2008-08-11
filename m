Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYHKDDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYHKDDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 23:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYHKDDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 23:03:30 -0400
Received: from home.keithp.com ([63.227.221.253]:4483 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbYHKDDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 23:03:30 -0400
Subject: Re: [PATCH] Export shmem_file_setup for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080811012347.GA27264@infradead.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
	 <20080801205052.GA28747@infradead.org>
	 <1217631718.23437.290.camel@koto.keithp.com>
	 <20080811012347.GA27264@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5LHOEQfKlOa0dqdCYMiJ"
Date: Sun, 10 Aug 2008 23:03:17 -0400
Message-Id: <1218423797.10772.48.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5LHOEQfKlOa0dqdCYMiJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-10 at 21:23 -0400, Christoph Hellwig wrote:

> shmfs is perfectly happy to have thousands of files, there are workloads
> that have a lot more than that.  Note that in other subthreads there is
> the assumption that all of them are open and in the fd table at the same
> time.  I haven't really seen a good explanation for that - objects on
> shmfs are persistant until deleted, and when you keep your parent
> directory fd open an openat to get at the actual object is cheap.

A typical GPU-intensive application will have a few thousand objects
full of GPU-bound data containing GPU commands, vertices, textures,
rendering buffers, constants and other misc GPU state.

When rendering a typical frame, all of these objects will be referenced
in turn -- each frame is much like the last, so the process of drawing
the frame ends up using almost exactly the same data each time. It's an
animation after all.

Any kind of resource constraint places severe pressure on an eviction
policy -- the obvious 'LRU' turns out to be almost exactly wrong as you
always eject the objects which are next in line for re-use. Obviously,
the right solution is to avoid artificial resource constraints, and
minimize the impact of real constraints.

Limiting the number of objects we can have in-use at a time (by limiting
the number of open FDs) is an artificial resource constraint, forcing
re-use of closed objects to pay an extra openat cost. That may be cheap,
but it's not free.

Plus, we don't want persistent objects here -- when the application
exits, we want the objects to disappear automatically; otherwise you'll
clutter shmem with thousands of spurious files when an application
crashes. So, if we create shmem files, we'll want to unlink them
immediately, leaving only the fd in place to refer to them.

Our alternative is to open the shmem file and pass the fd into our
driver to hold onto the file while the application closes the fd.
I see that as simply a kludge to work around the absence of anonymous
pageable file allocation -- it seems like an abuse of the current API.

Perhaps we should construct a different API to allocate a pageable
object? Having shmem expose these as 'files' doesn't make a lot of sense
in this context, it just happens to be an easy way to plug them into the
vm system, as is evidenced by ipc/shm using them as well.

--=20
keith.packard@intel.com

--=-5LHOEQfKlOa0dqdCYMiJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIn6v1Qp8BWwlsTdMRAp+gAKCtW/GUvpJQrqaLhvctlmvtn+xZZQCgora3
pFgOqvGbIiHnSM0/5yyaopw=
=SwNU
-----END PGP SIGNATURE-----

--=-5LHOEQfKlOa0dqdCYMiJ--

