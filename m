Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYJaC6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYJaC6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYJaC6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:58:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53790 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbYJaC6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:58:34 -0400
Date: Fri, 31 Oct 2008 11:58:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, taka@valinux.co.jp
Subject: [RFC][PATCH 4/5] memcg : add swap_cgroup
Message-Id: <20081031115800.f09ba084.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081031115057.6da3dafd.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081031115057.6da3dafd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For accounting swap, we need a record per swap entry, at least.

This patch adds following function.
  - swap_cgroup_swapon() .... called from swapon
  - swap_cgroup_swapoff() ... called at the end of swapoff.

  - swap_cgroup_record() .... record information of swap entry.
                              returns old value.
  - swap_cgroup_lookup() .... lookup information of swap entry.

This patch just implements "how to record information". No actual
method for limit the usage of swap. These routine uses flat table
to record and lookup. "wise" lookup system like radix-tree requires
requires memory allocation at new records but swap-out is usually
called under memory shortage (or memcg hits limit.)
So, I used static allocation. (maybe dynamic allocation is not very
hard but it adds additional memory allocation in memory shortage path.)

Note1: In this, we use pointer to record information and this means
      8bytes per swap entry. I think we can reduce this when we
      create "id of cgroup" in the range of 0-65535 or 0-255.

Note2: array of swap_cgroup is allocated from HIGHMEM. maybe good for x86-32.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 include/linux/page_cgroup.h |   35 +++++++
 mm/page_cgroup.c            |  199 ++++++++++++++++++++++++++++++++++++++++++++
 mm/swapfile.c               |    8 +
 3 files changed, 242 insertions(+)

Index: mmotm-2.6.28-rc2+/mm/page_cgroup.c
===================================================================
--- mmotm-2.6.28-rc2+.orig/mm/page_cgroup.c
+++ mmotm-2.6.28-rc2+/mm/page_cgroup.c
@@ -8,6 +8,8 @@
 #include <linux/memory.h>
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
+#include <linux/swapops.h>
+#include <linux/highmem.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -254,3 +256,200 @@ void __init pgdat_page_cgroup_init(struc
 }
 
 #endif
+
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+
+DEFINE_MUTEX(swap_cgroup_mutex);
+struct swap_cgroup_ctrl {
+	spinlock_t lock;
+	struct page **map;
+	unsigned long length;
+};
+
+struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
+
+/*
+ * This 8bytes seems big..maybe we can reduce this when we can use "id" for
+ * cgroup rather than pointer.
+ */
+struct swap_cgroup {
+	struct mem_cgroup	*val;
+};
+#define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
+#define SC_POS_MASK	(SC_PER_PAGE - 1)
+
+/*
+ * allocate buffer for swap_cgroup.
+ */
+static int swap_cgroup_prepare(int type)
+{
+	struct page *page;
+	struct swap_cgroup_ctrl *ctrl;
+	unsigned long idx, max;
+
+	if (!do_swap_account)
+		return 0;
+	ctrl = &swap_cgroup_ctrl[type];
+
+	for (idx = 0; idx < ctrl->length; idx++) {
+		page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+		if (!page)
+			goto not_enough_page;
+		ctrl->map[idx] = page;
+	}
+	return 0;
+not_enough_page:
+	max = idx;
+	for (idx = 0; idx < max; idx++)
+		__free_page(ctrl->map[idx]);
+
+	return -ENOMEM;
+}
+
+/**
+ * swap_cgroup_record - record mem_cgroup for this swp_entry.
+ * @ent: swap entry to be recorded into
+ * @mem: mem_cgroup to be recorded
+ *
+ * Returns old value at success, NULL at failure.
+ * (Of course, old value can be NULL.)
+ */
+struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
+{
+	unsigned long flags;
+	int type = swp_type(ent);
+	unsigned long offset = swp_offset(ent);
+	unsigned long idx = offset / SC_PER_PAGE;
+	unsigned long pos = offset & SC_POS_MASK;
+	struct swap_cgroup_ctrl *ctrl;
+	struct page *mappage;
+	struct swap_cgroup *sc;
+	struct mem_cgroup *old;
+
+	if (!do_swap_account)
+		return NULL;
+
+	ctrl = &swap_cgroup_ctrl[type];
+
+	mappage = ctrl->map[idx];
+	spin_lock_irqsave(&ctrl->lock, flags);
+	sc = kmap_atomic(mappage, KM_USER0);
+	sc += pos;
+	old = sc->val;
+	sc->val = mem;
+	kunmap_atomic(mappage, KM_USER0);
+	spin_unlock_irqrestore(&ctrl->lock, flags);
+	return old;
+}
+
+/**
+ * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
+ * @ent: swap entry to be looked up.
+ *
+ * Returns pointer to mem_cgroup at success. NULL at failure.
+ */
+struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
+{
+	int type = swp_type(ent);
+	unsigned long flags;
+	unsigned long offset = swp_offset(ent);
+	unsigned long idx = offset / SC_PER_PAGE;
+	unsigned long pos = offset & SC_POS_MASK;
+	struct swap_cgroup_ctrl *ctrl;
+	struct page *mappage;
+	struct swap_cgroup *sc;
+	struct mem_cgroup *ret;
+
+	if (!do_swap_account)
+		return NULL;
+
+	ctrl = &swap_cgroup_ctrl[type];
+
+	mappage = ctrl->map[idx];
+
+	spin_lock_irqsave(&ctrl->lock, flags);
+	sc = kmap_atomic(mappage, KM_USER0);
+	sc += pos;
+	ret = sc->val;
+	kunmap_atomic(mapppage, KM_USER0);
+	spin_unlock_irqrestore(&ctrl->lock, flags);
+	return ret;
+}
+
+int swap_cgroup_swapon(int type, unsigned long max_pages)
+{
+	void *array;
+	unsigned long array_size;
+	unsigned long length;
+	struct swap_cgroup_ctrl *ctrl;
+
+	if (!do_swap_account)
+		return 0;
+
+	length = ((max_pages/SC_PER_PAGE) + 1);
+	array_size = length * sizeof(void *);
+
+	array = vmalloc(array_size);
+	if (!array)
+		goto nomem;
+
+	memset(array, 0, array_size);
+	ctrl = &swap_cgroup_ctrl[type];
+	mutex_lock(&swap_cgroup_mutex);
+	ctrl->length = length;
+	ctrl->map = array;
+	if (swap_cgroup_prepare(type)) {
+		/* memory shortage */
+		ctrl->map = NULL;
+		ctrl->length = 0;
+		vfree(array);
+		mutex_unlock(&swap_cgroup_mutex);
+		goto nomem;
+	}
+	mutex_unlock(&swap_cgroup_mutex);
+
+	printk(KERN_INFO
+		"swap_cgroup: uses %ld bytes vmalloc and %ld bytes buffres\n",
+		array_size, length * PAGE_SIZE);
+	printk(KERN_INFO
+	"swap_cgroup can be disabled by noswapaccount boot option.\n");
+
+	return 0;
+nomem:
+	printk(KERN_INFO "couldn't allocate enough memory for swap_cgroup.\n");
+	printk(KERN_INFO
+		"swap_cgroup can be disabled by noswapaccount boot option\n");
+	return -ENOMEM;
+}
+
+void swap_cgroup_swapoff(int type)
+{
+	int i;
+	struct swap_cgroup_ctrl *ctrl;
+
+	if (!do_swap_account)
+		return;
+
+	mutex_lock(&swap_cgroup_mutex);
+	ctrl = &swap_cgroup_ctrl[type];
+	for (i = 0; i < ctrl->length; i++) {
+		struct page *page = ctrl->map[i];
+		if (page)
+			__free_page(page);
+	}
+	vfree(ctrl->map);
+	ctrl->map = NULL;
+	ctrl->length = 0;
+	mutex_unlock(&swap_cgroup_mutex);
+}
+
+static int __init swap_cgroup_init(void)
+{
+	int i;
+	for (i = 0; i < MAX_SWAPFILES; i++)
+		spin_lock_init(&swap_cgroup_ctrl[i].lock);
+	return 0;
+}
+late_initcall(swap_cgroup_init);
+#endif
Index: mmotm-2.6.28-rc2+/include/linux/page_cgroup.h
===================================================================
--- mmotm-2.6.28-rc2+.orig/include/linux/page_cgroup.h
+++ mmotm-2.6.28-rc2+/include/linux/page_cgroup.h
@@ -105,4 +105,39 @@ static inline void page_cgroup_init(void
 }
 
 #endif
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#include <linux/swap.h>
+extern struct mem_cgroup *
+swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem);
+extern struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent);
+extern int swap_cgroup_swapon(int type, unsigned long max_pages);
+extern void swap_cgroup_swapoff(int type);
+#else
+#include <linux/swap.h>
+
+static inline
+struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
+{
+	return NULL;
+}
+
+static inline
+struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
+{
+	return NULL;
+}
+
+static inline int
+swap_cgroup_swapon(int type, unsigned long max_pages)
+{
+	return 0;
+}
+
+static inline void swap_cgroup_swapoff(int type)
+{
+	return;
+}
+
+#endif
 #endif
Index: mmotm-2.6.28-rc2+/mm/swapfile.c
===================================================================
--- mmotm-2.6.28-rc2+.orig/mm/swapfile.c
+++ mmotm-2.6.28-rc2+/mm/swapfile.c
@@ -32,6 +32,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
+#include <linux/page_cgroup.h>
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -1345,6 +1346,9 @@ asmlinkage long sys_swapoff(const char _
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
+	/* Destroy swap account informatin */
+	swap_cgroup_swapoff(type);
+
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
@@ -1669,6 +1673,10 @@ asmlinkage long sys_swapon(const char __
 		nr_good_pages = swap_header->info.last_page -
 				swap_header->info.nr_badpages -
 				1 /* header page */;
+
+		if (!error)
+			error = swap_cgroup_swapon(type, maxpages);
+
 		if (error)
 			goto bad_swap;
 	}

