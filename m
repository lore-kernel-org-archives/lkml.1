Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbXILIqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbXILIqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXILIqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:46:05 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:45860 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759583AbXILIqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:46:03 -0400
Subject: Re: [PATCH 21/23] mm: per device dirty threshold
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: John Stoffel <john@stoffel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
In-Reply-To: <18151.20636.425784.226044@stoffel.org>
References: <20070911195350.825778000@chello.nl>
	 <20070911200015.732492000@chello.nl>
	 <18151.20636.425784.226044@stoffel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wAZg1Tj2w1P+vfdzcQZI"
Date: Wed, 12 Sep 2007 10:45:57 +0200
Message-Id: <1189586757.21778.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wAZg1Tj2w1P+vfdzcQZI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-11 at 22:36 -0400, John Stoffel wrote:
> Peter> Scale writeback cache per backing device, proportional to its
> Peter> writeout speed.  By decoupling the BDI dirty thresholds a
> Peter> number of problems we currently have will go away, namely:
>=20
> Ah, this clarifies my questions!  Thanks!
>=20
> Peter>  - mutual interference starvation (for any number of BDIs);
> Peter>  - deadlocks with stacked BDIs (loop, FUSE and local NFS mounts).
>=20
> Peter> It might be that all dirty pages are for a single BDI while
> Peter> other BDIs are idling. By giving each BDI a 'fair' share of the
> Peter> dirty limit, each one can have dirty pages outstanding and make
> Peter> progress.
>=20
> Question, can you change (shrink) the limit on a BDI while it has IO
> in flight?  And what will that do to the system?  I.e. if you have one
> device doing IO, so that it has a majority of the dirty limit.  Then
> another device starts IO, and it's a *faster* device, how
> quickly/slowly does the BDI dirty limits change for both the old and
> new device? =20

Yes, it can change while in use. A measure of how quickly it can change
is roughly: it can half in a dirty_limit worth of writeout.

What will happen is that those processes doing heavy IO on the slower
device will get throttled more aggressively until its below its new
threshold again - however all the time it will keep on writing at (full)
speed because it will have this backlog to rid itself of, and by doing
that it completes writeouts which ensure it will keep part of the dirty
limit for itself, and thus can always make progress.

You can monitor this by looking at /sys/block/sd*/queue/cache_size while
doing such a thing. It should stabilise quite 'quickly'.

> Peter> A global threshold also creates a deadlock for stacked BDIs;
> Peter> when A writes to B, and A generates enough dirty pages to get
> Peter> throttled, B will never start writeback until the dirty pages
> Peter> go away. Again, by giving each BDI its own 'independent' dirty
> Peter> limit, this problem is avoided.
>=20
> Peter> So the problem is to determine how to distribute the total
> Peter> dirty limit across the BDIs fairly and efficiently. A DBI that
>=20
> You mean BDI here, not DBI. =20

Uhh, yeah, obviously :-)

> Peter> has a large dirty limit but does not have any dirty pages
> Peter> outstanding is a waste.
>=20
> Peter> What is done is to keep a floating proportion between the DBIs
> Peter> based on writeback completions. This way faster/more active
> Peter> devices get a larger share than slower/idle devices.
>=20
> Does a slower device get a BDI which is calculated to keep it's limit
> under a certain number of seconds of outstanding IO?  This way no
> device can build up more than say 15 seconds of outstanding IO to
> flush at any one time. =20

Perhaps already answered above, as long as there is dirty stuff to write
out it will keep completing writes and thus gain a stable share of the
dirty limit.

--=-wAZg1Tj2w1P+vfdzcQZI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG56dFXA2jU0ANEf4RAgfVAKCGq9vqSIbhXDh6PoWsonONWjNF7wCfXZZQ
dDb1fuD+/ov4tuGGDwNMShk=
=Xys/
-----END PGP SIGNATURE-----

--=-wAZg1Tj2w1P+vfdzcQZI--

