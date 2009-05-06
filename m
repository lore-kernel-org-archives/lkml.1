Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZEFOyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZEFOyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbZEFOt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:27 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50114 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760088AbZEFOs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:59 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 6/19] TuxOnIce: Make functions and variables shared with swsusp non-static
Date: Thu,  7 May 2009 00:39:02 +1000
Message-Id: <1241620755-22133-7-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TuxOnIce shares the resume_file and restore_pblists with swsusp, and
also uses the saveable_[highmem_]page functions, struct nosave_region,
memory bitmap functions and header struct functions. Make all of these
non-static and move the memory bitmap definition to kernel/power/power.h
for this purpose.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/disk.c     |   20 +++++-----
 kernel/power/power.h    |   87 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/snapshot.c |   69 +++++++------------------------------
 3 files changed, 110 insertions(+), 66 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index e71ca9c..e4b1166 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -29,7 +29,7 @@
 
 
 static int noresume = 0;
-static char resume_file[256] = CONFIG_PM_STD_PARTITION;
+char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
@@ -115,7 +115,7 @@ static int hibernation_test(int level) { return 0; }
  *	hibernation
  */
 
-static int platform_begin(int platform_mode)
+int platform_begin(int platform_mode)
 {
 	return (platform_mode && hibernation_ops) ?
 		hibernation_ops->begin() : 0;
@@ -126,7 +126,7 @@ static int platform_begin(int platform_mode)
  *	working state
  */
 
-static void platform_end(int platform_mode)
+void platform_end(int platform_mode)
 {
 	if (platform_mode && hibernation_ops)
 		hibernation_ops->end();
@@ -137,7 +137,7 @@ static void platform_end(int platform_mode)
  *	platform driver if so configured and return an error code if it fails
  */
 
-static int platform_pre_snapshot(int platform_mode)
+int platform_pre_snapshot(int platform_mode)
 {
 	return (platform_mode && hibernation_ops) ?
 		hibernation_ops->pre_snapshot() : 0;
@@ -148,7 +148,7 @@ static int platform_pre_snapshot(int platform_mode)
  *	of operation using the platform driver (called with interrupts disabled)
  */
 
-static void platform_leave(int platform_mode)
+void platform_leave(int platform_mode)
 {
 	if (platform_mode && hibernation_ops)
 		hibernation_ops->leave();
@@ -159,7 +159,7 @@ static void platform_leave(int platform_mode)
  *	using the platform driver (must be called after platform_prepare())
  */
 
-static void platform_finish(int platform_mode)
+void platform_finish(int platform_mode)
 {
 	if (platform_mode && hibernation_ops)
 		hibernation_ops->finish();
@@ -171,7 +171,7 @@ static void platform_finish(int platform_mode)
  *	called, platform_restore_cleanup() must be called.
  */
 
-static int platform_pre_restore(int platform_mode)
+int platform_pre_restore(int platform_mode)
 {
 	return (platform_mode && hibernation_ops) ?
 		hibernation_ops->pre_restore() : 0;
@@ -184,7 +184,7 @@ static int platform_pre_restore(int platform_mode)
  *	regardless of the result of platform_pre_restore().
  */
 
-static void platform_restore_cleanup(int platform_mode)
+void platform_restore_cleanup(int platform_mode)
 {
 	if (platform_mode && hibernation_ops)
 		hibernation_ops->restore_cleanup();
@@ -195,7 +195,7 @@ static void platform_restore_cleanup(int platform_mode)
  *	devices.
  */
 
-static void platform_recover(int platform_mode)
+void platform_recover(int platform_mode)
 {
 	if (platform_mode && hibernation_ops && hibernation_ops->recover)
 		hibernation_ops->recover();
@@ -634,7 +634,7 @@ int hibernate(void)
  *
  */
 
-static int software_resume(void)
+int software_resume(void)
 {
 	int error;
 	unsigned int flags;
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 46b5ec7..ce81df1 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -31,8 +31,12 @@ static inline char *check_image_kernel(struct swsusp_info *info)
 	return arch_hibernation_header_restore(info) ?
 			"architecture specific data" : NULL;
 }
+#else
+extern char *check_image_kernel(struct swsusp_info *info);
 #endif /* CONFIG_ARCH_HIBERNATION_HEADER */
+extern int init_header(struct swsusp_info *info);
 
+extern char resume_file[256];
 /*
  * Keep some memory free so that I/O operations can succeed without paging
  * [Might this be more than 4 MB?]
@@ -49,6 +53,7 @@ static inline char *check_image_kernel(struct swsusp_info *info)
 extern int hibernation_snapshot(int platform_mode);
 extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
+extern void platform_recover(int platform_mode);
 #endif
 
 extern int pfn_is_nosave(unsigned long);
@@ -63,6 +68,8 @@ static struct kobj_attribute _name##_attr = {	\
 	.store	= _name##_store,		\
 }
 
+extern struct pbe *restore_pblist;
+
 /* Preferred image size in bytes (default 500 MB) */
 extern unsigned long image_size;
 extern int in_suspend;
@@ -223,3 +230,83 @@ static inline void suspend_thaw_processes(void)
 {
 }
 #endif
+
+extern struct page *saveable_page(struct zone *z, unsigned long p);
+#ifdef CONFIG_HIGHMEM
+extern struct page *saveable_highmem_page(struct zone *z, unsigned long p);
+#else
+static
+inline struct page *saveable_highmem_page(struct zone *z, unsigned long p)
+{
+	return NULL;
+}
+#endif
+
+#define PBES_PER_PAGE (PAGE_SIZE / sizeof(struct pbe))
+extern struct list_head nosave_regions;
+
+/**
+ *	This structure represents a range of page frames the contents of which
+ *	should not be saved during the suspend.
+ */
+
+struct nosave_region {
+	struct list_head list;
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+};
+
+#ifndef PHYS_PFN_OFFSET
+#define PHYS_PFN_OFFSET 0
+#endif
+
+#define ZONE_START(thiszone) ((thiszone)->zone_start_pfn - PHYS_PFN_OFFSET)
+
+#define BM_END_OF_MAP	(~0UL)
+
+#define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
+
+struct bm_block {
+	struct list_head hook;		/* hook into a list of bitmap blocks */
+	unsigned long start_pfn;	/* pfn represented by the first bit */
+	unsigned long end_pfn;	/* pfn represented by the last bit plus 1 */
+	unsigned long *data;	/* bitmap representing pages */
+};
+
+/* struct bm_position is used for browsing memory bitmaps */
+
+struct bm_position {
+	struct bm_block *block;
+	int bit;
+};
+
+struct memory_bitmap {
+	struct list_head blocks;	/* list of bitmap blocks */
+	struct linked_page *p_list;	/* list of pages used to store zone
+					 * bitmap objects and bitmap block
+					 * objects
+					 */
+	struct bm_position cur;		/* most recently used bit position */
+};
+
+extern int memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask,
+		int safe_needed);
+extern void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free);
+extern void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn);
+extern void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn);
+extern int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn);
+extern unsigned long memory_bm_next_pfn(struct memory_bitmap *bm);
+extern void memory_bm_position_reset(struct memory_bitmap *bm);
+extern void memory_bm_clear(struct memory_bitmap *bm);
+extern void memory_bm_copy(struct memory_bitmap *source,
+		struct memory_bitmap *dest);
+extern void memory_bm_dup(struct memory_bitmap *source,
+		struct memory_bitmap *dest);
+
+#ifdef CONFIG_TOI
+struct toi_module_ops;
+extern int memory_bm_read(struct memory_bitmap *bm, int (*rw_chunk)
+	(int rw, struct toi_module_ops *owner, char *buffer, int buffer_size));
+extern int memory_bm_write(struct memory_bitmap *bm, int (*rw_chunk)
+	(int rw, struct toi_module_ops *owner, char *buffer, int buffer_size));
+#endif
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 33e2e4a..8020644 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -223,48 +223,19 @@ static void *chain_alloc(struct chain_allocator *ca, unsigned int size)
  *	the represented memory area.
  */
 
-#define BM_END_OF_MAP	(~0UL)
-
-#define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
-
-struct bm_block {
-	struct list_head hook;	/* hook into a list of bitmap blocks */
-	unsigned long start_pfn;	/* pfn represented by the first bit */
-	unsigned long end_pfn;	/* pfn represented by the last bit plus 1 */
-	unsigned long *data;	/* bitmap representing pages */
-};
-
 static inline unsigned long bm_block_bits(struct bm_block *bb)
 {
 	return bb->end_pfn - bb->start_pfn;
 }
 
-/* strcut bm_position is used for browsing memory bitmaps */
-
-struct bm_position {
-	struct bm_block *block;
-	int bit;
-};
-
-struct memory_bitmap {
-	struct list_head blocks;	/* list of bitmap blocks */
-	struct linked_page *p_list;	/* list of pages used to store zone
-					 * bitmap objects and bitmap block
-					 * objects
-					 */
-	struct bm_position cur;	/* most recently used bit position */
-};
-
 /* Functions that operate on memory bitmaps */
 
-static void memory_bm_position_reset(struct memory_bitmap *bm)
+void memory_bm_position_reset(struct memory_bitmap *bm)
 {
 	bm->cur.block = list_entry(bm->blocks.next, struct bm_block, hook);
 	bm->cur.bit = 0;
 }
 
-static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free);
-
 /**
  *	create_bm_block_list - create a list of block bitmap objects
  *	@nr_blocks - number of blocks to allocate
@@ -371,7 +342,7 @@ static int create_mem_extents(struct list_head *list, gfp_t gfp_mask)
 /**
   *	memory_bm_create - allocate memory for a memory bitmap
   */
-static int
+int
 memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
 {
 	struct chain_allocator ca;
@@ -431,7 +402,7 @@ memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
 /**
   *	memory_bm_free - free memory occupied by the memory bitmap @bm
   */
-static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free)
+void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free)
 {
 	struct bm_block *bb;
 
@@ -481,7 +452,7 @@ static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
 	return 0;
 }
 
-static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
+void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
@@ -504,7 +475,7 @@ static int mem_bm_set_bit_check(struct memory_bitmap *bm, unsigned long pfn)
 	return error;
 }
 
-static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
+void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
@@ -515,7 +486,7 @@ static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
 	clear_bit(bit, addr);
 }
 
-static int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn)
+int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
@@ -543,7 +514,7 @@ static bool memory_bm_pfn_present(struct memory_bitmap *bm, unsigned long pfn)
  *	this function.
  */
 
-static unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
+unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
 {
 	struct bm_block *bb;
 	int bit;
@@ -568,18 +539,9 @@ static unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
 	return bb->start_pfn + bit;
 }
 
-/**
- *	This structure represents a range of page frames the contents of which
- *	should not be saved during the suspend.
- */
 
-struct nosave_region {
-	struct list_head list;
-	unsigned long start_pfn;
-	unsigned long end_pfn;
-};
 
-static LIST_HEAD(nosave_regions);
+LIST_HEAD(nosave_regions);
 
 /**
  *	register_nosave_region - register a range of page frames the contents
@@ -815,7 +777,7 @@ static unsigned int count_free_highmem_pages(void)
  *	We should save the page if it isn't Nosave or NosaveFree, or Reserved,
  *	and it isn't a part of a free chunk of pages.
  */
-static struct page *saveable_highmem_page(struct zone *zone, unsigned long pfn)
+struct page *saveable_highmem_page(struct zone *zone, unsigned long pfn)
 {
 	struct page *page;
 
@@ -859,11 +821,6 @@ unsigned int count_highmem_pages(void)
 	}
 	return n;
 }
-#else
-static inline void *saveable_highmem_page(struct zone *z, unsigned long p)
-{
-	return NULL;
-}
 #endif /* CONFIG_HIGHMEM */
 
 /**
@@ -874,7 +831,7 @@ static inline void *saveable_highmem_page(struct zone *z, unsigned long p)
  *	of pages statically defined as 'unsaveable', and it isn't a part of
  *	a free chunk of pages.
  */
-static struct page *saveable_page(struct zone *zone, unsigned long pfn)
+struct page *saveable_page(struct zone *zone, unsigned long pfn)
 {
 	struct page *page;
 
@@ -1250,14 +1207,14 @@ asmlinkage int swsusp_save(void)
 }
 
 #ifndef CONFIG_ARCH_HIBERNATION_HEADER
-static int init_header_complete(struct swsusp_info *info)
+int init_header_complete(struct swsusp_info *info)
 {
 	memcpy(&info->uts, init_utsname(), sizeof(struct new_utsname));
 	info->version_code = LINUX_VERSION_CODE;
 	return 0;
 }
 
-static char *check_image_kernel(struct swsusp_info *info)
+char *check_image_kernel(struct swsusp_info *info)
 {
 	if (info->version_code != LINUX_VERSION_CODE)
 		return "kernel version";
@@ -1278,7 +1235,7 @@ unsigned long snapshot_get_image_size(void)
 	return nr_copy_pages + nr_meta_pages + 1;
 }
 
-static int init_header(struct swsusp_info *info)
+int init_header(struct swsusp_info *info)
 {
 	memset(info, 0, sizeof(struct swsusp_info));
 	info->num_physpages = num_physpages;
-- 
1.5.6.3

