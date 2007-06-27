Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbXF0Cop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbXF0Cop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbXF0CoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:44:23 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3553 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbXF0CoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:44:21 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 26 Jun 2007 19:44:18 -0700
Subject: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO page retirement policy
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.29496.1182912259.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the core implementation of the new VM_NOZERO page retirement
policy (and the associated MAP_NOZERO).
A new field  owner_uid  is added the the  mm_struct, and it is kept set to
the effective UID of the task that own the  mm_struct.
A new field  owner_uid  is also added to the page struct.
When pages exit (unmapped from) a  vma, they are marked with the effective
UID of the  mm_struct  that owns it.
When pages exit the allocator, their  owner_uid  is cleared, unless the
new flag __GFP_UIDKEEP is passed to it. So every page fetcher other than
the new alloc_zeroed_page_vma(), clears the owner_uid and blocks all the
following uses of the uncleared page itself.
The new alloc_zeroed_page_vma() calls __alloc_pages() with the __GFP_UIDKEEP
flag, and checks if the VM_NOZERO flag is set in the vma, and if the  owner_uid
field of the page matches the one of the  mm_struct  owning the vma.
If any of these test fail, the page is cleared in the usual way, otherwise
it is passed back without being cleared.
Page-cache pages are (once unmapped) marked with the uid owning the  inode
of the mapping the pages are associated with.




Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



---
 include/asm-alpha/page.h     |    3 ++-
 include/asm-cris/page.h      |    3 ++-
 include/asm-generic/mman.h   |    1 +
 include/asm-h8300/page.h     |    3 ++-
 include/asm-i386/page.h      |    3 ++-
 include/asm-ia64/page.h      |    2 +-
 include/asm-m32r/page.h      |    3 ++-
 include/asm-m68knommu/page.h |    3 ++-
 include/asm-s390/page.h      |    3 ++-
 include/asm-x86_64/page.h    |    3 ++-
 include/linux/gfp.h          |    5 +++++
 include/linux/highmem.h      |    7 +------
 include/linux/mm.h           |   16 ++++++++++++++++
 include/linux/mm_types.h     |    1 +
 include/linux/mman.h         |    3 ++-
 include/linux/rmap.h         |    1 +
 include/linux/sched.h        |    3 +++
 kernel/fork.c                |    1 +
 kernel/sys.c                 |    3 +++
 mm/filemap.c                 |    2 ++
 mm/mmap.c                    |    3 ++-
 mm/page_alloc.c              |   33 +++++++++++++++++++++++++++++++++
 mm/rmap.c                    |   14 ++++++++++++++
 23 files changed, 102 insertions(+), 17 deletions(-)

Index: linux-2.6.mod/include/linux/sched.h
===================================================================
--- linux-2.6.mod.orig/include/linux/sched.h	2007-06-21 13:59:38.000000000 -0700
+++ linux-2.6.mod/include/linux/sched.h	2007-06-21 14:01:28.000000000 -0700
@@ -386,6 +386,9 @@
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
+
+	/* Effective UID of the owner of this mm_struct */
+	uid_t			owner_uid;
 };
 
 struct sighand_struct {
Index: linux-2.6.mod/mm/rmap.c
===================================================================
--- linux-2.6.mod.orig/mm/rmap.c	2007-06-21 14:27:19.000000000 -0700
+++ linux-2.6.mod/mm/rmap.c	2007-06-25 17:42:59.000000000 -0700
@@ -627,6 +627,16 @@
 }
 #endif
 
+void page_set_owner(struct page *page, uid_t owner_uid)
+{
+	if (unlikely(PageCompound(page))) {
+		unsigned int nrpages = 1U << compound_order(page);
+		for (; nrpages; nrpages--, page++)
+			page_set_owner_uid(page, owner_uid);
+	} else
+		page_set_owner_uid(page, owner_uid);
+}
+
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
@@ -649,6 +659,10 @@
 				print_symbol (KERN_EMERG "  vma->vm_file->f_op->mmap = %s\n", (unsigned long)vma->vm_file->f_op->mmap);
 			BUG();
 		}
+		/*
+		 * Record the last owner of the page.
+		 */
+		page_set_owner(page, vma->vm_mm->owner_uid);
 
 		/*
 		 * It would be tidy to reset the PageAnon mapping here,
Index: linux-2.6.mod/kernel/fork.c
===================================================================
--- linux-2.6.mod.orig/kernel/fork.c	2007-06-21 14:32:44.000000000 -0700
+++ linux-2.6.mod/kernel/fork.c	2007-06-24 21:23:52.000000000 -0700
@@ -342,6 +342,7 @@
 	mm->ioctx_list = NULL;
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
+	mm->owner_uid = current->euid;
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
Index: linux-2.6.mod/include/linux/highmem.h
===================================================================
--- linux-2.6.mod.orig/include/linux/highmem.h	2007-06-21 14:38:02.000000000 -0700
+++ linux-2.6.mod/include/linux/highmem.h	2007-06-22 12:10:36.000000000 -0700
@@ -76,12 +76,7 @@
 static inline struct page *
 alloc_zeroed_user_highpage(struct vm_area_struct *vma, unsigned long vaddr)
 {
-	struct page *page = alloc_page_vma(GFP_HIGHUSER, vma, vaddr);
-
-	if (page)
-		clear_user_highpage(page, vaddr);
-
-	return page;
+	return alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr);
 }
 #endif
 
Index: linux-2.6.mod/include/linux/mm.h
===================================================================
--- linux-2.6.mod.orig/include/linux/mm.h	2007-06-21 14:43:06.000000000 -0700
+++ linux-2.6.mod/include/linux/mm.h	2007-06-25 19:27:42.000000000 -0700
@@ -169,6 +169,7 @@
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
+#define VM_NOZERO	0x08000000	/* Do not zero the page, if possible */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
@@ -647,6 +648,21 @@
 	return atomic_read(&(page)->_mapcount) >= 0;
 }
 
+static inline void reset_owner_uid(struct page *page)
+{
+	page->owner_uid = -1;
+}
+
+static inline uid_t page_owner_uid(struct page *page)
+{
+	return (uid_t) page->owner_uid;
+}
+
+static inline void page_set_owner_uid(struct page *page, uid_t uid)
+{
+	page->owner_uid = (int) uid;
+}
+
 /*
  * Error return values for the *_nopage functions
  */
Index: linux-2.6.mod/include/asm-alpha/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-alpha/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-alpha/page.h	2007-06-21 16:40:19.000000000 -0700
@@ -17,7 +17,8 @@
 extern void clear_page(void *page);
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vmaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 extern void copy_page(void * _to, void * _from);
Index: linux-2.6.mod/include/asm-cris/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-cris/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-cris/page.h	2007-06-21 16:40:08.000000000 -0700
@@ -20,7 +20,8 @@
 #define clear_user_page(page, vaddr, pg)    clear_page(page)
 #define copy_user_page(to, from, vaddr, pg) copy_page(to, from)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 /*
Index: linux-2.6.mod/include/asm-h8300/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-h8300/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-h8300/page.h	2007-06-21 16:39:57.000000000 -0700
@@ -22,7 +22,8 @@
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 /*
Index: linux-2.6.mod/include/asm-i386/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-i386/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-i386/page.h	2007-06-21 16:39:47.000000000 -0700
@@ -34,7 +34,8 @@
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 /*
Index: linux-2.6.mod/include/asm-ia64/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-ia64/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-ia64/page.h	2007-06-21 16:39:27.000000000 -0700
@@ -89,7 +89,7 @@
 
 #define alloc_zeroed_user_highpage(vma, vaddr) \
 ({						\
-	struct page *page = alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr); \
+	struct page *page = alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr); \
 	if (page)				\
  		flush_dcache_page(page);	\
 	page;					\
Index: linux-2.6.mod/include/asm-m32r/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-m32r/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-m32r/page.h	2007-06-21 16:39:00.000000000 -0700
@@ -15,7 +15,8 @@
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 /*
Index: linux-2.6.mod/include/asm-m68knommu/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-m68knommu/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-m68knommu/page.h	2007-06-21 16:38:49.000000000 -0700
@@ -22,7 +22,8 @@
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 /*
Index: linux-2.6.mod/include/asm-s390/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-s390/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-s390/page.h	2007-06-21 16:38:35.000000000 -0700
@@ -64,7 +64,8 @@
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 /*
Index: linux-2.6.mod/include/asm-x86_64/page.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86_64/page.h	2007-06-21 16:37:20.000000000 -0700
+++ linux-2.6.mod/include/asm-x86_64/page.h	2007-06-21 16:38:13.000000000 -0700
@@ -48,7 +48,8 @@
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage(vma, vaddr) alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vma, vaddr)
+#define alloc_zeroed_user_highpage(vma, vaddr) \
+	alloc_zeroed_page_vma(vma, GFP_HIGHUSER, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 /*
  * These are used to make use of C type-checking..
Index: linux-2.6.mod/include/asm-generic/mman.h
===================================================================
--- linux-2.6.mod.orig/include/asm-generic/mman.h	2007-06-21 16:43:33.000000000 -0700
+++ linux-2.6.mod/include/asm-generic/mman.h	2007-06-21 18:14:55.000000000 -0700
@@ -13,6 +13,7 @@
 #define PROT_NONE	0x0		/* page can not be accessed */
 #define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
 #define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
+#define MAP_NOZERO	0x04000000	/* Do not zero the pages, if possible */
 
 #define MAP_SHARED	0x01		/* Share changes */
 #define MAP_PRIVATE	0x02		/* Changes are private */
Index: linux-2.6.mod/include/linux/mman.h
===================================================================
--- linux-2.6.mod.orig/include/linux/mman.h	2007-06-21 16:47:03.000000000 -0700
+++ linux-2.6.mod/include/linux/mman.h	2007-06-21 16:47:45.000000000 -0700
@@ -63,7 +63,8 @@
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
 	       _calc_vm_trans(flags, MAP_EXECUTABLE, VM_EXECUTABLE) |
-	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
+	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
+	       _calc_vm_trans(flags, MAP_NOZERO,     VM_NOZERO    );
 }
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MMAN_H */
Index: linux-2.6.mod/mm/mmap.c
===================================================================
--- linux-2.6.mod.orig/mm/mmap.c	2007-06-21 16:48:31.000000000 -0700
+++ linux-2.6.mod/mm/mmap.c	2007-06-25 19:14:49.000000000 -0700
@@ -915,7 +915,8 @@
 
 	if (!len)
 		return -EINVAL;
-
+	if (file && (flags & MAP_NOZERO))
+		return -EINVAL;
 	error = arch_mmap_check(addr, len, flags);
 	if (error)
 		return error;
Index: linux-2.6.mod/mm/page_alloc.c
===================================================================
--- linux-2.6.mod.orig/mm/page_alloc.c	2007-06-22 10:56:07.000000000 -0700
+++ linux-2.6.mod/mm/page_alloc.c	2007-06-25 17:40:23.000000000 -0700
@@ -1370,11 +1370,44 @@
 		show_mem();
 	}
 got_pg:
+	if (page && !(gfp_mask & __GFP_UIDKEEP)) {
+		unsigned int pgcount = 1U << order;
+		struct page *npage = page;
+
+		/*
+		 * It'd be possible to remove the loop below by resetting
+		 * page->owner_uid when the page is handed back to the buddy
+		 * allocator. Here we would simply reset page->owner_uid only.
+		 * This reduces the efficency of page reuse though, since pages
+		 * used by a user may be reset too early.
+		 */
+		for (; pgcount; pgcount--, npage++)
+			reset_owner_uid(npage);
+	}
 	return page;
 }
 
 EXPORT_SYMBOL(__alloc_pages);
 
+static inline int page_need_clear(struct vm_area_struct *vma, struct page *page)
+{
+	return (vma->vm_flags & VM_NOZERO) == 0 ||
+		page_owner_uid(page) != vma->vm_mm->owner_uid;
+}
+
+struct page *alloc_zeroed_page_vma(struct vm_area_struct *vma, gfp_t gfp_mask,
+				   unsigned long vaddr)
+{
+	struct page *page = alloc_page_vma(gfp_mask | __GFP_UIDKEEP, vma, vaddr);
+
+	if (page) {
+		if (page_need_clear(vma, page))
+			clear_user_highpage(page, vaddr);
+		reset_owner_uid(page);
+	}
+	return page;
+}
+
 /*
  * Common helper functions.
  */
Index: linux-2.6.mod/include/linux/gfp.h
===================================================================
--- linux-2.6.mod.orig/include/linux/gfp.h	2007-06-21 16:32:34.000000000 -0700
+++ linux-2.6.mod/include/linux/gfp.h	2007-06-22 12:15:14.000000000 -0700
@@ -45,6 +45,7 @@
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
 #define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
+#define __GFP_UIDKEEP	((__force gfp_t)0x80000u)	/* Do not clear owner UID */
 
 #define __GFP_BITS_SHIFT 20	/* Room for 20 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
@@ -124,6 +125,10 @@
 extern struct page *
 FASTCALL(__alloc_pages(gfp_t, unsigned int, struct zonelist *));
 
+extern struct page *alloc_zeroed_page_vma(struct vm_area_struct *vma,
+					  gfp_t gfp_mask,
+					  unsigned long vaddr);
+
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
Index: linux-2.6.mod/mm/filemap.c
===================================================================
--- linux-2.6.mod.orig/mm/filemap.c	2007-06-24 21:03:07.000000000 -0700
+++ linux-2.6.mod/mm/filemap.c	2007-06-24 22:12:40.000000000 -0700
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/mman.h>
+#include <linux/rmap.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/uio.h>
@@ -118,6 +119,7 @@
 
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
+	page_set_owner(page, mapping->host->i_uid);
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 }
Index: linux-2.6.mod/include/linux/rmap.h
===================================================================
--- linux-2.6.mod.orig/include/linux/rmap.h	2007-06-24 21:28:50.000000000 -0700
+++ linux-2.6.mod/include/linux/rmap.h	2007-06-24 21:29:13.000000000 -0700
@@ -72,6 +72,7 @@
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
+void page_set_owner(struct page *page, uid_t owner_uid);
 void page_remove_rmap(struct page *, struct vm_area_struct *);
 
 #ifdef CONFIG_DEBUG_VM
Index: linux-2.6.mod/include/linux/mm_types.h
===================================================================
--- linux-2.6.mod.orig/include/linux/mm_types.h	2007-06-21 14:02:06.000000000 -0700
+++ linux-2.6.mod/include/linux/mm_types.h	2007-06-25 19:11:22.000000000 -0700
@@ -64,6 +64,7 @@
 	struct list_head lru;		/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
 					 */
+	int owner_uid;			/* Last owner of the page */
 	/*
 	 * On machines where all RAM is mapped into kernel address space,
 	 * we can simply calculate the virtual address. On machines with
Index: linux-2.6.mod/kernel/sys.c
===================================================================
--- linux-2.6.mod.orig/kernel/sys.c	2007-06-26 17:40:19.000000000 -0700
+++ linux-2.6.mod/kernel/sys.c	2007-06-26 17:46:08.000000000 -0700
@@ -1149,6 +1149,7 @@
 
 	if (new_euid != old_euid) {
 		current->mm->dumpable = suid_dumpable;
+		current->mm->owner_uid = new_euid;
 		smp_wmb();
 	}
 	current->fsuid = current->euid = new_euid;
@@ -1199,6 +1200,7 @@
 
 	if (old_euid != uid) {
 		current->mm->dumpable = suid_dumpable;
+		current->mm->owner_uid = uid;
 		smp_wmb();
 	}
 	current->fsuid = current->euid = uid;
@@ -1244,6 +1246,7 @@
 	if (euid != (uid_t) -1) {
 		if (euid != current->euid) {
 			current->mm->dumpable = suid_dumpable;
+			current->mm->owner_uid = euid;
 			smp_wmb();
 		}
 		current->euid = euid;

