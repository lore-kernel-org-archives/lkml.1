Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0BSAY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:24:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:36045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0BSAYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:24:47 -0500
Date: Fri, 19 Feb 2010 00:22:05 GMT
From: "tip-bot for venkatesh.pallipadi@intel.com" 
	<venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
In-Reply-To: <20100210195909.792781000@intel.com>
References: <20100210195909.792781000@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86, pat: Preparatory changes in pat.c for bigger rbtree change
Message-ID: <tip-be5a0c126ad1dea2128dc5aef12c87083518d1ab@git.kernel.org>
Git-Commit-ID: be5a0c126ad1dea2128dc5aef12c87083518d1ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 00:22:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be5a0c126ad1dea2128dc5aef12c87083518d1ab
Gitweb:     http://git.kernel.org/tip/be5a0c126ad1dea2128dc5aef12c87083518d1ab
Author:     venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
AuthorDate: Wed, 10 Feb 2010 11:57:06 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Feb 2010 15:41:21 -0800

x86, pat: Preparatory changes in pat.c for bigger rbtree change

Minor changes in pat.c to cleanup code and make it smoother to introduce
bigger rbtree only change in the following patch. The changes are cleaup
only and should not have any functional impact.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20100210195909.792781000@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/pat.c          |  170 +++++++++++++++++++++++---------------------
 arch/x86/mm/pat_internal.h |   28 +++++++
 2 files changed, 116 insertions(+), 82 deletions(-)

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
