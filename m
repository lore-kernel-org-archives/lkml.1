Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZLGANi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZLGANi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbZLGANh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:37 -0500
Received: from kroah.org ([198.145.64.141]:34542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbZLGAN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:53 2009
Message-Id: <20091207000652.847365541@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nanhai Zou <nanhai.zou@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [071/119] drm/i915: Fix IRQ stall issue on Ironlake
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-irq-stall-issue-on-ironlake.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nanhai Zou <nanhai.zou@intel.com>

commit 2d109a845dd3074885db726892c629ab73dd0ed8 upstream.

The master irq control in DE must be disabled before irq handling,
and enable after the process. This fixes the irq stall issue on
Ironlake.

Signed-off-by: Nanhai Zou <nanhai.zou@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -253,10 +253,15 @@ irqreturn_t igdng_irq_handler(struct drm
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 	int ret = IRQ_NONE;
-	u32 de_iir, gt_iir;
+	u32 de_iir, gt_iir, de_ier;
 	u32 new_de_iir, new_gt_iir;
 	struct drm_i915_master_private *master_priv;
 
+	/* disable master interrupt before clearing iir  */
+	de_ier = I915_READ(DEIER);
+	I915_WRITE(DEIER, de_ier & ~DE_MASTER_IRQ_CONTROL);
+	(void)I915_READ(DEIER);
+
 	de_iir = I915_READ(DEIIR);
 	gt_iir = I915_READ(GTIIR);
 
@@ -287,6 +292,9 @@ irqreturn_t igdng_irq_handler(struct drm
 		gt_iir = new_gt_iir;
 	}
 
+	I915_WRITE(DEIER, de_ier);
+	(void)I915_READ(DEIER);
+
 	return ret;
 }
 


