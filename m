Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYIROEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYIROEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYIROEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:04:16 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:33442 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYIROEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:04:15 -0400
X-BigFish: VPS-39(zz1418M1432R98dR1805M179dR936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7E9QE-03-LH0-01
Date: Thu, 18 Sep 2008 16:03:50 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Message-ID: <20080918140350.GE24392@amd.com>
References: <1221670377-19295-4-git-send-email-joerg.roedel@amd.com> <20080918041104K.fujita.tomonori@lab.ntt.co.jp> <20080917192827.GA18515@8bytes.org> <20080918102931Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080918102931Z.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 18 Sep 2008 14:03:50.0873 (UTC) FILETIME=[60A19C90:01C91997]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 10:29:24AM +0900, FUJITA Tomonori wrote:
> On Wed, 17 Sep 2008 21:28:27 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Thu, Sep 18, 2008 at 04:20:18AM +0900, FUJITA Tomonori wrote:
> > > On Wed, 17 Sep 2008 18:52:37 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > The IO/TLB flushing on every unmaping operation is the most expensive
> > > > part there and not strictly necessary. It is sufficient to do the flush
> > > > before any entries are reused. This is patch implements lazy IO/TLB
> > > > flushing which does exactly this.
> > > > 
> > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > ---
> > > >  Documentation/kernel-parameters.txt |    5 +++++
> > > >  arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
> > > >  arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
> > > >  include/asm-x86/amd_iommu_types.h   |    9 +++++++++
> > > >  4 files changed, 45 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > index c2e00ee..5f0aefe 100644
> > > > --- a/Documentation/kernel-parameters.txt
> > > > +++ b/Documentation/kernel-parameters.txt
> > > > @@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
> > > >  			isolate - enable device isolation (each device, as far
> > > >  			          as possible, will get its own protection
> > > >  			          domain)
> > > > +			unmap_flush - enable flushing of IO/TLB entries when
> > > > +			              they are unmapped. Otherwise they are
> > > > +				      flushed before they will be reused, which
> > > > +				      is a lot of faster
> > > > +
> > > 
> > > Would it be nice to have consistency of IOMMU parameters?
> > 
> > True. We should merge common parameters across IOMMUs into the
> > iommu= parameter some time in the future, I think. It would also be the
> > place for the IOMMU size parameter.
> 
> Hmm, now is better than the future? I think that now you can add
> something like 'disable_batching_flush' as a common parameter and
> change AMD IOMMU to use it.

Ok, I queued the following patch in the AMD IOMMU updates and changed
this patch to use iommu_fullflush instead. Is this patch ok? It changes
the behavior of GART to use lazy flushing by default. But I don't think
that this is a problem.

commit 9769771290fddcfc0362c5d30242151d4eb1cc46
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Sep 18 15:23:43 2008 +0200

    x86: move GART TLB flushing options to generic code
    
    The GART currently implements the iommu=[no]fullflush command line
    parameters which influence its IO/TLB flushing strategy. This patch
    makes these parameters generic so that they can be used by the AMD IOMMU
    too.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c2e00ee..569527e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -888,6 +888,10 @@ and is between 256 and 4096 characters. It is defined in the file
 		nomerge
 		forcesac
 		soft
+		fullflush
+			Flush IO/TLB at every deallocation
+		nofullflush
+			Flush IO/TLB only when addresses are reused (default)
 
 
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 72ffb53..42c887b 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -229,8 +229,6 @@ IOMMU (input/output memory management unit)
   iommu options only relevant to the AMD GART hardware IOMMU:
     <size>             Set the size of the remapping area in bytes.
     allowed            Overwrite iommu off workarounds for specific chipsets.
-    fullflush          Flush IOMMU on each allocation (default).
-    nofullflush        Don't use IOMMU fullflush.
     leak               Turn on simple iommu leak tracing (only when
                        CONFIG_IOMMU_LEAK is on). Default number of leak pages
                        is 20.
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 23882c4..6dae123 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -16,6 +16,15 @@ EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
 
+/*
+ * If this is disabled the IOMMU will use an optimized flushing strategy
+ * of only flushing when an mapping is reused. With it true the GART is
+ * flushed for every mapping. Problem is that doing the lazy flush seems
+ * to trigger bugs with some popular PCI cards, in particular 3ware (but
+ * has been also also seen with Qlogic at least).
+ */
+int iommu_fullflush;
+
 #ifdef CONFIG_IOMMU_DEBUG
 int panic_on_overflow __read_mostly = 1;
 int force_iommu __read_mostly = 1;
@@ -171,6 +180,10 @@ static __init int iommu_setup(char *p)
 		}
 		if (!strncmp(p, "nomerge", 7))
 			iommu_merge = 0;
+		if (!strncmp(p, "fullflush", 8))
+			iommu_fullflush = 1;
+		if (!strncmp(p, "nofullflush", 11))
+			iommu_fullflush = 0;
 		if (!strncmp(p, "forcesac", 8))
 			iommu_sac_force = 1;
 		if (!strncmp(p, "allowdac", 8))
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 9739d56..508ef47 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -45,15 +45,6 @@ static unsigned long iommu_pages;	/* .. and in pages */
 
 static u32 *iommu_gatt_base;		/* Remapping table */
 
-/*
- * If this is disabled the IOMMU will use an optimized flushing strategy
- * of only flushing when an mapping is reused. With it true the GART is
- * flushed for every mapping. Problem is that doing the lazy flush seems
- * to trigger bugs with some popular PCI cards, in particular 3ware (but
- * has been also also seen with Qlogic at least).
- */
-int iommu_fullflush = 1;
-
 /* Allocation bitmap for the remapping area: */
 static DEFINE_SPINLOCK(iommu_bitmap_lock);
 /* Guarded by iommu_bitmap_lock: */
@@ -901,10 +892,6 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
-	if (!strncmp(p, "fullflush", 8))
-		iommu_fullflush = 1;
-	if (!strncmp(p, "nofullflush", 11))
-		iommu_fullflush = 0;
 	if (!strncmp(p, "noagp", 5))
 		no_agp = 1;
 	if (!strncmp(p, "noaperture", 10))
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 546ad31..bcebc37 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -7,6 +7,7 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int dmar_disabled;
+extern int iommu_fullflush;
 
 extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

