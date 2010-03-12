Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0CLH7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:59:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:1957 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab0CLH7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:59:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,625,1262592000"; 
   d="scan'208";a="603696922"
Subject: Re: [PATCH -v2 2/2] ACPI, APEI, PCIE AER, use general HEST table
 parsing in AER firmware_first setup
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <4B99B845.70600@jp.fujitsu.com>
References: <1268273698-21940-1-git-send-email-ying.huang@intel.com>
	 <1268273698-21940-2-git-send-email-ying.huang@intel.com>
	 <1268273698-21940-3-git-send-email-ying.huang@intel.com>
	 <4B99B845.70600@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 15:59:40 +0800
Message-ID: <1268380780.1640.510.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 11:43 +0800, Hidetoshi Seto wrote:
> (2010/03/11 11:14), Huang Ying wrote:
> > -EXPORT_SYMBOL_GPL(acpi_hest_firmware_first_pci);
> > --- a/drivers/pci/pcie/aer/aerdrv.h
> > +++ b/drivers/pci/pcie/aer/aerdrv.h
> > @@ -134,4 +134,13 @@ static inline int aer_osc_setup(struct p
> >  }
> >  #endif
> >  
> > +#ifdef CONFIG_ACPI_APEI
> > +extern void aer_set_firmware_first(struct pci_dev *pci_dev);
> > +#else
> > +static inline void aer_set_firmware_first(struct pci_dev *pci_dev)
> > +{
> > +	pci_dev->__aer_firmware_first_valid = 1;
> > +}
> > +#endif
> > +
> >  #endif /* _AERDRV_H_ */
> 
> How about having aer_get_firmware_first() in this header too?
> 
> > --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
>  :
> > +#ifdef CONFIG_ACPI_APEI
>  :
> > +void aer_set_firmware_first(struct pci_dev *pci_dev)
> > +{
>  :
> > +}
> > +#endif
> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> > @@ -30,12 +30,19 @@ static int nosourceid;
> >  module_param(forceload, bool, 0);
> >  module_param(nosourceid, bool, 0);
> >  
> > +static int pcie_aer_get_firmware_first(struct pci_dev *dev)
> > +{
> > +	if (!dev->__aer_firmware_first_valid)
> > +		aer_set_firmware_first(dev);
> > +	return dev->__aer_firmware_first;
> > +}
> > +
> 
> Then you can put pcie_aer_get_firmware_first() to next to
> pcie_aer_set_firmware_first() in aerdrv_acpi.c, which is
> the best file for these functions I think.
> 
> > @@ -872,7 +879,7 @@ out:
> >  	if (forceload) {
> >  		dev_printk(KERN_DEBUG, &dev->device,
> >  			   "aerdrv forceload requested.\n");
> > -		dev->port->aer_firmware_first = 0;
> > +		dev->port->__aer_firmware_first = 0;
> >  		return 0;
> >  	}
> >  	return -ENXIO;
> 
> I'd like to see a purpose-oriented method here, something like
> pcie_aer_force_firmware_first_to(dev, forcedvalue).
> 
> Or, it would be more better, change pcie_aer_set_firmware_first()
> (= currently used by APEI only) to static with better name.
> 
> E.g. 
>   Before:		After:
> 
>   # get a flag that tells @dev is firmware first or not
>     pcie_aer_get_firmware_first(dev)
> 			=> pcie_aer_get_firmware_first(dev) # no change
> 
>   # set a flag that tells @dev is firmware first or not
>     dev->port->__aer_firmware_first = X
> 			=> pcie_aer_set_firmware_first(dev, X)
> 
>   # parse hest to know @dev is firmware first or not
>     pcie_aer_set_firmware_first(dev)
> 			=> aer_parse_hest_for(dev)

Sounds reasonable. After putting current pcie_aer_set_firmware_first
implementation into aerdrv_core.c, we can make it static. And we can add
pcie_aer_force_firmware_first for forced setting.

> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -311,7 +311,8 @@ struct pci_dev {
> >  	unsigned int	is_virtfn:1;
> >  	unsigned int	reset_fn:1;
> >  	unsigned int    is_hotplug_bridge:1;
> > -	unsigned int    aer_firmware_first:1;
> > +	unsigned int    __aer_firmware_first_valid:1;
> > +	unsigned int	__aer_firmware_first:1;
> >  	pci_dev_flags_t dev_flags;
> >  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
> 
> BTW, what the prefix "__" for?

I want to warn users that this is a internal interface, don't use it
directly.

> I recommend you to separate this 2/2 patch into 2 pieces,
> one for PCI addressed to Jesse, and another is for ACPI.
> i.e.:
> 
>  [PATCH] PCIE, AER: arrange pcie_aer_{get,set}_firmware_first
>  [PATCH 1/2] ACPI, APEI: Make APEI core configurable built-in
>  [PATCH 2/2] ACPI, APEI: use general HEST table parsing in AER
> 
> You can make 3rd patch to contain only *acpi* changes, remove of
> acpi/hest.c and modify of pcie/aer/aerdrv_acpi.c.
> Then it will be easy-to-pull for Len, right?

Cross maintainers merging is painful after all. Even I split the patches
as you proposed, I may need to wait another 2 merge windows to merge the
code. To make it goes more smoothly, I suggest to merge all the code in
Len's tree after getting ack from Jesse.

Hi, Len and Jesse, how about my suggestion?

Best Regards,
Huang Ying


