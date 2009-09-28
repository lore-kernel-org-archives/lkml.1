Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZI1Q1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZI1Q1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZI1Q1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:27:22 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:45671 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZI1Q1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:27:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19136.58347.65571.678074@pilspetsen.it.uu.se>
Date: Mon, 28 Sep 2009 18:27:23 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: dri-devel@lists.sourceforge.net
Subject: [PATCH 2.6.32-rc1] fix radeon DRM warnings when !CONFIG_DEBUG_FS
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling the radeon DRM driver with !CONFIG_DEBUG_FS
throws the following warnings:

drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_debugfs_init':
drivers/gpu/drm/radeon/radeon_ttm.c:714: warning: unused variable 'i'
drivers/gpu/drm/radeon/radeon_ttm.c: At top level:
drivers/gpu/drm/radeon/radeon_ttm.c:692: warning: 'radeon_mem_types_list' defined but not used
drivers/gpu/drm/radeon/radeon_ttm.c:693: warning: 'radeon_mem_types_names' defined but not used

Fix: move these variables inside the #if defined(CONFIG_DEBUG_FS)
block in radeon_ttm_debugsfs_init(), which is the only place using them.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 drivers/gpu/drm/radeon/radeon_ttm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.32-rc1/drivers/gpu/drm/radeon/radeon_ttm.c.~1~	2009-09-28 13:54:30.000000000 +0200
+++ linux-2.6.32-rc1/drivers/gpu/drm/radeon/radeon_ttm.c	2009-09-28 17:12:24.000000000 +0200
@@ -689,9 +689,6 @@ struct ttm_backend *radeon_ttm_backend_c
 
 #define RADEON_DEBUGFS_MEM_TYPES 2
 
-static struct drm_info_list radeon_mem_types_list[RADEON_DEBUGFS_MEM_TYPES];
-static char radeon_mem_types_names[RADEON_DEBUGFS_MEM_TYPES][32];
-
 #if defined(CONFIG_DEBUG_FS)
 static int radeon_mm_dump_table(struct seq_file *m, void *data)
 {
@@ -711,9 +708,11 @@ static int radeon_mm_dump_table(struct s
 
 static int radeon_ttm_debugfs_init(struct radeon_device *rdev)
 {
+#if defined(CONFIG_DEBUG_FS)
+	static struct drm_info_list radeon_mem_types_list[RADEON_DEBUGFS_MEM_TYPES];
+	static char radeon_mem_types_names[RADEON_DEBUGFS_MEM_TYPES][32];
 	unsigned i;
 
-#if defined(CONFIG_DEBUG_FS)
 	for (i = 0; i < RADEON_DEBUGFS_MEM_TYPES; i++) {
 		if (i == 0)
 			sprintf(radeon_mem_types_names[i], "radeon_vram_mm");
