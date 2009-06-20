Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbZFTBhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbZFTBhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZFTBgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:36:55 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:21169 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZFTBgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:36:53 -0400
MIME-Version: 1.0
Message-ID: <13c63325-9e2d-4efc-a910-688304dad6ce@default>
Date: Fri, 19 Jun 2009 18:36:05 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: dan.magenheimer@oracle.com, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org
Subject: [RFC PATCH 3/4] tmem: preswap implementation (layered on tmem)
In-Reply-To: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A3C3D08.0137:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.30/mm/page_io.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/mm/page_io.c	2009-06-19 09:33:59.000000000 -0600
@@ -102,6 +102,12 @@
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
@@ -134,6 +140,12 @@
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
+++ linux-2.6.30-tmem/mm/swapfile.c	2009-06-19 16:20:14.000000000 -0600
@@ -35,7 +35,7 @@
 #include <linux/swapops.h>
 #include <linux/page_cgroup.h>
 
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 long nr_swap_pages;
 long total_swap_pages;
@@ -47,7 +47,7 @@
 static const char Bad_offset[] = "Bad swap offset entry ";
 static const char Unused_offset[] = "Unused swap offset entry ";
 
-static struct swap_list_t swap_list = {-1, -1};
+struct swap_list_t swap_list = {-1, -1};
 
 static struct swap_info_struct swap_info[MAX_SWAPFILES];
 
@@ -488,6 +488,7 @@
 				swap_list.next = p - swap_info;
 			nr_swap_pages++;
 			p->inuse_pages--;
+			preswap_flush(p - swap_info, offset);
 			mem_cgroup_uncharge_swap(ent);
 		}
 	}
@@ -864,7 +865,7 @@
  * Recycle to start on reaching the end, returning 0 when empty.
  */
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
-					unsigned int prev)
+				unsigned int prev, unsigned int preswap)
 {
 	unsigned int max = si->max;
 	unsigned int i = prev;
@@ -890,6 +891,12 @@
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
@@ -901,8 +908,12 @@
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
@@ -938,7 +949,7 @@
 	 * one pass through swap_map is enough, but not necessarily:
 	 * there are races when an instance of an entry might be missed.
 	 */
-	while ((i = find_next_to_unuse(si, i)) != 0) {
+	while ((i = find_next_to_unuse(si, i, preswap)) != 0) {
 		if (signal_pending(current)) {
 			retval = -EINTR;
 			break;
@@ -1124,6 +1135,8 @@
 		 * interactive performance.
 		 */
 		cond_resched();
+		if (preswap && pages_to_unuse && !--pages_to_unuse)
+			break;
 	}
 
 	mmput(start_mm);
@@ -1448,7 +1461,7 @@
 	spin_unlock(&swap_lock);
 
 	current->flags |= PF_SWAPOFF;
-	err = try_to_unuse(type);
+	err = try_to_unuse(type, 0, 0);
 	current->flags &= ~PF_SWAPOFF;
 
 	if (err) {
@@ -1497,9 +1510,14 @@
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
 	p->flags = 0;
+	preswap_flush_area(p - swap_info);
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
+#ifdef CONFIG_PRESWAP
+	if (p->preswap_map)
+		vfree(p->preswap_map);
+#endif
 	/* Destroy swap account informatin */
 	swap_cgroup_swapoff(type);
 
@@ -1812,6 +1830,11 @@
 	}
 
 	memset(swap_map, 0, maxpages * sizeof(short));
+#ifdef CONFIG_PRESWAP
+	p->preswap_map = vmalloc(maxpages / sizeof(long));
+	if (p->preswap_map)
+		memset(p->preswap_map, 0, maxpages / sizeof(long));
+#endif
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		int page_nr = swap_header->info.badpages[i];
 		if (page_nr <= 0 || page_nr >= swap_header->info.last_page) {
@@ -1886,6 +1909,7 @@
 	} else {
 		swap_info[prev].next = p - swap_info;
 	}
+	preswap_init(p - swap_info);
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	error = 0;
@@ -2002,6 +2026,8 @@
 
 	si = &swap_info[swp_type(entry)];
 	target = swp_offset(entry);
+	if (preswap_test(si, target))
+		return 0;
 	base = (target >> our_page_cluster) << our_page_cluster;
 	end = base + (1 << our_page_cluster);
 	if (!base)		/* first page is swap header */
@@ -2018,6 +2044,9 @@
 			break;
 		if (si->swap_map[toff] == SWAP_MAP_BAD)
 			break;
+		/* Don't read in preswap pages */
+		if (preswap_test(si, toff))
+			break;
 	}
 	/* Count contiguous allocated slots below our target */
 	for (toff = target; --toff >= base; nr_pages++) {
--- linux-2.6.30/include/linux/swap.h	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/include/linux/swap.h	2009-06-19 12:51:55.000000000 -0600
@@ -8,6 +8,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
 #include <linux/node.h>
+#include <linux/vmalloc.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -154,8 +155,62 @@
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
@@ -312,6 +367,8 @@
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
+extern struct swap_list_t swap_list;
+extern spinlock_t swap_lock;
 
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
--- linux-2.6.30/mm/preswap.c	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.30-tmem/mm/preswap.c	2009-06-19 14:55:16.000000000 -0600
@@ -0,0 +1,274 @@
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
+	ret = (*tmem_ops->put_page)(preswap_poolid, oswiz(type, ind),
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
+	ret = (*tmem_ops->get_page)(preswap_poolid, oswiz(type, ind),
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
+		ret = (*tmem_ops->flush_page)(preswap_poolid,
+					oswiz(type, ind), iswiz(ind));
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
+		(void)(*tmem_ops->flush_object)(preswap_poolid,
+			oswiz(type, ind));
+	sis->preswap_pages = 0;
+}
+
+void preswap_init(unsigned type)
+{
+	/* only need one tmem pool for all swap types */
+	if ((s32)preswap_poolid >= 0)
+		return;
+	if (tmem_ops == NULL)
+		return;
+	preswap_poolid = (*tmem_ops->new_pool)(0, 0, TMEM_POOL_PERSIST);
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
@@ -205,6 +205,7 @@
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+	VM_PRESWAP_PAGES=36,	/* pages/target_pages in preswap */
 };
 
 
--- linux-2.6.30/kernel/sysctl.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/kernel/sysctl.c	2009-06-19 09:33:59.000000000 -0600
@@ -1282,6 +1282,18 @@
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
