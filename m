Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbZDGUO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbZDGUO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbZDGUOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:14:49 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56811 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZDGUOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:14:48 -0400
Date: Tue, 7 Apr 2009 22:14:25 +0200
From: Florian Mickler <florian@mickler.org>
To: Eric Anholt <eric@anholt.net>
Cc: LKML <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       airlied@linux.ie, keithp@keithp.com
Subject: Re: Regression X Hangs at bootup -- PATCH
Message-ID: <20090407221425.3dc1831e@schatten>
In-Reply-To: <1239121300.9617.0.camel@gaiman.anholt.net>
References: <20090406225541.0e1e043b@schatten>
 <1239069835.31656.109.camel@gaiman.anholt.net>
 <20090407092346.058d19a0@schatten>
 <1239121300.9617.0.camel@gaiman.anholt.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/givvn22dMoYJw+=vvpTkTeG";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/givvn22dMoYJw+=vvpTkTeG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Apr 2009 09:21:40 -0700
Eric Anholt <eric@anholt.net> wrote:


> drm_free's other arguments are unused memory debug leftovers.  I've
> got a patch I need to push at airlied to remove
> drm_malloc/drm_calloc/drm_free.
>=20
in that case it is of course a non issue. but would you mind=20
to add a note like 'this adds a memleak to i915_gem_put_relocs_to_user
which will be fixed in a followup patch', or just rebase it onto that
patch?=20

anyhow, below patch is what i'm currently running.. if you rebase
the other version onto that patch of your's removing the
allocation thats fine too. if not, probably ok too. it's just that i
have too much time to care about this :)

sincerely,

Florian


p.s.: thx for doing this great work!=20

=46rom 868c938874d66aa3e507d8312cefc7730487f442 Mon Sep 17 00:00:00 2001
From: Florian Mickler <florian@mickler.org>
Date: Tue, 7 Apr 2009 18:41:32 +0200
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
 drivers/gpu/drm/i915/i915_gem.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c
b/drivers/gpu/drm/i915/i915_gem.c index 1449b45..e73844a 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -143,15 +143,18 @@ fast_shmem_read(struct page **pages,
 		int length)
 {
 	char __iomem *vaddr;
-	int ret;
+	int unwritten;
=20
 	vaddr =3D kmap_atomic(pages[page_base >> PAGE_SHIFT], KM_USER0);
 	if (vaddr =3D=3D NULL)
 		return -ENOMEM;
-	ret =3D __copy_to_user_inatomic(data, vaddr + page_offset,
length);
+	unwritten =3D __copy_to_user_inatomic(data, vaddr + page_offset,
length); kunmap_atomic(vaddr, KM_USER0);
=20
-	return ret;
+	if (unwritten)
+		return -EFAULT;
+
+	return 0;
 }
=20
 static inline int
@@ -3002,13 +3005,13 @@ i915_gem_get_relocs_from_user(struct
drm_i915_gem_exec_object *exec_list, drm_free(*relocs, reloc_count *
sizeof(**relocs), DRM_MEM_DRIVER);
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
@@ -3017,7 +3020,7 @@ i915_gem_put_relocs_to_user(struct
drm_i915_gem_exec_object *exec_list, struct
drm_i915_gem_relocation_entry *relocs) {
 	uint32_t reloc_count =3D 0, i;
-	int ret;
+	int ret =3D 0;
=20
 	for (i =3D 0; i < buffer_count; i++) {
 		struct drm_i915_gem_relocation_entry __user
*user_relocs; @@ -3036,6 +3039,9 @@ i915_gem_put_relocs_to_user(struct
drm_i915_gem_exec_object *exec_list,=20
 	drm_free(relocs, reloc_count * sizeof(*relocs),
DRM_MEM_DRIVER);=20
+	if (ret !=3D 0)
+		ret =3D -EFAULT;
+
 	return ret;
 }
=20
@@ -3308,10 +3314,12 @@ err:
 				   (uintptr_t) args->buffers_ptr,
 				   exec_list,
 				   sizeof(*exec_list) *
args->buffer_count);
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
1.6.2


--Sig_/givvn22dMoYJw+=vvpTkTeG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAknbtCYACgkQPjqCkyL3Kv3vXwCfUqiHs/7CkuvnV3fgV/jXI+Ys
WkoAmwdGv+DG+niY3lWGuXit+suZHKhz
=uf+i
-----END PGP SIGNATURE-----

--Sig_/givvn22dMoYJw+=vvpTkTeG--
