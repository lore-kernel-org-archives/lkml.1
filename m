Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZJUUvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZJUUvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZJUUvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:51:43 -0400
Received: from nox.protox.org ([88.191.38.29]:38676 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZJUUvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:51:42 -0400
Subject: Changing radeon KMS cs+gem ioctl to merge read & write domain
From: Jerome Glisse <glisse@freedesktop.org>
To: DRI Development Mailing List <dri-devel@lists.sourceforge.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-tKbvaVp0hj/WqbHcJLdR"
Date: Thu, 22 Oct 2009 00:49:09 +0200
Message-Id: <1256165349.15474.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tKbvaVp0hj/WqbHcJLdR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi,

I think we should merge the read & write domain of radeon KMS
into a single domains information. I don't think there is a
good reason for separate read & write domain, we did copy intel
model for that and intel use this mostly for cache coherency &
cache flushing as far as i understand. We make no good use of
this inside the kernel. In order to make this change less disruptive
and easier to introduce i propose we keep libdrm-radeon api
intact thus userspace xf86video-ati & mesa 3d driver doesn't
need a single line patch to adapt. Attached is a proof of concept,
a patch against libdrm which merge read & write domain and only
use the read domain to communicate with the kernel. I am still
in process of stress testing this patch but so far neither X
or 3D had any glitches.

I want to take advantage of this change to the cs reloc to the
following:
struct drm_radeon_cs_reloc {
»·······uint32_t»·······»·······handle;
»·······uint32_t»·······»·······domains;
»·······uint32_t»·······»·······unused;
»·······uint32_t»·······»·······flags;
};

With the following rules: a domain is a 4bit value (more than
enough i believe). Userspace can then provide domain preference
for each relocation. For instance :
0 Invalid|CPU
1 VRAM
2 GTT

domains = (VRAM << 0) | (GTT << 4)
would mean try to place object in VRAM first, if not enough
VRAM place it in GTT.

domains = (GTT << 0)
object can only be in GTT
...

I believe this would be a lot more useful information that
read|write domain. We would also now assume that userspace
knows what it's doing inside a single submited cs and that
userspace issue necessary flush if a bo is used in different
way. Which is what the ddx does.

I believe the only argument in favor of read & write split
is broken AGP chipset where GPU can't write to GART. So far
we don't use this information to work around the issue,
we don't even always test AGP writeback. Thus i believe this
change won't impact current user. Note that i am working on
code to work around bad AGP chipset (fallback to PCI GART
for GPU write + detection of broken writeback).

I really think we should take advantage of being in staging
driver to get the ioctl right before we have to freeze them.

Cheers,
Jerome Glisse

--=-tKbvaVp0hj/WqbHcJLdR
Content-Disposition: attachment; filename*0=0001-libdrm-libradeon-Unify-read-write-domain-into-a-sing.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-libdrm-libradeon-Unify-read-write-domain-into-a-sing.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 4dcdd0b5fce6d8ca5a6b8ae08cfbb0c80af6613e Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Thu, 22 Oct 2009 00:26:32 +0200
Subject: [PATCH] libdrm/libradeon: Unify read & write domain into a single one

This unify read & write domain into a single domain
without changing the API or ABI of libdrm_radeon.
---
 libdrm/radeon/radeon_cs.h       |   11 +--
 libdrm/radeon/radeon_cs_gem.c   |   35 +++-----
 libdrm/radeon/radeon_cs_space.c |  169 +++++++++++++--------------------------
 3 files changed, 71 insertions(+), 144 deletions(-)

diff --git a/libdrm/radeon/radeon_cs.h b/libdrm/radeon/radeon_cs.h
index 1117a85..8005550 100644
--- a/libdrm/radeon/radeon_cs.h
+++ b/libdrm/radeon/radeon_cs.h
@@ -40,8 +40,7 @@
 
 struct radeon_cs_reloc {
     struct radeon_bo    *bo;
-    uint32_t            read_domain;
-    uint32_t            write_domain;
+    uint32_t            domains;
     uint32_t            flags;
 };
 
@@ -52,8 +51,7 @@ struct radeon_cs_reloc {
 
 struct radeon_cs_space_check {
     struct radeon_bo *bo;
-    uint32_t read_domains;
-    uint32_t write_domain;
+    uint32_t domains;
     uint32_t new_accounted;
 };
 
@@ -109,9 +107,8 @@ struct radeon_cs_funcs {
 struct radeon_cs_manager {
     struct radeon_cs_funcs  *funcs;
     int                     fd;
-    int32_t vram_limit, gart_limit;
-    int32_t vram_write_used, gart_write_used;
-    int32_t read_used;
+    int32_t                 vram_limit, gart_limit;
+    int32_t                 vram_free, gart_free;
 };
 
 static inline struct radeon_cs *radeon_cs_create(struct radeon_cs_manager *csm,
diff --git a/libdrm/radeon/radeon_cs_gem.c b/libdrm/radeon/radeon_cs_gem.c
index e42ec48..5762c68 100644
--- a/libdrm/radeon/radeon_cs_gem.c
+++ b/libdrm/radeon/radeon_cs_gem.c
@@ -115,11 +115,12 @@ static int cs_gem_write_reloc(struct radeon_cs *cs,
 {
     struct cs_gem *csg = (struct cs_gem*)cs;
     struct cs_reloc_gem *reloc;
-    uint32_t idx;
+    uint32_t idx, domains;
     unsigned i;
 
     assert(bo->space_accounted);
-
+    domains = read_domain | write_domain;
+#if 0
     /* check domains */
     if ((read_domain && write_domain) || (!read_domain && !write_domain)) {
         /* in one CS a bo can only be in read or write domain but not
@@ -127,10 +128,11 @@ static int cs_gem_write_reloc(struct radeon_cs *cs,
          */
         return -EINVAL;
     }
-    if (read_domain == RADEON_GEM_DOMAIN_CPU) {
+#endif
+    if (read_domain & RADEON_GEM_DOMAIN_CPU) {
         return -EINVAL;
     }
-    if (write_domain == RADEON_GEM_DOMAIN_CPU) {
+    if (write_domain & RADEON_GEM_DOMAIN_CPU) {
         return -EINVAL;
     }
     /* check if bo is already referenced */
@@ -145,20 +147,8 @@ static int cs_gem_write_reloc(struct radeon_cs *cs,
              * new relocation.
              */
             /* the DDX expects to read and write from same pixmap */
-            if (write_domain && (reloc->read_domain & write_domain)) {
-                reloc->read_domain = 0;
-                reloc->write_domain = write_domain;
-            } else if (read_domain & reloc->write_domain) {
-                reloc->read_domain = 0;
-            } else {
-                if (write_domain != reloc->write_domain)
-                    return -EINVAL;
-                if (read_domain != reloc->read_domain)
-                    return -EINVAL;
-            }
-
-            reloc->read_domain |= read_domain;
-            reloc->write_domain |= write_domain;
+            reloc->read_domain |= domains;
+            reloc->write_domain = 0;
             /* update flags */
             reloc->flags |= (flags & reloc->flags);
             /* write relocation packet */
@@ -190,8 +180,8 @@ static int cs_gem_write_reloc(struct radeon_cs *cs,
     idx = (csg->base.crelocs++) * RELOC_SIZE;
     reloc = (struct cs_reloc_gem*)&csg->relocs[idx];
     reloc->handle = bo->handle;
-    reloc->read_domain = read_domain;
-    reloc->write_domain = write_domain;
+    reloc->read_domain = domains;
+    reloc->write_domain = 0;
     reloc->flags = flags;
     csg->chunks[1].length_dw += RELOC_SIZE;
     radeon_bo_ref(bo);
@@ -283,9 +273,8 @@ static int cs_gem_emit(struct radeon_cs *cs)
 	    csg->relocs_bo[i] = NULL;
     }
 
-    cs->csm->read_used = 0;
-    cs->csm->vram_write_used = 0;
-    cs->csm->gart_write_used = 0;
+    cs->csm->vram_free = cs->csm->vram_limit;
+    cs->csm->gart_free = cs->csm->gart_limit;
     return r;
 }
 
diff --git a/libdrm/radeon/radeon_cs_space.c b/libdrm/radeon/radeon_cs_space.c
index 4c1ef93..f4160e3 100644
--- a/libdrm/radeon/radeon_cs_space.c
+++ b/libdrm/radeon/radeon_cs_space.c
@@ -31,72 +31,39 @@
 #include "radeon_cs.h"
 
 struct rad_sizes {
-    int32_t op_read;
-    int32_t op_gart_write;
-    int32_t op_vram_write;
+    int32_t op_gtt;
+    int32_t op_vram;
 };
 
-static inline int radeon_cs_setup_bo(struct radeon_cs_space_check *sc, struct rad_sizes *sizes)
+static inline int radeon_cs_setup_bo(struct radeon_cs_space_check *sc,
+                                     struct radeon_cs_manager *csm,
+                                     struct rad_sizes *sizes)
 {
-    uint32_t read_domains, write_domain;
+    uint32_t domains;
     struct radeon_bo *bo;
 
     bo = sc->bo;
     sc->new_accounted = 0;
-    read_domains = sc->read_domains;
-    write_domain = sc->write_domain;
+    domains = sc->domains;
 
     /* legacy needs a static check */
     if (radeon_bo_is_static(bo)) {
-	bo->space_accounted = sc->new_accounted = (read_domains << 16) | write_domain;
-	return 0;
+        bo->space_accounted = sc->new_accounted = domains;
+        return 0;
     }
 
-    /* already accounted this bo */
-    if (write_domain && (write_domain == bo->space_accounted)) {
-	sc->new_accounted = bo->space_accounted;
-	return 0;
+    /* bo accounted in vram */
+    if (bo->space_accounted == RADEON_GEM_DOMAIN_VRAM) {
+        sc->new_accounted = bo->space_accounted;
+        return 0;
     }
-    if (read_domains && ((read_domains << 16) == bo->space_accounted)) {
-	sc->new_accounted = bo->space_accounted;
-	return 0;
-    }
-
-    if (bo->space_accounted == 0) {
-	if (write_domain == RADEON_GEM_DOMAIN_VRAM)
-	    sizes->op_vram_write += bo->size;
-	else if (write_domain == RADEON_GEM_DOMAIN_GTT)
-	  sizes->op_gart_write += bo->size;
-	else
-	    sizes->op_read += bo->size;
-	sc->new_accounted = (read_domains << 16) | write_domain;
-    } else {
-	uint16_t old_read, old_write;
-	
-	old_read = bo->space_accounted >> 16;
-	old_write = bo->space_accounted & 0xffff;
-	
-	if (write_domain && (old_read & write_domain)) {
-	    sc->new_accounted = write_domain;
-	    /* moving from read to a write domain */
-	    if (write_domain == RADEON_GEM_DOMAIN_VRAM) {
-		sizes->op_read -= bo->size;
-		sizes->op_vram_write += bo->size;
-	    } else if (write_domain == RADEON_GEM_DOMAIN_GTT) {
-		sizes->op_read -= bo->size;
-		sizes->op_gart_write += bo->size;
-	    }
-	} else if (read_domains & old_write) {
-	    sc->new_accounted = bo->space_accounted & 0xffff;
-	} else {
-	    /* rewrite the domains */
-	    if (write_domain != old_write)
-		fprintf(stderr,"WRITE DOMAIN RELOC FAILURE 0x%x %d %d\n", bo->handle, write_domain, old_write);
-	    if (read_domains != old_read)
-		fprintf(stderr,"READ DOMAIN RELOC FAILURE 0x%x %d %d\n", bo->handle, read_domains, old_read);
-	    return RADEON_CS_SPACE_FLUSH;
-	}
+    if (bo->space_accounted & domains) {
+        sc->new_accounted = bo->space_accounted;
+        return 0;
     }
+    sizes->op_gtt -= bo->size;
+    sizes->op_vram += bo->size;
+    bo->space_accounted = sc->new_accounted = RADEON_GEM_DOMAIN_VRAM;
     return 0;
 }
 
@@ -109,70 +76,51 @@ static int radeon_cs_do_space_check(struct radeon_cs *cs, struct radeon_cs_space
     int ret;
 
     /* check the totals for this operation */
-
     if (cs->bo_count == 0 && !new_tmp)
-	return 0;
-
+        return 0;
     memset(&sizes, 0, sizeof(struct rad_sizes));
 
     /* prepare */
     for (i = 0; i < cs->bo_count; i++) {
-	ret = radeon_cs_setup_bo(&cs->bos[i], &sizes);
-	if (ret)
-	    return ret;
+        ret = radeon_cs_setup_bo(&cs->bos[i], csm, &sizes);
+        if (ret)
+            return ret;
     }
 
     if (new_tmp) {
-	ret = radeon_cs_setup_bo(new_tmp, &sizes);
-	if (ret)
-	    return ret;
-    }
-	
-    if (sizes.op_read < 0)
-	    sizes.op_read = 0;
-
-    /* check sizes - operation first */
-    if ((sizes.op_read + sizes.op_gart_write > csm->gart_limit) ||
-	(sizes.op_vram_write > csm->vram_limit)) {
-	    return RADEON_CS_SPACE_OP_TO_BIG;
-    }
-    
-    if (((csm->vram_write_used + sizes.op_vram_write) > csm->vram_limit) ||
-	((csm->read_used + csm->gart_write_used + sizes.op_gart_write + sizes.op_read) > csm->gart_limit)) {
-	    return RADEON_CS_SPACE_FLUSH;
+        ret = radeon_cs_setup_bo(new_tmp, csm, &sizes);
+        if (ret)
+            return ret;
     }
-    
-    csm->gart_write_used += sizes.op_gart_write;
-    csm->vram_write_used += sizes.op_vram_write;
-    csm->read_used += sizes.op_read;
+    if ((sizes.op_gtt + sizes.op_vram) >= (csm->gart_limit + csm->vram_limit))
+        return RADEON_CS_SPACE_FLUSH;
+    csm->gart_free -= sizes.op_gtt;
+    csm->vram_free -= sizes.op_vram;
     /* commit */
     for (i = 0; i < cs->bo_count; i++) {
-	    bo = cs->bos[i].bo;
-	    bo->space_accounted = cs->bos[i].new_accounted;
+        bo = cs->bos[i].bo;
+        bo->space_accounted = cs->bos[i].new_accounted;
     }
     if (new_tmp)
-	new_tmp->bo->space_accounted = new_tmp->new_accounted;
-    
+        new_tmp->bo->space_accounted = new_tmp->new_accounted;
     return RADEON_CS_SPACE_OK;
 }
 
 void radeon_cs_space_add_persistent_bo(struct radeon_cs *cs, struct radeon_bo *bo, uint32_t read_domains, uint32_t write_domain)
 {
+    uint32_t domains = read_domains | write_domain;
     int i;
+
     for (i = 0; i < cs->bo_count; i++) {
-	if (cs->bos[i].bo == bo &&
-	    cs->bos[i].read_domains == read_domains &&
-	    cs->bos[i].write_domain == write_domain)
-	    return;
+        if (cs->bos[i].bo == bo && (cs->bos[i].domains & domains))
+            return;
     }
     radeon_bo_ref(bo);
     i = cs->bo_count;
     cs->bos[i].bo = bo;
-    cs->bos[i].read_domains = read_domains;
-    cs->bos[i].write_domain = write_domain;
+    cs->bos[i].domains = domains;
     cs->bos[i].new_accounted = 0;
     cs->bo_count++;
-
     assert(cs->bo_count < MAX_SPACE_BOS);
 }
 
@@ -184,33 +132,29 @@ static int radeon_cs_check_space_internal(struct radeon_cs *cs, struct radeon_cs
 again:
     ret = radeon_cs_do_space_check(cs, tmp_bo);
     if (ret == RADEON_CS_SPACE_OP_TO_BIG)
-	return -1;
+        return -1;
     if (ret == RADEON_CS_SPACE_FLUSH) {
-	(*cs->space_flush_fn)(cs->space_flush_data);
-	if (flushed)
-	    return -1;
-	flushed = 1;
-	goto again;
+        (*cs->space_flush_fn)(cs->space_flush_data);
+        if (flushed)
+            return -1;
+        flushed = 1;
+        goto again;
     }
     return 0;
 }
 
 int radeon_cs_space_check_with_bo(struct radeon_cs *cs,
-				  struct radeon_bo *bo,
-				  uint32_t read_domains, uint32_t write_domain)
-{									
+                  struct radeon_bo *bo,
+                  uint32_t read_domains, uint32_t write_domain)
+{
     struct radeon_cs_space_check temp_bo;
-    int ret = 0;
 
     if (bo) {
-	temp_bo.bo = bo;
-	temp_bo.read_domains = read_domains;
-	temp_bo.write_domain = write_domain;
-	temp_bo.new_accounted = 0;
+        temp_bo.bo = bo;
+        temp_bo.domains = read_domains | write_domain;
+        temp_bo.new_accounted = 0;
     }
-
-    ret = radeon_cs_check_space_internal(cs, bo ? &temp_bo : NULL);
-    return ret;
+    return radeon_cs_check_space_internal(cs, bo ? &temp_bo : NULL);
 }
 
 int radeon_cs_space_check(struct radeon_cs *cs)
@@ -222,13 +166,10 @@ void radeon_cs_space_reset_bos(struct radeon_cs *cs)
 {
     int i;
     for (i = 0; i < cs->bo_count; i++) {
-	radeon_bo_unref(cs->bos[i].bo);
-	cs->bos[i].bo = NULL;
-	cs->bos[i].read_domains = 0;
-	cs->bos[i].write_domain = 0;
-	cs->bos[i].new_accounted = 0;
+        radeon_bo_unref(cs->bos[i].bo);
+        cs->bos[i].bo = NULL;
+        cs->bos[i].domains = 0;
+        cs->bos[i].new_accounted = 0;
     }
     cs->bo_count = 0;
 }
-
-
-- 
1.6.5.rc2


--=-tKbvaVp0hj/WqbHcJLdR--

