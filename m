Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZDWH1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZDWH1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZDWH07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:26:59 -0400
Received: from sous-sol.org ([216.99.217.87]:48057 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751146AbZDWH06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:26:58 -0400
Message-Id: <20090423072229.534145635@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:35 -0700
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
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>
Subject: [patch 015/100] drm/i915: Change DCC tiling detection case to cover only mobile parts.
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-i915-change-dcc-tiling-detection-case-to-cover-only-mobile-parts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Anholt <eric@anholt.net>

upstream commit: 568d9a8f6d4bf81e0672c74573dc02981d31e3ea

Later spec investigation has revealed that every 9xx mobile part has
had this register in this format.  Also, no non-mobile parts have been shown
to have this register.  So make all mobile use the same code, and all
non-mobile use the hack 965 detection.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/i915/i915_gem_tiling.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -96,16 +96,16 @@ i915_gem_detect_bit_6_swizzle(struct drm
 		 */
 		swizzle_x = I915_BIT_6_SWIZZLE_NONE;
 		swizzle_y = I915_BIT_6_SWIZZLE_NONE;
-	} else if ((!IS_I965G(dev) && !IS_G33(dev)) || IS_I965GM(dev) ||
-		   IS_GM45(dev)) {
+	} else if (IS_MOBILE(dev)) {
 		uint32_t dcc;
 
-		/* On 915-945 and GM965, channel interleave by the CPU is
-		 * determined by DCC.  The CPU will alternate based on bit 6
-		 * in interleaved mode, and the GPU will then also alternate
-		 * on bit 6, 9, and 10 for X, but the CPU may also optionally
-		 * alternate based on bit 17 (XOR not disabled and XOR
-		 * bit == 17).
+		/* On mobile 9xx chipsets, channel interleave by the CPU is
+		 * determined by DCC.  For single-channel, neither the CPU
+		 * nor the GPU do swizzling.  For dual channel interleaved,
+		 * the GPU's interleave is bit 9 and 10 for X tiled, and bit
+		 * 9 for Y tiled.  The CPU's interleave is independent, and
+		 * can be based on either bit 11 (haven't seen this yet) or
+		 * bit 17 (common).
 		 */
 		dcc = I915_READ(DCC);
 		switch (dcc & DCC_ADDRESSING_MODE_MASK) {
@@ -115,19 +115,18 @@ i915_gem_detect_bit_6_swizzle(struct drm
 			swizzle_y = I915_BIT_6_SWIZZLE_NONE;
 			break;
 		case DCC_ADDRESSING_MODE_DUAL_CHANNEL_INTERLEAVED:
-			if (IS_I915G(dev) || IS_I915GM(dev) ||
-			    dcc & DCC_CHANNEL_XOR_DISABLE) {
+			if (dcc & DCC_CHANNEL_XOR_DISABLE) {
+				/* This is the base swizzling by the GPU for
+				 * tiled buffers.
+				 */
 				swizzle_x = I915_BIT_6_SWIZZLE_9_10;
 				swizzle_y = I915_BIT_6_SWIZZLE_9;
-			} else if ((IS_I965GM(dev) || IS_GM45(dev)) &&
-				   (dcc & DCC_CHANNEL_XOR_BIT_17) == 0) {
-				/* GM965/GM45 does either bit 11 or bit 17
-				 * swizzling.
-				 */
+			} else if ((dcc & DCC_CHANNEL_XOR_BIT_17) == 0) {
+				/* Bit 11 swizzling by the CPU in addition. */
 				swizzle_x = I915_BIT_6_SWIZZLE_9_10_11;
 				swizzle_y = I915_BIT_6_SWIZZLE_9_11;
 			} else {
-				/* Bit 17 or perhaps other swizzling */
+				/* Bit 17 swizzling by the CPU in addition. */
 				swizzle_x = I915_BIT_6_SWIZZLE_UNKNOWN;
 				swizzle_y = I915_BIT_6_SWIZZLE_UNKNOWN;
 			}

