Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbZDWH14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbZDWH14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZDWH1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:04 -0400
Received: from sous-sol.org ([216.99.217.87]:48074 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754157AbZDWH1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:01 -0400
Message-Id: <20090423072237.466772501@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:36 -0700
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
       =?UTF-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
Subject: [patch 016/100] drm/i915: Read the right SDVO register when detecting SVDO/HDMI.
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-i915-read-the-right-sdvo-register-when-detecting-svdo-hdmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Kristian Høgsberg <krh@redhat.com>

upstream commit: 13520b051e8888dd3af9bda639d83e7df76613d1

This fixes incorrect detection of the second SDVO/HDMI output on G4X, and
extra boot time on pre-G4X.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1474,13 +1474,21 @@ static void intel_setup_outputs(struct d
 
 	if (IS_I9XX(dev)) {
 		int found;
+		u32 reg;
 
 		if (I915_READ(SDVOB) & SDVO_DETECTED) {
 			found = intel_sdvo_init(dev, SDVOB);
 			if (!found && SUPPORTS_INTEGRATED_HDMI(dev))
 				intel_hdmi_init(dev, SDVOB);
 		}
-		if (!IS_G4X(dev) || (I915_READ(SDVOB) & SDVO_DETECTED)) {
+
+		/* Before G4X SDVOC doesn't have its own detect register */
+		if (IS_G4X(dev))
+			reg = SDVOC;
+		else
+			reg = SDVOB;
+
+		if (I915_READ(reg) & SDVO_DETECTED) {
 			found = intel_sdvo_init(dev, SDVOC);
 			if (!found && SUPPORTS_INTEGRATED_HDMI(dev))
 				intel_hdmi_init(dev, SDVOC);

