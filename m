Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYIDJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYIDJiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYIDJiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:38:09 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54791 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbYIDJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:38:06 -0400
Date: Thu, 4 Sep 2008 11:38:03 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v3][PATCH 7/9] Infrastructure for shared objects
Message-ID: <20080904093803.GX14473@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0809040404550.5982@takamine.ncl.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-6508-1220520951-0001-2"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809040404550.5982@takamine.ncl.cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-6508-1220520951-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2008 at 04:05:22AM -0400, Oren Laadan wrote:
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
>

[...]

> diff --git a/checkpoint/objhash.c b/checkpoint/objhash.c
> new file mode 100644
> index 0000000..442b08c
> --- /dev/null
> +++ b/checkpoint/objhash.c
> @@ -0,0 +1,205 @@
> +/*
> + *  Checkpoint-restart - object hash infrastructure to manage shared obj=
ects
> + *
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
> +#include <linux/ckpt.h>
> +
> +struct cr_objref {
> +	int objref;
> +	void *ptr;
> +	unsigned short type;
> +	unsigned short flags;
> +	struct hlist_node hash;
> +};
> +
> +struct cr_objhash {
> +	struct hlist_head *head;
> +	int objref_index;
> +};
> +
> +#define CR_OBJHASH_NBITS  10
> +#define CR_OBJHASH_TOTAL  (1UL << CR_OBJHASH_NBITS - 1)

Why -1? This makes a total number of 512 entries, which will break below wi=
th
hashes in range 0..1023.

> +
> +static void cr_obj_ref_drop(struct cr_objref *obj)
> +{
> +	switch (obj->type) {
> +	case CR_OBJ_FILE:
> +		fput((struct file *) obj->ptr);
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static void cr_obj_ref_grab(struct cr_objref *obj)
> +{
> +	switch (obj->type) {
> +	case CR_OBJ_FILE:
> +		get_file((struct file *) obj->ptr);
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static void cr_objhash_clear(struct cr_objhash *objhash)
> +{
> +	struct hlist_head *h =3D objhash->head;
> +	struct hlist_node *n, *t;
> +	struct cr_objref *obj;
> +	int i;
> +
> +	for (i =3D 0; i < CR_OBJHASH_TOTAL; i++) {
> +		hlist_for_each_entry_safe(obj, n, t, &h[i], hash) {
> +			cr_obj_ref_drop(obj);
> +			kfree(obj);
> +		}
> +	}
> +}
> +
> +void cr_objhash_free(struct cr_ctx *ctx)
> +{
> +	struct cr_objhash *objhash =3D ctx->objhash;
> +
> +	if (objhash) {
> +		cr_objhash_clear(objhash);
> +		kfree(objhash->head);
> +		kfree(ctx->objhash);
> +		ctx->objhash =3D NULL;
> +	}
> +}
> +
> +int cr_objhash_alloc(struct cr_ctx *ctx)
> +{
> +	struct cr_objhash *objhash;
> +	struct hlist_head *head;
> +
> +	objhash =3D kzalloc(sizeof(*objhash), GFP_KERNEL);
> +	if (!objhash)
> +		return -ENOMEM;
> +	head =3D kzalloc(CR_OBJHASH_TOTAL * sizeof(*head), GFP_KERNEL);

512 entries allocated

> +	if (!head) {
> +		kfree(objhash);
> +		return -ENOMEM;
> +	}
> +
> +	objhash->head =3D head;
> +	objhash->objref_index =3D 1;
> +
> +	ctx->objhash =3D objhash;
> +	return 0;
> +}
> +
> +static struct cr_objref *cr_obj_find_by_ptr(struct cr_ctx *ctx, void *pt=
r)
> +{
> +	struct hlist_head *h;
> +	struct hlist_node *n;
> +	struct cr_objref *obj;
> +
> +	h =3D &ctx->objhash->head[hash_ptr(ptr, CR_OBJHASH_NBITS)];

access to entries 0..1023

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-6508-1220520951-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIv6x7VKcRuvQ9Q1QRAqK1AJ9UEv+kOcAmYz47gcMkkJSqjrULiACeNANh
6DG57Y/0HsQwCIeCmnyYVl0=
=wCo+
-----END PGP SIGNATURE-----

--=_bohort-6508-1220520951-0001-2--
