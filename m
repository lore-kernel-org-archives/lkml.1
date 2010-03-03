Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0CCAZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:25:55 -0500
Received: from sh.osrg.net ([192.16.179.4]:49210 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab0CCAZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:25:54 -0500
Date: Wed, 3 Mar 2010 09:25:38 +0900
To: michael@ellerman.id.au
Cc: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
       davem@davemloft.net
Subject: Re: [PATCH] powerpc: remove IOMMU_VMERGE config option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1267575232.7814.21.camel@concordia>
References: <20100303085404R.fujita.tomonori@lab.ntt.co.jp>
	<1267575232.7814.21.camel@concordia>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100303092518X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 03 Mar 2010 09:25:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 11:13:52 +1100
Michael Ellerman <michael@ellerman.id.au> wrote:

> On Wed, 2010-03-03 at 08:54 +0900, FUJITA Tomonori wrote:
> > Seems that IOMMU_VMERGE option description gives the false
> > information:
> > 
> > http://marc.info/?l=linux-sparc&m=126753808727669&w=2
> > http://marc.info/?l=linux-sparc&m=126753880528825&w=2
> > 
> > IOMMU_VMERGE is unnecessary nowadays so how about removing it?
> 
> Except you didn't remove it, you just made it uneditable? Why not get
> rid of it entirely.

Oops, yeah, I should have. Here's the second version.

Thanks,

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] powerpc: remove IOMMU_VMERGE config option

The description says:

 Cause IO segments sent to a device for DMA to be merged virtually
 by the IOMMU when they happen to have been allocated contiguously.
 This doesn't add pressure to the IOMMU allocator. However, some
 drivers don't support getting large merged segments coming back
 from *_map_sg().

 Most drivers don't have this problem; it is safe to say Y here.

It's out of date. Long ago, drivers didn't have a way to tell IOMMUs
about their segment length limit (that is, the maximum segment length
that they can handle). So IOMMUs merged as many segments as possible
and gave too large segments to drivers.

dma_get_max_seg_size() was introduced to solve the above
problem. Device drives can use the API to tell IOMMU about the maximum
segment length that they can handle. In addition, the default limit
(64K) should be safe for everyone.

So this config option seems to be unnecessary.

Note that this config option just enables users to disable the virtual
merging by default. Users can still disable the virtual merging by the
boot parameter.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/Kconfig        |   13 -------------
 arch/powerpc/kernel/iommu.c |    7 +------
 2 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 155d571..c984bc5 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -313,19 +313,6 @@ config 8XX_MINIMAL_FPEMU
 
 	  It is recommended that you build a soft-float userspace instead.
 
-config IOMMU_VMERGE
-	bool "Enable IOMMU virtual merging"
-	depends on PPC64
-	default y
-	help
-	  Cause IO segments sent to a device for DMA to be merged virtually
-	  by the IOMMU when they happen to have been allocated contiguously.
-	  This doesn't add pressure to the IOMMU allocator. However, some
-	  drivers don't support getting large merged segments coming back
-	  from *_map_sg().
-
-	  Most drivers don't have this problem; it is safe to say Y here.
-
 config IOMMU_HELPER
 	def_bool PPC64
 
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 5547ae6..ec94f90 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -42,12 +42,7 @@
 
 #define DBG(...)
 
-#ifdef CONFIG_IOMMU_VMERGE
-static int novmerge = 0;
-#else
-static int novmerge = 1;
-#endif
-
+static int novmerge;
 static int protect4gb = 1;
 
 static void __iommu_free(struct iommu_table *, dma_addr_t, unsigned int);
-- 
1.6.5



