Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0BJX0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:26:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:16802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab0BJX0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:26:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,447,1262592000"; 
   d="scan'208";a="594903802"
Date: Wed, 10 Feb 2010 15:26:07 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] x86: Migrate to rbtree only backend for pat memtype management (ver 2)
Message-ID: <20100210232607.GB11465@linux-os.sc.intel.com>
References: <20100210195704.434039000@intel.com> <20100210195909.937016000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210195909.937016000@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move pat backend to fully rbtree based implementation from the existing
rbtree and linked list hybrid.

New rbtree based solution uses interval trees (augmented rbtrees) in
order to store the PAT ranges. The new code seprates out the pat backend
to pat_rbtree.c file, making is cleaner. The change also makes the PAT
lookup, reserve and free operations more optimal, as we don't have to
traverse linear linked list of few tens of entries in normal case.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
Updated with a bug fix in memtype_rb_lowest_match

 arch/x86/mm/Makefile       |    1 +
 arch/x86/mm/pat.c          |  209 +---------------------------------
 arch/x86/mm/pat_internal.h |   20 +++-
 arch/x86/mm/pat_rbtree.c   |  272 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 297 insertions(+), 205 deletions(-)
 create mode 100644 arch/x86/mm/pat_rbtree.c

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 06630d2..a4c7683 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -6,6 +6,7 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_physaddr.o		:= $(nostackp)
 CFLAGS_setup_nx.o		:= $(nostackp)
 
+obj-$(CONFIG_X86_PAT)		+= pat_rbtree.o
 obj-$(CONFIG_SMP)		+= tlb.o
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 628e507..9510111 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -130,65 +130,7 @@ void pat_init(void)
 
 #undef PAT
 
-/*
- * The global memtype list keeps track of memory type for specific
- * physical memory areas. Conflicting memory types in different
- * mappings can cause CPU cache corruption. To avoid this we keep track.
- *
- * The list is sorted based on starting address and can contain multiple
- * entries for each address (this allows reference counting for overlapping
- * areas). All the aliases have the same cache attributes of course.
- * Zero attributes are represented as holes.
- *
- * The data structure is a list that is also organized as an rbtree
- * sorted on the start address of memtype range.
- *
- * memtype_lock protects both the linear list and rbtree.
- */
-
-static struct rb_root memtype_rbroot = RB_ROOT;
-static LIST_HEAD(memtype_list);
-static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype list */
-
-static struct memtype *memtype_rb_search(struct rb_root *root, u64 start)
-{
-	struct rb_node *node = root->rb_node;
-	struct memtype *last_lower = NULL;
-
-	while (node) {
-		struct memtype *data = container_of(node, struct memtype, rb);
-
-		if (data->start < start) {
-			last_lower = data;
-			node = node->rb_right;
-		} else if (data->start > start) {
-			node = node->rb_left;
-		} else
-			return data;
-	}
-
-	/* Will return NULL if there is no entry with its start <= start */
-	return last_lower;
-}
-
-static void memtype_rb_insert(struct rb_root *root, struct memtype *data)
-{
-	struct rb_node **new = &(root->rb_node);
-	struct rb_node *parent = NULL;
-
-	while (*new) {
-		struct memtype *this = container_of(*new, struct memtype, rb);
-
-		parent = *new;
-		if (data->start <= this->start)
-			new = &((*new)->rb_left);
-		else if (data->start > this->start)
-			new = &((*new)->rb_right);
-	}
-
-	rb_link_node(&data->rb, parent, new);
-	rb_insert_color(&data->rb, root);
-}
+static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype accesses */
 
 /*
  * Does intersection of PAT memory type and MTRR memory type and returns
@@ -216,33 +158,6 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
-static int
-chk_conflict(struct memtype *new, struct memtype *entry, unsigned long *type)
-{
-	if (new->type != entry->type) {
-		if (type) {
-			new->type = entry->type;
-			*type = entry->type;
-		} else
-			goto conflict;
-	}
-
-	 /* check overlaps with more than one entry in the list */
-	list_for_each_entry_continue(entry, &memtype_list, nd) {
-		if (new->end <= entry->start)
-			break;
-		else if (new->type != entry->type)
-			goto conflict;
-	}
-	return 0;
-
- conflict:
-	printk(KERN_INFO "%s:%d conflicting memory types "
-	       "%Lx-%Lx %s<->%s\n", current->comm, current->pid, new->start,
-	       new->end, cattr_name(new->type), cattr_name(entry->type));
-	return -EBUSY;
-}
-
 static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
 {
 	int ram_page = 0, not_rampage = 0;
@@ -328,64 +243,6 @@ static int free_ram_pages_type(u64 start, u64 end)
 	return 0;
 }
 
-static int memtype_check_insert(struct memtype *new, unsigned long *new_type)
-{
-	struct memtype *entry;
-	u64 start, end;
-	unsigned long actual_type;
-	struct list_head *where;
-	int err = 0;
-
-	start = new->start;
-	end = new->end;
-	actual_type = new->type;
-
-	/* Search for existing mapping that overlaps the current range */
-	where = NULL;
-	list_for_each_entry(entry, &memtype_list, nd) {
-		if (end <= entry->start) {
-			where = entry->nd.prev;
-			break;
-		} else if (start <= entry->start) { /* end > entry->start */
-			err = chk_conflict(new, entry, new_type);
-			if (!err) {
-				dprintk("Overlap at 0x%Lx-0x%Lx\n",
-					entry->start, entry->end);
-				where = entry->nd.prev;
-			}
-			break;
-		} else if (start < entry->end) { /* start > entry->start */
-			err = chk_conflict(new, entry, new_type);
-			if (!err) {
-				dprintk("Overlap at 0x%Lx-0x%Lx\n",
-					entry->start, entry->end);
-
-				/*
-				 * Move to right position in the linked
-				 * list to add this new entry
-				 */
-				list_for_each_entry_continue(entry,
-							&memtype_list, nd) {
-					if (start <= entry->start) {
-						where = entry->nd.prev;
-						break;
-					}
-				}
-			}
-			break;
-		}
-	}
-	if (!err) {
-		if (where)
-			list_add(&new->nd, where);
-		else
-			list_add_tail(&new->nd, &memtype_list);
-
-		memtype_rb_insert(&memtype_rbroot, new);
-	}
-	return err;
-}
-
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
@@ -459,7 +316,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_lock(&memtype_lock);
 
-	err = memtype_check_insert(new, new_type);
+	err = rbt_memtype_check_insert(new, new_type);
 	if (err) {
 		printk(KERN_INFO "reserve_memtype failed 0x%Lx-0x%Lx, "
 		       "track %s, req %s\n",
@@ -481,7 +338,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 int free_memtype(u64 start, u64 end)
 {
-	struct memtype *entry, *saved_entry;
 	int err = -EINVAL;
 	int is_range_ram;
 
@@ -505,46 +361,7 @@ int free_memtype(u64 start, u64 end)
 	}
 
 	spin_lock(&memtype_lock);
-
-	entry = memtype_rb_search(&memtype_rbroot, start);
-	if (unlikely(entry == NULL))
-		goto unlock_ret;
-
-	/*
-	 * Saved entry points to an entry with start same or less than what
-	 * we searched for. Now go through the list in both directions to look
-	 * for the entry that matches with both start and end, with list stored
-	 * in sorted start address
-	 */
-	saved_entry = entry;
-	list_for_each_entry_from(entry, &memtype_list, nd) {
-		if (entry->start == start && entry->end == end) {
-			rb_erase(&entry->rb, &memtype_rbroot);
-			list_del(&entry->nd);
-			kfree(entry);
-			err = 0;
-			break;
-		} else if (entry->start > start) {
-			break;
-		}
-	}
-
-	if (!err)
-		goto unlock_ret;
-
-	entry = saved_entry;
-	list_for_each_entry_reverse(entry, &memtype_list, nd) {
-		if (entry->start == start && entry->end == end) {
-			rb_erase(&entry->rb, &memtype_rbroot);
-			list_del(&entry->nd);
-			kfree(entry);
-			err = 0;
-			break;
-		} else if (entry->start < start) {
-			break;
-		}
-	}
-unlock_ret:
+	err = rbt_memtype_erase(start, end);
 	spin_unlock(&memtype_lock);
 
 	if (err) {
@@ -593,7 +410,7 @@ static unsigned long lookup_memtype(u64 paddr)
 
 	spin_lock(&memtype_lock);
 
-	entry = memtype_rb_search(&memtype_rbroot, paddr);
+	entry = rbt_memtype_lookup(paddr);
 	if (entry != NULL)
 		rettype = entry->type;
 	else
@@ -930,22 +747,6 @@ EXPORT_SYMBOL_GPL(pgprot_writecombine);
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
-/* get Nth element of the linked list */
-static int copy_memtype_nth_element(struct memtype *out, loff_t pos)
-{
-	struct memtype *list_node;
-	int i = 1;
-
-	list_for_each_entry(list_node, &memtype_list, nd) {
-		if (pos == i) {
-			*out = *list_node;
-			return 0;
-		}
-		++i;
-	}
-	return 1;
-}
-
 static struct memtype *memtype_get_idx(loff_t pos)
 {
 	struct memtype *print_entry;
@@ -956,7 +757,7 @@ static struct memtype *memtype_get_idx(loff_t pos)
 		return NULL;
 
 	spin_lock(&memtype_lock);
-	ret = copy_memtype_nth_element(print_entry, pos);
+	ret = rbt_memtype_copy_nth_element(print_entry, pos);
 	spin_unlock(&memtype_lock);
 
 	if (!ret) {
diff --git a/arch/x86/mm/pat_internal.h b/arch/x86/mm/pat_internal.h
index 6c98780..4f39eef 100644
--- a/arch/x86/mm/pat_internal.h
+++ b/arch/x86/mm/pat_internal.h
@@ -9,8 +9,8 @@ extern int pat_debug_enable;
 struct memtype {
 	u64			start;
 	u64			end;
+	u64			subtree_max_end;
 	unsigned long		type;
-	struct list_head	nd;
 	struct rb_node		rb;
 };
 
@@ -25,4 +25,22 @@ static inline char *cattr_name(unsigned long flags)
 	}
 }
 
+#ifdef CONFIG_X86_PAT
+extern int rbt_memtype_check_insert(struct memtype *new,
+					unsigned long *new_type);
+extern int rbt_memtype_erase(u64 start, u64 end);
+extern struct memtype *rbt_memtype_lookup(u64 addr);
+extern int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos);
+#else
+static inline int rbt_memtype_check_insert(struct memtype *new,
+					unsigned long *new_type)
+{ return 0; }
+static inline int rbt_memtype_erase(u64 start, u64 end)
+{ return 0; }
+static inline struct memtype *rbt_memtype_lookup(u64 addr)
+{ return NULL; }
+static inline int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos)
+{ return 0; }
+#endif
+
 #endif /* __PAT_INTERNAL_H_ */
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
new file mode 100644
index 0000000..e4cd229
--- /dev/null
+++ b/arch/x86/mm/pat_rbtree.c
@@ -0,0 +1,272 @@
+/*
+ * Handle caching attributes in page tables (PAT)
+ *
+ * Authors: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ *          Suresh B Siddha <suresh.b.siddha@intel.com>
+ *
+ * Interval tree (augmented rbtree) used to store the PAT memory type
+ * reservations.
+ */
+
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/gfp.h>
+
+#include <asm/pgtable.h>
+#include <asm/pat.h>
+
+#include "pat_internal.h"
+
+/*
+ * The memtype tree keeps track of memory type for specific
+ * physical memory areas. Without proper tracking, conflicting memory
+ * types in different mappings can cause CPU cache corruption.
+ *
+ * The tree is an interval tree (augmented rbtree) with tree ordered
+ * on starting address. Tree can contain multiple entries for
+ * different regions which overlap. All the aliases have the same
+ * cache attributes of course.
+ *
+ * memtype_lock protects the rbtree.
+ */
+
+static void memtype_rb_augment_cb(struct rb_node *node);
+static struct rb_root memtype_rbroot = RB_AUGMENT_ROOT(&memtype_rb_augment_cb);
+
+static int is_node_overlap(struct memtype *node, u64 start, u64 end)
+{
+	if (node->start >= end || node->end <= start)
+		return 0;
+
+	return 1;
+}
+
+static u64 get_subtree_max_end(struct rb_node *node)
+{
+	u64 ret = 0;
+	if (node) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+		ret = data->subtree_max_end;
+	}
+	return ret;
+}
+
+/* Update 'subtree_max_end' for a node, based on node and its children */
+static void update_node_max_end(struct rb_node *node)
+{
+	struct memtype *data;
+	u64 max_end, child_max_end;
+
+	if (!node)
+		return;
+
+	data = container_of(node, struct memtype, rb);
+	max_end = data->end;
+
+	child_max_end = get_subtree_max_end(node->rb_right);
+	if (child_max_end > max_end)
+		max_end = child_max_end;
+
+	child_max_end = get_subtree_max_end(node->rb_left);
+	if (child_max_end > max_end)
+		max_end = child_max_end;
+
+	data->subtree_max_end = max_end;
+}
+
+/* Update 'subtree_max_end' for a node and all its ancestors */
+static void update_path_max_end(struct rb_node *node)
+{
+	u64 old_max_end, new_max_end;
+
+	while (node) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+
+		old_max_end = data->subtree_max_end;
+		update_node_max_end(node);
+		new_max_end = data->subtree_max_end;
+
+		if (new_max_end == old_max_end)
+			break;
+
+		node = rb_parent(node);
+	}
+}
+
+/* Find the first (lowest start addr) overlapping range from rb tree */
+static struct memtype *memtype_rb_lowest_match(struct rb_root *root,
+				u64 start, u64 end)
+{
+	struct rb_node *node = root->rb_node;
+	struct memtype *last_lower = NULL;
+
+	while (node) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+
+		if (get_subtree_max_end(node->rb_left) > start) {
+			/* Lowest overlap if any must be on left side */
+			node = node->rb_left;
+		} else if (is_node_overlap(data, start, end)) {
+			last_lower = data;
+			break;
+		} else if (start >= data->start) {
+			/* Lowest overlap if any must be on right side */
+			node = node->rb_right;
+		} else {
+			break;
+		}
+	}
+	return last_lower; /* Returns NULL if there is no overlap */
+}
+
+static struct memtype *memtype_rb_exact_match(struct rb_root *root,
+				u64 start, u64 end)
+{
+	struct memtype *match;
+
+	match = memtype_rb_lowest_match(root, start, end);
+	while (match != NULL && match->start < end) {
+		struct rb_node *node;
+
+		if (match->start == start && match->end == end)
+			return match;
+
+		node = rb_next(&match->rb);
+		if (node)
+			match = container_of(node, struct memtype, rb);
+		else
+			match = NULL;
+	}
+
+	return NULL; /* Returns NULL if there is no exact match */
+}
+
+static int memtype_rb_check_conflict(struct rb_root *root,
+				u64 start, u64 end,
+				unsigned long reqtype, unsigned long *newtype)
+{
+	struct rb_node *node;
+	struct memtype *match;
+	int found_type = reqtype;
+
+	match = memtype_rb_lowest_match(&memtype_rbroot, start, end);
+	if (match == NULL)
+		goto success;
+
+	if (match->type != found_type && newtype == NULL)
+		goto failure;
+
+	dprintk("Overlap at 0x%Lx-0x%Lx\n", match->start, match->end);
+	found_type = match->type;
+
+	node = rb_next(&match->rb);
+	while (node) {
+		match = container_of(node, struct memtype, rb);
+
+		if (match->start >= end) /* Checked all possible matches */
+			goto success;
+
+		if (is_node_overlap(match, start, end) &&
+		    match->type != found_type) {
+			goto failure;
+		}
+
+		node = rb_next(&match->rb);
+	}
+success:
+	if (newtype)
+		*newtype = found_type;
+
+	return 0;
+
+failure:
+	printk(KERN_INFO "%s:%d conflicting memory types "
+		"%Lx-%Lx %s<->%s\n", current->comm, current->pid, start,
+		end, cattr_name(found_type), cattr_name(match->type));
+	return -EBUSY;
+}
+
+static void memtype_rb_augment_cb(struct rb_node *node)
+{
+	if (node)
+		update_path_max_end(node);
+}
+
+static void memtype_rb_insert(struct rb_root *root, struct memtype *newdata)
+{
+	struct rb_node **node = &(root->rb_node);
+	struct rb_node *parent = NULL;
+
+	while (*node) {
+		struct memtype *data = container_of(*node, struct memtype, rb);
+
+		parent = *node;
+		if (newdata->start <= data->start)
+			node = &((*node)->rb_left);
+		else if (newdata->start > data->start)
+			node = &((*node)->rb_right);
+	}
+
+	rb_link_node(&newdata->rb, parent, node);
+	rb_insert_color(&newdata->rb, root);
+}
+
+int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
+{
+	int err = 0;
+
+	err = memtype_rb_check_conflict(&memtype_rbroot, new->start, new->end,
+						new->type, ret_type);
+
+	if (!err) {
+		new->type = *ret_type;
+		memtype_rb_insert(&memtype_rbroot, new);
+	}
+	return err;
+}
+
+int rbt_memtype_erase(u64 start, u64 end)
+{
+	struct memtype *data;
+
+	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
+	if (!data)
+		return -EINVAL;
+
+	rb_erase(&data->rb, &memtype_rbroot);
+	return 0;
+}
+
+struct memtype *rbt_memtype_lookup(u64 addr)
+{
+	struct memtype *data;
+	data = memtype_rb_lowest_match(&memtype_rbroot, addr, addr + PAGE_SIZE);
+	return data;
+}
+
+#if defined(CONFIG_DEBUG_FS)
+int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos)
+{
+	struct rb_node *node;
+	int i = 1;
+
+	node = rb_first(&memtype_rbroot);
+	while (node && pos != i) {
+		node = rb_next(node);
+		i++;
+	}
+
+	if (node) { /* pos == i */
+		struct memtype *this = container_of(node, struct memtype, rb);
+		*out = *this;
+		return 0;
+	} else {
+		return 1;
+	}
+}
+#endif
+
-- 
1.6.0.6

