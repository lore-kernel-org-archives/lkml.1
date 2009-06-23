Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZFWTqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZFWTqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZFWTqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:46:11 -0400
Received: from nox.protox.org ([88.191.38.29]:35800 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbZFWTqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:46:09 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] radeon: preallocate memory for command stream parsing
Date: Tue, 23 Jun 2009 21:46:07 +0200
Message-Id: <1245786367-2773-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command stream parsing is the most common operation and can
happen hundred of times per second, we don't want to allocate/free
memory each time this ioctl is call. This rework the ioctl
to avoid doing so by allocating temporary memory along the
ib pool.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c        |   27 +++---
 drivers/gpu/drm/radeon/r300.c        |    6 +-
 drivers/gpu/drm/radeon/radeon.h      |  110 ++++++++++----------
 drivers/gpu/drm/radeon/radeon_cs.c   |  186 +++++++++++++++-------------------
 drivers/gpu/drm/radeon/radeon_ring.c |   23 ++++
 5 files changed, 177 insertions(+), 175 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index c550932..56ef9f7 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -699,7 +699,7 @@ void r100_cs_dump_packet(struct radeon_cs_parser *p,
 	unsigned idx;
 
 	ib = p->ib->ptr;
-	ib_chunk = &p->chunks[p->chunk_ib_idx];
+	ib_chunk = &p->ibc;
 	idx = pkt->idx;
 	for (i = 0; i <= (pkt->count + 1); i++, idx++) {
 		DRM_INFO("ib[%d]=0x%08X\n", idx, ib[idx]);
@@ -718,14 +718,15 @@ int r100_cs_packet_parse(struct radeon_cs_parser *p,
 			 struct radeon_cs_packet *pkt,
 			 unsigned idx)
 {
-	struct radeon_cs_chunk *ib_chunk = &p->chunks[p->chunk_ib_idx];
-	uint32_t header = ib_chunk->kdata[idx];
+	struct radeon_cs_chunk *ib_chunk = &p->ibc;
+	uint32_t header;
 
 	if (idx >= ib_chunk->length_dw) {
 		DRM_ERROR("Can not parse packet at %d after CS end %d !\n",
 			  idx, ib_chunk->length_dw);
 		return -EINVAL;
 	}
+	header = ib_chunk->kdata[idx];
 	pkt->idx = idx;
 	pkt->type = CP_PACKET_GET_TYPE(header);
 	pkt->count = CP_PACKET_GET_COUNT(header);
@@ -767,18 +768,16 @@ int r100_cs_packet_next_reloc(struct radeon_cs_parser *p,
 			      struct radeon_cs_reloc **cs_reloc)
 {
 	struct radeon_cs_chunk *ib_chunk;
-	struct radeon_cs_chunk *relocs_chunk;
 	struct radeon_cs_packet p3reloc;
 	unsigned idx;
 	int r;
 
-	if (p->chunk_relocs_idx == -1) {
+	if (p->relocs == NULL) {
 		DRM_ERROR("No relocation chunk !\n");
 		return -EINVAL;
 	}
 	*cs_reloc = NULL;
-	ib_chunk = &p->chunks[p->chunk_ib_idx];
-	relocs_chunk = &p->chunks[p->chunk_relocs_idx];
+	ib_chunk = &p->ibc;
 	r = r100_cs_packet_parse(p, &p3reloc, p->idx);
 	if (r) {
 		return r;
@@ -791,14 +790,14 @@ int r100_cs_packet_next_reloc(struct radeon_cs_parser *p,
 		return -EINVAL;
 	}
 	idx = ib_chunk->kdata[p3reloc.idx + 1];
-	if (idx >= relocs_chunk->length_dw) {
+	if ((idx / 4) >= p->nrelocs) {
 		DRM_ERROR("Relocs at %d after relocations chunk end %d !\n",
-			  idx, relocs_chunk->length_dw);
+			  idx, p->nrelocs * 4);
 		r100_cs_dump_packet(p, &p3reloc);
 		return -EINVAL;
 	}
 	/* FIXME: we assume reloc size is 4 dwords */
-	*cs_reloc = p->relocs_ptr[(idx / 4)];
+	*cs_reloc = p->relocs_ptr[idx / 4];
 	return 0;
 }
 
@@ -816,7 +815,7 @@ static int r100_packet0_check(struct radeon_cs_parser *p,
 	int r;
 
 	ib = p->ib->ptr;
-	ib_chunk = &p->chunks[p->chunk_ib_idx];
+	ib_chunk = &p->ibc;
 	idx = pkt->idx + 1;
 	reg = pkt->reg;
 	onereg = false;
@@ -897,7 +896,7 @@ int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
 	struct radeon_cs_chunk *ib_chunk;
 	unsigned idx;
 
-	ib_chunk = &p->chunks[p->chunk_ib_idx];
+	ib_chunk = &p->ibc;
 	idx = pkt->idx + 1;
 	if ((ib_chunk->kdata[idx+2] + 1) > radeon_object_size(robj)) {
 		DRM_ERROR("[drm] Buffer too small for PACKET3 INDX_BUFFER "
@@ -920,7 +919,7 @@ static int r100_packet3_check(struct radeon_cs_parser *p,
 	int r;
 
 	ib = p->ib->ptr;
-	ib_chunk = &p->chunks[p->chunk_ib_idx];
+	ib_chunk = &p->ibc;
 	idx = pkt->idx + 1;
 	switch (pkt->opcode) {
 	case PACKET3_3D_LOAD_VBPNTR:
@@ -1027,7 +1026,7 @@ int r100_cs_parse(struct radeon_cs_parser *p)
 		if (r) {
 			return r;
 		}
-	} while (p->idx < p->chunks[p->chunk_ib_idx].length_dw);
+	} while (p->idx < p->ibc.length_dw);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index e2ed5bc..2b2199e 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1024,7 +1024,7 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 	int r;
 
 	ib = p->ib->ptr;
-	ib_chunk = &p->chunks[p->chunk_ib_idx];
+	ib_chunk = &p->ibc;
 	track = (struct r300_cs_track*)p->track;
 	switch(reg) {
 	case RADEON_DST_PITCH_OFFSET:
@@ -1361,7 +1361,7 @@ static int r300_packet3_check(struct radeon_cs_parser *p,
 	int r;
 
 	ib = p->ib->ptr;
-	ib_chunk = &p->chunks[p->chunk_ib_idx];
+	ib_chunk = &p->ibc;
 	idx = pkt->idx + 1;
 	track = (struct r300_cs_track*)p->track;
 	switch(pkt->opcode) {
@@ -1520,7 +1520,7 @@ int r300_cs_parse(struct radeon_cs_parser *p)
 		if (r) {
 			return r;
 		}
-	} while (p->idx < p->chunks[p->chunk_ib_idx].length_dw);
+	} while (p->idx < p->ibc.length_dw);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index d61f2fc..1bea78a 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -352,6 +352,56 @@ void radeon_irq_kms_fini(struct radeon_device *rdev);
 
 
 /*
+ * CS.
+ */
+struct radeon_ib;
+
+struct radeon_cs_reloc {
+	struct drm_gem_object		*gobj;
+	struct radeon_object		*robj;
+	struct radeon_object_list	lobj;
+	uint32_t			handle;
+	uint32_t			flags;
+};
+
+struct radeon_cs_chunk {
+	uint32_t		chunk_id;
+	uint32_t		length_dw;
+	uint32_t		*kdata;
+};
+
+struct radeon_cs_parser {
+	struct radeon_device	*rdev;
+	struct drm_file		*filp;
+	struct radeon_cs_chunk	ibc;
+	/* IB */
+	unsigned		idx;
+	/* relocations */
+	unsigned		nrelocs;
+	struct radeon_cs_reloc	*relocs;
+	struct radeon_cs_reloc	**relocs_ptr;
+	struct list_head	validated;
+	struct radeon_ib	*ib;
+	void			*track;
+};
+
+struct radeon_cs_packet {
+	unsigned	idx;
+	unsigned	type;
+	unsigned	reg;
+	unsigned	opcode;
+	int		count;
+	unsigned	one_reg_wr;
+};
+
+typedef int (*radeon_packet0_check_t)(struct radeon_cs_parser *p,
+				      struct radeon_cs_packet *pkt,
+				      unsigned idx, unsigned reg);
+typedef int (*radeon_packet3_check_t)(struct radeon_cs_parser *p,
+				      struct radeon_cs_packet *pkt);
+
+
+/*
  * CP & ring.
  */
 struct radeon_ib {
@@ -360,12 +410,18 @@ struct radeon_ib {
 	uint64_t		gpu_addr;
 	struct radeon_fence	*fence;
 	volatile uint32_t	*ptr;
+	uint32_t		*ib;
+	struct radeon_cs_reloc	*relocs;
+	struct radeon_cs_reloc	**relocs_ptr;
 	uint32_t		length_dw;
 };
 
 struct radeon_ib_pool {
 	struct mutex		mutex;
 	struct radeon_object	*robj;
+	uint32_t		*ib;
+	struct radeon_cs_reloc	*relocs;
+	struct radeon_cs_reloc	**relocs_ptr;
 	struct list_head	scheduled_ibs;
 	struct radeon_ib	ibs[RADEON_IB_POOL_SIZE];
 	bool			ready;
@@ -405,60 +461,6 @@ void radeon_ring_fini(struct radeon_device *rdev);
 
 
 /*
- * CS.
- */
-struct radeon_cs_reloc {
-	struct drm_gem_object		*gobj;
-	struct radeon_object		*robj;
-	struct radeon_object_list	lobj;
-	uint32_t			handle;
-	uint32_t			flags;
-};
-
-struct radeon_cs_chunk {
-	uint32_t		chunk_id;
-	uint32_t		length_dw;
-	uint32_t		*kdata;
-};
-
-struct radeon_cs_parser {
-	struct radeon_device	*rdev;
-	struct drm_file		*filp;
-	/* chunks */
-	unsigned		nchunks;
-	struct radeon_cs_chunk	*chunks;
-	uint64_t		*chunks_array;
-	/* IB */
-	unsigned		idx;
-	/* relocations */
-	unsigned		nrelocs;
-	struct radeon_cs_reloc	*relocs;
-	struct radeon_cs_reloc	**relocs_ptr;
-	struct list_head	validated;
-	/* indices of various chunks */
-	int			chunk_ib_idx;
-	int			chunk_relocs_idx;
-	struct radeon_ib	*ib;
-	void			*track;
-};
-
-struct radeon_cs_packet {
-	unsigned	idx;
-	unsigned	type;
-	unsigned	reg;
-	unsigned	opcode;
-	int		count;
-	unsigned	one_reg_wr;
-};
-
-typedef int (*radeon_packet0_check_t)(struct radeon_cs_parser *p,
-				      struct radeon_cs_packet *pkt,
-				      unsigned idx, unsigned reg);
-typedef int (*radeon_packet3_check_t)(struct radeon_cs_parser *p,
-				      struct radeon_cs_packet *pkt);
-
-
-/*
  * AGP
  */
 int radeon_agp_init(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index b843f9b..8fb08fa 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -29,61 +29,52 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 
-void r100_cs_dump_packet(struct radeon_cs_parser *p,
-			 struct radeon_cs_packet *pkt);
-
-int radeon_cs_parser_relocs(struct radeon_cs_parser *p)
+static int radeon_cs_parser_reloc(struct radeon_cs_parser *p,
+				  struct drm_radeon_cs_chunk *chunk)
 {
-	struct drm_device *ddev = p->rdev->ddev;
-	struct radeon_cs_chunk *chunk;
-	unsigned i, j;
+	struct drm_radeon_cs_reloc __user *reloc_ptr;
+	struct drm_radeon_cs_reloc reloc;
+	unsigned i, j, c;
 	bool duplicate;
 
-	if (p->chunk_relocs_idx == -1) {
-		return 0;
-	}
-	chunk = &p->chunks[p->chunk_relocs_idx];
-	/* FIXME: we assume that each relocs use 4 dwords */
 	p->nrelocs = chunk->length_dw / 4;
-	p->relocs_ptr = kcalloc(p->nrelocs, sizeof(void *), GFP_KERNEL);
-	if (p->relocs_ptr == NULL) {
-		return -ENOMEM;
-	}
-	p->relocs = kcalloc(p->nrelocs, sizeof(struct radeon_cs_reloc), GFP_KERNEL);
-	if (p->relocs == NULL) {
-		return -ENOMEM;
+	if (p->nrelocs > 1024) {
+		DRM_ERROR("Too many relocations %d\n", p->nrelocs);
+		return -EINVAL;
 	}
-	for (i = 0; i < p->nrelocs; i++) {
-		struct drm_radeon_cs_reloc *r;
-
+	for (i = 0, c = 0; i < p->nrelocs; i++) {
+		reloc_ptr = (void __user*)(unsigned long)(chunk->chunk_data + i * 16);
+		if (DRM_COPY_FROM_USER(&reloc, reloc_ptr, 16)) {
+			return -EFAULT;
+		}
 		duplicate = false;
-		r = (struct drm_radeon_cs_reloc *)&chunk->kdata[i*4];
-		for (j = 0; j < p->nrelocs; j++) {
-			if (r->handle == p->relocs[j].handle) {
+		for (j = 0; j < c; j++) {
+			if (reloc.handle == p->relocs[j].handle) {
 				p->relocs_ptr[i] = &p->relocs[j];
 				duplicate = true;
 				break;
 			}
 		}
 		if (!duplicate) {
-			p->relocs[i].gobj = drm_gem_object_lookup(ddev,
+			p->relocs[i].gobj = drm_gem_object_lookup(p->rdev->ddev,
 								  p->filp,
-								  r->handle);
+								  reloc.handle);
 			if (p->relocs[i].gobj == NULL) {
 				DRM_ERROR("gem object lookup failed 0x%x\n",
-					  r->handle);
+					  reloc.handle);
 				return -EINVAL;
 			}
 			p->relocs_ptr[i] = &p->relocs[i];
 			p->relocs[i].robj = p->relocs[i].gobj->driver_private;
 			p->relocs[i].lobj.robj = p->relocs[i].robj;
-			p->relocs[i].lobj.rdomain = r->read_domains;
-			p->relocs[i].lobj.wdomain = r->write_domain;
-			p->relocs[i].handle = r->handle;
-			p->relocs[i].flags = r->flags;
+			p->relocs[i].lobj.rdomain = reloc.read_domains;
+			p->relocs[i].lobj.wdomain = reloc.write_domain;
+			p->relocs[i].handle = reloc.handle;
+			p->relocs[i].flags = reloc.flags;
 			INIT_LIST_HEAD(&p->relocs[i].lobj.list);
 			radeon_object_list_add_object(&p->relocs[i].lobj,
 						      &p->validated);
+			c++;
 		}
 	}
 	return radeon_object_list_validate(&p->validated, p->ib->fence);
@@ -92,65 +83,53 @@ int radeon_cs_parser_relocs(struct radeon_cs_parser *p)
 int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 {
 	struct drm_radeon_cs *cs = data;
-	uint64_t *chunk_array_ptr;
-	unsigned size, i;
+	unsigned i;
+	int r;
+	bool found_ib = false;
 
-	if (!cs->num_chunks) {
-		return 0;
-	}
-	/* get chunks */
-	INIT_LIST_HEAD(&p->validated);
-	p->idx = 0;
-	p->chunk_ib_idx = -1;
-	p->chunk_relocs_idx = -1;
-	p->chunks_array = kcalloc(cs->num_chunks, sizeof(uint64_t), GFP_KERNEL);
-	if (p->chunks_array == NULL) {
-		return -ENOMEM;
-	}
-	chunk_array_ptr = (uint64_t *)(unsigned long)(cs->chunks);
-	if (DRM_COPY_FROM_USER(p->chunks_array, chunk_array_ptr,
-			       sizeof(uint64_t)*cs->num_chunks)) {
-		return -EFAULT;
-	}
-	p->nchunks = cs->num_chunks;
-	p->chunks = kcalloc(p->nchunks, sizeof(struct radeon_cs_chunk), GFP_KERNEL);
-	if (p->chunks == NULL) {
-		return -ENOMEM;
-	}
-	for (i = 0; i < p->nchunks; i++) {
-		struct drm_radeon_cs_chunk __user **chunk_ptr = NULL;
-		struct drm_radeon_cs_chunk user_chunk;
+	for (i = 0; i < cs->num_chunks; i++) {
+		struct drm_radeon_cs_chunk __user *chunk_ptr = NULL;
+		struct drm_radeon_cs_chunk chunk;
 		uint32_t __user *cdata;
+		unsigned tmp;
+		u64 ptr;
 
-		chunk_ptr = (void __user*)(unsigned long)p->chunks_array[i];
-		if (DRM_COPY_FROM_USER(&user_chunk, chunk_ptr,
-				       sizeof(struct drm_radeon_cs_chunk))) {
+		chunk_ptr = (void __user*)(unsigned long)(cs->chunks + i * 8);
+		if (DRM_COPY_FROM_USER(&ptr, chunk_ptr,  sizeof(u64))) {
 			return -EFAULT;
 		}
-		p->chunks[i].chunk_id = user_chunk.chunk_id;
-		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_RELOCS) {
-			p->chunk_relocs_idx = i;
-		}
-		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_IB) {
-			p->chunk_ib_idx = i;
-		}
-		p->chunks[i].length_dw = user_chunk.length_dw;
-		cdata = (uint32_t *)(unsigned long)user_chunk.chunk_data;
-
-		p->chunks[i].kdata = NULL;
-		size = p->chunks[i].length_dw * sizeof(uint32_t);
-		p->chunks[i].kdata = kzalloc(size, GFP_KERNEL);
-		if (p->chunks[i].kdata == NULL) {
-			return -ENOMEM;
-		}
-		if (DRM_COPY_FROM_USER(p->chunks[i].kdata, cdata, size)) {
+		chunk_ptr = (void __user*)(unsigned long)ptr;
+		if (DRM_COPY_FROM_USER(&chunk, chunk_ptr, sizeof(struct drm_radeon_cs_chunk))) {
 			return -EFAULT;
 		}
-	}
-	if (p->chunks[p->chunk_ib_idx].length_dw > (16 * 1024)) {
-		DRM_ERROR("cs IB too big: %d\n",
-			  p->chunks[p->chunk_ib_idx].length_dw);
-		return -EINVAL;
+		switch (chunk.chunk_id) {
+		case RADEON_CHUNK_ID_RELOCS:
+			r = radeon_cs_parser_reloc(p, &chunk);
+			if (r) {
+				return r;
+			}
+			break;
+		case RADEON_CHUNK_ID_IB:
+			if (found_ib) {
+				DRM_ERROR("Multiple IB chunks not supported\n");
+				return -EINVAL;
+			}
+			found_ib = true;
+			if (chunk.length_dw > 16 * 1024) {
+				DRM_ERROR("cs IB too big: %d\n", chunk.length_dw);
+				return -EINVAL;
+			}
+			p->ibc.chunk_id = chunk.chunk_id;
+			p->ibc.length_dw = chunk.length_dw;
+			tmp = p->ibc.length_dw * sizeof(u32);
+			cdata = (uint32_t *)(unsigned long)chunk.chunk_data;
+			if (DRM_COPY_FROM_USER(p->ibc.kdata, cdata, tmp)) {
+				return -EFAULT;
+			}
+			break;
+		default:
+			break;
+		}
 	}
 	return 0;
 }
@@ -179,13 +158,6 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error)
 			mutex_unlock(&parser->rdev->ddev->struct_mutex);
 		}
 	}
-	kfree(parser->relocs);
-	kfree(parser->relocs_ptr);
-	for (i = 0; i < parser->nchunks; i++) {
-		kfree(parser->chunks[i].kdata);
-	}
-	kfree(parser->chunks);
-	kfree(parser->chunks_array);
 	radeon_ib_free(parser->rdev, &parser->ib);
 }
 
@@ -193,7 +165,6 @@ int radeon_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 {
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_cs_parser parser;
-	struct radeon_cs_chunk *ib_chunk;
 	int r;
 
 	mutex_lock(&rdev->cs_mutex);
@@ -202,36 +173,43 @@ int radeon_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		return -EINVAL;
 	}
 	/* initialize parser */
-	memset(&parser, 0, sizeof(struct radeon_cs_parser));
+	INIT_LIST_HEAD(&parser.validated);
+	parser.idx = 0;
+	parser.ibc.kdata = NULL;
+	parser.ibc.length_dw = 0;
+	parser.relocs = NULL;
+	parser.relocs_ptr = NULL;
+	parser.ib = NULL;
 	parser.filp = filp;
 	parser.rdev = rdev;
-	r = radeon_cs_parser_init(&parser, data);
+	r =  radeon_ib_get(rdev, &parser.ib);
 	if (r) {
-		DRM_ERROR("Failed to initialize parser !\n");
+		DRM_ERROR("Failed to get ib !\n");
 		radeon_cs_parser_fini(&parser, r);
 		mutex_unlock(&rdev->cs_mutex);
 		return r;
 	}
-	r =  radeon_ib_get(rdev, &parser.ib);
+	parser.ibc.kdata = parser.ib->ib;
+	parser.relocs = parser.ib->relocs;
+	parser.relocs_ptr = parser.ib->relocs_ptr;
+	r = radeon_cs_parser_init(&parser, data);
 	if (r) {
-		DRM_ERROR("Failed to get ib !\n");
+		DRM_ERROR("Failed to initialize parser !\n");
 		radeon_cs_parser_fini(&parser, r);
 		mutex_unlock(&rdev->cs_mutex);
 		return r;
 	}
-	r = radeon_cs_parser_relocs(&parser);
-	if (r) {
-		DRM_ERROR("Failed to parse relocation !\n");
+	if (parser.ibc.kdata == NULL) {
+		DRM_INFO("No IB chunk in cs, nothing to do\n");
 		radeon_cs_parser_fini(&parser, r);
 		mutex_unlock(&rdev->cs_mutex);
-		return r;
+		return 0;
 	}
 	/* Copy the packet into the IB, the parser will read from the
 	 * input memory (cached) and write to the IB (which can be
 	 * uncached). */
-	ib_chunk = &parser.chunks[parser.chunk_ib_idx];
-	parser.ib->length_dw = ib_chunk->length_dw;
-	memcpy((void *)parser.ib->ptr, ib_chunk->kdata, ib_chunk->length_dw*4);
+	parser.ib->length_dw = parser.ibc.length_dw;
+	memcpy((void *)parser.ib->ptr, parser.ibc.kdata, parser.ibc.length_dw * 4);
 	r = radeon_cs_parse(&parser);
 	if (r) {
 		DRM_ERROR("Invalid command stream !\n");
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index a853261..0026a11 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -177,6 +177,20 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 
 	/* Allocate 1M object buffer */
 	INIT_LIST_HEAD(&rdev->ib_pool.scheduled_ibs);
+	rdev->ib_pool.ib = drm_calloc_large(RADEON_IB_POOL_SIZE, 64 * 1024);
+	if (rdev->ib_pool.ib == NULL) {
+		return -ENOMEM;
+	}
+	rdev->ib_pool.relocs = drm_calloc_large(RADEON_IB_POOL_SIZE * 1024,
+						sizeof(struct radeon_cs_reloc));
+	if (rdev->ib_pool.relocs == NULL) {
+		return -ENOMEM;
+	}
+	rdev->ib_pool.relocs_ptr = drm_calloc_large(RADEON_IB_POOL_SIZE * 1024,
+						    sizeof(void *));
+	if (rdev->ib_pool.relocs == NULL) {
+		return -ENOMEM;
+	}
 	r = radeon_object_create(rdev, NULL,  RADEON_IB_POOL_SIZE*64*1024,
 				 true, RADEON_GEM_DOMAIN_GTT,
 				 false, &rdev->ib_pool.robj);
@@ -202,6 +216,9 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 		rdev->ib_pool.ibs[i].ptr = ptr + offset;
 		rdev->ib_pool.ibs[i].idx = i;
 		rdev->ib_pool.ibs[i].length_dw = 0;
+		rdev->ib_pool.ibs[i].ib = &rdev->ib_pool.ib[i * 16 * 1024];
+		rdev->ib_pool.ibs[i].relocs = &rdev->ib_pool.relocs[i * 1024];
+		rdev->ib_pool.ibs[i].relocs_ptr = &rdev->ib_pool.relocs_ptr[i * 1024];
 		INIT_LIST_HEAD(&rdev->ib_pool.ibs[i].list);
 	}
 	bitmap_zero(rdev->ib_pool.alloc_bm, RADEON_IB_POOL_SIZE);
@@ -225,6 +242,12 @@ void radeon_ib_pool_fini(struct radeon_device *rdev)
 		radeon_object_unref(&rdev->ib_pool.robj);
 		rdev->ib_pool.robj = NULL;
 	}
+	if (rdev->ib_pool.ib)
+		drm_free_large(rdev->ib_pool.ib);
+	if (rdev->ib_pool.relocs)
+		drm_free_large(rdev->ib_pool.relocs);
+	if (rdev->ib_pool.relocs_ptr)
+		drm_free_large(rdev->ib_pool.relocs_ptr);
 	mutex_unlock(&rdev->ib_pool.mutex);
 }
 
-- 
1.6.2.2

