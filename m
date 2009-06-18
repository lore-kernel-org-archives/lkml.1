Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbZFRPvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbZFRPvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZFRPvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:51:43 -0400
Received: from nox.protox.org ([88.191.38.29]:59909 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbZFRPvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:51:41 -0400
Subject: [PATCH] radeon: command stream checker for r3xx-r5xx hardware
From: Jerome Glisse <glisse@freedesktop.org>
To: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@gmail.com>
Content-Type: multipart/mixed; boundary="=-QM6AMeHVR7Qycn1Y931/"
Date: Thu, 18 Jun 2009 17:51:34 +0200
Message-Id: <1245340294.2417.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QM6AMeHVR7Qycn1Y931/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This finish 3D state cs checking for r3xx-r5xx, you will
need lastest DDX and mesa as some previously allowed register
are now forbidden.

Jerome

--=-QM6AMeHVR7Qycn1Y931/
Content-Disposition: attachment; filename*0=0001-radeon-command-stream-checker-for-r3xx-r5xx-hardwar.patc; filename*1=h
Content-Type: text/x-patch; name="0001-radeon-command-stream-checker-for-r3xx-r5xx-hardwar.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 246cb55f8345bdf3ef071b587b311ab1088280ce Mon Sep 17 00:00:00 2001
From: Jerome Glisse <glisse@freedesktop.org>
Date: Wed, 17 Jun 2009 13:28:30 +0200
Subject: [PATCH] radeon: command stream checker for r3xx-r5xx hardware

For security purpose we want to make sure the userspace process doesn't
access memory beyond buffer it owns. To achieve this we need to check
states the userspace program. For color buffer and zbuffer we check that
the clipping register will discard access beyond buffers set as color
or zbuffer. For vertex buffer we check that no vertex fetch will happen
beyond buffer end. For texture we check various texture states (number
of mipmap level, texture size, texture depth, ...) to compute the amount
of memory the texture fetcher might access.

The command stream checking impact the performances so far quick benchmark
shows an average of 3% decrease in fps of various applications. It can
be optimized a bit more by caching result of checking and thus avoid a
full recheck if no states changed since last check.

Note that this patch is still incomplete on checking side as it doesn't
check 2d rendering states.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c          |   76 +++--
 drivers/gpu/drm/radeon/r300.c          |  478 +++++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/r300.h          |   36 +++
 drivers/gpu/drm/radeon/radeon.h        |    9 +-
 drivers/gpu/drm/radeon/radeon_asic.h   |   15 +-
 drivers/gpu/drm/radeon/radeon_device.c |    4 +
 drivers/gpu/drm/radeon/rv515.c         |   58 ++++
 7 files changed, 611 insertions(+), 65 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/r300.h

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 5225f5b..9c762dc 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -644,7 +644,7 @@ int r100_cp_reset(struct radeon_device *rdev)
  */
 int r100_cs_parse_packet0(struct radeon_cs_parser *p,
 			  struct radeon_cs_packet *pkt,
-			  unsigned *auth, unsigned n,
+			  const unsigned *auth, unsigned n,
 			  radeon_packet0_check_t check)
 {
 	unsigned reg;
@@ -654,6 +654,10 @@ int r100_cs_parse_packet0(struct radeon_cs_parser *p,
 
 	idx = pkt->idx + 1;
 	reg = pkt->reg;
+	/* Check that register fall into register range
+	 * determined by the number of entry (n) in the
+	 * safe register bitmap.
+	 */
 	if (pkt->one_reg_wr) {
 		if ((reg >> 7) > n) {
 			return -EINVAL;
@@ -683,24 +687,6 @@ int r100_cs_parse_packet0(struct radeon_cs_parser *p,
 	return 0;
 }
 
-int r100_cs_parse_packet3(struct radeon_cs_parser *p,
-			  struct radeon_cs_packet *pkt,
-			  unsigned *auth, unsigned n,
-			  radeon_packet3_check_t check)
-{
-	unsigned i, m;
-
-	if ((pkt->opcode >> 5) > n) {
-		return -EINVAL;
-	}
-	i = pkt->opcode >> 5;
-	m = 1 << (pkt->opcode & 31);
-	if (auth[i] & m) {
-		return check(p, pkt);
-	}
-	return 0;
-}
-
 void r100_cs_dump_packet(struct radeon_cs_parser *p,
 			 struct radeon_cs_packet *pkt)
 {
@@ -901,6 +887,25 @@ static int r100_packet0_check(struct radeon_cs_parser *p,
 	return 0;
 }
 
+int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
+					 struct radeon_cs_packet *pkt,
+					 struct radeon_object *robj)
+{
+	struct radeon_cs_chunk *ib_chunk;
+	unsigned idx;
+
+	ib_chunk = &p->chunks[p->chunk_ib_idx];
+	idx = pkt->idx + 1;
+	if ((ib_chunk->kdata[idx+2] + 1) > radeon_object_size(robj)) {
+		DRM_ERROR("[drm] Buffer too small for PACKET3 INDX_BUFFER "
+			  "(need %u have %lu) !\n",
+			  ib_chunk->kdata[idx+2] + 1,
+			  radeon_object_size(robj));
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int r100_packet3_check(struct radeon_cs_parser *p,
 			      struct radeon_cs_packet *pkt)
 {
@@ -954,6 +959,10 @@ static int r100_packet3_check(struct radeon_cs_parser *p,
 			return r;
 		}
 		ib[idx+1] = ib_chunk->kdata[idx+1] + ((u32)reloc->lobj.gpu_offset);
+		r = r100_cs_track_check_pkt3_indx_buffer(p, pkt, reloc->robj);
+		if (r) {
+			return r;
+		}
 		break;
 	case 0x23:
 		/* FIXME: cleanup */
@@ -999,18 +1008,18 @@ int r100_cs_parse(struct radeon_cs_parser *p)
 		}
 		p->idx += pkt.count + 2;
 		switch (pkt.type) {
-		case PACKET_TYPE0:
-			r = r100_packet0_check(p, &pkt);
-			break;
-		case PACKET_TYPE2:
-			break;
-		case PACKET_TYPE3:
-			r = r100_packet3_check(p, &pkt);
-			break;
-		default:
-			DRM_ERROR("Unknown packet type %d !\n",
-					pkt.type);
-			return -EINVAL;
+			case PACKET_TYPE0:
+				r = r100_packet0_check(p, &pkt);
+				break;
+			case PACKET_TYPE2:
+				break;
+			case PACKET_TYPE3:
+				r = r100_packet3_check(p, &pkt);
+				break;
+			default:
+				DRM_ERROR("Unknown packet type %d !\n",
+					  pkt.type);
+				return -EINVAL;
 		}
 		if (r) {
 			return r;
@@ -1352,6 +1361,11 @@ void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 	}
 }
 
+int r100_init(struct radeon_device *rdev)
+{
+	return 0;
+}
+
 /*
  * Debugfs info
  */
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index f5870a0..e2ed5bc 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -48,14 +48,13 @@ int r100_cs_packet_next_reloc(struct radeon_cs_parser *p,
 			      struct radeon_cs_reloc **cs_reloc);
 int r100_cs_parse_packet0(struct radeon_cs_parser *p,
 			  struct radeon_cs_packet *pkt,
-			  unsigned *auth, unsigned n,
+			  const unsigned *auth, unsigned n,
 			  radeon_packet0_check_t check);
-int r100_cs_parse_packet3(struct radeon_cs_parser *p,
-			  struct radeon_cs_packet *pkt,
-			  unsigned *auth, unsigned n,
-			  radeon_packet3_check_t check);
 void r100_cs_dump_packet(struct radeon_cs_parser *p,
 			 struct radeon_cs_packet *pkt);
+int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
+					 struct radeon_cs_packet *pkt,
+					 struct radeon_object *robj);
 
 /* This files gather functions specifics to:
  * r300,r350,rv350,rv370,rv380
@@ -288,7 +287,7 @@ int r300_copy_dma(struct radeon_device *rdev,
 		return r;
 	}
 	/* Must wait for 2D idle & clean before DMA or hangs might happen */
-	radeon_ring_write(rdev, PACKET0(RADEON_WAIT_UNTIL, 0));
+	radeon_ring_write(rdev, PACKET0(RADEON_WAIT_UNTIL, 0 ));
 	radeon_ring_write(rdev, (1 << 16));
 	for (i = 0; i < num_loops; i++) {
 		cur_size = size;
@@ -319,7 +318,7 @@ void r300_ring_start(struct radeon_device *rdev)
 
 	/* Sub pixel 1/12 so we can have 4K rendering according to doc */
 	gb_tile_config = (R300_ENABLE_TILING | R300_TILE_SIZE_16);
-	switch (rdev->num_gb_pipes) {
+	switch(rdev->num_gb_pipes) {
 	case 2:
 		gb_tile_config |= R300_PIPE_COUNT_R300;
 		break;
@@ -452,8 +451,8 @@ void r300_gpu_init(struct radeon_device *rdev)
 	case 4:
 		gb_tile_config |= R300_PIPE_COUNT_R420;
 		break;
-	case 1:
 	default:
+	case 1:
 		gb_tile_config |= R300_PIPE_COUNT_RV350;
 		break;
 	}
@@ -725,18 +724,120 @@ struct r300_cs_track_cb {
 	unsigned		offset;
 };
 
+struct r300_cs_track_array {
+	struct radeon_object	*robj;
+	unsigned		esize;
+};
+
+struct r300_cs_track_texture {
+	struct radeon_object	*robj;
+	unsigned		pitch;
+	unsigned		width;
+	unsigned		height;
+	unsigned		num_levels;
+	unsigned		cpp;
+	unsigned		tex_coord_type;
+	unsigned		txdepth;
+	unsigned		width_11;
+	unsigned		height_11;
+	bool			use_pitch;
+	bool			enabled;
+	bool			roundup_w;
+	bool			roundup_h;
+};
+
 struct r300_cs_track {
-	unsigned		num_cb;
-	unsigned		maxy;
-	struct r300_cs_track_cb cb[4];
-	struct r300_cs_track_cb zb;
-	bool			z_enabled;
+	unsigned			num_cb;
+	unsigned			maxy;
+	unsigned			vtx_size;
+	unsigned			vap_vf_cntl;
+	unsigned			immd_dwords;
+	unsigned			num_arrays;
+	unsigned			max_indx;
+	struct r300_cs_track_array	arrays[11];
+	struct r300_cs_track_cb 	cb[4];
+	struct r300_cs_track_cb 	zb;
+	struct r300_cs_track_texture	textures[16];
+	bool				z_enabled;
 };
 
+static inline void r300_cs_track_texture_print(struct r300_cs_track_texture *t)
+{
+	DRM_ERROR("pitch                      %d\n", t->pitch);
+	DRM_ERROR("width                      %d\n", t->width);
+	DRM_ERROR("height                     %d\n", t->height);
+	DRM_ERROR("num levels                 %d\n", t->num_levels);
+	DRM_ERROR("depth                      %d\n", t->txdepth);
+	DRM_ERROR("bpp                        %d\n", t->cpp);
+	DRM_ERROR("coordinate type            %d\n", t->tex_coord_type);
+	DRM_ERROR("width round to power of 2  %d\n", t->roundup_w);
+	DRM_ERROR("height round to power of 2 %d\n", t->roundup_h);
+}
+
+static inline int r300_cs_track_texture_check(struct radeon_device *rdev,
+					      struct r300_cs_track *track)
+{
+	struct radeon_object *robj;
+	unsigned long size;
+	unsigned u, i, w, h;
+
+	for (u = 0; u < 16; u++) {
+		if (!track->textures[u].enabled)
+			continue;
+		robj = track->textures[u].robj;
+		if (robj == NULL) {
+			DRM_ERROR("No texture bound to unit %u\n", u);
+			return -EINVAL;
+		}
+		size = 0;
+		for (i = 0; i <= track->textures[u].num_levels; i++) {
+			if (track->textures[u].use_pitch) {
+				w = track->textures[u].pitch / (1 << i);
+			} else {
+				w = track->textures[u].width / (1 << i);
+				if (rdev->family >= CHIP_RV515)
+					w |= track->textures[u].width_11;
+				if (track->textures[u].roundup_w)
+					w = roundup_pow_of_two(w);
+			}
+			h = track->textures[u].height / (1 << i);
+			if (rdev->family >= CHIP_RV515)
+				h |= track->textures[u].height_11;
+			if (track->textures[u].roundup_h)
+				h = roundup_pow_of_two(h);
+			size += w * h;
+		}
+		size *= track->textures[u].cpp;
+		switch (track->textures[u].tex_coord_type) {
+		case 0:
+			break;
+		case 1:
+			size *= (1 << track->textures[u].txdepth);
+			break;
+		case 2:
+			size *= 6;
+			break;
+		default:
+			DRM_ERROR("Invalid texture coordinate type %u for unit "
+				  "%u\n", track->textures[u].tex_coord_type, u);
+			return -EINVAL;
+		}
+		if (size > radeon_object_size(robj)) {
+			DRM_ERROR("Texture of unit %u needs %lu bytes but is "
+				  "%lu\n", u, size, radeon_object_size(robj));
+			r300_cs_track_texture_print(&track->textures[u]);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 int r300_cs_track_check(struct radeon_device *rdev, struct r300_cs_track *track)
 {
 	unsigned i;
 	unsigned long size;
+	unsigned prim_walk;
+	unsigned nverts;
 
 	for (i = 0; i < track->num_cb; i++) {
 		if (track->cb[i].robj == NULL) {
@@ -769,7 +870,59 @@ int r300_cs_track_check(struct radeon_device *rdev, struct r300_cs_track *track)
 			return -EINVAL;
 		}
 	}
-	return 0;
+	prim_walk = (track->vap_vf_cntl >> 4) & 0x3;
+	nverts = (track->vap_vf_cntl >> 16) & 0xFFFF;
+	switch (prim_walk) {
+	case 1:
+		for (i = 0; i < track->num_arrays; i++) {
+			size = track->arrays[i].esize * track->max_indx * 4;
+			if (track->arrays[i].robj == NULL) {
+				DRM_ERROR("(PW %u) Vertex array %u no buffer "
+					  "bound\n", prim_walk, i);
+				return -EINVAL;
+			}
+			if (size > radeon_object_size(track->arrays[i].robj)) {
+				DRM_ERROR("(PW %u) Vertex array %u need %lu dwords "
+					   "have %lu dwords\n", prim_walk, i,
+					   size >> 2,
+					   radeon_object_size(track->arrays[i].robj) >> 2);
+				DRM_ERROR("Max indices %u\n", track->max_indx);
+				return -EINVAL;
+			}
+		}
+		break;
+	case 2:
+		for (i = 0; i < track->num_arrays; i++) {
+			size = track->arrays[i].esize * (nverts - 1) * 4;
+			if (track->arrays[i].robj == NULL) {
+				DRM_ERROR("(PW %u) Vertex array %u no buffer "
+					  "bound\n", prim_walk, i);
+				return -EINVAL;
+			}
+			if (size > radeon_object_size(track->arrays[i].robj)) {
+				DRM_ERROR("(PW %u) Vertex array %u need %lu dwords "
+					   "have %lu dwords\n", prim_walk, i, size >> 2,
+					   radeon_object_size(track->arrays[i].robj) >> 2);
+				return -EINVAL;
+			}
+		}
+		break;
+	case 3:
+		size = track->vtx_size * nverts;
+		if (size != track->immd_dwords) {
+			DRM_ERROR("IMMD draw %u dwors but needs %lu dwords\n",
+				  track->immd_dwords, size);
+			DRM_ERROR("VAP_VF_CNTL.NUM_VERTICES %u, VTX_SIZE %u\n",
+				  nverts, track->vtx_size);
+			return -EINVAL;
+		}
+		break;
+	default:
+		DRM_ERROR("[drm] Invalid primitive walk %d for VAP_VF_CNTL\n",
+			  prim_walk);
+		return -EINVAL;
+	}
+	return r300_cs_track_texture_check(rdev, track);
 }
 
 static inline void r300_cs_track_clear(struct r300_cs_track *track)
@@ -789,9 +942,33 @@ static inline void r300_cs_track_clear(struct r300_cs_track *track)
 	track->zb.pitch = 8192;
 	track->zb.cpp = 4;
 	track->zb.offset = 0;
+	track->vtx_size = 0x7F;
+	track->immd_dwords = 0xFFFFFFFFUL;
+	track->num_arrays = 11;
+	track->max_indx = 0x00FFFFFFUL;
+	for (i = 0; i < track->num_arrays; i++) {
+		track->arrays[i].robj = NULL;
+		track->arrays[i].esize = 0x7F;
+	}
+	for (i = 0; i < 16; i++) {
+		track->textures[i].pitch = 16536;
+		track->textures[i].width = 16536;
+		track->textures[i].height = 16536;
+		track->textures[i].width_11 = 1 << 11;
+		track->textures[i].height_11 = 1 << 11;
+		track->textures[i].num_levels = 12;
+		track->textures[i].txdepth = 16;
+		track->textures[i].cpp = 64;
+		track->textures[i].tex_coord_type = 1;
+		track->textures[i].robj = NULL;
+		/* CS IB emission code makes sure texture unit are disabled */
+		track->textures[i].enabled = false;
+		track->textures[i].roundup_w = true;
+		track->textures[i].roundup_h = true;
+	}
 }
 
-static unsigned r300_auth_reg[] = {
+static const unsigned r300_reg_safe_bm[159] = {
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
 	0xFFFFFFBF, 0xFFFFFFFF, 0xFFFFFFBF, 0xFFFFFFFF,
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
@@ -808,7 +985,7 @@ static unsigned r300_auth_reg[] = {
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFF03F,
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
-	0xFFFFFFFF, 0xFFFFCFCC, 0xF00E9FFF, 0x007C0000,
+	0xFFFFFFFF, 0xFFFFEFCE, 0xF00EBFFF, 0x007C0000,
 	0xF0000078, 0xFF000009, 0xFFFFFFFF, 0xFFFFFFFF,
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
@@ -824,9 +1001,9 @@ static unsigned r300_auth_reg[] = {
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
 	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
-	0xFFFFFC78, 0xFFFFFFFF, 0xFFFFFFFC, 0xFFFFFFFF,
+	0xFFFFFC78, 0xFFFFFFFF, 0xFFFFFFFE, 0xFFFFFFFF,
 	0x38FF8F50, 0xFFF88082, 0xF000000C, 0xFAE009FF,
-	0x00000000, 0x00000000, 0xFFFF0000, 0x00000000,
+	0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000,
 	0x00000000, 0x0000C100, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0xFFFF0000, 0xFFFFFFFF, 0xFF80FFFF,
@@ -848,8 +1025,8 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 
 	ib = p->ib->ptr;
 	ib_chunk = &p->chunks[p->chunk_ib_idx];
-	track = (struct r300_cs_track *)p->track;
-	switch (reg) {
+	track = (struct r300_cs_track*)p->track;
+	switch(reg) {
 	case RADEON_DST_PITCH_OFFSET:
 	case RADEON_SRC_PITCH_OFFSET:
 		r = r100_cs_packet_next_reloc(p, &reloc);
@@ -907,6 +1084,7 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 	case R300_TX_OFFSET_0+52:
 	case R300_TX_OFFSET_0+56:
 	case R300_TX_OFFSET_0+60:
+		i = (reg - R300_TX_OFFSET_0) >> 2;
 		r = r100_cs_packet_next_reloc(p, &reloc);
 		if (r) {
 			DRM_ERROR("No reloc for ib[%d]=0x%04X\n",
@@ -915,11 +1093,23 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 			return r;
 		}
 		ib[idx] = ib_chunk->kdata[idx] + ((u32)reloc->lobj.gpu_offset);
+		track->textures[i].robj = reloc->robj;
 		break;
 	/* Tracked registers */
+	case 0x2084:
+		/* VAP_VF_CNTL */
+		track->vap_vf_cntl = ib_chunk->kdata[idx];
+		break;
+	case 0x20B4:
+		/* VAP_VTX_SIZE */
+		track->vtx_size = ib_chunk->kdata[idx] & 0x7F;
+		break;
+	case 0x2134:
+		/* VAP_VF_MAX_VTX_INDX */
+		track->max_indx = ib_chunk->kdata[idx] & 0x00FFFFFFUL;
+		break;
 	case 0x43E4:
 		/* SC_SCISSOR1 */
-
 		track->maxy = ((ib_chunk->kdata[idx] >> 13) & 0x1FFF) + 1;
 		if (p->rdev->family < CHIP_RV515) {
 			track->maxy -= 1440;
@@ -994,8 +1184,166 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 		/* ZB_DEPTHPITCH */
 		track->zb.pitch = ib_chunk->kdata[idx] & 0x3FFC;
 		break;
+	case 0x4104:
+		for (i = 0; i < 16; i++) {
+			bool enabled;
+
+			enabled = !!(ib_chunk->kdata[idx] & (1 << i));
+			track->textures[i].enabled = enabled;
+		}
+		break;
+	case 0x44C0:
+	case 0x44C4:
+	case 0x44C8:
+	case 0x44CC:
+	case 0x44D0:
+	case 0x44D4:
+	case 0x44D8:
+	case 0x44DC:
+	case 0x44E0:
+	case 0x44E4:
+	case 0x44E8:
+	case 0x44EC:
+	case 0x44F0:
+	case 0x44F4:
+	case 0x44F8:
+	case 0x44FC:
+		/* TX_FORMAT1_[0-15] */
+		i = (reg - 0x44C0) >> 2;
+		tmp = (ib_chunk->kdata[idx] >> 25) & 0x3;
+		track->textures[i].tex_coord_type = tmp;
+		switch ((ib_chunk->kdata[idx] & 0x1F)) {
+		case 0:
+		case 2:
+		case 5:
+		case 18:
+		case 20:
+		case 21:
+			track->textures[i].cpp = 1;
+			break;
+		case 1:
+		case 3:
+		case 6:
+		case 7:
+		case 10:
+		case 11:
+		case 19:
+		case 22:
+		case 24:
+			track->textures[i].cpp = 2;
+			break;
+		case 4:
+		case 8:
+		case 9:
+		case 12:
+		case 13:
+		case 23:
+		case 25:
+		case 27:
+		case 30:
+			track->textures[i].cpp = 4;
+			break;
+		case 14:
+		case 26:
+		case 28:
+			track->textures[i].cpp = 8;
+			break;
+		case 29:
+			track->textures[i].cpp = 16;
+			break;
+		default:
+			DRM_ERROR("Invalid texture format %u\n",
+				  (ib_chunk->kdata[idx] & 0x1F));
+			return -EINVAL;
+			break;
+		}
+		break;
+	case 0x4400:
+	case 0x4404:
+	case 0x4408:
+	case 0x440C:
+	case 0x4410:
+	case 0x4414:
+	case 0x4418:
+	case 0x441C:
+	case 0x4420:
+	case 0x4424:
+	case 0x4428:
+	case 0x442C:
+	case 0x4430:
+	case 0x4434:
+	case 0x4438:
+	case 0x443C:
+		/* TX_FILTER0_[0-15] */
+		i = (reg - 0x4400) >> 2;
+		tmp = ib_chunk->kdata[idx] & 0x7;;
+		if (tmp == 2 || tmp == 4 || tmp == 6) {
+			track->textures[i].roundup_w = false;
+		}
+		tmp = (ib_chunk->kdata[idx] >> 3) & 0x7;;
+		if (tmp == 2 || tmp == 4 || tmp == 6) {
+			track->textures[i].roundup_h = false;
+		}
+		break;
+	case 0x4500:
+	case 0x4504:
+	case 0x4508:
+	case 0x450C:
+	case 0x4510:
+	case 0x4514:
+	case 0x4518:
+	case 0x451C:
+	case 0x4520:
+	case 0x4524:
+	case 0x4528:
+	case 0x452C:
+	case 0x4530:
+	case 0x4534:
+	case 0x4538:
+	case 0x453C:
+		/* TX_FORMAT2_[0-15] */
+		i = (reg - 0x4500) >> 2;
+		tmp = ib_chunk->kdata[idx] & 0x3FFF;
+		track->textures[i].pitch = tmp + 1;
+		if (p->rdev->family >= CHIP_RV515) {
+			tmp = ((ib_chunk->kdata[idx] >> 15) & 1) << 11;
+			track->textures[i].width_11 = tmp;
+			tmp = ((ib_chunk->kdata[idx] >> 16) & 1) << 11;
+			track->textures[i].height_11 = tmp;
+		}
+		break;
+	case 0x4480:
+	case 0x4484:
+	case 0x4488:
+	case 0x448C:
+	case 0x4490:
+	case 0x4494:
+	case 0x4498:
+	case 0x449C:
+	case 0x44A0:
+	case 0x44A4:
+	case 0x44A8:
+	case 0x44AC:
+	case 0x44B0:
+	case 0x44B4:
+	case 0x44B8:
+	case 0x44BC:
+		/* TX_FORMAT0_[0-15] */
+		i = (reg - 0x4480) >> 2;
+		tmp = ib_chunk->kdata[idx] & 0x7FF;
+		track->textures[i].width = tmp + 1;
+		tmp = (ib_chunk->kdata[idx] >> 11) & 0x7FF;
+		track->textures[i].height = tmp + 1;
+		tmp = (ib_chunk->kdata[idx] >> 26) & 0xF;
+		track->textures[i].num_levels = tmp;
+		tmp = ib_chunk->kdata[idx] & (1 << 31);
+		track->textures[i].use_pitch = !!tmp;
+		tmp = (ib_chunk->kdata[idx] >> 22) & 0xF;
+		track->textures[i].txdepth = tmp;
+		break;
 	default:
-		printk(KERN_ERR "Forbidden register 0x%04X in cs at %d\n", reg, idx);
+		printk(KERN_ERR "Forbidden register 0x%04X in cs at %d\n",
+		       reg, idx);
 		return -EINVAL;
 	}
 	return 0;
@@ -1015,11 +1363,12 @@ static int r300_packet3_check(struct radeon_cs_parser *p,
 	ib = p->ib->ptr;
 	ib_chunk = &p->chunks[p->chunk_ib_idx];
 	idx = pkt->idx + 1;
-	track = (struct r300_cs_track *)p->track;
-	switch (pkt->opcode) {
+	track = (struct r300_cs_track*)p->track;
+	switch(pkt->opcode) {
 	case PACKET3_3D_LOAD_VBPNTR:
-		c = ib_chunk->kdata[idx++];
-		for (i = 0; i < (c - 1); i += 2, idx += 3) {
+		c = ib_chunk->kdata[idx++] & 0x1F;
+		track->num_arrays = c;
+		for (i = 0; i < (c - 1); i+=2, idx+=3) {
 			r = r100_cs_packet_next_reloc(p, &reloc);
 			if (r) {
 				DRM_ERROR("No reloc for packet3 %d\n",
@@ -1028,6 +1377,9 @@ static int r300_packet3_check(struct radeon_cs_parser *p,
 				return r;
 			}
 			ib[idx+1] = ib_chunk->kdata[idx+1] + ((u32)reloc->lobj.gpu_offset);
+			track->arrays[i + 0].robj = reloc->robj;
+			track->arrays[i + 0].esize = ib_chunk->kdata[idx] >> 8;
+			track->arrays[i + 0].esize &= 0x7F;
 			r = r100_cs_packet_next_reloc(p, &reloc);
 			if (r) {
 				DRM_ERROR("No reloc for packet3 %d\n",
@@ -1036,6 +1388,9 @@ static int r300_packet3_check(struct radeon_cs_parser *p,
 				return r;
 			}
 			ib[idx+2] = ib_chunk->kdata[idx+2] + ((u32)reloc->lobj.gpu_offset);
+			track->arrays[i + 1].robj = reloc->robj;
+			track->arrays[i + 1].esize = ib_chunk->kdata[idx] >> 24;
+			track->arrays[i + 1].esize &= 0x7F;
 		}
 		if (c & 1) {
 			r = r100_cs_packet_next_reloc(p, &reloc);
@@ -1046,6 +1401,9 @@ static int r300_packet3_check(struct radeon_cs_parser *p,
 				return r;
 			}
 			ib[idx+1] = ib_chunk->kdata[idx+1] + ((u32)reloc->lobj.gpu_offset);
+			track->arrays[i + 0].robj = reloc->robj;
+			track->arrays[i + 0].esize = ib_chunk->kdata[idx] >> 8;
+			track->arrays[i + 0].esize &= 0x7F;
 		}
 		break;
 	case PACKET3_INDX_BUFFER:
@@ -1056,14 +1414,65 @@ static int r300_packet3_check(struct radeon_cs_parser *p,
 			return r;
 		}
 		ib[idx+1] = ib_chunk->kdata[idx+1] + ((u32)reloc->lobj.gpu_offset);
+		r = r100_cs_track_check_pkt3_indx_buffer(p, pkt, reloc->robj);
+		if (r) {
+			return r;
+		}
 		break;
 	/* Draw packet */
-	case PACKET3_3D_DRAW_VBUF:
 	case PACKET3_3D_DRAW_IMMD:
-	case PACKET3_3D_DRAW_INDX:
-	case PACKET3_3D_DRAW_VBUF_2:
+		/* Number of dwords is vtx_size * (num_vertices - 1)
+		 * PRIM_WALK must be equal to 3 vertex data in embedded
+		 * in cmd stream */
+		if (((ib_chunk->kdata[idx+1] >> 4) & 0x3) != 3) {
+			DRM_ERROR("PRIM_WALK must be 3 for IMMD draw\n");
+			return -EINVAL;
+		}
+		track->vap_vf_cntl = ib_chunk->kdata[idx+1];
+		track->immd_dwords = pkt->count - 1;
+		r = r300_cs_track_check(p->rdev, track);
+		if (r) {
+			return r;
+		}
+		break;
 	case PACKET3_3D_DRAW_IMMD_2:
+		/* Number of dwords is vtx_size * (num_vertices - 1)
+		 * PRIM_WALK must be equal to 3 vertex data in embedded
+		 * in cmd stream */
+		if (((ib_chunk->kdata[idx] >> 4) & 0x3) != 3) {
+			DRM_ERROR("PRIM_WALK must be 3 for IMMD draw\n");
+			return -EINVAL;
+		}
+		track->vap_vf_cntl = ib_chunk->kdata[idx];
+		track->immd_dwords = pkt->count;
+		r = r300_cs_track_check(p->rdev, track);
+		if (r) {
+			return r;
+		}
+		break;
+	case PACKET3_3D_DRAW_VBUF:
+		track->vap_vf_cntl = ib_chunk->kdata[idx + 1];
+		r = r300_cs_track_check(p->rdev, track);
+		if (r) {
+			return r;
+		}
+		break;
+	case PACKET3_3D_DRAW_VBUF_2:
+		track->vap_vf_cntl = ib_chunk->kdata[idx];
+		r = r300_cs_track_check(p->rdev, track);
+		if (r) {
+			return r;
+		}
+		break;
+	case PACKET3_3D_DRAW_INDX:
+		track->vap_vf_cntl = ib_chunk->kdata[idx + 1];
+		r = r300_cs_track_check(p->rdev, track);
+		if (r) {
+			return r;
+		}
+		break;
 	case PACKET3_3D_DRAW_INDX_2:
+		track->vap_vf_cntl = ib_chunk->kdata[idx];
 		r = r300_cs_track_check(p->rdev, track);
 		if (r) {
 			return r;
@@ -1095,8 +1504,8 @@ int r300_cs_parse(struct radeon_cs_parser *p)
 		switch (pkt.type) {
 		case PACKET_TYPE0:
 			r = r100_cs_parse_packet0(p, &pkt,
-						  r300_auth_reg,
-						  ARRAY_SIZE(r300_auth_reg),
+						  p->rdev->config.r300.reg_safe_bm,
+						  p->rdev->config.r300.reg_safe_bm_size,
 						  &r300_packet0_check);
 			break;
 		case PACKET_TYPE2:
@@ -1114,3 +1523,10 @@ int r300_cs_parse(struct radeon_cs_parser *p)
 	} while (p->idx < p->chunks[p->chunk_ib_idx].length_dw);
 	return 0;
 }
+
+int r300_init(struct radeon_device *rdev)
+{
+	rdev->config.r300.reg_safe_bm = r300_reg_safe_bm;
+	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(r300_reg_safe_bm);
+	return 0;
+}
diff --git a/drivers/gpu/drm/radeon/r300.h b/drivers/gpu/drm/radeon/r300.h
new file mode 100644
index 0000000..8486b4d
--- /dev/null
+++ b/drivers/gpu/drm/radeon/r300.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright 2008 Advanced Micro Devices, Inc.
+ * Copyright 2008 Red Hat Inc.
+ * Copyright 2009 Jerome Glisse.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Dave Airlie
+ *          Alex Deucher
+ *          Jerome Glisse
+ */
+#ifndef R300_H
+#define R300_H
+
+struct r300_asic {
+	const unsigned	*reg_safe_bm;
+	unsigned	reg_safe_bm_size;
+};
+
+#endif
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index c3f24cc..d61f2fc 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -51,7 +51,7 @@
 
 #include "radeon_mode.h"
 #include "radeon_reg.h"
-
+#include "r300.h"
 
 /*
  * Modules parameters.
@@ -496,6 +496,7 @@ int r100_debugfs_cp_init(struct radeon_device *rdev);
  * ASIC specific functions.
  */
 struct radeon_asic {
+	int (*init)(struct radeon_device *rdev);
 	void (*errata)(struct radeon_device *rdev);
 	void (*vram_info)(struct radeon_device *rdev);
 	int (*gpu_reset)(struct radeon_device *rdev);
@@ -536,6 +537,10 @@ struct radeon_asic {
 	void (*set_clock_gating)(struct radeon_device *rdev, int enable);
 };
 
+union radeon_asic_config {
+	struct r300_asic	r300;
+};
+
 
 /*
  * IOCTL.
@@ -573,6 +578,7 @@ struct radeon_device {
 	struct drm_device		*ddev;
 	struct pci_dev			*pdev;
 	/* ASIC */
+	union radeon_asic_config	config;
 	enum radeon_family		family;
 	unsigned long			flags;
 	int				usec_timeout;
@@ -763,6 +769,7 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 /*
  * ASICs macro.
  */
+#define radeon_init(rdev) (rdev)->asic->init((rdev))
 #define radeon_cs_parse(p) rdev->asic->cs_parse((p))
 #define radeon_errata(rdev) (rdev)->asic->errata((rdev))
 #define radeon_vram_info(rdev) (rdev)->asic->vram_info((rdev))
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index e57d8a7..e2e5673 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -41,6 +41,7 @@ void radeon_atom_set_clock_gating(struct radeon_device *rdev, int enable);
 /*
  * r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280
  */
+int r100_init(struct radeon_device *rdev);
 uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg);
 void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void r100_errata(struct radeon_device *rdev);
@@ -72,6 +73,7 @@ int r100_copy_blit(struct radeon_device *rdev,
 		   struct radeon_fence *fence);
 
 static struct radeon_asic r100_asic = {
+	.init = &r100_init,
 	.errata = &r100_errata,
 	.vram_info = &r100_vram_info,
 	.gpu_reset = &r100_gpu_reset,
@@ -104,6 +106,7 @@ static struct radeon_asic r100_asic = {
 /*
  * r300,r350,rv350,rv380
  */
+int r300_init(struct radeon_device *rdev);
 void r300_errata(struct radeon_device *rdev);
 void r300_vram_info(struct radeon_device *rdev);
 int r300_gpu_reset(struct radeon_device *rdev);
@@ -126,6 +129,7 @@ int r300_copy_dma(struct radeon_device *rdev,
 		  unsigned num_pages,
 		  struct radeon_fence *fence);
 static struct radeon_asic r300_asic = {
+	.init = &r300_init,
 	.errata = &r300_errata,
 	.vram_info = &r300_vram_info,
 	.gpu_reset = &r300_gpu_reset,
@@ -162,6 +166,7 @@ void r420_vram_info(struct radeon_device *rdev);
 int r420_mc_init(struct radeon_device *rdev);
 void r420_mc_fini(struct radeon_device *rdev);
 static struct radeon_asic r420_asic = {
+	.init = &r300_init,
 	.errata = &r420_errata,
 	.vram_info = &r420_vram_info,
 	.gpu_reset = &r300_gpu_reset,
@@ -205,6 +210,7 @@ int rs400_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 uint32_t rs400_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rs400_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 static struct radeon_asic rs400_asic = {
+	.init = &r300_init,
 	.errata = &rs400_errata,
 	.vram_info = &rs400_vram_info,
 	.gpu_reset = &r300_gpu_reset,
@@ -249,6 +255,7 @@ int rs600_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 uint32_t rs600_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rs600_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 static struct radeon_asic rs600_asic = {
+	.init = &r300_init,
 	.errata = &rs600_errata,
 	.vram_info = &rs600_vram_info,
 	.gpu_reset = &r300_gpu_reset,
@@ -288,6 +295,7 @@ void rs690_mc_fini(struct radeon_device *rdev);
 uint32_t rs690_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rs690_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 static struct radeon_asic rs690_asic = {
+	.init = &r300_init,
 	.errata = &rs690_errata,
 	.vram_info = &rs690_vram_info,
 	.gpu_reset = &r300_gpu_reset,
@@ -320,6 +328,7 @@ static struct radeon_asic rs690_asic = {
 /*
  * rv515
  */
+int rv515_init(struct radeon_device *rdev);
 void rv515_errata(struct radeon_device *rdev);
 void rv515_vram_info(struct radeon_device *rdev);
 int rv515_gpu_reset(struct radeon_device *rdev);
@@ -331,6 +340,7 @@ void rv515_ring_start(struct radeon_device *rdev);
 uint32_t rv515_pcie_rreg(struct radeon_device *rdev, uint32_t reg);
 void rv515_pcie_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 static struct radeon_asic rv515_asic = {
+	.init = &rv515_init,
 	.errata = &rv515_errata,
 	.vram_info = &rv515_vram_info,
 	.gpu_reset = &rv515_gpu_reset,
@@ -349,7 +359,7 @@ static struct radeon_asic rv515_asic = {
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.fence_ring_emit = &r300_fence_ring_emit,
-	.cs_parse = &r100_cs_parse,
+	.cs_parse = &r300_cs_parse,
 	.copy_blit = &r100_copy_blit,
 	.copy_dma = &r300_copy_dma,
 	.copy = &r100_copy_blit,
@@ -368,6 +378,7 @@ void r520_vram_info(struct radeon_device *rdev);
 int r520_mc_init(struct radeon_device *rdev);
 void r520_mc_fini(struct radeon_device *rdev);
 static struct radeon_asic r520_asic = {
+	.init = &rv515_init,
 	.errata = &r520_errata,
 	.vram_info = &r520_vram_info,
 	.gpu_reset = &rv515_gpu_reset,
@@ -386,7 +397,7 @@ static struct radeon_asic r520_asic = {
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.fence_ring_emit = &r300_fence_ring_emit,
-	.cs_parse = &r100_cs_parse,
+	.cs_parse = &r300_cs_parse,
 	.copy_blit = &r100_copy_blit,
 	.copy_dma = &r300_copy_dma,
 	.copy = &r100_copy_blit,
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 5fd2b63..f30aa72 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -470,6 +470,10 @@ int radeon_device_init(struct radeon_device *rdev,
 	if (r) {
 		return r;
 	}
+	r = radeon_init(rdev);
+	if (r) {
+		return r;
+	}
 
 	/* Report DMA addressing limitation */
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(32));
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 7eab95d..ffea37b 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -225,6 +225,8 @@ void rv515_ring_start(struct radeon_device *rdev)
 	radeon_ring_write(rdev,
 			  R300_GEOMETRY_ROUND_NEAREST |
 			  R300_COLOR_ROUND_NEAREST);
+	radeon_ring_write(rdev, PACKET0(0x20C8, 0));
+	radeon_ring_write(rdev, 0);
 	radeon_ring_unlock_commit(rdev);
 }
 
@@ -502,3 +504,59 @@ int rv515_debugfs_ga_info_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
+
+
+/*
+ * Asic initialization
+ */
+static const unsigned r500_reg_safe_bm[159] = {
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFBF, 0xFFFFFFFF, 0xFFFFFFBF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0x17FF1FFF, 0xFFFFFFFC, 0xFFFFFFFF, 0xFF30FFBF,
+	0xFFFFFFF8, 0xC3E6FFFF, 0xFFFFF6DF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFF03F,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFEFCE, 0xF00EBFFF, 0x007C0000,
+	0xF0000038, 0xFF000009, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFF7FF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0x1FFFFC78, 0xFFFFE000, 0xFFFFFFFE, 0xFFFFFFFF,
+	0x38CF8F50, 0xFFF88082, 0xFF0000FC, 0xFAE009FF,
+	0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000,
+	0xFFFF8CFC, 0xFFFFC1FF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
+	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF80FFFF,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x0003FC01, 0x3FFFFCF8, 0xFE800B19,
+};
+
+
+
+int rv515_init(struct radeon_device *rdev)
+{
+	rdev->config.r300.reg_safe_bm = r500_reg_safe_bm;
+	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(r500_reg_safe_bm);
+	return 0;
+}
-- 
1.6.2.2


--=-QM6AMeHVR7Qycn1Y931/--

