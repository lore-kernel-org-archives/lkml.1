Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZAMKxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZAMKxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZAMKwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:52:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZAMKwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:52:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090112235550.2d6be428.akpm@linux-foundation.org>
References: <20090112235550.2d6be428.akpm@linux-foundation.org> <20090108125346.28454.90871.stgit@warthog.procyon.org.uk> <20090108125407.28454.29221.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, bernds_cb1@t-online.de,
       rgetz@blackfin.uclinux.org, vapier.adi@gmail.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] NOMMU: Make VMAs per MM as for MMU-mode linux [ver #3]
Date: Tue, 13 Jan 2009 10:51:28 +0000
Message-ID: <10270.1231843888@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +		K((unsigned long) atomic_read(&mmap_pages_allocated)),
> 
> This is slightly wrong, as atomic_read() returns "int".  It will show
> weird results on 64-bit nommu machines which allocate more than 2G pages :)

Okay...  I'll make mmap_pages_allocated an atomic_long.  That should be
exactly the same on a 32-bit system.

> > +		   vma->vm_pgoff << PAGE_SHIFT,
> 
> This will overflow at file offsets >4G?

True.  I'll cast it to unsigned long long before shifting and adjust the print
format to %08llx.

> > +	vm_area_cachep = kmem_cache_create("vm_area_struct",
> > +			sizeof(struct vm_area_struct), 0,
> > +			SLAB_PANIC, NULL);
> 
> We have the KMEM_CACHE() macro for this.

Not that fork.c seems to use it.

> (I see this was copy-n-pasted from fork.c.  Why was it moved?)

Because I wanted to do something different for vm_area_struct under nommu for
a time.  I'll move it back.

> open-coded BUG_ON()

All changed.

> `region' could be local to this block, if one feels so inclined.

But then you can't look in the variable with gdb.

> > +#define validate_nommu_regions() do {} while(0)
> 
> There's no need to implement this in cpp...

True.  There's also no need to implement it as a static inline either.

> > +static void free_page_series(unsigned long from, unsigned long to)
> > ...
> > +		atomic_dec(&mmap_pages_allocated);
> 
> This isn't counting "pages allocated".  It's counting page *refcounts*.
> Now, perhaps these pages will always have a refcount of 1 (why?), in
> which case things happen to work out.  But if so, the next line isn't
> needed:

It's actually keeping track of the number of pages we have recorded in
vm_region structs as being allocated.  Once we put the pages here, we can't
track them anymore.

Furthermore, they should have a refcount of 1 at this point, unless there's a
bug in ptrace or direct I/O.

> > +		if (page_count(page) != 1)
> 
> should be "== 1", surely?

Why?  That would be silly.  I want to warn _if_ the page count isn't what I
expect, not if it is.  I'll adjust the text of the warning to make it clear.

> > + * - the caller must hold the region semaphore, which this releases
> 
> "for writing"

Yep.

> > +		printk(KERN_WARNING
> > +		       "munmap of memory not mmapped by process %d (%s):"
> > +		       " 0x%lx-0x%lx\n",
> > +		       current->pid, current->comm, start, start + len - 1);
> 
> Unprivileged userspace can spam logs?  Perhaps not a concern on typical
> nommu systems.  But buggy userspace can spam logs, too, which _is_ a
> problem?

I'll limit it to 5 printks.  But this is NOMMU: if userspace wants to corrupt
the kernel, it can do so at will.


Patch attached.  Now I have to go and catch a plane to Australia.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Fix a number of issues with the per-MM VMA patch

Fix a number of issues with the per-MM VMA patch:

 (1) Make mmap_pages_allocated an atomic_long_t, just in case this is used on
     a NOMMU system with more than 2G pages.  Makes no difference on a 32-bit
     system.

 (2) Report vma->vm_pgoff * PAGE_SIZE as a 64-bit value, not a 32-bit value,
     lest it overflow.

 (3) Move the allocation of the vm_area_struct slab back for fork.c.

 (4) Use KMEM_CACHE() for both vm_area_struct and vm_region slabs.

 (5) Use BUG_ON() rather than if () BUG().

 (6) Make the default validate_nommu_regions() a static inline rather than a
     #define.

 (7) Make free_page_series()'s objection to pages with a refcount != 1 more
     informative.

 (8) Adjust the __put_nommu_region() banner comment to indicate that the
     semaphore must be held for writing.

 (9) Limit the number of warnings about munmaps of non-mmapped regions.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/meminfo.c    |    2 +-
 fs/proc/task_nommu.c |    4 ++--
 include/linux/mm.h   |    2 +-
 kernel/fork.c        |    1 +
 mm/mmap.c            |    3 ---
 mm/nommu.c           |   52 ++++++++++++++++++++++++--------------------------
 6 files changed, 30 insertions(+), 34 deletions(-)


diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 43d2394..74ea974 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -120,7 +120,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		K(i.freeram-i.freehigh),
 #endif
 #ifndef CONFIG_MMU
-		K((unsigned long) atomic_read(&mmap_pages_allocated)),
+		K((unsigned long) atomic_long_read(&mmap_pages_allocated)),
 #endif
 		K(i.totalswap),
 		K(i.freeswap),
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 343ea12..370be0a 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -136,14 +136,14 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 	}
 
 	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 		   vma->vm_start,
 		   vma->vm_end,
 		   flags & VM_READ ? 'r' : '-',
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   vma->vm_pgoff << PAGE_SHIFT,
+		   (unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b91a73f..d9a832c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1064,7 +1064,7 @@ static inline void setup_per_cpu_pageset(void) {}
 #endif
 
 /* nommu.c */
-extern atomic_t mmap_pages_allocated;
+extern atomic_long_t mmap_pages_allocated;
 
 /* prio_tree.c */
 void vma_prio_tree_add(struct vm_area_struct *, struct vm_area_struct *old);
diff --git a/kernel/fork.c b/kernel/fork.c
index 1d68f12..119b6ed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1484,6 +1484,7 @@ void __init proc_caches_init(void)
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC);
 	mmap_init();
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 7496231..46d126c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2478,7 +2478,4 @@ void mm_drop_all_locks(struct mm_struct *mm)
  */
 void __init mmap_init(void)
 {
-	vm_area_cachep = kmem_cache_create("vm_area_struct",
-			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
 }
diff --git a/mm/nommu.c b/mm/nommu.c
index 60ed837..427d8c4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -69,7 +69,7 @@ int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
 int heap_stack_gap = 0;
 
-atomic_t mmap_pages_allocated;
+atomic_long_t mmap_pages_allocated;
 
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(num_physpages);
@@ -445,12 +445,7 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
  */
 void __init mmap_init(void)
 {
-	vm_region_jar = kmem_cache_create("vm_region_jar",
-					  sizeof(struct vm_region), 0,
-					  SLAB_PANIC, NULL);
-	vm_area_cachep = kmem_cache_create("vm_area_struct",
-					   sizeof(struct vm_area_struct), 0,
-					   SLAB_PANIC, NULL);
+	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC);
 }
 
 /*
@@ -468,27 +463,24 @@ static noinline void validate_nommu_regions(void)
 		return;
 
 	last = rb_entry(lastp, struct vm_region, vm_rb);
-	if (unlikely(last->vm_end <= last->vm_start))
-		BUG();
-	if (unlikely(last->vm_top < last->vm_end))
-		BUG();
+	BUG_ON(unlikely(last->vm_end <= last->vm_start));
+	BUG_ON(unlikely(last->vm_top < last->vm_end));
 
 	while ((p = rb_next(lastp))) {
 		region = rb_entry(p, struct vm_region, vm_rb);
 		last = rb_entry(lastp, struct vm_region, vm_rb);
 
-		if (unlikely(region->vm_end <= region->vm_start))
-			BUG();
-		if (unlikely(region->vm_top < region->vm_end))
-			BUG();
-		if (unlikely(region->vm_start < last->vm_top))
-			BUG();
+		BUG_ON(unlikely(region->vm_end <= region->vm_start));
+		BUG_ON(unlikely(region->vm_top < region->vm_end));
+		BUG_ON(unlikely(region->vm_start < last->vm_top));
 
 		lastp = p;
 	}
 }
 #else
-#define validate_nommu_regions() do {} while(0)
+static void validate_nommu_regions(void)
+{
+}
 #endif
 
 /*
@@ -545,16 +537,17 @@ static void free_page_series(unsigned long from, unsigned long to)
 		struct page *page = virt_to_page(from);
 
 		kdebug("- free %lx", from);
-		atomic_dec(&mmap_pages_allocated);
+		atomic_long_dec(&mmap_pages_allocated);
 		if (page_count(page) != 1)
-			kdebug("free page %p [%d]", page, page_count(page));
+			kdebug("free page %p: refcount not one: %d",
+			       page, page_count(page));
 		put_page(page);
 	}
 }
 
 /*
  * release a reference to a region
- * - the caller must hold the region semaphore, which this releases
+ * - the caller must hold the region semaphore for writing, which this releases
  * - the region may not have been added to the tree yet, in which case vm_top
  *   will equal vm_start
  */
@@ -1078,7 +1071,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
 		goto enomem;
 
 	total = 1 << order;
-	atomic_add(total, &mmap_pages_allocated);
+	atomic_long_add(total, &mmap_pages_allocated);
 
 	point = rlen >> PAGE_SHIFT;
 
@@ -1089,7 +1082,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
 			order = ilog2(total - point);
 			n = 1 << order;
 			kdebug("shave %lu/%lu @%lu", n, total - point, total);
-			atomic_sub(n, &mmap_pages_allocated);
+			atomic_long_sub(n, &mmap_pages_allocated);
 			total -= n;
 			set_page_refcounted(pages + total);
 			__free_pages(pages + total, order);
@@ -1518,10 +1511,15 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 	/* find the first potentially overlapping VMA */
 	vma = find_vma(mm, start);
 	if (!vma) {
-		printk(KERN_WARNING
-		       "munmap of memory not mmapped by process %d (%s):"
-		       " 0x%lx-0x%lx\n",
-		       current->pid, current->comm, start, start + len - 1);
+		static int limit = 0;
+		if (limit < 5) {
+			printk(KERN_WARNING
+			       "munmap of memory not mmapped by process %d"
+			       " (%s): 0x%lx-0x%lx\n",
+			       current->pid, current->comm,
+			       start, start + len - 1);
+			limit++;
+		}
 		return -EINVAL;
 	}
 
