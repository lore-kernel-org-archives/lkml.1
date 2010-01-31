Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015Ab0AaTiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0AaTiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 14:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324Ab0AaTiU
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 14:38:20 -0500
Received: from mail-qy0-f188.google.com ([209.85.221.188]:52127 "EHLO
	mail-qy0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0AaTiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 14:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HEpVz8msxbtdSx3m0bj5/szPMhFNntoro7vBOZc70K82S8dfaA2dlhKf6rJxtd4fNO
         nM5sL7MD59yxJDSIa1AWPw7wA+6VckpAhPH7UVLod7D20cBSJeavgQmlUb4yL1W1uU+y
         5+EombKkfgbTDsZRd+sHtOvumuL4VpEdf9t+M=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dan Nicholson <dbn.lists@gmail.com>, Dave Airlie <airlied@linux.ie>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jerome Glisse <jglisse@redhat.com>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/2] radeon_agp: Move the check of the aper_size after drm_acp_acquire and drm_agp_info
Date: Sun, 31 Jan 2010 20:38:03 +0100
Message-Id: <1264966683-17992-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264966683-17992-1-git-send-email-jkacur@redhat.com>
References: <1264966683-17992-1-git-send-email-jkacur@redhat.com>
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
index f58c5f4..b634d98 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -133,13 +133,6 @@ int radeon_agp_init(struct radeon_device *rdev)
 	bool is_v3;
 	int ret;
 
-	if (rdev->ddev->agp->agp_info.aper_size < 32) {
-		dev_warn(rdev->dev, "AGP aperture too small (%zuM) "
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
+		dev_warn(rdev->dev, "AGP aperture too small (%zuM) "
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

