Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0BOFJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 00:09:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35246 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab0BOFJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 00:09:44 -0500
Date: Mon, 15 Feb 2010 05:09:29 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1002150508210.25675@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two ttm regression fixes from Thomas, and one alpha unaligned issue in the
atom parser for radeon KMS.

The following changes since commit 724e6d3fe8003c3f60bf404bf22e4e331327c596:
  Linus Torvalds (1):
        Linux 2.6.33-rc8

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Matt Turner (1):
      drm/radeon/kms/atom: use get_unaligned_le32() for ctx->ps

Thomas Hellstrom (2):
      drm: Fix a bug in the range manager.
      drm/ttm: Fix a bug occuring when validating a buffer object in a range.

 drivers/gpu/drm/drm_mm.c      |    3 ++-
 drivers/gpu/drm/radeon/atom.c |    5 ++++-
 drivers/gpu/drm/ttm/ttm_bo.c  |    6 ++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index cdec329..2ac074c 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -405,7 +405,8 @@ struct drm_mm_node *drm_mm_search_free_in_range(const struct drm_mm *mm,
 				wasted += alignment - tmp;
 		}
 
-		if (entry->size >= size + wasted) {
+		if (entry->size >= size + wasted &&
+		    (entry->start + wasted + size) <= end) {
 			if (!best_match)
 				return entry;
 			if (entry->size < best_size) {
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index e3b4456..2a3df55 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -24,6 +24,7 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <asm/unaligned.h>
 
 #define ATOM_DEBUG
 
@@ -212,7 +213,9 @@ static uint32_t atom_get_src_int(atom_exec_context *ctx, uint8_t attr,
 	case ATOM_ARG_PS:
 		idx = U8(*ptr);
 		(*ptr)++;
-		val = le32_to_cpu(ctx->ps[idx]);
+		/* get_unaligned_le32 avoids unaligned accesses from atombios
+		 * tables, noticed on a DEC Alpha. */
+		val = get_unaligned_le32((u32 *)&ctx->ps[idx]);
 		if (print)
 			DEBUG("PS[0x%02X,0x%04X]", idx, val);
 		break;
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 1a3e909..c7320ce 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1020,6 +1020,12 @@ static int ttm_bo_mem_compat(struct ttm_placement *placement,
 			     struct ttm_mem_reg *mem)
 {
 	int i;
+	struct drm_mm_node *node = mem->mm_node;
+
+	if (node && placement->lpfn != 0 &&
+	    (node->start < placement->fpfn ||
+	     node->start + node->size > placement->lpfn))
+		return -1;
 
 	for (i = 0; i < placement->num_placement; i++) {
 		if ((placement->placement[i] & mem->placement &
