Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673Ab0AUEaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0AUEaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401Ab0AUE31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:29:27 -0500
Received: from kroah.org ([198.145.64.141]:60078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0AUEWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:33 2010
Message-Id: <20100121041833.110428612@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zou Nan hai <Nanhai.zou@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [05/30] drm/i915: remove loop in Ironlake interrupt handler
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zou Nan hai <Nanhai.zou@intel.com>

commit c7c85101afd0cb8ce497456d12ee1cad4aad152f upstream.

On Ironlake, there is an interrupt master control bit. With the bit
disabled before clearing IIR, we do not need to handle extra interrupt
in a loop. This patch removes the loop in Ironlake interrupt handler.
It fixed irq lost issue on some Ironlake platforms.

Signed-off-by: Zou Nan hai <Nanhai.zou@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/gpu/drm/i915/i915_irq.c |   43 ++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -255,7 +255,6 @@ irqreturn_t igdng_irq_handler(struct drm
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 	int ret = IRQ_NONE;
 	u32 de_iir, gt_iir, de_ier;
-	u32 new_de_iir, new_gt_iir;
 	struct drm_i915_master_private *master_priv;
 
 	/* disable master interrupt before clearing iir  */
@@ -266,35 +265,29 @@ irqreturn_t igdng_irq_handler(struct drm
 	de_iir = I915_READ(DEIIR);
 	gt_iir = I915_READ(GTIIR);
 
-	for (;;) {
-		if (de_iir == 0 && gt_iir == 0)
-			break;
-
-		ret = IRQ_HANDLED;
-
-		I915_WRITE(DEIIR, de_iir);
-		new_de_iir = I915_READ(DEIIR);
-		I915_WRITE(GTIIR, gt_iir);
-		new_gt_iir = I915_READ(GTIIR);
+	if (de_iir == 0 && gt_iir == 0)
+		goto done;
 
-		if (dev->primary->master) {
-			master_priv = dev->primary->master->driver_priv;
-			if (master_priv->sarea_priv)
-				master_priv->sarea_priv->last_dispatch =
-					READ_BREADCRUMB(dev_priv);
-		}
+	ret = IRQ_HANDLED;
 
-		if (gt_iir & GT_USER_INTERRUPT) {
-			u32 seqno = i915_get_gem_seqno(dev);
-			dev_priv->mm.irq_gem_seqno = seqno;
-			trace_i915_gem_request_complete(dev, seqno);
-			DRM_WAKEUP(&dev_priv->irq_queue);
-		}
+	if (dev->primary->master) {
+		master_priv = dev->primary->master->driver_priv;
+		if (master_priv->sarea_priv)
+			master_priv->sarea_priv->last_dispatch =
+				READ_BREADCRUMB(dev_priv);
+	}
 
-		de_iir = new_de_iir;
-		gt_iir = new_gt_iir;
+	if (gt_iir & GT_USER_INTERRUPT) {
+		u32 seqno = i915_get_gem_seqno(dev);
+		dev_priv->mm.irq_gem_seqno = seqno;
+		trace_i915_gem_request_complete(dev, seqno);
+		DRM_WAKEUP(&dev_priv->irq_queue);
 	}
 
+	I915_WRITE(GTIIR, gt_iir);
+	I915_WRITE(DEIIR, de_iir);
+
+done:
 	I915_WRITE(DEIER, de_ier);
 	(void)I915_READ(DEIER);
 


