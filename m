Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZGJSDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZGJSDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZGJSDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:03:39 -0400
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:49998 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZGJSDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:03:38 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 14:03:37 EDT
Subject: Re: [git pull] drm: previous pull req + 1.
From: Eric Anholt <eric@anholt.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <1246262271.25462.32.camel@tiger>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <1245542690.6104.6.camel@localhost>
	 <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
	 <1245595658.4805.17.camel@localhost>  <1245619456.4937.35.camel@tiger>
	 <1245694171.6673.5.camel@localhost>  <1246262271.25462.32.camel@tiger>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t4Ts3sE9v3WhKnVPQYy+"
Date: Thu, 09 Jul 2009 16:11:06 -0700
Message-Id: <1247181066.19542.5.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t4Ts3sE9v3WhKnVPQYy+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-29 at 08:57 +0100, Chris Wilson wrote:
> On Mon, 2009-06-22 at 21:09 +0300, Maxim Levitsky wrote:
> > Nope, same thing.
> >=20
> > I use commit 87ef92092fd092936535ba057ee19b97bb6a709a + this patch
> > Note that GE doesn't hang the system when maximizing it.
> >=20
> > It is for sure tiled textures accessed incorrectly, same behavior
> > observed in many games (they still run though)
>=20
> Sorry for the delay, I was travelling last week and was sure I had
> nailed the problem. Aside from the missing flush on i965 when a batch
> buffer might be using fenced commands, the only other issue I found was
> that we did not zap the mapping range on clear - which could also cause
> tiling errors if textures were being written via a GTT mmap.
>=20
> So please can you try this patch:
>=20
> >From 20b7c9322914213bb589035afbbc03faf1ae3bf0 Mon Sep 17 00:00:00 2001
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Date: Mon, 29 Jun 2009 08:45:31 +0100
> Subject: [PATCH] drm/i915: Remove mappings on clearing fence register
>=20
> As the fence register is not locked whilst the user has mmaped the buffer
> through the GTT, in order for the buffer to reacquire a fence register we
> need to cause a fresh page-fault on the next user access. In order to
> cause the page fault, we zap the current mapping on clearing the register=
.
> We also ensure that all potential outstanding access via the fence
> register is flushed before release as well.
>=20
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/i915/i915_gem.c |   41 ++++++++++++++++++---------------=
-----
>  1 files changed, 19 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_=
gem.c
> index 685a876..6dc74c8 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1946,12 +1946,6 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
>  		obj_priv->agp_mem =3D NULL;
>  	}
> =20
> -
> -	/* blow away mappings if mapped through GTT */
> -	if (obj_priv->mmap_offset && dev->dev_mapping)
> -		unmap_mapping_range(dev->dev_mapping,
> -				    obj_priv->mmap_offset, obj->size, 1);
> -

Err, so now untiled things wouldn't fault to rebind?  Seems wrong.


> @@ -2456,6 +2451,11 @@ i915_gem_clear_fence_reg(struct drm_gem_object *ob=
j)
> =20
>  	dev_priv->fence_regs[obj_priv->fence_reg].obj =3D NULL;
>  	obj_priv->fence_reg =3D I915_FENCE_REG_NONE;
> +
> +	/* blow away mappings if mapped through GTT */
> +	if (obj_priv->mmap_offset && dev->dev_mapping)
> +		unmap_mapping_range(dev->dev_mapping,
> +				    obj_priv->mmap_offset, obj->size, 1);
>  }

This part seems good.

> =20
>  /**
> @@ -2469,27 +2469,24 @@ i915_gem_clear_fence_reg(struct drm_gem_object *o=
bj)
>  int
>  i915_gem_object_put_fence_reg(struct drm_gem_object *obj)
>  {
> -	struct drm_device *dev =3D obj->dev;
>  	struct drm_i915_gem_object *obj_priv =3D obj->driver_private;
> +	int ret;
> =20
>  	if (obj_priv->fence_reg =3D=3D I915_FENCE_REG_NONE)
>  		return 0;
> =20
> -	/* On the i915, GPU access to tiled buffers is via a fence,
> -	 * therefore we must wait for any outstanding access to complete
> -	 * before clearing the fence.
> +	/* If there is outstanding activity on the buffer whilst it holds
> +	 * a fence register we must assume that it requires that fence for
> +	 * correct operation. Therefore we must wait for any outstanding
> +	 * access to complete before clearing the fence.
>  	 */
> -	if (!IS_I965G(dev)) {
> -		int ret;
> -
> -		i915_gem_object_flush_gpu_write_domain(obj);
> -		i915_gem_object_flush_gtt_write_domain(obj);
> -		ret =3D i915_gem_object_wait_rendering(obj);
> -		if (ret !=3D 0)
> -			return ret;
> -	}
> +	i915_gem_object_flush_gpu_write_domain(obj);
> +	i915_gem_object_flush_gtt_write_domain(obj);
> +	ret =3D i915_gem_object_wait_rendering(obj);
> +	if (ret !=3D 0)
> +		return ret;
> =20
> -	i915_gem_clear_fence_reg (obj);
> +	i915_gem_clear_fence_reg(obj);
> =20
>  	return 0;
>  }

This part doesn't make sense to me.  There should be nothing in the 965
rendering path that's using fences.  Did you identify something that
was?

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-t4Ts3sE9v3WhKnVPQYy+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpWeQoACgkQHUdvYGzw6vc/zQCePibUGoJd3Eaww/b0kR8ZRqqv
srwAn1QSzoP9hbVKY8SDruCA7k16WcGC
=Bb+w
-----END PGP SIGNATURE-----

--=-t4Ts3sE9v3WhKnVPQYy+--
