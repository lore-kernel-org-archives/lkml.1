Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0BJVeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:34:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:44197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0BJVeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:34:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,446,1262592000"; 
   d="scan'208";a="594868397"
Message-Id: <20100210195909.792781000@intel.com>
References: <20100210195704.434039000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Feb 2010 11:57:06 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/3] x86: Preparatory changes in pat.c for bigger rbtree change
Content-Disposition: inline; filename=0002-x86-Preparatory-changes-in-pat.c-for-bigger-rbtree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor changes in pat.c to cleanup code and make it smoother to introduce
bigger rbtree only change in the following patch. The changes are cleaup
only and should not have any functional impact.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c          |  170 +++++++++++++++++++++++---------------------
 arch/x86/mm/pat_internal.h |   28 +++++++
 2 files changed, 116 insertions(+), 82 deletions(-)
 create mode 100644 arch/x86/mm/pat_internal.h

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ae9648e..628e507 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -30,6 +30,8 @@
 #include <asm/pat.h>
 #include <asm/io.h>
 
+#include "pat_internal.h"
+
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
@@ -53,19 +55,15 @@ static inline void pat_disable(const char *reason)
 #endif
 
 
-static int debug_enable;
+int pat_debug_enable;
 
 static int __init pat_debug_setup(char *str)
 {
-	debug_enable = 1;
+	pat_debug_enable = 1;
 	return 0;
 }
 __setup("debugpat", pat_debug_setup);
 
-#define dprintk(fmt, arg...) \
-	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
-
-
 static u64 __read_mostly boot_pat_state;
 
 enum {
@@ -132,17 +130,6 @@ void pat_init(void)
 
 #undef PAT
 
-static char *cattr_name(unsigned long flags)
-{
-	switch (flags & _PAGE_CACHE_MASK) {
-	case _PAGE_CACHE_UC:		return "uncached";
-	case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
-	case _PAGE_CACHE_WB:		return "write-back";
-	case _PAGE_CACHE_WC:		return "write-combining";
-	default:			return "broken";
-	}
-}
-
 /*
  * The global memtype list keeps track of memory type for specific
  * physical memory areas. Conflicting memory types in different
@@ -159,14 +146,6 @@ static char *cattr_name(unsigned long flags)
  * memtype_lock protects both the linear list and rbtree.
  */
 
-struct memtype {
-	u64			start;
-	u64			end;
-	unsigned long		type;
-	struct list_head	nd;
-	struct rb_node		rb;
-};
-
 static struct rb_root memtype_rbroot = RB_ROOT;
 static LIST_HEAD(memtype_list);
 static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype list */
@@ -349,6 +328,64 @@ static int free_ram_pages_type(u64 start, u64 end)
 	return 0;
 }
 
+static int memtype_check_insert(struct memtype *new, unsigned long *new_type)
+{
+	struct memtype *entry;
+	u64 start, end;
+	unsigned long actual_type;
+	struct list_head *where;
+	int err = 0;
+
+	start = new->start;
+	end = new->end;
+	actual_type = new->type;
+
+	/* Search for existing mapping that overlaps the current range */
+	where = NULL;
+	list_for_each_entry(entry, &memtype_list, nd) {
+		if (end <= entry->start) {
+			where = entry->nd.prev;
+			break;
+		} else if (start <= entry->start) { /* end > entry->start */
+			err = chk_conflict(new, entry, new_type);
+			if (!err) {
+				dprintk("Overlap at 0x%Lx-0x%Lx\n",
+					entry->start, entry->end);
+				where = entry->nd.prev;
+			}
+			break;
+		} else if (start < entry->end) { /* start > entry->start */
+			err = chk_conflict(new, entry, new_type);
+			if (!err) {
+				dprintk("Overlap at 0x%Lx-0x%Lx\n",
+					entry->start, entry->end);
+
+				/*
+				 * Move to right position in the linked
+				 * list to add this new entry
+				 */
+				list_for_each_entry_continue(entry,
+							&memtype_list, nd) {
+					if (start <= entry->start) {
+						where = entry->nd.prev;
+						break;
+					}
+				}
+			}
+			break;
+		}
+	}
+	if (!err) {
+		if (where)
+			list_add(&new->nd, where);
+		else
+			list_add_tail(&new->nd, &memtype_list);
+
+		memtype_rb_insert(&memtype_rbroot, new);
+	}
+	return err;
+}
+
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
@@ -364,9 +401,8 @@ static int free_ram_pages_type(u64 start, u64 end)
 int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		    unsigned long *new_type)
 {
-	struct memtype *new, *entry;
+	struct memtype *new;
 	unsigned long actual_type;
-	struct list_head *where;
 	int is_range_ram;
 	int err = 0;
 
@@ -423,42 +459,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_lock(&memtype_lock);
 
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
-
+	err = memtype_check_insert(new, new_type);
 	if (err) {
 		printk(KERN_INFO "reserve_memtype failed 0x%Lx-0x%Lx, "
 		       "track %s, req %s\n",
@@ -469,13 +470,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return err;
 	}
 
-	if (where)
-		list_add(&new->nd, where);
-	else
-		list_add_tail(&new->nd, &memtype_list);
-
-	memtype_rb_insert(&memtype_rbroot, new);
-
 	spin_unlock(&memtype_lock);
 
 	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
@@ -937,28 +931,40 @@ EXPORT_SYMBOL_GPL(pgprot_writecombine);
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
 /* get Nth element of the linked list */
-static struct memtype *memtype_get_idx(loff_t pos)
+static int copy_memtype_nth_element(struct memtype *out, loff_t pos)
 {
-	struct memtype *list_node, *print_entry;
+	struct memtype *list_node;
 	int i = 1;
 
-	print_entry  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
-	if (!print_entry)
-		return NULL;
-
-	spin_lock(&memtype_lock);
 	list_for_each_entry(list_node, &memtype_list, nd) {
 		if (pos == i) {
-			*print_entry = *list_node;
-			spin_unlock(&memtype_lock);
-			return print_entry;
+			*out = *list_node;
+			return 0;
 		}
 		++i;
 	}
+	return 1;
+}
+
+static struct memtype *memtype_get_idx(loff_t pos)
+{
+	struct memtype *print_entry;
+	int ret;
+
+	print_entry  = kzalloc(sizeof(struct memtype), GFP_KERNEL);
+	if (!print_entry)
+		return NULL;
+
+	spin_lock(&memtype_lock);
+	ret = copy_memtype_nth_element(print_entry, pos);
 	spin_unlock(&memtype_lock);
-	kfree(print_entry);
 
-	return NULL;
+	if (!ret) {
+		return print_entry;
+	} else {
+		kfree(print_entry);
+		return NULL;
+	}
 }
 
 static void *memtype_seq_start(struct seq_file *seq, loff_t *pos)
diff --git a/arch/x86/mm/pat_internal.h b/arch/x86/mm/pat_internal.h
new file mode 100644
index 0000000..6c98780
--- /dev/null
+++ b/arch/x86/mm/pat_internal.h
@@ -0,0 +1,28 @@
+#ifndef __PAT_INTERNAL_H_
+#define __PAT_INTERNAL_H_
+
+extern int pat_debug_enable;
+
+#define dprintk(fmt, arg...) \
+	do { if (pat_debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
+
+struct memtype {
+	u64			start;
+	u64			end;
+	unsigned long		type;
+	struct list_head	nd;
+	struct rb_node		rb;
+};
+
+static inline char *cattr_name(unsigned long flags)
+{
+	switch (flags & _PAGE_CACHE_MASK) {
+	case _PAGE_CACHE_UC:		return "uncached";
+	case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
+	case _PAGE_CACHE_WB:		return "write-back";
+	case _PAGE_CACHE_WC:		return "write-combining";
+	default:			return "broken";
+	}
+}
+
+#endif /* __PAT_INTERNAL_H_ */
-- 
1.6.0.6

-- 

