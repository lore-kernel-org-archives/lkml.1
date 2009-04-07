Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbZDGQVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbZDGQVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZDGQVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:21:43 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:53754 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZDGQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:21:42 -0400
Subject: Re: Regression X Hangs at bootup -- PATCH
From: Eric Anholt <eric@anholt.net>
To: Florian Mickler <florian@mickler.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       airlied@linux.ie, keithp@keithp.com
In-Reply-To: <20090407092346.058d19a0@schatten>
References: <20090406225541.0e1e043b@schatten>
	 <1239069835.31656.109.camel@gaiman.anholt.net>
	 <20090407092346.058d19a0@schatten>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sAFMNglEUww0hVc/O5uy"
Date: Tue, 07 Apr 2009 09:21:40 -0700
Message-Id: <1239121300.9617.0.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sAFMNglEUww0hVc/O5uy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 09:23 +0200, Florian Mickler wrote:
> On Mon, 06 Apr 2009 19:03:55 -0700
> Eric Anholt <eric@anholt.net> wrote:
>=20
> > Nice catch!  Thanks.  I did some cleanup that brings it more in line
> > with style elsewhere in the code and cuts some of the gratuitous
> > looking changes.  Would you be OK with these changes rolled into your
> > original diff?
>=20
>  i take it, you appended the endresult?
>=20
> i'm ok with it, it's less invasive. but i think your
> i915_gem_put_relocs part is wrong. (see below)
>=20
>=20
> >=20
> >  drivers/gpu/drm/i915/i915_gem.c |   34
> > ++++++++++++++++++++++------------ 1 files changed, 22 insertions(+),
> > 12 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c
> > b/drivers/gpu/drm/i915/i915_gem.c index 33ab07b..6f7d0e2 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -141,15 +141,18 @@ fast_shmem_read(struct page **pages,
> >  		int length)
> >  {
> >  	char __iomem *vaddr;
> > -	int ret;
> > +	int unwritten;
> > =20
> >  	vaddr =3D kmap_atomic(pages[page_base >> PAGE_SHIFT],
> > KM_USER0); if (vaddr =3D=3D NULL)
> >  		return -ENOMEM;
> > -	ret =3D __copy_to_user_inatomic(data, vaddr + page_offset,
> > length);
> > +	unwritten =3D __copy_to_user_inatomic(data, vaddr +
> > page_offset, length); kunmap_atomic(vaddr, KM_USER0);
> > =20
> > -	return ret;
> > +	if (unwritten)
> > +		return -EFAULT;
> > +
> > +	return 0;
> >  }
>=20
> yep thats ok.
>=20
> > =20
> >  static inline int
> > @@ -3000,13 +3003,13 @@ i915_gem_get_relocs_from_user(struct
> > drm_i915_gem_exec_object *exec_list, drm_free(*relocs, reloc_count *
> > sizeof(**relocs), DRM_MEM_DRIVER);
> >  			*relocs =3D NULL;
> > -			return ret;
> > +			return -EFAULT;
> >  		}
> > =20
> >  		reloc_index +=3D exec_list[i].relocation_count;
> >  	}
> > =20
> > -	return ret;
> > +	return 0;
> >  }
> > =20
>=20
> right.
>=20
> >  static int
> > @@ -3015,23 +3018,28 @@ i915_gem_put_relocs_to_user(struct
> > drm_i915_gem_exec_object *exec_list, struct
> > drm_i915_gem_relocation_entry *relocs) {
> >  	uint32_t reloc_count =3D 0, i;
> > -	int ret;
> > +	int ret =3D 0;
> > =20
> >  	for (i =3D 0; i < buffer_count; i++) {
> >  		struct drm_i915_gem_relocation_entry __user
> > *user_relocs;
> > +		int unwritten;
> > =20
> >  		user_relocs =3D (void __user
> > *)(uintptr_t)exec_list[i].relocs_ptr;=20
> > -		if (ret =3D=3D 0) {
> > -			ret =3D copy_to_user(user_relocs,
> > -					   &relocs[reloc_count],
> > -
> > exec_list[i].relocation_count *
> > -					   sizeof(*relocs));
> > +		unwritten =3D copy_to_user(user_relocs,
> > +					 &relocs[reloc_count],
> > +
> > exec_list[i].relocation_count *
> > +					 sizeof(*relocs));
> > +
> > +		if (unwritten) {
> > +			ret =3D -EFAULT;
> > +			goto err;
> >  		}
> > =20
> >  		reloc_count +=3D exec_list[i].relocation_count;
> >  	}
> > =20
>=20
> i wondered too at first about the if (ret =3D=3D 0) part, but you need th=
e
> whole reloc_count to free everything in the next part:
>=20
> > +err:
> >  	drm_free(relocs, reloc_count * sizeof(*relocs),
> > DRM_MEM_DRIVER);=20
> >  	return ret;
>=20
>=20
> so i think, this would be a memleak in the error-case (if it ever
> happens)

drm_free's other arguments are unused memory debug leftovers.  I've got
a patch I need to push at airlied to remove
drm_malloc/drm_calloc/drm_free.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-sAFMNglEUww0hVc/O5uy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknbfZEACgkQHUdvYGzw6vfRCgCgglUiJ8Go6gVbqEWuZp+iv5sw
mQMAnREgZuuAq9R18iRn2Q7+zChPLg43
=IJIG
-----END PGP SIGNATURE-----

--=-sAFMNglEUww0hVc/O5uy--
