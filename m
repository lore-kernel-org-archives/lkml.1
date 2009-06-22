Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZFVR0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZFVR0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbZFVR0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:26:04 -0400
Received: from nox.protox.org ([88.191.38.29]:38864 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZFVR0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:26:03 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] radeon: use vmalloc instead of kmalloc
Date: Mon, 22 Jun 2009 19:26:01 +0200
Message-Id: <1245691561-15336-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to allocated contiguous pages in cs codepath
so use vmalloc instead.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index b843f9b..54a9740 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -45,11 +45,11 @@ int radeon_cs_parser_relocs(struct radeon_cs_parser *p)
 	chunk = &p->chunks[p->chunk_relocs_idx];
 	/* FIXME: we assume that each relocs use 4 dwords */
 	p->nrelocs = chunk->length_dw / 4;
-	p->relocs_ptr = kcalloc(p->nrelocs, sizeof(void *), GFP_KERNEL);
+	p->relocs_ptr = vmalloc(p->nrelocs * sizeof(void *));
 	if (p->relocs_ptr == NULL) {
 		return -ENOMEM;
 	}
-	p->relocs = kcalloc(p->nrelocs, sizeof(struct radeon_cs_reloc), GFP_KERNEL);
+	p->relocs = vmalloc(p->nrelocs * sizeof(struct radeon_cs_reloc));
 	if (p->relocs == NULL) {
 		return -ENOMEM;
 	}
@@ -103,7 +103,7 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 	p->idx = 0;
 	p->chunk_ib_idx = -1;
 	p->chunk_relocs_idx = -1;
-	p->chunks_array = kcalloc(cs->num_chunks, sizeof(uint64_t), GFP_KERNEL);
+	p->chunks_array = vmalloc(cs->num_chunks * sizeof(uint64_t));
 	if (p->chunks_array == NULL) {
 		return -ENOMEM;
 	}
@@ -113,7 +113,7 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 		return -EFAULT;
 	}
 	p->nchunks = cs->num_chunks;
-	p->chunks = kcalloc(p->nchunks, sizeof(struct radeon_cs_chunk), GFP_KERNEL);
+	p->chunks = vmalloc(p->nchunks * sizeof(struct radeon_cs_chunk));
 	if (p->chunks == NULL) {
 		return -ENOMEM;
 	}
@@ -139,7 +139,7 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 
 		p->chunks[i].kdata = NULL;
 		size = p->chunks[i].length_dw * sizeof(uint32_t);
-		p->chunks[i].kdata = kzalloc(size, GFP_KERNEL);
+		p->chunks[i].kdata = vmalloc(size);
 		if (p->chunks[i].kdata == NULL) {
 			return -ENOMEM;
 		}
@@ -179,13 +179,13 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error)
 			mutex_unlock(&parser->rdev->ddev->struct_mutex);
 		}
 	}
-	kfree(parser->relocs);
-	kfree(parser->relocs_ptr);
+	vfree(parser->relocs);
+	vfree(parser->relocs_ptr);
 	for (i = 0; i < parser->nchunks; i++) {
-		kfree(parser->chunks[i].kdata);
+		vfree(parser->chunks[i].kdata);
 	}
-	kfree(parser->chunks);
-	kfree(parser->chunks_array);
+	vfree(parser->chunks);
+	vfree(parser->chunks_array);
 	radeon_ib_free(parser->rdev, &parser->ib);
 }
 
-- 
1.6.2.2

