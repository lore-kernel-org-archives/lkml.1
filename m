Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZGGQUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZGGQUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZGGQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:20:24 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59329 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608AbZGGQUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:20:21 -0400
MIME-Version: 1.0
Message-ID: <6613609f-3a50-4a03-a0ac-88a69ee66c7e@default>
Date: Tue, 7 Jul 2009 09:18:28 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [RFC PATCH 3/4] (Take 2): tmem: Implement preswap on top of tmem
 layer
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A537582.029F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tmem [PATCH 3/4] (Take 2): Implement preswap on top of tmem layer.

Hooks added to existing page swap routines
and data structures to:
1) create a tmem pool when any swap "type" is created (one pool
   covers all open swap types)
2) attempt to "put" pages to preswap prior to writing to a swap disk
   and fallback to writing to swap disk if put fails
3) track successfully put pages with a new bit-per-page preswap_map
   array
4) "get" pages from preswap if preswap_map indicates
5) destroy the tmem pool when no more swap types are in use
6) implement "shrinking" to repatriate pages from preswap into
   the swap cache (or purge entirely if no longer needed)
7) Provide a sysctl interface to support both userland shrinking
   and determine number of pages currently in preswap

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>


 include/linux/swap.h                     |   57 ++++
 include/linux/sysctl.h                   |    1 
 kernel/sysctl.c                          |   12 
 mm/Kconfig                               |    8 
 mm/Makefile                              |    1 
 mm/page_io.c                             |   12 
 mm/preswap.c                             |  273 +++++++++++++++++++++
 mm/swapfile.c                            |   46 +++
 8 files changed, 404 insertions(+), 6 deletions(-)

--- linux-2.6.30/mm/page_io.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/mm/page_io.c	2009-06-19 09:33:59.000000000 -0600
@@ -102,6 +102,12 @@ int swap_writepage(struct page *page, st
 		unlock_page(page);
 		goto out;
 	}
+	if (preswap_put(page) == 1) {
+		set_page_writeback(page);
+		unlock_page(page);
+		end_page_writeback(page);
+		goto out;
+	}
 	bio = get_swap_bio(GFP_NOIO, page_private(page), page,
 				end_swap_bio_write);
 	if (bio == NULL) {
@@ -134,6 +140,12 @@ int swap_readpage(struct file *file, str
 		ret = -ENOMEM;
 		goto out;
 	}
+	if (preswap_get(page) == 1) {
+		SetPageUptodate(page);
+		unlock_page(page);
+		bio_put(bio);
+		goto out;
+	}
 	count_vm_event(PSWPIN);
 	submit_bio(READ, bio);
 out:
--- linux-2.6.30/mm/swapfile.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/mm/swapfile.c	2009-06-24 12:08:54.000000000 -0600
@@ -35,7 +35,7 @@
 #include <linux/swapops.h>
 #include <linux/page_cgroup.h>
 
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 long nr_swap_pages;
 long total_swap_pages;
@@ -47,7 +47,7 @@ static const char Unused_file[] = "Unuse
 static const char Bad_offset[] = "Bad swap offset entry ";
 static const char Unused_offset[] = "Unused swap offset entry ";
 
-static struct swap_list_t swap_list = {-1, -1};
+struct swap_list_t swap_list = {-1, -1};
 
 static struct swap_info_struct swap_info[MAX_SWAPFILES];
 
@@ -488,6 +488,7 @@ static int swap_entry_free(struct swap_i
 				swap_list.next = p - swap_info;
 			nr_swap_pages++;
 			p->inuse_pages--;
+			preswap_flush(p - swap_info, offset);
 			mem_cgroup_uncharge_swap(ent);
 		}
 	}
@@ -864,7 +865,7 @@ static int unuse_mm(struct mm_struct *mm
  * Recycle to start on reaching the end, returning 0 when empty.
  */
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
-					unsigned int prev)
+				unsigned int prev, unsigned int preswap)
 {
 	unsigned int max = si->max;
 	unsigned int i = prev;
@@ -890,6 +891,12 @@ static unsigned int find_next_to_unuse(s
 			prev = 0;
 			i = 1;
 		}
+		if (preswap) {
+			if (preswap_test(si, i))
+				break;
+			else
+				continue;
+		}
 		count = si->swap_map[i];
 		if (count && count != SWAP_MAP_BAD)
 			break;
@@ -901,8 +908,12 @@ static unsigned int find_next_to_unuse(s
  * We completely avoid races by reading each swap page in advance,
  * and then search for the process using it.  All the necessary
  * page table adjustments can then be made atomically.
+ *
+ * if the boolean preswap is true, only unuse pages_to_unuse pages;
+ * pages_to_unuse==0 means all pages
  */
-static int try_to_unuse(unsigned int type)
+int try_to_unuse(unsigned int type, unsigned int preswap,
+		unsigned long pages_to_unuse)
 {
 	struct swap_info_struct * si = &swap_info[type];
 	struct mm_struct *start_mm;
@@ -938,7 +949,7 @@ static int try_to_unuse(unsigned int typ
 	 * one pass through swap_map is enough, but not necessarily:
 	 * there are races when an instance of an entry might be missed.
 	 */
-	while ((i = find_next_to_unuse(si, i)) != 0) {
+	while ((i = find_next_to_unuse(si, i, preswap)) != 0) {
 		if (signal_pending(current)) {
 			retval = -EINTR;
 			break;
@@ -1124,6 +1135,8 @@ static int try_to_unuse(unsigned int typ
 		 * interactive performance.
 		 */
 		cond_resched();
+		if (preswap && pages_to_unuse && !--pages_to_unuse)
+			break;
 	}
 
 	mmput(start_mm);
@@ -1448,7 +1461,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_unlock(&swap_lock);
 
 	current->flags |= PF_SWAPOFF;
-	err = try_to_unuse(type);
+	err = try_to_unuse(type, 0, 0);
 	current->flags &= ~PF_SWAPOFF;
 
 	if (err) {
@@ -1497,6 +1510,11 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
 	p->flags = 0;
+	preswap_flush_area(p - swap_info);
+#ifdef CONFIG_PRESWAP
+	if (p->preswap_map)
+		vfree(p->preswap_map);
+#endif
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
@@ -1886,6 +1904,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 	} else {
 		swap_info[prev].next = p - swap_info;
 	}
+#ifdef CONFIG_PRESWAP
+	p->preswap_map = vmalloc(maxpages / sizeof(long));
+	if (p->preswap_map)
+		memset(p->preswap_map, 0, maxpages / sizeof(long));
+#endif
+	preswap_init(p - swap_info);
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	error = 0;
@@ -2008,6 +2032,10 @@ int valid_swaphandles(swp_entry_t entry,
 		base++;
 
 	spin_lock(&swap_lock);
+	if (preswap_test(si, target)) {
+		spin_unlock(&swap_lock);
+		return 0;
+	}
 	if (end > si->max)	/* don't go beyond end of map */
 		end = si->max;
 
@@ -2018,6 +2046,9 @@ int valid_swaphandles(swp_entry_t entry,
 			break;
 		if (si->swap_map[toff] == SWAP_MAP_BAD)
 			break;
+		/* Don't read in preswap pages */
+		if (preswap_test(si, toff))
+			break;
 	}
 	/* Count contiguous allocated slots below our target */
 	for (toff = target; --toff >= base; nr_pages++) {
@@ -2026,6 +2057,9 @@ int valid_swaphandles(swp_entry_t entry,
 			break;
 		if (si->swap_map[toff] == SWAP_MAP_BAD)
 			break;
+		/* Don't read in preswap pages */
+		if (preswap_test(si, toff))
+			break;
 	}
 	spin_unlock(&swap_lock);
 
--- linux-2.6.30/include/linux/swap.h	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/include/linux/swap.h	2009-06-19 12:51:55.000000000 -0600
@@ -8,6 +8,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
 #include <linux/node.h>
+#include <linux/vmalloc.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -154,8 +155,62 @@ struct swap_info_struct {
 	unsigned int max;
 	unsigned int inuse_pages;
 	unsigned int old_block_size;
+#ifdef CONFIG_PRESWAP
+	unsigned long *preswap_map;
+	unsigned int preswap_pages;
+#endif
 };
 
+#ifdef CONFIG_PRESWAP
+
+#include <linux/sysctl.h>
+extern int preswap_sysctl_handler(struct ctl_table *, int, struct file *,
+	void __user *, size_t *, loff_t *);
+extern const unsigned long preswap_zero, preswap_infinity;
+
+extern void preswap_shrink(unsigned long);
+extern int preswap_test(struct swap_info_struct *, unsigned long);
+extern void preswap_init(unsigned);
+extern int preswap_put(struct page *);
+extern int preswap_get(struct page *);
+extern void preswap_flush(unsigned, unsigned long);
+extern void preswap_flush_area(unsigned);
+/* in swapfile.c */
+extern int try_to_unuse(unsigned int, unsigned int, unsigned long);
+#else
+static inline void preswap_shrink(unsigned long target_pages)
+{
+}
+
+static inline int preswap_test(struct swap_info_struct *sis,
+	unsigned long offset)
+{
+	return 0;
+}
+
+static inline void preswap_init(unsigned type)
+{
+}
+
+static inline int preswap_put(struct page *page)
+{
+	return 0;
+}
+
+static inline int preswap_get(struct page *page)
+{
+	return 0;
+}
+
+static inline void preswap_flush(unsigned type, unsigned long offset)
+{
+}
+
+static inline void preswap_flush_area(unsigned type)
+{
+}
+#endif /* CONFIG_PRESWAP */
+
 struct swap_list_t {
 	int head;	/* head of priority-ordered swapfile list */
 	int next;	/* swapfile to be used next */
@@ -312,6 +367,8 @@ extern struct swap_info_struct *get_swap
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
+extern struct swap_list_t swap_list;
+extern spinlock_t swap_lock;
 
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
--- linux-2.6.30/mm/preswap.c	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.30-tmem/mm/preswap.c	2009-06-23 09:22:48.000000000 -0600
@@ -0,0 +1,273 @@
+/*
+ * linux/mm/preswap.c
+ *
+ * Implements a fast "preswap" on top of the transcendent memory ("tmem") API.
+ * When a swapdisk is enabled (with swapon), a "private persistent tmem pool"
+ * is created along with a bit-per-page preswap_map.  When swapping occurs
+ * and a page is about to be written to disk, a "put" into the pool may first
+ * be attempted by passing the pageframe to be swapped, along with a "handle"
+ * consisting of a pool_id, an object id, and an index.  Since the pool is of
+ * indeterminate size, the "put" may be rejected, in which case the page
+ * is swapped to disk as normal.  If the "put" is successful, the page is
+ * copied to tmem and the preswap_map records the success.  Later, when
+ * the page needs to be swapped in, the preswap_map is checked and, if set,
+ * the page may be obtained with a "get" operation.  Note that the swap
+ * subsystem is responsible for: maintaining coherency between the swapcache,
+ * preswap, and the swapdisk; for evicting stale pages from preswap; and for
+ * emptying preswap when swapoff is performed. The "flush page" and "flush
+ * object" actions are provided for this.
+ *
+ * Note that if a "duplicate put" is performed to overwrite a page and
+ * the "put" operation fails, the page (and old data) is flushed and lost.
+ * Also note that multiple accesses to a tmem pool may be concurrent and
+ * any ordering must be guaranteed by the caller.
+ *
+ * Copyright (C) 2008,2009 Dan Magenheimer, Oracle Corp.
+ */
+
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/sysctl.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+#include <linux/proc_fs.h>
+#include <linux/security.h>
+#include <linux/capability.h>
+#include <linux/uaccess.h>
+#include <linux/tmem.h>
+
+static u32 preswap_poolid = -1; /* if negative, preswap will never call tmem */
+
+const unsigned long preswap_zero = 0, preswap_infinity = ~0UL; /* for sysctl */
+
+/*
+ * Swizzling increases objects per swaptype, increasing tmem concurrency
+ * for heavy swaploads.  Later, larger nr_cpus -> larger SWIZ_BITS
+ */
+#define SWIZ_BITS		4
+#define SWIZ_MASK		((1 << SWIZ_BITS) - 1)
+#define oswiz(_type, _ind)	((_type << SWIZ_BITS) | (_ind & SWIZ_MASK))
+#define iswiz(_ind)		(_ind >> SWIZ_BITS)
+
+/*
+ * preswap_map test/set/clear operations (must be atomic)
+ */
+
+int preswap_test(struct swap_info_struct *sis, unsigned long offset)
+{
+	if (!sis->preswap_map)
+		return 0;
+	return test_bit(offset % BITS_PER_LONG,
+		&sis->preswap_map[offset/BITS_PER_LONG]);
+}
+
+static inline void preswap_set(struct swap_info_struct *sis,
+				unsigned long offset)
+{
+	if (!sis->preswap_map)
+		return;
+	set_bit(offset % BITS_PER_LONG,
+		&sis->preswap_map[offset/BITS_PER_LONG]);
+}
+
+static inline void preswap_clear(struct swap_info_struct *sis,
+				unsigned long offset)
+{
+	if (!sis->preswap_map)
+		return;
+	clear_bit(offset % BITS_PER_LONG,
+		&sis->preswap_map[offset/BITS_PER_LONG]);
+}
+
+/*
+ * preswap tmem operations
+ */
+
+/* returns 1 if the page was successfully put into preswap, 0 if the page
+ * was declined, and -ERRNO for a specific error */
+int preswap_put(struct page *page)
+{
+	swp_entry_t entry = { .val = page_private(page), };
+	unsigned type = swp_type(entry);
+	pgoff_t offset = swp_offset(entry);
+	u64 ind64 = (u64)offset;
+	u32 ind = (u32)offset;
+	unsigned long pfn = page_to_pfn(page);
+	struct swap_info_struct *sis = get_swap_info_struct(type);
+	int dup = 0, ret;
+
+	if ((s32)preswap_poolid < 0)
+		return 0;
+	if (ind64 != ind)
+		return 0;
+	if (preswap_test(sis, offset))
+		dup = 1;
+	mb(); /* ensure page is quiescent; tmem may address it with an alias */
+	ret = tmem_put_page(preswap_poolid, oswiz(type, ind),
+		iswiz(ind), pfn);
+	if (ret == 1) {
+		preswap_set(sis, offset);
+		if (!dup)
+			sis->preswap_pages++;
+	} else if (dup) {
+		/* failed dup put always results in an automatic flush of
+		 * the (older) page from preswap */
+		preswap_clear(sis, offset);
+		sis->preswap_pages--;
+	}
+	return ret;
+}
+
+/* returns 1 if the page was successfully gotten from preswap, 0 if the page
+ * was not present (should never happen!), and -ERRNO for a specific error */
+int preswap_get(struct page *page)
+{
+	swp_entry_t entry = { .val = page_private(page), };
+	unsigned type = swp_type(entry);
+	pgoff_t offset = swp_offset(entry);
+	u64 ind64 = (u64)offset;
+	u32 ind = (u32)offset;
+	unsigned long pfn = page_to_pfn(page);
+	struct swap_info_struct *sis = get_swap_info_struct(type);
+	int ret;
+
+	if ((s32)preswap_poolid < 0)
+		return 0;
+	if (ind64 != ind)
+		return 0;
+	if (!preswap_test(sis, offset))
+		return 0;
+	ret = tmem_get_page(preswap_poolid, oswiz(type, ind),
+		iswiz(ind), pfn);
+	return ret;
+}
+
+/* flush a single page from preswap */
+void preswap_flush(unsigned type, unsigned long offset)
+{
+	u64 ind64 = (u64)offset;
+	u32 ind = (u32)offset;
+	struct swap_info_struct *sis = get_swap_info_struct(type);
+	int ret = 1;
+
+	if ((s32)preswap_poolid < 0)
+		return;
+	if (ind64 != ind)
+		return;
+	if (preswap_test(sis, offset)) {
+		ret = tmem_flush_page(preswap_poolid,
+			oswiz(type, ind), iswiz(ind));
+		sis->preswap_pages--;
+		preswap_clear(sis, offset);
+	}
+}
+
+/* flush all pages from the passed swaptype */
+void preswap_flush_area(unsigned type)
+{
+	struct swap_info_struct *sis = get_swap_info_struct(type);
+	int ind;
+
+	if ((s32)preswap_poolid < 0)
+		return;
+	for (ind = SWIZ_MASK; ind >= 0; ind--)
+		(void)tmem_flush_object(preswap_poolid, oswiz(type, ind));
+	sis->preswap_pages = 0;
+}
+
+void preswap_init(unsigned type)
+{
+	struct tmem_pool_uuid private = TMEM_POOL_PRIVATE_UUID;
+
+	/* only need one tmem pool for all swap types */
+	if ((s32)preswap_poolid >= 0)
+		return;
+	preswap_poolid = tmem_new_pool(private, TMEM_POOL_PERSIST);
+}
+
+/*
+ * preswap infrastructure functions
+ */
+
+/* code structure leveraged from sys_swapoff */
+void preswap_shrink(unsigned long target_pages)
+{
+	struct swap_info_struct *si = NULL;
+	unsigned long total_pages = 0, total_pages_to_unuse;
+	unsigned long pages = 0, unuse_pages = 0;
+	int type;
+	int wrapped = 0;
+
+	do {
+		/*
+		 * we don't want to hold swap_lock while doing a very
+		 * lengthy try_to_unuse, but swap_list may change
+		 * so restart scan from swap_list.head each time
+		 */
+		spin_lock(&swap_lock);
+		total_pages = 0;
+		for (type = swap_list.head; type >= 0; type = si->next) {
+			si = get_swap_info_struct(type);
+			total_pages += si->preswap_pages;
+		}
+		if (total_pages <= target_pages) {
+			spin_unlock(&swap_lock);
+			return;
+		}
+		total_pages_to_unuse = total_pages - target_pages;
+		for (type = swap_list.head; type >= 0; type = si->next) {
+			si = get_swap_info_struct(type);
+			if (total_pages_to_unuse < si->preswap_pages)
+				pages = unuse_pages = total_pages_to_unuse;
+			else {
+				pages = si->preswap_pages;
+				unuse_pages = 0; /* unuse all */
+			}
+			if (security_vm_enough_memory(pages))
+				continue;
+			vm_unacct_memory(pages);
+			break;
+		}
+		spin_unlock(&swap_lock);
+		if (type < 0)
+			return;
+		current->flags |= PF_SWAPOFF;
+		(void)try_to_unuse(type, 1, unuse_pages);
+		current->flags &= ~PF_SWAPOFF;
+		wrapped++;
+	} while (wrapped <= 3);
+}
+
+
+#ifdef CONFIG_SYSCTL
+/* cat /sys/proc/vm/preswap provides total number of pages in preswap
+ * across all swaptypes.  echo N > /sys/proc/vm/preswap attempts to shrink
+ * preswap page usage to N (usually 0) */
+int preswap_sysctl_handler(ctl_table *table, int write,
+	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	unsigned long npages;
+	int type;
+	unsigned long totalpages = 0;
+	struct swap_info_struct *si = NULL;
+
+	/* modeled after hugetlb_sysctl_handler in mm/hugetlb.c */
+	if (!write) {
+		spin_lock(&swap_lock);
+		for (type = swap_list.head; type >= 0; type = si->next) {
+			si = get_swap_info_struct(type);
+			totalpages += si->preswap_pages;
+		}
+		spin_unlock(&swap_lock);
+		npages = totalpages;
+	}
+	table->data = &npages;
+	table->maxlen = sizeof(unsigned long);
+	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+
+	if (write)
+		preswap_shrink(npages);
+
+	return 0;
+}
+#endif
--- linux-2.6.30/include/linux/sysctl.h	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/include/linux/sysctl.h	2009-06-19 09:33:59.000000000 -0600
@@ -205,6 +205,7 @@ enum
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+	VM_PRESWAP_PAGES=36,	/* pages/target_pages in preswap */
 };
 
 
--- linux-2.6.30/kernel/sysctl.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/kernel/sysctl.c	2009-06-19 09:33:59.000000000 -0600
@@ -1282,6 +1282,18 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &scan_unevictable_handler,
 	},
 #endif
+#ifdef CONFIG_PRESWAP
+	{
+		.ctl_name	= VM_PRESWAP_PAGES,
+		.procname	= "preswap",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &preswap_sysctl_handler,
+		.extra1		= (void *)&preswap_zero,
+		.extra2		= (void *)&preswap_infinity,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
--- linux-2.6.30-tmem-precache/mm/Kconfig	2009-07-06 16:37:05.000000000 -0600
+++ linux-2.6.30-tmem-preswap/mm/Kconfig	2009-07-06 16:35:22.000000000 -0600
@@ -271,3 +271,11 @@ config PRECACHE
 	  Allows the transcendent memory pool to be used to store clean
 	  page-cache pages which, under some circumstances, will greatly
 	  reduce paging and thus improve performance.
+
+config PRESWAP
+	bool "Swap pages to transcendent memory"
+	depends on TMEM
+	help
+	  Allows the transcendent memory pool to be used as a pseudo-swap
+	  device which, under some circumstances, will greatly reduce
+	  swapping and thus improve performance.
--- linux-2.6.30-tmem-precache/mm/Makefile	2009-07-06 16:37:10.000000000 -0600
+++ linux-2.6.30-tmem-preswap/mm/Makefile	2009-07-06 16:35:22.000000000 -0600
@@ -17,6 +17,7 @@ obj-$(CONFIG_PROC_PAGE_MONITOR) += pagew
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_TMEM)	+= tmem.o
+obj-$(CONFIG_PRESWAP)	+= preswap.o
 obj-$(CONFIG_PRECACHE)	+= precache.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
