Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXJ2UgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXJ2UgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbXJ2Uf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:35:58 -0400
Received: from mga10.intel.com ([192.55.52.92]:27281 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756619AbXJ2Uf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:35:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,344,1188802800"; 
   d="scan'208";a="362819876"
Date: Mon, 29 Oct 2007 13:31:30 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] iommu-PMEN_REG boot up support
Message-ID: <20071029203130.GA1734@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071026181849.GA25256@linux.intel.com> <20071027001938.GB10215@rhun.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027001938.GB10215@rhun.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 02:19:38AM +0200, Muli Ben-Yehuda wrote:
> On Fri, Oct 26, 2007 at 11:18:49AM -0700, Mark Gross wrote:
> 
> > The following patch clears the portect memory region enable bit at
> > boot time by default.  It also provides a kernel parrameter for
> > disabling this behavior and leave the PMEN_REG untouched if so
> > wanted.
> > 
> > If the boot loader or platform has protected memory regions enabled
> > at boot time it could prevent DMA's from happening as drivers are
> > loaded and used.
> 
> What's the value of adding a command line option for this? Under what
> circumstances would we want to not clear this bit?

umm, /me asks around and finds out that at this time there isn't much
point to having a command line to preserve any protected areas set up at
boot time.

> 
> > +		} else if (!strncmp(str, "no_epm_clear", 12)) {
> > +			printk(KERN_INFO
> > +				"Intel-IOMMU: subress clearing of Enable "
> > +				"Protected Memory bit\n");
> > +			clear_pmen_epm = 0;
> 
> `suppress', I assume. Rest looks fine, if the configuration option is
> really needed.
> 
> Cheers,
> Muli
> -- 
> SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
> http://www.haifa.il.ibm.com/Workshops/systor2007/
> 
> Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
> -


Signed-off-by: mark gross <mgross@linux.intel.com>

--mgross


Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c	2007-10-24 09:31:32.000000000 -0700
+++ linux-2.6/drivers/pci/intel-iommu.c	2007-10-29 13:30:29.000000000 -0700
@@ -692,6 +692,23 @@
 		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
 }
 
+static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
+{
+	u32 pmen;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+	pmen = readl(iommu->reg + DMAR_PMEN_REG);
+	pmen &= ~DMA_PMEN_EPM;
+	writel(pmen, iommu->reg + DMAR_PMEN_REG);
+
+	/* wait for the protected region status bit to clear */
+	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
+		readl, (pmen & DMA_PMEN_PRS), pmen);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
 static int iommu_enable_translation(struct intel_iommu *iommu)
 {
 	u32 sts;
@@ -1731,6 +1748,8 @@
 		iommu_flush_context_global(iommu, 0);
 		iommu_flush_iotlb_global(iommu, 0);
 
+		iommu_disable_protect_mem_regions(iommu);
+
 		ret = iommu_enable_translation(iommu);
 		if (ret)
 			goto error;
Index: linux-2.6/drivers/pci/intel-iommu.h
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.h	2007-10-24 09:31:32.000000000 -0700
+++ linux-2.6/drivers/pci/intel-iommu.h	2007-10-29 10:30:24.000000000 -0700
@@ -126,6 +126,10 @@
 #define DMA_TLB_IH_NONLEAF (((u64)1) << 6)
 #define DMA_TLB_MAX_SIZE (0x3f)
 
+/* PMEN_REG */
+#define DMA_PMEN_EPM (((u32)1)<<31)
+#define DMA_PMEN_PRS (((u32)1)<<0)
+
 /* GCMD_REG */
 #define DMA_GCMD_TE (((u32)1) << 31)
 #define DMA_GCMD_SRTP (((u32)1) << 30)
