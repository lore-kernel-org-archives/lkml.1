Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYG2EkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYG2EkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYG2Ej6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:39:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:40700 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYG2Ej5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:39:57 -0400
Date: Tue, 29 Jul 2008 13:38:53 +0900
To: sfr@canb.auug.org.au
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080729135652.f89042c1.sfr@canb.auug.org.au>
References: <20080729110749.728c54e6.sfr@canb.auug.org.au>
	<20080729104722H.fujita.tomonori@lab.ntt.co.jp>
	<20080729135652.f89042c1.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080729133909L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 13:56:52 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi, 
> 
> On Tue, 29 Jul 2008 10:46:31 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >
> > > So, I assume a patch created on July 25 is not destined for 2.6.27,
> > 
> > Hmm, seems that they will go into 2.6.27:
> > 
> > http://marc.info/?l=linux-kernel&m=121729275722287&w=2
> > 
> > 
> > > right?  Especially since it breaks another architecture build and has
> > > only made it to linux-next on July 29 ... and needs more work given the
> > > comments already on this patch.
> > 
> > It doesn't break another architecture build since only x86 IOMMUs use
> > the helper function. But as I pointed out, it doesn't work for some
> > architectures.
> 
> Um, did you see the linux-next build report I posted (possibly not):
> 
> arch/powerpc/kernel/iommu.c:56: error: static declaration of 'iommu_num_pages' follows non-static declaration
> include/linux/iommu-helper.h:11: error: previous declaration of 'iommu_num_pages' was here
> 
> This is now a build of 2.6.27-rc1 for powerpc64 ppc64_defconfig ...

Ah, really sorry. Yeah, it breaks POWER and SPARC builds.


> So we have a patch first posted to lkml on July 25 first hits linux-next
> on July 29 and is no in Linus' tree on July 29.  A grep would have found
> the problem.
> 
> More care required ...

Agreed... As I said before, this is not urgent at all so we didn't
need to rush.


A fix has already been posted?

==
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] move iommu_num_pages helper to x86

This IOMMU helper function doesn't work for some architectures:

http://marc.info/?l=linux-kernel&m=121699304403202&w=2

It also breaks POWER and SPARC builds:

http://marc.info/?l=linux-kernel&m=121730388001890&w=2

Currently, only x86 IOMMUs use this so let's move it to x86 for
now.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c    |    8 ++++++++
 include/asm-x86/iommu.h      |    2 ++
 include/linux/iommu-helper.h |    1 -
 lib/iommu-helper.c           |    8 --------
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 8dbffb8..87d4d69 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -123,6 +123,14 @@ void __init pci_iommu_alloc(void)
 
 	pci_swiotlb_init();
 }
+
+unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
+{
+	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
+
+	return size >> PAGE_SHIFT;
+}
+EXPORT_SYMBOL(iommu_num_pages);
 #endif
 
 /*
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index ecc8061..5f888cc 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -7,6 +7,8 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
+extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
+
 #ifdef CONFIG_GART_IOMMU
 extern int gart_iommu_aperture;
 extern int gart_iommu_aperture_allowed;
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index f8598f5..c975caf 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -8,4 +8,3 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index 889ddce..a3b8d4c 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -80,11 +80,3 @@ void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
 	}
 }
 EXPORT_SYMBOL(iommu_area_free);
-
-unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
-{
-	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
-
-	return size >> PAGE_SHIFT;
-}
-EXPORT_SYMBOL(iommu_num_pages);
-- 
1.5.5.GIT

