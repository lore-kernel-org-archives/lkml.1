Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbZAHM5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbZAHM5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbZAHM4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:56:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40756 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759888AbZAHM4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:56:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/10] NOMMU: Make mmap allocation page trimming behaviour
	configurable. [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:54:12 +0000
Message-ID: <20090108125412.28454.85076.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

NOMMU mmap allocates a piece of memory for an mmap that's rounded up in size to
the nearest power-of-2 number of pages.  Currently it then discards the excess
pages back to the page allocator, making that memory available for use by other
things.  This can, however, cause greater amount of fragmentation.

To counter this, a sysctl is added in order to fine-tune the trimming
behaviour.  The default behaviour remains to trim pages aggressively, while
this can either be disabled completely or set to a higher page-granular
watermark in order to have finer-grained control.

vm region vm_top bits taken from an earlier patch by David Howells.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Mike Frysinger <vapier.adi@gmail.com>
---

 Documentation/nommu-mmap.txt |   15 ++++++++++
 Documentation/sysctl/vm.txt  |   18 ++++++++++++
 include/linux/mm_types.h     |    1 +
 kernel/sysctl.c              |   14 +++++++++
 mm/nommu.c                   |   65 +++++++++++++++++++++++++++---------------
 5 files changed, 90 insertions(+), 23 deletions(-)


diff --git a/Documentation/nommu-mmap.txt b/Documentation/nommu-mmap.txt
index 02b89dc..b565e82 100644
--- a/Documentation/nommu-mmap.txt
+++ b/Documentation/nommu-mmap.txt
@@ -248,3 +248,18 @@ PROVIDING SHAREABLE BLOCK DEVICE SUPPORT
 Provision of shared mappings on block device files is exactly the same as for
 character devices. If there isn't a real device underneath, then the driver
 should allocate sufficient contiguous memory to honour any supported mapping.
+
+
+=================================
+ADJUSTING PAGE TRIMMING BEHAVIOUR
+=================================
+
+NOMMU mmap automatically rounds up to the nearest power-of-2 number of pages
+when performing an allocation.  This can have adverse effects on memory
+fragmentation, and as such, is left configurable.  The default behaviour is to
+aggressively trim allocations and discard any excess pages back in to the page
+allocator.  In order to retain finer-grained control over fragmentation, this
+behaviour can either be disabled completely, or bumped up to a higher page
+watermark where trimming begins.
+
+Page trimming behaviour is configurable via the sysctl `vm.nr_trim_pages'.
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index cd05994..a341507 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -38,6 +38,7 @@ Currently, these files are in /proc/sys/vm:
 - numa_zonelist_order
 - nr_hugepages
 - nr_overcommit_hugepages
+- nr_trim_pages		(only if CONFIG_MMU=n)
 
 ==============================================================
 
@@ -348,3 +349,20 @@ Change the maximum size of the hugepage pool. The maximum is
 nr_hugepages + nr_overcommit_hugepages.
 
 See Documentation/vm/hugetlbpage.txt
+
+==============================================================
+
+nr_trim_pages
+
+This is available only on NOMMU kernels.
+
+This value adjusts the excess page trimming behaviour of power-of-2 aligned
+NOMMU mmap allocations.
+
+A value of 0 disables trimming of allocations entirely, while a value of 1
+trims excess pages aggressively. Any value >= 1 acts as the watermark where
+trimming of allocations is initiated.
+
+The default value is 1.
+
+See Documentation/nommu-mmap.txt for more information.
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1c1e0d3..92915e8 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -106,6 +106,7 @@ struct vm_region {
 	unsigned long	vm_flags;	/* VMA vm_flags */
 	unsigned long	vm_start;	/* start address of region */
 	unsigned long	vm_end;		/* region initialised to here */
+	unsigned long	vm_top;		/* region allocated to here */
 	unsigned long	vm_pgoff;	/* the offset in vm_file corresponding to vm_start */
 	struct file	*vm_file;	/* the backing file or NULL */
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 92f6e5b..89d7443 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -82,6 +82,9 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
+#ifndef CONFIG_MMU
+extern int sysctl_nr_trim_pages;
+#endif
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
@@ -1102,6 +1105,17 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec
 	},
+#else
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_trim_pages",
+		.data		= &sysctl_nr_trim_pages,
+		.maxlen		= sizeof(sysctl_nr_trim_pages),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
 #endif
 	{
 		.ctl_name	= VM_LAPTOP_MODE,
diff --git a/mm/nommu.c b/mm/nommu.c
index 0d363df..a6e8ccf 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -10,7 +10,7 @@
  *  Copyright (c) 2000-2003 David McCullough <davidm@snapgear.com>
  *  Copyright (c) 2000-2001 D Jeff Dionne <jeff@uClinux.org>
  *  Copyright (c) 2002      Greg Ungerer <gerg@snapgear.com>
- *  Copyright (c) 2007      Paul Mundt <lethal@linux-sh.org>
+ *  Copyright (c) 2007-2008 Paul Mundt <lethal@linux-sh.org>
  */
 
 #include <linux/module.h>
@@ -66,6 +66,7 @@ atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
+int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
 int heap_stack_gap = 0;
 
 atomic_t mmap_pages_allocated;
@@ -455,6 +456,8 @@ static noinline void validate_nommu_regions(void)
 	last = rb_entry(lastp, struct vm_region, vm_rb);
 	if (unlikely(last->vm_end <= last->vm_start))
 		BUG();
+	if (unlikely(last->vm_top < last->vm_end))
+		BUG();
 
 	while ((p = rb_next(lastp))) {
 		region = rb_entry(p, struct vm_region, vm_rb);
@@ -462,7 +465,9 @@ static noinline void validate_nommu_regions(void)
 
 		if (unlikely(region->vm_end <= region->vm_start))
 			BUG();
-		if (unlikely(region->vm_start < last->vm_end))
+		if (unlikely(region->vm_top < region->vm_end))
+			BUG();
+		if (unlikely(region->vm_start < last->vm_top))
 			BUG();
 
 		lastp = p;
@@ -536,7 +541,7 @@ static void free_page_series(unsigned long from, unsigned long to)
 /*
  * release a reference to a region
  * - the caller must hold the region semaphore, which this releases
- * - the region may not have been added to the tree yet, in which case vm_end
+ * - the region may not have been added to the tree yet, in which case vm_top
  *   will equal vm_start
  */
 static void __put_nommu_region(struct vm_region *region)
@@ -547,7 +552,7 @@ static void __put_nommu_region(struct vm_region *region)
 	BUG_ON(!nommu_region_tree.rb_node);
 
 	if (atomic_dec_and_test(&region->vm_usage)) {
-		if (region->vm_end > region->vm_start)
+		if (region->vm_top > region->vm_start)
 			delete_nommu_region(region);
 		up_write(&nommu_region_sem);
 
@@ -558,7 +563,7 @@ static void __put_nommu_region(struct vm_region *region)
 		 * from ramfs/tmpfs mustn't be released here */
 		if (region->vm_flags & VM_MAPPED_COPY) {
 			kdebug("free series");
-			free_page_series(region->vm_start, region->vm_end);
+			free_page_series(region->vm_start, region->vm_top);
 		}
 		kmem_cache_free(vm_region_jar, region);
 	} else {
@@ -999,6 +1004,10 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
 	int ret;
 
 	ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
+	if (ret == 0) {
+		vma->vm_region->vm_top = vma->vm_region->vm_end;
+		return ret;
+	}
 	if (ret != -ENOSYS)
 		return ret;
 
@@ -1027,11 +1036,14 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	 */
 	if (vma->vm_file) {
 		ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
-		if (ret != -ENOSYS) {
+		if (ret == 0) {
 			/* shouldn't return success if we're not sharing */
-			BUG_ON(ret == 0 && !(vma->vm_flags & VM_MAYSHARE));
-			return ret; /* success or a real error */
+			BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
+			vma->vm_region->vm_top = vma->vm_region->vm_end;
+			return ret;
 		}
+		if (ret != -ENOSYS)
+			return ret;
 
 		/* getting an ENOSYS error indicates that direct mmap isn't
 		 * possible (as opposed to tried but failed) so we'll try to
@@ -1051,23 +1063,25 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	if (!pages)
 		goto enomem;
 
-	/* we allocated a power-of-2 sized page set, so we need to trim off the
-	 * excess */
 	total = 1 << order;
 	atomic_add(total, &mmap_pages_allocated);
 
 	point = rlen >> PAGE_SHIFT;
-	while (total > point) {
-		order = ilog2(total - point);
-		n = 1 << order;
-		kdebug("shave %lu/%lu @%lu", n, total - point, total);
-		atomic_sub(n, &mmap_pages_allocated);
-		total -= n;
-		set_page_refcounted(pages + total);
-		__free_pages(pages + total, order);
+
+	/* we allocated a power-of-2 sized page set, so we may want to trim off
+	 * the excess */
+	if (sysctl_nr_trim_pages && total - point >= sysctl_nr_trim_pages) {
+		while (total > point) {
+			order = ilog2(total - point);
+			n = 1 << order;
+			kdebug("shave %lu/%lu @%lu", n, total - point, total);
+			atomic_sub(n, &mmap_pages_allocated);
+			total -= n;
+			set_page_refcounted(pages + total);
+			__free_pages(pages + total, order);
+		}
 	}
 
-	total = rlen >> PAGE_SHIFT;
 	for (point = 1; point < total; point++)
 		set_page_refcounted(&pages[point]);
 
@@ -1075,6 +1089,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
 	region->vm_start = (unsigned long) base;
 	region->vm_end   = region->vm_start + rlen;
+	region->vm_top   = region->vm_start + (total << PAGE_SHIFT);
 
 	vma->vm_start = region->vm_start;
 	vma->vm_end   = region->vm_start + len;
@@ -1110,6 +1125,7 @@ error_free:
 	free_page_series(region->vm_start, region->vm_end);
 	region->vm_start = vma->vm_start = 0;
 	region->vm_end   = vma->vm_end = 0;
+	region->vm_top   = 0;
 	return ret;
 
 enomem:
@@ -1401,7 +1417,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	npages = (addr - vma->vm_start) >> PAGE_SHIFT;
 
 	if (new_below) {
-		region->vm_end = new->vm_end = addr;
+		region->vm_top = region->vm_end = new->vm_end = addr;
 	} else {
 		region->vm_start = new->vm_start = addr;
 		region->vm_pgoff = new->vm_pgoff += npages;
@@ -1418,6 +1434,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 		vma->vm_region->vm_pgoff = vma->vm_pgoff += npages;
 	} else {
 		vma->vm_region->vm_end = vma->vm_end = addr;
+		vma->vm_region->vm_top = addr;
 	}
 	add_nommu_region(vma->vm_region);
 	add_nommu_region(new->vm_region);
@@ -1454,10 +1471,12 @@ static int shrink_vma(struct mm_struct *mm,
 
 	down_write(&nommu_region_sem);
 	delete_nommu_region(region);
-	if (from > region->vm_start)
-		region->vm_end = from;
-	else
+	if (from > region->vm_start) {
+		to = region->vm_top;
+		region->vm_top = region->vm_end = from;
+	} else {
 		region->vm_start = to;
+	}
 	add_nommu_region(region);
 	up_write(&nommu_region_sem);
 

