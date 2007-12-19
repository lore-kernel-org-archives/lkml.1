Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbXLSFgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbXLSFgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXLSFgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:36:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:4995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXLSFgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:36:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,182,1196668800"; 
   d="scan'208";a="245516200"
Date: Wed, 19 Dec 2007 13:28:53 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       "Gross, Mark" <mark.gross@intel.com>
Subject: [agp-mm][PATCH 2/4][AGP] Add generic support for graphics dma remapping
Message-ID: <20071219052853.GC24238@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
	"Gross, Mark" <mark.gross@intel.com>
References: <20071218050809.GA12564@zhen-devel.sh.intel.com> <20071219052030.GA24238@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219052030.GA24238@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[agp-mm] [AGP] Add generic support for graphics dma remapping

New driver hooks for support graphics memory dma remapping
are introduced in this patch. It makes generic code can
tell if current device needs dma remapping, then call driver
provided interfaces for mapping and unmapping. Change has
also been made to handle scratch_page in remapping case.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/agp.h      |   13 +++++++++++++
 drivers/char/agp/backend.c  |   21 ++++++++++++++++++++-
 drivers/char/agp/generic.c  |   14 ++++++++++++++
 include/linux/agp_backend.h |    7 +++++++
 4 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 9ec9374..2c78a28 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -119,6 +119,17 @@ struct agp_bridge_driver {
 	void (*agp_destroy_page)(void *, int flags);
 	int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 	void (*chipset_flush)(struct agp_bridge_data *);
+	/* Tell current graphics dma remapping engine status, there might
+	 * be driver or platform specific way to detect. */
+	int (*agp_require_remapping)(void);
+
+	/* This can support single page remapping via void *virt for like
+	 * scratch_page, or normal bunch of mem page range via struct
+	 * agp_memory *mem.
+	 */
+	int (*agp_map_page)(struct agp_memory *mem, void *virt, dma_addr_t *ret, int is_single);
+
+	void (*agp_unmap_page)(struct agp_memory *mem, dma_addr_t ret, int is_single);
 };
 
 struct agp_bridge_data {
@@ -133,6 +144,8 @@ struct agp_bridge_data {
 	u32 *gatt_table_real;
 	unsigned long scratch_page;
 	unsigned long scratch_page_real;
+	dma_addr_t scratch_page_dma;
+	u8 scratch_page_is_mapped;
 	unsigned long gart_bus_addr;
 	unsigned long gatt_bus_addr;
 	u32 mode;
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index f9c180c..7898051 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -151,7 +151,20 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 
 		bridge->scratch_page_real = virt_to_gart(addr);
 		bridge->scratch_page =
-		    bridge->driver->mask_memory(bridge, bridge->scratch_page_real, 0);
+			bridge->driver->mask_memory(bridge, bridge->scratch_page_real, 0);
+
+		if (bridge->driver->agp_require_remapping &&
+				bridge->driver->agp_require_remapping()) {
+			if (bridge->driver->agp_map_page(NULL, addr, &bridge->scratch_page_dma, 1)) {
+				printk(KERN_ERR PFX "unable to map scratch page\n");
+				rc = -ENOMEM;
+				goto err_out;
+			}
+			bridge->scratch_page_is_mapped = TRUE;
+			bridge->scratch_page =
+				bridge->driver->mask_memory(bridge,
+						bridge->scratch_page_dma, 0);
+		}
 	}
 
 	size_value = bridge->driver->fetch_size();
@@ -189,6 +202,9 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 
 err_out:
 	if (bridge->driver->needs_scratch_page) {
+		if (bridge->scratch_page_is_mapped)
+			bridge->driver->agp_unmap_page(NULL, bridge->scratch_page_dma, 1);
+
 		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
 						 AGP_PAGE_DESTROY_UNMAP);
 		flush_agp_mappings();
@@ -217,6 +233,9 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)
 
 	if (bridge->driver->agp_destroy_page &&
 	    bridge->driver->needs_scratch_page) {
+		if (bridge->scratch_page_is_mapped)
+			bridge->driver->agp_unmap_page(NULL, bridge->scratch_page_dma, 1);
+
 		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
 						 AGP_PAGE_DESTROY_UNMAP);
 		flush_agp_mappings();
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 8c67b4f..d2a502c 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -422,6 +422,14 @@ int agp_bind_memory(struct agp_memory *curr, off_t pg_start)
 		curr->bridge->driver->cache_flush();
 		curr->is_flushed = TRUE;
 	}
+
+	if (curr->bridge->driver->agp_require_remapping &&
+			curr->bridge->driver->agp_require_remapping()) {
+		ret_val = curr->bridge->driver->agp_map_page(curr, NULL, NULL, 0);
+		if (ret_val)
+			return ret_val;
+	}
+
 	ret_val = curr->bridge->driver->insert_memory(curr, pg_start, curr->type);
 
 	if (ret_val != 0)
@@ -461,6 +469,12 @@ int agp_unbind_memory(struct agp_memory *curr)
 
 	curr->is_bound = FALSE;
 	curr->pg_start = 0;
+
+	if (curr->is_mapped) {
+		if (curr->bridge->driver->agp_unmap_page)
+			curr->bridge->driver->agp_unmap_page(curr, 0, 0);
+		curr->is_mapped = FALSE;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(agp_unbind_memory);
diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index 03e3454..64c7476 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -87,7 +87,14 @@ struct agp_memory {
 	u32 physical;
 	u8 is_bound;
 	u8 is_flushed;
+	u8 is_mapped;
         u8 vmalloc_flag;
+	/* Following are used in graphics dma remapping case,
+	 * for map/unmap via sg interfaces.
+	 */
+	struct scatterlist *sg_list;
+	int num_sg;
+	u8 sg_vmalloc_flag;
 };
 
 #define AGP_NORMAL_MEMORY 0
-- 
1.5.3.4

