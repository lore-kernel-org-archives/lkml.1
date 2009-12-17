Return-Path: <linux-kernel-owner+w=401wt.eu-S935693AbZLQE3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935693AbZLQE3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935695AbZLQEEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:49 -0500
Received: from kroah.org ([198.145.64.141]:55671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935673AbZLQEEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:42 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:53 2009
Message-Id: <20091217035653.247116914@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [080/151] drm/radeon/kms: rs6xx/rs740: clamp vram to aperture size
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 0088dbdb809e8799cb8f26da5ac64b15201fa99d upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/rs600.c |    9 ++++++---
 drivers/gpu/drm/radeon/rs690.c |    9 ++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -301,9 +301,7 @@ int rs600_mc_wait_for_idle(struct radeon
 
 void rs600_gpu_init(struct radeon_device *rdev)
 {
-	/* FIXME: HDP same place on rs600 ? */
 	r100_hdp_reset(rdev);
-	/* FIXME: is this correct ? */
 	r420_pipes_init(rdev);
 	/* Wait for mc idle */
 	if (rs600_mc_wait_for_idle(rdev))
@@ -312,7 +310,6 @@ void rs600_gpu_init(struct radeon_device
 
 void rs600_vram_info(struct radeon_device *rdev)
 {
-	/* FIXME: to do or is these values sane ? */
 	rdev->mc.vram_is_ddr = true;
 	rdev->mc.vram_width = 128;
 
@@ -321,6 +318,12 @@ void rs600_vram_info(struct radeon_devic
 
 	rdev->mc.aper_base = drm_get_resource_start(rdev->ddev, 0);
 	rdev->mc.aper_size = drm_get_resource_len(rdev->ddev, 0);
+
+	if (rdev->mc.mc_vram_size > rdev->mc.aper_size)
+		rdev->mc.mc_vram_size = rdev->mc.aper_size;
+
+	if (rdev->mc.real_vram_size > rdev->mc.aper_size)
+		rdev->mc.real_vram_size = rdev->mc.aper_size;
 }
 
 void rs600_bandwidth_update(struct radeon_device *rdev)
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -134,7 +134,7 @@ void rs690_vram_info(struct radeon_devic
 	fixed20_12 a;
 
 	rs400_gart_adjust_size(rdev);
-	/* DDR for all card after R300 & IGP */
+
 	rdev->mc.vram_is_ddr = true;
 	rdev->mc.vram_width = 128;
 
@@ -143,6 +143,13 @@ void rs690_vram_info(struct radeon_devic
 
 	rdev->mc.aper_base = drm_get_resource_start(rdev->ddev, 0);
 	rdev->mc.aper_size = drm_get_resource_len(rdev->ddev, 0);
+
+	if (rdev->mc.mc_vram_size > rdev->mc.aper_size)
+		rdev->mc.mc_vram_size = rdev->mc.aper_size;
+
+	if (rdev->mc.real_vram_size > rdev->mc.aper_size)
+		rdev->mc.real_vram_size = rdev->mc.aper_size;
+
 	rs690_pm_info(rdev);
 	/* FIXME: we should enforce default clock in case GPU is not in
 	 * default setup


