Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZDWHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZDWHf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZDWH2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:32 -0400
Received: from sous-sol.org ([216.99.217.87]:48346 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755698AbZDWH23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:29 -0400
Message-Id: <20090423072248.318124884@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: [patch 018/100] drm/i915: Check for dev->primary->master before dereference.
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-i915-check-for-dev-primary-master-before-dereference.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

upstream commit: 98787c057fdefdce6230ff46f2c1105835005a4c

I've hit the occasional oops inside i915_wait_ring() with an indication of
a NULL derefence of dev->primary->master.  Adding a NULL check is
consistent with the other potential users of dev->primary->master.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/i915/i915_dma.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -41,7 +41,6 @@
 int i915_wait_ring(struct drm_device * dev, int n, const char *caller)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 	drm_i915_ring_buffer_t *ring = &(dev_priv->ring);
 	u32 acthd_reg = IS_I965G(dev) ? ACTHD_I965 : ACTHD;
 	u32 last_acthd = I915_READ(acthd_reg);
@@ -58,8 +57,12 @@ int i915_wait_ring(struct drm_device * d
 		if (ring->space >= n)
 			return 0;
 
-		if (master_priv->sarea_priv)
-			master_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
+		if (dev->primary->master) {
+			struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
+			if (master_priv->sarea_priv)
+				master_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
+		}
+
 
 		if (ring->head != last_head)
 			i = 0;

