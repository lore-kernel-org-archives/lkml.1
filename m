Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbZFLEod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbZFLEod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZFLEoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:44:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZFLEoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:44:21 -0400
From: Dave Airlie <airlied@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH] agp: switch AGP to use page array instead of unsigned long array
Date: Fri, 12 Jun 2009 14:45:56 +1000
Message-Id: <1244781956-2660-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

This switches AGP to use an array of pages for tracking the
pages allocated to the GART. This should enable GEM on PAE to work
a lot better as we can pass highmem pages to the PAT code and it will
do the right thing with them.

cc'ed people who cared about AGP in the past.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Cc: Eric Anholt <eric@anholt.net>
Cc: Thomas Hellstrom <thellstrom@vmware.com>

---
 drivers/char/agp/agp.h           |   12 +++---
 drivers/char/agp/ali-agp.c       |   26 +++++++-------
 drivers/char/agp/amd-k7-agp.c    |    2 +-
 drivers/char/agp/amd64-agp.c     |    2 +-
 drivers/char/agp/ati-agp.c       |    5 ++-
 drivers/char/agp/backend.c       |    8 ++--
 drivers/char/agp/efficeon-agp.c  |    5 ++-
 drivers/char/agp/generic.c       |   69 +++++++++++++++----------------------
 drivers/char/agp/hp-agp.c        |    9 ++---
 drivers/char/agp/i460-agp.c      |   43 ++++++++++++++---------
 drivers/char/agp/intel-agp.c     |   49 ++++++++++++--------------
 drivers/char/agp/nvidia-agp.c    |    2 +-
 drivers/char/agp/parisc-agp.c    |   20 +++++++++--
 drivers/char/agp/sgi-agp.c       |    5 ++-
 drivers/char/agp/sworks-agp.c    |    2 +-
 drivers/char/agp/uninorth-agp.c  |   12 +++---
 drivers/gpu/drm/drm_agpsupport.c |    2 +-
 drivers/gpu/drm/drm_memory.c     |    8 ++--
 drivers/gpu/drm/drm_vm.c         |    4 +-
 include/linux/agp_backend.h      |    2 +-
 20 files changed, 147 insertions(+), 140 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 46f5075..178e2e9 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -107,7 +107,7 @@ struct agp_bridge_driver {
 	void (*agp_enable)(struct agp_bridge_data *, u32);
 	void (*cleanup)(void);
 	void (*tlb_flush)(struct agp_memory *);
-	unsigned long (*mask_memory)(struct agp_bridge_data *, unsigned long, int);
+	unsigned long (*mask_memory)(struct agp_bridge_data *, struct page *, int);
 	void (*cache_flush)(void);
 	int (*create_gatt_table)(struct agp_bridge_data *);
 	int (*free_gatt_table)(struct agp_bridge_data *);
@@ -115,9 +115,9 @@ struct agp_bridge_driver {
 	int (*remove_memory)(struct agp_memory *, off_t, int);
 	struct agp_memory *(*alloc_by_type) (size_t, int);
 	void (*free_by_type)(struct agp_memory *);
-	void *(*agp_alloc_page)(struct agp_bridge_data *);
+	struct page *(*agp_alloc_page)(struct agp_bridge_data *);
 	int (*agp_alloc_pages)(struct agp_bridge_data *, struct agp_memory *, size_t);
-	void (*agp_destroy_page)(void *, int flags);
+	void (*agp_destroy_page)(struct page *, int flags);
 	void (*agp_destroy_pages)(struct agp_memory *);
 	int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 	void (*chipset_flush)(struct agp_bridge_data *);
@@ -278,10 +278,10 @@ int agp_generic_insert_memory(struct agp_memory *mem, off_t pg_start, int type);
 int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type);
 struct agp_memory *agp_generic_alloc_by_type(size_t page_count, int type);
 void agp_generic_free_by_type(struct agp_memory *curr);
-void *agp_generic_alloc_page(struct agp_bridge_data *bridge);
+struct page *agp_generic_alloc_page(struct agp_bridge_data *bridge);
 int agp_generic_alloc_pages(struct agp_bridge_data *agp_bridge,
 			    struct agp_memory *memory, size_t page_count);
-void agp_generic_destroy_page(void *addr, int flags);
+void agp_generic_destroy_page(struct page *page, int flags);
 void agp_generic_destroy_pages(struct agp_memory *memory);
 void agp_free_key(int key);
 int agp_num_entries(void);
@@ -291,7 +291,7 @@ int agp_3_5_enable(struct agp_bridge_data *bridge);
 void global_cache_flush(void);
 void get_agp_version(struct agp_bridge_data *bridge);
 unsigned long agp_generic_mask_memory(struct agp_bridge_data *bridge,
-	unsigned long addr, int type);
+				      struct page *page, int type);
 int agp_generic_type_to_mask_type(struct agp_bridge_data *bridge,
 				  int type);
 struct agp_bridge_data *agp_generic_find_bridge(struct pci_dev *pdev);
diff --git a/drivers/char/agp/ali-agp.c b/drivers/char/agp/ali-agp.c
index dc8d1a9..58ffa71 100644
--- a/drivers/char/agp/ali-agp.c
+++ b/drivers/char/agp/ali-agp.c
@@ -141,37 +141,37 @@ static void m1541_cache_flush(void)
 	}
 }
 
-static void *m1541_alloc_page(struct agp_bridge_data *bridge)
+static struct page *m1541_alloc_page(struct agp_bridge_data *bridge)
 {
-	void *addr = agp_generic_alloc_page(agp_bridge);
+	struct page *page = agp_generic_alloc_page(agp_bridge);
 	u32 temp;
 
-	if (!addr)
+	if (!page)
 		return NULL;
 
 	pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
 	pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
 			(((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
-			  virt_to_gart(addr)) | ALI_CACHE_FLUSH_EN ));
-	return addr;
+			  phys_to_gart(page_to_phys(page))) | ALI_CACHE_FLUSH_EN ));
+	return page;
 }
 
-static void ali_destroy_page(void * addr, int flags)
+static void ali_destroy_page(struct page *page, int flags)
 {
-	if (addr) {
+	if (page) {
 		if (flags & AGP_PAGE_DESTROY_UNMAP) {
 			global_cache_flush();	/* is this really needed?  --hch */
-			agp_generic_destroy_page(addr, flags);
+			agp_generic_destroy_page(page, flags);
 		} else
-			agp_generic_destroy_page(addr, flags);
+			agp_generic_destroy_page(page, flags);
 	}
 }
 
-static void m1541_destroy_page(void * addr, int flags)
+static void m1541_destroy_page(struct page *page, int flags)
 {
 	u32 temp;
 
-	if (addr == NULL)
+	if (page == NULL)
 		return;
 
 	if (flags & AGP_PAGE_DESTROY_UNMAP) {
@@ -180,9 +180,9 @@ static void m1541_destroy_page(void * addr, int flags)
 		pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
 		pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
 				       (((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
-					 virt_to_gart(addr)) | ALI_CACHE_FLUSH_EN));
+					 phys_to_gart(page_to_phys(page))) | ALI_CACHE_FLUSH_EN));
 	}
-	agp_generic_destroy_page(addr, flags);
+	agp_generic_destroy_page(page, flags);
 }
 
 
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index 3f98254..ba9bde7 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -325,7 +325,7 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = GET_GATT(addr);
 		writel(agp_generic_mask_memory(agp_bridge,
-			mem->memory[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
+			mem->pages[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
 		readl(cur_gatt+GET_GATT_OFF(addr));	/* PCI Posting. */
 	}
 	amd_irongate_tlbflush(mem);
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d765afd..3bf5dda 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -79,7 +79,7 @@ static int amd64_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		tmp = agp_bridge->driver->mask_memory(agp_bridge,
-			mem->memory[i], mask_type);
+			mem->pages[i], mask_type);
 
 		BUG_ON(tmp & 0xffffff0000000ffcULL);
 		pte = (tmp & 0x000000ff00000000ULL) >> 28;
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index f1537ee..4d38baa 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -296,8 +296,9 @@ static int ati_insert_memory(struct agp_memory * mem,
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = GET_GATT(addr);
-		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			mem->memory[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
+		writel(agp_bridge->driver->mask_memory(agp_bridge,	
+						       mem->pages[i], mem->type),
+		       cur_gatt+GET_GATT_OFF(addr));
 		readl(cur_gatt+GET_GATT_OFF(addr));	/* PCI Posting. */
 	}
 	agp_bridge->driver->tlb_flush(mem);
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index 8c617ad..cfa5a64 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -141,17 +141,17 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	bridge->version = &agp_current_version;
 
 	if (bridge->driver->needs_scratch_page) {
-		void *addr = bridge->driver->agp_alloc_page(bridge);
+		struct page *page = bridge->driver->agp_alloc_page(bridge);
 
-		if (!addr) {
+		if (!page) {
 			dev_err(&bridge->dev->dev,
 				"can't get memory for scratch page\n");
 			return -ENOMEM;
 		}
 
-		bridge->scratch_page_real = virt_to_gart(addr);
+		bridge->scratch_page_real = phys_to_gart(page_to_phys(page));
 		bridge->scratch_page =
-		    bridge->driver->mask_memory(bridge, bridge->scratch_page_real, 0);
+		    bridge->driver->mask_memory(bridge, page, 0);
 	}
 
 	size_value = bridge->driver->fetch_size();
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 453543a..35d50f2 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -65,8 +65,9 @@ static const struct gatt_mask efficeon_generic_masks[] =
 };
 
 /* This function does the same thing as mask_memory() for this chipset... */
-static inline unsigned long efficeon_mask_memory(unsigned long addr)
+static inline unsigned long efficeon_mask_memory(struct page *page)
 {
+	unsigned long addr = phys_to_gart(page_to_phys(page));
 	return addr | 0x00000001;
 }
 
@@ -257,7 +258,7 @@ static int efficeon_insert_memory(struct agp_memory * mem, off_t pg_start, int t
 	last_page = NULL;
 	for (i = 0; i < count; i++) {
 		int index = pg_start + i;
-		unsigned long insert = efficeon_mask_memory(mem->memory[i]);
+		unsigned long insert = efficeon_mask_memory(mem->pages[i]);
 
 		page = (unsigned int *) efficeon_private.l1_table[index >> 10];
 
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 2224b76..1e8b461 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -95,13 +95,13 @@ EXPORT_SYMBOL(agp_flush_chipset);
 
 void agp_alloc_page_array(size_t size, struct agp_memory *mem)
 {
-	mem->memory = NULL;
+	mem->pages = NULL;
 	mem->vmalloc_flag = false;
 
 	if (size <= 2*PAGE_SIZE)
-		mem->memory = kmalloc(size, GFP_KERNEL | __GFP_NORETRY);
-	if (mem->memory == NULL) {
-		mem->memory = vmalloc(size);
+		mem->pages = kmalloc(size, GFP_KERNEL | __GFP_NORETRY);
+	if (mem->pages == NULL) {
+		mem->pages = vmalloc(size);
 		mem->vmalloc_flag = true;
 	}
 }
@@ -110,9 +110,9 @@ EXPORT_SYMBOL(agp_alloc_page_array);
 void agp_free_page_array(struct agp_memory *mem)
 {
 	if (mem->vmalloc_flag) {
-		vfree(mem->memory);
+		vfree(mem->pages);
 	} else {
-		kfree(mem->memory);
+		kfree(mem->pages);
 	}
 }
 EXPORT_SYMBOL(agp_free_page_array);
@@ -136,7 +136,7 @@ static struct agp_memory *agp_create_user_memory(unsigned long num_agp_pages)
 
 	agp_alloc_page_array(alloc_size, new);
 
-	if (new->memory == NULL) {
+	if (new->pages == NULL) {
 		agp_free_key(new->key);
 		kfree(new);
 		return NULL;
@@ -162,7 +162,7 @@ struct agp_memory *agp_create_memory(int scratch_pages)
 
 	agp_alloc_page_array(PAGE_SIZE * scratch_pages, new);
 
-	if (new->memory == NULL) {
+	if (new->pages == NULL) {
 		agp_free_key(new->key);
 		kfree(new);
 		return NULL;
@@ -206,15 +206,13 @@ void agp_free_memory(struct agp_memory *curr)
 		} else {
 
 			for (i = 0; i < curr->page_count; i++) {
-				curr->memory[i] = (unsigned long)gart_to_virt(
-					curr->memory[i]);
 				curr->bridge->driver->agp_destroy_page(
-					(void *)curr->memory[i],
+					curr->pages[i],
 					AGP_PAGE_DESTROY_UNMAP);
 			}
 			for (i = 0; i < curr->page_count; i++) {
 				curr->bridge->driver->agp_destroy_page(
-					(void *)curr->memory[i],
+					curr->pages[i],
 					AGP_PAGE_DESTROY_FREE);
 			}
 		}
@@ -282,13 +280,13 @@ struct agp_memory *agp_allocate_memory(struct agp_bridge_data *bridge,
 	}
 
 	for (i = 0; i < page_count; i++) {
-		void *addr = bridge->driver->agp_alloc_page(bridge);
+		struct page *page = bridge->driver->agp_alloc_page(bridge);
 
-		if (addr == NULL) {
+		if (page == NULL) {
 			agp_free_memory(new);
 			return NULL;
 		}
-		new->memory[i] = virt_to_gart(addr);
+		new->pages[i] = page;
 		new->page_count++;
 	}
 	new->bridge = bridge;
@@ -1134,7 +1132,7 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
-		writel(bridge->driver->mask_memory(bridge, mem->memory[i], mask_type),
+		writel(bridge->driver->mask_memory(bridge, mem->pages[i], mask_type),
 		       bridge->gatt_table+j);
 	}
 	readl(bridge->gatt_table+j-1);	/* PCI Posting. */
@@ -1204,7 +1202,7 @@ struct agp_memory *agp_generic_alloc_user(size_t page_count, int type)
 		return NULL;
 
 	for (i = 0; i < page_count; i++)
-		new->memory[i] = 0;
+		new->pages[i] = 0;
 	new->page_count = 0;
 	new->type = type;
 	new->num_scratch_pages = pages;
@@ -1237,23 +1235,20 @@ int agp_generic_alloc_pages(struct agp_bridge_data *bridge, struct agp_memory *m
 		get_page(page);
 		atomic_inc(&agp_bridge->current_memory_agp);
 
-		/* set_memory_array_uc() needs virtual address */
-		mem->memory[i] = (unsigned long)page_address(page);
+		mem->pages[i] = page;
 		mem->page_count++;
 	}
 
 #ifdef CONFIG_X86
-	set_memory_array_uc(mem->memory, num_pages);
+	set_pages_array_uc(mem->pages, num_pages);
 #endif
 	ret = 0;
 out:
-	for (i = 0; i < mem->page_count; i++)
-		mem->memory[i] = virt_to_gart((void *)mem->memory[i]);
 	return ret;
 }
 EXPORT_SYMBOL(agp_generic_alloc_pages);
 
-void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
+struct page *agp_generic_alloc_page(struct agp_bridge_data *bridge)
 {
 	struct page * page;
 
@@ -1265,56 +1260,47 @@ void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
 
 	get_page(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
-	return page_address(page);
+	return page;
 }
 EXPORT_SYMBOL(agp_generic_alloc_page);
 
 void agp_generic_destroy_pages(struct agp_memory *mem)
 {
 	int i;
-	void *addr;
 	struct page *page;
 
 	if (!mem)
 		return;
 
-	for (i = 0; i < mem->page_count; i++)
-		mem->memory[i] = (unsigned long)gart_to_virt(mem->memory[i]);
-
 #ifdef CONFIG_X86
-	set_memory_array_wb(mem->memory, mem->page_count);
+	set_pages_array_wb(mem->pages, mem->page_count);
 #endif
 
 	for (i = 0; i < mem->page_count; i++) {
-		addr = (void *)mem->memory[i];
-		page = virt_to_page(addr);
+		page = mem->pages[i];
 
 #ifndef CONFIG_X86
 		unmap_page_from_agp(page);
 #endif
-
 		put_page(page);
-		free_page((unsigned long)addr);
+		__free_page(page);
 		atomic_dec(&agp_bridge->current_memory_agp);
-		mem->memory[i] = 0;
+		mem->pages[i] = NULL;
 	}
 }
 EXPORT_SYMBOL(agp_generic_destroy_pages);
 
-void agp_generic_destroy_page(void *addr, int flags)
+void agp_generic_destroy_page(struct page *page, int flags)
 {
-	struct page *page;
-
-	if (addr == NULL)
+	if (page == NULL)
 		return;
 
-	page = virt_to_page(addr);
 	if (flags & AGP_PAGE_DESTROY_UNMAP)
 		unmap_page_from_agp(page);
 
 	if (flags & AGP_PAGE_DESTROY_FREE) {
 		put_page(page);
-		free_page((unsigned long)addr);
+		__free_page(page);
 		atomic_dec(&agp_bridge->current_memory_agp);
 	}
 }
@@ -1361,8 +1347,9 @@ void global_cache_flush(void)
 EXPORT_SYMBOL(global_cache_flush);
 
 unsigned long agp_generic_mask_memory(struct agp_bridge_data *bridge,
-	unsigned long addr, int type)
+				      struct page *page, int type)
 {
+	unsigned long addr = phys_to_gart(page_to_phys(page));
 	/* memory type is ignored in the generic routine */
 	if (bridge->driver->masks)
 		return addr | bridge->driver->masks[0].mask;
diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index 183ac3f..abea273 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -361,13 +361,11 @@ hp_zx1_insert_memory (struct agp_memory *mem, off_t pg_start, int type)
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
 		unsigned long paddr;
 
-		paddr = mem->memory[i];
+		paddr = page_to_phys(mem->pages[i]);
 		for (k = 0;
 		     k < hp->io_pages_per_kpage;
 		     k++, j++, paddr += hp->io_page_size) {
-			hp->gatt[j] =
-				agp_bridge->driver->mask_memory(agp_bridge,
-					paddr, type);
+			hp->gatt[j] = HP_ZX1_PDIR_VALID_BIT | paddr;
 		}
 	}
 
@@ -397,8 +395,9 @@ hp_zx1_remove_memory (struct agp_memory *mem, off_t pg_start, int type)
 
 static unsigned long
 hp_zx1_mask_memory (struct agp_bridge_data *bridge,
-	unsigned long addr, int type)
+		    struct page *page, int type)
 {
+	unsigned long addr = phys_to_gart(page_to_phys(page));
 	return HP_ZX1_PDIR_VALID_BIT | addr;
 }
 
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index 10da687..ad1b3df 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -60,6 +60,9 @@
  */
 #define WR_FLUSH_GATT(index)	RD_GATT(index)
 
+static unsigned long i460_mask_memory (struct agp_bridge_data *bridge,
+				       unsigned long addr, int type);
+
 static struct {
 	void *gatt;				/* ioremap'd GATT area */
 
@@ -74,6 +77,7 @@ static struct {
 		unsigned long *alloced_map;	/* bitmap of kernel-pages in use */
 		int refcount;			/* number of kernel pages using the large page */
 		u64 paddr;			/* physical address of large page */
+		struct page *page; 		/* page pointer */
 	} *lp_desc;
 } i460;
 
@@ -294,7 +298,7 @@ static int i460_insert_memory_small_io_page (struct agp_memory *mem,
 	void *temp;
 
 	pr_debug("i460_insert_memory_small_io_page(mem=%p, pg_start=%ld, type=%d, paddr0=0x%lx)\n",
-		 mem, pg_start, type, mem->memory[0]);
+		 mem, pg_start, type, page_to_phys(mem->pages[0]));
 
 	if (type >= AGP_USER_TYPES || mem->type >= AGP_USER_TYPES)
 		return -EINVAL;
@@ -321,10 +325,9 @@ static int i460_insert_memory_small_io_page (struct agp_memory *mem,
 
 	io_page_size = 1UL << I460_IO_PAGE_SHIFT;
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
-		paddr = mem->memory[i];
+		paddr = phys_to_gart(page_to_phys(mem->pages[i]));
 		for (k = 0; k < I460_IOPAGES_PER_KPAGE; k++, j++, paddr += io_page_size)
-			WR_GATT(j, agp_bridge->driver->mask_memory(agp_bridge,
-				paddr, mem->type));
+			WR_GATT(j, i460_mask_memory(agp_bridge, paddr, mem->type));
 	}
 	WR_FLUSH_GATT(j - 1);
 	return 0;
@@ -360,14 +363,13 @@ static int i460_remove_memory_small_io_page(struct agp_memory *mem,
  * i460.lp_desc[pg_num].alloced_map is a bitmap of kernel pages that are in use (allocated).
  */
 
-static int i460_alloc_large_page (struct lp_desc *lp)
+static int i460_alloc_large_page (struct lp_desc *lp, struct page **page)
 {
 	unsigned long order = I460_IO_PAGE_SHIFT - PAGE_SHIFT;
 	size_t map_size;
-	void *lpage;
 
-	lpage = (void *) __get_free_pages(GFP_KERNEL, order);
-	if (!lpage) {
+	lp->page = alloc_pages(GFP_KERNEL, order);
+	if (!lp->page) {
 		printk(KERN_ERR PFX "Couldn't alloc 4M GART page...\n");
 		return -ENOMEM;
 	}
@@ -375,12 +377,12 @@ static int i460_alloc_large_page (struct lp_desc *lp)
 	map_size = ((I460_KPAGES_PER_IOPAGE + BITS_PER_LONG - 1) & -BITS_PER_LONG)/8;
 	lp->alloced_map = kzalloc(map_size, GFP_KERNEL);
 	if (!lp->alloced_map) {
-		free_pages((unsigned long) lpage, order);
+		__free_pages(lp->page, order);
 		printk(KERN_ERR PFX "Out of memory, we're in trouble...\n");
 		return -ENOMEM;
 	}
 
-	lp->paddr = virt_to_gart(lpage);
+	lp->paddr = phys_to_gart(page_to_phys(lp->page));
 	lp->refcount = 0;
 	atomic_add(I460_KPAGES_PER_IOPAGE, &agp_bridge->current_memory_agp);
 	return 0;
@@ -391,7 +393,7 @@ static void i460_free_large_page (struct lp_desc *lp)
 	kfree(lp->alloced_map);
 	lp->alloced_map = NULL;
 
-	free_pages((unsigned long) gart_to_virt(lp->paddr), I460_IO_PAGE_SHIFT - PAGE_SHIFT);
+	__free_pages(lp->page, I460_IO_PAGE_SHIFT - PAGE_SHIFT);
 	atomic_sub(I460_KPAGES_PER_IOPAGE, &agp_bridge->current_memory_agp);
 }
 
@@ -439,8 +441,8 @@ static int i460_insert_memory_large_io_page (struct agp_memory *mem,
 			if (i460_alloc_large_page(lp) < 0)
 				return -ENOMEM;
 			pg = lp - i460.lp_desc;
-			WR_GATT(pg, agp_bridge->driver->mask_memory(agp_bridge,
-				lp->paddr, 0));
+			WR_GATT(pg, i460_mask_memory(agp_bridge,
+						     lp->paddr, 0));
 			WR_FLUSH_GATT(pg);
 		}
 
@@ -448,7 +450,7 @@ static int i460_insert_memory_large_io_page (struct agp_memory *mem,
 		     idx < ((lp == end) ? (end_offset + 1) : I460_KPAGES_PER_IOPAGE);
 		     idx++, i++)
 		{
-			mem->memory[i] = lp->paddr + idx*PAGE_SIZE;
+			mem->pages[i] = lp->page;
 			__set_bit(idx, lp->alloced_map);
 			++lp->refcount;
 		}
@@ -477,7 +479,7 @@ static int i460_remove_memory_large_io_page (struct agp_memory *mem,
 		     idx < ((lp == end) ? (end_offset + 1) : I460_KPAGES_PER_IOPAGE);
 		     idx++, i++)
 		{
-			mem->memory[i] = 0;
+			mem->pages[i] = NULL;
 			__clear_bit(idx, lp->alloced_map);
 			--lp->refcount;
 		}
@@ -544,13 +546,20 @@ static void i460_destroy_page (void *page, int flags)
 #endif /* I460_LARGE_IO_PAGES */
 
 static unsigned long i460_mask_memory (struct agp_bridge_data *bridge,
-	unsigned long addr, int type)
+				       unsigned long addr, int type)
 {
 	/* Make sure the returned address is a valid GATT entry */
 	return bridge->driver->masks[0].mask
 		| (((addr & ~((1 << I460_IO_PAGE_SHIFT) - 1)) & 0xfffff000) >> 12);
 }
 
+static unsigned long i460_page_mask_memory(struct agp_bridge_data *bridge,
+					   sturct page *page, int type)
+{
+	unsigned long addr = phys_to_gart(page_to_phys(page));
+	return i460_mask_memory(bridge, addr, type);
+}
+
 const struct agp_bridge_driver intel_i460_driver = {
 	.owner			= THIS_MODULE,
 	.aperture_sizes		= i460_sizes,
@@ -560,7 +569,7 @@ const struct agp_bridge_driver intel_i460_driver = {
 	.fetch_size		= i460_fetch_size,
 	.cleanup		= i460_cleanup,
 	.tlb_flush		= i460_tlb_flush,
-	.mask_memory		= i460_mask_memory,
+	.mask_memory		= i460_page_mask_memory,
 	.masks			= i460_masks,
 	.agp_enable		= agp_generic_enable,
 	.cache_flush		= global_cache_flush,
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 3686912..5e7720c 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -251,7 +251,7 @@ static void intel_i810_agp_enable(struct agp_bridge_data *bridge, u32 mode)
 }
 
 /* Exists to support ARGB cursors */
-static void *i8xx_alloc_pages(void)
+static struct page *i8xx_alloc_pages(void)
 {
 	struct page *page;
 
@@ -266,17 +266,14 @@ static void *i8xx_alloc_pages(void)
 	}
 	get_page(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
-	return page_address(page);
+	return page;
 }
 
-static void i8xx_destroy_pages(void *addr)
+static void i8xx_destroy_pages(struct page *page)
 {
-	struct page *page;
-
-	if (addr == NULL)
+	if (page == NULL)
 		return;
 
-	page = virt_to_page(addr);
 	set_pages_wb(page, 4);
 	put_page(page);
 	__free_pages(page, 2);
@@ -340,7 +337,7 @@ static int intel_i810_insert_entries(struct agp_memory *mem, off_t pg_start,
 			global_cache_flush();
 		for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 			writel(agp_bridge->driver->mask_memory(agp_bridge,
-							       mem->memory[i],
+							       mem->pages[i],
 							       mask_type),
 			       intel_private.registers+I810_PTE_BASE+(j*4));
 		}
@@ -383,37 +380,37 @@ static int intel_i810_remove_entries(struct agp_memory *mem, off_t pg_start,
 static struct agp_memory *alloc_agpphysmem_i8xx(size_t pg_count, int type)
 {
 	struct agp_memory *new;
-	void *addr;
+	struct page *page;
 
 	switch (pg_count) {
-	case 1: addr = agp_bridge->driver->agp_alloc_page(agp_bridge);
+	case 1: page = agp_bridge->driver->agp_alloc_page(agp_bridge);
 		break;
 	case 4:
 		/* kludge to get 4 physical pages for ARGB cursor */
-		addr = i8xx_alloc_pages();
+		page = i8xx_alloc_pages();
 		break;
 	default:
 		return NULL;
 	}
 
-	if (addr == NULL)
+	if (page == NULL)
 		return NULL;
 
 	new = agp_create_memory(pg_count);
 	if (new == NULL)
 		return NULL;
 
-	new->memory[0] = virt_to_gart(addr);
+	new->pages[0] = page;
 	if (pg_count == 4) {
 		/* kludge to get 4 physical pages for ARGB cursor */
-		new->memory[1] = new->memory[0] + PAGE_SIZE;
-		new->memory[2] = new->memory[1] + PAGE_SIZE;
-		new->memory[3] = new->memory[2] + PAGE_SIZE;
+		new->pages[1] = new->pages[0] + 1;
+		new->pages[2] = new->pages[1] + 1;
+		new->pages[3] = new->pages[2] + 1;
 	}
 	new->page_count = pg_count;
 	new->num_scratch_pages = pg_count;
 	new->type = AGP_PHYS_MEMORY;
-	new->physical = new->memory[0];
+	new->physical = page_to_phys(new->pages[0]);
 	return new;
 }
 
@@ -445,13 +442,11 @@ static void intel_i810_free_by_type(struct agp_memory *curr)
 	agp_free_key(curr->key);
 	if (curr->type == AGP_PHYS_MEMORY) {
 		if (curr->page_count == 4)
-			i8xx_destroy_pages(gart_to_virt(curr->memory[0]));
+			i8xx_destroy_pages(curr->pages[0]);
 		else {
-			void *va = gart_to_virt(curr->memory[0]);
-
-			agp_bridge->driver->agp_destroy_page(va,
+			agp_bridge->driver->agp_destroy_page(curr->pages[0],
 							     AGP_PAGE_DESTROY_UNMAP);
-			agp_bridge->driver->agp_destroy_page(va,
+			agp_bridge->driver->agp_destroy_page(curr->pages[0],
 							     AGP_PAGE_DESTROY_FREE);
 		}
 		agp_free_page_array(curr);
@@ -460,8 +455,9 @@ static void intel_i810_free_by_type(struct agp_memory *curr)
 }
 
 static unsigned long intel_i810_mask_memory(struct agp_bridge_data *bridge,
-	unsigned long addr, int type)
+					    struct page *page, int type)
 {
+	unsigned long addr = phys_to_gart(page_to_phys(page));
 	/* Type checking must be done elsewhere */
 	return addr | bridge->driver->masks[type].mask;
 }
@@ -849,7 +845,7 @@ static int intel_i830_insert_entries(struct agp_memory *mem, off_t pg_start,
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-						       mem->memory[i], mask_type),
+						       mem->pages[i], mask_type),
 		       intel_private.registers+I810_PTE_BASE+(j*4));
 	}
 	readl(intel_private.registers+I810_PTE_BASE+((j-1)*4));
@@ -1079,7 +1075,7 @@ static int intel_i915_insert_entries(struct agp_memory *mem, off_t pg_start,
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			mem->memory[i], mask_type), intel_private.gtt+j);
+						       mem->pages[i], mask_type), intel_private.gtt+j);
 	}
 
 	readl(intel_private.gtt+j-1);
@@ -1194,8 +1190,9 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
  * this conditional.
  */
 static unsigned long intel_i965_mask_memory(struct agp_bridge_data *bridge,
-	unsigned long addr, int type)
+					    struct page *page, int type)
 {
+	unsigned long addr = phys_to_gart(page_to_phys(page));
 	/* Shift high bits down */
 	addr |= (addr >> 28) & 0xf0;
 
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index 16acee2..263d71d 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -225,7 +225,7 @@ static int nvidia_insert_memory(struct agp_memory *mem, off_t pg_start, int type
 	}
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			mem->memory[i], mask_type),
+			mem->pages[i], mask_type),
 			agp_bridge->gatt_table+nvidia_private.pg_offset+j);
 	}
 
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 699e342..f4bb43f 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -31,6 +31,10 @@
 #define AGP8X_MODE_BIT		3
 #define AGP8X_MODE		(1 << AGP8X_MODE_BIT)
 
+static unsigned long
+parisc_agp_mask_memory(struct agp_bridge_data *bridge, unsigned long addr,
+		       int type);
+
 static struct _parisc_agp_info {
 	void __iomem *ioc_regs;
 	void __iomem *lba_regs;
@@ -149,12 +153,12 @@ parisc_agp_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
 		unsigned long paddr;
 
-		paddr = mem->memory[i];
+		paddr = page_to_phys(mem->pages[i]);
 		for (k = 0;
 		     k < info->io_pages_per_kpage;
 		     k++, j++, paddr += info->io_page_size) {
 			info->gatt[j] =
-				agp_bridge->driver->mask_memory(agp_bridge,
+				parisc_agp_mask_memory(agp_bridge,
 					paddr, type);
 		}
 	}
@@ -185,9 +189,17 @@ parisc_agp_remove_memory(struct agp_memory *mem, off_t pg_start, int type)
 }
 
 static unsigned long
-parisc_agp_mask_memory(struct agp_bridge_data *bridge,
-		    unsigned long addr, int type)
+parisc_agp_mask_memory(struct agp_bridge_data *bridge, unsigned long addr,
+		       int type)
+{
+	return SBA_PDIR_VALID_BIT | addr;
+}
+
+static unsigned long
+parisc_agp_page_mask_memory(struct agp_bridge_data *bridge, struct page *page,
+			    int type)
 {
+	unsigned long addr = phys_to_gart(page_to_phys(page));
 	return SBA_PDIR_VALID_BIT | addr;
 }
 
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index b972d83..b3704e8 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -71,8 +71,9 @@ static void sgi_tioca_tlbflush(struct agp_memory *mem)
  */
 static unsigned long
 sgi_tioca_mask_memory(struct agp_bridge_data *bridge,
-		      unsigned long addr, int type)
+		      struct page *page, int type)
 {
+	unsigned long addr = phys_to_gart(page_to_phys(page));
 	return tioca_physpage_to_gart(addr);
 }
 
@@ -189,7 +190,7 @@ static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		table[j] =
-		    bridge->driver->mask_memory(bridge, mem->memory[i],
+		    bridge->driver->mask_memory(bridge, mem->pages[i],
 						mem->type);
 	}
 
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 6224df8..b964a21 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -349,7 +349,7 @@ static int serverworks_insert_memory(struct agp_memory *mem,
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = SVRWRKS_GET_GATT(addr);
-		writel(agp_bridge->driver->mask_memory(agp_bridge, mem->memory[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
+		writel(agp_bridge->driver->mask_memory(agp_bridge, mem->pages[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
 	}
 	serverworks_tlbflush(mem);
 	return 0;
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index 03f95ec..596e1d4 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -166,9 +166,9 @@ static int uninorth_insert_memory(struct agp_memory *mem, off_t pg_start,
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		agp_bridge->gatt_table[j] =
-		    cpu_to_le32((mem->memory[i] & 0xFFFFF000UL) | 0x1UL);
-		flush_dcache_range((unsigned long)__va(mem->memory[i]),
-				   (unsigned long)__va(mem->memory[i])+0x1000);
+			cpu_to_le32((page_to_phys(mem->pages[i]) & 0xFFFFF000UL) | 0x1UL);
+		flush_dcache_range((unsigned long)__va(page_to_phys(mem->pages[i])),
+				   (unsigned long)__va(page_to_phys(mem->pages[i]))+0x1000);
 	}
 	(void)in_le32((volatile u32*)&agp_bridge->gatt_table[pg_start]);
 	mb();
@@ -205,9 +205,9 @@ static int u3_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 	}
 
 	for (i = 0; i < mem->page_count; i++) {
-		gp[i] = (mem->memory[i] >> PAGE_SHIFT) | 0x80000000UL;
-		flush_dcache_range((unsigned long)__va(mem->memory[i]),
-				   (unsigned long)__va(mem->memory[i])+0x1000);
+		gp[i] = (page_to_phys(mem->pages[i]) >> PAGE_SHIFT) | 0x80000000UL;
+		flush_dcache_range((unsigned long)__va(page_to_phys(mem->pages[i])),
+				   (unsigned long)__va(page_to_phys(mem->pages[i]))+0x1000);
 	}
 	mb();
 	flush_dcache_range((unsigned long)gp, (unsigned long) &gp[i]);
diff --git a/drivers/gpu/drm/drm_agpsupport.c b/drivers/gpu/drm/drm_agpsupport.c
index 1479659..bca3b6f 100644
--- a/drivers/gpu/drm/drm_agpsupport.c
+++ b/drivers/gpu/drm/drm_agpsupport.c
@@ -482,7 +482,7 @@ drm_agp_bind_pages(struct drm_device *dev,
 	}
 
 	for (i = 0; i < num_pages; i++)
-		mem->memory[i] = phys_to_gart(page_to_phys(pages[i]));
+		mem->pages[i] = pages[i];
 	mem->page_count = num_pages;
 
 	mem->is_flushed = true;
diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
index 0c707f5..a64587e 100644
--- a/drivers/gpu/drm/drm_memory.c
+++ b/drivers/gpu/drm/drm_memory.c
@@ -82,10 +82,11 @@ void *drm_realloc(void *oldpt, size_t oldsize, size_t size, int area)
 static void *agp_remap(unsigned long offset, unsigned long size,
 		       struct drm_device * dev)
 {
-	unsigned long *phys_addr_map, i, num_pages =
+	unsigned long i, num_pages =
 	    PAGE_ALIGN(size) / PAGE_SIZE;
 	struct drm_agp_mem *agpmem;
 	struct page **page_map;
+	struct page **phys_page_map;
 	void *addr;
 
 	size = PAGE_ALIGN(size);
@@ -112,10 +113,9 @@ static void *agp_remap(unsigned long offset, unsigned long size,
 	if (!page_map)
 		return NULL;
 
-	phys_addr_map =
-	    agpmem->memory->memory + (offset - agpmem->bound) / PAGE_SIZE;
+	phys_page_map = (agpmem->memory->pages + (offset - agpmem->bound) / PAGE_SIZE);
 	for (i = 0; i < num_pages; ++i)
-		page_map[i] = pfn_to_page(phys_addr_map[i] >> PAGE_SHIFT);
+		page_map[i] = phys_page_map[i];
 	addr = vmap(page_map, num_pages, VM_IOREMAP, PAGE_AGP);
 	vfree(page_map);
 
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 22f7656..1302ab6 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -144,14 +144,14 @@ static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		 * Get the page, inc the use count, and return it
 		 */
 		offset = (baddr - agpmem->bound) >> PAGE_SHIFT;
-		page = virt_to_page(__va(agpmem->memory->memory[offset]));
+		page = agpmem->memory->pages[offset];
 		get_page(page);
 		vmf->page = page;
 
 		DRM_DEBUG
 		    ("baddr = 0x%llx page = 0x%p, offset = 0x%llx, count=%d\n",
 		     (unsigned long long)baddr,
-		     __va(agpmem->memory->memory[offset]),
+		     agpmem->memory->pages[offset],
 		     (unsigned long long)offset,
 		     page_count(page));
 		return 0;
diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index 2b8df8b..76fa794 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -70,7 +70,7 @@ struct agp_memory {
 	struct agp_memory *next;
 	struct agp_memory *prev;
 	struct agp_bridge_data *bridge;
-	unsigned long *memory;
+	struct page **pages;
 	size_t page_count;
 	int key;
 	int num_scratch_pages;
-- 
1.5.4.1

