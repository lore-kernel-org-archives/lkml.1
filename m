Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0BBMAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:00:43 -0500
Received: from nox.protox.org ([88.191.38.29]:34651 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0BBMAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:00:40 -0500
Date: Tue, 2 Feb 2010 12:56:11 +0100
From: Jerome Glisse <glisse@freedesktop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100202115611.GA10289@localhost.localdomain>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20100202081727.GA6788@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 02, 2010 at 09:17:27AM +0100, Ingo Molnar wrote:
> 
> * Dave Airlie <airlied@linux.ie> wrote:
> 
> > > Hi Linus,
> > > 
> > > Please pull the 'drm-linus' branch from
> > > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> > > 
> > 
> > I've also added an oops fix I seem to lose off my radar to this tree.
> > 
> > commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
> > Author: Michel D??nzer <daenzer@vmware.com>
> > Date:   Fri Jan 22 09:20:00 2010 +0100
> > 
> >     drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
> 
> FYI, this drm pull into mainline has triggered quick boot crashes in -tip 
> testing (even with the above fix applied), on an Athlon64 whitebox PC with:
> 
>  01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)]
>  01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
> 
> the crash is:
> 
> [    7.111003] radeon 0000:01:00.0: Disabling GPU acceleration
> [    7.273547] Failed to wait GUI idle while programming pipes. Bad things might happen.
> [    7.436296] [drm:r100_cp_fini] *ERROR* Wait for CP idle timeout, shutting down CP.
> [    7.598755] Failed to wait GUI idle while programming pipes. Bad things might happen.
> [    7.599306] BUG: unable to handle kernel paging request at f8380000
> [    7.599999] IP: [<c149f0de>] rv370_pcie_gart_set_page+0x2d/0x3c
> [    7.599999] *pde = 36d44067 *pte = 00000000
> [    7.599999] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> [    7.599999] last sysfs file:
> 
> i have bisected it back to:
> 
>  | 97b94ccb9aa1b82ed7a9a045d0ae5b32c99b84a0 is the first bad commit
>  | commit 97b94ccb9aa1b82ed7a9a045d0ae5b32c99b84a0
>  | Author: Dave Airlie <airlied@redhat.com>
>  | Date:   Fri Jan 29 15:31:47 2010 +1000
>  |
>  |     drm/radeon/kms: fix incorrect logic in DP vs eDP connector checking.
>  |    
>  |     This makes displayport work again here.
> 
> Unfortunately even with that patch reverted it still crashes. Config and 
> bootlog attached.
> 
> It's the moving of radeom KMS out of staging after -rc6 that causes it, 
> because it brought it into the scope of my testing:
> 
>  f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
> 
> So at least on this box it's clearly not ready for mainline enablement yet. 
> I've attached the revert patch further below.
> 
> 	Ingo
> 

Attached is a patch which will fix the oops, still it's strange that
CP fails to init on your config. Do you have IOMMU enabled ? I haven't
played with iommu stuff thus i wonder if we are missing somethings in
this area.

Anyway the root issue of the oops made me wonder if we shouldn't explore
some kind of stack based GPU block initialization, when we init a GPU
block we push and when we want to deinit we pop the stack thus block
should be deinited in right order. We are having a lot of different
path in the driver and the failure path are not as well tested as
they might be. Anyway such change is more a long term idea that might
be good to look into (maybe for 2.6.35).

Cheers,
Jerome

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-drm-radeon-kms-don-t-call-suspend-path-before-cleani.patch"

>From b31f021587f79d0d60c283e6fccf82f18a540de0 Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Tue, 2 Feb 2010 11:51:45 +0100
Subject: [PATCH] drm/radeon/kms: don't call suspend path before cleaning up GPU

In suspend path we unmap the GART table while in cleaning up
path we will unbind buffer and thus try to write to unmapped
GART leading to oops. In order to avoid this we don't call the
suspend path in cleanup path. Cleanup path is clever enough
to desactive GPU like the suspend path is doing, thus this was
redondant.

Tested on: RV370, R420, RV515, RV570, RV610, RV770 (all PCIE)

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c   |    4 +---
 drivers/gpu/drm/radeon/r300.c   |    5 ++---
 drivers/gpu/drm/radeon/r420.c   |    3 +--
 drivers/gpu/drm/radeon/r520.c   |    3 +--
 drivers/gpu/drm/radeon/r600.c   |   21 +++++++++++++--------
 drivers/gpu/drm/radeon/radeon.h |    1 +
 drivers/gpu/drm/radeon/rs400.c  |    2 --
 drivers/gpu/drm/radeon/rs600.c  |    2 --
 drivers/gpu/drm/radeon/rs690.c  |    2 --
 drivers/gpu/drm/radeon/rv515.c  |    4 +---
 drivers/gpu/drm/radeon/rv770.c  |   12 ++++++------
 11 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 11c9a3f..5689580 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3369,7 +3369,6 @@ int r100_suspend(struct radeon_device *rdev)
 
 void r100_fini(struct radeon_device *rdev)
 {
-	r100_suspend(rdev);
 	r100_cp_fini(rdev);
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
@@ -3481,13 +3480,12 @@ int r100_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		r100_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
+		radeon_irq_kms_fini(rdev);
 		if (rdev->flags & RADEON_IS_PCI)
 			r100_pci_gart_fini(rdev);
-		radeon_irq_kms_fini(rdev);
 		rdev->accel_working = false;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 0051d11..e699e6d 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1327,7 +1327,6 @@ int r300_suspend(struct radeon_device *rdev)
 
 void r300_fini(struct radeon_device *rdev)
 {
-	r300_suspend(rdev);
 	r100_cp_fini(rdev);
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
@@ -1418,15 +1417,15 @@ int r300_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		r300_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
+		radeon_irq_kms_fini(rdev);
 		if (rdev->flags & RADEON_IS_PCIE)
 			rv370_pcie_gart_fini(rdev);
 		if (rdev->flags & RADEON_IS_PCI)
 			r100_pci_gart_fini(rdev);
-		radeon_irq_kms_fini(rdev);
+		radeon_agp_fini(rdev);
 		rdev->accel_working = false;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 4526faa..d937324 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -389,16 +389,15 @@ int r420_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		r420_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
+		radeon_irq_kms_fini(rdev);
 		if (rdev->flags & RADEON_IS_PCIE)
 			rv370_pcie_gart_fini(rdev);
 		if (rdev->flags & RADEON_IS_PCI)
 			r100_pci_gart_fini(rdev);
 		radeon_agp_fini(rdev);
-		radeon_irq_kms_fini(rdev);
 		rdev->accel_working = false;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 9a18907..ddf5731 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -294,13 +294,12 @@ int r520_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		rv515_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
+		radeon_irq_kms_fini(rdev);
 		rv370_pcie_gart_fini(rdev);
 		radeon_agp_fini(rdev);
-		radeon_irq_kms_fini(rdev);
 		rdev->accel_working = false;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 1b6d000..fd1fea8 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1654,6 +1654,12 @@ void r600_ring_init(struct radeon_device *rdev, unsigned ring_size)
 	rdev->cp.align_mask = 16 - 1;
 }
 
+void r600_cp_fini(struct radeon_device *rdev)
+{
+	r600_cp_stop(rdev);
+	radeon_ring_fini(rdev);
+}
+
 
 /*
  * GPU scratch registers helpers function.
@@ -2055,9 +2061,11 @@ int r600_init(struct radeon_device *rdev)
 	rdev->accel_working = true;
 	r = r600_startup(rdev);
 	if (r) {
-		r600_suspend(rdev);
+		dev_err(rdev->dev, "disabling GPU acceleration\n");
+		r600_cp_fini(rdev);
 		r600_wb_fini(rdev);
-		radeon_ring_fini(rdev);
+		r600_irq_fini(rdev);
+		radeon_irq_kms_fini(rdev);
 		r600_pcie_gart_fini(rdev);
 		rdev->accel_working = false;
 	}
@@ -2083,20 +2091,17 @@ int r600_init(struct radeon_device *rdev)
 
 void r600_fini(struct radeon_device *rdev)
 {
-	/* Suspend operations */
-	r600_suspend(rdev);
-
 	r600_audio_fini(rdev);
 	r600_blit_fini(rdev);
+	r600_cp_fini(rdev);
+	r600_wb_fini(rdev);
 	r600_irq_fini(rdev);
 	radeon_irq_kms_fini(rdev);
-	radeon_ring_fini(rdev);
-	r600_wb_fini(rdev);
 	r600_pcie_gart_fini(rdev);
+	radeon_agp_fini(rdev);
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
 	radeon_clocks_fini(rdev);
-	radeon_agp_fini(rdev);
 	radeon_bo_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 2d5f2bf..11b0a2b 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1143,6 +1143,7 @@ extern bool r600_card_posted(struct radeon_device *rdev);
 extern void r600_cp_stop(struct radeon_device *rdev);
 extern void r600_ring_init(struct radeon_device *rdev, unsigned ring_size);
 extern int r600_cp_resume(struct radeon_device *rdev);
+extern void r600_cp_fini(struct radeon_device *rdev);
 extern int r600_count_pipe_bits(uint32_t val);
 extern int r600_gart_clear_page(struct radeon_device *rdev, int i);
 extern int r600_mc_wait_for_idle(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 9f54189..eeeb0d6 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -448,7 +448,6 @@ int rs400_suspend(struct radeon_device *rdev)
 
 void rs400_fini(struct radeon_device *rdev)
 {
-	rs400_suspend(rdev);
 	r100_cp_fini(rdev);
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
@@ -527,7 +526,6 @@ int rs400_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		rs400_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index d525575..c381856 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -610,7 +610,6 @@ int rs600_suspend(struct radeon_device *rdev)
 
 void rs600_fini(struct radeon_device *rdev)
 {
-	rs600_suspend(rdev);
 	r100_cp_fini(rdev);
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
@@ -689,7 +688,6 @@ int rs600_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		rs600_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index cd31da9..06e2771 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -676,7 +676,6 @@ int rs690_suspend(struct radeon_device *rdev)
 
 void rs690_fini(struct radeon_device *rdev)
 {
-	rs690_suspend(rdev);
 	r100_cp_fini(rdev);
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
@@ -756,7 +755,6 @@ int rs690_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		rs690_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 6275671..0e1e6b8 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -537,7 +537,6 @@ void rv515_set_safe_registers(struct radeon_device *rdev)
 
 void rv515_fini(struct radeon_device *rdev)
 {
-	rv515_suspend(rdev);
 	r100_cp_fini(rdev);
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
@@ -615,13 +614,12 @@ int rv515_init(struct radeon_device *rdev)
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
 		dev_err(rdev->dev, "Disabling GPU acceleration\n");
-		rv515_suspend(rdev);
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
+		radeon_irq_kms_fini(rdev);
 		rv370_pcie_gart_fini(rdev);
 		radeon_agp_fini(rdev);
-		radeon_irq_kms_fini(rdev);
 		rdev->accel_working = false;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index afd9e82..1f04d0a 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1065,9 +1065,11 @@ int rv770_init(struct radeon_device *rdev)
 	rdev->accel_working = true;
 	r = rv770_startup(rdev);
 	if (r) {
-		rv770_suspend(rdev);
+		dev_err(rdev->dev, "disabling GPU acceleration\n");
+		r600_cp_fini(rdev);
 		r600_wb_fini(rdev);
-		radeon_ring_fini(rdev);
+		r600_irq_fini(rdev);
+		radeon_irq_kms_fini(rdev);
 		rv770_pcie_gart_fini(rdev);
 		rdev->accel_working = false;
 	}
@@ -1089,13 +1091,11 @@ int rv770_init(struct radeon_device *rdev)
 
 void rv770_fini(struct radeon_device *rdev)
 {
-	rv770_suspend(rdev);
-
 	r600_blit_fini(rdev);
+	r600_cp_fini(rdev);
+	r600_wb_fini(rdev);
 	r600_irq_fini(rdev);
 	radeon_irq_kms_fini(rdev);
-	radeon_ring_fini(rdev);
-	r600_wb_fini(rdev);
 	rv770_pcie_gart_fini(rdev);
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-- 
1.6.6


--W/nzBZO5zC0uMSeA--
