Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbXLEO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbXLEO1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXLEO1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:27:16 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:27363 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbXLEO1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:27:15 -0500
Subject: Re: +
	aoe-properly-initialise-the-request_queues-backing_dev_info.patch added to
	-mm tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com, stable@kernel.org
In-Reply-To: <200712032314.lB3NE6lS022508@imap1.linux-foundation.org>
References: <200712032314.lB3NE6lS022508@imap1.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ap3JWaMdPMatrsD53v9f"
Date: Wed, 05 Dec 2007 15:27:10 +0100
Message-Id: <1196864830.6788.39.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ap3JWaMdPMatrsD53v9f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-12-03 at 15:14 -0800, akpm@linux-foundation.org wrote:

> ------------------------------------------------------
> Subject: aoe: properly initialise the request_queue's backing_dev_info
> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> Cc: "Ed L. Cashin" <ecashin@coraid.com>
> Cc: <stable@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  drivers/block/aoe/aoeblk.c |   26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
>=20
> diff -puN drivers/block/aoe/aoeblk.c~aoe-properly-initialise-the-request_=
queues-backing_dev_info drivers/block/aoe/aoeblk.c
> --- a/drivers/block/aoe/aoeblk.c~aoe-properly-initialise-the-request_queu=
es-backing_dev_info
> +++ a/drivers/block/aoe/aoeblk.c
> @@ -6,6 +6,7 @@
> =20
>  #include <linux/hdreg.h>
>  #include <linux/blkdev.h>
> +#include <linux/backing-dev.h>
>  #include <linux/fs.h>
>  #include <linux/ioctl.h>
>  #include <linux/genhd.h>
> @@ -210,25 +211,20 @@ aoeblk_gdalloc(void *vp)
>  	if (gd =3D=3D NULL) {
>  		printk(KERN_ERR "aoe: cannot allocate disk structure for %ld.%ld\n",
>  			d->aoemajor, d->aoeminor);
> -		spin_lock_irqsave(&d->lock, flags);
> -		d->flags &=3D ~DEVFL_GDALLOC;
> -		spin_unlock_irqrestore(&d->lock, flags);
> -		return;
> +		goto err;
>  	}
> =20
>  	d->bufpool =3D mempool_create_slab_pool(MIN_BUFS, buf_pool_cache);
>  	if (d->bufpool =3D=3D NULL) {
>  		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%ld\n",
>  			d->aoemajor, d->aoeminor);
> -		put_disk(gd);
> -		spin_lock_irqsave(&d->lock, flags);
> -		d->flags &=3D ~DEVFL_GDALLOC;
> -		spin_unlock_irqrestore(&d->lock, flags);
> -		return;
> +		goto err_disk;
>  	}
> =20
> -	spin_lock_irqsave(&d->lock, flags);
>  	blk_queue_make_request(&d->blkq, aoeblk_make_request);
> +	if (bdi_init(&d->blkq.backing_dev_info))
> +		goto err_mempool;
> +	spin_lock_irqsave(&d->lock, flags);
>  	gd->major =3D AOE_MAJOR;
>  	gd->first_minor =3D d->sysminor * AOE_PARTITIONS;
>  	gd->fops =3D &aoe_bdops;
> @@ -246,6 +242,16 @@ aoeblk_gdalloc(void *vp)
> =20
>  	add_disk(gd);
>  	aoedisk_add_sysfs(d);
> +	return;
> +
> +err_mempool:
> +	mempool_destroy(d->bufpool);
> +err_disk:
> +	put_disk(gd);
> +err:
> +	spin_lock_irqsave(&d->lock, flags);
> +	d->flags &=3D ~DEVFL_GDALLOC;
> +	spin_unlock_irqrestore(&d->lock, flags);
>  }
> =20
>  void


--=-ap3JWaMdPMatrsD53v9f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHVrU+XA2jU0ANEf4RAqnTAKCSOG42ge0F/bgfhQW2GGW3N7P7vACeO6at
ZDokFs3jXYVTbjMGZY7Zt+c=
=YNcK
-----END PGP SIGNATURE-----

--=-ap3JWaMdPMatrsD53v9f--

