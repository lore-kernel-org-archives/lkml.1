Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZISQvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZISQvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZISQvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:51:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:17515 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbZISQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:51:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,416,1249282800"; 
   d="scan'208";a="552009758"
Date: Sat, 19 Sep 2009 20:29:51 -0400
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: dwmw2@infradead.org, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "gorcunov@gmail.com" <gorcunov@gmail.com>
Subject: Re: [PATCH] IR: Fix kernel hang if interrupt remapping disable in BIOS
Message-ID: <20090920002951.GA21419@youquan-linux.bj.intel.com>
References: <20090909160538.GA3799@youquan-linux.bj.intel.com> <1252532288.2767.27.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252532288.2767.27.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 02:38:08PM -0700, Suresh Siddha wrote:
> On Wed, 2009-09-09 at 09:05 -0700, Song, Youquan wrote:
> > BIOS clear DMAR table INTR_REMAP flag to disable interrupt remapping. Current
> > kernel only check interrupt remapping(IR) flag in DRHD's extended capability 
> > register to decide interrupt remapping support or not. But IR flag will not 
> > change when BIOS disable/enable interrupt remapping. 
> > 
> > When user disable interrupt remapping in BIOS or BIOS often defaultly disable 
> > interrupt remapping feature when BIOS is not mature.Though BIOS disable
> > interrupt remapping but intr_remapping_supported function will always report 
> > to OS support interrupt remapping if VT-d2 chipset populated. On this 
> > cases, kernel will continue enable interrupt remapping and result kernel panic. 
> > This bug exist on almost all platforms with interrupt remapping support.
> 
> I haven't encountered this before probably because bios was turning off
> the interrupt-remapping support in extended capability aswell. but I do
> agree that this fix is needed.
> 
> >      
> > 
> > This patch add DMAR table INTR_REMAP flag check before enable interrup remapping
> > 
> > Signed-off-by: Youquan Song <youquan.song@intel.com>
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> David, Can you please pick this up?
> 
> thanks.

David,  Can you please pick this up? We want the bug fixed at 2.6.32.
Thanks.

> 
> > ---
> > 
> > diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> > index a8a4383..d943e95 100644
> > --- a/drivers/pci/dmar.c
> > +++ b/drivers/pci/dmar.c
> > @@ -1302,3 +1302,13 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
> >  
> >  	return 0;
> >  }
> > +
> > +/*
> > + * Check interrupt remapping support in DMAR table description.
> > + */
> > +int dmar_ir_support(void)
> > +{
> > +	struct acpi_table_dmar *dmar;
> > +	dmar = (struct acpi_table_dmar *)dmar_tbl;
> > +	return dmar->flags & 0x1;
> > +}
> > diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
> > index ebfa47b..ac06514 100644
> > --- a/drivers/pci/intr_remapping.c
> > +++ b/drivers/pci/intr_remapping.c
> > @@ -611,6 +611,9 @@ int __init intr_remapping_supported(void)
> >  	if (disable_intremap)
> >  		return 0;
> >  
> > +	if (!dmar_ir_support())
> > +		return 0;
> > +
> >  	for_each_drhd_unit(drhd) {
> >  		struct intel_iommu *iommu = drhd->iommu;
> >  
> > diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> > index 482dc91..4f0a72a 100644
> > --- a/include/linux/intel-iommu.h
> > +++ b/include/linux/intel-iommu.h
> > @@ -360,4 +360,6 @@ extern void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
> >  
> >  extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
> >  
> > +extern int dmar_ir_support(void);
> > +
> >  #endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
