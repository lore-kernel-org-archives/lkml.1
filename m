Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbXFASTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbXFASTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761591AbXFASTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:19:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760692AbXFASTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:19:02 -0400
Message-ID: <46606306.2060203@redhat.com>
Date: Fri, 01 Jun 2007 14:18:46 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, andrew.vasquez@qlogic.com
Subject: Re: [PATCH] quiet down swiotlb warnings
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org>
In-Reply-To: <20070601181225.GA16460@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------020505080101000003010604"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020505080101000003010604
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> On Fri, Jun 01, 2007 at 09:01:45PM +0200, Andi Kleen wrote:
>> Bad idea imho. swiotlb mappings should always lead to printk by default
>> because it is pretty dangerous.
>>
>> One possible solution for this I could think of would be to define a
>> new pci_map_sg_couldfail() or similar that doesn't warn and use a weak
>> fallback just calling pci_map_sg on other IOMMU implementations. 
> 
> pci_map_sg is defined to be failing when running out of ressources, which
> is perfectly fine.  We don't printk on kmalloc failures either (actually
> in some cases which is highly annoying and leads people to stick a
> __GFP_NOWARN into various places)

Andi, I could see your "pretty dangerous" case applying
when do_panic is set, but not in any other circumstances.

Does the patch below look better to you?

Signed-off-by: Rik van Riel <riel@redhat.com>

--------------020505080101000003010604
Content-Type: text/x-patch;
 name="2.6.21-swiotlb-quiet.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.21-swiotlb-quiet.patch"

--- linux-2.6.21.noarch/lib/swiotlb.c.quiet	2007-06-01 13:23:04.000000000 -0400
+++ linux-2.6.21.noarch/lib/swiotlb.c	2007-06-01 14:18:26.000000000 -0400
@@ -505,6 +505,7 @@ swiotlb_free_coherent(struct device *hwd
 static void
 swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 {
+	static int warnings = 0;
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
 	 * Unfortunately the drivers cannot handle this operation properly.
@@ -512,8 +513,9 @@ swiotlb_full(struct device *dev, size_t 
 	 * When the mapping is small enough return a static buffer to limit
 	 * the damage, or panic when the transfer is too big.
 	 */
-	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
-	       "device %s\n", size, dev ? dev->bus_id : "?");
+	if (do_panic || ++warnings < 5)
+		printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
+		       "device %s\n", size, dev ? dev->bus_id : "?");
 
 	if (size > io_tlb_overflow && do_panic) {
 		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)

--------------020505080101000003010604--
