Return-Path: <linux-kernel-owner+w=401wt.eu-S936183AbXHGVDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936183AbXHGVDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965019AbXHGUv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:51:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56382 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965008AbXHGUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:51:54 -0400
Date: Tue, 7 Aug 2007 13:45:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>
Subject: [2.6.22.2 review 34/84] drm/i915: Fix i965 secured batchbuffer
	usage (CVE-2007-3851)
Message-ID: <20070807204543.GI23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-i915-fix-i965-secured-batchbuffer-usage.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

This 965G and above chipsets moved the batch buffer non-secure bits to
another place. This means that previous drm's allowed in-secure batchbuffers
to be submitted to the hardware from non-privileged users who are logged
into X and and have access to direct rendering.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/drm/i915_dma.c |   14 +++++++++++---
 drivers/char/drm/i915_drv.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/char/drm/i915_dma.c
+++ b/drivers/char/drm/i915_dma.c
@@ -184,6 +184,8 @@ static int i915_initialize(drm_device_t 
 	 * private backbuffer/depthbuffer usage.
 	 */
 	dev_priv->use_mi_batchbuffer_start = 0;
+	if (IS_I965G(dev)) /* 965 doesn't support older method */
+		dev_priv->use_mi_batchbuffer_start = 1;
 
 	/* Allow hardware batchbuffers unless told otherwise.
 	 */
@@ -517,8 +519,13 @@ static int i915_dispatch_batchbuffer(drm
 
 		if (dev_priv->use_mi_batchbuffer_start) {
 			BEGIN_LP_RING(2);
-			OUT_RING(MI_BATCH_BUFFER_START | (2 << 6));
-			OUT_RING(batch->start | MI_BATCH_NON_SECURE);
+			if (IS_I965G(dev)) {
+				OUT_RING(MI_BATCH_BUFFER_START | (2 << 6) | MI_BATCH_NON_SECURE_I965);
+				OUT_RING(batch->start);
+			} else {
+				OUT_RING(MI_BATCH_BUFFER_START | (2 << 6));
+				OUT_RING(batch->start | MI_BATCH_NON_SECURE);
+			}
 			ADVANCE_LP_RING();
 		} else {
 			BEGIN_LP_RING(4);
@@ -735,7 +742,8 @@ static int i915_setparam(DRM_IOCTL_ARGS)
 
 	switch (param.param) {
 	case I915_SETPARAM_USE_MI_BATCHBUFFER_START:
-		dev_priv->use_mi_batchbuffer_start = param.value;
+		if (!IS_I965G(dev))
+			dev_priv->use_mi_batchbuffer_start = param.value;
 		break;
 	case I915_SETPARAM_TEX_LRU_LOG_GRANULARITY:
 		dev_priv->tex_lru_log_granularity = param.value;
--- a/drivers/char/drm/i915_drv.h
+++ b/drivers/char/drm/i915_drv.h
@@ -282,6 +282,7 @@ extern int i915_wait_ring(drm_device_t *
 #define MI_BATCH_BUFFER_START 	(0x31<<23)
 #define MI_BATCH_BUFFER_END 	(0xA<<23)
 #define MI_BATCH_NON_SECURE	(1)
+#define MI_BATCH_NON_SECURE_I965 (1<<8)
 
 #define MI_WAIT_FOR_EVENT       ((0x3<<23))
 #define MI_WAIT_FOR_PLANE_A_FLIP      (1<<2)

-- 
