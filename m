Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbZEAAXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbZEAAXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763276AbZEAAFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:05:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:50181 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765389AbZEAAFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:05:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,275,1239001200"; 
   d="scan'208";a="137965858"
Date: Thu, 30 Apr 2009 17:05:10 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "Han, Weidong" <weidong.han@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] Intel IOMMU Pass Through Support
Message-ID: <20090501000509.GA20743@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <20090430162905.d232be29.akpm@linux-foundation.org> <49FA3650.8030307@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FA3650.8030307@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 04:37:52PM -0700, Randy Dunlap wrote:
> Andrew Morton wrote:
> > On Wed, 15 Apr 2009 17:19:57 -0700
> > Fenghua Yu <fenghua.yu@intel.com> wrote:
> > 
> >> The patch adds kernel parameter intel_iommu=pt to set up pass through mode in
> >> context mapping entry. This disables DMAR in linux kernel; but KVM still runs on
> >> VT-d and interrupt remapping still works.
> >>
> >> In this mode, kernel uses swiotlb for DMA API functions but other VT-d
> >> functionalities are enabled for KVM. KVM always uses multi level translation
> >> page table in VT-d. By default, pass though mode is disabled in kernel.
> >>
> >> This is useful when people don't want to enable VT-d DMAR in kernel but still
> >> want to use KVM and interrupt remapping for reasons like DMAR performance
> >> concern or debug purpose.
> >>
> > 
> > The patch is now in linux-next and broke my build.
> > 
> > arch/x86/built-in.o: In function `iommu_setup':
> > arch/x86/kernel/pci-dma.c:215: undefined reference to `iommu_pass_through'
> > arch/x86/built-in.o: In function `pci_swiotlb_init':
> > arch/x86/kernel/pci-swiotlb.c:74: undefined reference to `iommu_pass_through'
> > 
> > Because iommu_pass_through is defined in drivers/pci/intel-iommu.c and
> > 
> > # CONFIG_DMAR is not set
> > 
> > I'll need to cook up some local hack to work around that.
> > 
> 
> Patch just went to linux-next mailing list (but should have also
> gone to lkml):
> 
> http://marc.info/?l=linux-next&m=124113213400748&w=2

That's right. I just posted this patch to fix the compiling errors.

> 
> 
> > 
> > Also, the patch in linux-next (but not the one which I'm replying to
> > here does:
> > 
> > : --- a/arch/x86/kernel/pci-dma.c
> > : +++ b/arch/x86/kernel/pci-dma.c
> > : @@ -160,6 +160,8 @@ again:
> > :         return page_address(page);
> > :  }
> > :  
> > : +extern int iommu_pass_through;
> > : +
> > 
> > Which is wrong and unnecessary - the variable was already declared in a
> > header file.
> > 
> > scripts/checkpatch.pl would have warned you about this error, but
> > apparently neither you nor the people who reviewed or merged the patch
> > bother to use it.

Actually checkpatch.pl doesn't report anything wrong with this statement.

The following patch removes this statement on the top of linux-next.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 pci-dma.c |    2 --
 1 files changed, 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 8cad0d8..049005e 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -160,8 +162,6 @@ again:
 	return page_address(page);
 }
 
-extern int iommu_pass_through;
-
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
