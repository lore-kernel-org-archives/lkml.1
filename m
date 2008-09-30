Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYI3TfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYI3TfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYI3TfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:35:05 -0400
Received: from relais.videotron.ca ([24.201.245.36]:44132 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYI3TfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:35:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 30 Sep 2008 15:35:01 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: lkml <linux-kernel@vger.kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: wrong usage of MAX_DMA_ADDRESS in bootmem.h
In-reply-to: <20080930184411.GJ15911@flint.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.0809301513260.3635@xanadu.home>
References: <1222230419-15661-21-git-send-email-nico@cam.org>
 <1222230592-15868-1-git-send-email-nico@cam.org>
 <20080930162809.GD15911@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0809301409230.3635@xanadu.home>
 <20080930184411.GJ15911@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have implemented highmem for ARM.  To catch wrong usage of __pa() and 
__va() with out of range values, I added a range check when 
CONFIG_DEBUG_HIGHMEM is set.

One issue is that bootmem.h uses __pa(MAX_DMA_ADDRESS). However 
MAX_DMA_ADDRESS on ARM is defined as 0xffffffff because there is usually 
no restriction on the maximum DMA-able address.

RMK suggested that those places should be using ISA_DMA_THRESHOLD 
instead -- here's an excert of our conversation on this topic:

> I suspect all those places which are doing __pa(MAX_DMA_ADDRESS) really
> want to be using ISA_DMA_THRESHOLD - that's something to raise on LKML
> if it's causing problems.
> 
> > > Given the definition I've just given, if there's no restrictions on
> > > what can be DMA'd from, defining 'MAX_DMA_ADDRESS' to a constant well
> > > in excess of the maximum amount of RAM is quite reasonable.  Since most
> > > ARM platforms don't have any restrictions on memory that can be DMA'd,
> > > the existing code is perfectly reasonable and correct.
> > 
> > It falls apart when the range check on values passed to __pa() is 
> > enabled in a highmem context.
> 
> As I say, having it in excess of the real amount of RAM fitted is not a
> problem.  Unfortunately, it makes the range check fall apart but I suspect
> that's because of inappropriate use.

So what about this patch?

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 95837bf..7a97ffe 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -96,21 +96,21 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 				      unsigned long goal);
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 #define alloc_bootmem(x) \
-	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, SMP_CACHE_BYTES, ISA_DMA_THRESHOLD)
 #define alloc_bootmem_nopanic(x) \
-	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, ISA_DMA_THRESHOLD)
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
 #define alloc_bootmem_pages(x) \
-	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, PAGE_SIZE, ISA_DMA_THRESHOLD)
 #define alloc_bootmem_pages_nopanic(x) \
-	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, PAGE_SIZE, ISA_DMA_THRESHOLD)
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, ISA_DMA_THRESHOLD)
 #define alloc_bootmem_pages_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, ISA_DMA_THRESHOLD)
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
