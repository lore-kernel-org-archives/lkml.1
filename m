Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbXH0VPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbXH0VPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbXH0VNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:48 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1144 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbXH0VNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:47 -0400
Message-Id: <20070827211344.724173000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:54 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 04/23] drm_bufs.c: drm_alloc + memset to drm_alloc
Content-Disposition: inline; filename=drm_bufs.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does dma_alloc and memset conversion to drm_zalloc or drm_calloc.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_bufs.c | 44959 -> 44420 (-539 bytes)
 drivers/char/drm/drm_bufs.o | 149686 -> 146822 (-2864 bytes)

 drivers/char/drm/drm_bufs.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_bufs.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_bufs.c
@@ -277,14 +277,13 @@ static int drm_addmap_core(struct drm_de
 		return -EINVAL;
 	}

-	list = drm_alloc(sizeof(*list), DRM_MEM_MAPS);
+	list = drm_zalloc(sizeof(*list), DRM_MEM_MAPS);
 	if (!list) {
 		if (map->type == _DRM_REGISTERS)
 			iounmap(map->handle);
 		drm_free(map, sizeof(*map), DRM_MEM_MAPS);
 		return -EINVAL;
 	}
-	memset(list, 0, sizeof(*list));
 	list->map = map;

 	mutex_lock(&dev->struct_mutex);
@@ -627,14 +626,13 @@ int drm_addbufs_agp(struct drm_device *
 		return -EINVAL;
 	}

-	entry->buflist = drm_alloc(count * sizeof(*entry->buflist),
+	entry->buflist = drm_calloc(count, sizeof(*entry->buflist),
 				   DRM_MEM_BUFS);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));

 	entry->buf_size = size;
 	entry->page_order = page_order;
@@ -658,7 +656,7 @@ int drm_addbufs_agp(struct drm_device *
 		buf->filp = NULL;

 		buf->dev_priv_size = dev->driver->dev_priv_size;
-		buf->dev_private = drm_alloc(buf->dev_priv_size, DRM_MEM_BUFS);
+		buf->dev_private = drm_zalloc(buf->dev_priv_size, DRM_MEM_BUFS);
 		if (!buf->dev_private) {
 			/* Set count correctly so we free the proper amount. */
 			entry->buf_count = count;
@@ -667,7 +665,6 @@ int drm_addbufs_agp(struct drm_device *
 			atomic_dec(&dev->buf_alloc);
 			return -ENOMEM;
 		}
-		memset(buf->dev_private, 0, buf->dev_priv_size);

 		DRM_DEBUG("buffer %d @ %p\n", entry->buf_count, buf->address);

@@ -783,16 +780,15 @@ int drm_addbufs_pci(struct drm_device *
 		return -EINVAL;
 	}

-	entry->buflist = drm_alloc(count * sizeof(*entry->buflist),
+	entry->buflist = drm_calloc(count, sizeof(*entry->buflist),
 				   DRM_MEM_BUFS);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));

-	entry->seglist = drm_alloc(count * sizeof(*entry->seglist),
+	entry->seglist = drm_calloc(count, sizeof(*entry->seglist),
 				   DRM_MEM_SEGS);
 	if (!entry->seglist) {
 		drm_free(entry->buflist,
@@ -801,7 +797,6 @@ int drm_addbufs_pci(struct drm_device *
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->seglist, 0, count * sizeof(*entry->seglist));

 	/* Keep the original pagelist until we know all the allocations
 	 * have succeeded
@@ -869,7 +864,7 @@ int drm_addbufs_pci(struct drm_device *
 			buf->filp = NULL;

 			buf->dev_priv_size = dev->driver->dev_priv_size;
-			buf->dev_private = drm_alloc(buf->dev_priv_size,
+			buf->dev_private = drm_zalloc(buf->dev_priv_size,
 						     DRM_MEM_BUFS);
 			if (!buf->dev_private) {
 				/* Set count correctly so we free the proper amount. */
@@ -885,7 +880,6 @@ int drm_addbufs_pci(struct drm_device *
 				atomic_dec(&dev->buf_alloc);
 				return -ENOMEM;
 			}
-			memset(buf->dev_private, 0, buf->dev_priv_size);

 			DRM_DEBUG("buffer %d @ %p\n",
 				  entry->buf_count, buf->address);
@@ -1015,14 +1009,13 @@ static int drm_addbufs_sg(struct drm_dev
 		return -EINVAL;
 	}

-	entry->buflist = drm_alloc(count * sizeof(*entry->buflist),
+	entry->buflist = drm_calloc(count, sizeof(*entry->buflist),
 				   DRM_MEM_BUFS);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));

 	entry->buf_size = size;
 	entry->page_order = page_order;
@@ -1047,7 +1040,7 @@ static int drm_addbufs_sg(struct drm_dev
 		buf->filp = NULL;

 		buf->dev_priv_size = dev->driver->dev_priv_size;
-		buf->dev_private = drm_alloc(buf->dev_priv_size, DRM_MEM_BUFS);
+		buf->dev_private = drm_zalloc(buf->dev_priv_size, DRM_MEM_BUFS);
 		if (!buf->dev_private) {
 			/* Set count correctly so we free the proper amount. */
 			entry->buf_count = count;
@@ -1057,8 +1050,6 @@ static int drm_addbufs_sg(struct drm_dev
 			return -ENOMEM;
 		}

-		memset(buf->dev_private, 0, buf->dev_priv_size);
-
 		DRM_DEBUG("buffer %d @ %p\n", entry->buf_count, buf->address);

 		offset += alignment;
@@ -1177,14 +1168,13 @@ static int drm_addbufs_fb(struct drm_dev
 		return -EINVAL;
 	}

-	entry->buflist = drm_alloc(count * sizeof(*entry->buflist),
+	entry->buflist = drm_calloc(count, sizeof(*entry->buflist),
 				   DRM_MEM_BUFS);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));

 	entry->buf_size = size;
 	entry->page_order = page_order;
@@ -1208,7 +1198,7 @@ static int drm_addbufs_fb(struct drm_dev
 		buf->filp = NULL;

 		buf->dev_priv_size = dev->driver->dev_priv_size;
-		buf->dev_private = drm_alloc(buf->dev_priv_size, DRM_MEM_BUFS);
+		buf->dev_private = drm_zalloc(buf->dev_priv_size, DRM_MEM_BUFS);
 		if (!buf->dev_private) {
 			/* Set count correctly so we free the proper amount. */
 			entry->buf_count = count;
@@ -1217,7 +1207,6 @@ static int drm_addbufs_fb(struct drm_dev
 			atomic_dec(&dev->buf_alloc);
 			return -ENOMEM;
 		}
-		memset(buf->dev_private, 0, buf->dev_priv_size);

 		DRM_DEBUG("buffer %d @ %p\n", entry->buf_count, buf->address);

--
