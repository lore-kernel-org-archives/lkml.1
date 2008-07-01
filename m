Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYGATdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYGATdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYGATc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:32:57 -0400
Received: from outbound-mail-102.bluehost.com ([69.89.22.12]:57262 "HELO
	outbound-mail-102.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754027AbYGATc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:32:56 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] DRM/i915: only use tiled blits on 965+
Date: Tue, 1 Jul 2008 12:32:52 -0700
User-Agent: KMail/1.9.9
Cc: Dave Airlie <airlied@linux.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011232.53124.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When scheduled swaps occur, we need to blit between front & back buffers.  If
the buffers are tiled, we need to set the appropriate XY_SRC_COPY tile bit,
but only on 965 chips, since it will cause corruption on pre-965 (e.g. 945).

Bug reported by and fix tested by Tomas Janousek <tomi@nomi.cz>.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/char/drm/i915_irq.c b/drivers/char/drm/i915_irq.c
index f7f16e7..df03611 100644
--- a/drivers/char/drm/i915_irq.c
+++ b/drivers/char/drm/i915_irq.c
@@ -62,11 +62,11 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 	u32 ropcpp = (0xcc << 16) | ((cpp - 1) << 24);
 	RING_LOCALS;
 
-	if (sarea_priv->front_tiled) {
+	if (IS_I965G(dev) && sarea_priv->front_tiled) {
 		cmd |= XY_SRC_COPY_BLT_DST_TILED;
 		dst_pitch >>= 2;
 	}
-	if (sarea_priv->back_tiled) {
+	if (IS_I965G(dev) && sarea_priv->back_tiled) {
 		cmd |= XY_SRC_COPY_BLT_SRC_TILED;
 		src_pitch >>= 2;
 	}
