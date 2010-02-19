Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0BSRTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:19:07 -0500
Received: from kroah.org ([198.145.64.141]:57374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab0BSRAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:10 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:32 2010
Message-Id: <20100219163232.671340280@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [11/93] drm/i915: enable self-refresh on 965
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@jbarnes-x200.(none)>

commit 1dc7546d1a73664e5d117715b214bea9cae5951c upstream.

Need to calculate the SR watermark and enable it.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2556,15 +2556,39 @@ static void g4x_update_wm(struct drm_dev
 		   (cursor_sr << DSPFW_CURSOR_SR_SHIFT));
 }
 
-static void i965_update_wm(struct drm_device *dev, int unused, int unused2,
-			   int unused3, int unused4)
+static void i965_update_wm(struct drm_device *dev, int planea_clock,
+			   int planeb_clock, int sr_hdisplay, int pixel_size)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long line_time_us;
+	int sr_clock, sr_entries, srwm = 1;
 
-	DRM_DEBUG("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 8\n");
+	/* Calc sr entries for one plane configs */
+	if (sr_hdisplay && (!planea_clock || !planeb_clock)) {
+		/* self-refresh has much higher latency */
+		const static int sr_latency_ns = 12000;
+
+		sr_clock = planea_clock ? planea_clock : planeb_clock;
+		line_time_us = ((sr_hdisplay * 1000) / sr_clock);
+
+		/* Use ns/us then divide to preserve precision */
+		sr_entries = (((sr_latency_ns / line_time_us) + 1) *
+			      pixel_size * sr_hdisplay) / 1000;
+		sr_entries = roundup(sr_entries / I915_FIFO_LINE_SIZE, 1);
+		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
+		srwm = I945_FIFO_SIZE - sr_entries;
+		if (srwm < 0)
+			srwm = 1;
+		srwm &= 0x3f;
+		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	}
+
+	DRM_DEBUG_KMS("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n",
+		      srwm);
 
 	/* 965 has limitations... */
-	I915_WRITE(DSPFW1, (8 << 16) | (8 << 8) | (8 << 0));
+	I915_WRITE(DSPFW1, (srwm << DSPFW_SR_SHIFT) | (8 << 16) | (8 << 8) |
+		   (8 << 0));
 	I915_WRITE(DSPFW2, (8 << 8) | (8 << 0));
 }
 


