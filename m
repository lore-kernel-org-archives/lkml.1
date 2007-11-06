Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbXKFTwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbXKFTwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXKFTwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:04 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45361 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754321AbXKFTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:00 -0500
Message-Id: <20071106195158.566603927@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:48 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/28] cpu alloc: i386 support
Content-Disposition: inline; filename=cpu_alloc_i386
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Setup a 256 kB area for the cpu areas below the FIXADDR area.

The use of the cpu alloc area is pretty minimal on i386. An 8p system
with no extras uses only ~8kb. So 256kb should be plenty. A configuration
that supports up to 8 processors takes up 2MB of the scarce
virtual address space.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/Kconfig.i386        |   12 ++++++++++++
 arch/x86/mm/init_32.c        |    3 +++
 include/asm-x86/pgtable_32.h |    7 +++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/Kconfig.i386
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.i386	2007-11-06 05:05:19.000000000 +0000
+++ linux-2.6/arch/x86/Kconfig.i386	2007-11-06 05:26:39.000000000 +0000
@@ -95,6 +95,18 @@
 	bool
 	default y
 
+config CPU_AREA_VIRTUAL
+	bool
+	default y
+
+config CPU_AREA_ORDER
+	int
+	default "6"
+
+config CPU_AREA_ALLOC_ORDER
+	int
+	default "0"
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c	2007-11-06 05:01:23.000000000 +0000
+++ linux-2.6/arch/x86/mm/init_32.c	2007-11-06 05:07:33.000000000 +0000
@@ -674,6 +674,7 @@
 #if 1 /* double-sanity-check paranoia */
 	printk("virtual kernel memory layout:\n"
 	       "    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
+	       "    cpu area: 0x%08lx - 0x%08lx   (%4ld kb)\n"
 #ifdef CONFIG_HIGHMEM
 	       "    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 #endif
@@ -684,6 +685,8 @@
 	       "      .text : 0x%08lx - 0x%08lx   (%4ld kB)\n",
 	       FIXADDR_START, FIXADDR_TOP,
 	       (FIXADDR_TOP - FIXADDR_START) >> 10,
+	       CPU_AREA_BASE, FIXADDR_START,
+	       (FIXADDR_START - CPU_AREA_BASE) >> 10,
 
 #ifdef CONFIG_HIGHMEM
 	       PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
Index: linux-2.6/include/asm-x86/pgtable_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable_32.h	2007-11-06 05:01:23.000000000 +0000
+++ linux-2.6/include/asm-x86/pgtable_32.h	2007-11-06 05:07:33.000000000 +0000
@@ -79,11 +79,14 @@
 #define VMALLOC_START	(((unsigned long) high_memory + \
 			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
 #ifdef CONFIG_HIGHMEM
-# define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
+# define CPU_AREA_BASE	(PKMAP_BASE - NR_CPUS * \
+				(1 << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT)))
 #else
-# define VMALLOC_END	(FIXADDR_START-2*PAGE_SIZE)
+# define CPU_AREA_BASE	(FIXADDR_START - NR_CPUS * \
+				(1 << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT)))
 #endif
 
+#define VMALLOC_END	(CPU_AREA_BASE - 2 * PAGE_SIZE)
 /*
  * _PAGE_PSE set in the page directory entry just means that
  * the page directory entry points directly to a 4MB-aligned block of

-- 
