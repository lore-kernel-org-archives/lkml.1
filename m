Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZDGCES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZDGCES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZDGCEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:04:00 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50888 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZDGCEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:04:00 -0400
Subject: Re: Regression X Hangs at bootup -- PATCH
From: Eric Anholt <eric@anholt.net>
To: Florian Mickler <florian@mickler.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       airlied@linux.ie, keithp@keithp.com
In-Reply-To: <20090406225541.0e1e043b@schatten>
References: <20090406225541.0e1e043b@schatten>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-R2kuguacmS49uvEwtai3"
Date: Mon, 06 Apr 2009 19:03:55 -0700
Message-Id: <1239069835.31656.109.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R2kuguacmS49uvEwtai3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

=46rom bce4dab0061fa195360f3b88ce22c44895d3d197 Mon Sep 17 00:00:00 2001
From: Florian Mickler <florian@mickler.org>
Date: Mon, 6 Apr 2009 22:55:41 +0200
Subject: [PATCH] drm/i915: Fix use of uninitialized var in 40a5f0de

i915_gem_put_relocs_to_user returned an uninitialized value which
got returned to userspace. This caused libdrm in my setup to never
get out of a do{}while() loop retrying i915_gem_execbuffer.

result was hanging X, overheating of cpu and 2-3gb of logfile-spam.

This patch adresses the issue by
 1. initializing vars in this file where necessary
 2. correcting wrongly interpreted return values of copy_[from/to]_user

Signed-off-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
---

On Mon, 2009-04-06 at 22:55 +0200, Florian Mickler wrote:
> [resent, because i got the lkml-adress wrong the first time]
> Hi Eric!
>=20
> To put this mail into context:
> http://bugs.freedesktop.org/show_bug.cgi?id=3D20985
>=20
> I finally poked a little bit at the code, since i figured you would be
> glad if i came up with something.
>=20
> I think I understood the problem and made a correct patch, but kernel
> is new territory for me. So please doublecheck if i made the correct
> choices for the error-returns.
>=20
> Can you make shure that this patch (if acceptable) goes into mainline?

Nice catch!  Thanks.  I did some cleanup that brings it more in line
with style elsewhere in the code and cuts some of the gratuitous looking
changes.  Would you be OK with these changes rolled into your original
diff?

 drivers/gpu/drm/i915/i915_gem.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_ge=
m.c
index 33ab07b..6f7d0e2 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -141,15 +141,18 @@ fast_shmem_read(struct page **pages,
 		int length)
 {
 	char __iomem *vaddr;
-	int ret;
+	int unwritten;
=20
 	vaddr =3D kmap_atomic(pages[page_base >> PAGE_SHIFT], KM_USER0);
 	if (vaddr =3D=3D NULL)
 		return -ENOMEM;
-	ret =3D __copy_to_user_inatomic(data, vaddr + page_offset, length);
+	unwritten =3D __copy_to_user_inatomic(data, vaddr + page_offset, length);
 	kunmap_atomic(vaddr, KM_USER0);
=20
-	return ret;
+	if (unwritten)
+		return -EFAULT;
+
+	return 0;
 }
=20
 static inline int
@@ -3000,13 +3003,13 @@ i915_gem_get_relocs_from_user(struct drm_i915_gem_e=
xec_object *exec_list,
 			drm_free(*relocs, reloc_count * sizeof(**relocs),
 				 DRM_MEM_DRIVER);
 			*relocs =3D NULL;
-			return ret;
+			return -EFAULT;
 		}
=20
 		reloc_index +=3D exec_list[i].relocation_count;
 	}
=20
-	return ret;
+	return 0;
 }
=20
 static int
@@ -3015,23 +3018,28 @@ i915_gem_put_relocs_to_user(struct drm_i915_gem_exe=
c_object *exec_list,
 			    struct drm_i915_gem_relocation_entry *relocs)
 {
 	uint32_t reloc_count =3D 0, i;
-	int ret;
+	int ret =3D 0;
=20
 	for (i =3D 0; i < buffer_count; i++) {
 		struct drm_i915_gem_relocation_entry __user *user_relocs;
+		int unwritten;
=20
 		user_relocs =3D (void __user *)(uintptr_t)exec_list[i].relocs_ptr;
=20
-		if (ret =3D=3D 0) {
-			ret =3D copy_to_user(user_relocs,
-					   &relocs[reloc_count],
-					   exec_list[i].relocation_count *
-					   sizeof(*relocs));
+		unwritten =3D copy_to_user(user_relocs,
+					 &relocs[reloc_count],
+					 exec_list[i].relocation_count *
+					 sizeof(*relocs));
+
+		if (unwritten) {
+			ret =3D -EFAULT;
+			goto err;
 		}
=20
 		reloc_count +=3D exec_list[i].relocation_count;
 	}
=20
+err:
 	drm_free(relocs, reloc_count * sizeof(*relocs), DRM_MEM_DRIVER);
=20
 	return ret;
@@ -3306,10 +3314,12 @@ err:
 				   (uintptr_t) args->buffers_ptr,
 				   exec_list,
 				   sizeof(*exec_list) * args->buffer_count);
-		if (ret)
+		if (ret) {
+			ret =3D -EFAULT;
 			DRM_ERROR("failed to copy %d exec entries "
 				  "back to user (%d)\n",
 				  args->buffer_count, ret);
+		}
 	}
=20
 	/* Copy the updated relocations out regardless of current error
--=20
1.6.2.1


--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-R2kuguacmS49uvEwtai3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknatIsACgkQHUdvYGzw6ve1QACcD8R0eejTSKpQmOOmDMn334+X
F8MAn2LwtF4eiK89jxc3I8D0z0MHNedb
=6zDD
-----END PGP SIGNATURE-----

--=-R2kuguacmS49uvEwtai3--
