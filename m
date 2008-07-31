Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYGaBFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYGaBFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYGaBE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:04:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46390 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbYGaBE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:04:58 -0400
Date: Thu, 31 Jul 2008 02:04:56 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH][stable] drm/radeon: fixup issue with radeon and PAT
 support.
Message-ID: <alpine.DEB.0.82.0807310203560.8146@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With new userspace libpciaccess we can get a conflicting mapping
on the PCIE GART table in the video RAM. Always try and map it _wc.

Only do this on x86, some arches notably sparc aren't using iomap.h
so we don't get the ioremap_wc define there, so for stable better
safe than sorry.

stable: I've asked Linus to pull the same patch for the new drm layout
already.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/char/drm/drmP.h       |    1 +
 drivers/char/drm/drm_memory.c |   10 ++++++++++
 drivers/char/drm/radeon_cp.c  |    2 +-
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 0764b66..1c1b13e 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -1089,6 +1089,7 @@ extern int drm_mm_remove_space_from_tail(struct drm_mm *mm, unsigned long size);
 extern int drm_mm_add_space_to_tail(struct drm_mm *mm, unsigned long size);
 
 extern void drm_core_ioremap(struct drm_map *map, struct drm_device *dev);
+extern void drm_core_ioremap_wc(struct drm_map *map, struct drm_device *dev);
 extern void drm_core_ioremapfree(struct drm_map *map, struct drm_device *dev);
 
 static __inline__ struct drm_map *drm_core_findmap(struct drm_device *dev,
diff --git a/drivers/char/drm/drm_memory.c b/drivers/char/drm/drm_memory.c
index 845081b..f347d26 100644
--- a/drivers/char/drm/drm_memory.c
+++ b/drivers/char/drm/drm_memory.c
@@ -167,6 +167,16 @@ void drm_core_ioremap(struct drm_map *map, struct drm_device *dev)
 }
 EXPORT_SYMBOL(drm_core_ioremap);
 
+void drm_core_ioremap_wc(struct drm_map *map, struct drm_device *dev)
+{
+#ifdef CONFIG_X86
+	map->handle = ioremap_wc(map->offset, map->size);
+#else
+	map->handle = ioremap(map->offset, map->size);
+#endif
+}
+EXPORT_SYMBOL(drm_core_ioremap_wc);
+
 void drm_core_ioremapfree(struct drm_map *map, struct drm_device *dev)
 {
 	if (!map->handle || !map->size)
diff --git a/drivers/char/drm/radeon_cp.c b/drivers/char/drm/radeon_cp.c
index e53158f..f0de81a 100644
--- a/drivers/char/drm/radeon_cp.c
+++ b/drivers/char/drm/radeon_cp.c
@@ -1154,7 +1154,7 @@ static int radeon_do_init_cp(struct drm_device * dev, drm_radeon_init_t * init)
 			dev_priv->gart_info.mapping.size =
 			    dev_priv->gart_info.table_size;
 
-			drm_core_ioremap(&dev_priv->gart_info.mapping, dev);
+			drm_core_ioremap_wc(&dev_priv->gart_info.mapping, dev);
 			dev_priv->gart_info.addr =
 			    dev_priv->gart_info.mapping.handle;
 
-- 
1.5.5.1

