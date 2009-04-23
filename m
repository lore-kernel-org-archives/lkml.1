Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZDWHeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZDWHeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZDWH23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:29 -0400
Received: from sous-sol.org ([216.99.217.87]:48341 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755165AbZDWH20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:26 -0400
Message-Id: <20090423072314.355707876@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:42 -0700
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
       Zhenyu Wang <zhenyu.z.wang@intel.com>
Subject: [patch 022/100] drm/i915: fix TV mode setting in property change
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-i915-fix-tv-mode-setting-in-property-change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Zhenyu Wang <zhenyu.z.wang@intel.com>

upstream commit: 7d6ff7851c23740c3813bdf457be638381774b69

Only set TV DAC in property change seems doesn't work, we have to
setup whole crtc pipe which assigned to TV alone.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
[anholt: Note that this should also fix the oops at startup with new 2D]
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/i915/intel_tv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1558,6 +1558,8 @@ intel_tv_set_property(struct drm_connect
 	struct drm_device *dev = connector->dev;
 	struct intel_output *intel_output = to_intel_output(connector);
 	struct intel_tv_priv *tv_priv = intel_output->dev_priv;
+	struct drm_encoder *encoder = &intel_output->enc;
+	struct drm_crtc *crtc = encoder->crtc;
 	int ret = 0;
 	bool changed = false;
 
@@ -1596,8 +1598,9 @@ intel_tv_set_property(struct drm_connect
 		goto out;
 	}
 
-	if (changed)
-		intel_tv_mode_set(&intel_output->enc, NULL, NULL);
+	if (changed && crtc)
+		drm_crtc_helper_set_mode(crtc, &crtc->mode, crtc->x,
+				crtc->y, crtc->fb);
 out:
 	return ret;
 }

