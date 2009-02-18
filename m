Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZBRJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZBRJfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZBRJfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:35:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45317
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbZBRJfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:35:37 -0500
Date: Wed, 18 Feb 2009 01:35:21 -0800 (PST)
Message-Id: <20090218.013521.97380943.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drm: Only use DRM_IOCTL_UPDATE_DRAW compat wrapper for
 compat X86.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ben, I'm pretty sure you're hitting this too on powerpc.  Every time a
32-bit process tries to upload cliprects it's going to fail with
-EFAULT or similar.

Nothing in userspace checks the return value for errors, etc. :-/

The only reason I caught this is because I have a debugging check on
sparc64 that makes sure that faults on kernel accesses to 32-bit
userspace never have any of the high 32-bits set.

--------------------

drm: Only use DRM_IOCTL_UPDATE_DRAW compat wrapper for compat X86.

Only X86 32-bit uses a different alignment for "unsigned long long"
than it's 64-bit counterpart.

Therefore this compat translation is only correct, and only needed,
when either CONFIG_X86 or CONFIG_IA64.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpu/drm/drm_ioc32.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 920b72f..282d9fd 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -954,6 +954,7 @@ static int compat_drm_sg_free(struct file *file, unsigned int cmd,
 			 DRM_IOCTL_SG_FREE, (unsigned long)request);
 }
 
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
 typedef struct drm_update_draw32 {
 	drm_drawable_t handle;
 	unsigned int type;
@@ -984,6 +985,7 @@ static int compat_drm_update_draw(struct file *file, unsigned int cmd,
 			DRM_IOCTL_UPDATE_DRAW, (unsigned long)request);
 	return err;
 }
+#endif
 
 struct drm_wait_vblank_request32 {
 	enum drm_vblank_seq_type type;
@@ -1066,7 +1068,9 @@ drm_ioctl_compat_t *drm_compat_ioctls[] = {
 #endif
 	[DRM_IOCTL_NR(DRM_IOCTL_SG_ALLOC32)] = compat_drm_sg_alloc,
 	[DRM_IOCTL_NR(DRM_IOCTL_SG_FREE32)] = compat_drm_sg_free,
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
 	[DRM_IOCTL_NR(DRM_IOCTL_UPDATE_DRAW32)] = compat_drm_update_draw,
+#endif
 	[DRM_IOCTL_NR(DRM_IOCTL_WAIT_VBLANK32)] = compat_drm_wait_vblank,
 };
 
-- 
1.6.1.2.350.g88cc

