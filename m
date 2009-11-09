Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZKIXDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZKIXDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZKIXDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:03:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:53427 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbZKIXDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:03:04 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on	passthrough
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: alex.williamson@hp.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 23:02:27 +0000
Message-ID: <1257807747.25961.852.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 11:41 +0900, FUJITA Tomonori wrote:
> This is fine for 2.6.32 but we'll cleanly fix this by using
> swiotlb_dma_ops later, right?

Well, the idea was that with 'iommu=pt' we'd have passthrough mode for
_decent_ devices, but the crappy devices without 64-bit DMA would just
have the IOMMU enabled instead.

We can see this as a simple classification bug -- we should be checking
pdev->coherent_dma_mask as well as pdev->dma_mask:

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2196,7 +2196,8 @@ static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
 	 * take them out of the 1:1 domain later.
 	 */
 	if (!startup)
-		return pdev->dma_mask > DMA_BIT_MASK(32);
+		return (pdev->dma_mask & pdev->coherent_dma_mask) < 
+			dma_get_required_mask();
 
 	return 1;
 }

That fixes the case of a 32-bit coherent_dma_mask as it was intended to
be fixed.

Unfortunately, Alex's hardware is more broken than that. It also likes
to do stray reads from unmapped addresses -- addresses which used to be
mapped at some time in the past. So he really _does_ want the IOMMU
disabled, or in passthrough mode.

But I think that's a special case and needs to be handled with a quirk,
while the above patch actually addresses the problem we claimed we were
trying to address.

Handling Alex's broken hardware probably wants to be done with
'iommu=off' for now, and then when Chris's swiotlb fallback patches are
done we can perhaps do something more cunning.

I'm slightly reluctant to put the half-arsed 'try to allocate in the
right region for broken devices but without full swiotlb support' option
into 2.6.32.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

