Return-Path: <linux-kernel-owner+w=401wt.eu-S935392AbXKPXOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935392AbXKPXOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934508AbXKPXLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:24 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39559 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761310AbXKPXLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:04 -0500
Message-Id: <20071116231103.808561432@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:27 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 07/30] cpu alloc: IA64 support
Content-Disposition: inline; filename=cpu_alloc_ia64_support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Typical use of per cpu memory for a small system of 8G 8p 4node is less than
64k per cpu memory. This is increasing rapidly for larger systems where we can
get up to 512k or 1M of memory used for cpu storage.

The maximum size allowed of the cpu area is 128MB of memory.

The cpu area is placed in region 5 with the kernel, vmemmap and vmalloc areas.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/ia64/Kconfig          |   13 +++++++++++++
 include/asm-ia64/pgtable.h |   32 ++++++++++++++++++++++++++------
 2 files changed, 39 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig	2007-11-15 21:24:46.991154957 -0800
+++ linux-2.6/arch/ia64/Kconfig	2007-11-16 14:43:17.277214329 -0800
@@ -99,6 +99,19 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config CPU_AREA_VIRTUAL
+	bool
+	default y
+
+# Maximum of 128 MB cpu_alloc space per cpu
+config CPU_AREA_ORDER
+	int
+	default "13"
+
+config CPU_AREA_ALLOC_ORDER
+	int
+	default "0"
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
Index: linux-2.6/include/asm-ia64/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/pgtable.h	2007-11-15 21:24:47.003154534 -0800
+++ linux-2.6/include/asm-ia64/pgtable.h	2007-11-16 14:42:57.629964336 -0800
@@ -224,21 +224,41 @@ ia64_phys_addr_valid (unsigned long addr
  */
 
 
+/*
+ * Layout of RGN_GATE
+ *
+ * 47 bits wide (16kb pages)
+ *
+ * 0xa000000000000000-0xa00000200000000	8G	Kernel data area
+ * 0xa000002000000000-0xa00040000000000	64T	vmalloc
+ * 0xa000400000000000-0xa00060000000000 32T	vmemmmap
+ * 0xa000600000000000-0xa00080000000000	32T	cpu area
+ *
+ * 55 bits wide (64kb pages)
+ *
+ * 0xa000000000000000-0xa00000200000000	8G	Kernel data area
+ * 0xa000002000000000-0xa04000000000000	16P	vmalloc
+ * 0xa040000000000000-0xa06000000000000 8P	vmemmmap
+ * 0xa060000000000000-0xa08000000000000	8P	cpu area
+ */
+
 #define VMALLOC_START		(RGN_BASE(RGN_GATE) + 0x200000000UL)
+#define VMALLOC_END_INIT	(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 10)))
+
 #ifdef CONFIG_VIRTUAL_MEM_MAP
-# define VMALLOC_END_INIT	(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
 # define VMALLOC_END		vmalloc_end
   extern unsigned long vmalloc_end;
 #else
+# define VMALLOC_END VMALLOC_END_INIT
+#endif
+
 #if defined(CONFIG_SPARSEMEM) && defined(CONFIG_SPARSEMEM_VMEMMAP)
 /* SPARSEMEM_VMEMMAP uses half of vmalloc... */
-# define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 10)))
-# define vmemmap		((struct page *)VMALLOC_END)
-#else
-# define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
-#endif
+# define vmemmap		((struct page *)VMALLOC_END_INIT)
 #endif
 
+#define CPU_AREA_BASE		(RGN_BASE(RGN_GATE) + (3UL << (4*PAGE_SHIFT - 11)))
+
 /* fs/proc/kcore.c */
 #define	kc_vaddr_to_offset(v) ((v) - RGN_BASE(RGN_GATE))
 #define	kc_offset_to_vaddr(o) ((o) + RGN_BASE(RGN_GATE))

-- 
