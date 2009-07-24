Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZGXH5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZGXH5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZGXH5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:57:34 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:55412 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbZGXH5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:57:32 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 2/2] ttm: Fix ttm in-kernel copying of pages with non-standard caching attributes.
Date: Fri, 24 Jul 2009 09:57:34 +0200
Message-Id: <1248422254-32193-2-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1248422254-32193-1-git-send-email-thellstrom@vmware.com>
References: <>
 <1248422254-32193-1-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 this affected highmem pages only, since they were always kmapped
cache-coherent, and this is fixed using kmap_atomic_prot().

For other architectures that may not modify the linear kernel map we
resort to vmap() for now, since kmap_atomic_prot() generally uses the
linear kernel map for lowmem pages. This of course comes with a
performance impact and should be optimized when possible.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |   63 ++++++++++++++++++++++++++++++------
 1 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 3e5d0c4..ce2e6f3 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -136,7 +136,8 @@ static int ttm_copy_io_page(void *dst, void *src, unsigned long page)
 }
 
 static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
-				unsigned long page)
+				unsigned long page,
+				pgprot_t prot)
 {
 	struct page *d = ttm_tt_get_page(ttm, page);
 	void *dst;
@@ -145,17 +146,35 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
 		return -ENOMEM;
 
 	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
-	dst = kmap(d);
+
+#ifdef CONFIG_X86
+	dst = kmap_atomic_prot(d, KM_USER0, prot);
+#else
+	if (prot != PAGE_KERNEL)
+		dst = vmap(&d, 1, 0, prot);
+	else
+		dst = kmap(d);
+#endif
 	if (!dst)
 		return -ENOMEM;
 
 	memcpy_fromio(dst, src, PAGE_SIZE);
-	kunmap(d);
+
+#ifdef CONFIG_X86
+	kunmap_atomic(dst, KM_USER0);
+#else
+	if (prot != PAGE_KERNEL)
+		vunmap(dst);
+	else
+		kunmap(d);
+#endif
+
 	return 0;
 }
 
 static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
-				unsigned long page)
+				unsigned long page,
+				pgprot_t prot)
 {
 	struct page *s = ttm_tt_get_page(ttm, page);
 	void *src;
@@ -164,12 +183,28 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
 		return -ENOMEM;
 
 	dst = (void *)((unsigned long)dst + (page << PAGE_SHIFT));
-	src = kmap(s);
+#ifdef CONFIG_X86
+	src = kmap_atomic_prot(s, KM_USER0, prot);
+#else
+	if (prot != PAGE_KERNEL)
+		src = vmap(&s, 1, 0, prot);
+	else
+		src = kmap(s);
+#endif
 	if (!src)
 		return -ENOMEM;
 
 	memcpy_toio(dst, src, PAGE_SIZE);
-	kunmap(s);
+
+#ifdef CONFIG_X86
+	kunmap_atomic(src, KM_USER0);
+#else
+	if (prot != PAGE_KERNEL)
+		vunmap(src);
+	else
+		kunmap(s);
+#endif
+
 	return 0;
 }
 
@@ -214,11 +249,17 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
 
 	for (i = 0; i < new_mem->num_pages; ++i) {
 		page = i * dir + add;
-		if (old_iomap == NULL)
-			ret = ttm_copy_ttm_io_page(ttm, new_iomap, page);
-		else if (new_iomap == NULL)
-			ret = ttm_copy_io_ttm_page(ttm, old_iomap, page);
-		else
+		if (old_iomap == NULL) {
+			pgprot_t prot = ttm_io_prot(old_mem->placement,
+						    PAGE_KERNEL);
+			ret = ttm_copy_ttm_io_page(ttm, new_iomap, page,
+						   prot);
+		} else if (new_iomap == NULL) {
+			pgprot_t prot = ttm_io_prot(new_mem->placement,
+						    PAGE_KERNEL);
+			ret = ttm_copy_io_ttm_page(ttm, old_iomap, page,
+						   prot);
+		} else
 			ret = ttm_copy_io_page(new_iomap, old_iomap, page);
 		if (ret)
 			goto out1;
-- 
1.6.1.3

