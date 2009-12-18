Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZLRAjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZLRAjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZLRAjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:39:35 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:54813 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZLRAja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:39:30 -0500
MIME-Version: 1.0
Message-ID: <db7e960e-d87c-4a35-ac27-cd75ec67d8b1@default>
Date: Thu, 17 Dec 2009 16:38:13 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: dan.magenheimer@oracle.com, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, kurt.hackel@oracle.com,
       Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, linux-mm@kvack.org,
       Rusty@rcsinet15.oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       chris.mason@oracle.com, Pavel Machek <pavel@ucw.cz>
Subject: Tmem [PATCH 3/5] (Take 3): Implement frontswap on top of tmem layer
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B2ACF0A.016D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tmem [PATCH 3/5] (Take 3): Implement frontswap on top of tmem layer.

Hooks added to existing page swap routines and data structures to:
1) create a tmem pool when any swap "type" is created (one pool
   covers all open swap types)
2) attempt to "put" pages to frontswap prior to writing to a swap disk
   and fallback to writing to swap disk if put fails
3) track successfully put pages with a new bit-per-page frontswap_map
   array
4) "get" pages from frontswap if frontswap_map indicates
5) destroy the tmem pool when no more swap types are in use
6) implement "shrinking" to repatriate pages from frontswap into
   the swap cache (or purge entirely if no longer needed)
7) Provide a sysctl interface to support both userland shrinking
   and determine number of pages currently in frontswap

The term "frontswap" is coined because it is the opposite
of a "backing store" for swap disks.  The previous term
("preswap") was deemed too generic and overloaded.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>


 include/linux/swap.h                     |   51 +++
 include/linux/sysctl.h                   |    1 
 kernel/sysctl.c                          |   11 
 mm/frontswap.c                           |  319 +++++++++++++++++++++
 mm/page_io.c                             |   12 
 mm/swapfile.c                            |   43 ++
 6 files changed, 430 insertions(+), 7 deletions(-)

--- linux-2.6.32/mm/page_io.c	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/mm/page_io.c	2009-12-17 13:59:06.000000000 -0700
@@ -102,6 +102,12 @@ int swap_writepage(struct page *page, st
 		unlock_page(page);
 		goto out;
 	}
+	if (frontswap_put(page) == 1) {
+		set_page_writeback(page);
+		unlock_page(page);
+		end_page_writeback(page);
+		goto out;
+	}
 	bio = get_swap_bio(GFP_NOIO, page_private(page), page,
 				end_swap_bio_write);
 	if (bio == NULL) {
@@ -134,6 +140,12 @@ int swap_readpage(struct page *page)
 		ret = -ENOMEM;
 		goto out;
 	}
+	if (frontswap_get(page) == 1) {
+		SetPageUptodate(page);
+		unlock_page(page);
+		bio_put(bio);
+		goto out;
+	}
 	count_vm_event(PSWPIN);
 	submit_bio(READ, bio);
 out:
--- linux-2.6.32/mm/swapfile.c	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/mm/swapfile.c	2009-12-17 14:00:05.000000000 -0700
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
 
@@ -585,6 +585,7 @@ static int swap_entry_free(struct swap_i
 			swap_list.next = p - swap_info;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		frontswap_flush(p - swap_info, offset);
 	}
 	if (!swap_count(count))
 		mem_cgroup_uncharge_swap(ent);
@@ -984,7 +985,7 @@ static int unuse_mm(struct mm_struct *mm
  * Recycle to start on reaching the end, returning 0 when empty.
  */
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
-					unsigned int prev)
+				unsigned int prev, unsigned int frontswap)
 {
 	unsigned int max = si->max;
 	unsigned int i = prev;
@@ -1010,6 +1011,12 @@ static unsigned int find_next_to_unuse(s
 			prev = 0;
 			i = 1;
 		}
+		if (frontswap) {
+			if (frontswap_test(si, i))
+				break;
+			else
+				continue;
+		}
 		count = si->swap_map[i];
 		if (count && swap_count(count) != SWAP_MAP_BAD)
 			break;
@@ -1021,8 +1028,12 @@ static unsigned int find_next_to_unuse(s
  * We completely avoid races by reading each swap page in advance,
  * and then search for the process using it.  All the necessary
  * page table adjustments can then be made atomically.
+ *
+ * if the boolean frontswap is true, only unuse pages_to_unuse pages;
+ * pages_to_unuse==0 means all pages
  */
-static int try_to_unuse(unsigned int type)
+int try_to_unuse(unsigned int type, unsigned int frontswap,
+		unsigned long pages_to_unuse)
 {
 	struct swap_info_struct * si = &swap_info[type];
 	struct mm_struct *start_mm;
@@ -1058,7 +1069,7 @@ static int try_to_unuse(unsigned int typ
 	 * one pass through swap_map is enough, but not necessarily:
 	 * there are races when an instance of an entry might be missed.
 	 */
-	while ((i = find_next_to_unuse(si, i)) != 0) {
+	while ((i = find_next_to_unuse(si, i, frontswap)) != 0) {
 		if (signal_pending(current)) {
 			retval = -EINTR;
 			break;
@@ -1251,6 +1262,8 @@ retry:
 		 * interactive performance.
 		 */
 		cond_resched();
+		if (frontswap && pages_to_unuse && !--pages_to_unuse)
+			break;
 	}
 
 	mmput(start_mm);
@@ -1575,7 +1588,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_unlock(&swap_lock);
 
 	current->flags |= PF_OOM_ORIGIN;
-	err = try_to_unuse(type);
+	err = try_to_unuse(type, 0, 0);
 	current->flags &= ~PF_OOM_ORIGIN;
 
 	if (err) {
@@ -1624,6 +1637,11 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
 	p->flags = 0;
+	frontswap_flush_area(p - swap_info);
+#ifdef CONFIG_FRONTSWAP
+	if (p->frontswap_map)
+		vfree(p->frontswap_map);
+#endif
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
@@ -2015,6 +2033,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 	} else {
 		swap_info[prev].next = p - swap_info;
 	}
+#ifdef CONFIG_FRONTSWAP
+	p->frontswap_map = vmalloc(maxpages / sizeof(long));
+	if (p->frontswap_map)
+		memset(p->frontswap_map, 0, maxpages / sizeof(long));
+#endif
+	frontswap_init(p - swap_info);
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	error = 0;
@@ -2189,6 +2213,10 @@ int valid_swaphandles(swp_entry_t entry,
 		base++;
 
 	spin_lock(&swap_lock);
+	if (frontswap_test(si, target)) {
+		spin_unlock(&swap_lock);
+		return 0;
+	}
 	if (end > si->max)	/* don't go beyond end of map */
 		end = si->max;
 
@@ -2199,6 +2227,9 @@ int valid_swaphandles(swp_entry_t entry,
 			break;
 		if (swap_count(si->swap_map[toff]) == SWAP_MAP_BAD)
 			break;
+		/* Don't read in frontswap pages */
+		if (frontswap_test(si, toff))
+			break;
 	}
 	/* Count contiguous allocated slots below our target */
 	for (toff = target; --toff >= base; nr_pages++) {
--- linux-2.6.32/include/linux/swap.h	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/include/linux/swap.h	2009-12-17 14:00:37.000000000 -0700
@@ -8,6 +8,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
 #include <linux/node.h>
+#include <linux/vmalloc.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -177,8 +178,56 @@ struct swap_info_struct {
 	unsigned int max;
 	unsigned int inuse_pages;
 	unsigned int old_block_size;
+#ifdef CONFIG_FRONTSWAP
+	unsigned long *frontswap_map;
+	unsigned int frontswap_pages;
+#endif
 };
 
+#ifdef CONFIG_FRONTSWAP
+extern void frontswap_shrink(unsigned long);
+extern int frontswap_test(struct swap_info_struct *, unsigned long);
+extern void frontswap_init(unsigned);
+extern int frontswap_put(struct page *);
+extern int frontswap_get(struct page *);
+extern void frontswap_flush(unsigned, unsigned long);
+extern void frontswap_flush_area(unsigned);
+/* in swapfile.c */
+extern int try_to_unuse(unsigned int, unsigned int, unsigned long);
+#else
+static inline void frontswap_shrink(unsigned long target_pages)
+{
+}
+
+static inline int frontswap_test(struct swap_info_struct *sis,
+	unsigned long offset)
+{
+	return 0;
+}
+
+static inline void frontswap_init(unsigned type)
+{
+}
+
+static inline int frontswap_put(struct page *page)
+{
+	return 0;
+}
+
+static inline int frontswap_get(struct page *page)
+{
+	return 0;
+}
+
+static inline void frontswap_flush(unsigned type, unsigned long offset)
+{
+}
+
+static inline void frontswap_flush_area(unsigned type)
+{
+}
+#endif /* CONFIG_FRONTSWAP */
+
 struct swap_list_t {
 	int head;	/* head of priority-ordered swapfile list */
 	int next;	/* swapfile to be used next */
@@ -323,6 +372,8 @@ extern struct swap_info_struct *get_swap
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
+extern struct swap_list_t swap_list;
+extern spinlock_t swap_lock;
 
 /* linux/mm/thrash.c */
 extern struct mm_struct *swap_token_mm;
--- linux-2.6.32/mm/frontswap.c	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.32-tmem/mm/frontswap.c	2009-12-17 15:31:24.000000000 -0700
@@ -0,0 +1,319 @@
+/*
+ * linux/mm/frontswap.c
+ *
+ * Implements a fast "frontswap" on top of the transcendent memory ("tmem") API.
+ * When a swapdisk is enabled (with swapon), a "private persistent tmem pool"
+ * is created along with a bit-per-page frontswap_map.  When swapping occurs
+ * and a page is about to be written to disk, a "put" into the pool may first
+ * be attempted by passing the pageframe to be swapped, along with a "handle"
+ * consisting of a pool_id, an object id, and an index.  Since the pool is of
+ * indeterminate size, the "put" may be rejected, in which case the page
+ * is swapped to disk as normal.  If the "put" is successful, the page is
+ * copied to tmem and the frontswap_map records the success.  Later, when
+ * the page needs to be swapped in, the frontswap_map is checked and, if set,
+ * the page may be obtained with a "get" operation.  Note that the swap
+ * subsystem is responsible for: maintaining coherency between the swapcache,
+ * frontswap, and the swapdisk; for evicting stale pages from frontswap; and for
+ * emptying frontswap when swapoff is performed. The "flush page" and "flush
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
+static u32 frontswap_poolid = -1; /* if negative, frontswap never calls tmem */
+
+static unsigned long frontswap_succ_puts;
+static unsigned long frontswap_failed_puts;
+static unsigned long frontswap_gets;
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
+ * frontswap_map test/set/clear operations (must be atomic)
+ */
+
+int frontswap_test(struct swap_info_struct *sis, unsigned long offset)
+{
+	if (!sis->frontswap_map)
+		return 0;
+	return test_bit(offset % BITS_PER_LONG,
+		&sis->frontswap_map[offset/BITS_PER_LONG]);
+}
+
+static inline void frontswap_set(struct swap_info_struct *sis,
+				unsigned long offset)
+{
+	if (!sis->frontswap_map)
+		return;
+	set_bit(offset % BITS_PER_LONG,
+		&sis->frontswap_map[offset/BITS_PER_LONG]);
+}
+
+static inline void frontswap_clear(struct swap_info_struct *sis,
+				unsigned long offset)
+{
+	if (!sis->frontswap_map)
+		return;
+	clear_bit(offset % BITS_PER_LONG,
+		&sis->frontswap_map[offset/BITS_PER_LONG]);
+}
+
+/*
+ * frontswap tmem operations
+ */
+
+/* returns 1 if the page was successfully put into frontswap, 0 if the page
+ * was declined, and -ERRNO for a specific error */
+int frontswap_put(struct page *page)
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
+	if ((s32)frontswap_poolid < 0)
+		return 0;
+	if (ind64 != ind)
+		return 0;
+	if (frontswap_test(sis, offset))
+		dup = 1;
+	mb(); /* ensure page is quiescent; tmem may address it with an alias */
+	ret = tmem_put_page(frontswap_poolid, oswiz(type, ind),
+		iswiz(ind), pfn);
+	if (ret == 1) {
+		frontswap_set(sis, offset);
+		frontswap_succ_puts++;
+		if (!dup)
+			sis->frontswap_pages++;
+	} else if (dup) {
+		/* failed dup put always results in an automatic flush of
+		 * the (older) page from frontswap */
+		frontswap_clear(sis, offset);
+		sis->frontswap_pages--;
+		frontswap_failed_puts++;
+	} else
+		frontswap_failed_puts++;
+	return ret;
+}
+
+/* returns 1 if the page was successfully gotten from frontswap, 0 if the page
+ * was not present (should never happen!), and -ERRNO for a specific error */
+int frontswap_get(struct page *page)
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
+	if ((s32)frontswap_poolid < 0)
+		return 0;
+	if (ind64 != ind)
+		return 0;
+	if (!frontswap_test(sis, offset))
+		return 0;
+	ret = tmem_get_page(frontswap_poolid, oswiz(type, ind),
+		iswiz(ind), pfn);
+	if (ret)
+		frontswap_gets++;
+	return ret;
+}
+
+/* flush a single page from frontswap */
+void frontswap_flush(unsigned type, unsigned long offset)
+{
+	u64 ind64 = (u64)offset;
+	u32 ind = (u32)offset;
+	struct swap_info_struct *sis = get_swap_info_struct(type);
+	int ret = 1;
+
+	if ((s32)frontswap_poolid < 0)
+		return;
+	if (ind64 != ind)
+		return;
+	if (frontswap_test(sis, offset)) {
+		ret = tmem_flush_page(frontswap_poolid,
+			oswiz(type, ind), iswiz(ind));
+		sis->frontswap_pages--;
+		frontswap_clear(sis, offset);
+	}
+}
+
+/* flush all pages from the passed swaptype */
+void frontswap_flush_area(unsigned type)
+{
+	struct swap_info_struct *sis = get_swap_info_struct(type);
+	int ind;
+
+	if ((s32)frontswap_poolid < 0)
+		return;
+	for (ind = SWIZ_MASK; ind >= 0; ind--)
+		(void)tmem_flush_object(frontswap_poolid, oswiz(type, ind));
+	sis->frontswap_pages = 0;
+}
+
+void frontswap_init(unsigned type)
+{
+	struct tmem_pool_uuid private = TMEM_POOL_PRIVATE_UUID;
+
+	/* only need one tmem pool for all swap types */
+	if ((s32)frontswap_poolid >= 0)
+		return;
+	frontswap_poolid = tmem_new_pool(private, TMEM_POOL_PERSIST);
+}
+
+/*
+ * frontswap infrastructure functions
+ */
+
+/* code structure leveraged from sys_swapoff */
+void frontswap_shrink(unsigned long target_pages)
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
+			total_pages += si->frontswap_pages;
+		}
+		if (total_pages <= target_pages) {
+			spin_unlock(&swap_lock);
+			return;
+		}
+		total_pages_to_unuse = total_pages - target_pages;
+		for (type = swap_list.head; type >= 0; type = si->next) {
+			si = get_swap_info_struct(type);
+			if (total_pages_to_unuse < si->frontswap_pages)
+				pages = unuse_pages = total_pages_to_unuse;
+			else {
+				pages = si->frontswap_pages;
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
+		current->flags |= PF_OOM_ORIGIN;
+		(void)try_to_unuse(type, 1, unuse_pages);
+		current->flags &= ~PF_OOM_ORIGIN;
+		wrapped++;
+	} while (wrapped <= 3);
+}
+
+
+#ifdef CONFIG_SYSCTL
+
+#include <linux/sysctl.h>
+
+static const unsigned long frontswap_zero = 0, frontswap_infinity = ~0UL;
+
+/* cat /sys/vm/tmem/frontswap/curr_pages provides total number of pages in
+ * frontswap across all swaptypes.  echo N > /sys/proc/vm/frontswap attempts
+ * to shrink frontswap page usage to N (usually 0) */
+static int frontswap_curr_pages_ctl(ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
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
+			totalpages += si->frontswap_pages;
+		}
+		spin_unlock(&swap_lock);
+		npages = totalpages;
+	}
+	table->data = &npages;
+	table->maxlen = sizeof(unsigned long);
+	proc_doulongvec_minmax(table, write, buffer, length, ppos);
+
+	if (write)
+		frontswap_shrink(npages);
+
+	return 0;
+}
+
+ctl_table frontswap_table[] = {
+	{
+		.procname	= "curr_pages",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &frontswap_curr_pages_ctl,
+		.extra1		= (void *)&frontswap_zero,
+		.extra2		= (void *)&frontswap_infinity,
+	},
+	{
+		.procname	= "succ_puts",
+		.data		= &frontswap_succ_puts,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0444,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "failed_puts",
+		.data		= &frontswap_failed_puts,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0444,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "gets",
+		.data		= &frontswap_gets,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0444,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+	{ .ctl_name = 0 }
+};
+#endif /* CONFIG_SYSCTL */
--- linux-2.6.32/include/linux/sysctl.h	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/include/linux/sysctl.h	2009-12-17 15:30:00.000000000 -0700
@@ -206,7 +206,6 @@ enum
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
 };
 
-
 /* CTL_NET names: */
 enum
 {
--- linux-2.6.32/kernel/sysctl.c	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/kernel/sysctl.c	2009-12-17 11:25:25.000000000 -0700
@@ -195,6 +195,9 @@ extern struct ctl_table inotify_table[];
 #ifdef CONFIG_EPOLL
 extern struct ctl_table epoll_table[];
 #endif
+#ifdef CONFIG_TMEM
+extern struct ctl_table tmem_table[];
+#endif
 
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 int sysctl_legacy_va_layout;
@@ -1422,6 +1425,14 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_TMEM
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "tmem",
+		.mode		= 0555,
+		.child		= tmem_table,
+	},
+#endif
 
 /*
  * NOTE: do not add new entries to this table unless you have read
