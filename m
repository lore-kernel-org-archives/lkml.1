Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbXDDXGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbXDDXGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXDDXGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:06:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47604 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752662AbXDDXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:06:31 -0400
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>, Dave Hansen <hansendc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <ak@suse.de>
Message-Id: <20070404230629.20292.89714.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070404230619.20292.4475.sendpatchset@schroedinger.engr.sgi.com>
References: <20070404230619.20292.4475.sendpatchset@schroedinger.engr.sgi.com>
Subject: [PATCH 3/4] IA64: SPARSE_VIRTUAL 16K page size support
Date: Wed,  4 Apr 2007 16:06:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[IA64] Sparse virtual implementation

Equip IA64 sparsemem with a virtual memmap. This is similar to the existing
CONFIG_VMEMMAP functionality for discontig. It uses a page size mapping.

This is provided as a minimally intrusive solution. We split the
128TB VMALLOC area into two 64TB areas and use one for the virtual memmap.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm2/arch/ia64/Kconfig
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/ia64/Kconfig	2007-04-02 16:15:29.000000000 -0700
+++ linux-2.6.21-rc5-mm2/arch/ia64/Kconfig	2007-04-02 16:15:50.000000000 -0700
@@ -350,6 +350,10 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
+config SPARSE_VIRTUAL
+	def_bool y
+	depends on ARCH_SPARSEMEM_ENABLE
+
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y if (IA64_SGI_SN2 || IA64_GENERIC || IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB)
 	depends on ARCH_DISCONTIGMEM_ENABLE
Index: linux-2.6.21-rc5-mm2/include/asm-ia64/page.h
===================================================================
--- linux-2.6.21-rc5-mm2.orig/include/asm-ia64/page.h	2007-04-02 16:15:29.000000000 -0700
+++ linux-2.6.21-rc5-mm2/include/asm-ia64/page.h	2007-04-02 16:15:50.000000000 -0700
@@ -106,6 +106,9 @@ extern int ia64_pfn_valid (unsigned long
 # define ia64_pfn_valid(pfn) 1
 #endif
 
+#define vmemmap ((struct page *)(RGN_BASE(RGN_GATE) + \
+				(1UL << (4*PAGE_SHIFT - 10))))
+
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 extern struct page *vmem_map;
 #ifdef CONFIG_DISCONTIGMEM
Index: linux-2.6.21-rc5-mm2/include/asm-ia64/pgtable.h
===================================================================
--- linux-2.6.21-rc5-mm2.orig/include/asm-ia64/pgtable.h	2007-04-02 16:15:29.000000000 -0700
+++ linux-2.6.21-rc5-mm2/include/asm-ia64/pgtable.h	2007-04-02 16:15:50.000000000 -0700
@@ -236,8 +236,13 @@ ia64_phys_addr_valid (unsigned long addr
 # define VMALLOC_END		vmalloc_end
   extern unsigned long vmalloc_end;
 #else
+#if defined(CONFIG_SPARSEMEM) && defined(CONFIG_SPARSE_VIRTUAL)
+/* SPARSE_VIRTUAL uses half of vmalloc... */
+# define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 10)))
+#else
 # define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
 #endif
+#endif
 
 /* fs/proc/kcore.c */
 #define	kc_vaddr_to_offset(v) ((v) - RGN_BASE(RGN_GATE))
