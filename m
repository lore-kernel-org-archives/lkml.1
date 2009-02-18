Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZBRXl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZBRXl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZBRXlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:41:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42097
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbZBRXlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:41:18 -0500
Date: Wed, 18 Feb 2009 15:41:02 -0800 (PST)
Message-Id: <20090218.154102.122148224.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drm: Preserve SHMLBA bits in hash key for _DRM_SHM
 mappings.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ok, this is the last DRM bug I am aware of with Radeon on sparc64.
What kills me is that I fixed this bug 6 or 7 years ago :)

--------------------

drm: Preserve SHMLBA bits in hash key for _DRM_SHM mappings.

Platforms such as sparc64 have D-cache aliasing issues.  We
cannot allow virtual mappings in different contexts to be such
that two cache lines can be loaded for the same backing data.
Updates to one cache line won't be seen by accesses to the other
cache line.

Code in sparc64 and other architectures solve this problem by
making sure that all userland mappings of MAP_SHARED objects have
the same virtual address base.  They implement this by keying
off of the page offset, and using that to choose a suitably
consistent virtual address for mmap() requests.

Making things even worse, getting this wrong on sparc64 can result
in hangs during DRM lock acquisition.  This is because, at least on
UltraSPARC-III, normal loads consult the D-cache but atomics such
as 'cas' (which is what cmpxchg() is implement using) only consult
the L2 cache.  So if a D-cache alias is inserted, the load can
see different data than the atomic, and we'll loop forever because
the atomic compare-and-exchange will never complete successfully.

So to make this all work properly, we need to make sure that the
hash address computed by drm_map_handle() preserves the SHMLBA
relevant bits, and that's what this patch does for _DRM_SHM mappings.

As a historical note, many years ago this bug didn't exist because we
used to just use the low 32-bits of the address as the hash and just
hope for the best.  This preserved the SHMLBA bits properly.  But when
the hashtab code was added to DRM, this was no longer the case.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpu/drm/drm_bufs.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 069544c..445c762 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -34,6 +34,8 @@
  */
 
 #include <linux/vmalloc.h>
+#include <linux/log2.h>
+#include <asm/shmparam.h>
 #include "drmP.h"
 
 resource_size_t drm_get_resource_start(struct drm_device *dev, unsigned int resource)
@@ -83,9 +85,11 @@ static struct drm_map_list *drm_find_matching_map(struct drm_device *dev,
 }
 
 static int drm_map_handle(struct drm_device *dev, struct drm_hash_item *hash,
-			  unsigned long user_token, int hashed_handle)
+			  unsigned long user_token, int hashed_handle, int shm)
 {
-	int use_hashed_handle;
+	int use_hashed_handle, shift;
+	unsigned long add;
+
 #if (BITS_PER_LONG == 64)
 	use_hashed_handle = ((user_token & 0xFFFFFFFF00000000UL) || hashed_handle);
 #elif (BITS_PER_LONG == 32)
@@ -101,9 +105,31 @@ static int drm_map_handle(struct drm_device *dev, struct drm_hash_item *hash,
 		if (ret != -EINVAL)
 			return ret;
 	}
+
+	shift = 0;
+	add = DRM_MAP_HASH_OFFSET >> PAGE_SHIFT;
+	if (shm && (SHMLBA > PAGE_SIZE)) {
+		int bits = ilog2(SHMLBA >> PAGE_SHIFT) + 1;
+
+		/* For shared memory, we have to preserve the SHMLBA
+		 * bits of the eventual vma->vm_pgoff value during
+		 * mmap().  Otherwise we run into cache aliasing problems
+		 * on some platforms.  On these platforms, the pgoff of
+		 * a mmap() request is used to pick a suitable virtual
+		 * address for the mmap() region such that it will not
+		 * cause cache aliasing problems.
+		 *
+		 * Therefore, make sure the SHMLBA relevant bits of the
+		 * hash value we use are equal to those in the original
+		 * kernel virtual address.
+		 */
+		shift = bits;
+		add |= ((user_token >> PAGE_SHIFT) & ((1UL << bits) - 1UL));
+	}
+
 	return drm_ht_just_insert_please(&dev->map_hash, hash,
 					 user_token, 32 - PAGE_SHIFT - 3,
-					 0, DRM_MAP_HASH_OFFSET >> PAGE_SHIFT);
+					 shift, add);
 }
 
 /**
@@ -323,7 +349,8 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 	/* We do it here so that dev->struct_mutex protects the increment */
 	user_token = (map->type == _DRM_SHM) ? (unsigned long)map->handle :
 		map->offset;
-	ret = drm_map_handle(dev, &list->hash, user_token, 0);
+	ret = drm_map_handle(dev, &list->hash, user_token, 0,
+			     (map->type == _DRM_SHM));
 	if (ret) {
 		if (map->type == _DRM_REGISTERS)
 			iounmap(map->handle);
-- 
1.6.1.2.350.g88cc

