Return-Path: <linux-kernel-owner+w=401wt.eu-S1764307AbXJOBSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764307AbXJOBSi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXJOBSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:18:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51676 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbXJOBS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:18:29 -0400
Date: Mon, 15 Oct 2007 02:18:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp patches for 2.6.24-rc1
Message-ID: <Pine.LNX.4.64.0710150217190.27521@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from 'agp-patches' branch of
master.kernel.org:/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

to receive the following updates:

  drivers/char/agp/agp.h        |    7 +++++--
  drivers/char/agp/ali-agp.c    |   27 ++++++++++++++++-----------
  drivers/char/agp/amd-k7-agp.c |    9 ++-------
  drivers/char/agp/backend.c    |   12 ++++++++----
  drivers/char/agp/generic.c    |   19 +++++++++++++------
  drivers/char/agp/i460-agp.c   |    4 ++--
  drivers/char/agp/intel-agp.c  |    6 ++++--
  7 files changed, 50 insertions(+), 34 deletions(-)

Dave Airlie (1):
       AGP fix race condition between unmapping and freeing pages

Jesper Juhl (1):
       fix use after free in amd create gatt pages

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 8955e7f..b83824c 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -58,6 +58,9 @@ struct gatt_mask {
  	 * devices this will probably be ignored */
  };

+#define AGP_PAGE_DESTROY_UNMAP 1
+#define AGP_PAGE_DESTROY_FREE 2
+
  struct aper_size_info_8 {
  	int size;
  	int num_entries;
@@ -113,7 +116,7 @@ struct agp_bridge_driver {
  	struct agp_memory *(*alloc_by_type) (size_t, int);
  	void (*free_by_type)(struct agp_memory *);
  	void *(*agp_alloc_page)(struct agp_bridge_data *);
-	void (*agp_destroy_page)(void *);
+	void (*agp_destroy_page)(void *, int flags);
          int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
  };

@@ -267,7 +270,7 @@ int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type);
  struct agp_memory *agp_generic_alloc_by_type(size_t page_count, int type);
  void agp_generic_free_by_type(struct agp_memory *curr);
  void *agp_generic_alloc_page(struct agp_bridge_data *bridge);
-void agp_generic_destroy_page(void *addr);
+void agp_generic_destroy_page(void *addr, int flags);
  void agp_free_key(int key);
  int agp_num_entries(void);
  u32 agp_collect_device_status(struct agp_bridge_data *bridge, u32 mode, u32 command);
diff --git a/drivers/char/agp/ali-agp.c b/drivers/char/agp/ali-agp.c
index 4941ddb..aa5ddb7 100644
--- a/drivers/char/agp/ali-agp.c
+++ b/drivers/char/agp/ali-agp.c
@@ -156,29 +156,34 @@ static void *m1541_alloc_page(struct agp_bridge_data *bridge)
  	return addr;
  }

-static void ali_destroy_page(void * addr)
+static void ali_destroy_page(void * addr, int flags)
  {
  	if (addr) {
-		global_cache_flush();	/* is this really needed?  --hch */
-		agp_generic_destroy_page(addr);
-		global_flush_tlb();
+		if (flags & AGP_PAGE_DESTROY_UNMAP) {
+			global_cache_flush();	/* is this really needed?  --hch */
+			agp_generic_destroy_page(addr, flags);
+			global_flush_tlb();
+		} else
+			agp_generic_destroy_page(addr, flags);
  	}
  }

-static void m1541_destroy_page(void * addr)
+static void m1541_destroy_page(void * addr, int flags)
  {
  	u32 temp;

  	if (addr == NULL)
  		return;

-	global_cache_flush();
+	if (flags & AGP_PAGE_DESTROY_UNMAP) {
+		global_cache_flush();

-	pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
-	pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
-			(((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
-			  virt_to_gart(addr)) | ALI_CACHE_FLUSH_EN));
-	agp_generic_destroy_page(addr);
+		pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
+		pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
+				       (((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
+					 virt_to_gart(addr)) | ALI_CACHE_FLUSH_EN));
+	}
+	agp_generic_destroy_page(addr, flags);
  }


diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index f60bca7..1405a42 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -100,21 +100,16 @@ static int amd_create_gatt_pages(int nr_tables)

  	for (i = 0; i < nr_tables; i++) {
  		entry = kzalloc(sizeof(struct amd_page_map), GFP_KERNEL);
+		tables[i] = entry;
  		if (entry == NULL) {
-			while (i > 0) {
-				kfree(tables[i-1]);
-				i--;
-			}
-			kfree(tables);
  			retval = -ENOMEM;
  			break;
  		}
-		tables[i] = entry;
  		retval = amd_create_page_map(entry);
  		if (retval != 0)
  			break;
  	}
-	amd_irongate_private.num_tables = nr_tables;
+	amd_irongate_private.num_tables = i;
  	amd_irongate_private.gatt_pages = tables;

  	if (retval != 0)
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index 1b47c89..832ded2 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -189,9 +189,11 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)

  err_out:
  	if (bridge->driver->needs_scratch_page) {
-		bridge->driver->agp_destroy_page(
-				gart_to_virt(bridge->scratch_page_real));
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_UNMAP);
  		flush_agp_mappings();
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_FREE);
  	}
  	if (got_gatt)
  		bridge->driver->free_gatt_table(bridge);
@@ -215,9 +217,11 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)

  	if (bridge->driver->agp_destroy_page &&
  	    bridge->driver->needs_scratch_page) {
-		bridge->driver->agp_destroy_page(
-				gart_to_virt(bridge->scratch_page_real));
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_UNMAP);
  		flush_agp_mappings();
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_FREE);
  	}
  }

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 3db4f40..64b2f6d 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -195,9 +195,12 @@ void agp_free_memory(struct agp_memory *curr)
  	}
  	if (curr->page_count != 0) {
  		for (i = 0; i < curr->page_count; i++) {
-			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]));
+			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_UNMAP);
  		}
  		flush_agp_mappings();
+		for (i = 0; i < curr->page_count; i++) {
+			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_FREE);
+		}
  	}
  	agp_free_key(curr->key);
  	agp_free_page_array(curr);
@@ -1176,7 +1179,7 @@ void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
  EXPORT_SYMBOL(agp_generic_alloc_page);


-void agp_generic_destroy_page(void *addr)
+void agp_generic_destroy_page(void *addr, int flags)
  {
  	struct page *page;

@@ -1184,10 +1187,14 @@ void agp_generic_destroy_page(void *addr)
  		return;

  	page = virt_to_page(addr);
-	unmap_page_from_agp(page);
-	put_page(page);
-	free_page((unsigned long)addr);
-	atomic_dec(&agp_bridge->current_memory_agp);
+	if (flags & AGP_PAGE_DESTROY_UNMAP)
+		unmap_page_from_agp(page);
+
+	if (flags & AGP_PAGE_DESTROY_FREE) {
+		put_page(page);
+		free_page((unsigned long)addr);
+		atomic_dec(&agp_bridge->current_memory_agp);
+	}
  }
  EXPORT_SYMBOL(agp_generic_destroy_page);

diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index 75d2aca..70117df 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -536,10 +536,10 @@ static void *i460_alloc_page (struct agp_bridge_data *bridge)
  	return page;
  }

-static void i460_destroy_page (void *page)
+static void i460_destroy_page (void *page, int flags)
  {
  	if (I460_IO_PAGE_SHIFT <= PAGE_SHIFT) {
-		agp_generic_destroy_page(page);
+		agp_generic_destroy_page(page, flags);
  		global_flush_tlb();
  	}
  }
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 141ca17..d879619 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -400,9 +400,11 @@ static void intel_i810_free_by_type(struct agp_memory *curr)
  		if (curr->page_count == 4)
  			i8xx_destroy_pages(gart_to_virt(curr->memory[0]));
  		else {
-			agp_bridge->driver->agp_destroy_page(
-				 gart_to_virt(curr->memory[0]));
+			agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
+							     AGP_PAGE_DESTROY_UNMAP);
  			global_flush_tlb();
+			agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
+							     AGP_PAGE_DESTROY_FREE);
  		}
  		agp_free_page_array(curr);
  	}
