Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbZG2N2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbZG2N2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZG2N2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:28:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbZG2N2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:28:52 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] drm/radeon/kms: fix memory leak in radeon_driver_load_kms
Date: Wed, 29 Jul 2009 21:28:24 +0800
Message-Id: <1248874104-6162-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following kmemleak report:
unreferenced object 0xffff88022cb53000 (size 4096):
  comm "work_for_cpu", pid 97, jiffies 4294672345
  backtrace:
    [<ffffffff810eb222>] create_object+0x19f/0x2a0
    [<ffffffff810eb422>] kmemleak_alloc+0x26/0x4c
    [<ffffffff810e363f>] __kmalloc+0x187/0x1b0
    [<ffffffffa005f3db>] kzalloc.clone.0+0x13/0x15 [radeon]
    [<ffffffffa005f403>] radeon_driver_load_kms+0x26/0xe1 [radeon]
    [<ffffffffa0017432>] drm_get_dev+0x37f/0x480 [drm]
    [<ffffffffa007f424>] radeon_pci_probe+0x15/0x269 [radeon]
    [<ffffffff811f8779>] local_pci_probe+0x17/0x1b
    [<ffffffff8105ffbb>] do_work_for_cpu+0x18/0x2a
    [<ffffffff81063c38>] kthread+0x8a/0x92
    [<ffffffff81012cba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 4612a7c..df3fdbe 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -58,6 +58,8 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 	if (r) {
 		DRM_ERROR("Failed to initialize radeon, disabling IOCTL\n");
 		radeon_device_fini(rdev);
+		kfree(rdev);
+		dev->dev_private = NULL;
 		return r;
 	}
 	return 0;
-- 
1.6.2.5

