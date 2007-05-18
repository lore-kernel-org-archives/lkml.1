Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbXERCwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbXERCwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXERCwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:52:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:12432 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbXERCwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:52:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,551,1170662400"; 
   d="scan'208";a="244494740"
Subject: Re: [Patch] Allocate sparsemem memmap above 4G on X86_64
From: Zou Nan hai <nanhai.zou@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ak@suse.de, suresh.b.siddha@intel.com
In-Reply-To: <20070517123216.184104a8.akpm@linux-foundation.org>
References: <1179369607.4103.158.camel@linux-znh>
	 <20070517123216.184104a8.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: 
Message-Id: <1179456777.2633.8.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 18 May 2007 10:52:57 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 03:32, Andrew Morton wrote:
> On 17 May 2007 10:40:07 +0800
> Zou Nan hai <nanhai.zou@intel.com> wrote:
> 
> > 
> Please always prefer to use static inline functions rather than macros. 
> They are more readable, they are more likely to have comments attached to
> them and they provide typechecking.
> 
> Please prefer to uninline functions by default.  One reason for this is
> that adding inlines to headers increases include complexity.  This code is
> all __init anyway, so the possible few bytes of text will get removed.
> 
> 
> Try to avoid using the ARCH_HAS_FOO thing.  We have two alternatives:
> 
> a) use __attribute__((weak))
> 
> b) do:
> 
> 	extern void foo(void);
> 	#define foo foo
> 
>    then, elsewhere,
> 
> 	#ifndef foo
> 	#define foo() bar()
> 	#endif
> 
> Both tricks avoid the introduction of two new symbols into the global
> namespace to solve a single problem.
  On systems with huge amount of physical memory, VFS cache and memory
memmap may eat all available system memory under 4G, then the system may
fail to allocate swiotlb bounce buffer.
  There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix
dose not cover sparsemem model.
  This patch add fix to sparsemem model by first try to allocate memmap
above 4G.

Signed-off-by:	Zou Nan hai <nanhai.zou@intel.com>
Acked-by:	Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86_64/mm/init.c |    6 ++++++
 mm/sparse.c           |   11 +++++++++++
 2 files changed, 17 insertions(+)

diff -Nraup a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c	2007-05-19 16:54:46.000000000 +0800
+++ b/arch/x86_64/mm/init.c	2007-05-19 17:43:47.000000000 +0800
@@ -761,3 +761,9 @@ int in_gate_area_no_task(unsigned long a
 {
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
+
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return __alloc_bootmem_core(pgdat->bdata, size,
+			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+}
diff -Nraup a/mm/sparse.c b/mm/sparse.c
--- a/mm/sparse.c	2007-05-19 16:54:48.000000000 +0800
+++ b/mm/sparse.c	2007-05-19 17:44:01.000000000 +0800
@@ -209,6 +209,12 @@ static int __meminit sparse_init_one_sec
 	return 1;
 }
 
+__attribute__((weak))
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return NULL;
+}
+
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -219,6 +225,11 @@ static struct page __init *sparse_early_
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
