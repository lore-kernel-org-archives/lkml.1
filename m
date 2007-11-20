Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbXKTBQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbXKTBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXKTBNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49839 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753383AbXKTBNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:34 -0500
Message-Id: <20071120011334.092511935@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:42 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 10/45] cpu_alloc: Sparc64 support
Content-Disposition: inline; filename=cpu_alloc_sparc64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable a simple virtual configuration with 32MB available per cpu so that
we do not use a static area on sparc64.

[Not tested. I have no sparc64]

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/sparc64/Kconfig              |   15 +++++++++++++++
 arch/sparc64/kernel/vmlinux.lds.S |    3 +++
 include/asm-sparc64/pgtable.h     |    1 +
 3 files changed, 19 insertions(+)

Index: linux-2.6/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc64/Kconfig	2007-11-18 14:38:24.601033354 -0800
+++ linux-2.6/arch/sparc64/Kconfig	2007-11-18 21:14:11.476343425 -0800
@@ -103,6 +103,21 @@ config SPARC64_PAGE_SIZE_4MB
 
 endchoice
 
+config CPU_AREA_VIRTUAL
+	bool
+	default y
+
+config CPU_AREA_ORDER
+	int
+	default "11" if SPARC64_PAGE_SIZE_8KB
+	default "9" if SPARC64_PAGE_SIZE_64KB
+	default "6" if SPARC64_PAGE_SIZE_512KB
+	default "3" if SPARC64_PAGE_SIZE_4MB
+
+config CPU_AREA_ALLOC_ORDER
+	int
+	default "0"
+
 config SECCOMP
 	bool "Enable seccomp to safely compute untrusted bytecode"
 	depends on PROC_FS
Index: linux-2.6/include/asm-sparc64/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/pgtable.h	2007-11-18 14:38:24.609034022 -0800
+++ linux-2.6/include/asm-sparc64/pgtable.h	2007-11-18 21:14:11.504343895 -0800
@@ -43,6 +43,7 @@
 #define VMALLOC_START		_AC(0x0000000100000000,UL)
 #define VMALLOC_END		_AC(0x0000000200000000,UL)
 #define VMEMMAP_BASE		_AC(0x0000000200000000,UL)
+#define CPU_AREA_BASE		_AC(0x0000000300000000,UL)
 
 #define vmemmap			((struct page *)VMEMMAP_BASE)
 
Index: linux-2.6/arch/sparc64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/vmlinux.lds.S	2007-11-18 21:14:31.068844088 -0800
+++ linux-2.6/arch/sparc64/kernel/vmlinux.lds.S	2007-11-18 21:14:50.469421513 -0800
@@ -2,12 +2,15 @@
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/pgtable.h>
 
 OUTPUT_FORMAT("elf64-sparc", "elf64-sparc", "elf64-sparc")
 OUTPUT_ARCH(sparc:v9a)
 ENTRY(_start)
 
 jiffies = jiffies_64;
+cpu_area = CPU_AREA_BASE
+
 SECTIONS
 {
 	swapper_low_pmd_dir = 0x0000000000402000;

-- 
