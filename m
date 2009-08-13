Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZHMULx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZHMULx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZHMT72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:28 -0400
Received: from kroah.org ([198.145.64.141]:41688 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbZHMT7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:27 2009
Message-Id: <20090813195127.336139759@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Gr=C3=A9goire=20Henry?= <henry@pps.jussieu.fr>,
       Eric Anholt <eric@anholt.net>
Subject: [patch 19/74] drm/i915: initialize fence registers to zero when loading GEM
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=0006-drm-i915-initialize-fence-registers-to-zero-when-loa.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Grégoire Henry <henry@pps.jussieu.fr>

(cherry picked from commit b5aa8a0fc132dd512c33e7c2621d075e3b77a65e)

Unitialized fence register could leads to corrupted display. Problem
encountered on MacBooks (revision 1 and 2), directly booting from EFI
or through BIOS emulation.

(bug #21710 at freedestop.org)

Signed-off-by: Grégoire Henry <henry@pps.jussieu.fr>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/i915_gem.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4154,6 +4154,7 @@ i915_gem_lastclose(struct drm_device *de
 void
 i915_gem_load(struct drm_device *dev)
 {
+	int i;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
 	spin_lock_init(&dev_priv->mm.active_list_lock);
@@ -4173,6 +4174,18 @@ i915_gem_load(struct drm_device *dev)
 	else
 		dev_priv->num_fence_regs = 8;
 
+	/* Initialize fence registers to zero */
+	if (IS_I965G(dev)) {
+		for (i = 0; i < 16; i++)
+			I915_WRITE64(FENCE_REG_965_0 + (i * 8), 0);
+	} else {
+		for (i = 0; i < 8; i++)
+			I915_WRITE(FENCE_REG_830_0 + (i * 4), 0);
+		if (IS_I945G(dev) || IS_I945GM(dev) || IS_G33(dev))
+			for (i = 0; i < 8; i++)
+				I915_WRITE(FENCE_REG_945_8 + (i * 4), 0);
+	}
+
 	i915_gem_detect_bit_6_swizzle(dev);
 }
 


