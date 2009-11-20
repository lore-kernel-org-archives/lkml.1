Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZKTNaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZKTNaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZKTNaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:30:23 -0500
Received: from nox.protox.org ([88.191.38.29]:47416 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbZKTN3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:29:43 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 2/3] drm/radeon/kms: Rework radeon object handling
Date: Fri, 20 Nov 2009 14:29:23 +0100
Message-Id: <1258723764-4399-3-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258723764-4399-2-git-send-email-jglisse@redhat.com>
References: <1258723764-4399-1-git-send-email-jglisse@redhat.com>
 <1258723764-4399-2-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locking & protection of radeon object was somewhat messy.
This patch completely rework it to now use ttm reserve as a
protection for the radeon object structure member. It also
shrink down the various radeon object structure by removing
field which were redondant with the ttm information. Last it
converts few simple functions to inline which should with
performances.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c      |   30 +-
 drivers/gpu/drm/radeon/r100.c               |   90 +++--
 drivers/gpu/drm/radeon/r100_track.h         |   10 +-
 drivers/gpu/drm/radeon/r300.c               |   15 +-
 drivers/gpu/drm/radeon/r420.c               |    4 +-
 drivers/gpu/drm/radeon/r520.c               |    2 +-
 drivers/gpu/drm/radeon/r600.c               |   65 +++-
 drivers/gpu/drm/radeon/r600_blit_kms.c      |   30 +-
 drivers/gpu/drm/radeon/radeon.h             |  111 +++---
 drivers/gpu/drm/radeon/radeon_benchmark.c   |   36 ++-
 drivers/gpu/drm/radeon/radeon_cs.c          |   13 +-
 drivers/gpu/drm/radeon/radeon_device.c      |   16 +-
 drivers/gpu/drm/radeon/radeon_fb.c          |   63 ++--
 drivers/gpu/drm/radeon/radeon_gart.c        |   42 ++-
 drivers/gpu/drm/radeon/radeon_gem.c         |   90 +++---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |   27 +-
 drivers/gpu/drm/radeon/radeon_object.c      |  538 +++++++++++----------------
 drivers/gpu/drm/radeon/radeon_object.h      |  157 +++++++-
 drivers/gpu/drm/radeon/radeon_ring.c        |   67 ++--
 drivers/gpu/drm/radeon/radeon_test.c        |   55 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c         |   36 ++-
 drivers/gpu/drm/radeon/rs400.c              |    4 +-
 drivers/gpu/drm/radeon/rs600.c              |   15 +-
 drivers/gpu/drm/radeon/rs690.c              |    4 +-
 drivers/gpu/drm/radeon/rv515.c              |    6 +-
 drivers/gpu/drm/radeon/rv770.c              |   30 ++-
 26 files changed, 873 insertions(+), 683 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index c15287a..80d7f46 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -574,21 +574,31 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_framebuffer *radeon_fb;
 	struct drm_gem_object *obj;
-	struct drm_radeon_gem_object *obj_priv;
+	struct radeon_bo *rbo;
 	uint64_t fb_location;
 	uint32_t fb_format, fb_pitch_pixels, tiling_flags;
+	int r;
 
 	if (!crtc->fb)
 		return -EINVAL;
 
 	radeon_fb = to_radeon_framebuffer(crtc->fb);
 
+	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
-	obj_priv = obj->driver_private;
-
-	if (radeon_gem_object_pin(obj, RADEON_GEM_DOMAIN_VRAM, &fb_location)) {
+	rbo = obj->driver_private;
+	r = radeon_bo_reserve(rbo, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &fb_location);
+	if (unlikely(r != 0)) {
+		radeon_bo_unreserve(rbo);
 		return -EINVAL;
 	}
+	radeon_bo_get_tiling_flags(rbo, &tiling_flags, NULL);
+	radeon_bo_unreserve(rbo);
+	if (tiling_flags & RADEON_TILING_MACRO)
+		fb_format |= AVIVO_D1GRPH_MACRO_ADDRESS_MODE;
 
 	switch (crtc->fb->bits_per_pixel) {
 	case 8:
@@ -618,11 +628,6 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 		return -EINVAL;
 	}
 
-	radeon_object_get_tiling_flags(obj->driver_private,
-				       &tiling_flags, NULL);
-	if (tiling_flags & RADEON_TILING_MACRO)
-		fb_format |= AVIVO_D1GRPH_MACRO_ADDRESS_MODE;
-
 	if (tiling_flags & RADEON_TILING_MICRO)
 		fb_format |= AVIVO_D1GRPH_TILED;
 
@@ -674,7 +679,12 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 	if (old_fb && old_fb != crtc->fb) {
 		radeon_fb = to_radeon_framebuffer(old_fb);
-		radeon_gem_object_unpin(radeon_fb->obj);
+		rbo = radeon_fb->obj->driver_private;
+		r = radeon_bo_reserve(rbo, false);
+		if (unlikely(r != 0))
+			return r;
+		radeon_bo_unpin(rbo);
+		radeon_bo_unreserve(rbo);
 	}
 
 	/* Bytes per pixel may have changed */
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 5e821a3..5b83583 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -255,24 +255,27 @@ int r100_wb_init(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->wb.wb_obj == NULL) {
-		r = radeon_object_create(rdev, NULL, RADEON_GPU_PAGE_SIZE,
-					 true,
-					 RADEON_GEM_DOMAIN_GTT,
-					 false, &rdev->wb.wb_obj);
+		r = radeon_bo_create(rdev, NULL, RADEON_GPU_PAGE_SIZE, true,
+					RADEON_GEM_DOMAIN_GTT,
+					&rdev->wb.wb_obj);
 		if (r) {
-			DRM_ERROR("radeon: failed to create WB buffer (%d).\n", r);
+			dev_err(rdev->dev, "(%d) create WB buffer failed\n", r);
 			return r;
 		}
-		r = radeon_object_pin(rdev->wb.wb_obj,
-				      RADEON_GEM_DOMAIN_GTT,
-				      &rdev->wb.gpu_addr);
+		r = radeon_bo_reserve(rdev->wb.wb_obj, false);
+		if (unlikely(r != 0))
+			return r;
+		r = radeon_bo_pin(rdev->wb.wb_obj, RADEON_GEM_DOMAIN_GTT,
+					&rdev->wb.gpu_addr);
 		if (r) {
-			DRM_ERROR("radeon: failed to pin WB buffer (%d).\n", r);
+			dev_err(rdev->dev, "(%d) pin WB buffer failed\n", r);
+			radeon_bo_unreserve(rdev->wb.wb_obj);
 			return r;
 		}
-		r = radeon_object_kmap(rdev->wb.wb_obj, (void **)&rdev->wb.wb);
+		r = radeon_bo_kmap(rdev->wb.wb_obj, (void **)&rdev->wb.wb);
+		radeon_bo_unreserve(rdev->wb.wb_obj);
 		if (r) {
-			DRM_ERROR("radeon: failed to map WB buffer (%d).\n", r);
+			dev_err(rdev->dev, "(%d) map WB buffer failed\n", r);
 			return r;
 		}
 	}
@@ -290,11 +293,19 @@ void r100_wb_disable(struct radeon_device *rdev)
 
 void r100_wb_fini(struct radeon_device *rdev)
 {
+	int r;
+
 	r100_wb_disable(rdev);
 	if (rdev->wb.wb_obj) {
-		radeon_object_kunmap(rdev->wb.wb_obj);
-		radeon_object_unpin(rdev->wb.wb_obj);
-		radeon_object_unref(&rdev->wb.wb_obj);
+		r = radeon_bo_reserve(rdev->wb.wb_obj, false);
+		if (unlikely(r != 0)) {
+			dev_err(rdev->dev, "(%d) can't finish WB\n", r);
+			return;
+		}
+		radeon_bo_kunmap(rdev->wb.wb_obj);
+		radeon_bo_unpin(rdev->wb.wb_obj);
+		radeon_bo_unreserve(rdev->wb.wb_obj);
+		radeon_bo_unref(&rdev->wb.wb_obj);
 		rdev->wb.wb = NULL;
 		rdev->wb.wb_obj = NULL;
 	}
@@ -1288,17 +1299,17 @@ static int r100_packet0_check(struct radeon_cs_parser *p,
 
 int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
 					 struct radeon_cs_packet *pkt,
-					 struct radeon_object *robj)
+					 struct radeon_bo *robj)
 {
 	unsigned idx;
 	u32 value;
 	idx = pkt->idx + 1;
 	value = radeon_get_ib_value(p, idx + 2);
-	if ((value + 1) > radeon_object_size(robj)) {
+	if ((value + 1) > radeon_bo_size(robj)) {
 		DRM_ERROR("[drm] Buffer too small for PACKET3 INDX_BUFFER "
 			  "(need %u have %lu) !\n",
 			  value + 1,
-			  radeon_object_size(robj));
+			  radeon_bo_size(robj));
 		return -EINVAL;
 	}
 	return 0;
@@ -2580,7 +2591,7 @@ static int r100_cs_track_cube(struct radeon_device *rdev,
 			      struct r100_cs_track *track, unsigned idx)
 {
 	unsigned face, w, h;
-	struct radeon_object *cube_robj;
+	struct radeon_bo *cube_robj;
 	unsigned long size;
 
 	for (face = 0; face < 5; face++) {
@@ -2593,9 +2604,9 @@ static int r100_cs_track_cube(struct radeon_device *rdev,
 
 		size += track->textures[idx].cube_info[face].offset;
 
-		if (size > radeon_object_size(cube_robj)) {
+		if (size > radeon_bo_size(cube_robj)) {
 			DRM_ERROR("Cube texture offset greater than object size %lu %lu\n",
-				  size, radeon_object_size(cube_robj));
+				  size, radeon_bo_size(cube_robj));
 			r100_cs_track_texture_print(&track->textures[idx]);
 			return -1;
 		}
@@ -2606,7 +2617,7 @@ static int r100_cs_track_cube(struct radeon_device *rdev,
 static int r100_cs_track_texture_check(struct radeon_device *rdev,
 				       struct r100_cs_track *track)
 {
-	struct radeon_object *robj;
+	struct radeon_bo *robj;
 	unsigned long size;
 	unsigned u, i, w, h;
 	int ret;
@@ -2662,9 +2673,9 @@ static int r100_cs_track_texture_check(struct radeon_device *rdev,
 				  "%u\n", track->textures[u].tex_coord_type, u);
 			return -EINVAL;
 		}
-		if (size > radeon_object_size(robj)) {
+		if (size > radeon_bo_size(robj)) {
 			DRM_ERROR("Texture of unit %u needs %lu bytes but is "
-				  "%lu\n", u, size, radeon_object_size(robj));
+				  "%lu\n", u, size, radeon_bo_size(robj));
 			r100_cs_track_texture_print(&track->textures[u]);
 			return -EINVAL;
 		}
@@ -2686,10 +2697,10 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 		}
 		size = track->cb[i].pitch * track->cb[i].cpp * track->maxy;
 		size += track->cb[i].offset;
-		if (size > radeon_object_size(track->cb[i].robj)) {
+		if (size > radeon_bo_size(track->cb[i].robj)) {
 			DRM_ERROR("[drm] Buffer too small for color buffer %d "
 				  "(need %lu have %lu) !\n", i, size,
-				  radeon_object_size(track->cb[i].robj));
+				  radeon_bo_size(track->cb[i].robj));
 			DRM_ERROR("[drm] color buffer %d (%u %u %u %u)\n",
 				  i, track->cb[i].pitch, track->cb[i].cpp,
 				  track->cb[i].offset, track->maxy);
@@ -2703,10 +2714,10 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 		}
 		size = track->zb.pitch * track->zb.cpp * track->maxy;
 		size += track->zb.offset;
-		if (size > radeon_object_size(track->zb.robj)) {
+		if (size > radeon_bo_size(track->zb.robj)) {
 			DRM_ERROR("[drm] Buffer too small for z buffer "
 				  "(need %lu have %lu) !\n", size,
-				  radeon_object_size(track->zb.robj));
+				  radeon_bo_size(track->zb.robj));
 			DRM_ERROR("[drm] zbuffer (%u %u %u %u)\n",
 				  track->zb.pitch, track->zb.cpp,
 				  track->zb.offset, track->maxy);
@@ -2724,11 +2735,12 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 					  "bound\n", prim_walk, i);
 				return -EINVAL;
 			}
-			if (size > radeon_object_size(track->arrays[i].robj)) {
-				DRM_ERROR("(PW %u) Vertex array %u need %lu dwords "
-					   "have %lu dwords\n", prim_walk, i,
-					   size >> 2,
-					   radeon_object_size(track->arrays[i].robj) >> 2);
+			if (size > radeon_bo_size(track->arrays[i].robj)) {
+				dev_err(rdev->dev, "(PW %u) Vertex array %u "
+					"need %lu dwords have %lu dwords\n",
+					prim_walk, i, size >> 2,
+					radeon_bo_size(track->arrays[i].robj)
+					>> 2);
 				DRM_ERROR("Max indices %u\n", track->max_indx);
 				return -EINVAL;
 			}
@@ -2742,10 +2754,12 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 					  "bound\n", prim_walk, i);
 				return -EINVAL;
 			}
-			if (size > radeon_object_size(track->arrays[i].robj)) {
-				DRM_ERROR("(PW %u) Vertex array %u need %lu dwords "
-					   "have %lu dwords\n", prim_walk, i, size >> 2,
-					   radeon_object_size(track->arrays[i].robj) >> 2);
+			if (size > radeon_bo_size(track->arrays[i].robj)) {
+				dev_err(rdev->dev, "(PW %u) Vertex array %u "
+					"need %lu dwords have %lu dwords\n",
+					prim_walk, i, size >> 2,
+					radeon_bo_size(track->arrays[i].robj)
+					>> 2);
 				return -EINVAL;
 			}
 		}
@@ -3160,7 +3174,7 @@ void r100_fini(struct radeon_device *rdev)
 		r100_pci_gart_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
@@ -3250,7 +3264,7 @@ int r100_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	if (rdev->flags & RADEON_IS_PCI) {
diff --git a/drivers/gpu/drm/radeon/r100_track.h b/drivers/gpu/drm/radeon/r100_track.h
index 0daf0d7..ca50903 100644
--- a/drivers/gpu/drm/radeon/r100_track.h
+++ b/drivers/gpu/drm/radeon/r100_track.h
@@ -10,26 +10,26 @@
  * CS functions
  */
 struct r100_cs_track_cb {
-	struct radeon_object	*robj;
+	struct radeon_bo	*robj;
 	unsigned		pitch;
 	unsigned		cpp;
 	unsigned		offset;
 };
 
 struct r100_cs_track_array {
-	struct radeon_object	*robj;
+	struct radeon_bo	*robj;
 	unsigned		esize;
 };
 
 struct r100_cs_cube_info {
-	struct radeon_object	*robj;
-	unsigned                offset;
+	struct radeon_bo	*robj;
+	unsigned		offset;
 	unsigned		width;
 	unsigned		height;
 };
 
 struct r100_cs_track_texture {
-	struct radeon_object	*robj;
+	struct radeon_bo	*robj;
 	struct r100_cs_cube_info cube_info[5]; /* info for 5 non-primary faces */
 	unsigned		pitch;
 	unsigned		width;
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 2f43ee8..b76fe28 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -137,14 +137,19 @@ int rv370_pcie_gart_enable(struct radeon_device *rdev)
 
 void rv370_pcie_gart_disable(struct radeon_device *rdev)
 {
-	uint32_t tmp;
+	u32 tmp;
+	int r;
 
 	tmp = RREG32_PCIE(RADEON_PCIE_TX_GART_CNTL);
 	tmp |= RADEON_PCIE_TX_GART_UNMAPPED_ACCESS_DISCARD;
 	WREG32_PCIE(RADEON_PCIE_TX_GART_CNTL, tmp & ~RADEON_PCIE_TX_GART_EN);
 	if (rdev->gart.table.vram.robj) {
-		radeon_object_kunmap(rdev->gart.table.vram.robj);
-		radeon_object_unpin(rdev->gart.table.vram.robj);
+		r = radeon_bo_reserve(rdev->gart.table.vram.robj, false);
+		if (likely(r == 0)) {
+			radeon_bo_kunmap(rdev->gart.table.vram.robj);
+			radeon_bo_unpin(rdev->gart.table.vram.robj);
+			radeon_bo_unreserve(rdev->gart.table.vram.robj);
+		}
 	}
 }
 
@@ -1265,7 +1270,7 @@ void r300_fini(struct radeon_device *rdev)
 		r100_pci_gart_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
@@ -1325,7 +1330,7 @@ int r300_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	if (rdev->flags & RADEON_IS_PCIE) {
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 1cefdbc..dc5e93a 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -258,7 +258,7 @@ void r420_fini(struct radeon_device *rdev)
 	radeon_agp_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	if (rdev->is_atom_bios) {
 		radeon_atombios_fini(rdev);
 	} else {
@@ -331,7 +331,7 @@ int r420_init(struct radeon_device *rdev)
 		return r;
 	}
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r) {
 		return r;
 	}
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index f743518..a41e9c7 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -277,7 +277,7 @@ int r520_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	r = rv370_pcie_gart_init(rdev);
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 8d6bc12..9f1f005 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -180,7 +180,7 @@ int r600_pcie_gart_enable(struct radeon_device *rdev)
 void r600_pcie_gart_disable(struct radeon_device *rdev)
 {
 	u32 tmp;
-	int i;
+	int i, r;
 
 	/* Disable all tables */
 	for (i = 0; i < 7; i++)
@@ -208,8 +208,12 @@ void r600_pcie_gart_disable(struct radeon_device *rdev)
 	WREG32(MC_VM_L1_TLB_MCB_RD_HDP_CNTL, tmp);
 	WREG32(MC_VM_L1_TLB_MCB_WR_HDP_CNTL, tmp);
 	if (rdev->gart.table.vram.robj) {
-		radeon_object_kunmap(rdev->gart.table.vram.robj);
-		radeon_object_unpin(rdev->gart.table.vram.robj);
+		r = radeon_bo_reserve(rdev->gart.table.vram.robj, false);
+		if (likely(r == 0)) {
+			radeon_bo_kunmap(rdev->gart.table.vram.robj);
+			radeon_bo_unpin(rdev->gart.table.vram.robj);
+			radeon_bo_unreserve(rdev->gart.table.vram.robj);
+		}
 	}
 }
 
@@ -1381,10 +1385,16 @@ int r600_ring_test(struct radeon_device *rdev)
 
 void r600_wb_disable(struct radeon_device *rdev)
 {
+	int r;
+
 	WREG32(SCRATCH_UMSK, 0);
 	if (rdev->wb.wb_obj) {
-		radeon_object_kunmap(rdev->wb.wb_obj);
-		radeon_object_unpin(rdev->wb.wb_obj);
+		r = radeon_bo_reserve(rdev->wb.wb_obj, false);
+		if (unlikely(r != 0))
+			return;
+		radeon_bo_kunmap(rdev->wb.wb_obj);
+		radeon_bo_unpin(rdev->wb.wb_obj);
+		radeon_bo_unreserve(rdev->wb.wb_obj);
 	}
 }
 
@@ -1392,7 +1402,7 @@ void r600_wb_fini(struct radeon_device *rdev)
 {
 	r600_wb_disable(rdev);
 	if (rdev->wb.wb_obj) {
-		radeon_object_unref(&rdev->wb.wb_obj);
+		radeon_bo_unref(&rdev->wb.wb_obj);
 		rdev->wb.wb = NULL;
 		rdev->wb.wb_obj = NULL;
 	}
@@ -1403,22 +1413,29 @@ int r600_wb_enable(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->wb.wb_obj == NULL) {
-		r = radeon_object_create(rdev, NULL, RADEON_GPU_PAGE_SIZE, true,
-				RADEON_GEM_DOMAIN_GTT, false, &rdev->wb.wb_obj);
+		r = radeon_bo_create(rdev, NULL, RADEON_GPU_PAGE_SIZE, true,
+				RADEON_GEM_DOMAIN_GTT, &rdev->wb.wb_obj);
 		if (r) {
-			dev_warn(rdev->dev, "failed to create WB buffer (%d).\n", r);
+			dev_warn(rdev->dev, "(%d) create WB bo failed\n", r);
+			return r;
+		}
+		r = radeon_bo_reserve(rdev->wb.wb_obj, false);
+		if (unlikely(r != 0)) {
+			r600_wb_fini(rdev);
 			return r;
 		}
-		r = radeon_object_pin(rdev->wb.wb_obj, RADEON_GEM_DOMAIN_GTT,
+		r = radeon_bo_pin(rdev->wb.wb_obj, RADEON_GEM_DOMAIN_GTT,
 				&rdev->wb.gpu_addr);
 		if (r) {
-			dev_warn(rdev->dev, "failed to pin WB buffer (%d).\n", r);
+			radeon_bo_unreserve(rdev->wb.wb_obj);
+			dev_warn(rdev->dev, "(%d) pin WB bo failed\n", r);
 			r600_wb_fini(rdev);
 			return r;
 		}
-		r = radeon_object_kmap(rdev->wb.wb_obj, (void **)&rdev->wb.wb);
+		r = radeon_bo_kmap(rdev->wb.wb_obj, (void **)&rdev->wb.wb);
+		radeon_bo_unreserve(rdev->wb.wb_obj);
 		if (r) {
-			dev_warn(rdev->dev, "failed to map WB buffer (%d).\n", r);
+			dev_warn(rdev->dev, "(%d) map WB bo failed\n", r);
 			r600_wb_fini(rdev);
 			return r;
 		}
@@ -1516,10 +1533,14 @@ int r600_startup(struct radeon_device *rdev)
 	}
 	r600_gpu_init(rdev);
 
-	r = radeon_object_pin(rdev->r600_blit.shader_obj, RADEON_GEM_DOMAIN_VRAM,
-			      &rdev->r600_blit.shader_gpu_addr);
+	r = radeon_bo_reserve(rdev->r600_blit.shader_obj, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_pin(rdev->r600_blit.shader_obj, RADEON_GEM_DOMAIN_VRAM,
+			&rdev->r600_blit.shader_gpu_addr);
+	radeon_bo_unreserve(rdev->r600_blit.shader_obj);
 	if (r) {
-		DRM_ERROR("failed to pin blit object %d\n", r);
+		dev_err(rdev->dev, "(%d) pin blit object failed\n", r);
 		return r;
 	}
 
@@ -1569,13 +1590,19 @@ int r600_resume(struct radeon_device *rdev)
 
 int r600_suspend(struct radeon_device *rdev)
 {
+	int r;
+
 	/* FIXME: we should wait for ring to be empty */
 	r600_cp_stop(rdev);
 	rdev->cp.ready = false;
 	r600_wb_disable(rdev);
 	r600_pcie_gart_disable(rdev);
 	/* unpin shaders bo */
-	radeon_object_unpin(rdev->r600_blit.shader_obj);
+	r = radeon_bo_reserve(rdev->r600_blit.shader_obj, false);
+	if (unlikely(r != 0))
+		return r;
+	radeon_bo_unpin(rdev->r600_blit.shader_obj);
+	radeon_bo_unreserve(rdev->r600_blit.shader_obj);
 	return 0;
 }
 
@@ -1636,7 +1663,7 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	rdev->cp.ring_obj = NULL;
@@ -1698,7 +1725,7 @@ void r600_fini(struct radeon_device *rdev)
 	radeon_clocks_fini(rdev);
 	if (rdev->flags & RADEON_IS_AGP)
 		radeon_agp_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
diff --git a/drivers/gpu/drm/radeon/r600_blit_kms.c b/drivers/gpu/drm/radeon/r600_blit_kms.c
index dbf716e..f42943a 100644
--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -473,9 +473,8 @@ int r600_blit_init(struct radeon_device *rdev)
 	obj_size += r6xx_ps_size * 4;
 	obj_size = ALIGN(obj_size, 256);
 
-	r = radeon_object_create(rdev, NULL, obj_size,
-				 true, RADEON_GEM_DOMAIN_VRAM,
-				 false, &rdev->r600_blit.shader_obj);
+	r = radeon_bo_create(rdev, NULL, obj_size, true, RADEON_GEM_DOMAIN_VRAM,
+				&rdev->r600_blit.shader_obj);
 	if (r) {
 		DRM_ERROR("r600 failed to allocate shader\n");
 		return r;
@@ -485,12 +484,14 @@ int r600_blit_init(struct radeon_device *rdev)
 		  obj_size,
 		  rdev->r600_blit.vs_offset, rdev->r600_blit.ps_offset);
 
-	r = radeon_object_kmap(rdev->r600_blit.shader_obj, &ptr);
+	r = radeon_bo_reserve(rdev->r600_blit.shader_obj, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_kmap(rdev->r600_blit.shader_obj, &ptr);
 	if (r) {
 		DRM_ERROR("failed to map blit object %d\n", r);
 		return r;
 	}
-
 	if (rdev->family >= CHIP_RV770)
 		memcpy_toio(ptr + rdev->r600_blit.state_offset,
 			    r7xx_default_state, rdev->r600_blit.state_len * 4);
@@ -500,19 +501,26 @@ int r600_blit_init(struct radeon_device *rdev)
 	if (num_packet2s)
 		memcpy_toio(ptr + rdev->r600_blit.state_offset + (rdev->r600_blit.state_len * 4),
 			    packet2s, num_packet2s * 4);
-
-
 	memcpy(ptr + rdev->r600_blit.vs_offset, r6xx_vs, r6xx_vs_size * 4);
 	memcpy(ptr + rdev->r600_blit.ps_offset, r6xx_ps, r6xx_ps_size * 4);
-
-	radeon_object_kunmap(rdev->r600_blit.shader_obj);
+	radeon_bo_kunmap(rdev->r600_blit.shader_obj);
+	radeon_bo_unreserve(rdev->r600_blit.shader_obj);
 	return 0;
 }
 
 void r600_blit_fini(struct radeon_device *rdev)
 {
-	radeon_object_unpin(rdev->r600_blit.shader_obj);
-	radeon_object_unref(&rdev->r600_blit.shader_obj);
+	int r;
+
+	r = radeon_bo_reserve(rdev->r600_blit.shader_obj, false);
+	if (unlikely(r != 0)) {
+		dev_err(rdev->dev, "(%d) can't finish r600 blit\n", r);
+		goto out_unref;
+	}
+	radeon_bo_unpin(rdev->r600_blit.shader_obj);
+	radeon_bo_unreserve(rdev->r600_blit.shader_obj);
+out_unref:
+	radeon_bo_unref(&rdev->r600_blit.shader_obj);
 }
 
 int r600_vb_ib_get(struct radeon_device *rdev)
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 9f0bd98..4b5d86b 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -28,8 +28,6 @@
 #ifndef __RADEON_H__
 #define __RADEON_H__
 
-#include "radeon_object.h"
-
 /* TODO: Here are things that needs to be done :
  *	- surface allocator & initializer : (bit like scratch reg) should
  *	  initialize HDP_ stuff on RS600, R600, R700 hw, well anythings
@@ -67,6 +65,11 @@
 #include <linux/list.h>
 #include <linux/kref.h>
 
+#include <ttm/ttm_bo_api.h>
+#include <ttm/ttm_bo_driver.h>
+#include <ttm/ttm_placement.h>
+#include <ttm/ttm_module.h>
+
 #include "radeon_family.h"
 #include "radeon_mode.h"
 #include "radeon_reg.h"
@@ -186,76 +189,60 @@ void radeon_fence_unref(struct radeon_fence **fence);
  * Tiling registers
  */
 struct radeon_surface_reg {
-	struct radeon_object *robj;
+	struct radeon_bo *bo;
 };
 
 #define RADEON_GEM_MAX_SURFACES 8
 
 /*
- * Radeon buffer.
+ * TTM.
  */
-struct radeon_object;
+struct radeon_mman {
+	struct ttm_bo_global_ref        bo_global_ref;
+	struct ttm_global_reference	mem_global_ref;
+	bool				mem_global_referenced;
+	struct ttm_bo_device		bdev;
+};
+
+struct radeon_bo {
+	/* Protected by gem.mutex */
+	struct list_head		list;
+	/* Protected by tbo.reserved */
+	struct ttm_buffer_object	tbo;
+	struct ttm_bo_kmap_obj		kmap;
+	unsigned			pin_count;
+	void				*kptr;
+	u32				tiling_flags;
+	u32				pitch;
+	int				surface_reg;
+	/* Constant after initialization */
+	struct radeon_device		*rdev;
+	struct drm_gem_object		*gobj;
+};
 
-struct radeon_object_list {
+struct radeon_bo_list {
 	struct list_head	list;
-	struct radeon_object	*robj;
+	struct radeon_bo	*bo;
 	uint64_t		gpu_offset;
 	unsigned		rdomain;
 	unsigned		wdomain;
-	uint32_t                tiling_flags;
+	u32			tiling_flags;
 };
 
-int radeon_object_init(struct radeon_device *rdev);
-void radeon_object_fini(struct radeon_device *rdev);
-int radeon_object_create(struct radeon_device *rdev,
-			 struct drm_gem_object *gobj,
-			 unsigned long size,
-			 bool kernel,
-			 uint32_t domain,
-			 bool interruptible,
-			 struct radeon_object **robj_ptr);
-int radeon_object_kmap(struct radeon_object *robj, void **ptr);
-void radeon_object_kunmap(struct radeon_object *robj);
-void radeon_object_unref(struct radeon_object **robj);
-int radeon_object_pin(struct radeon_object *robj, uint32_t domain,
-		      uint64_t *gpu_addr);
-void radeon_object_unpin(struct radeon_object *robj);
-int radeon_object_wait(struct radeon_object *robj);
-int radeon_object_busy_domain(struct radeon_object *robj, uint32_t *cur_placement);
-int radeon_object_evict_vram(struct radeon_device *rdev);
-int radeon_object_mmap(struct radeon_object *robj, uint64_t *offset);
-void radeon_object_force_delete(struct radeon_device *rdev);
-void radeon_object_list_add_object(struct radeon_object_list *lobj,
-				   struct list_head *head);
-int radeon_object_list_validate(struct list_head *head, void *fence);
-void radeon_object_list_unvalidate(struct list_head *head);
-void radeon_object_list_clean(struct list_head *head);
-int radeon_object_fbdev_mmap(struct radeon_object *robj,
-			     struct vm_area_struct *vma);
-unsigned long radeon_object_size(struct radeon_object *robj);
-void radeon_object_clear_surface_reg(struct radeon_object *robj);
-int radeon_object_check_tiling(struct radeon_object *robj, bool has_moved,
-			       bool force_drop);
-void radeon_object_set_tiling_flags(struct radeon_object *robj,
-				    uint32_t tiling_flags, uint32_t pitch);
-void radeon_object_get_tiling_flags(struct radeon_object *robj, uint32_t *tiling_flags, uint32_t *pitch);
-void radeon_bo_move_notify(struct ttm_buffer_object *bo,
-			   struct ttm_mem_reg *mem);
-void radeon_bo_fault_reserve_notify(struct ttm_buffer_object *bo);
 /*
  * GEM objects.
  */
 struct radeon_gem {
+	struct mutex		mutex;
 	struct list_head	objects;
 };
 
 int radeon_gem_init(struct radeon_device *rdev);
 void radeon_gem_fini(struct radeon_device *rdev);
 int radeon_gem_object_create(struct radeon_device *rdev, int size,
-			     int alignment, int initial_domain,
-			     bool discardable, bool kernel,
-			     bool interruptible,
-			     struct drm_gem_object **obj);
+				int alignment, int initial_domain,
+				bool discardable, bool kernel,
+				struct drm_gem_object **obj);
 int radeon_gem_object_pin(struct drm_gem_object *obj, uint32_t pin_domain,
 			  uint64_t *gpu_addr);
 void radeon_gem_object_unpin(struct drm_gem_object *obj);
@@ -271,7 +258,7 @@ struct radeon_gart_table_ram {
 };
 
 struct radeon_gart_table_vram {
-	struct radeon_object		*robj;
+	struct radeon_bo		*robj;
 	volatile uint32_t		*ptr;
 };
 
@@ -376,7 +363,7 @@ struct radeon_ib {
  */
 struct radeon_ib_pool {
 	struct mutex		mutex;
-	struct radeon_object	*robj;
+	struct radeon_bo	*robj;
 	struct list_head	scheduled_ibs;
 	struct radeon_ib	ibs[RADEON_IB_POOL_SIZE];
 	bool			ready;
@@ -384,7 +371,7 @@ struct radeon_ib_pool {
 };
 
 struct radeon_cp {
-	struct radeon_object	*ring_obj;
+	struct radeon_bo	*ring_obj;
 	volatile uint32_t	*ring;
 	unsigned		rptr;
 	unsigned		wptr;
@@ -400,7 +387,7 @@ struct radeon_cp {
 };
 
 struct r600_blit {
-	struct radeon_object	*shader_obj;
+	struct radeon_bo	*shader_obj;
 	u64 shader_gpu_addr;
 	u32 vs_offset, ps_offset;
 	u32 state_offset;
@@ -430,8 +417,8 @@ void radeon_ring_fini(struct radeon_device *rdev);
  */
 struct radeon_cs_reloc {
 	struct drm_gem_object		*gobj;
-	struct radeon_object		*robj;
-	struct radeon_object_list	lobj;
+	struct radeon_bo		*robj;
+	struct radeon_bo_list		lobj;
 	uint32_t			handle;
 	uint32_t			flags;
 };
@@ -526,7 +513,7 @@ void radeon_agp_fini(struct radeon_device *rdev);
  * Writeback
  */
 struct radeon_wb {
-	struct radeon_object	*wb_obj;
+	struct radeon_bo	*wb_obj;
 	volatile uint32_t	*wb;
 	uint64_t		gpu_addr;
 };
@@ -749,9 +736,9 @@ struct radeon_device {
 	uint8_t				*bios;
 	bool				is_atom_bios;
 	uint16_t			bios_header_start;
-	struct radeon_object		*stollen_vga_memory;
+	struct radeon_bo		*stollen_vga_memory;
 	struct fb_info			*fbdev_info;
-	struct radeon_object		*fbdev_robj;
+	struct radeon_bo		*fbdev_rbo;
 	struct radeon_framebuffer	*fbdev_rfb;
 	/* Register mmio */
 	resource_size_t			rmmio_base;
@@ -827,6 +814,10 @@ static inline void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32
 	}
 }
 
+/*
+ * Cast helper
+ */
+#define to_radeon_fence(p) ((struct radeon_fence *)(p))
 
 /*
  * Registers read & write functions.
@@ -1018,7 +1009,7 @@ extern int r100_cp_reset(struct radeon_device *rdev);
 extern void r100_vga_render_disable(struct radeon_device *rdev);
 extern int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
 						struct radeon_cs_packet *pkt,
-						struct radeon_object *robj);
+						struct radeon_bo *robj);
 extern int r100_cs_parse_packet0(struct radeon_cs_parser *p,
 				struct radeon_cs_packet *pkt,
 				const unsigned *auth, unsigned n,
@@ -1104,4 +1095,6 @@ extern void r600_blit_fini(struct radeon_device *rdev);
 extern int r600_cp_init_microcode(struct radeon_device *rdev);
 extern int r600_gpu_reset(struct radeon_device *rdev);
 
+#include "radeon_object.h"
+
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_benchmark.c b/drivers/gpu/drm/radeon/radeon_benchmark.c
index 10bd50a..4ddfd4b 100644
--- a/drivers/gpu/drm/radeon/radeon_benchmark.c
+++ b/drivers/gpu/drm/radeon/radeon_benchmark.c
@@ -29,8 +29,8 @@
 void radeon_benchmark_move(struct radeon_device *rdev, unsigned bsize,
 			   unsigned sdomain, unsigned ddomain)
 {
-	struct radeon_object *dobj = NULL;
-	struct radeon_object *sobj = NULL;
+	struct radeon_bo *dobj = NULL;
+	struct radeon_bo *sobj = NULL;
 	struct radeon_fence *fence = NULL;
 	uint64_t saddr, daddr;
 	unsigned long start_jiffies;
@@ -41,19 +41,27 @@ void radeon_benchmark_move(struct radeon_device *rdev, unsigned bsize,
 
 	size = bsize;
 	n = 1024;
-	r = radeon_object_create(rdev, NULL, size, true, sdomain, false, &sobj);
+	r = radeon_bo_create(rdev, NULL, size, true, sdomain, &sobj);
 	if (r) {
 		goto out_cleanup;
 	}
-	r = radeon_object_pin(sobj, sdomain, &saddr);
+	r = radeon_bo_reserve(sobj, false);
+	if (unlikely(r != 0))
+		goto out_cleanup;
+	r = radeon_bo_pin(sobj, sdomain, &saddr);
+	radeon_bo_unreserve(sobj);
 	if (r) {
 		goto out_cleanup;
 	}
-	r = radeon_object_create(rdev, NULL, size, true, ddomain, false, &dobj);
+	r = radeon_bo_create(rdev, NULL, size, true, ddomain, &dobj);
 	if (r) {
 		goto out_cleanup;
 	}
-	r = radeon_object_pin(dobj, ddomain, &daddr);
+	r = radeon_bo_reserve(dobj, false);
+	if (unlikely(r != 0))
+		goto out_cleanup;
+	r = radeon_bo_pin(dobj, ddomain, &daddr);
+	radeon_bo_unreserve(dobj);
 	if (r) {
 		goto out_cleanup;
 	}
@@ -109,12 +117,20 @@ void radeon_benchmark_move(struct radeon_device *rdev, unsigned bsize,
 	}
 out_cleanup:
 	if (sobj) {
-		radeon_object_unpin(sobj);
-		radeon_object_unref(&sobj);
+		r = radeon_bo_reserve(sobj, false);
+		if (likely(r == 0)) {
+			radeon_bo_unpin(sobj);
+			radeon_bo_unreserve(sobj);
+		}
+		radeon_bo_unref(&sobj);
 	}
 	if (dobj) {
-		radeon_object_unpin(dobj);
-		radeon_object_unref(&dobj);
+		r = radeon_bo_reserve(dobj, false);
+		if (likely(r == 0)) {
+			radeon_bo_unpin(dobj);
+			radeon_bo_unreserve(dobj);
+		}
+		radeon_bo_unref(&dobj);
 	}
 	if (fence) {
 		radeon_fence_unref(&fence);
diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 5ab2cf9..65590a0 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -76,17 +76,17 @@ int radeon_cs_parser_relocs(struct radeon_cs_parser *p)
 			}
 			p->relocs_ptr[i] = &p->relocs[i];
 			p->relocs[i].robj = p->relocs[i].gobj->driver_private;
-			p->relocs[i].lobj.robj = p->relocs[i].robj;
+			p->relocs[i].lobj.bo = p->relocs[i].robj;
 			p->relocs[i].lobj.rdomain = r->read_domains;
 			p->relocs[i].lobj.wdomain = r->write_domain;
 			p->relocs[i].handle = r->handle;
 			p->relocs[i].flags = r->flags;
 			INIT_LIST_HEAD(&p->relocs[i].lobj.list);
-			radeon_object_list_add_object(&p->relocs[i].lobj,
-						      &p->validated);
+			radeon_bo_list_add_object(&p->relocs[i].lobj,
+						&p->validated);
 		}
 	}
-	return radeon_object_list_validate(&p->validated, p->ib->fence);
+	return radeon_bo_list_validate(&p->validated, p->ib->fence);
 }
 
 int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
@@ -190,9 +190,10 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error)
 	unsigned i;
 
 	if (error) {
-		radeon_object_list_unvalidate(&parser->validated);
+		radeon_bo_list_unvalidate(&parser->validated,
+						parser->ib->fence);
 	} else {
-		radeon_object_list_clean(&parser->validated);
+		radeon_bo_list_unreserve(&parser->validated);
 	}
 	for (i = 0; i < parser->nrelocs; i++) {
 		if (parser->relocs[i].gobj) {
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 88c1907..e13f723 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -531,6 +531,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	mutex_init(&rdev->cs_mutex);
 	mutex_init(&rdev->ib_pool.mutex);
 	mutex_init(&rdev->cp.mutex);
+	mutex_init(&rdev->gem.mutex);
 	rwlock_init(&rdev->fence_drv.lock);
 	INIT_LIST_HEAD(&rdev->gem.objects);
 
@@ -614,6 +615,7 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 {
 	struct radeon_device *rdev = dev->dev_private;
 	struct drm_crtc *crtc;
+	int r;
 
 	if (dev == NULL || rdev == NULL) {
 		return -ENODEV;
@@ -624,18 +626,22 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 	/* unpin the front buffers */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct radeon_framebuffer *rfb = to_radeon_framebuffer(crtc->fb);
-		struct radeon_object *robj;
+		struct radeon_bo *robj;
 
 		if (rfb == NULL || rfb->obj == NULL) {
 			continue;
 		}
 		robj = rfb->obj->driver_private;
-		if (robj != rdev->fbdev_robj) {
-			radeon_object_unpin(robj);
+		if (robj != rdev->fbdev_rbo) {
+			r = radeon_bo_reserve(robj, false);
+			if (unlikely(r == 0)) {
+				radeon_bo_unpin(robj);
+				radeon_bo_unreserve(robj);
+			}
 		}
 	}
 	/* evict vram memory */
-	radeon_object_evict_vram(rdev);
+	radeon_bo_evict_vram(rdev);
 	/* wait for gpu to finish processing current batch */
 	radeon_fence_wait_last(rdev);
 
@@ -643,7 +649,7 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 
 	radeon_suspend(rdev);
 	/* evict remaining vram memory */
-	radeon_object_evict_vram(rdev);
+	radeon_bo_evict_vram(rdev);
 
 	pci_save_state(dev->pdev);
 	if (state.event == PM_EVENT_SUSPEND) {
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index b38c4c8..f510058 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -140,7 +140,7 @@ int radeonfb_create(struct drm_device *dev,
 	struct radeon_framebuffer *rfb;
 	struct drm_mode_fb_cmd mode_cmd;
 	struct drm_gem_object *gobj = NULL;
-	struct radeon_object *robj = NULL;
+	struct radeon_bo *rbo = NULL;
 	struct device *device = &rdev->pdev->dev;
 	int size, aligned_size, ret;
 	u64 fb_gpuaddr;
@@ -168,14 +168,14 @@ int radeonfb_create(struct drm_device *dev,
 	ret = radeon_gem_object_create(rdev, aligned_size, 0,
 			RADEON_GEM_DOMAIN_VRAM,
 			false, ttm_bo_type_kernel,
-			false, &gobj);
+			&gobj);
 	if (ret) {
 		printk(KERN_ERR "failed to allocate framebuffer (%d %d)\n",
 		       surface_width, surface_height);
 		ret = -ENOMEM;
 		goto out;
 	}
-	robj = gobj->driver_private;
+	rbo = gobj->driver_private;
 
 	if (fb_tiled)
 		tiling_flags = RADEON_TILING_MACRO;
@@ -192,8 +192,13 @@ int radeonfb_create(struct drm_device *dev,
 	}
 #endif
 
-	if (tiling_flags)
-		radeon_object_set_tiling_flags(robj, tiling_flags | RADEON_TILING_SURFACE, mode_cmd.pitch);
+	if (tiling_flags) {
+		ret = radeon_bo_set_tiling_flags(rbo,
+					tiling_flags | RADEON_TILING_SURFACE,
+					mode_cmd.pitch);
+		if (ret)
+			dev_err(rdev->dev, "FB failed to set tiling flags\n");
+	}
 	mutex_lock(&rdev->ddev->struct_mutex);
 	fb = radeon_framebuffer_create(rdev->ddev, &mode_cmd, gobj);
 	if (fb == NULL) {
@@ -201,10 +206,19 @@ int radeonfb_create(struct drm_device *dev,
 		ret = -ENOMEM;
 		goto out_unref;
 	}
-	ret = radeon_object_pin(robj, RADEON_GEM_DOMAIN_VRAM, &fb_gpuaddr);
+	ret = radeon_bo_reserve(rbo, false);
+	if (unlikely(ret != 0))
+		goto out_unref;
+	ret = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &fb_gpuaddr);
+	if (ret) {
+		radeon_bo_unreserve(rbo);
+		goto out_unref;
+	}
+	if (fb_tiled)
+		radeon_bo_check_tiling(rbo, 0, 0);
+	ret = radeon_bo_kmap(rbo, &fbptr);
+	radeon_bo_unreserve(rbo);
 	if (ret) {
-		printk(KERN_ERR "failed to pin framebuffer\n");
-		ret = -ENOMEM;
 		goto out_unref;
 	}
 
@@ -213,7 +227,7 @@ int radeonfb_create(struct drm_device *dev,
 	*fb_p = fb;
 	rfb = to_radeon_framebuffer(fb);
 	rdev->fbdev_rfb = rfb;
-	rdev->fbdev_robj = robj;
+	rdev->fbdev_rbo = rbo;
 
 	info = framebuffer_alloc(sizeof(struct radeon_fb_device), device);
 	if (info == NULL) {
@@ -234,15 +248,7 @@ int radeonfb_create(struct drm_device *dev,
 	if (ret)
 		goto out_unref;
 
-	if (fb_tiled)
-		radeon_object_check_tiling(robj, 0, 0);
-
-	ret = radeon_object_kmap(robj, &fbptr);
-	if (ret) {
-		goto out_unref;
-	}
-
-	memset_io(fbptr, 0, aligned_size);
+	memset_io(fbptr, 0xff, aligned_size);
 
 	strcpy(info->fix.id, "radeondrmfb");
 
@@ -288,8 +294,12 @@ int radeonfb_create(struct drm_device *dev,
 	return 0;
 
 out_unref:
-	if (robj) {
-		radeon_object_kunmap(robj);
+	if (rbo) {
+		ret = radeon_bo_reserve(rbo, false);
+		if (likely(ret == 0)) {
+			radeon_bo_kunmap(rbo);
+			radeon_bo_unreserve(rbo);
+		}
 	}
 	if (fb && ret) {
 		list_del(&fb->filp_head);
@@ -328,7 +338,8 @@ int radeonfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 {
 	struct fb_info *info;
 	struct radeon_framebuffer *rfb = to_radeon_framebuffer(fb);
-	struct radeon_object *robj;
+	struct radeon_bo *rbo;
+	int r;
 
 	if (!fb) {
 		return -EINVAL;
@@ -336,10 +347,14 @@ int radeonfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 	info = fb->fbdev;
 	if (info) {
 		struct radeon_fb_device *rfbdev = info->par;
-		robj = rfb->obj->driver_private;
+		rbo = rfb->obj->driver_private;
 		unregister_framebuffer(info);
-		radeon_object_kunmap(robj);
-		radeon_object_unpin(robj);
+		r = radeon_bo_reserve(rbo, false);
+		if (likely(r == 0)) {
+			radeon_bo_kunmap(rbo);
+			radeon_bo_unpin(rbo);
+			radeon_bo_unreserve(rbo);
+		}
 		drm_fb_helper_free(&rfbdev->helper);
 		framebuffer_release(info);
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index a68d756..e73d56e 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -78,11 +78,9 @@ int radeon_gart_table_vram_alloc(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->gart.table.vram.robj == NULL) {
-		r = radeon_object_create(rdev, NULL,
-					 rdev->gart.table_size,
-					 true,
-					 RADEON_GEM_DOMAIN_VRAM,
-					 false, &rdev->gart.table.vram.robj);
+		r = radeon_bo_create(rdev, NULL, rdev->gart.table_size,
+					true, RADEON_GEM_DOMAIN_VRAM,
+					&rdev->gart.table.vram.robj);
 		if (r) {
 			return r;
 		}
@@ -95,32 +93,38 @@ int radeon_gart_table_vram_pin(struct radeon_device *rdev)
 	uint64_t gpu_addr;
 	int r;
 
-	r = radeon_object_pin(rdev->gart.table.vram.robj,
-			      RADEON_GEM_DOMAIN_VRAM, &gpu_addr);
-	if (r) {
-		radeon_object_unref(&rdev->gart.table.vram.robj);
+	r = radeon_bo_reserve(rdev->gart.table.vram.robj, false);
+	if (unlikely(r != 0))
 		return r;
-	}
-	r = radeon_object_kmap(rdev->gart.table.vram.robj,
-			       (void **)&rdev->gart.table.vram.ptr);
+	r = radeon_bo_pin(rdev->gart.table.vram.robj,
+				RADEON_GEM_DOMAIN_VRAM, &gpu_addr);
 	if (r) {
-		radeon_object_unpin(rdev->gart.table.vram.robj);
-		radeon_object_unref(&rdev->gart.table.vram.robj);
-		DRM_ERROR("radeon: failed to map gart vram table.\n");
+		radeon_bo_unreserve(rdev->gart.table.vram.robj);
 		return r;
 	}
+	r = radeon_bo_kmap(rdev->gart.table.vram.robj,
+				(void **)&rdev->gart.table.vram.ptr);
+	if (r)
+		radeon_bo_unpin(rdev->gart.table.vram.robj);
+	radeon_bo_unreserve(rdev->gart.table.vram.robj);
 	rdev->gart.table_addr = gpu_addr;
-	return 0;
+	return r;
 }
 
 void radeon_gart_table_vram_free(struct radeon_device *rdev)
 {
+	int r;
+
 	if (rdev->gart.table.vram.robj == NULL) {
 		return;
 	}
-	radeon_object_kunmap(rdev->gart.table.vram.robj);
-	radeon_object_unpin(rdev->gart.table.vram.robj);
-	radeon_object_unref(&rdev->gart.table.vram.robj);
+	r = radeon_bo_reserve(rdev->gart.table.vram.robj, false);
+	if (likely(r == 0)) {
+		radeon_bo_kunmap(rdev->gart.table.vram.robj);
+		radeon_bo_unpin(rdev->gart.table.vram.robj);
+		radeon_bo_unreserve(rdev->gart.table.vram.robj);
+	}
+	radeon_bo_unref(&rdev->gart.table.vram.robj);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index d880edf..f3fb2bf 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -38,22 +38,21 @@ int radeon_gem_object_init(struct drm_gem_object *obj)
 
 void radeon_gem_object_free(struct drm_gem_object *gobj)
 {
-	struct radeon_object *robj = gobj->driver_private;
+	struct radeon_bo *robj = gobj->driver_private;
 
 	gobj->driver_private = NULL;
 	if (robj) {
-		radeon_object_unref(&robj);
+		radeon_bo_unref(&robj);
 	}
 }
 
 int radeon_gem_object_create(struct radeon_device *rdev, int size,
-			     int alignment, int initial_domain,
-			     bool discardable, bool kernel,
-			     bool interruptible,
-			     struct drm_gem_object **obj)
+				int alignment, int initial_domain,
+				bool discardable, bool kernel,
+				struct drm_gem_object **obj)
 {
 	struct drm_gem_object *gobj;
-	struct radeon_object *robj;
+	struct radeon_bo *robj;
 	int r;
 
 	*obj = NULL;
@@ -65,8 +64,7 @@ int radeon_gem_object_create(struct radeon_device *rdev, int size,
 	if (alignment < PAGE_SIZE) {
 		alignment = PAGE_SIZE;
 	}
-	r = radeon_object_create(rdev, gobj, size, kernel, initial_domain,
-				 interruptible, &robj);
+	r = radeon_bo_create(rdev, gobj, size, kernel, initial_domain, &robj);
 	if (r) {
 		DRM_ERROR("Failed to allocate GEM object (%d, %d, %u)\n",
 			  size, initial_domain, alignment);
@@ -83,33 +81,33 @@ int radeon_gem_object_create(struct radeon_device *rdev, int size,
 int radeon_gem_object_pin(struct drm_gem_object *obj, uint32_t pin_domain,
 			  uint64_t *gpu_addr)
 {
-	struct radeon_object *robj = obj->driver_private;
-	uint32_t flags;
+	struct radeon_bo *robj = obj->driver_private;
+	int r;
 
-	switch (pin_domain) {
-	case RADEON_GEM_DOMAIN_VRAM:
-		flags = TTM_PL_FLAG_VRAM;
-		break;
-	case RADEON_GEM_DOMAIN_GTT:
-		flags = TTM_PL_FLAG_TT;
-		break;
-	default:
-		flags = TTM_PL_FLAG_SYSTEM;
-		break;
-	}
-	return radeon_object_pin(robj, flags, gpu_addr);
+	r = radeon_bo_reserve(robj, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_pin(robj, pin_domain, gpu_addr);
+	radeon_bo_unreserve(robj);
+	return r;
 }
 
 void radeon_gem_object_unpin(struct drm_gem_object *obj)
 {
-	struct radeon_object *robj = obj->driver_private;
-	radeon_object_unpin(robj);
+	struct radeon_bo *robj = obj->driver_private;
+	int r;
+
+	r = radeon_bo_reserve(robj, false);
+	if (likely(r == 0)) {
+		radeon_bo_unpin(robj);
+		radeon_bo_unreserve(robj);
+	}
 }
 
 int radeon_gem_set_domain(struct drm_gem_object *gobj,
 			  uint32_t rdomain, uint32_t wdomain)
 {
-	struct radeon_object *robj;
+	struct radeon_bo *robj;
 	uint32_t domain;
 	int r;
 
@@ -127,7 +125,7 @@ int radeon_gem_set_domain(struct drm_gem_object *gobj,
 	}
 	if (domain == RADEON_GEM_DOMAIN_CPU) {
 		/* Asking for cpu access wait for object idle */
-		r = radeon_object_wait(robj);
+		r = radeon_bo_wait(robj, NULL, false);
 		if (r) {
 			printk(KERN_ERR "Failed to wait for object !\n");
 			return r;
@@ -144,7 +142,7 @@ int radeon_gem_init(struct radeon_device *rdev)
 
 void radeon_gem_fini(struct radeon_device *rdev)
 {
-	radeon_object_force_delete(rdev);
+	radeon_bo_force_delete(rdev);
 }
 
 
@@ -192,8 +190,8 @@ int radeon_gem_create_ioctl(struct drm_device *dev, void *data,
 	/* create a gem object to contain this object in */
 	args->size = roundup(args->size, PAGE_SIZE);
 	r = radeon_gem_object_create(rdev, args->size, args->alignment,
-				     args->initial_domain, false,
-				     false, true, &gobj);
+					args->initial_domain, false,
+					false, &gobj);
 	if (r) {
 		return r;
 	}
@@ -218,7 +216,7 @@ int radeon_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	 * just validate the BO into a certain domain */
 	struct drm_radeon_gem_set_domain *args = data;
 	struct drm_gem_object *gobj;
-	struct radeon_object *robj;
+	struct radeon_bo *robj;
 	int r;
 
 	/* for now if someone requests domain CPU -
@@ -244,19 +242,18 @@ int radeon_gem_mmap_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_radeon_gem_mmap *args = data;
 	struct drm_gem_object *gobj;
-	struct radeon_object *robj;
-	int r;
+	struct radeon_bo *robj;
 
 	gobj = drm_gem_object_lookup(dev, filp, args->handle);
 	if (gobj == NULL) {
 		return -EINVAL;
 	}
 	robj = gobj->driver_private;
-	r = radeon_object_mmap(robj, &args->addr_ptr);
+	args->addr_ptr = radeon_bo_mmap_offset(robj);
 	mutex_lock(&dev->struct_mutex);
 	drm_gem_object_unreference(gobj);
 	mutex_unlock(&dev->struct_mutex);
-	return r;
+	return 0;
 }
 
 int radeon_gem_busy_ioctl(struct drm_device *dev, void *data,
@@ -264,7 +261,7 @@ int radeon_gem_busy_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_radeon_gem_busy *args = data;
 	struct drm_gem_object *gobj;
-	struct radeon_object *robj;
+	struct radeon_bo *robj;
 	int r;
 	uint32_t cur_placement;
 
@@ -273,7 +270,7 @@ int radeon_gem_busy_ioctl(struct drm_device *dev, void *data,
 		return -EINVAL;
 	}
 	robj = gobj->driver_private;
-	r = radeon_object_busy_domain(robj, &cur_placement);
+	r = radeon_bo_wait(robj, &cur_placement, true);
 	switch (cur_placement) {
 	case TTM_PL_VRAM:
 		args->domain = RADEON_GEM_DOMAIN_VRAM;
@@ -297,7 +294,7 @@ int radeon_gem_wait_idle_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_radeon_gem_wait_idle *args = data;
 	struct drm_gem_object *gobj;
-	struct radeon_object *robj;
+	struct radeon_bo *robj;
 	int r;
 
 	gobj = drm_gem_object_lookup(dev, filp, args->handle);
@@ -305,7 +302,7 @@ int radeon_gem_wait_idle_ioctl(struct drm_device *dev, void *data,
 		return -EINVAL;
 	}
 	robj = gobj->driver_private;
-	r = radeon_object_wait(robj);
+	r = radeon_bo_wait(robj, NULL, false);
 	mutex_lock(&dev->struct_mutex);
 	drm_gem_object_unreference(gobj);
 	mutex_unlock(&dev->struct_mutex);
@@ -317,7 +314,7 @@ int radeon_gem_set_tiling_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_radeon_gem_set_tiling *args = data;
 	struct drm_gem_object *gobj;
-	struct radeon_object *robj;
+	struct radeon_bo *robj;
 	int r = 0;
 
 	DRM_DEBUG("%d \n", args->handle);
@@ -325,7 +322,7 @@ int radeon_gem_set_tiling_ioctl(struct drm_device *dev, void *data,
 	if (gobj == NULL)
 		return -EINVAL;
 	robj = gobj->driver_private;
-	radeon_object_set_tiling_flags(robj, args->tiling_flags, args->pitch);
+	r = radeon_bo_set_tiling_flags(robj, args->tiling_flags, args->pitch);
 	mutex_lock(&dev->struct_mutex);
 	drm_gem_object_unreference(gobj);
 	mutex_unlock(&dev->struct_mutex);
@@ -337,16 +334,19 @@ int radeon_gem_get_tiling_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_radeon_gem_get_tiling *args = data;
 	struct drm_gem_object *gobj;
-	struct radeon_object *robj;
+	struct radeon_bo *rbo;
 	int r = 0;
 
 	DRM_DEBUG("\n");
 	gobj = drm_gem_object_lookup(dev, filp, args->handle);
 	if (gobj == NULL)
 		return -EINVAL;
-	robj = gobj->driver_private;
-	radeon_object_get_tiling_flags(robj, &args->tiling_flags,
-				       &args->pitch);
+	rbo = gobj->driver_private;
+	r = radeon_bo_reserve(rbo, false);
+	if (unlikely(r != 0))
+		return r;
+	radeon_bo_get_tiling_flags(rbo, &args->tiling_flags, &args->pitch);
+	radeon_bo_unreserve(rbo);
 	mutex_lock(&dev->struct_mutex);
 	drm_gem_object_unreference(gobj);
 	mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 8d0b7aa..e8a984d 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -400,12 +400,14 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct radeon_framebuffer *radeon_fb;
 	struct drm_gem_object *obj;
+	struct radeon_bo *rbo;
 	uint64_t base;
 	uint32_t crtc_offset, crtc_offset_cntl, crtc_tile_x0_y0 = 0;
 	uint32_t crtc_pitch, pitch_pixels;
 	uint32_t tiling_flags;
 	int format;
 	uint32_t gen_cntl_reg, gen_cntl_val;
+	int r;
 
 	DRM_DEBUG("\n");
 
@@ -431,10 +433,22 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 		return false;
 	}
 
+	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
-	if (radeon_gem_object_pin(obj, RADEON_GEM_DOMAIN_VRAM, &base)) {
+	rbo = obj->driver_private;
+	r = radeon_bo_reserve(rbo, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &base);
+	if (unlikely(r != 0)) {
+		radeon_bo_unreserve(rbo);
 		return -EINVAL;
 	}
+	radeon_bo_get_tiling_flags(rbo, &tiling_flags, NULL);
+	radeon_bo_unreserve(rbo);
+	if (tiling_flags & RADEON_TILING_MICRO)
+		DRM_ERROR("trying to scanout microtiled buffer\n");
+
 	/* if scanout was in GTT this really wouldn't work */
 	/* crtc offset is from display base addr not FB location */
 	radeon_crtc->legacy_display_base_addr = rdev->mc.vram_location;
@@ -449,10 +463,6 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 		       (crtc->fb->bits_per_pixel * 8));
 	crtc_pitch |= crtc_pitch << 16;
 
-	radeon_object_get_tiling_flags(obj->driver_private,
-				       &tiling_flags, NULL);
-	if (tiling_flags & RADEON_TILING_MICRO)
-		DRM_ERROR("trying to scanout microtiled buffer\n");
 
 	if (tiling_flags & RADEON_TILING_MACRO) {
 		if (ASIC_IS_R300(rdev))
@@ -530,7 +540,12 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 	if (old_fb && old_fb != crtc->fb) {
 		radeon_fb = to_radeon_framebuffer(old_fb);
-		radeon_gem_object_unpin(radeon_fb->obj);
+		rbo = radeon_fb->obj->driver_private;
+		r = radeon_bo_reserve(rbo, false);
+		if (unlikely(r != 0))
+			return r;
+		radeon_bo_unpin(rbo);
+		radeon_bo_unreserve(rbo);
 	}
 
 	/* Bytes per pixel may have changed */
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 1f056da..bec4943 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -34,74 +34,32 @@
 #include "radeon_drm.h"
 #include "radeon.h"
 
-struct radeon_object {
-	struct ttm_buffer_object	tobj;
-	struct list_head		list;
-	struct radeon_device		*rdev;
-	struct drm_gem_object		*gobj;
-	struct ttm_bo_kmap_obj		kmap;
-	unsigned			pin_count;
-	uint64_t			gpu_addr;
-	void				*kptr;
-	bool				is_iomem;
-	uint32_t			tiling_flags;
-	uint32_t			pitch;
-	int				surface_reg;
-};
 
 int radeon_ttm_init(struct radeon_device *rdev);
 void radeon_ttm_fini(struct radeon_device *rdev);
+static void radeon_bo_clear_surface_reg(struct radeon_bo *bo);
 
 /*
  * To exclude mutual BO access we rely on bo_reserve exclusion, as all
  * function are calling it.
  */
 
-static int radeon_object_reserve(struct radeon_object *robj, bool interruptible)
+static void radeon_ttm_bo_destroy(struct ttm_buffer_object *tbo)
 {
-	return ttm_bo_reserve(&robj->tobj, interruptible, false, false, 0);
-}
+	struct radeon_bo *bo;
 
-static void radeon_object_unreserve(struct radeon_object *robj)
-{
-	ttm_bo_unreserve(&robj->tobj);
+	bo = container_of(tbo, struct radeon_bo, tbo);
+	mutex_lock(&bo->rdev->gem.mutex);
+	list_del_init(&bo->list);
+	mutex_unlock(&bo->rdev->gem.mutex);
+	radeon_bo_clear_surface_reg(bo);
+	kfree(bo);
 }
 
-static void radeon_ttm_object_object_destroy(struct ttm_buffer_object *tobj)
+static inline u32 radeon_ttm_flags_from_domain(u32 domain)
 {
-	struct radeon_object *robj;
-
-	robj = container_of(tobj, struct radeon_object, tobj);
-	list_del_init(&robj->list);
-	radeon_object_clear_surface_reg(robj);
-	kfree(robj);
-}
-
-static inline void radeon_object_gpu_addr(struct radeon_object *robj)
-{
-	/* Default gpu address */
-	robj->gpu_addr = 0xFFFFFFFFFFFFFFFFULL;
-	if (robj->tobj.mem.mm_node == NULL) {
-		return;
-	}
-	robj->gpu_addr = ((u64)robj->tobj.mem.mm_node->start) << PAGE_SHIFT;
-	switch (robj->tobj.mem.mem_type) {
-	case TTM_PL_VRAM:
-		robj->gpu_addr += (u64)robj->rdev->mc.vram_location;
-		break;
-	case TTM_PL_TT:
-		robj->gpu_addr += (u64)robj->rdev->mc.gtt_location;
-		break;
-	default:
-		DRM_ERROR("Unknown placement %d\n", robj->tobj.mem.mem_type);
-		robj->gpu_addr = 0xFFFFFFFFFFFFFFFFULL;
-		return;
-	}
-}
+	u32 flags = 0;
 
-static inline uint32_t radeon_object_flags_from_domain(uint32_t domain)
-{
-	uint32_t flags = 0;
 	if (domain & RADEON_GEM_DOMAIN_VRAM) {
 		flags |= TTM_PL_FLAG_VRAM | TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
 	}
@@ -117,17 +75,13 @@ static inline uint32_t radeon_object_flags_from_domain(uint32_t domain)
 	return flags;
 }
 
-int radeon_object_create(struct radeon_device *rdev,
-			 struct drm_gem_object *gobj,
-			 unsigned long size,
-			 bool kernel,
-			 uint32_t domain,
-			 bool interruptible,
-			 struct radeon_object **robj_ptr)
+int radeon_bo_create(struct radeon_device *rdev, struct drm_gem_object *gobj,
+			unsigned long size, bool kernel, u32 domain,
+			struct radeon_bo **bo_ptr)
 {
-	struct radeon_object *robj;
+	struct radeon_bo *bo;
 	enum ttm_bo_type type;
-	uint32_t flags;
+	u32 flags;
 	int r;
 
 	if (unlikely(rdev->mman.bdev.dev_mapping == NULL)) {
@@ -138,206 +92,140 @@ int radeon_object_create(struct radeon_device *rdev,
 	} else {
 		type = ttm_bo_type_device;
 	}
-	*robj_ptr = NULL;
-	robj = kzalloc(sizeof(struct radeon_object), GFP_KERNEL);
-	if (robj == NULL) {
+	*bo_ptr = NULL;
+	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
+	if (bo == NULL)
 		return -ENOMEM;
-	}
-	robj->rdev = rdev;
-	robj->gobj = gobj;
-	robj->surface_reg = -1;
-	INIT_LIST_HEAD(&robj->list);
-
-	flags = radeon_object_flags_from_domain(domain);
-	r = ttm_buffer_object_init(&rdev->mman.bdev, &robj->tobj, size, type, flags,
-				   0, 0, false, NULL, size,
-				   &radeon_ttm_object_object_destroy);
+	bo->rdev = rdev;
+	bo->gobj = gobj;
+	bo->surface_reg = -1;
+	INIT_LIST_HEAD(&bo->list);
+
+	flags = radeon_ttm_flags_from_domain(domain);
+retry:
+	r = ttm_buffer_object_init(&rdev->mman.bdev, &bo->tbo, size, type,
+					flags, 0, 0, true, NULL, size,
+					&radeon_ttm_bo_destroy);
 	if (unlikely(r != 0)) {
+		if (r == -ERESTART)
+			goto retry;
 		/* ttm call radeon_ttm_object_object_destroy if error happen */
-		DRM_ERROR("Failed to allocate TTM object (%ld, 0x%08X, %u)\n",
-			  size, flags, 0);
+		dev_err(rdev->dev, "object_init failed for (%ld, 0x%08X)\n",
+			size, flags);
 		return r;
 	}
-	*robj_ptr = robj;
+	*bo_ptr = bo;
 	if (gobj) {
-		list_add_tail(&robj->list, &rdev->gem.objects);
+		mutex_lock(&bo->rdev->gem.mutex);
+		list_add_tail(&bo->list, &rdev->gem.objects);
+		mutex_unlock(&bo->rdev->gem.mutex);
 	}
 	return 0;
 }
 
-int radeon_object_kmap(struct radeon_object *robj, void **ptr)
+int radeon_bo_kmap(struct radeon_bo *bo, void **ptr)
 {
+	bool is_iomem;
 	int r;
 
-	spin_lock(&robj->tobj.lock);
-	if (robj->kptr) {
+	if (bo->kptr) {
 		if (ptr) {
-			*ptr = robj->kptr;
+			*ptr = bo->kptr;
 		}
-		spin_unlock(&robj->tobj.lock);
 		return 0;
 	}
-	spin_unlock(&robj->tobj.lock);
-	r = ttm_bo_kmap(&robj->tobj, 0, robj->tobj.num_pages, &robj->kmap);
+	r = ttm_bo_kmap(&bo->tbo, 0, bo->tbo.num_pages, &bo->kmap);
 	if (r) {
 		return r;
 	}
-	spin_lock(&robj->tobj.lock);
-	robj->kptr = ttm_kmap_obj_virtual(&robj->kmap, &robj->is_iomem);
-	spin_unlock(&robj->tobj.lock);
+	bo->kptr = ttm_kmap_obj_virtual(&bo->kmap, &is_iomem);
 	if (ptr) {
-		*ptr = robj->kptr;
+		*ptr = bo->kptr;
 	}
-	radeon_object_check_tiling(robj, 0, 0);
+	radeon_bo_check_tiling(bo, 0, 0);
 	return 0;
 }
 
-void radeon_object_kunmap(struct radeon_object *robj)
+void radeon_bo_kunmap(struct radeon_bo *bo)
 {
-	spin_lock(&robj->tobj.lock);
-	if (robj->kptr == NULL) {
-		spin_unlock(&robj->tobj.lock);
+	if (bo->kptr == NULL)
 		return;
-	}
-	robj->kptr = NULL;
-	spin_unlock(&robj->tobj.lock);
-	radeon_object_check_tiling(robj, 0, 0);
-	ttm_bo_kunmap(&robj->kmap);
+	bo->kptr = NULL;
+	radeon_bo_check_tiling(bo, 0, 0);
+	ttm_bo_kunmap(&bo->kmap);
 }
 
-void radeon_object_unref(struct radeon_object **robj)
+void radeon_bo_unref(struct radeon_bo **bo)
 {
-	struct ttm_buffer_object *tobj;
+	struct ttm_buffer_object *tbo;
 
-	if ((*robj) == NULL) {
+	if ((*bo) == NULL)
 		return;
-	}
-	tobj = &((*robj)->tobj);
-	ttm_bo_unref(&tobj);
-	if (tobj == NULL) {
-		*robj = NULL;
-	}
-}
-
-int radeon_object_mmap(struct radeon_object *robj, uint64_t *offset)
-{
-	*offset = robj->tobj.addr_space_offset;
-	return 0;
+	tbo = &((*bo)->tbo);
+	ttm_bo_unref(&tbo);
+	if (tbo == NULL)
+		*bo = NULL;
 }
 
-int radeon_object_pin(struct radeon_object *robj, uint32_t domain,
-		      uint64_t *gpu_addr)
+int radeon_bo_pin(struct radeon_bo *bo, u32 domain, u64 *gpu_addr)
 {
-	uint32_t flags;
-	uint32_t tmp;
+	u32 flags;
+	u32 tmp;
 	int r;
 
-	flags = radeon_object_flags_from_domain(domain);
-	spin_lock(&robj->tobj.lock);
-	if (robj->pin_count) {
-		robj->pin_count++;
-		if (gpu_addr != NULL) {
-			*gpu_addr = robj->gpu_addr;
-		}
-		spin_unlock(&robj->tobj.lock);
+	flags = radeon_ttm_flags_from_domain(domain);
+	if (bo->pin_count) {
+		bo->pin_count++;
+		if (gpu_addr)
+			*gpu_addr = radeon_bo_gpu_offset(bo);
 		return 0;
 	}
-	spin_unlock(&robj->tobj.lock);
-	r = radeon_object_reserve(robj, false);
-	if (unlikely(r != 0)) {
-		DRM_ERROR("radeon: failed to reserve object for pinning it.\n");
-		return r;
-	}
-	tmp = robj->tobj.mem.placement;
+	tmp = bo->tbo.mem.placement;
 	ttm_flag_masked(&tmp, flags, TTM_PL_MASK_MEM);
-	robj->tobj.proposed_placement = tmp | TTM_PL_FLAG_NO_EVICT | TTM_PL_MASK_CACHING;
-	r = ttm_buffer_object_validate(&robj->tobj,
-				       robj->tobj.proposed_placement,
-				       false, false);
-	radeon_object_gpu_addr(robj);
-	if (gpu_addr != NULL) {
-		*gpu_addr = robj->gpu_addr;
+	bo->tbo.proposed_placement = tmp | TTM_PL_FLAG_NO_EVICT |
+					TTM_PL_MASK_CACHING;
+retry:
+	r = ttm_buffer_object_validate(&bo->tbo, bo->tbo.proposed_placement,
+					true, false);
+	if (likely(r == 0)) {
+		bo->pin_count = 1;
+		if (gpu_addr != NULL)
+			*gpu_addr = radeon_bo_gpu_offset(bo);
 	}
-	robj->pin_count = 1;
 	if (unlikely(r != 0)) {
-		DRM_ERROR("radeon: failed to pin object.\n");
+		if (r == -ERESTART)
+			goto retry;
+		dev_err(bo->rdev->dev, "%p pin failed\n", bo);
 	}
-	radeon_object_unreserve(robj);
 	return r;
 }
 
-void radeon_object_unpin(struct radeon_object *robj)
+int radeon_bo_unpin(struct radeon_bo *bo)
 {
-	uint32_t flags;
 	int r;
 
-	spin_lock(&robj->tobj.lock);
-	if (!robj->pin_count) {
-		spin_unlock(&robj->tobj.lock);
-		printk(KERN_WARNING "Unpin not necessary for %p !\n", robj);
-		return;
-	}
-	robj->pin_count--;
-	if (robj->pin_count) {
-		spin_unlock(&robj->tobj.lock);
-		return;
-	}
-	spin_unlock(&robj->tobj.lock);
-	r = radeon_object_reserve(robj, false);
-	if (unlikely(r != 0)) {
-		DRM_ERROR("radeon: failed to reserve object for unpinning it.\n");
-		return;
-	}
-	flags = robj->tobj.mem.placement;
-	robj->tobj.proposed_placement = flags & ~TTM_PL_FLAG_NO_EVICT;
-	r = ttm_buffer_object_validate(&robj->tobj,
-				       robj->tobj.proposed_placement,
-				       false, false);
-	if (unlikely(r != 0)) {
-		DRM_ERROR("radeon: failed to unpin buffer.\n");
-	}
-	radeon_object_unreserve(robj);
-}
-
-int radeon_object_wait(struct radeon_object *robj)
-{
-	int r = 0;
-
-	/* FIXME: should use block reservation instead */
-	r = radeon_object_reserve(robj, true);
-	if (unlikely(r != 0)) {
-		DRM_ERROR("radeon: failed to reserve object for waiting.\n");
-		return r;
-	}
-	spin_lock(&robj->tobj.lock);
-	if (robj->tobj.sync_obj) {
-		r = ttm_bo_wait(&robj->tobj, true, true, false);
+	if (!bo->pin_count) {
+		dev_warn(bo->rdev->dev, "%p unpin not necessary\n", bo);
+		return 0;
 	}
-	spin_unlock(&robj->tobj.lock);
-	radeon_object_unreserve(robj);
-	return r;
-}
-
-int radeon_object_busy_domain(struct radeon_object *robj, uint32_t *cur_placement)
-{
-	int r = 0;
-
-	r = radeon_object_reserve(robj, true);
+	bo->pin_count--;
+	if (bo->pin_count)
+		return 0;
+	bo->tbo.proposed_placement = bo->tbo.mem.placement &
+					~TTM_PL_FLAG_NO_EVICT;
+retry:
+	r = ttm_buffer_object_validate(&bo->tbo, bo->tbo.proposed_placement,
+					true, false);
 	if (unlikely(r != 0)) {
-		DRM_ERROR("radeon: failed to reserve object for waiting.\n");
+		if (r == -ERESTART)
+			goto retry;
+		dev_err(bo->rdev->dev, "%p validate failed for unpin\n", bo);
 		return r;
 	}
-	spin_lock(&robj->tobj.lock);
-	*cur_placement = robj->tobj.mem.mem_type;
-	if (robj->tobj.sync_obj) {
-		r = ttm_bo_wait(&robj->tobj, true, true, true);
-	}
-	spin_unlock(&robj->tobj.lock);
-	radeon_object_unreserve(robj);
-	return r;
+	return 0;
 }
 
-int radeon_object_evict_vram(struct radeon_device *rdev)
+int radeon_bo_evict_vram(struct radeon_device *rdev)
 {
 	if (rdev->flags & RADEON_IS_IGP) {
 		/* Useless to evict on IGP chips */
@@ -346,30 +234,32 @@ int radeon_object_evict_vram(struct radeon_device *rdev)
 	return ttm_bo_evict_mm(&rdev->mman.bdev, TTM_PL_VRAM);
 }
 
-void radeon_object_force_delete(struct radeon_device *rdev)
+void radeon_bo_force_delete(struct radeon_device *rdev)
 {
-	struct radeon_object *robj, *n;
+	struct radeon_bo *bo, *n;
 	struct drm_gem_object *gobj;
 
 	if (list_empty(&rdev->gem.objects)) {
 		return;
 	}
-	DRM_ERROR("Userspace still has active objects !\n");
-	list_for_each_entry_safe(robj, n, &rdev->gem.objects, list) {
+	dev_err(rdev->dev, "Userspace still has active objects !\n");
+	list_for_each_entry_safe(bo, n, &rdev->gem.objects, list) {
 		mutex_lock(&rdev->ddev->struct_mutex);
-		gobj = robj->gobj;
-		DRM_ERROR("Force free for (%p,%p,%lu,%lu)\n",
-			  gobj, robj, (unsigned long)gobj->size,
-			  *((unsigned long *)&gobj->refcount));
-		list_del_init(&robj->list);
-		radeon_object_unref(&robj);
+		gobj = bo->gobj;
+		dev_err(rdev->dev, "%p %p %lu %lu force free\n",
+			gobj, bo, (unsigned long)gobj->size,
+			*((unsigned long *)&gobj->refcount));
+		mutex_lock(&bo->rdev->gem.mutex);
+		list_del_init(&bo->list);
+		mutex_unlock(&bo->rdev->gem.mutex);
+		radeon_bo_unref(&bo);
 		gobj->driver_private = NULL;
 		drm_gem_object_unreference(gobj);
 		mutex_unlock(&rdev->ddev->struct_mutex);
 	}
 }
 
-int radeon_object_init(struct radeon_device *rdev)
+int radeon_bo_init(struct radeon_device *rdev)
 {
 	/* Add an MTRR for the VRAM */
 	rdev->mc.vram_mtrr = mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
@@ -382,13 +272,13 @@ int radeon_object_init(struct radeon_device *rdev)
 	return radeon_ttm_init(rdev);
 }
 
-void radeon_object_fini(struct radeon_device *rdev)
+void radeon_bo_fini(struct radeon_device *rdev)
 {
 	radeon_ttm_fini(rdev);
 }
 
-void radeon_object_list_add_object(struct radeon_object_list *lobj,
-				   struct list_head *head)
+void radeon_bo_list_add_object(struct radeon_bo_list *lobj,
+				struct list_head *head)
 {
 	if (lobj->wdomain) {
 		list_add(&lobj->list, head);
@@ -397,72 +287,67 @@ void radeon_object_list_add_object(struct radeon_object_list *lobj,
 	}
 }
 
-int radeon_object_list_reserve(struct list_head *head)
+int radeon_bo_list_reserve(struct list_head *head)
 {
-	struct radeon_object_list *lobj;
+	struct radeon_bo_list *lobj;
 	int r;
 
 	list_for_each_entry(lobj, head, list){
-		if (!lobj->robj->pin_count) {
-			r = radeon_object_reserve(lobj->robj, true);
-			if (unlikely(r != 0)) {
-				DRM_ERROR("radeon: failed to reserve object.\n");
-				return r;
-			}
-		} else {
-		}
+		r = radeon_bo_reserve(lobj->bo, false);
+		if (unlikely(r != 0))
+			return r;
 	}
 	return 0;
 }
 
-void radeon_object_list_unreserve(struct list_head *head)
+void radeon_bo_list_unreserve(struct list_head *head)
 {
-	struct radeon_object_list *lobj;
+	struct radeon_bo_list *lobj;
 
 	list_for_each_entry(lobj, head, list) {
-		if (!lobj->robj->pin_count) {
-			radeon_object_unreserve(lobj->robj);
-		}
+		/* only unreserve object we successfully reserved */
+		if (radeon_bo_is_reserved(lobj->bo))
+			radeon_bo_unreserve(lobj->bo);
 	}
 }
 
-int radeon_object_list_validate(struct list_head *head, void *fence)
+int radeon_bo_list_validate(struct list_head *head, void *fence)
 {
-	struct radeon_object_list *lobj;
-	struct radeon_object *robj;
+	struct radeon_bo_list *lobj;
+	struct radeon_bo *bo;
 	struct radeon_fence *old_fence = NULL;
 	int r;
 
-	r = radeon_object_list_reserve(head);
+	r = radeon_bo_list_reserve(head);
 	if (unlikely(r != 0)) {
-		radeon_object_list_unreserve(head);
 		return r;
 	}
 	list_for_each_entry(lobj, head, list) {
-		robj = lobj->robj;
-		if (!robj->pin_count) {
+		bo = lobj->bo;
+		if (!bo->pin_count) {
 			if (lobj->wdomain) {
-				robj->tobj.proposed_placement =
-					radeon_object_flags_from_domain(lobj->wdomain);
+				bo->tbo.proposed_placement =
+					radeon_ttm_flags_from_domain(lobj->wdomain);
 			} else {
-				robj->tobj.proposed_placement =
-					radeon_object_flags_from_domain(lobj->rdomain);
+				bo->tbo.proposed_placement =
+					radeon_ttm_flags_from_domain(lobj->rdomain);
 			}
-			r = ttm_buffer_object_validate(&robj->tobj,
-						       robj->tobj.proposed_placement,
-						       true, false);
+retry:
+			r = ttm_buffer_object_validate(&bo->tbo,
+						bo->tbo.proposed_placement,
+						true, false);
 			if (unlikely(r)) {
-				DRM_ERROR("radeon: failed to validate.\n");
+				if (r == -ERESTART)
+					goto retry;
 				return r;
 			}
-			radeon_object_gpu_addr(robj);
 		}
-		lobj->gpu_offset = robj->gpu_addr;
-		lobj->tiling_flags = robj->tiling_flags;
+		lobj->gpu_offset = radeon_bo_gpu_offset(bo);
+		lobj->tiling_flags = bo->tiling_flags;
 		if (fence) {
-			old_fence = (struct radeon_fence *)robj->tobj.sync_obj;
-			robj->tobj.sync_obj = radeon_fence_ref(fence);
-			robj->tobj.sync_obj_arg = NULL;
+			old_fence = (struct radeon_fence *)bo->tbo.sync_obj;
+			bo->tbo.sync_obj = radeon_fence_ref(fence);
+			bo->tbo.sync_obj_arg = NULL;
 		}
 		if (old_fence) {
 			radeon_fence_unref(&old_fence);
@@ -471,51 +356,44 @@ int radeon_object_list_validate(struct list_head *head, void *fence)
 	return 0;
 }
 
-void radeon_object_list_unvalidate(struct list_head *head)
+void radeon_bo_list_unvalidate(struct list_head *head, void *fence)
 {
-	struct radeon_object_list *lobj;
-	struct radeon_fence *old_fence = NULL;
+	struct radeon_bo_list *lobj;
+	struct radeon_fence *old_fence;
 
-	list_for_each_entry(lobj, head, list) {
-		old_fence = (struct radeon_fence *)lobj->robj->tobj.sync_obj;
-		lobj->robj->tobj.sync_obj = NULL;
-		if (old_fence) {
-			radeon_fence_unref(&old_fence);
+	if (fence)
+		list_for_each_entry(lobj, head, list) {
+			old_fence = to_radeon_fence(lobj->bo->tbo.sync_obj);
+			if (old_fence == fence) {
+				lobj->bo->tbo.sync_obj = NULL;
+				radeon_fence_unref(&old_fence);
+			}
 		}
-	}
-	radeon_object_list_unreserve(head);
-}
-
-void radeon_object_list_clean(struct list_head *head)
-{
-	radeon_object_list_unreserve(head);
+	radeon_bo_list_unreserve(head);
 }
 
-int radeon_object_fbdev_mmap(struct radeon_object *robj,
+int radeon_bo_fbdev_mmap(struct radeon_bo *bo,
 			     struct vm_area_struct *vma)
 {
-	return ttm_fbdev_mmap(vma, &robj->tobj);
+	return ttm_fbdev_mmap(vma, &bo->tbo);
 }
 
-unsigned long radeon_object_size(struct radeon_object *robj)
+static int radeon_bo_get_surface_reg(struct radeon_bo *bo)
 {
-	return robj->tobj.num_pages << PAGE_SHIFT;
-}
-
-int radeon_object_get_surface_reg(struct radeon_object *robj)
-{
-	struct radeon_device *rdev = robj->rdev;
+	struct radeon_device *rdev = bo->rdev;
 	struct radeon_surface_reg *reg;
-	struct radeon_object *old_object;
+	struct radeon_bo *old_object;
 	int steal;
 	int i;
 
-	if (!robj->tiling_flags)
+	BUG_ON(!atomic_read(&bo->tbo.reserved));
+
+	if (!bo->tiling_flags)
 		return 0;
 
-	if (robj->surface_reg >= 0) {
-		reg = &rdev->surface_regs[robj->surface_reg];
-		i = robj->surface_reg;
+	if (bo->surface_reg >= 0) {
+		reg = &rdev->surface_regs[bo->surface_reg];
+		i = bo->surface_reg;
 		goto out;
 	}
 
@@ -523,10 +401,10 @@ int radeon_object_get_surface_reg(struct radeon_object *robj)
 	for (i = 0; i < RADEON_GEM_MAX_SURFACES; i++) {
 
 		reg = &rdev->surface_regs[i];
-		if (!reg->robj)
+		if (!reg->bo)
 			break;
 
-		old_object = reg->robj;
+		old_object = reg->bo;
 		if (old_object->pin_count == 0)
 			steal = i;
 	}
@@ -537,91 +415,101 @@ int radeon_object_get_surface_reg(struct radeon_object *robj)
 			return -ENOMEM;
 		/* find someone with a surface reg and nuke their BO */
 		reg = &rdev->surface_regs[steal];
-		old_object = reg->robj;
+		old_object = reg->bo;
 		/* blow away the mapping */
 		DRM_DEBUG("stealing surface reg %d from %p\n", steal, old_object);
-		ttm_bo_unmap_virtual(&old_object->tobj);
+		ttm_bo_unmap_virtual(&old_object->tbo);
 		old_object->surface_reg = -1;
 		i = steal;
 	}
 
-	robj->surface_reg = i;
-	reg->robj = robj;
+	bo->surface_reg = i;
+	reg->bo = bo;
 
 out:
-	radeon_set_surface_reg(rdev, i, robj->tiling_flags, robj->pitch,
-			       robj->tobj.mem.mm_node->start << PAGE_SHIFT,
-			       robj->tobj.num_pages << PAGE_SHIFT);
+	radeon_set_surface_reg(rdev, i, bo->tiling_flags, bo->pitch,
+			       bo->tbo.mem.mm_node->start << PAGE_SHIFT,
+			       bo->tbo.num_pages << PAGE_SHIFT);
 	return 0;
 }
 
-void radeon_object_clear_surface_reg(struct radeon_object *robj)
+static void radeon_bo_clear_surface_reg(struct radeon_bo *bo)
 {
-	struct radeon_device *rdev = robj->rdev;
+	struct radeon_device *rdev = bo->rdev;
 	struct radeon_surface_reg *reg;
 
-	if (robj->surface_reg == -1)
+	if (bo->surface_reg == -1)
 		return;
 
-	reg = &rdev->surface_regs[robj->surface_reg];
-	radeon_clear_surface_reg(rdev, robj->surface_reg);
+	reg = &rdev->surface_regs[bo->surface_reg];
+	radeon_clear_surface_reg(rdev, bo->surface_reg);
 
-	reg->robj = NULL;
-	robj->surface_reg = -1;
+	reg->bo = NULL;
+	bo->surface_reg = -1;
 }
 
-void radeon_object_set_tiling_flags(struct radeon_object *robj,
-				    uint32_t tiling_flags, uint32_t pitch)
+int radeon_bo_set_tiling_flags(struct radeon_bo *bo,
+				uint32_t tiling_flags, uint32_t pitch)
 {
-	robj->tiling_flags = tiling_flags;
-	robj->pitch = pitch;
+	int r;
+
+	r = radeon_bo_reserve(bo, false);
+	if (unlikely(r != 0))
+		return r;
+	bo->tiling_flags = tiling_flags;
+	bo->pitch = pitch;
+	radeon_bo_unreserve(bo);
+	return 0;
 }
 
-void radeon_object_get_tiling_flags(struct radeon_object *robj,
-				    uint32_t *tiling_flags,
-				    uint32_t *pitch)
+void radeon_bo_get_tiling_flags(struct radeon_bo *bo,
+				uint32_t *tiling_flags,
+				uint32_t *pitch)
 {
+	BUG_ON(!atomic_read(&bo->tbo.reserved));
 	if (tiling_flags)
-		*tiling_flags = robj->tiling_flags;
+		*tiling_flags = bo->tiling_flags;
 	if (pitch)
-		*pitch = robj->pitch;
+		*pitch = bo->pitch;
 }
 
-int radeon_object_check_tiling(struct radeon_object *robj, bool has_moved,
-			       bool force_drop)
+int radeon_bo_check_tiling(struct radeon_bo *bo, bool has_moved,
+				bool force_drop)
 {
-	if (!(robj->tiling_flags & RADEON_TILING_SURFACE))
+	BUG_ON(!atomic_read(&bo->tbo.reserved));
+
+	if (!(bo->tiling_flags & RADEON_TILING_SURFACE))
 		return 0;
 
 	if (force_drop) {
-		radeon_object_clear_surface_reg(robj);
+		radeon_bo_clear_surface_reg(bo);
 		return 0;
 	}
 
-	if (robj->tobj.mem.mem_type != TTM_PL_VRAM) {
+	if (bo->tbo.mem.mem_type != TTM_PL_VRAM) {
 		if (!has_moved)
 			return 0;
 
-		if (robj->surface_reg >= 0)
-			radeon_object_clear_surface_reg(robj);
+		if (bo->surface_reg >= 0)
+			radeon_bo_clear_surface_reg(bo);
 		return 0;
 	}
 
-	if ((robj->surface_reg >= 0) && !has_moved)
+	if ((bo->surface_reg >= 0) && !has_moved)
 		return 0;
 
-	return radeon_object_get_surface_reg(robj);
+	return radeon_bo_get_surface_reg(bo);
 }
 
 void radeon_bo_move_notify(struct ttm_buffer_object *bo,
-			  struct ttm_mem_reg *mem)
+				struct ttm_mem_reg *mem)
 {
-	struct radeon_object *robj = container_of(bo, struct radeon_object, tobj);
-	radeon_object_check_tiling(robj, 0, 1);
+	struct radeon_bo *rbo = container_of(bo, struct radeon_bo, tbo);
+	radeon_bo_check_tiling(rbo, 0, 1);
 }
 
 void radeon_bo_fault_reserve_notify(struct ttm_buffer_object *bo)
 {
-	struct radeon_object *robj = container_of(bo, struct radeon_object, tobj);
-	radeon_object_check_tiling(robj, 0, 0);
+	struct radeon_bo *rbo = container_of(bo, struct radeon_bo, tbo);
+	radeon_bo_check_tiling(rbo, 0, 0);
 }
diff --git a/drivers/gpu/drm/radeon/radeon_object.h b/drivers/gpu/drm/radeon/radeon_object.h
index 10e8af6..e9da130 100644
--- a/drivers/gpu/drm/radeon/radeon_object.h
+++ b/drivers/gpu/drm/radeon/radeon_object.h
@@ -28,19 +28,152 @@
 #ifndef __RADEON_OBJECT_H__
 #define __RADEON_OBJECT_H__
 
-#include <ttm/ttm_bo_api.h>
-#include <ttm/ttm_bo_driver.h>
-#include <ttm/ttm_placement.h>
-#include <ttm/ttm_module.h>
+#include <drm/radeon_drm.h>
+#include "radeon.h"
 
-/*
- * TTM.
+/**
+ * radeon_mem_type_to_domain - return domain corresponding to mem_type
+ * @mem_type:	ttm memory type
+ *
+ * Returns corresponding domain of the ttm mem_type
+ */
+static inline unsigned radeon_mem_type_to_domain(u32 mem_type)
+{
+	switch (mem_type) {
+	case TTM_PL_VRAM:
+		return RADEON_GEM_DOMAIN_VRAM;
+	case TTM_PL_TT:
+		return RADEON_GEM_DOMAIN_GTT;
+	case TTM_PL_SYSTEM:
+		return RADEON_GEM_DOMAIN_CPU;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/**
+ * radeon_bo_reserve - reserve bo
+ * @bo:		bo structure
+ * @no_wait:		don't sleep while trying to reserve (return -EBUSY)
+ *
+ * Returns:
+ * -EBUSY: buffer is busy and @no_wait is true
+ * -ERESTART: A wait for the buffer to become unreserved was interrupted by
+ * a signal. Release all buffer reservations and return to user-space.
+ */
+static inline int radeon_bo_reserve(struct radeon_bo *bo, bool no_wait)
+{
+	int r;
+
+retry:
+	r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, 0);
+	if (unlikely(r != 0)) {
+		if (r == -ERESTART)
+			goto retry;
+		dev_err(bo->rdev->dev, "%p reserve failed\n", bo);
+		return r;
+	}
+	return 0;
+}
+
+static inline void radeon_bo_unreserve(struct radeon_bo *bo)
+{
+	ttm_bo_unreserve(&bo->tbo);
+}
+
+/**
+ * radeon_bo_gpu_offset - return GPU offset of bo
+ * @bo:	radeon object for which we query the offset
+ *
+ * Returns current GPU offset of the object.
+ *
+ * Note: object should either be pinned or reserved when calling this
+ * function, it might be usefull to add check for this for debugging.
+ */
+static inline u64 radeon_bo_gpu_offset(struct radeon_bo *bo)
+{
+	return bo->tbo.offset;
+}
+
+static inline unsigned long radeon_bo_size(struct radeon_bo *bo)
+{
+	return bo->tbo.num_pages << PAGE_SHIFT;
+}
+
+static inline bool radeon_bo_is_reserved(struct radeon_bo *bo)
+{
+	return !!atomic_read(&bo->tbo.reserved);
+}
+
+/**
+ * radeon_bo_mmap_offset - return mmap offset of bo
+ * @bo:	radeon object for which we query the offset
+ *
+ * Returns mmap offset of the object.
+ *
+ * Note: addr_space_offset is constant after ttm bo init thus isn't protected
+ * by any lock.
  */
-struct radeon_mman {
-	struct ttm_bo_global_ref        bo_global_ref;
-	struct ttm_global_reference	mem_global_ref;
-	bool				mem_global_referenced;
-	struct ttm_bo_device		bdev;
-};
+static inline u64 radeon_bo_mmap_offset(struct radeon_bo *bo)
+{
+	return bo->tbo.addr_space_offset;
+}
+
+static inline int radeon_bo_wait(struct radeon_bo *bo, u32 *mem_type,
+					bool no_wait)
+{
+	int r;
+
+retry:
+	r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, 0);
+	if (unlikely(r != 0)) {
+		if (r == -ERESTART)
+			goto retry;
+		dev_err(bo->rdev->dev, "%p reserve failed for wait\n", bo);
+		return r;
+	}
+	spin_lock(&bo->tbo.lock);
+	if (mem_type)
+		*mem_type = bo->tbo.mem.mem_type;
+	if (bo->tbo.sync_obj)
+		r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
+	spin_unlock(&bo->tbo.lock);
+	ttm_bo_unreserve(&bo->tbo);
+	if (unlikely(r == -ERESTART))
+		goto retry;
+	return r;
+}
+
+extern int radeon_bo_create(struct radeon_device *rdev,
+				struct drm_gem_object *gobj, unsigned long size,
+				bool kernel, u32 domain,
+				struct radeon_bo **bo_ptr);
+extern int radeon_bo_kmap(struct radeon_bo *bo, void **ptr);
+extern void radeon_bo_kunmap(struct radeon_bo *bo);
+extern void radeon_bo_unref(struct radeon_bo **bo);
+extern int radeon_bo_pin(struct radeon_bo *bo, u32 domain, u64 *gpu_addr);
+extern int radeon_bo_unpin(struct radeon_bo *bo);
+extern int radeon_bo_evict_vram(struct radeon_device *rdev);
+extern void radeon_bo_force_delete(struct radeon_device *rdev);
+extern int radeon_bo_init(struct radeon_device *rdev);
+extern void radeon_bo_fini(struct radeon_device *rdev);
+extern void radeon_bo_list_add_object(struct radeon_bo_list *lobj,
+				struct list_head *head);
+extern int radeon_bo_list_reserve(struct list_head *head);
+extern void radeon_bo_list_unreserve(struct list_head *head);
+extern int radeon_bo_list_validate(struct list_head *head, void *fence);
+extern void radeon_bo_list_unvalidate(struct list_head *head, void *fence);
+extern int radeon_bo_fbdev_mmap(struct radeon_bo *bo,
+				struct vm_area_struct *vma);
+extern int radeon_bo_set_tiling_flags(struct radeon_bo *bo,
+				u32 tiling_flags, u32 pitch);
+extern void radeon_bo_get_tiling_flags(struct radeon_bo *bo,
+				u32 *tiling_flags, u32 *pitch);
+extern int radeon_bo_check_tiling(struct radeon_bo *bo, bool has_moved,
+				bool force_drop);
+extern void radeon_bo_move_notify(struct ttm_buffer_object *bo,
+					struct ttm_mem_reg *mem);
+extern void radeon_bo_fault_reserve_notify(struct ttm_buffer_object *bo);
 
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 747b4bf..4d12b2d 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -165,19 +165,24 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 		return 0;
 	/* Allocate 1M object buffer */
 	INIT_LIST_HEAD(&rdev->ib_pool.scheduled_ibs);
-	r = radeon_object_create(rdev, NULL,  RADEON_IB_POOL_SIZE*64*1024,
-				 true, RADEON_GEM_DOMAIN_GTT,
-				 false, &rdev->ib_pool.robj);
+	r = radeon_bo_create(rdev, NULL,  RADEON_IB_POOL_SIZE*64*1024,
+				true, RADEON_GEM_DOMAIN_GTT,
+				&rdev->ib_pool.robj);
 	if (r) {
 		DRM_ERROR("radeon: failed to ib pool (%d).\n", r);
 		return r;
 	}
-	r = radeon_object_pin(rdev->ib_pool.robj, RADEON_GEM_DOMAIN_GTT, &gpu_addr);
+	r = radeon_bo_reserve(rdev->ib_pool.robj, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_pin(rdev->ib_pool.robj, RADEON_GEM_DOMAIN_GTT, &gpu_addr);
 	if (r) {
+		radeon_bo_unreserve(rdev->ib_pool.robj);
 		DRM_ERROR("radeon: failed to pin ib pool (%d).\n", r);
 		return r;
 	}
-	r = radeon_object_kmap(rdev->ib_pool.robj, &ptr);
+	r = radeon_bo_kmap(rdev->ib_pool.robj, &ptr);
+	radeon_bo_unreserve(rdev->ib_pool.robj);
 	if (r) {
 		DRM_ERROR("radeon: failed to map ib poll (%d).\n", r);
 		return r;
@@ -203,14 +208,21 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 
 void radeon_ib_pool_fini(struct radeon_device *rdev)
 {
+	int r;
+
 	if (!rdev->ib_pool.ready) {
 		return;
 	}
 	mutex_lock(&rdev->ib_pool.mutex);
 	bitmap_zero(rdev->ib_pool.alloc_bm, RADEON_IB_POOL_SIZE);
 	if (rdev->ib_pool.robj) {
-		radeon_object_kunmap(rdev->ib_pool.robj);
-		radeon_object_unref(&rdev->ib_pool.robj);
+		r = radeon_bo_reserve(rdev->ib_pool.robj, false);
+		if (likely(r == 0)) {
+			radeon_bo_kunmap(rdev->ib_pool.robj);
+			radeon_bo_unpin(rdev->ib_pool.robj);
+			radeon_bo_unreserve(rdev->ib_pool.robj);
+		}
+		radeon_bo_unref(&rdev->ib_pool.robj);
 		rdev->ib_pool.robj = NULL;
 	}
 	mutex_unlock(&rdev->ib_pool.mutex);
@@ -288,29 +300,28 @@ int radeon_ring_init(struct radeon_device *rdev, unsigned ring_size)
 	rdev->cp.ring_size = ring_size;
 	/* Allocate ring buffer */
 	if (rdev->cp.ring_obj == NULL) {
-		r = radeon_object_create(rdev, NULL, rdev->cp.ring_size,
-					 true,
-					 RADEON_GEM_DOMAIN_GTT,
-					 false,
-					 &rdev->cp.ring_obj);
+		r = radeon_bo_create(rdev, NULL, rdev->cp.ring_size, true,
+					RADEON_GEM_DOMAIN_GTT,
+					&rdev->cp.ring_obj);
 		if (r) {
-			DRM_ERROR("radeon: failed to create ring buffer (%d).\n", r);
-			mutex_unlock(&rdev->cp.mutex);
+			dev_err(rdev->dev, "(%d) ring create failed\n", r);
 			return r;
 		}
-		r = radeon_object_pin(rdev->cp.ring_obj,
-				      RADEON_GEM_DOMAIN_GTT,
-				      &rdev->cp.gpu_addr);
+		r = radeon_bo_reserve(rdev->cp.ring_obj, false);
+		if (unlikely(r != 0))
+			return r;
+		r = radeon_bo_pin(rdev->cp.ring_obj, RADEON_GEM_DOMAIN_GTT,
+					&rdev->cp.gpu_addr);
 		if (r) {
-			DRM_ERROR("radeon: failed to pin ring buffer (%d).\n", r);
-			mutex_unlock(&rdev->cp.mutex);
+			radeon_bo_unreserve(rdev->cp.ring_obj);
+			dev_err(rdev->dev, "(%d) ring pin failed\n", r);
 			return r;
 		}
-		r = radeon_object_kmap(rdev->cp.ring_obj,
+		r = radeon_bo_kmap(rdev->cp.ring_obj,
 				       (void **)&rdev->cp.ring);
+		radeon_bo_unreserve(rdev->cp.ring_obj);
 		if (r) {
-			DRM_ERROR("radeon: failed to map ring buffer (%d).\n", r);
-			mutex_unlock(&rdev->cp.mutex);
+			dev_err(rdev->dev, "(%d) ring map failed\n", r);
 			return r;
 		}
 	}
@@ -321,11 +332,17 @@ int radeon_ring_init(struct radeon_device *rdev, unsigned ring_size)
 
 void radeon_ring_fini(struct radeon_device *rdev)
 {
+	int r;
+
 	mutex_lock(&rdev->cp.mutex);
 	if (rdev->cp.ring_obj) {
-		radeon_object_kunmap(rdev->cp.ring_obj);
-		radeon_object_unpin(rdev->cp.ring_obj);
-		radeon_object_unref(&rdev->cp.ring_obj);
+		r = radeon_bo_reserve(rdev->cp.ring_obj, false);
+		if (likely(r == 0)) {
+			radeon_bo_kunmap(rdev->cp.ring_obj);
+			radeon_bo_unpin(rdev->cp.ring_obj);
+			radeon_bo_unreserve(rdev->cp.ring_obj);
+		}
+		radeon_bo_unref(&rdev->cp.ring_obj);
 		rdev->cp.ring = NULL;
 		rdev->cp.ring_obj = NULL;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_test.c b/drivers/gpu/drm/radeon/radeon_test.c
index f8a465d..391c973 100644
--- a/drivers/gpu/drm/radeon/radeon_test.c
+++ b/drivers/gpu/drm/radeon/radeon_test.c
@@ -30,8 +30,8 @@
 /* Test BO GTT->VRAM and VRAM->GTT GPU copies across the whole GTT aperture */
 void radeon_test_moves(struct radeon_device *rdev)
 {
-	struct radeon_object *vram_obj = NULL;
-	struct radeon_object **gtt_obj = NULL;
+	struct radeon_bo *vram_obj = NULL;
+	struct radeon_bo **gtt_obj = NULL;
 	struct radeon_fence *fence = NULL;
 	uint64_t gtt_addr, vram_addr;
 	unsigned i, n, size;
@@ -52,38 +52,42 @@ void radeon_test_moves(struct radeon_device *rdev)
 		goto out_cleanup;
 	}
 
-	r = radeon_object_create(rdev, NULL, size, true, RADEON_GEM_DOMAIN_VRAM,
-				 false, &vram_obj);
+	r = radeon_bo_create(rdev, NULL, size, true, RADEON_GEM_DOMAIN_VRAM,
+				&vram_obj);
 	if (r) {
 		DRM_ERROR("Failed to create VRAM object\n");
 		goto out_cleanup;
 	}
-
-	r = radeon_object_pin(vram_obj, RADEON_GEM_DOMAIN_VRAM, &vram_addr);
+	r = radeon_bo_reserve(vram_obj, false);
+	if (unlikely(r != 0))
+		goto out_cleanup;
+	r = radeon_bo_pin(vram_obj, RADEON_GEM_DOMAIN_VRAM, &vram_addr);
 	if (r) {
 		DRM_ERROR("Failed to pin VRAM object\n");
 		goto out_cleanup;
 	}
-
 	for (i = 0; i < n; i++) {
 		void *gtt_map, *vram_map;
 		void **gtt_start, **gtt_end;
 		void **vram_start, **vram_end;
 
-		r = radeon_object_create(rdev, NULL, size, true,
-					 RADEON_GEM_DOMAIN_GTT, false, gtt_obj + i);
+		r = radeon_bo_create(rdev, NULL, size, true,
+					 RADEON_GEM_DOMAIN_GTT, gtt_obj + i);
 		if (r) {
 			DRM_ERROR("Failed to create GTT object %d\n", i);
 			goto out_cleanup;
 		}
 
-		r = radeon_object_pin(gtt_obj[i], RADEON_GEM_DOMAIN_GTT, &gtt_addr);
+		r = radeon_bo_reserve(gtt_obj[i], false);
+		if (unlikely(r != 0))
+			goto out_cleanup;
+		r = radeon_bo_pin(gtt_obj[i], RADEON_GEM_DOMAIN_GTT, &gtt_addr);
 		if (r) {
 			DRM_ERROR("Failed to pin GTT object %d\n", i);
 			goto out_cleanup;
 		}
 
-		r = radeon_object_kmap(gtt_obj[i], &gtt_map);
+		r = radeon_bo_kmap(gtt_obj[i], &gtt_map);
 		if (r) {
 			DRM_ERROR("Failed to map GTT object %d\n", i);
 			goto out_cleanup;
@@ -94,7 +98,7 @@ void radeon_test_moves(struct radeon_device *rdev)
 		     gtt_start++)
 			*gtt_start = gtt_start;
 
-		radeon_object_kunmap(gtt_obj[i]);
+		radeon_bo_kunmap(gtt_obj[i]);
 
 		r = radeon_fence_create(rdev, &fence);
 		if (r) {
@@ -116,7 +120,7 @@ void radeon_test_moves(struct radeon_device *rdev)
 
 		radeon_fence_unref(&fence);
 
-		r = radeon_object_kmap(vram_obj, &vram_map);
+		r = radeon_bo_kmap(vram_obj, &vram_map);
 		if (r) {
 			DRM_ERROR("Failed to map VRAM object after copy %d\n", i);
 			goto out_cleanup;
@@ -131,13 +135,13 @@ void radeon_test_moves(struct radeon_device *rdev)
 					  "expected 0x%p (GTT map 0x%p-0x%p)\n",
 					  i, *vram_start, gtt_start, gtt_map,
 					  gtt_end);
-				radeon_object_kunmap(vram_obj);
+				radeon_bo_kunmap(vram_obj);
 				goto out_cleanup;
 			}
 			*vram_start = vram_start;
 		}
 
-		radeon_object_kunmap(vram_obj);
+		radeon_bo_kunmap(vram_obj);
 
 		r = radeon_fence_create(rdev, &fence);
 		if (r) {
@@ -159,7 +163,7 @@ void radeon_test_moves(struct radeon_device *rdev)
 
 		radeon_fence_unref(&fence);
 
-		r = radeon_object_kmap(gtt_obj[i], &gtt_map);
+		r = radeon_bo_kmap(gtt_obj[i], &gtt_map);
 		if (r) {
 			DRM_ERROR("Failed to map GTT object after copy %d\n", i);
 			goto out_cleanup;
@@ -174,12 +178,12 @@ void radeon_test_moves(struct radeon_device *rdev)
 					  "expected 0x%p (VRAM map 0x%p-0x%p)\n",
 					  i, *gtt_start, vram_start, vram_map,
 					  vram_end);
-				radeon_object_kunmap(gtt_obj[i]);
+				radeon_bo_kunmap(gtt_obj[i]);
 				goto out_cleanup;
 			}
 		}
 
-		radeon_object_kunmap(gtt_obj[i]);
+		radeon_bo_kunmap(gtt_obj[i]);
 
 		DRM_INFO("Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0x%llx\n",
 			 gtt_addr - rdev->mc.gtt_location);
@@ -187,14 +191,20 @@ void radeon_test_moves(struct radeon_device *rdev)
 
 out_cleanup:
 	if (vram_obj) {
-		radeon_object_unpin(vram_obj);
-		radeon_object_unref(&vram_obj);
+		if (radeon_bo_is_reserved(vram_obj)) {
+			radeon_bo_unpin(vram_obj);
+			radeon_bo_unreserve(vram_obj);
+		}
+		radeon_bo_unref(&vram_obj);
 	}
 	if (gtt_obj) {
 		for (i = 0; i < n; i++) {
 			if (gtt_obj[i]) {
-				radeon_object_unpin(gtt_obj[i]);
-				radeon_object_unref(&gtt_obj[i]);
+				if (radeon_bo_is_reserved(gtt_obj[i])) {
+					radeon_bo_unpin(gtt_obj[i]);
+					radeon_bo_unreserve(gtt_obj[i]);
+				}
+				radeon_bo_unref(&gtt_obj[i]);
 			}
 		}
 		kfree(gtt_obj);
@@ -206,4 +216,3 @@ out_cleanup:
 		printk(KERN_WARNING "Error while testing BO move.\n");
 	}
 }
-
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index f489c0d..6b6b459 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -150,7 +150,7 @@ static int radeon_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 		man->default_caching = TTM_PL_FLAG_CACHED;
 		break;
 	case TTM_PL_TT:
-		man->gpu_offset = 0;
+		man->gpu_offset = rdev->mc.gtt_location;
 		man->available_caching = TTM_PL_MASK_CACHING;
 		man->default_caching = TTM_PL_FLAG_CACHED;
 		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE | TTM_MEMTYPE_FLAG_CMA;
@@ -180,7 +180,7 @@ static int radeon_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 		break;
 	case TTM_PL_VRAM:
 		/* "On-card" video ram */
-		man->gpu_offset = 0;
+		man->gpu_offset = rdev->mc.vram_location;
 		man->flags = TTM_MEMTYPE_FLAG_FIXED |
 			     TTM_MEMTYPE_FLAG_NEEDS_IOREMAP |
 			     TTM_MEMTYPE_FLAG_MAPPABLE;
@@ -482,27 +482,31 @@ int radeon_ttm_init(struct radeon_device *rdev)
 		DRM_ERROR("failed initializing buffer object driver(%d).\n", r);
 		return r;
 	}
-	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_VRAM, 0,
-			   ((rdev->mc.real_vram_size) >> PAGE_SHIFT));
+	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_VRAM,
+				0, rdev->mc.real_vram_size >> PAGE_SHIFT);
 	if (r) {
 		DRM_ERROR("Failed initializing VRAM heap.\n");
 		return r;
 	}
-	r = radeon_object_create(rdev, NULL, 256 * 1024, true,
-				 RADEON_GEM_DOMAIN_VRAM, false,
-				 &rdev->stollen_vga_memory);
+	r = radeon_bo_create(rdev, NULL, 256 * 1024, true,
+				RADEON_GEM_DOMAIN_VRAM,
+				&rdev->stollen_vga_memory);
 	if (r) {
 		return r;
 	}
-	r = radeon_object_pin(rdev->stollen_vga_memory, RADEON_GEM_DOMAIN_VRAM, NULL);
+	r = radeon_bo_reserve(rdev->stollen_vga_memory, false);
+	if (r)
+		return r;
+	r = radeon_bo_pin(rdev->stollen_vga_memory, RADEON_GEM_DOMAIN_VRAM, NULL);
+	radeon_bo_unreserve(rdev->stollen_vga_memory);
 	if (r) {
-		radeon_object_unref(&rdev->stollen_vga_memory);
+		radeon_bo_unref(&rdev->stollen_vga_memory);
 		return r;
 	}
 	DRM_INFO("radeon: %uM of VRAM memory ready\n",
 		 (unsigned)rdev->mc.real_vram_size / (1024 * 1024));
-	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_TT, 0,
-			   ((rdev->mc.gtt_size) >> PAGE_SHIFT));
+	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_TT,
+				0, rdev->mc.gtt_size >> PAGE_SHIFT);
 	if (r) {
 		DRM_ERROR("Failed initializing GTT heap.\n");
 		return r;
@@ -523,9 +527,15 @@ int radeon_ttm_init(struct radeon_device *rdev)
 
 void radeon_ttm_fini(struct radeon_device *rdev)
 {
+	int r;
+
 	if (rdev->stollen_vga_memory) {
-		radeon_object_unpin(rdev->stollen_vga_memory);
-		radeon_object_unref(&rdev->stollen_vga_memory);
+		r = radeon_bo_reserve(rdev->stollen_vga_memory, false);
+		if (r == 0) {
+			radeon_bo_unpin(rdev->stollen_vga_memory);
+			radeon_bo_unreserve(rdev->stollen_vga_memory);
+		}
+		radeon_bo_unref(&rdev->stollen_vga_memory);
 	}
 	ttm_bo_clean_mm(&rdev->mman.bdev, TTM_PL_VRAM);
 	ttm_bo_clean_mm(&rdev->mman.bdev, TTM_PL_TT);
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index ca03716..968016b 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -452,7 +452,7 @@ void rs400_fini(struct radeon_device *rdev)
 	rs400_gart_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
@@ -510,7 +510,7 @@ int rs400_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	r = rs400_gart_init(rdev);
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 5f117cd..30dc65d 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -146,15 +146,20 @@ int rs600_gart_enable(struct radeon_device *rdev)
 
 void rs600_gart_disable(struct radeon_device *rdev)
 {
-	uint32_t tmp;
+	u32 tmp;
+	int r;
 
 	/* FIXME: disable out of gart access */
 	WREG32_MC(R_000100_MC_PT0_CNTL, 0);
 	tmp = RREG32_MC(R_000009_MC_CNTL1);
 	WREG32_MC(R_000009_MC_CNTL1, tmp & C_000009_ENABLE_PAGE_TABLES);
 	if (rdev->gart.table.vram.robj) {
-		radeon_object_kunmap(rdev->gart.table.vram.robj);
-		radeon_object_unpin(rdev->gart.table.vram.robj);
+		r = radeon_bo_reserve(rdev->gart.table.vram.robj, false);
+		if (r == 0) {
+			radeon_bo_kunmap(rdev->gart.table.vram.robj);
+			radeon_bo_unpin(rdev->gart.table.vram.robj);
+			radeon_bo_unreserve(rdev->gart.table.vram.robj);
+		}
 	}
 }
 
@@ -445,7 +450,7 @@ void rs600_fini(struct radeon_device *rdev)
 	rs600_gart_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
@@ -505,7 +510,7 @@ int rs600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	r = rs600_gart_init(rdev);
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 2754717..2d576af 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -662,7 +662,7 @@ void rs690_fini(struct radeon_device *rdev)
 	rs400_gart_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
@@ -723,7 +723,7 @@ int rs690_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	r = rs400_gart_init(rdev);
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 7935f79..10b10c1 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -541,11 +541,11 @@ void rv515_fini(struct radeon_device *rdev)
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
 	radeon_gem_fini(rdev);
-    rv370_pcie_gart_fini(rdev);
+	rv370_pcie_gart_fini(rdev);
 	radeon_agp_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
@@ -604,7 +604,7 @@ int rv515_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	r = rv370_pcie_gart_init(rdev);
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index b0efd0d..c90c7c3 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -92,7 +92,7 @@ int rv770_pcie_gart_enable(struct radeon_device *rdev)
 void rv770_pcie_gart_disable(struct radeon_device *rdev)
 {
 	u32 tmp;
-	int i;
+	int i, r;
 
 	/* Disable all tables */
 	for (i = 0; i < 7; i++)
@@ -113,8 +113,12 @@ void rv770_pcie_gart_disable(struct radeon_device *rdev)
 	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB3_CNTL, tmp);
 	if (rdev->gart.table.vram.robj) {
-		radeon_object_kunmap(rdev->gart.table.vram.robj);
-		radeon_object_unpin(rdev->gart.table.vram.robj);
+		r = radeon_bo_reserve(rdev->gart.table.vram.robj, false);
+		if (likely(r == 0)) {
+			radeon_bo_kunmap(rdev->gart.table.vram.robj);
+			radeon_bo_unpin(rdev->gart.table.vram.robj);
+			radeon_bo_unreserve(rdev->gart.table.vram.robj);
+		}
 	}
 }
 
@@ -880,8 +884,12 @@ static int rv770_startup(struct radeon_device *rdev)
 	}
 	rv770_gpu_init(rdev);
 
-	r = radeon_object_pin(rdev->r600_blit.shader_obj, RADEON_GEM_DOMAIN_VRAM,
-			      &rdev->r600_blit.shader_gpu_addr);
+	r = radeon_bo_reserve(rdev->r600_blit.shader_obj, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_pin(rdev->r600_blit.shader_obj, RADEON_GEM_DOMAIN_VRAM,
+			&rdev->r600_blit.shader_gpu_addr);
+	radeon_bo_unreserve(rdev->r600_blit.shader_obj);
 	if (r) {
 		DRM_ERROR("failed to pin blit object %d\n", r);
 		return r;
@@ -934,13 +942,19 @@ int rv770_resume(struct radeon_device *rdev)
 
 int rv770_suspend(struct radeon_device *rdev)
 {
+	int r;
+
 	/* FIXME: we should wait for ring to be empty */
 	r700_cp_stop(rdev);
 	rdev->cp.ready = false;
 	r600_wb_disable(rdev);
 	rv770_pcie_gart_disable(rdev);
 	/* unpin shaders bo */
-        radeon_object_unpin(rdev->r600_blit.shader_obj);
+	r = radeon_bo_reserve(rdev->r600_blit.shader_obj, false);
+	if (likely(r == 0)) {
+		radeon_bo_unpin(rdev->r600_blit.shader_obj);
+		radeon_bo_unreserve(rdev->r600_blit.shader_obj);
+	}
 	return 0;
 }
 
@@ -998,7 +1012,7 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	/* Memory manager */
-	r = radeon_object_init(rdev);
+	r = radeon_bo_init(rdev);
 	if (r)
 		return r;
 	rdev->cp.ring_obj = NULL;
@@ -1059,7 +1073,7 @@ void rv770_fini(struct radeon_device *rdev)
 	radeon_clocks_fini(rdev);
 	if (rdev->flags & RADEON_IS_AGP)
 		radeon_agp_fini(rdev);
-	radeon_object_fini(rdev);
+	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
-- 
1.6.5.2

