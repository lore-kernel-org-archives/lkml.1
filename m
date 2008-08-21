Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYHUKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYHUKk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYHUKkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:40:19 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:57000 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYHUKkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:40:18 -0400
Date: Thu, 21 Aug 2008 12:40:16 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 7/9] Infrastructure for shared objects
Message-ID: <20080821104016.GJ581@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202306170.17436@takamine.ncl.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-10627-1219315086-0001-2"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808202306170.17436@takamine.ncl.cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-10627-1219315086-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2008 at 11:06:50PM -0400, Oren Laadan wrote:
>
> Infrastructure to handle objects that may be shared and referenced by
> multiple tasks or other objects, e..g open files, memory address space
> etc.
>
> The state of shared objects is saved once. On the first encounter, the
> state is dumped and the object is assigned a unique identifier and also
> stored in a hash table (indexed by its physical kenrel address). From
> then on the object will be found in the hash and only its identifier is
> saved.
>
> On restart the identifier is looked up in the hash table; if not found
> then the state is read, the object is created, and added to the hash
> table (this time indexed by its identifier). Otherwise, the object in
> the hash table is used.

[...]

> diff --git a/checkpoint/ckpt.h b/checkpoint/ckpt.h
> index 0addb63..8b02c4c 100644
> --- a/checkpoint/ckpt.h
> +++ b/checkpoint/ckpt.h
> @@ -29,6 +29,8 @@ struct cr_ctx {
>  	void *hbuf;		/* header: to avoid many alloc/dealloc */
>  	int hpos;
>
> +	struct cr_objhash *objhash;
> +
>  	struct cr_pgarr *pgarr;
>  	struct cr_pgarr *pgcur;
>
> @@ -56,6 +58,22 @@ int cr_kread(struct cr_ctx *ctx, void *buf, int count);
>  void *cr_hbuf_get(struct cr_ctx *ctx, int n);
>  void cr_hbuf_put(struct cr_ctx *ctx, int n);
>
> +/* shared objects handling */
> +
> +enum {
> +	CR_OBJ_FILE =3D 1,
> +	CR_OBJ_MAX
> +};
> + +void cr_objhash_free(struct cr_ctx *ctx);
    ^
    |
      Strange, isn't it?

> +int cr_objhash_alloc(struct cr_ctx *ctx);
> +void *cr_obj_get_by_tag(struct cr_ctx *ctx, int tag, unsigned short type=
);
> +int cr_obj_get_by_ptr(struct cr_ctx *ctx, void *ptr, unsigned short type=
);
> +int cr_obj_add_ptr(struct cr_ctx *ctx, void *ptr, int *tag,
> +		   unsigned short type, unsigned short flags);
> +int cr_obj_add_tag(struct cr_ctx *ctx, void *ptr, int tag,
> +		   unsigned short type, unsigned short flags);
> +
>  struct cr_hdr;
>
>  int cr_write_obj(struct cr_ctx *ctx, struct cr_hdr *h, void *buf);
> diff --git a/checkpoint/objhash.c b/checkpoint/objhash.c
> new file mode 100644
> index 0000000..aca32c6
> --- /dev/null
> +++ b/checkpoint/objhash.c
> @@ -0,0 +1,193 @@
> +/*
> + *  Checkpoint-restart - object hash infrastructure to manage shared=20
> objects + *
> + *  Copyright (C) 2008 Oren Laadan
> + *
> + *  This file is subject to the terms and conditions of the GNU General =
Public
> + *  License.  See the file COPYING in the main directory of the Linux
> + *  distribution for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/file.h>
> +#include <linux/hash.h>
> +
> +#include "ckpt.h"
> +
> +struct cr_obj {
> +	int tag;
> +	void *ptr;
> +	unsigned short type;
> +	unsigned short flags;
> +	struct cr_obj *next;
> +};
> +
> +struct cr_objhash {
> +	struct cr_obj **hash;
> +	int next_tag;
> +};
> +
> +#define CR_OBJHASH_NBITS  10	/* 10 bits =3D 1K buckets */
> +#define CR_OBJHASH_ORDER  0	/* 1K buckets * 4 bytes/bucket =3D 1 page */

Only true when PAGE_SIZE =3D=3D 4K and in 32bits. Perhaps like below?

#define CR_OBJHASH_BUCKET_NBITS (BITS_PER_LONG =3D=3D 64 ? 3 : 2)
#define CR_MIN_OBJHASH_NBITS ((PAGE_SHIFT - CR_OBJHASH_BUCKET_NBITS)
#define CR_OBJHASH_NBITS (CR_MIN_OBJHASH_NBITS >=3D 10 ? CR_MIN_OBJHASH_NBI=
TS : 10)
#define CR_OBJHASH_ORDER (CR_OBJHASH_NBITS + CR_OBJHASH_BUCKET_NBITS - PAGE=
_SHIFT)

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-10627-1219315086-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIrUYQVKcRuvQ9Q1QRAmSJAJ90Ulu7lEVbhJmBnikR3wDQdg7DdgCgzKOX
+lMFTaVjHJwo4PEi9F/hAl0=
=+vf6
-----END PGP SIGNATURE-----

--=_bohort-10627-1219315086-0001-2--
