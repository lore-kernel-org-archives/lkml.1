Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZEAA5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZEAA5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZEAA5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:57:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:19351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZEAA5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:57:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,276,1239001200"; 
   d="scan'208";a="453137272"
Date: Thu, 30 Apr 2009 17:57:11 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "Han, Weidong" <weidong.han@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Intel IOMMU Pass Through Support
Message-ID: <20090501005711.GA27123@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <20090430162905.d232be29.akpm@linux-foundation.org> <49FA3650.8030307@xenotime.net> <20090430170034.1f8f8047.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430170034.1f8f8047.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 05:00:34PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 16:37:52 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > > 
> > > arch/x86/built-in.o: In function `iommu_setup':
> > > arch/x86/kernel/pci-dma.c:215: undefined reference to `iommu_pass_through'
> > > arch/x86/built-in.o: In function `pci_swiotlb_init':
> > > arch/x86/kernel/pci-swiotlb.c:74: undefined reference to `iommu_pass_through'
> > > 
> > > Because iommu_pass_through is defined in drivers/pci/intel-iommu.c and
> > > 
> > > # CONFIG_DMAR is not set
> > > 
> > > I'll need to cook up some local hack to work around that.
> > > 
> > 
> > Patch just went to linux-next mailing list (but should have also
> > gone to lkml):
> > 
> > http://marc.info/?l=linux-next&m=124113213400748&w=2
> 
> OK, thanks.  My linux-next feed seems to have broken.
> 
> That patch modifies 
> 
> 	arch/ia64/kernel/dma-mapping.c
> 	arch/x86/kernel/pci-dma.c
> 
> but it would be more logical to modify
> 
> 	arch/ia64/kernel/pci-dma.c
> 	arch/x86/kernel/pci-dma.c
> 
> is there a reason why that cannot be done?

No particular reason. I just follow iommu_detected definition which is arch/ia64
kernel/dma-mapping.c.

Now I updated the compiling error fix patch as follows:

This updated patch should fix the compiling errors and remove the extern
iommu_pass_through from drivers/pci/intel-iommu.c file.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 arch/ia64/kernel/pci-dma.c |    2 ++
 arch/x86/kernel/pci-dma.c  |    4 ++--
 drivers/pci/intel-iommu.c  |    1 -
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index eb98738..ecdde25 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -32,6 +32,8 @@ int force_iommu __read_mostly = 1;
 int force_iommu __read_mostly;
 #endif
 
+int iommu_pass_through;
+
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to i386. */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 8cad0d8..049005e 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -32,6 +32,8 @@ int no_iommu __read_mostly;
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
+int iommu_pass_through;
+
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
@@ -160,8 +162,6 @@ again:
 	return page_address(page);
 }
 
-extern int iommu_pass_through;
-
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index d3ac5e5..66a9cba 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -288,7 +288,6 @@ int dmar_disabled = 1;
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
-int iommu_pass_through;
 
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
