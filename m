Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbXKMWUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbXKMWUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXKMWUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:20:04 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46924 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753803AbXKMWUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:20:02 -0500
Date: Tue, 13 Nov 2007 14:20:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.031510.151440585.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com> <20071106195157.878563669@sgi.com>
 <20071113.031510.151440585.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, David Miller wrote:

> Yes, I could add virtualized area support to sparc64, but we cannot
> impose this on every platform.

Other platforms do not have the 8MB restriction nor do they have so many 
processors.

Here is the draft of a virtual cpu area implementation for sparc64. Uses 
the VMEMMAP chunks:

---
 arch/sparc64/Kconfig          |   12 ++++++++++++
 arch/sparc64/mm/init.c        |   34 ++++++++++++++++++++++++++++++++++
 include/asm-sparc64/pgtable.h |    1 +
 3 files changed, 47 insertions(+)

Index: linux-2.6/arch/sparc64/mm/init.c
===================================================================
--- linux-2.6.orig/arch/sparc64/mm/init.c	2007-11-13 14:09:44.619500290 -0800
+++ linux-2.6/arch/sparc64/mm/init.c	2007-11-13 14:17:49.794860210 -0800
@@ -1697,6 +1697,40 @@ int __meminit vmemmap_populate(struct pa
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
+int cpu_area_populate(void *start, unsigned long size, gfp_t flags, int node)
+{
+	unsigned long vstart = (unsigned long) start;
+	unsigned long vend = (unsigned long) (start + size);
+	unsigned long phys_start = (vstart - CPU_AREA_BASE);
+	unsigned long phys_end = (vend - CPU_AREA_BASE);
+	unsigned long addr = phys_start & VMEMMAP_CHUNK_MASK;
+	unsigned long end = VMEMMAP_ALIGN(phys_end);
+	unsigned long pte_base;
+
+	pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4U |
+		    _PAGE_CP_4U | _PAGE_CV_4U |
+		    _PAGE_P_4U | _PAGE_W_4U);
+	if (tlb_type == hypervisor)
+		pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
+			    _PAGE_CP_4V | _PAGE_CV_4V |
+			    _PAGE_P_4V | _PAGE_W_4V);
+
+	for (; addr < end; addr += VMEMMAP_CHUNK) {
+		unsigned long *vmem_pp =
+			vmemmap_table + (addr >> VMEMMAP_CHUNK_SHIFT);
+		void *block;
+
+		if (!(*vmem_pp & _PAGE_VALID)) {
+			block = vmemmap_alloc_block(1UL << 22, flags, node);
+			if (!block)
+				return -ENOMEM;
+
+			*vmem_pp = pte_base | __pa(block);
+		}
+	}
+	return 0;
+}
+
 static void prot_init_common(unsigned long page_none,
 			     unsigned long page_shared,
 			     unsigned long page_copy,
Index: linux-2.6/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc64/Kconfig	2007-11-13 14:12:28.895750307 -0800
+++ linux-2.6/arch/sparc64/Kconfig	2007-11-13 14:18:32.110750142 -0800
@@ -76,6 +76,18 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y
 
+config CPU_AREA_VIRTUAL
+	bool
+	def_bool y
+
+config CPU_AREA_ORDER
+	int
+	default "10"
+
+config CPU_AREA_ALLOC_ORDER
+	int
+	default "0"
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
Index: linux-2.6/include/asm-sparc64/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/pgtable.h	2007-11-13 14:11:51.871000018 -0800
+++ linux-2.6/include/asm-sparc64/pgtable.h	2007-11-13 14:12:21.011750241 -0800
@@ -43,6 +43,7 @@
 #define VMALLOC_START		_AC(0x0000000100000000,UL)
 #define VMALLOC_END		_AC(0x0000000200000000,UL)
 #define VMEMMAP_BASE		_AC(0x0000000200000000,UL)
+#define CPU_AREA_BASE		_AC(0x0000000300000000,UL)
 
 #define vmemmap			((struct page *)VMEMMAP_BASE)
 
