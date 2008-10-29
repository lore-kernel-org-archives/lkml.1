Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYJ2L4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYJ2L4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 07:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYJ2Lzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 07:55:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:58847 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYJ2Lzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 07:55:50 -0400
Date: Wed, 29 Oct 2008 20:55:16 +0900
To: jens.axboe@oracle.com
Cc: mingo@elte.hu, jeremy@goop.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with
 BIOVEC_PHYS_MERGEABLE
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081029113434.GA31673@kernel.dk>
References: <20081029112745.GT22217@kernel.dk>
	<20081029113016.GA3751@elte.hu>
	<20081029113434.GA31673@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081029205501W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 12:34:34 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Oct 29 2008, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Wed, Oct 29 2008, Ingo Molnar wrote:
> > > > 
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > 
> > > > > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > > > 
> > > > > >> does it have any dependency on:
> > > > > >>
> > > > > >>   Subject: [PATCH 1/2] bio: define __BIOVEC_PHYS_MERGEABLE
> > > > > >
> > > > > > No, they're independent.  Defining __BIOVEC_PHYS_MERGEABLE will be 
> > > > > > useful for the Xen changes I need to make in the wake of Tomo's 
> > > > > > patch.
> > > > > 
> > > > > ok - applied to tip/x86/xen, thanks Jeremy! (also added Jens's 
> > > > > Acked-by)
> > > > 
> > > > build failure, zapped it:
> > > > 
> > > > fs/bio.c: In function '__bio_add_page':
> > > > fs/bio.c:443: error: implicit declaration of function '__BIOVEC_PHYS_MERGEABLE'
> > > 
> > > What patch(es) did you apply?
> > 
> > the one i replied to (2/2), and which one Jeremy said was independent 
> > of 1/2. Not so much it appears.
> 
> OK, those two are definitely connected, since the first one defines
> __BIOVEC_PHYS_MERGEABLE :-)

And [2/2] is wrong (that's what Jens and I explained to
Jeremy). Please don't apply it.


> The one I acked was in the mail I replied to, Tomos patch.

For your convenience, here's a repost (with Jens' ack).

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: remove dead BIO_VMERGE_BOUNDARY definition

The block layer dropped the virtual merge feature
(b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
definition is meaningless now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/include/asm/io.h    |    2 --
 arch/x86/include/asm/io_64.h |    2 --
 arch/x86/kernel/pci-dma.c    |    6 ------
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 5618a10..2f13dbe 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -59,8 +59,6 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
 #define writeq writeq
 #endif
 
-extern int iommu_bio_merge;
-
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
index fea325a..563c162 100644
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -232,8 +232,6 @@ void memset_io(volatile void __iomem *a, int b, size_t c);
 
 #define flush_write_buffers()
 
-#define BIO_VMERGE_BOUNDARY iommu_bio_merge
-
 /*
  * Convert a virtual cached pointer to an uncached pointer
  */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1972266..d851667 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -28,11 +28,6 @@ int no_iommu __read_mostly;
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
-/* This tells the BIO block layer to assume merging. Default to off
-   because we cannot guarantee merging later. */
-int iommu_bio_merge __read_mostly = 0;
-EXPORT_SYMBOL(iommu_bio_merge);
-
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
@@ -186,7 +181,6 @@ static __init int iommu_setup(char *p)
 		}
 
 		if (!strncmp(p, "biomerge", 8)) {
-			iommu_bio_merge = 4096;
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
-- 
1.5.5.GIT

