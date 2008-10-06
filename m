Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYJFCIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYJFCIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 22:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYJFCIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 22:08:09 -0400
Received: from mga06.intel.com ([134.134.136.21]:49188 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbYJFCII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 22:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,365,1220252400"; 
   d="scan'208";a="344271377"
Subject: Re: [PATCH] pci-e: ignore unknown capability and continue searching
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       czernecki@gmail.com, linux-pci@vger.kernel.org
In-Reply-To: <200810030834.09088.jbarnes@virtuousgeek.org>
References: <1222748945.3887.7.camel@ymzhang>
	 <1223022104.16351.2.camel@ymzhang>
	 <200810030834.09088.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Oct 2008 10:02:37 +0800
Message-Id: <1223258557.1685.5.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-10-03 at 08:34 -0700, Jesse Barnes wrote:
> I'd rather get rid of this function altogether.  Can you check out my "use 
> pci_find_ext_capability everywhere" patch and see if you can do something 
> similar for the port driver?
Jesse,

I did a quick check. If applying the patches from you and Matthew, port driver
has no its own version of find capability.

Yanmin 

>   I mainly just want to avoid having duplicated 
> find_capability code everywhere...
> 
> Thanks,
> Jesse
> 
> On Friday, October 3, 2008 1:21 am Zhang, Yanmin wrote:
> > Greg, Jesse,
> >
> > Is there any issue with the patch? Tomasz need kernel to have the patch to
> > work on his machine.
> >
> > Thanks,
> > Yanmin
> >
> > On Tue, 2008-09-30 at 12:29 +0800, Zhang, Yanmin wrote:
> > > ﻿Subject: pci-e: ignore unknown capability and continue searching
> > > ﻿From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> > >
> > >
> > > Tomasz reported AER driver couldn't work on his machine. With the output
> > > of "lcpsi -vvv", I found the root port's extended capabilities are
> > >          Capabilities: [100] Unknown (11)
> > >          Capabilities: [150] Advanced Error Reporting
> > >          Capabilities: [190] Unknown (13)
> > > Such Unknown capability is not expected. During pci-e
> > > initialization,function get_port_device_capability just returns if it
> > > hits an unknown capability when searching the AER capability.
> > >
> > > I worked out a patch against 2.6.27-rc7. When hitting an unkown
> > > capability, function get_port_device_capability continues the searching.
> > >
> > > Tomasz tested it and the patch does work well.
> > >
> > > Signed-off-by Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > > Reported-by Tomasz Czernecki <czernecki@gmail.com>
> > >
> > > ---
> > >
> > > --- linux-2.6.27-rc7/drivers/pci/pcie/portdrv_core.c	2008-09-27
> > > 09:35:32.000000000 +0800 +++
> > > linux-2.6.27-rc7_aer/drivers/pci/pcie/portdrv_core.c	2008-09-27
> > > 10:10:39.000000000 +0800 @@ -195,23 +195,25 @@ static int
> > > get_port_device_capability(st
> > >  	/* PME Capable - root port capability */
> > >  	if (((reg16 >> 4) & PORT_TYPE_MASK) == PCIE_RC_PORT)
> > >  		services |= PCIE_PORT_SERVICE_PME;
> > > -
> > > +
> > >  	pos = PCI_CFG_SPACE_SIZE;
> > >  	while (pos) {
> > > -		pci_read_config_dword(dev, pos, &reg32);
> > > -		switch (reg32 & 0xffff) {
> > > +		if (pci_read_config_dword(dev, pos, &reg32))
> > > +			break;
> > > +
> > > +		/* some broken boards return ~0 */
> > > +		if (reg32 == 0xffffffff)
> > > +			break;
> > > +
> > > +		switch (PCI_EXT_CAP_ID(reg32)) {
> > >  		case PCI_EXT_CAP_ID_ERR:
> > >  			services |= PCIE_PORT_SERVICE_AER;
> > > -			pos = reg32 >> 20;
> > >  			break;
> > >  		case PCI_EXT_CAP_ID_VC:
> > >  			services |= PCIE_PORT_SERVICE_VC;
> > > -			pos = reg32 >> 20;
> > > -			break;
> > > -		default:
> > > -			pos = 0;
> > >  			break;
> > >  		}
> > > +		pos = PCI_EXT_CAP_NEXT(reg32);
> > >  	}
> > >
> > >  	return services;
> > >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

