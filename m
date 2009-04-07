Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZDGHYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZDGHYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDGHYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:24:06 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33802 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZDGHYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:24:05 -0400
Date: Tue, 7 Apr 2009 09:23:46 +0200
From: Florian Mickler <florian@mickler.org>
To: Eric Anholt <eric@anholt.net>
Cc: LKML <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       airlied@linux.ie, keithp@keithp.com
Subject: Re: Regression X Hangs at bootup -- PATCH
Message-ID: <20090407092346.058d19a0@schatten>
In-Reply-To: <1239069835.31656.109.camel@gaiman.anholt.net>
References: <20090406225541.0e1e043b@schatten>
	<1239069835.31656.109.camel@gaiman.anholt.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Se12EXXJUOh=z/EzxexGZ+g";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Se12EXXJUOh=z/EzxexGZ+g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Apr 2009 19:03:55 -0700
Eric Anholt <eric@anholt.net> wrote:

> Nice catch!  Thanks.  I did some cleanup that brings it more in line
> with style elsewhere in the code and cuts some of the gratuitous
> looking changes.  Would you be OK with these changes rolled into your
> original diff?

 i take it, you appended the endresult?

i'm ok with it, it's less invasive. but i think your
i915_gem_put_relocs part is wrong. (see below)


>=20
>  drivers/gpu/drm/i915/i915_gem.c |   34
> ++++++++++++++++++++++------------ 1 files changed, 22 insertions(+),
> 12 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_gem.c
> b/drivers/gpu/drm/i915/i915_gem.c index 33ab07b..6f7d0e2 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -141,15 +141,18 @@ fast_shmem_read(struct page **pages,
>  		int length)
>  {
>  	char __iomem *vaddr;
> -	int ret;
> +	int unwritten;
> =20
>  	vaddr =3D kmap_atomic(pages[page_base >> PAGE_SHIFT],
> KM_USER0); if (vaddr =3D=3D NULL)
>  		return -ENOMEM;
> -	ret =3D __copy_to_user_inatomic(data, vaddr + page_offset,
> length);
> +	unwritten =3D __copy_to_user_inatomic(data, vaddr +
> page_offset, length); kunmap_atomic(vaddr, KM_USER0);
> =20
> -	return ret;
> +	if (unwritten)
> +		return -EFAULT;
> +
> +	return 0;
>  }

yep thats ok.

> =20
>  static inline int
> @@ -3000,13 +3003,13 @@ i915_gem_get_relocs_from_user(struct
> drm_i915_gem_exec_object *exec_list, drm_free(*relocs, reloc_count *
> sizeof(**relocs), DRM_MEM_DRIVER);
>  			*relocs =3D NULL;
> -			return ret;
> +			return -EFAULT;
>  		}
> =20
>  		reloc_index +=3D exec_list[i].relocation_count;
>  	}
> =20
> -	return ret;
> +	return 0;
>  }
> =20

right.

>  static int
> @@ -3015,23 +3018,28 @@ i915_gem_put_relocs_to_user(struct
> drm_i915_gem_exec_object *exec_list, struct
> drm_i915_gem_relocation_entry *relocs) {
>  	uint32_t reloc_count =3D 0, i;
> -	int ret;
> +	int ret =3D 0;
> =20
>  	for (i =3D 0; i < buffer_count; i++) {
>  		struct drm_i915_gem_relocation_entry __user
> *user_relocs;
> +		int unwritten;
> =20
>  		user_relocs =3D (void __user
> *)(uintptr_t)exec_list[i].relocs_ptr;=20
> -		if (ret =3D=3D 0) {
> -			ret =3D copy_to_user(user_relocs,
> -					   &relocs[reloc_count],
> -
> exec_list[i].relocation_count *
> -					   sizeof(*relocs));
> +		unwritten =3D copy_to_user(user_relocs,
> +					 &relocs[reloc_count],
> +
> exec_list[i].relocation_count *
> +					 sizeof(*relocs));
> +
> +		if (unwritten) {
> +			ret =3D -EFAULT;
> +			goto err;
>  		}
> =20
>  		reloc_count +=3D exec_list[i].relocation_count;
>  	}
> =20

i wondered too at first about the if (ret =3D=3D 0) part, but you need the
whole reloc_count to free everything in the next part:

> +err:
>  	drm_free(relocs, reloc_count * sizeof(*relocs),
> DRM_MEM_DRIVER);=20
>  	return ret;


so i think, this would be a memleak in the error-case (if it ever
happens)


> @@ -3306,10 +3314,12 @@ err:
>  				   (uintptr_t) args->buffers_ptr,
>  				   exec_list,
>  				   sizeof(*exec_list) *
> args->buffer_count);
> -		if (ret)
> +		if (ret) {
> +			ret =3D -EFAULT;
>  			DRM_ERROR("failed to copy %d exec entries "
>  				  "back to user (%d)\n",
>  				  args->buffer_count, ret);
> +		}
>  	}
> =20
>  	/* Copy the updated relocations out regardless of current
> error





--Sig_/Se12EXXJUOh=z/EzxexGZ+g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkna/4gACgkQPjqCkyL3Kv3n7QCeP0X6fOU08qbdP7Z7RJBVDEWt
4wkAn1pxlR9kLQ0E5lFGf7zA5g4APtkz
=c6Dd
-----END PGP SIGNATURE-----

--Sig_/Se12EXXJUOh=z/EzxexGZ+g--
