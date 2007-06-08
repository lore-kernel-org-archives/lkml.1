Return-Path: <linux-kernel-owner+w=401wt.eu-S939336AbXFHHub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939336AbXFHHub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967001AbXFHHZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:00 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55311 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938401AbXFHHYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:55 -0400
Message-Id: <20070608072209.461194000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 25/54] x86_64: allocate sparsemem memmap above 4G
Content-Disposition: inline; filename=x86_64-allocate-sparsemem-memmap-above-4g.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Zou Nan hai <nanhai.zou@intel.com>

On systems with huge amount of physical memory, VFS cache and memory memmap
may eat all available system memory under 4G, then the system may fail to
allocate swiotlb bounce buffer.

There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix dose
not cover sparsemem model.

This patch add fix to sparsemem model by first try to allocate memmap above
4G.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[chrisw: trivial backport]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86_64/mm/init.c   |    6 ++++++
 include/linux/bootmem.h |    1 +
 mm/sparse.c             |   11 +++++++++++
 3 files changed, 18 insertions(+)

--- linux-2.6.21.4.orig/arch/x86_64/mm/init.c
+++ linux-2.6.21.4/arch/x86_64/mm/init.c
@@ -776,3 +776,9 @@ int in_gate_area_no_task(unsigned long a
 {
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
+
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return __alloc_bootmem_core(pgdat->bdata, size,
+			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+}
--- linux-2.6.21.4.orig/include/linux/bootmem.h
+++ linux-2.6.21.4/include/linux/bootmem.h
@@ -59,6 +59,7 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long align,
 				  unsigned long goal,
 				  unsigned long limit);
+extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
--- linux-2.6.21.4.orig/mm/sparse.c
+++ linux-2.6.21.4/mm/sparse.c
@@ -209,6 +209,12 @@ static int sparse_init_one_section(struc
 	return 1;
 }
 
+__attribute__((weak))
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return NULL;
+}
+
 static struct page *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -219,6 +225,11 @@ static struct page *sparse_early_mem_map
 	if (map)
 		return map;
 
+  	map = alloc_bootmem_high_node(NODE_DATA(nid),
+                       sizeof(struct page) * PAGES_PER_SECTION);
+	if (map)
+		return map;
+
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)

-- 
