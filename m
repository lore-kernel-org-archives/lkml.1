Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXKOGXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXKOGXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXKOGRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:17:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51170 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbXKOGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:17:00 -0500
Date: Wed, 14 Nov 2007 22:15:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [patch 19/19] revert "x86_64: allocate sparsemem memmap above 4G"
Message-ID: <20071115061528.GT7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-x86_64-allocate-sparsemem-memmap-above-4g.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

Reverted upstream by commit 6a22c57b8d2a62dea7280a6b2ac807a539ef0716

Revert this commit:

	commit 2e1c49db4c640b35df13889b86b9d62215ade4b6
	Author: Zou Nan hai <nanhai.zou@intel.com>
	Date:   Fri Jun 1 00:46:28 2007 -0700
	
	x86_64: allocate sparsemem memmap above 4G

This reverts commit 2e1c49db4c640b35df13889b86b9d62215ade4b6.

First off, testing in Fedora has shown it to cause boot failures,
bisected down by Martin Ebourne, and reported by Dave Jobes.  So the
commit will likely be reverted in the 2.6.23 stable kernels.

Secondly, in the 2.6.24 model, x86-64 has now grown support for
SPARSEMEM_VMEMMAP, which disables the relevant code anyway, so while the
bug is not visible any more, it's become invisible due to the code just
being irrelevant and no longer enabled on the only architecture that
this ever affected.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Martin Ebourne <fedora@ebourne.me.uk>
Cc: Zou Nan hai <nanhai.zou@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/mm/init.c   |    6 ------
 include/linux/bootmem.h |    1 -
 mm/sparse.c             |   11 -----------
 3 files changed, 18 deletions(-)

--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -734,12 +734,6 @@ int in_gate_area_no_task(unsigned long a
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
 
-void * __init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
-{
-	return __alloc_bootmem_core(pgdat->bdata, size,
-			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
-}
-
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
 	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -59,7 +59,6 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long align,
 				  unsigned long goal,
 				  unsigned long limit);
-extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -215,12 +215,6 @@ static int __meminit sparse_init_one_sec
 	return 1;
 }
 
-__attribute__((weak)) __init
-void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
-{
-	return NULL;
-}
-
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -231,11 +225,6 @@ static struct page __init *sparse_early_
 	if (map)
 		return map;
 
-  	map = alloc_bootmem_high_node(NODE_DATA(nid),
-                       sizeof(struct page) * PAGES_PER_SECTION);
-	if (map)
-		return map;
-
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)

-- 
