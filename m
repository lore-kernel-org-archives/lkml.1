Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbYHUPSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbYHUPSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760495AbYHUPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:18:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:38084 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760475AbYHUPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:18:22 -0400
Date: Fri, 22 Aug 2008 00:12:09 +0900
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, jbarnes@virtuousgeek.org, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080821231230V.fujita.tomonori@lab.ntt.co.jp>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
	<20080820094612.GA28492@elte.hu>
	<20080821231230V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080822001238F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 23:16:50 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 20 Aug 2008 11:46:12 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > Hi,
> > > 
> > > this patchset reworks the dma_*_coherent functions in the DMA layer 
> > > for the x86 architecture. The patch series extends the existing DMA 
> > > backends with missing *coherent callbacks and simplifies the generic 
> > > function to basically only call the registered backend. This allows 
> > > future optimizations in hardware specific IOMMU implementations. The 
> > > code ist tested on AMD64 with AMD IOMMU, GART, SWIOTLB and NOMMU as 
> > > well as on my old 486 box. Muli tested the Calgary specific patch.
> > > 
> > > Joerg
> > > 
> > > Changes since v1:
> > > 
> > > - fixed wrong logic in the pci-nommu alloc_coherent code
> > > - moved dma_*_coherent to include/asm-x86/dma-mapping.h
> > > 
> > > git diff --stat tip/master.. :
> > > 
> > >  arch/x86/kernel/amd_iommu.c      |    2 -
> > >  arch/x86/kernel/pci-calgary_64.c |   14 ++++
> > >  arch/x86/kernel/pci-dma.c        |  146 +-------------------------------------
> > >  arch/x86/kernel/pci-gart_64.c    |   35 +++++++++-
> > >  arch/x86/kernel/pci-nommu.c      |   62 ++++++++++++++++
> > >  include/asm-x86/dma-mapping.h    |   47 ++++++++++---
> > >  6 files changed, 149 insertions(+), 157 deletions(-)
> > 
> > applied to tip/x86/iommu - thanks Joerg!
> > 
> > Jesse, Fujita-san, do these changes look fine to you?
> 
> As I wrote in another mail, GART should return zeroed memory (keeping
> the current behavior is better). Except for it, the patchset looks
> fine.

I think that you can apply the following patch after Joerg's patchset.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: remove map_simple hook in struct dma_mapping_ops

pci-dma.c doesn't use map_simple hook any more so we can remove it
from struct dma_mapping_ops now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    1 -
 include/asm-x86/dma-mapping.h |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 10afe97..b3bbe2b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -720,7 +720,6 @@ extern int agp_amd64_init(void);
 
 static struct dma_mapping_ops gart_dma_ops = {
 	.map_single			= gart_map_single,
-	.map_simple			= gart_map_simple,
 	.unmap_single			= gart_unmap_single,
 	.sync_single_for_cpu		= NULL,
 	.sync_single_for_device		= NULL,
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 8e16095..3a9a6f5 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -26,9 +26,6 @@ struct dma_mapping_ops {
 				void *vaddr, dma_addr_t dma_handle);
 	dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
 				size_t size, int direction);
-	/* like map_single, but doesn't check the device mask */
-	dma_addr_t      (*map_simple)(struct device *hwdev, phys_addr_t ptr,
-				size_t size, int direction);
 	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
 				size_t size, int direction);
 	void            (*sync_single_for_cpu)(struct device *hwdev,
-- 
1.5.5.GIT

