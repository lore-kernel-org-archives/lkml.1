Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZDWHfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZDWHfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZDWH2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:33 -0400
Received: from sous-sol.org ([216.99.217.87]:48350 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754157AbZDWH2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:30 -0400
Message-Id: <20090423072308.747289590@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:41 -0700
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
Subject: [patch 021/100] drm/i915: only set TV mode when any property changed
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-i915-only-set-tv-mode-when-any-property-changed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Zhenyu Wang <zhenyu.z.wang@intel.com>

upstream commit: ebcc8f2eade76946dbb5d5c545b91f8157051aa8

If there's no real property change, don't need to set TV mode again.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
[anholt: checkpatch.pl fix]
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/i915/intel_tv.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1559,32 +1559,45 @@ intel_tv_set_property(struct drm_connect
 	struct intel_output *intel_output = to_intel_output(connector);
 	struct intel_tv_priv *tv_priv = intel_output->dev_priv;
 	int ret = 0;
+	bool changed = false;
 
 	ret = drm_connector_property_set_value(connector, property, val);
 	if (ret < 0)
 		goto out;
 
-	if (property == dev->mode_config.tv_left_margin_property)
+	if (property == dev->mode_config.tv_left_margin_property &&
+		tv_priv->margin[TV_MARGIN_LEFT] != val) {
 		tv_priv->margin[TV_MARGIN_LEFT] = val;
-	else if (property == dev->mode_config.tv_right_margin_property)
+		changed = true;
+	} else if (property == dev->mode_config.tv_right_margin_property &&
+		tv_priv->margin[TV_MARGIN_RIGHT] != val) {
 		tv_priv->margin[TV_MARGIN_RIGHT] = val;
-	else if (property == dev->mode_config.tv_top_margin_property)
+		changed = true;
+	} else if (property == dev->mode_config.tv_top_margin_property &&
+		tv_priv->margin[TV_MARGIN_TOP] != val) {
 		tv_priv->margin[TV_MARGIN_TOP] = val;
-	else if (property == dev->mode_config.tv_bottom_margin_property)
+		changed = true;
+	} else if (property == dev->mode_config.tv_bottom_margin_property &&
+		tv_priv->margin[TV_MARGIN_BOTTOM] != val) {
 		tv_priv->margin[TV_MARGIN_BOTTOM] = val;
-	else if (property == dev->mode_config.tv_mode_property) {
+		changed = true;
+	} else if (property == dev->mode_config.tv_mode_property) {
 		if (val >= NUM_TV_MODES) {
 			ret = -EINVAL;
 			goto out;
 		}
+		if (!strcmp(tv_priv->tv_format, tv_modes[val].name))
+			goto out;
+
 		tv_priv->tv_format = tv_modes[val].name;
-		intel_tv_mode_set(&intel_output->enc, NULL, NULL);
+		changed = true;
 	} else {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	intel_tv_mode_set(&intel_output->enc, NULL, NULL);
+	if (changed)
+		intel_tv_mode_set(&intel_output->enc, NULL, NULL);
 out:
 	return ret;
 }

