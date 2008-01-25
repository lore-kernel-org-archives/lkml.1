Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYAYSIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYAYSIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbYAYSIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:08:20 -0500
Received: from mga07.intel.com ([143.182.124.22]:49885 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759053AbYAYSIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,251,1199692800"; 
   d="scan'208";a="371312137"
Date: Fri, 25 Jan 2008 10:08:20 -0800
From: mark gross <mgross@linux.intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: [agp-mm][PATCH 1/4][intel_iommu] explicit export current
	graphics dmar status
Message-ID: <20080125180820.GA16868@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071218050809.GA12564@zhen-devel.sh.intel.com> <20071219052030.GA24238@zhen-devel.sh.intel.com> <20071219052608.GB24238@zhen-devel.sh.intel.com> <20080104015338.GA17253@zhen-devel.sh.intel.com> <20080108204420.GA9491@linux.intel.com> <20080125030255.GB19129@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125030255.GB19129@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:02:55AM +0800, Zhenyu Wang wrote:
> 
> Mark, sorry for missing this for long time...
> 
> On 2008.01.08 12:44:20 -0800, mark gross wrote:
> > > > 
> > > > [agp-mm] [intel_iommu] explicit export current graphics dmar status
> > > > 
> > > > To make it possbile to tell other modules about curent
> > > > graphics dmar engine status, that could decide if graphics
> > > > driver should remap physical address to dma address.
> > > > 
> > > > Also this one trys to make dmar_disabled really present
> > > > current status of DMAR, which would be used for completely
> > > > express graphics dmar engine is active or not.
> > 
> > do you think this exporting will be needed?
> > If so why and when would someone use it?
> 
> This is used for our graphics driver module to know if we have to
> do dma remapping in iommu case, both in kernel config and kernel
> boot time param config. 

ok. How soon do you need this export?

> 
> The simplest case is that DMAR_GFX_WA is on, which no dma mapping
> will act in intel_agp.
> 
> If no DMAR_GFX_WA, we still have boot param to turn off whole intel
> iommu (intel_iommu=off), just turn off graphics remap engine
> (intel_iommu=igfx_off). So this exported interface is used to know
> that in runtime.
> 
> > 
> > > > 
> > > > Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
> > > > ---
> > > >  drivers/pci/intel-iommu.c |   18 ++++++++++++++++--
> > > >  include/linux/dmar.h      |    6 ++++++
> > > >  2 files changed, 22 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> > > > index e079a52..81a0abc 100644
> > > > --- a/drivers/pci/intel-iommu.c
> > > > +++ b/drivers/pci/intel-iommu.c
> > > > @@ -53,7 +53,7 @@
> > > >  static void domain_remove_dev_info(struct dmar_domain *domain);
> > > >  
> > > >  static int dmar_disabled;
> > > > -static int __initdata dmar_map_gfx = 1;
> > > > +static int dmar_map_gfx = 1;
> > > >  static int dmar_forcedac;
> > > >  
> > > >  #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
> > > > @@ -86,6 +86,16 @@ static int __init intel_iommu_setup(char *str)
> > > >  }
> > > >  __setup("intel_iommu=", intel_iommu_setup);
> > > >  
> > > > +int intel_iommu_gfx_remapping(void)
> > > > +{
> > > > +#ifndef CONFIG_DMAR_GFX_WA
> > > > +	if (!dmar_disabled && iommu_detected && dmar_map_gfx)
> > > > +		return 1;
> > > > +#endif
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(intel_iommu_gfx_remapping);
> > > > +
> > > >  static struct kmem_cache *iommu_domain_cache;
> > > >  static struct kmem_cache *iommu_devinfo_cache;
> > > >  static struct kmem_cache *iommu_iova_cache;
> > > > @@ -2189,8 +2199,12 @@ static void __init iommu_exit_mempool(void)
> > > >  
> > > >  void __init detect_intel_iommu(void)
> > > >  {
> > > > -	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
> > > > +	if (dmar_disabled)
> > > > +		return;
> > > > +	if (swiotlb || no_iommu || iommu_detected) {
> > > > +		dmar_disabled = 1;
> > > >  		return;
> > 
> > Why the bloat?  This block of 7 lines looks like it does the same as the
> > 2 you replaced.
> 
> No, dmar_disabled is not set in origin, which can't tell if it's turned
> off with (intel_iommu=off) later.
> 

oops, I missed that how about something like

if (swiotlb || no_iommu || iommu_detected || dmar_disabled) {
	dmar_disabled = 1;
	return;
}

I guess your way is ok too.

> > 
> > > > +	}
> > > >  	if (early_dmar_detect()) {
> > > >  		iommu_detected = 1;
> > > >  	}
> > > > diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> > > > index ffb6439..8ae435e 100644
> > > > --- a/include/linux/dmar.h
> > > > +++ b/include/linux/dmar.h
> > > > @@ -47,6 +47,8 @@ extern int intel_iommu_init(void);
> > > >  extern int dmar_table_init(void);
> > > >  extern int early_dmar_detect(void);
> > > >  
> > > > +extern int intel_iommu_gfx_remapping(void);
> > > > +
> > > >  extern struct list_head dmar_drhd_units;
> > > >  extern struct list_head dmar_rmrr_units;
> > > >  
> > > > @@ -81,6 +83,10 @@ static inline int intel_iommu_init(void)
> > > >  {
> > > >  	return -ENODEV;
> > > >  }
> > > > +static inline int intel_iommu_gfx_remapping(void)
> > > > +{
> > > > +	return 0;
> > > > +}
> > 
> > Um this function is silly lets not post it.
> > 
> > > >  
> > > >  #endif /* !CONFIG_DMAR */
> > > >  #endif /* __DMAR_H__ */
> > > > -- 
> > > > 1.5.3.4
> > > > 
> > > 
> > > Any comments to this one? Is it ok to push this iommu patch with
> > > agp dma remapping patches to next -mm?
> > > 
> > 
> > Its not ready for posting.

send me your current patch and eta for the graphics module patches so I
can better coordinate with you.

--mgross
