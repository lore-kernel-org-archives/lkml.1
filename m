Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXCQXqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXCQXqN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXCQXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:46:13 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40787 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXCQXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:46:12 -0400
Date: Sun, 18 Mar 2007 00:45:50 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: akpm@linux-foundation.org, Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070317234303.14375.43303.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/char/agp: Convert to generic boolean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/agp/
  Convert to generic booleans

include/linux/agpgart.h
  Removed defines of FALSE/TRUE
    was only used under drivers/char/agp/
  struct agp_front_data {
    Removed used_by_controller
      only assigned 'false' once and never used
    Convert backend_acquired from 'u8' to 'bool'
      only used in drivers/char/agp/ and only as a boolean value

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno"

 drivers/char/agp/amd-k7-agp.c   |    4 ++--
 drivers/char/agp/amd64-agp.c    |    4 ++--
 drivers/char/agp/ati-agp.c      |    4 ++--
 drivers/char/agp/compat_ioctl.c |    2 +-
 drivers/char/agp/efficeon-agp.c |    4 ++--
 drivers/char/agp/frontend.c     |   11 +++++------
 drivers/char/agp/generic.c      |   22 +++++++++++-----------
 drivers/char/agp/hp-agp.c       |    4 ++--
 drivers/char/agp/intel-agp.c    |    8 ++++----
 drivers/char/agp/nvidia-agp.c   |    4 ++--
 drivers/char/agp/parisc-agp.c   |    4 ++--
 drivers/char/agp/sgi-agp.c      |    4 ++--
 drivers/char/agp/sworks-agp.c   |    4 ++--
 include/linux/agpgart.h         |   11 +----------
 14 files changed, 40 insertions(+), 50 deletions(-)


diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index e6c534e..3d57e9f 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -308,9 +308,9 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 4857204..54aba18 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -89,9 +89,9 @@ static int amd64_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 780e59e..aacd866 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -299,10 +299,10 @@ static int ati_insert_memory(struct agp_memory * mem,
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		/*CACHE_FLUSH(); */
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff --git a/drivers/char/agp/compat_ioctl.c b/drivers/char/agp/compat_ioctl.c
index fcb4b1b..851bfa9 100644
--- a/drivers/char/agp/compat_ioctl.c
+++ b/drivers/char/agp/compat_ioctl.c
@@ -213,7 +213,7 @@ long compat_agp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		ret_val = -EINVAL;
 		goto ioctl_out;
 	}
-	if ((agp_fe.backend_acquired != TRUE) &&
+	if (!agp_fe.backend_acquired &&
 	    (cmd != AGPIOC_ACQUIRE32)) {
 		ret_val = -EBUSY;
 		goto ioctl_out;
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index df8da72..1941248 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -249,9 +249,9 @@ static int efficeon_insert_memory(struct agp_memory * mem, off_t pg_start, int t
 	if (type != 0 || mem->type != 0)
 		return -EINVAL;
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	last_page = NULL;
diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 679d7f9..a326942 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -393,7 +393,7 @@ static int agp_remove_controller(struct agp_controller *controller)
 
 	if (agp_fe.current_controller == controller) {
 		agp_fe.current_controller = NULL;
-		agp_fe.backend_acquired = FALSE;
+		agp_fe.backend_acquired = false;
 		agp_backend_release(agp_bridge);
 	}
 	kfree(controller);
@@ -441,7 +441,6 @@ static void agp_controller_release_current(struct agp_controller *controller,
 	}
 
 	agp_fe.current_controller = NULL;
-	agp_fe.used_by_controller = FALSE;
 	agp_backend_release(agp_bridge);
 }
 
@@ -571,7 +570,7 @@ static int agp_mmap(struct file *file, struct vm_area_struct *vma)
 
 	mutex_lock(&(agp_fe.agp_mutex));
 
-	if (agp_fe.backend_acquired != TRUE)
+	if (!agp_fe.backend_acquired)
 		goto out_eperm;
 
 	if (!(test_bit(AGP_FF_IS_VALID, &priv->access_flags)))
@@ -766,7 +765,7 @@ int agpioc_acquire_wrap(struct agp_file_private *priv)
 
 	atomic_inc(&agp_bridge->agp_in_use);
 
-	agp_fe.backend_acquired = TRUE;
+	agp_fe.backend_acquired = true;
 
 	controller = agp_find_controller_by_pid(priv->my_pid);
 
@@ -776,7 +775,7 @@ int agpioc_acquire_wrap(struct agp_file_private *priv)
 		controller = agp_create_controller(priv->my_pid);
 
 		if (controller == NULL) {
-			agp_fe.backend_acquired = FALSE;
+			agp_fe.backend_acquired = false;
 			agp_backend_release(agp_bridge);
 			return -ENOMEM;
 		}
@@ -972,7 +971,7 @@ static int agp_ioctl(struct inode *inode, struct file *file,
 		ret_val = -EINVAL;
 		goto ioctl_out;
 	}
-	if ((agp_fe.backend_acquired != TRUE) &&
+	if (!agp_fe.backend_acquired &&
 	    (cmd != AGPIOC_ACQUIRE)) {
 		ret_val = -EBUSY;
 		goto ioctl_out;
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index f902d71..b38fd83 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -202,7 +202,7 @@ void agp_free_memory(struct agp_memory *curr)
 	if (curr == NULL)
 		return;
 
-	if (curr->is_bound == TRUE)
+	if (curr->is_bound)
 		agp_unbind_memory(curr);
 
 	if (curr->type >= AGP_USER_TYPES) {
@@ -425,20 +425,20 @@ int agp_bind_memory(struct agp_memory *curr, off_t pg_start)
 	if (curr == NULL)
 		return -EINVAL;
 
-	if (curr->is_bound == TRUE) {
+	if (curr->is_bound) {
 		printk(KERN_INFO PFX "memory %p is already bound!\n", curr);
 		return -EINVAL;
 	}
-	if (curr->is_flushed == FALSE) {
+	if (!curr->is_flushed) {
 		curr->bridge->driver->cache_flush();
-		curr->is_flushed = TRUE;
+		curr->is_flushed = true;
 	}
 	ret_val = curr->bridge->driver->insert_memory(curr, pg_start, curr->type);
 
 	if (ret_val != 0)
 		return ret_val;
 
-	curr->is_bound = TRUE;
+	curr->is_bound = true;
 	curr->pg_start = pg_start;
 	return 0;
 }
@@ -460,7 +460,7 @@ int agp_unbind_memory(struct agp_memory *curr)
 	if (curr == NULL)
 		return -EINVAL;
 
-	if (curr->is_bound != TRUE) {
+	if (!curr->is_bound) {
 		printk(KERN_INFO PFX "memory %p was not bound!\n", curr);
 		return -EINVAL;
 	}
@@ -470,7 +470,7 @@ int agp_unbind_memory(struct agp_memory *curr)
 	if (ret_val != 0)
 		return ret_val;
 
-	curr->is_bound = FALSE;
+	curr->is_bound = false;
 	curr->pg_start = 0;
 	return 0;
 }
@@ -832,7 +832,7 @@ void agp_generic_enable(struct agp_bridge_data *bridge, u32 requested_mode)
 			/* If we have 3.5, we can do the isoch stuff. */
 			if (bridge->minor_version >= 5)
 				agp_3_5_enable(bridge);
-			agp_device_command(bridge_agpstat, TRUE);
+			agp_device_command(bridge_agpstat, true);
 			return;
 		} else {
 		    /* Disable calibration cycle in RX91<1> when not in AGP3.0 mode of operation.*/
@@ -849,7 +849,7 @@ void agp_generic_enable(struct agp_bridge_data *bridge, u32 requested_mode)
 	}
 
 	/* AGP v<3 */
-	agp_device_command(bridge_agpstat, FALSE);
+	agp_device_command(bridge_agpstat, false);
 }
 EXPORT_SYMBOL(agp_generic_enable);
 
@@ -1088,9 +1088,9 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		bridge->driver->cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index bcdb149..4e8184a 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -355,9 +355,9 @@ hp_zx1_insert_memory (struct agp_memory *mem, off_t pg_start, int type)
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index e542a62..80b0607 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1435,7 +1435,7 @@ static const struct agp_bridge_driver intel_810_driver = {
 	.aperture_sizes		= intel_i810_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 2,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i810_configure,
 	.fetch_size		= intel_i810_fetch_size,
 	.cleanup		= intel_i810_cleanup,
@@ -1484,7 +1484,7 @@ static const struct agp_bridge_driver intel_830_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i830_configure,
 	.fetch_size		= intel_i830_fetch_size,
 	.cleanup		= intel_i830_cleanup,
@@ -1653,7 +1653,7 @@ static const struct agp_bridge_driver intel_915_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i915_configure,
 	.fetch_size		= intel_i9xx_fetch_size,
 	.cleanup		= intel_i915_cleanup,
@@ -1678,7 +1678,7 @@ static const struct agp_bridge_driver intel_i965_driver = {
        .aperture_sizes         = intel_i830_sizes,
        .size_type              = FIXED_APER_SIZE,
        .num_aperture_sizes     = 4,
-       .needs_scratch_page     = TRUE,
+       .needs_scratch_page     = true,
        .configure              = intel_i915_configure,
        .fetch_size             = intel_i9xx_fetch_size,
        .cleanup                = intel_i915_cleanup,
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index 0c9dab5..b0fa203 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -211,9 +211,9 @@ static int nvidia_insert_memory(struct agp_memory *mem, off_t pg_start, int type
 			return -EBUSY;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 3d83b46..6190595 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -144,9 +144,9 @@ parisc_agp_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index ee8f50e..bd594eb 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -184,9 +184,9 @@ static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		bridge->driver->cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 55212a3..eeae573 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -347,9 +347,9 @@ static int serverworks_insert_memory(struct agp_memory *mem,
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff --git a/include/linux/agpgart.h b/include/linux/agpgart.h
index bfb8ec7..35b65f8 100644
--- a/include/linux/agpgart.h
+++ b/include/linux/agpgart.h
@@ -41,14 +41,6 @@
 
 #define AGP_DEVICE      "/dev/agpgart"
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #ifndef __KERNEL__
 #include <linux/types.h>
 #include <asm/types.h>
@@ -205,8 +197,7 @@ struct agp_front_data {
 	struct agp_controller *current_controller;
 	struct agp_controller *controllers;
 	struct agp_file_private *file_priv_list;
-	u8 used_by_controller;
-	u8 backend_acquired;
+	bool backend_acquired;
 };
 
 #endif				/* __KERNEL__ */
