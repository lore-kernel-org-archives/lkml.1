Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXGXVOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXGXVOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXGXVOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:14:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21006 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXGXVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:14:06 -0400
Date: Tue, 24 Jul 2007 14:17:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: ak@suse.de, jdmason@us.ibm.com, muli@il.ibm.com
Subject: [PATCH] x86_64 tce section mismatch
Message-Id: <20070724141702.a9f63ae4.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warnings:
these functions are called only from __init functions.

WARNING: vmlinux.o(.text+0x1861c): Section mismatch: reference to .init.text:free_bootmem (between 'free_tce_table' and 'build_tce_table')
WARNING: vmlinux.o(.text+0x187e5): Section mismatch: reference to .init.text:__alloc_bootmem_low (between 'alloc_tce_table' and 'kretprobe_trampoline_holder')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86_64/kernel/tce.c |    6 +++---
 include/asm-x86_64/tce.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/tce.c
+++ linux-2.6.23-rc1/arch/x86_64/kernel/tce.c
@@ -131,7 +131,7 @@ done:
 	return ret;
 }
 
-int build_tce_table(struct pci_dev *dev, void __iomem *bbar)
+int __init build_tce_table(struct pci_dev *dev, void __iomem *bbar)
 {
 	struct iommu_table *tbl;
 	int ret;
@@ -165,7 +165,7 @@ done:
 	return ret;
 }
 
-void* alloc_tce_table(void)
+void* __init alloc_tce_table(void)
 {
 	unsigned int size;
 
@@ -175,7 +175,7 @@ void* alloc_tce_table(void)
 	return __alloc_bootmem_low(size, size, 0);
 }
 
-void free_tce_table(void *tbl)
+void __init free_tce_table(void *tbl)
 {
 	unsigned int size;
 
--- linux-2.6.23-rc1.orig/include/asm-x86_64/tce.h
+++ linux-2.6.23-rc1/include/asm-x86_64/tce.h
@@ -41,8 +41,8 @@ struct iommu_table;
 extern void tce_build(struct iommu_table *tbl, unsigned long index,
         unsigned int npages, unsigned long uaddr, int direction);
 extern void tce_free(struct iommu_table *tbl, long index, unsigned int npages);
-extern void* alloc_tce_table(void);
-extern void free_tce_table(void *tbl);
-extern int build_tce_table(struct pci_dev *dev, void __iomem *bbar);
+extern void* __init alloc_tce_table(void);
+extern void __init free_tce_table(void *tbl);
+extern int __init build_tce_table(struct pci_dev *dev, void __iomem *bbar);
 
 #endif /* _ASM_X86_64_TCE_H */
