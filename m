Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYCHASt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYCHASt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 19:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYCHASj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 19:18:39 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2399 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCHASi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 19:18:38 -0500
Subject: [PATCH] drivers/char/agp - use bool
From: Joe Perches <joe@perches.com>
To: David Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 16:17:41 -0800
Message-Id: <1204935461.5541.101.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/agp_backend.h     |   14 +++-----------
 drivers/char/agp/agp.h          |    6 +++---
 drivers/char/agp/alpha-agp.c    |    4 ++--
 drivers/char/agp/amd-k7-agp.c   |    4 ++--
 drivers/char/agp/amd64-agp.c    |    4 ++--
 drivers/char/agp/ati-agp.c      |    4 ++--
 drivers/char/agp/efficeon-agp.c |    6 +++---
 drivers/char/agp/generic.c      |   24 ++++++++++++------------
 drivers/char/agp/hp-agp.c       |    6 +++---
 drivers/char/agp/i460-agp.c     |    2 +-
 drivers/char/agp/intel-agp.c    |   10 +++++-----
 drivers/char/agp/nvidia-agp.c   |    4 ++--
 drivers/char/agp/parisc-agp.c   |    6 +++---
 drivers/char/agp/sgi-agp.c      |    8 ++++----
 drivers/char/agp/sworks-agp.c   |    6 +++---
 drivers/char/agp/uninorth-agp.c |   10 +++++-----
 16 files changed, 55 insertions(+), 63 deletions(-)

diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index 03e3454..3698939 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -32,14 +32,6 @@
 
 #ifdef __KERNEL__
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 enum chipset_type {
 	NOT_SUPPORTED,
 	SUPPORTED,
@@ -59,7 +51,7 @@ struct agp_kern_info {
 	size_t aper_size;
 	int max_memory;		/* In pages */
 	int current_memory;
-	int cant_use_aperture;
+	bool cant_use_aperture;
 	unsigned long page_mask;
 	struct vm_operations_struct *vm_ops;
 };
@@ -85,8 +77,8 @@ struct agp_memory {
 	off_t pg_start;
 	u32 type;
 	u32 physical;
-	u8 is_bound;
-	u8 is_flushed;
+	bool is_bound;
+	bool is_flushed;
         u8 vmalloc_flag;
 };
 
diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index c69f795..9abddea 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -99,8 +99,8 @@ struct agp_bridge_driver {
 	const void *aperture_sizes;
 	int num_aperture_sizes;
 	enum aper_size_type size_type;
-	int cant_use_aperture;
-	int needs_scratch_page;
+	bool cant_use_aperture;
+	bool needs_scratch_page;
 	const struct gatt_mask *masks;
 	int (*fetch_size)(void);
 	int (*configure)(void);
@@ -278,7 +278,7 @@ void agp_generic_destroy_page(void *addr, int flags);
 void agp_free_key(int key);
 int agp_num_entries(void);
 u32 agp_collect_device_status(struct agp_bridge_data *bridge, u32 mode, u32 command);
-void agp_device_command(u32 command, int agp_v3);
+void agp_device_command(u32 command, bool agp_v3);
 int agp_3_5_enable(struct agp_bridge_data *bridge);
 void global_cache_flush(void);
 void get_agp_version(struct agp_bridge_data *bridge);
diff --git a/drivers/char/agp/alpha-agp.c b/drivers/char/agp/alpha-agp.c
index e77c178..5da89f6 100644
--- a/drivers/char/agp/alpha-agp.c
+++ b/drivers/char/agp/alpha-agp.c
@@ -80,7 +80,7 @@ static void alpha_core_agp_enable(struct agp_bridge_data *bridge, u32 mode)
 	agp->mode.bits.enable = 1;
 	agp->ops->configure(agp);
 
-	agp_device_command(agp->mode.lw, 0);
+	agp_device_command(agp->mode.lw, false);
 }
 
 static int alpha_core_agp_insert_memory(struct agp_memory *mem, off_t pg_start,
@@ -126,7 +126,7 @@ struct agp_bridge_driver alpha_core_agp_driver = {
 	.aperture_sizes		= alpha_core_agp_sizes,
 	.num_aperture_sizes	= 1,
 	.size_type		= FIXED_APER_SIZE,
-	.cant_use_aperture	= 1,
+	.cant_use_aperture	= true,
 	.masks			= NULL,
 
 	.fetch_size		= alpha_core_agp_fetch_size,
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index d286699..10359a2 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -314,9 +314,9 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
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
index d8200ac..13665db 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -90,9 +90,9 @@ static int amd64_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
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
index 55c97f6..b0066d9 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -287,10 +287,10 @@ static int ati_insert_memory(struct agp_memory * mem,
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
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index cac0009..8ca6f26 100644
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
@@ -329,7 +329,7 @@ static const struct agp_bridge_driver efficeon_driver = {
 	.free_gatt_table	= efficeon_free_gatt_table,
 	.insert_memory		= efficeon_insert_memory,
 	.remove_memory		= efficeon_remove_memory,
-	.cant_use_aperture	= 0,	// 1 might be faster?
+	.cant_use_aperture	= false,	// true might be faster?
 
 	// Generic
 	.alloc_by_type		= agp_generic_alloc_by_type,
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 7fc0c99..653ca3b 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -188,7 +188,7 @@ void agp_free_memory(struct agp_memory *curr)
 	if (curr == NULL)
 		return;
 
-	if (curr->is_bound == TRUE)
+	if (curr->is_bound)
 		agp_unbind_memory(curr);
 
 	if (curr->type >= AGP_USER_TYPES) {
@@ -411,20 +411,20 @@ int agp_bind_memory(struct agp_memory *curr, off_t pg_start)
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
@@ -446,7 +446,7 @@ int agp_unbind_memory(struct agp_memory *curr)
 	if (curr == NULL)
 		return -EINVAL;
 
-	if (curr->is_bound != TRUE) {
+	if (!curr->is_bound) {
 		printk(KERN_INFO PFX "memory %p was not bound!\n", curr);
 		return -EINVAL;
 	}
@@ -456,7 +456,7 @@ int agp_unbind_memory(struct agp_memory *curr)
 	if (ret_val != 0)
 		return ret_val;
 
-	curr->is_bound = FALSE;
+	curr->is_bound = false;
 	curr->pg_start = 0;
 	return 0;
 }
@@ -754,7 +754,7 @@ u32 agp_collect_device_status(struct agp_bridge_data *bridge, u32 requested_mode
 EXPORT_SYMBOL(agp_collect_device_status);
 

-void agp_device_command(u32 bridge_agpstat, int agp_v3)
+void agp_device_command(u32 bridge_agpstat, bool agp_v3)
 {
 	struct pci_dev *device = NULL;
 	int mode;
@@ -818,7 +818,7 @@ void agp_generic_enable(struct agp_bridge_data *bridge, u32 requested_mode)
 			/* If we have 3.5, we can do the isoch stuff. */
 			if (bridge->minor_version >= 5)
 				agp_3_5_enable(bridge);
-			agp_device_command(bridge_agpstat, TRUE);
+			agp_device_command(bridge_agpstat, true);
 			return;
 		} else {
 		    /* Disable calibration cycle in RX91<1> when not in AGP3.0 mode of operation.*/
@@ -835,7 +835,7 @@ void agp_generic_enable(struct agp_bridge_data *bridge, u32 requested_mode)
 	}
 
 	/* AGP v<3 */
-	agp_device_command(bridge_agpstat, FALSE);
+	agp_device_command(bridge_agpstat, false);
 }
 EXPORT_SYMBOL(agp_generic_enable);
 
@@ -1083,9 +1083,9 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
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
index cbb0444..80d7317 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -353,9 +353,9 @@ hp_zx1_insert_memory (struct agp_memory *mem, off_t pg_start, int type)
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
@@ -437,7 +437,7 @@ const struct agp_bridge_driver hp_zx1_driver = {
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
-	.cant_use_aperture	= 1,
+	.cant_use_aperture	= true,
 };
 
 static int __init
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index 76f581c..e587eeb 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -580,7 +580,7 @@ const struct agp_bridge_driver intel_i460_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
-	.cant_use_aperture	= 1,
+	.cant_use_aperture	= true,
 };
 
 static int __devinit agp_intel_i460_probe(struct pci_dev *pdev,
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index eeea50a..a759694 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1656,7 +1656,7 @@ static const struct agp_bridge_driver intel_810_driver = {
 	.aperture_sizes		= intel_i810_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 2,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i810_configure,
 	.fetch_size		= intel_i810_fetch_size,
 	.cleanup		= intel_i810_cleanup,
@@ -1705,7 +1705,7 @@ static const struct agp_bridge_driver intel_830_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i830_configure,
 	.fetch_size		= intel_i830_fetch_size,
 	.cleanup		= intel_i830_cleanup,
@@ -1876,7 +1876,7 @@ static const struct agp_bridge_driver intel_915_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i915_configure,
 	.fetch_size		= intel_i9xx_fetch_size,
 	.cleanup		= intel_i915_cleanup,
@@ -1902,7 +1902,7 @@ static const struct agp_bridge_driver intel_i965_driver = {
        .aperture_sizes         = intel_i830_sizes,
        .size_type              = FIXED_APER_SIZE,
        .num_aperture_sizes     = 4,
-       .needs_scratch_page     = TRUE,
+       .needs_scratch_page     = true,
        .configure              = intel_i915_configure,
        .fetch_size             = intel_i9xx_fetch_size,
        .cleanup                = intel_i915_cleanup,
@@ -1952,7 +1952,7 @@ static const struct agp_bridge_driver intel_g33_driver = {
 	.aperture_sizes         = intel_i830_sizes,
 	.size_type              = FIXED_APER_SIZE,
 	.num_aperture_sizes     = 4,
-	.needs_scratch_page     = TRUE,
+	.needs_scratch_page     = true,
 	.configure              = intel_i915_configure,
 	.fetch_size             = intel_i9xx_fetch_size,
 	.cleanup                = intel_i915_cleanup,
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index 225ed2a..eaceb61 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -214,9 +214,9 @@ static int nvidia_insert_memory(struct agp_memory *mem, off_t pg_start, int type
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
index 2939e35..8c42dcc 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -141,9 +141,9 @@ parisc_agp_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
@@ -226,7 +226,7 @@ static const struct agp_bridge_driver parisc_agp_driver = {
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
-	.cant_use_aperture	= 1,
+	.cant_use_aperture	= true,
 };
 
 static int __init
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index 98cf8ab..713453a 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -182,9 +182,9 @@ static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		bridge->driver->cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
@@ -264,8 +264,8 @@ const struct agp_bridge_driver sgi_tioca_driver = {
 	.agp_alloc_page = sgi_tioca_alloc_page,
 	.agp_destroy_page = agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
-	.cant_use_aperture = 1,
-	.needs_scratch_page = 0,
+	.cant_use_aperture = true,
+	.needs_scratch_page = false,
 	.num_aperture_sizes = 1,
 };
 
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index e08934e..0e054c1 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -339,9 +339,9 @@ static int serverworks_insert_memory(struct agp_memory *mem,
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
@@ -412,7 +412,7 @@ static void serverworks_agp_enable(struct agp_bridge_data *bridge, u32 mode)
 			       bridge->capndx + PCI_AGP_COMMAND,
 			       command);
 
-	agp_device_command(command, 0);
+	agp_device_command(command, false);
 }
 
 static const struct agp_bridge_driver sworks_driver = {
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index 42c0a60..d2fa3cf 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -281,10 +281,10 @@ static void uninorth_agp_enable(struct agp_bridge_data *bridge, u32 mode)
 
 	if (uninorth_rev >= 0x30) {
 		/* This is an AGP V3 */
-		agp_device_command(command, (status & AGPSTAT_MODE_3_0));
+		agp_device_command(command, (status & AGPSTAT_MODE_3_0) != 0);
 	} else {
 		/* AGP V2 */
-		agp_device_command(command, 0);
+		agp_device_command(command, false);
 	}
 
 	uninorth_tlbflush(NULL);
@@ -511,7 +511,7 @@ const struct agp_bridge_driver uninorth_agp_driver = {
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
-	.cant_use_aperture	= 1,
+	.cant_use_aperture	= true,
 };
 
 const struct agp_bridge_driver u3_agp_driver = {
@@ -536,8 +536,8 @@ const struct agp_bridge_driver u3_agp_driver = {
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
-	.cant_use_aperture	= 1,
-	.needs_scratch_page	= 1,
+	.cant_use_aperture	= true,
+	.needs_scratch_page	= true,
 };
 
 static struct agp_device_ids uninorth_agp_device_ids[] __devinitdata = {


