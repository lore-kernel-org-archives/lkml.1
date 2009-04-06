Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZDFU4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZDFU4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZDFUz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:55:56 -0400
Received: from ist.d-labs.de ([213.239.218.44]:45406 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZDFUzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:55:55 -0400
Date: Mon, 6 Apr 2009 22:55:41 +0200
From: Florian Mickler <florian@mickler.org>
To: eric@anholt.net
Cc: LKML <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       airlied@linux.ie, keithp@keithp.com
Subject: Regression X Hangs at bootup -- PATCH
Message-ID: <20090406225541.0e1e043b@schatten>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nyZ8ahC0SlyCtpAi0Ki7Mqq";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nyZ8ahC0SlyCtpAi0Ki7Mqq
Content-Type: multipart/mixed; boundary="MP_/NJZbclDKFIWOOaZpL1uY4=y"

--MP_/NJZbclDKFIWOOaZpL1uY4=y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[resent, because i got the lkml-adress wrong the first time]
Hi Eric!

To put this mail into context:
http://bugs.freedesktop.org/show_bug.cgi?id=3D20985

I finally poked a little bit at the code, since i figured you would be
glad if i came up with something.

I think I understood the problem and made a correct patch, but kernel
is new territory for me. So please doublecheck if i made the correct
choices for the error-returns.

Can you make shure that this patch (if acceptable) goes into mainline?

Sincerely,
Florian


p.s.: does somebody know where the actual implementation of
copy_[from/to]_user for my core2duo @64bit is? it is a mistery!


--MP_/NJZbclDKFIWOOaZpL1uY4=y
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-Fix-use-of-uninitialized-var.patch

=46rom 95d4c8702dbd0bbc06291105c3fbfe1927b13f2d Mon Sep 17 00:00:00 2001
From: Florian Mickler <florian@mickler.org>
Date: Mon, 6 Apr 2009 21:35:33 +0200
Subject: [PATCH] Fix: use of uninitialized var

i915_gem_put_relocs_to_user returned an uninitialized value which
got returned to userspace. This caused libdrm in my setup to never
get out of a do{}while() loop retrying i915_gem_execbuffer.

result was hanging X, overheating of cpu and 2-3gb of logfile-spam.

This patch adresses the issue by
 1. initializing vars in this file where necessary
 2. correcting wrongly interpreted return values of
 copy_[from/to]_user

 Nr. 2  helps libdrm from getting out of its loop and Nr. 1 helps
 i915_gem_execbuffer to not think there was an error.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/gpu/drm/i915/i915_gem.c |   63 +++++++++++++++++++++++++----------=
---
 1 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_ge=
m.c
index 1449b45..99c01f5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -151,6 +151,7 @@ fast_shmem_read(struct page **pages,
 	ret =3D __copy_to_user_inatomic(data, vaddr + page_offset, length);
 	kunmap_atomic(vaddr, KM_USER0);
=20
+	/* return a number of bytes */
 	return ret;
 }
=20
@@ -2976,7 +2977,7 @@ i915_gem_get_relocs_from_user(struct drm_i915_gem_exe=
c_object *exec_list,
 			      struct drm_i915_gem_relocation_entry **relocs)
 {
 	uint32_t reloc_count =3D 0, reloc_index =3D 0, i;
-	int ret;
+	int ret =3D 0;
=20
 	*relocs =3D NULL;
 	for (i =3D 0; i < buffer_count; i++) {
@@ -3002,13 +3003,14 @@ i915_gem_get_relocs_from_user(struct drm_i915_gem_e=
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
+	/* success */
+	return 0;
 }
=20
 static int
@@ -3017,14 +3019,14 @@ i915_gem_put_relocs_to_user(struct drm_i915_gem_exe=
c_object *exec_list,
 			    struct drm_i915_gem_relocation_entry *relocs)
 {
 	uint32_t reloc_count =3D 0, i;
-	int ret;
+	int ret =3D 0;
=20
 	for (i =3D 0; i < buffer_count; i++) {
 		struct drm_i915_gem_relocation_entry __user *user_relocs;
=20
 		user_relocs =3D (void __user *)(uintptr_t)exec_list[i].relocs_ptr;
=20
-		if (ret =3D=3D 0) {
+		if ( ret =3D=3D 0) {
 			ret =3D copy_to_user(user_relocs,
 					   &relocs[reloc_count],
 					   exec_list[i].relocation_count *
@@ -3036,6 +3038,12 @@ i915_gem_put_relocs_to_user(struct drm_i915_gem_exec=
_object *exec_list,
=20
 	drm_free(relocs, reloc_count * sizeof(*relocs), DRM_MEM_DRIVER);
=20
+	/* copy_to_user returns a number of bytes */
+	if (ret !=3D 0) {
+		ret =3D -EFAULT;
+	}
+
+=09
 	return ret;
 }
=20
@@ -3052,11 +3060,14 @@ i915_gem_execbuffer(struct drm_device *dev, void *d=
ata,
 	struct drm_i915_gem_object *obj_priv;
 	struct drm_clip_rect *cliprects =3D NULL;
 	struct drm_i915_gem_relocation_entry *relocs;
-	int ret, ret2, i, pinned =3D 0;
+	int ret, error, i, pinned;
 	uint64_t exec_offset;
 	uint32_t seqno, flush_domains, reloc_index;
 	int pin_tries;
=20
+	error =3D 0;
+	pinned =3D 0;
+
 #if WATCH_EXEC
 	DRM_INFO("buffers_ptr %d buffer_count %d len %08x\n",
 		  (int) args->buffers_ptr, args->buffer_count, args->batch_len);
@@ -3075,7 +3086,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *dat=
a,
 		DRM_ERROR("Failed to allocate exec or object list "
 			  "for %d buffers\n",
 			  args->buffer_count);
-		ret =3D -ENOMEM;
+		error =3D -ENOMEM;
 		goto pre_mutex_err;
 	}
 	ret =3D copy_from_user(exec_list,
@@ -3085,6 +3096,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *dat=
a,
 	if (ret !=3D 0) {
 		DRM_ERROR("copy %d exec entries failed %d\n",
 			  args->buffer_count, ret);
+		error =3D ret;
 		goto pre_mutex_err;
 	}
=20
@@ -3101,15 +3113,17 @@ i915_gem_execbuffer(struct drm_device *dev, void *d=
ata,
 		if (ret !=3D 0) {
 			DRM_ERROR("copy %d cliprects failed: %d\n",
 				  args->num_cliprects, ret);
+			error =3D ret;
 			goto pre_mutex_err;
 		}
 	}
=20
 	ret =3D i915_gem_get_relocs_from_user(exec_list, args->buffer_count,
 					    &relocs);
-	if (ret !=3D 0)
+	if (ret !=3D 0) {
+		error =3D ret;
 		goto pre_mutex_err;
-
+	}
 	mutex_lock(&dev->struct_mutex);
=20
 	i915_verify_inactive(dev, __FILE__, __LINE__);
@@ -3117,14 +3131,14 @@ i915_gem_execbuffer(struct drm_device *dev, void *d=
ata,
 	if (dev_priv->mm.wedged) {
 		DRM_ERROR("Execbuf while wedged\n");
 		mutex_unlock(&dev->struct_mutex);
-		ret =3D -EIO;
+		error =3D -EIO;
 		goto pre_mutex_err;
 	}
=20
 	if (dev_priv->mm.suspended) {
 		DRM_ERROR("Execbuf while VT-switched.\n");
 		mutex_unlock(&dev->struct_mutex);
-		ret =3D -EBUSY;
+		error =3D -EBUSY;
 		goto pre_mutex_err;
 	}
=20
@@ -3135,7 +3149,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *dat=
a,
 		if (object_list[i] =3D=3D NULL) {
 			DRM_ERROR("Invalid object handle %d at index %d\n",
 				   exec_list[i].handle, i);
-			ret =3D -EBADF;
+			error =3D -EBADF;
 			goto err;
 		}
=20
@@ -3143,7 +3157,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *dat=
a,
 		if (obj_priv->in_execbuffer) {
 			DRM_ERROR("Object %p appears more than once in object list\n",
 				   object_list[i]);
-			ret =3D -EBADF;
+			error =3D -EBADF;
 			goto err;
 		}
 		obj_priv->in_execbuffer =3D true;
@@ -3174,6 +3188,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *dat=
a,
 		if (ret !=3D -ENOMEM || pin_tries >=3D 1) {
 			if (ret !=3D -ERESTARTSYS)
 				DRM_ERROR("Failed to pin buffers %d\n", ret);
+			error =3D ret;
 			goto err;
 		}
=20
@@ -3184,8 +3199,10 @@ i915_gem_execbuffer(struct drm_device *dev, void *da=
ta,
=20
 		/* evict everyone we can from the aperture */
 		ret =3D i915_gem_evict_everything(dev);
-		if (ret)
+		if (ret){
+			error =3D ret;
 			goto err;
+		}
 	}
=20
 	/* Set the pending read domains for the batch buffer to COMMAND */
@@ -3253,6 +3270,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *dat=
a,
 	ret =3D i915_dispatch_gem_execbuffer(dev, args, cliprects, exec_offset);
 	if (ret) {
 		DRM_ERROR("dispatch failed %d\n", ret);
+		error =3D ret;
 		goto err;
 	}
=20
@@ -3308,10 +3326,12 @@ err:
 				   (uintptr_t) args->buffers_ptr,
 				   exec_list,
 				   sizeof(*exec_list) * args->buffer_count);
-		if (ret)
+		if (ret) {
+			error =3D -EFAULT;
 			DRM_ERROR("failed to copy %d exec entries "
 				  "back to user (%d)\n",
 				  args->buffer_count, ret);
+		}
 	}
=20
 	/* Copy the updated relocations out regardless of current error
@@ -3319,13 +3339,12 @@ err:
 	 * time userland calls execbuf, it would do so with presumed offset
 	 * state that didn't match the actual object state.
 	 */
-	ret2 =3D i915_gem_put_relocs_to_user(exec_list, args->buffer_count,
+	ret =3D i915_gem_put_relocs_to_user(exec_list, args->buffer_count,
 					   relocs);
-	if (ret2 !=3D 0) {
-		DRM_ERROR("Failed to copy relocations back out: %d\n", ret2);
-
-		if (ret =3D=3D 0)
-			ret =3D ret2;
+	if (ret !=3D 0) {
+		DRM_ERROR("Failed to copy relocations back out\n");
+		if (error =3D=3D 0)
+			error =3D ret;
 	}
=20
 pre_mutex_err:
@@ -3336,7 +3355,7 @@ pre_mutex_err:
 	drm_free(cliprects, sizeof(*cliprects) * args->num_cliprects,
 		 DRM_MEM_DRIVER);
=20
-	return ret;
+	return error;
 }
=20
 int
--=20
1.6.2


--MP_/NJZbclDKFIWOOaZpL1uY4=y--

--Sig_/nyZ8ahC0SlyCtpAi0Ki7Mqq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAknabFIACgkQPjqCkyL3Kv0GcQCaA/d6mw9YHvjAI4DIuwnswu18
6e4AoNJGK2w8tk2Q5diV315Ceogp+jpo
=y0T8
-----END PGP SIGNATURE-----

--Sig_/nyZ8ahC0SlyCtpAi0Ki7Mqq--
