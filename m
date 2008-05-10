Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYEJSgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYEJSgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 14:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYEJSfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 14:35:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:4385 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYEJSft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 14:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=xHEG7ez/DzZeJbyJMbi0BLaXa92WiZH+F0mictD5RgXLD1x3dDxfmEKKN5SVKQzfaT4ZFnvdBCJl9x0XkG+9gWM2QteWMdDCoXIyp3t9T6Cl72w3tPSMyqvtG5bFRAs+Tv25QMpMl/SrHXLNtAN8dQun04WcYK/NJrkR5Uh9Ccg=
Date: Sat, 10 May 2008 23:31:07 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Chris Snook <csnook@redhat.com>, Luca Tettamanti <kronos.it@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH] Re: atl1 64-bit => 32-bit DMA borkage (reproducible,
	bisected)
Message-ID: <20080510193107.GA4930@martell.zuzino.mipt.ru>
References: <20080420133704.63f5cc10@osprey.hogchain.net> <20080420205500.GA4762@martell.zuzino.mipt.ru> <20080421210821.28053a92@osprey.hogchain.net> <20080425195743.2bfe66ee@osprey.hogchain.net> <20080504211507.GC1040@martell.zuzino.mipt.ru> <20080506110225.31fd61a4@osprey.hogchain.net> <20080509195149.GA4985@martell.zuzino.mipt.ru> <48249E55.1020300@redhat.com> <20080509200715.GA5040@martell.zuzino.mipt.ru> <20080509143854.7bc39ab7@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509143854.7bc39ab7@osprey.hogchain.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 02:38:54PM -0500, Jay Cliburn wrote:
> [trimmed cc list slightly]
> 
> On Sat, 10 May 2008 00:07:15 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Fri, May 09, 2008 at 02:56:21PM -0400, Chris Snook wrote:
> > > Alexey Dobriyan wrote:
> > >> Hmmm, there was a wonderful oops on interface stop here when the
> > >> other end of atl1 cable was physically unplugged (but there was
> > >> traffic before): atl1_down
> > >> 	atl1_clean_rx_ring
> > >> 	swiotlb_unmap_single
> > >> 	swiotlb_unmap_single_attrs
> > >> 	memcpy_c
> > >
> > > Intel chip, or AMD?
> > 
> > Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz
> > Asus P5B-E motherboard.
> > 
> 
> I see the same thing with a Socked AM2-based board (Asus M2V) with 4GB
> RAM installed. The problem occurs only when SWIOTLB is active, which
> happens automatically at boot (in arch/x86/kernel/pci-swiotlb.c) when
> the page frame number exceeds 1048576 (corresponding to 2^32 bytes).
> 
> I thought for awhile that the problem went away with iommu=allowed, but
> I was wrong.
> 
> The bug appears to be a "simple" skb write-after-free that happens only
> when bounce buffers are in use, but I'll be damned if I can find the
> cause of it.
> 
> <continues looking>

Try this patch! If scared, remove swiotlb poisoning, I'm not entirely
sure it's correct, but it makes aforementioned second oops
deterministic.

--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2027,6 +2029,7 @@ rrd_ok:
 		/* Good Receive */
 		pci_unmap_page(adapter->pdev, buffer_info->dma,
 			       buffer_info->length, PCI_DMA_FROMDEVICE);
+		buffer_info->dma = 0;
 		skb = buffer_info->skb;
 		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d568894..f6165ed 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -399,12 +399,14 @@ unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if (buffer && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+	if (buffer && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))) {
 		/*
 		 * bounce... copy the data back into the original buffer * and
 		 * delete the bounce buffer.
 		 */
 		memcpy(buffer, dma_addr, size);
+		io_tlb_orig_addr[index] = (void *)0x9a9a9a9a9a9a9a9aUL;
+	}
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding

