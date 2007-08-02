Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbXHBHNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbXHBHNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXHBHNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:13:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:39589 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752154AbXHBHNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:13:09 -0400
Subject: Re: [patch] radix-tree: use indirect bit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070802052446.GC31121@wotan.suse.de>
References: <20070802052446.GC31121@wotan.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vTAcrZP3od7ql68VWfeD"
Date: Thu, 02 Aug 2007 09:13:05 +0200
Message-Id: <1186038785.12034.101.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vTAcrZP3od7ql68VWfeD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 07:24 +0200, Nick Piggin wrote:
> Rather than sign direct radix-tree pointers with a special bit, sign
> the indirect one that hangs off the root. This means that, given a
> lookup_slot operation, the invalid result will be differentiated from
> the valid (previously, valid results could have the bit either set or
> clear).
>=20
> This does not affect slot lookups which occur under lock -- they
> can never return an invalid result. Is needed in future for lockless
> pagecache.
>=20
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

>=20
> Index: linux-2.6/include/linux/radix-tree.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/radix-tree.h
> +++ linux-2.6/include/linux/radix-tree.h
> @@ -26,28 +26,31 @@
>  #include <linux/rcupdate.h>
> =20
>  /*
> - * A direct pointer (root->rnode pointing directly to a data item,
> - * rather than another radix_tree_node) is signalled by the low bit
> - * set in the root->rnode pointer.
> - *
> - * In this case root->height is also NULL, but the direct pointer tests =
are
> - * needed for RCU lookups when root->height is unreliable.
> + * An indirect pointer (root->rnode pointing to a radix_tree_node, rathe=
r
> + * than a data item) is signalled by the low bit set in the root->rnode
> + * pointer.
> + *
> + * In this case root->height is > 0, but the indirect pointer tests are
> + * needed for RCU lookups (because root->height is unreliable). The only
> + * time callers need worry about this is when doing a lookup_slot under
> + * RCU.
>   */
> -#define RADIX_TREE_DIRECT_PTR	1
> +#define RADIX_TREE_INDIRECT_PTR	1
> +#define RADIX_TREE_RETRY ((void *)-1UL)
> =20
> -static inline void *radix_tree_ptr_to_direct(void *ptr)
> +static inline void *radix_tree_ptr_to_indirect(void *ptr)
>  {
> -	return (void *)((unsigned long)ptr | RADIX_TREE_DIRECT_PTR);
> +	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
>  }
> =20
> -static inline void *radix_tree_direct_to_ptr(void *ptr)
> +static inline void *radix_tree_indirect_to_ptr(void *ptr)
>  {
> -	return (void *)((unsigned long)ptr & ~RADIX_TREE_DIRECT_PTR);
> +	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
>  }
> =20
> -static inline int radix_tree_is_direct_ptr(void *ptr)
> +static inline int radix_tree_is_indirect_ptr(void *ptr)
>  {
> -	return (int)((unsigned long)ptr & RADIX_TREE_DIRECT_PTR);
> +	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
>  }
> =20
>  /*** radix-tree API starts here ***/
> @@ -130,7 +133,10 @@ do {									\
>   */
>  static inline void *radix_tree_deref_slot(void **pslot)
>  {
> -	return radix_tree_direct_to_ptr(*pslot);
> +	void *ret =3D *pslot;
> +	if (unlikely(radix_tree_is_indirect_ptr(ret)))
> +		ret =3D RADIX_TREE_RETRY;
> +	return ret;
>  }
>  /**
>   * radix_tree_replace_slot	- replace item in a slot
> @@ -142,10 +148,8 @@ static inline void *radix_tree_deref_slo
>   */
>  static inline void radix_tree_replace_slot(void **pslot, void *item)
>  {
> -	BUG_ON(radix_tree_is_direct_ptr(item));
> -	rcu_assign_pointer(*pslot,
> -		(void *)((unsigned long)item |
> -			((unsigned long)*pslot & RADIX_TREE_DIRECT_PTR)));
> +	BUG_ON(radix_tree_is_indirect_ptr(item));
> +	rcu_assign_pointer(*pslot, item);
>  }
> =20
>  int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
> Index: linux-2.6/lib/radix-tree.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/lib/radix-tree.c
> +++ linux-2.6/lib/radix-tree.c
> @@ -104,7 +104,7 @@ radix_tree_node_alloc(struct radix_tree_
>  			rtp->nr--;
>  		}
>  	}
> -	BUG_ON(radix_tree_is_direct_ptr(ret));
> +	BUG_ON(radix_tree_is_indirect_ptr(ret));
>  	return ret;
>  }
> =20
> @@ -240,7 +240,7 @@ static int radix_tree_extend(struct radi
>  			return -ENOMEM;
> =20
>  		/* Increase the height.  */
> -		node->slots[0] =3D radix_tree_direct_to_ptr(root->rnode);
> +		node->slots[0] =3D radix_tree_indirect_to_ptr(root->rnode);
> =20
>  		/* Propagate the aggregated tag info into the new root */
>  		for (tag =3D 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
> @@ -251,6 +251,7 @@ static int radix_tree_extend(struct radi
>  		newheight =3D root->height+1;
>  		node->height =3D newheight;
>  		node->count =3D 1;
> +		node =3D radix_tree_ptr_to_indirect(node);
>  		rcu_assign_pointer(root->rnode, node);
>  		root->height =3D newheight;
>  	} while (height > root->height);
> @@ -274,7 +275,7 @@ int radix_tree_insert(struct radix_tree_
>  	int offset;
>  	int error;
> =20
> -	BUG_ON(radix_tree_is_direct_ptr(item));
> +	BUG_ON(radix_tree_is_indirect_ptr(item));
> =20
>  	/* Make sure the tree is high enough.  */
>  	if (index > radix_tree_maxindex(root->height)) {
> @@ -283,7 +284,8 @@ int radix_tree_insert(struct radix_tree_
>  			return error;
>  	}
> =20
> -	slot =3D root->rnode;
> +	slot =3D radix_tree_indirect_to_ptr(root->rnode);
> +
>  	height =3D root->height;
>  	shift =3D (height-1) * RADIX_TREE_MAP_SHIFT;
> =20
> @@ -298,7 +300,8 @@ int radix_tree_insert(struct radix_tree_
>  				rcu_assign_pointer(node->slots[offset], slot);
>  				node->count++;
>  			} else
> -				rcu_assign_pointer(root->rnode, slot);
> +				rcu_assign_pointer(root->rnode,
> +					radix_tree_ptr_to_indirect(slot));
>  		}
> =20
>  		/* Go a level down */
> @@ -318,7 +321,7 @@ int radix_tree_insert(struct radix_tree_
>  		BUG_ON(tag_get(node, 0, offset));
>  		BUG_ON(tag_get(node, 1, offset));
>  	} else {
> -		rcu_assign_pointer(root->rnode, radix_tree_ptr_to_direct(item));
> +		rcu_assign_pointer(root->rnode, item);
>  		BUG_ON(root_tag_get(root, 0));
>  		BUG_ON(root_tag_get(root, 1));
>  	}
> @@ -350,11 +353,12 @@ void **radix_tree_lookup_slot(struct rad
>  	if (node =3D=3D NULL)
>  		return NULL;
> =20
> -	if (radix_tree_is_direct_ptr(node)) {
> +	if (!radix_tree_is_indirect_ptr(node)) {
>  		if (index > 0)
>  			return NULL;
>  		return (void **)&root->rnode;
>  	}
> +	node =3D radix_tree_indirect_to_ptr(node);
> =20
>  	height =3D node->height;
>  	if (index > radix_tree_maxindex(height))
> @@ -398,11 +402,12 @@ void *radix_tree_lookup(struct radix_tre
>  	if (node =3D=3D NULL)
>  		return NULL;
> =20
> -	if (radix_tree_is_direct_ptr(node)) {
> +	if (!radix_tree_is_indirect_ptr(node)) {
>  		if (index > 0)
>  			return NULL;
> -		return radix_tree_direct_to_ptr(node);
> +		return node;
>  	}
> +	node =3D radix_tree_indirect_to_ptr(node);
> =20
>  	height =3D node->height;
>  	if (index > radix_tree_maxindex(height))
> @@ -447,7 +452,7 @@ void *radix_tree_tag_set(struct radix_tr
>  	height =3D root->height;
>  	BUG_ON(index > radix_tree_maxindex(height));
> =20
> -	slot =3D root->rnode;
> +	slot =3D radix_tree_indirect_to_ptr(root->rnode);
>  	shift =3D (height - 1) * RADIX_TREE_MAP_SHIFT;
> =20
>  	while (height > 0) {
> @@ -497,7 +502,7 @@ void *radix_tree_tag_clear(struct radix_
> =20
>  	shift =3D (height - 1) * RADIX_TREE_MAP_SHIFT;
>  	pathp->node =3D NULL;
> -	slot =3D root->rnode;
> +	slot =3D radix_tree_indirect_to_ptr(root->rnode);
> =20
>  	while (height > 0) {
>  		int offset;
> @@ -562,8 +567,9 @@ int radix_tree_tag_get(struct radix_tree
>  	if (node =3D=3D NULL)
>  		return 0;
> =20
> -	if (radix_tree_is_direct_ptr(node))
> +	if (!radix_tree_is_indirect_ptr(node))
>  		return (index =3D=3D 0);
> +	node =3D radix_tree_indirect_to_ptr(node);
> =20
>  	height =3D node->height;
>  	if (index > radix_tree_maxindex(height))
> @@ -680,13 +686,13 @@ radix_tree_gang_lookup(struct radix_tree
>  	if (!node)
>  		return 0;
> =20
> -	if (radix_tree_is_direct_ptr(node)) {
> +	if (!radix_tree_is_indirect_ptr(node)) {
>  		if (first_index > 0)
>  			return 0;
> -		node =3D radix_tree_direct_to_ptr(node);
> -		results[0] =3D rcu_dereference(node);
> +		results[0] =3D node;
>  		return 1;
>  	}
> +	node =3D radix_tree_indirect_to_ptr(node);
> =20
>  	max_index =3D radix_tree_maxindex(node->height);
> =20
> @@ -808,13 +814,13 @@ radix_tree_gang_lookup_tag(struct radix_
>  	if (!node)
>  		return 0;
> =20
> -	if (radix_tree_is_direct_ptr(node)) {
> +	if (!radix_tree_is_indirect_ptr(node)) {
>  		if (first_index > 0)
>  			return 0;
> -		node =3D radix_tree_direct_to_ptr(node);
> -		results[0] =3D rcu_dereference(node);
> +		results[0] =3D node;
>  		return 1;
>  	}
> +	node =3D radix_tree_indirect_to_ptr(node);
> =20
>  	max_index =3D radix_tree_maxindex(node->height);
> =20
> @@ -844,12 +850,22 @@ EXPORT_SYMBOL(radix_tree_gang_lookup_tag
>  static inline void radix_tree_shrink(struct radix_tree_root *root)
>  {
>  	/* try to shrink tree height */
> -	while (root->height > 0 &&
> -			root->rnode->count =3D=3D 1 &&
> -			root->rnode->slots[0]) {
> +	while (root->height > 0) {
>  		struct radix_tree_node *to_free =3D root->rnode;
>  		void *newptr;
> =20
> +		BUG_ON(!radix_tree_is_indirect_ptr(to_free));
> +		to_free =3D radix_tree_indirect_to_ptr(to_free);
> +
> +		/*
> +		 * The candidate node has more than one child, or its child
> +		 * is not at the leftmost slot, we cannot shrink.
> +		 */
> +		if (to_free->count !=3D 1)
> +			break;
> +		if (!to_free->slots[0])
> +			break;
> +
>  		/*
>  		 * We don't need rcu_assign_pointer(), since we are simply
>  		 * moving the node from one part of the tree to another. If
> @@ -858,8 +874,8 @@ static inline void radix_tree_shrink(str
>  		 * one (root->rnode).
>  		 */
>  		newptr =3D to_free->slots[0];
> -		if (root->height =3D=3D 1)
> -			newptr =3D radix_tree_ptr_to_direct(newptr);
> +		if (root->height > 1)
> +			newptr =3D radix_tree_ptr_to_indirect(newptr);
>  		root->rnode =3D newptr;
>  		root->height--;
>  		/* must only free zeroed nodes into the slab */
> @@ -894,12 +910,12 @@ void *radix_tree_delete(struct radix_tre
>  		goto out;
> =20
>  	slot =3D root->rnode;
> -	if (height =3D=3D 0 && root->rnode) {
> -		slot =3D radix_tree_direct_to_ptr(slot);
> +	if (height =3D=3D 0) {
>  		root_tag_clear_all(root);
>  		root->rnode =3D NULL;
>  		goto out;
>  	}
> +	slot =3D radix_tree_indirect_to_ptr(slot);
> =20
>  	shift =3D (height - 1) * RADIX_TREE_MAP_SHIFT;
>  	pathp->node =3D NULL;
> @@ -941,7 +957,8 @@ void *radix_tree_delete(struct radix_tre
>  			radix_tree_node_free(to_free);
> =20
>  		if (pathp->node->count) {
> -			if (pathp->node =3D=3D root->rnode)
> +			if (pathp->node =3D=3D
> +					radix_tree_indirect_to_ptr(root->rnode))
>  				radix_tree_shrink(root);
>  			goto out;
>  		}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=-vTAcrZP3od7ql68VWfeD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGsYQBXA2jU0ANEf4RArbXAJ4tEMX8IDKR3tiuOhtjHcrybSkciACeInOQ
aM+ngZNd3X27ChhDmxeKvGI=
=K7Sg
-----END PGP SIGNATURE-----

--=-vTAcrZP3od7ql68VWfeD--

