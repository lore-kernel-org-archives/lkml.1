Return-Path: <linux-kernel-owner+w=401wt.eu-S932916AbXGZJG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbXGZJG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbXGZJGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:06:22 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:11059 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbXGZJGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:06:21 -0400
Date: Thu, 26 Jul 2007 12:06:11 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: Calgary - fix section mismatch warnings in tce
Message-ID: <20070726090611.GL4104@rhun.haifa.ibm.com>
References: <20070726062330.GA1322@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726062330.GA1322@uranus.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 08:23:30AM +0200, Sam Ravnborg wrote:
> Fix the following two section mismatch warnings:
> 
> WARNING: vmlinux.o(.text+0x1ce84): Section mismatch: reference to .init.text:free_bootmem (between 'free_tce_table' and 'build_tce_table')
> WARNING: vmlinux.o(.text+0x1d04d): Section mismatch: reference to .init.text:__alloc_bootmem_low (between 'alloc_tce_table' and 'kretprobe_trampoline_holder')
> 
> In both cases the functions was used only from __init
> context so mark them __init.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

There was a more complete patch by Randy Dunlap posted a couple of
days ago that I queued for the next Calgary update. However, since
people are tripping over this and are bothered enough to send patches,
Andi or Andrew, could you please expedite the attached patch upstream?

====

From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: x86-64: Calgary - fix section mismatch warnings in tce

Fix section mismatch warnings:
these functions are called only from __init functions.

WARNING: vmlinux.o(.text+0x1861c): Section mismatch: reference to .init.text:free_bootmem (between 'free_tce_table' and 'build_tce_table')
WARNING: vmlinux.o(.text+0x187e5): Section mismatch: reference to .init.text:__alloc_bootmem_low (between 'alloc_tce_table' and 'kretprobe_trampoline_holder')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
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
