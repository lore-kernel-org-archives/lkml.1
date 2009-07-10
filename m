Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZGJRB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZGJRB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZGJQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:7792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZGJQ7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777325"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 05/10] x86, PAT: Add rbtree to do quick lookup in memtype tracking
Date: Fri, 10 Jul 2009 09:57:36 -0700
Message-Id: <3a66cb82f9810b9ecc942694b1bb23db7fff8ab2.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
 <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
 <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PAT memtype tracking uses a linear link list to keep track of IO
(non-RAM) regions and their memtypes. The code used a last_accessed
pointer as a cache to speedup the lookup. As per discussions with
H. Peter Anvin a while back, having a rbtree here will avoid bad
performances in pathological cases where we may end up with huge
linked list. This may not add any noticable performance speedup
in normal case as the number of entires in PAT memtype list tend
to be ~20-30 range. The patch removes the "cached_entry" logic
as with rbtree we have more generic way of speeding up the lookup.

With this patch, we use rbtree to do the quick lookup. We still use
linked list as the memtype range tracked can be of different sizes
and can overlap in different ways. We also keep track of usage counts
with linked list.

Example:
Multiple ioremaps with different sizes
uncached-minus @ 0xfffff00000-0xfffff04000
uncached-minus @ 0xfffff02000-0xfffff03000

And one userlevel mmap and the thread forks a new process
uncached-minus @ 0xbf453000-0xbf454000
uncached-minus @ 0xbf453000-0xbf454000

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c |  106 +++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 86 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 82d097c..c90f242 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -15,6 +15,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/rbtree.h>
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
@@ -148,11 +149,10 @@ static char *cattr_name(unsigned long flags)
  * areas). All the aliases have the same cache attributes of course.
  * Zero attributes are represented as holes.
  *
- * Currently the data structure is a list because the number of mappings
- * are expected to be relatively small. If this should be a problem
- * it could be changed to a rbtree or similar.
+ * The data structure is a list that is also organized as an rbtree
+ * sorted on the start address of memtype range.
  *
- * memtype_lock protects the whole list.
+ * memtype_lock protects both the linear list and rbtree.
  */
 
 struct memtype {
@@ -160,11 +160,53 @@ struct memtype {
 	u64			end;
 	unsigned long		type;
 	struct list_head	nd;
+	struct rb_node		rb;
 };
 
+static struct rb_root memtype_rbroot = RB_ROOT;
 static LIST_HEAD(memtype_list);
 static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype list */
 
+static struct memtype *memtype_rb_search(struct rb_root *root, u64 start)
+{
+	struct rb_node *node = root->rb_node;
+	struct memtype *last_lower = NULL;
+
+	while (node) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+
+		if (data->start < start) {
+			last_lower = data;
+			node = node->rb_right;
+		} else if (data->start > start) {
+			node = node->rb_left;
+		} else
+			return data;
+	}
+
+	/* Will return NULL if there is no entry with its start <= start */
+	return last_lower;
+}
+
+static void memtype_rb_insert(struct rb_root *root, struct memtype *data)
+{
+	struct rb_node **new = &(root->rb_node);
+	struct rb_node *parent = NULL;
+
+	while (*new) {
+		struct memtype *this = container_of(*new, struct memtype, rb);
+
+		parent = *new;
+		if (data->start <= this->start)
+			new = &((*new)->rb_left);
+		else if (data->start > this->start)
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&data->rb, parent, new);
+	rb_insert_color(&data->rb, root);
+}
+
 /*
  * Does intersection of PAT memory type and MTRR memory type and returns
  * the resulting memory type as PAT understands it.
@@ -218,9 +260,6 @@ chk_conflict(struct memtype *new, struct memtype *entry, unsigned long *type)
 	return -EBUSY;
 }
 
-static struct memtype *cached_entry;
-static u64 cached_start;
-
 static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
 {
 	int ram_page = 0, not_rampage = 0;
@@ -382,17 +421,19 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_lock(&memtype_lock);
 
-	if (cached_entry && start >= cached_start)
-		entry = cached_entry;
-	else
+	entry = memtype_rb_search(&memtype_rbroot, new->start);
+	if (likely(entry != NULL)) {
+		/* To work correctly with list_for_each_entry_continue */
+		entry = list_entry(entry->nd.prev, struct memtype, nd);
+	} else {
 		entry = list_entry(&memtype_list, struct memtype, nd);
+	}
 
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
 	list_for_each_entry_continue(entry, &memtype_list, nd) {
 		if (end <= entry->start) {
 			where = entry->nd.prev;
-			cached_entry = list_entry(where, struct memtype, nd);
 			break;
 		} else if (start <= entry->start) { /* end > entry->start */
 			err = chk_conflict(new, entry, new_type);
@@ -400,8 +441,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 				dprintk("Overlap at 0x%Lx-0x%Lx\n",
 					entry->start, entry->end);
 				where = entry->nd.prev;
-				cached_entry = list_entry(where,
-							struct memtype, nd);
 			}
 			break;
 		} else if (start < entry->end) { /* start > entry->start */
@@ -409,8 +448,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 			if (!err) {
 				dprintk("Overlap at 0x%Lx-0x%Lx\n",
 					entry->start, entry->end);
-				cached_entry = list_entry(entry->nd.prev,
-							struct memtype, nd);
 
 				/*
 				 * Move to right position in the linked
@@ -438,13 +475,13 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return err;
 	}
 
-	cached_start = start;
-
 	if (where)
 		list_add(&new->nd, where);
 	else
 		list_add_tail(&new->nd, &memtype_list);
 
+	memtype_rb_insert(&memtype_rbroot, new);
+
 	spin_unlock(&memtype_lock);
 
 	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
@@ -456,7 +493,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 int free_memtype(u64 start, u64 end)
 {
-	struct memtype *entry;
+	struct memtype *entry, *saved_entry;
 	int err = -EINVAL;
 	int is_range_ram;
 
@@ -474,17 +511,46 @@ int free_memtype(u64 start, u64 end)
 		return -EINVAL;
 
 	spin_lock(&memtype_lock);
+
+	entry = memtype_rb_search(&memtype_rbroot, start);
+	if (unlikely(entry == NULL))
+		goto unlock_ret;
+
+	/*
+	 * Saved entry points to an entry with start same or less than what
+	 * we searched for. Now go through the list in both directions to look
+	 * for the entry that matches with both start and end, with list stored
+	 * in sorted start address
+	 */
+	saved_entry = entry;
 	list_for_each_entry(entry, &memtype_list, nd) {
 		if (entry->start == start && entry->end == end) {
-			if (cached_entry == entry || cached_start == start)
-				cached_entry = NULL;
+			rb_erase(&entry->rb, &memtype_rbroot);
+			list_del(&entry->nd);
+			kfree(entry);
+			err = 0;
+			break;
+		} else if (entry->start > start) {
+			break;
+		}
+	}
+
+	if (!err)
+		goto unlock_ret;
 
+	entry = saved_entry;
+	list_for_each_entry_reverse(entry, &memtype_list, nd) {
+		if (entry->start == start && entry->end == end) {
+			rb_erase(&entry->rb, &memtype_rbroot);
 			list_del(&entry->nd);
 			kfree(entry);
 			err = 0;
 			break;
+		} else if (entry->start < start) {
+			break;
 		}
 	}
+unlock_ret:
 	spin_unlock(&memtype_lock);
 
 	if (err) {
-- 
1.6.0.6

