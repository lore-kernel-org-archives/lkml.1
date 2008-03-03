Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYCCMa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYCCMa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYCCMat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:30:49 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37497 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbYCCMas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:30:48 -0500
Date: Mon, 3 Mar 2008 21:22:07 +0900
To: rubisher@scarlet.be
Cc: kyle@mcmartin.ca, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       tomof@acm.org, kyle@parisc-linux.org, matthew@wil.cx,
       grundler@parisc-linux.org, akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <JX5IQO$1ADFF18D173371DE06D03C11EFEA34BA@scarlet.be>
References: <JX5IQO$1ADFF18D173371DE06D03C11EFEA34BA@scarlet.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080303212206E.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Mar 2008 12:04:00 +0100
"rubisher" <rubisher@scarlet.be> wrote:

> > On Sun, Mar 02, 2008 at 03:10:25PM +0900, FUJITA Tomonori wrote:
> > > This patchset is another sequel to my patchset to fix iommu segment
> > > boundary problems, IOMMUs allocate memory areas without considering a
> > > low level driver's segment boundary limits:
> > > 
> > > http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html
> > > 
> > 
> > This looks fine. Are you able to test this? If not, we can set you up
> > with an account on a machine with remote console and all that jazz, if
> > you'd like to.
> > 
> > cheers, Kyle
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> Sorry for bad news but using a kernel known to work fine on my b2k (kyle's
> parisc-2.6.git date 2008_02_21) against which I applied those patches, this
> new kernel 32bit up failled to boot with this panic message:
> 
> Linux Tulip driver version 1.1.15 (Feb 27, 2007)
> ------------[ cut here ]------------
> Kernel BUG at 1029520c [verbose debug info unavailable]
> 
>      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> PSW: 00000000000001001111111100001110 Not tainted
> r00-03  0004ff0e 1054c010 1029e774 80000000
> r04-07  1fc2b020 00000100 00000000 00000001
> r08-11  1fc1d454 1fc2c000 00000000 80000000
> r12-15  00000001 00000001 1fc10858 0001a000
> r16-19  00000011 104a23d0 00000000 ffffffff
> r20-23  00001000 00000000 1fdb6a00 00000000
> r24-27  00000000 00000001 00000100 10507010
> r28-31  00000100 00100000 1fc205c0 00000000
> sr00-03  00000000 00000000 00000000 00000000
> sr04-07  00000000 00000000 00000000 00000000
> IASQ: 00000000 00000000 IAOQ: 1029520c 10295210
>  IIR: 03ffe01f    ISR: 1024003f  IOR: 0802056c
>  CPU:        0   CR30: 1fc20000 CR31: 11111111
>  ORIG_R28: 0000000f
>  IAOQ[0]: iommu_is_span_boundary+0x28/0x30
>  IAOQ[1]: iommu_is_span_boundary+0x2c/0x30
>  RP(r2): sba_alloc_range+0x23c/0x4f8

Thanks a lot for testing!

Really sorry about the bug. Can you try the following patch? It's on
the top of the patchset.

Thanks,

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 2f3b364..d0855a1 100644
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
