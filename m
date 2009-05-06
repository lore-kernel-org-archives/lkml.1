Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbZEFWFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbZEFWFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761441AbZEFVyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:44 -0400
Received: from kroah.org ([198.145.64.141]:57151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761482AbZEFVyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:59 2009
Message-Id: <20090506214758.893758313@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:54 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>
Subject: [patch 26/58] drm/i915: allow tiled front buffers on 965+
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-allow-tiled-front-buffers-on-965.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit f544847fbaf099278343f875987a983f2b913134 upstream.

This patch corrects a pretty big oversight in the KMS code for 965+
chips.  The current code is missing tiled surface register programming,
so userland can allocate a tiled surface and use it for mode setting,
resulting in corruption.  This patch fixes that, allowing for tiled
front buffers on 965+.

Cc: stable@kernel.org
Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    9 +++++++++
 2 files changed, 10 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1431,6 +1431,7 @@
 #define   DISPPLANE_NO_LINE_DOUBLE		0
 #define   DISPPLANE_STEREO_POLARITY_FIRST	0
 #define   DISPPLANE_STEREO_POLARITY_SECOND	(1<<18)
+#define   DISPPLANE_TILED			(1<<10)
 #define DSPAADDR		0x70184
 #define DSPASTRIDE		0x70188
 #define DSPAPOS			0x7018C /* reserved */
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -338,6 +338,7 @@ intel_pipe_set_base(struct drm_crtc *crt
 	int dspbase = (pipe == 0 ? DSPAADDR : DSPBADDR);
 	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
 	int dspstride = (pipe == 0) ? DSPASTRIDE : DSPBSTRIDE;
+	int dsptileoff = (pipe == 0 ? DSPATILEOFF : DSPBTILEOFF);
 	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
 	u32 dspcntr, alignment;
 	int ret;
@@ -414,6 +415,13 @@ intel_pipe_set_base(struct drm_crtc *crt
 		mutex_unlock(&dev->struct_mutex);
 		return -EINVAL;
 	}
+	if (IS_I965G(dev)) {
+		if (obj_priv->tiling_mode != I915_TILING_NONE)
+			dspcntr |= DISPPLANE_TILED;
+		else
+			dspcntr &= ~DISPPLANE_TILED;
+	}
+
 	I915_WRITE(dspcntr_reg, dspcntr);
 
 	Start = obj_priv->gtt_offset;
@@ -426,6 +434,7 @@ intel_pipe_set_base(struct drm_crtc *crt
 		I915_READ(dspbase);
 		I915_WRITE(dspsurf, Start);
 		I915_READ(dspsurf);
+		I915_WRITE(dsptileoff, (y << 16) | x);
 	} else {
 		I915_WRITE(dspbase, Start + Offset);
 		I915_READ(dspbase);


