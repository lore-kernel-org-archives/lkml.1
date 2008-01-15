Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYAOFGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYAOFGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 00:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYAOFGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 00:06:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:38666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbYAOFGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 00:06:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,285,1196668800"; 
   d="scan'208";a="324586886"
Subject: Re: [PATCH]PCIE ASPM support - takes 2
From: Shaohua Li <shaohua.li@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>, Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080115041943.GS18741@parisc-linux.org>
References: <1200367276.20538.1.camel@sli10-desk.sh.intel.com>
	 <20080115041943.GS18741@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 13:07:02 +0800
Message-Id: <1200373622.20869.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 21:19 -0700, Matthew Wilcox wrote:
> On Tue, Jan 15, 2008 at 11:21:16AM +0800, Shaohua Li wrote:
> > +	int same_clock = 0;
> > +
> > +	/* Check downstream component if bit Slot Clock Configuration is 1 */
> > +	child_pos = pci_find_capability(child_dev, PCI_CAP_ID_EXP);
> > +	pci_read_config_word(child_dev, child_pos + PCI_EXP_LNKSTA, &reg16);
> > +	if (reg16 & PCI_EXP_LNKSTA_SLC)
> > +		same_clock = 1;
> > +
> > +	/* Check upstream component if bit Slot Clock Configuration is 1 */
> > +	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
> > +	pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
> > +	if (reg16 & PCI_EXP_LNKSTA_SLC)
> > +		same_clock &= 1;
> > +	else
> > +		same_clock = 0;
> 
> This could be done a little neater ... the &= 1 idiom confused me on a
> quick scan.
> 
> How about:
> 
> 	int same_clock = 1;
> 
> 	child_pos = pci_find_capability(child_dev, PCI_CAP_ID_EXP);
> 	pci_read_config_word(child_dev, child_pos + PCI_EXP_LNKSTA, &reg16);
> 	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
> 		same_clock = 0;
> 
> 	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
> 	pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
> 	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
> 		same_clock = 0;
Thanks, for your time. ok, this is better.
> > +#ifdef CONFIG_PCIEASPM
> > +extern int pcie_aspm_init(void);
> > +#else
> > +#define pcie_aspm_init() do {} while (0)
> > +#endif
> 
> If pcie_aspm_init() returns a value, then callers may want to check it
> ... which they can't do for this null definition.  How about simply:
> 
> #define pcie_aspm_init() 0
ok
> 
> > Index: linux/drivers/pci/pci-acpi.c
> > ===================================================================
> > --- linux.orig/drivers/pci/pci-acpi.c	2008-01-15 10:16:35.000000000 +0800
> > +++ linux/drivers/pci/pci-acpi.c	2008-01-15 10:16:54.000000000 +0800
> > @@ -15,6 +15,7 @@
> >  #include <acpi/acnamesp.h>
> >  #include <acpi/acresrc.h>
> >  #include <acpi/acpi_bus.h>
> > +#include <linux/aspm.h>
> >  
> >  #include <linux/pci-acpi.h>
> >  #include "pci.h"
> > @@ -349,3 +350,11 @@ static int __init acpi_pci_init(void)
> >  	return 0;
> >  }
> >  arch_initcall(acpi_pci_init);
> > +
> > +/* Called after ACPI is enabled */
> > +static int __init acpi_pcie_support_init(void)
> > +{
> > +	pcie_aspm_init();
> > +	return 0;
> > +}
> > +fs_initcall(acpi_pcie_support_init);
> 
> Is there any reason to put this in here instead of just making
> pcie_aspm_init an initcall?
yes, this will evaluate some ACPI methods, so must be called after ACPI
is initialized, which is a sub_system call

Thanks,
Shaohua

