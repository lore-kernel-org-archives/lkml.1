Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700Ab0A3Uv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0A3Uv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596Ab0A3UvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:51:25 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:53614 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0A3UvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:51:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=f59MsECACOGk2Z2kPESAiX60zEB7XIIWQN6sEl0/SBCaY1XiHRXigSn/0+LSMEiex0
         rRwtR9w6N1sQLq6oMVVylK5oKP0BDZa0xq57dHDME090AcJOfVJIWE3/wfOYEuUofnuz
         69s46RQLIusk2/mfWzHE3FNddZZg6rhiO7vrc=
From: John Kacur <jkacur@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Dave Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] radeon_agp: Move the check of the aper_size after drm_acp_acquire and drm_agp_info
Date: Sat, 30 Jan 2010 21:51:10 +0100
Message-Id: <1264884670-28211-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264884670-28211-1-git-send-email-jkacur@redhat.com>
References: <1264884670-28211-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First call drm_agp_acquire to check if agp has been acquired.
Second call drm_agp_info to fill in the info data struct, including aper_size.
Finally do the check to see if the aper_size makes sense.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_agp.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
index 1c4e523..ad168ee 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -133,13 +133,6 @@ int radeon_agp_init(struct radeon_device *rdev)
 	bool is_v3;
 	int ret;
 
-	if (rdev->ddev->agp->agp_info.aper_size < 32) {
-		dev_warn(rdev->dev, "AGP aperture to small (%zuM) "
-			"need at least 32M, disabling AGP\n",
-			rdev->ddev->agp->agp_info.aper_size);
-		return -EINVAL;
-	}
-
 	/* Acquire AGP. */
 	if (!rdev->ddev->agp->acquired) {
 		ret = drm_agp_acquire(rdev->ddev);
@@ -154,6 +147,14 @@ int radeon_agp_init(struct radeon_device *rdev)
 		DRM_ERROR("Unable to get AGP info: %d\n", ret);
 		return ret;
 	}
+
+	if (rdev->ddev->agp->agp_info.aper_size < 32) {
+		dev_warn(rdev->dev, "AGP aperture to small (%zuM) "
+			"need at least 32M, disabling AGP\n",
+			rdev->ddev->agp->agp_info.aper_size);
+		return -EINVAL;
+	}
+
 	mode.mode = info.mode;
 	agp_status = (RREG32(RADEON_AGP_STATUS) | RADEON_AGPv3_MODE) & mode.mode;
 	is_v3 = !!(agp_status & RADEON_AGPv3_MODE);
-- 
1.6.0.6

