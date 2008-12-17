Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757906AbYLQF0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYLQF0X (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYLQF0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:26:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:45807 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYLQF0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:26:12 -0500
Date: Wed, 17 Dec 2008 14:25:36 +0900
To: mingo@elte.hu
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
        jbeulich@novell.com, fujita.tomonori@lab.ntt.co.jp,
        joerg.roedel@amd.com
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
	of swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081216203513.GA14787@elte.hu>
References: <patchbomb.1229458644@abulafia.goop.org>
	<20081216203513.GA14787@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081217142637V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 21:35:13 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Hi Ingo,
> > 
> > Here's some patches to clean up swiotlb to prepare for some Xen dom0 
> > patches.  These have been posted before, but undergone a round of 
> > cleanups to address various comments.
> 
> applied to tip/core/iommu, thanks Jeremy.
> 
> the only patch that seems to have the potential to break drivers is:
> 
>   be4ac7b: swiotlb: consistently use address_needs_mapping everywhere

Yeah, as I already wrote, this patch is wrong.


I think that the whole patchset is against the swiotlb design. swiotlb
is designed to be used as a library. Each architecture implements the
own swiotlb by using swiotlb library
(e.g. arch/x86/kernel/pci-swiotlb_64.c).

For example, adding the following code (9/14) for just Xen that the
majority of swiotbl users (x86_64 and IA64) don't need to the library
is against the design.

Can we have something like pci-swiotlb_xen.c (with some modifications
to the swiotlb library code)?

+__sync_single(struct swiotlb_phys_addr buffer, char *dma_addr, size_t size, int dir)
 {
-	if (dir == DMA_TO_DEVICE)
-		memcpy(dma_addr, buffer, size);
-	else
-		memcpy(buffer, dma_addr, size);
+	if (PageHighMem(buffer.page)) {
+		size_t len, bytes;
+		char *dev, *host, *kmp;
+
+		len = size;
+		while (len != 0) {
+			unsigned long flags;
+
+			bytes = len;
+			if ((bytes + buffer.offset) > PAGE_SIZE)
+				bytes = PAGE_SIZE - buffer.offset;
+			local_irq_save(flags); /* protects KM_BOUNCE_READ */
+			kmp  = kmap_atomic(buffer.page, KM_BOUNCE_READ);
+			dev  = dma_addr + size - len;
+			host = kmp + buffer.offset;
+			if (dir == DMA_FROM_DEVICE)
+				memcpy(host, dev, bytes);
+			else
+				memcpy(dev, host, bytes);
+			kunmap_atomic(kmp, KM_BOUNCE_READ);
+			local_irq_restore(flags);
+			len -= bytes;
+			buffer.page++;
+			buffer.offset = 0;
+		}
+	} else {
+		void *v = page_address(buffer.page) + buffer.offset;
+
+		if (dir == DMA_TO_DEVICE)
+			memcpy(dma_addr, v, size);
+		else
+			memcpy(v, dma_addr, size);
+	}
 }


