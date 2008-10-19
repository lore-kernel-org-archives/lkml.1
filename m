Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbYJSGmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbYJSGmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 02:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYJSGlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 02:41:53 -0400
Received: from home.keithp.com ([63.227.221.253]:54297 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYJSGlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 02:41:52 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1224389697.4384.118.camel@koto.keithp.com>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pCTThlF6EyakBo+fgDPk"
Date: Sat, 18 Oct 2008 23:41:36 -0700
Message-Id: <1224398496.5303.7.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pCTThlF6EyakBo+fgDPk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-18 at 21:14 -0700, Keith Packard wrote:
> On Sun, 2008-10-19 at 00:32 +0200, Ingo Molnar wrote:
>=20
> > Mind sending patches for this? :-)

Here's a patch for the i915 driver that includes the new API. Tested on
x86_32+HIGHMEM and x86_64. I stuck a new 'io_reserve.h' header in the
i915 directory for this patch, but it should go elsewhere.

The new APIs are:

io_reserve_create_wc
io_reserve_free
io_reserve_map_atomic_wc
io_reserve_unmap_atomic
io_reserve_map_wc
io_reserve_unmap

I added the non-atomic variants at Eric's suggestion so that we can use
the direct map on x86_64, avoiding any use of ioremap at run-time. I
think the resulting code looks quite a bit cleaner now. Also, one
benchmark I tried ran about 18 times faster in 64-bit mode than the
original code.

=46rom 2f6b125cb586a0671a2b9c22aadb03fcafdf99ab Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@taka.keithp.com>
Date: Sat, 18 Oct 2008 22:59:58 -0700
Subject: [PATCH] [drm/i915] Create new 'io_reserve' API for mapping GTT pag=
es

The io_reserve API abstracts away the operations necessary to construct
mappings for our GTT aperture, providing atomic and non-atomic mappings for
GTT pages that work efficiently on x86_64 and x86_32+HIGHMEM configurations=
.

This eliminates the in-drive abuse of the kmap_atomic_pfn function as well
as improving GEM performance on x86_64 architecture.

Signed-off-by: Keith Packard <keithp@taka.keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.h   |    3 +
 drivers/gpu/drm/i915/i915_gem.c   |   71 ++++++++++++----------
 drivers/gpu/drm/i915/i915_irq.c   |    4 +-
 drivers/gpu/drm/i915/io_reserve.h |  122 +++++++++++++++++++++++++++++++++=
++++
 4 files changed, 165 insertions(+), 35 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/io_reserve.h

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index f20ffe1..c99b9ea 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -31,6 +31,7 @@
 #define _I915_DRV_H_
=20
 #include "i915_reg.h"
+#include "io_reserve.h"
=20
 /* General customization:
  */
@@ -246,6 +247,8 @@ typedef struct drm_i915_private {
 	struct {
 		struct drm_mm gtt_space;
=20
+		struct io_reserve *io_reserve;
+
 		/**
 		 * List of objects currently involved in rendering from the
 		 * ringbuffer.
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_ge=
m.c
index 9255088..cd9e489 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -177,14 +177,14 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct dr=
m_gem_object *obj,
 		    struct drm_file *file_priv)
 {
 	struct drm_i915_gem_object *obj_priv =3D obj->driver_private;
+	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	ssize_t remain;
-	loff_t offset;
+	loff_t offset, base;
 	char __user *user_data;
 	char __iomem *vaddr;
 	char *vaddr_atomic;
-	int i, o, l;
+	int o, l;
 	int ret =3D 0;
-	unsigned long pfn;
 	unsigned long unwritten;
=20
 	user_data =3D (char __user *) (uintptr_t) args->data_ptr;
@@ -211,42 +211,41 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct dr=
m_gem_object *obj,
 	while (remain > 0) {
 		/* Operation in this page
 		 *
-		 * i =3D page number
+		 * base =3D page offset within aperture
 		 * o =3D offset within page
 		 * l =3D bytes to copy
 		 */
-		i =3D offset >> PAGE_SHIFT;
+		base =3D (offset & ~(PAGE_SIZE-1));
 		o =3D offset & (PAGE_SIZE-1);
 		l =3D remain;
 		if ((o + l) > PAGE_SIZE)
 			l =3D PAGE_SIZE - o;
=20
-		pfn =3D (dev->agp->base >> PAGE_SHIFT) + i;
-
-#ifdef CONFIG_HIGHMEM
 		/* This is a workaround for the low performance of iounmap
 		 * (approximate 10% cpu cost on normal 3D workloads).
-		 * kmap_atomic on HIGHMEM kernels happens to let us map card
-		 * memory without taking IPIs.  When the vmap rework lands
-		 * we should be able to dump this hack.
+		 * io_reserve_map_atomic_wc maps card memory
+		 * without taking IPIs.
+		 */
+		vaddr_atomic =3D io_reserve_map_atomic_wc(dev_priv->mm.io_reserve,
+							base);
+		if (vaddr_atomic) {
+			unwritten =3D __copy_from_user_inatomic_nocache(vaddr_atomic + o,
+								      user_data, l);
+			io_reserve_unmap_atomic(vaddr_atomic);
+		} else
+			unwritten =3D l;
+		=09
+		/* If we get a fault while copying data, then (presumably) our
+		 * source page isn't available. In this case, use the
+		 * non-atomic __copy_from_user function
 		 */
-		vaddr_atomic =3D kmap_atomic_pfn(pfn, KM_USER0);
-#if WATCH_PWRITE
-		DRM_INFO("pwrite i %d o %d l %d pfn %ld vaddr %p\n",
-			 i, o, l, pfn, vaddr_atomic);
-#endif
-		unwritten =3D __copy_from_user_inatomic_nocache(vaddr_atomic + o,
-							      user_data, l);
-		kunmap_atomic(vaddr_atomic, KM_USER0);
-
 		if (unwritten)
-#endif /* CONFIG_HIGHMEM */
 		{
-			vaddr =3D ioremap_wc(pfn << PAGE_SHIFT, PAGE_SIZE);
+			vaddr =3D io_reserve_map_wc(dev_priv->mm.io_reserve, base);
 #if WATCH_PWRITE
-			DRM_INFO("pwrite slow i %d o %d l %d "
-				 "pfn %ld vaddr %p\n",
-				 i, o, l, pfn, vaddr);
+			DRM_INFO("pwrite slow base %ld o %d l %d "
+				 "vaddr %p\n",
+				 base, o, l, vaddr);
 #endif
 			if (vaddr =3D=3D NULL) {
 				ret =3D -EFAULT;
@@ -256,7 +255,7 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_=
gem_object *obj,
 #if WATCH_PWRITE
 			DRM_INFO("unwritten %ld\n", unwritten);
 #endif
-			iounmap(vaddr);
+			io_reserve_unmap(vaddr);
 			if (unwritten) {
 				ret =3D -EFAULT;
 				goto fail;
@@ -1489,6 +1488,7 @@ i915_gem_object_pin_and_relocate(struct drm_gem_objec=
t *obj,
 				 struct drm_i915_gem_exec_object *entry)
 {
 	struct drm_device *dev =3D obj->dev;
+	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	struct drm_i915_gem_relocation_entry reloc;
 	struct drm_i915_gem_relocation_entry __user *relocs;
 	struct drm_i915_gem_object *obj_priv =3D obj->driver_private;
@@ -1621,12 +1621,11 @@ i915_gem_object_pin_and_relocate(struct drm_gem_obj=
ect *obj,
 		    (last_reloc_offset & ~(PAGE_SIZE - 1)) !=3D
 		    (reloc_offset & ~(PAGE_SIZE - 1))) {
 			if (reloc_page !=3D NULL)
-				iounmap(reloc_page);
+				io_reserve_unmap(reloc_page);
=20
-			reloc_page =3D ioremap_wc(dev->agp->base +
-						(reloc_offset &
-						 ~(PAGE_SIZE - 1)),
-						PAGE_SIZE);
+			reloc_page =3D io_reserve_map_wc(dev_priv->mm.io_reserve,
+						       (reloc_offset &=20
+							~(PAGE_SIZE - 1)));
 			last_reloc_offset =3D reloc_offset;
 			if (reloc_page =3D=3D NULL) {
 				drm_gem_object_unreference(target_obj);
@@ -1636,7 +1635,7 @@ i915_gem_object_pin_and_relocate(struct drm_gem_objec=
t *obj,
 		}
=20
 		reloc_entry =3D (uint32_t __iomem *)(reloc_page +
-					   (reloc_offset & (PAGE_SIZE - 1)));
+						   (reloc_offset & (PAGE_SIZE - 1)));
 		reloc_val =3D target_obj_priv->gtt_offset + reloc.delta;
=20
 #if WATCH_BUF
@@ -1661,7 +1660,7 @@ i915_gem_object_pin_and_relocate(struct drm_gem_objec=
t *obj,
 	}
=20
 	if (reloc_page !=3D NULL)
-		iounmap(reloc_page);
+		io_reserve_unmap(reloc_page);
=20
 #if WATCH_BUF
 	if (0)
@@ -2504,6 +2503,10 @@ i915_gem_entervt_ioctl(struct drm_device *dev, void =
*data,
 	if (ret !=3D 0)
 		return ret;
=20
+	dev_priv->mm.io_reserve =3D io_reserve_create_wc(dev->agp->base,
+						       dev->agp->agp_info.aper_size
+						       * 1024 * 1024);
+
 	mutex_lock(&dev->struct_mutex);
 	BUG_ON(!list_empty(&dev_priv->mm.active_list));
 	BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
@@ -2521,11 +2524,13 @@ int
 i915_gem_leavevt_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv)
 {
+	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	int ret;
=20
 	ret =3D i915_gem_idle(dev);
 	drm_irq_uninstall(dev);
=20
+	io_reserve_free(dev_priv->mm.io_reserve);
 	return ret;
 }
=20
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index ce866ac..de8e084 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -784,8 +784,8 @@ int i915_vblank_swap(struct drm_device *dev, void *data=
,
 	if (dev_priv->swaps_pending >=3D 10) {
 		DRM_DEBUG("Too many swaps queued\n");
 		DRM_DEBUG(" pipe 0: %d pipe 1: %d\n",
-			  drm_vblank_count(dev, 0);
-			  drm_vblank_count(dev, 1);
+			  drm_vblank_count(dev, 0),
+			  drm_vblank_count(dev, 1));
=20
 		list_for_each(list, &dev_priv->vbl_swaps.head) {
 			vbl_old =3D list_entry(list, drm_i915_vbl_swap_t, head);
diff --git a/drivers/gpu/drm/i915/io_reserve.h b/drivers/gpu/drm/i915/io_re=
serve.h
new file mode 100644
index 0000000..4e90a36
--- /dev/null
+++ b/drivers/gpu/drm/i915/io_reserve.h
@@ -0,0 +1,122 @@
+/*
+ * Copyright =C2=A9 2008 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software=
"),
+ * to deal in the Software without restriction, including without limitati=
on
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense=
,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the ne=
xt
+ * paragraph) shall be included in all copies or substantial portions of t=
he
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS=
 OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY=
,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHAL=
L
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OT=
HER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEA=
LINGS
+ * IN THE SOFTWARE.
+ *
+ * Authors:
+ *    Keith Packard <keithp@keithp.com>
+ *
+ */
+/* x86_64 style */
+
+#ifndef _IO_RESERVE_H_
+#define _IO_RESERVE_H_
+
+/* this struct isn't actually defined anywhere */
+struct io_reserve;
+
+#ifdef CONFIG_X86_64
+
+/* Create the io_reserve object*/
+static inline struct io_reserve *
+io_reserve_create_wc(unsigned long base, unsigned long size)
+{
+	return (struct io_reserve *) ioremap_wc(base, size);
+}
+
+static inline void
+io_reserve_free(struct io_reserve *reserve)
+{
+	iounmap(reserve);
+}
+
+/* Atomic map/unmap */
+static inline void *
+io_reserve_map_atomic_wc(struct io_reserve *reserve, unsigned long offset)
+{
+	return ((char *) reserve) + offset;
+}
+
+static inline void
+io_reserve_unmap_atomic(void *vaddr)
+{
+}
+
+/* Non-atomic map/unmap */
+static inline void *
+io_reserve_map_wc(struct io_reserve *reserve, unsigned long offset)
+{
+	return ((char *) reserve) + offset;
+}
+
+static inline void
+io_reserve_unmap(void *vaddr)
+{
+}
+
+#endif /* CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_32
+static inline struct io_reserve *
+io_reserve_create_wc(unsigned long base, unsigned long size)
+{
+	return (struct io_reserve *) base;
+}
+
+static inline void
+io_reserve_free(struct io_reserve *reserve)
+{
+}
+
+/* Atomic map/unmap */
+static inline void *
+io_reserve_map_atomic_wc(struct io_reserve *reserve, unsigned long offset)
+{
+#ifdef CONFIG_HIGHMEM
+	offset +=3D (unsigned long) reserve;
+	return kmap_atomic_pfn(offset >> PAGE_SHIFT, KM_USER0);
+#else
+	return NULL;
+#endif
+}
+
+static inline void
+io_reserve_unmap_atomic(void *vaddr)
+{
+#ifdef CONFIG_HIGHMEM
+	kunmap_atomic(vaddr, KM_USER0);
+#endif
+}
+
+static inline void *
+io_reserve_map_wc(struct io_reserve *reserve, unsigned long offset)
+{
+	offset +=3D (unsigned long) reserve;
+	return ioremap_wc(offset, PAGE_SIZE);
+}
+
+static inline void
+io_reserve_unmap(void *vaddr)
+{
+	iounmap(vaddr);
+}
+#endif /* CONFIG_X86_32 */
+
+#endif /* _IO_RESERVE_H_ */
--=20
1.5.6.5



--=20
keith.packard@intel.com

--=-pCTThlF6EyakBo+fgDPk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+tadQp8BWwlsTdMRAi2NAJ0WaACGMoFh4ZBpJnCJZgmwxyq2nQCgqtl3
kJAmmFx09I6KZc1Sw2GH10Y=
=wTyv
-----END PGP SIGNATURE-----

--=-pCTThlF6EyakBo+fgDPk--

