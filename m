Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbYCEIO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbYCEIO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbYCEIOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:14:17 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:41759 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbYCEIOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:14:16 -0500
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25-rc4
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080305170930C.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 05 Mar 2008 17:09:30 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 21:03:44 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> It's a few days late, but I was waiting for some updates for some of the 
> most annoying regressions until releasing it, so the end result is 
> hopefully more useful as a result.

Ah, the IOMMU patches (alpha and parisc) that I submitted for -mm have
been merged somehow.

The parisc patches were tested but probably the alpha patches not.

Here's a patch for 32bits arch parisc.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] parisc: fix IOMMU's device boundary overflow bug on 32bits arch

On 32bits boxes, boundary_size becomes zero due to a overflow and we
hit BUG_ON in iommu_is_span_boundary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
---
 drivers/parisc/ccio-dma.c  |    4 ++--
 drivers/parisc/sba_iommu.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 60d338c..62db3c3 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -366,8 +366,8 @@ ccio_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 	** ggg sacrifices another 710 to the computer gods.
 	*/
 
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
-	boundary_size >>= IOVP_SHIFT;
+	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
+			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
 
 	if (pages_needed <= 8) {
 		/*
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e834127..bdbe780 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -341,8 +341,8 @@ sba_search_bitmap(struct ioc *ioc, struct device *dev,
 	unsigned long shift;
 	int ret;
 
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
-	boundary_size >>= IOVP_SHIFT;
+	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
+			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
 
 #if defined(ZX1_SUPPORT)
 	BUG_ON(ioc->ibase & ~IOVP_MASK);
-- 
1.5.3.7

