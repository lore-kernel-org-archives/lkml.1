Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413Ab0ANWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0ANWhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533Ab0ANWhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:37:47 -0500
Received: from kroah.org ([198.145.64.141]:60556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0ANW2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:32 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/52] drm/i915: Select the correct BPC for LVDS on Ironlake
Date: Thu, 14 Jan 2010 14:26:57 -0800
Message-Id: <1263508051-7868-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-17-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

commit e5a95eb778690bc864eb330202d2c1b974caaeb4 upstream.

Select the correct BPC for LVDS on Ironlake. If it is 18-bit LVDS panel,
the BPC will be 6. When it is 24-bit LVDS panel, the BPC will 8.
At the same time the BPC will be 8 when the output device is CRT/HDMI/DP.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_display.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d02016d..406b532 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2901,6 +2901,18 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
 
 		/* determine panel color depth */
 		temp = I915_READ(pipeconf_reg);
+		temp &= ~PIPE_BPC_MASK;
+		if (is_lvds) {
+			int lvds_reg = I915_READ(PCH_LVDS);
+			/* the BPC will be 6 if it is 18-bit LVDS panel */
+			if ((lvds_reg & LVDS_A3_POWER_MASK) == LVDS_A3_POWER_UP)
+				temp |= PIPE_8BPC;
+			else
+				temp |= PIPE_6BPC;
+		} else
+			temp |= PIPE_8BPC;
+		I915_WRITE(pipeconf_reg, temp);
+		I915_READ(pipeconf_reg);
 
 		switch (temp & PIPE_BPC_MASK) {
 		case PIPE_8BPC:
-- 
1.6.6

