Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbXGXVj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbXGXVj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760041AbXGXVjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:39:48 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:38979 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754092AbXGXVjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:39:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ip6YtSMvbUz5wh2bZlURMrKGIbddjRMLGrvakffXLALqqhukT151JfBfEeC7D89DXMRARQfsRNwzo36QqG/UoDZopty7Jl6mziF0WUMODBgA4M/mxKIw+ObnBneoIA4UuFhOV06shOZnXwZNUQfPl6We5gy+akQU12liFba1/n0=  ;
X-YMail-OSG: 6a3wtTIVM1lq7CRZ0mUXoiVgSt5qhPGwSZhcs_05a3PWjBt9.4spr66USWAylat1lwOT8ookDw--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.23-rc1] dma_free_coherent() needs irqs enabled (sigh)
Date: Tue, 24 Jul 2007 14:29:05 -0700
User-Agent: KMail/1.9.6
Cc: Russell King <rmk@arm.linux.org.uk>, David Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241429.05615.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
call context requirement:  unlike its dma_alloc_coherent() sibling, it
may not be called with IRQs disabled.  (This was new behavior on ARM as
of late 2006, caused by ARM SMP updates.)  This little surprise can be
annoyingly driver-visible.

Since it looks like that restriction won't be removed, this patch changes
the definition of the API to include that requirement.  Also, to help
catch nonportable drivers, it updates the x86 and swiotlb versions to
include the relevant warnings.  (I already observed that it trips on the
bus_reset_tasklet of the new firewire_ohci driver.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Miller <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 Documentation/DMA-API.txt    |    3 +++
 arch/i386/kernel/pci-dma.c   |    3 ++-
 arch/x86_64/kernel/pci-dma.c |    1 +
 lib/swiotlb.c                |    1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

--- g26.orig/Documentation/DMA-API.txt	2007-07-22 05:06:57.000000000 -0700
+++ g26/Documentation/DMA-API.txt	2007-07-22 14:48:45.000000000 -0700
@@ -68,6 +68,9 @@ size and dma_handle must all be the same
 consistent allocate.  cpu_addr must be the virtual address returned by
 the consistent allocate
 
+Note that unlike their sibling allocation calls, these routines
+may only be called with IRQs enabled.
+
 
 Part Ib - Using small dma-coherent buffers
 ------------------------------------------
--- g26.orig/arch/x86_64/kernel/pci-dma.c	2007-07-22 05:13:10.000000000 -0700
+++ g26/arch/x86_64/kernel/pci-dma.c	2007-07-22 14:48:45.000000000 -0700
@@ -163,6 +163,7 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t bus)
 {
+	WARN_ON(irqs_disabled());	/* for portability */
 	if (dma_ops->unmap_single)
 		dma_ops->unmap_single(dev, bus, size, 0);
 	free_pages((unsigned long)vaddr, get_order(size));
--- g26.orig/arch/i386/kernel/pci-dma.c	2007-07-22 05:06:57.000000000 -0700
+++ g26/arch/i386/kernel/pci-dma.c	2007-07-22 14:48:46.000000000 -0700
@@ -63,7 +63,8 @@ void dma_free_coherent(struct device *de
 {
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
-	
+
+	WARN_ON(irqs_disabled());	/* for portability */
 	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
 		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
 
--- g26.orig/lib/swiotlb.c	2007-07-22 05:13:15.000000000 -0700
+++ g26/lib/swiotlb.c	2007-07-22 14:48:46.000000000 -0700
@@ -497,6 +497,7 @@ void
 swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		      dma_addr_t dma_handle)
 {
+	WARN_ON(irqs_disabled());
 	if (!(vaddr >= (void *)io_tlb_start
                     && vaddr < (void *)io_tlb_end))
 		free_pages((unsigned long) vaddr, get_order(size));
