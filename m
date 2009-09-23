Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZIWQBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZIWQBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZIWQBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:01:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZIWQBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:01:31 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH 2/4] drm/edid: Ignore bad standard timings.
Date: Wed, 23 Sep 2009 12:01:30 -0400
Message-Id: <1253721692-26165-2-git-send-email-ajax@redhat.com>
In-Reply-To: <1253721692-26165-1-git-send-email-ajax@redhat.com>
References: <1253721692-26165-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/gpu/drm/drm_edid.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 3326987..dd35dc1 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -502,6 +502,19 @@ static struct drm_display_mode *drm_find_dmt(struct drm_device *dev,
 	}
 	return mode;
 }
+
+/*
+ * 0 is reserved.  The spec says 0x01 fill for unused timings.  Some old
+ * monitors fill with ascii space (0x20) instead.
+ */
+static int
+bad_std_timing(u8 a, u8 b)
+{
+	return (a == 0x00 && b == 0x00) ||
+	       (a == 0x01 && b == 0x01) ||
+	       (a == 0x20 && b == 0x20);
+}
+
 /**
  * drm_mode_std - convert standard mode info (width, height, refresh) into mode
  * @t: standard timing params
@@ -525,6 +538,9 @@ struct drm_display_mode *drm_mode_std(struct drm_device *dev,
 	unsigned vfreq = (t->vfreq_aspect & EDID_TIMING_VFREQ_MASK)
 		>> EDID_TIMING_VFREQ_SHIFT;
 
+	if (bad_std_timing(t->hsize, t->vfreq_aspect))
+		return NULL;
+
 	/* According to the EDID spec, the hdisplay = hsize * 8 + 248 */
 	hsize = t->hsize * 8 + 248;
 	/* vrefresh_rate = vfreq + 60 */
-- 
1.6.4.2

