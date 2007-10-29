Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXJ2Sjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXJ2Sjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbXJ2Sje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:39:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbXJ2Sjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:39:33 -0400
Date: Mon, 29 Oct 2007 11:37:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [stable] 2.6.23 boot failures on x86-64.
In-Reply-To: <20071029180739.GA17595@kroah.com>
Message-ID: <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
References: <20071029175014.GH7793@redhat.com>
 <20071029180739.GA17595@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Oct 2007, Greg KH wrote:
> 
> I'll be glad to revert it in -stable, if it's also reverted in Linus's
> tree first :)

We've had some changes since 2.6.23, and afaik, the 
"alloc_bootmem_high_node()" code is alreadt effectively dead there. It's 
only called if CONFIG_SPARSEMEM_VMEMMAP is *not* enabled, and I *think* we 
enable it by force on x86-64 these days.

More people added to Cc, just to clarify whether I'm just confused.

Andy, Christoph, Mel: commit 2e1c49db4c640b35df13889b86b9d62215ade4b6 aka 
"x86_64: allocate sparsemem memmap above 4G" is the one that causes the 
failures, just fyi.

Martin - it would be great if you could try out your failing machine with 
2.6.24-rc1 (or a nightly snapshot or current git.. the more recent the 
better).

But if I'm right, that commit should be reverted from 2.6.24 just because 
it's pointless (even if the bug itself is gone). And if I'm wrong, it 
should be reverted. So something like the appended would make sense 
regardless.

Can I get a "tested-by"? And/or ack/nack's on my half-arsed theory above?

		Linus
--
From: Linus Torvalds <torvalds@woody.linux-foundation.org>

Revert "x86_64: allocate sparsemem memmap above 4G"

This reverts commit 2e1c49db4c640b35df13889b86b9d62215ade4b6, since
testing in Fedora has shown it to cause boot failures, as per Dave
Jones. Bisected down by Martin Ebourne.

Cc: Dave Jones <davej@redhat.com>
Cc: Martin Ebourne <fedora@ebourne.me.uk>
Cc: Zou Nan hai <nanhai.zou@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1e3862e..a7308b2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -728,12 +728,6 @@ int in_gate_area_no_task(unsigned long addr)
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
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index c83534e..0365ec9 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -59,7 +59,6 @@ extern void *__alloc_bootmem_core(struct bootmem_data *bdata,
 				  unsigned long align,
 				  unsigned long goal,
 				  unsigned long limit);
-extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
diff --git a/mm/sparse.c b/mm/sparse.c
index 08fb14f..e06f514 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -220,12 +220,6 @@ static int __meminit sparse_init_one_section(struct mem_section *ms,
 	return 1;
 }
 
-__attribute__((weak)) __init
-void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
-{
-	return NULL;
-}
-
 static unsigned long usemap_size(void)
 {
 	unsigned long size_bytes;
@@ -267,11 +261,6 @@ struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
 	if (map)
 		return map;
 
-  	map = alloc_bootmem_high_node(NODE_DATA(nid),
-                       sizeof(struct page) * PAGES_PER_SECTION);
-	if (map)
-		return map;
-
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
 	return map;
