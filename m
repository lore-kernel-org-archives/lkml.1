Return-Path: <linux-kernel-owner+w=401wt.eu-S936195AbZLQELg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936195AbZLQELg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936301AbZLQELG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:11:06 -0500
Received: from kroah.org ([198.145.64.141]:56050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935718AbZLQEFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:01 2009
Message-Id: <20091217035700.890391616@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>,
       David Woodhouse <dwmw2@infradead.org>,
       Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [138/151] drm/i915: Avoid NULL dereference with component_only tv_modes
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit d271817baecbccb47da0d9f28c285a0dae8a06b7 upstream.

In commit d2d9f2324, the guard for a valid video mode was removed. This
caused the regression:

  kernel crash during kms graphic boot on Intel GM4500 platform
  https://bugzilla.redhat.com/show_bug.cgi?id=540218

This patches changes the logic slightly not to rely on a coupled
variable, but to just check whether the video_modes is valid before
dereferencing.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>
[ickle: Actually reference the correct bug report]
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_tv.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1213,20 +1213,17 @@ intel_tv_mode_set(struct drm_encoder *en
 		tv_ctl |= TV_TRILEVEL_SYNC;
 	if (tv_mode->pal_burst)
 		tv_ctl |= TV_PAL_BURST;
+
 	scctl1 = 0;
-	/* dda1 implies valid video levels */
-	if (tv_mode->dda1_inc) {
+	if (tv_mode->dda1_inc)
 		scctl1 |= TV_SC_DDA1_EN;
-	}
-
 	if (tv_mode->dda2_inc)
 		scctl1 |= TV_SC_DDA2_EN;
-
 	if (tv_mode->dda3_inc)
 		scctl1 |= TV_SC_DDA3_EN;
-
 	scctl1 |= tv_mode->sc_reset;
-	scctl1 |= video_levels->burst << TV_BURST_LEVEL_SHIFT;
+	if (video_levels)
+		scctl1 |= video_levels->burst << TV_BURST_LEVEL_SHIFT;
 	scctl1 |= tv_mode->dda1_inc << TV_SCDDA1_INC_SHIFT;
 
 	scctl2 = tv_mode->dda2_size << TV_SCDDA2_SIZE_SHIFT |


