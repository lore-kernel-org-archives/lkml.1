Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYJCPe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYJCPe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYJCPeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:34:17 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:44605 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751941AbYJCPeQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:34:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Il8mYfw7E6FCbpVN9MeLQkWByoOZ5PqFq0mvmohqyPzMUrF96VOvAIEIHDsRLFpRsEmXcAI03n6cmW82kLKGWDIfZn7+A8w2LAjKcr89cycFeoLPY6/spOWS/h7EzAFa;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] pci-e: ignore unknown capability and continue searching
Date: Fri, 3 Oct 2008 08:34:08 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       czernecki@gmail.com, linux-pci@vger.kernel.org
References: <1222748945.3887.7.camel@ymzhang> <1223022104.16351.2.camel@ymzhang>
In-Reply-To: <1223022104.16351.2.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810030834.09088.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd rather get rid of this function altogether.  Can you check out my "use 
pci_find_ext_capability everywhere" patch and see if you can do something 
similar for the port driver?  I mainly just want to avoid having duplicated 
find_capability code everywhere...

Thanks,
Jesse

On Friday, October 3, 2008 1:21 am Zhang, Yanmin wrote:
> Greg, Jesse,
>
> Is there any issue with the patch? Tomasz need kernel to have the patch to
> work on his machine.
>
> Thanks,
> Yanmin
>
> On Tue, 2008-09-30 at 12:29 +0800, Zhang, Yanmin wrote:
> > ﻿Subject: pci-e: ignore unknown capability and continue searching
> > ﻿From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> >
> >
> > Tomasz reported AER driver couldn't work on his machine. With the output
> > of "lcpsi -vvv", I found the root port's extended capabilities are
> >          Capabilities: [100] Unknown (11)
> >          Capabilities: [150] Advanced Error Reporting
> >          Capabilities: [190] Unknown (13)
> > Such Unknown capability is not expected. During pci-e
> > initialization,function get_port_device_capability just returns if it
> > hits an unknown capability when searching the AER capability.
> >
> > I worked out a patch against 2.6.27-rc7. When hitting an unkown
> > capability, function get_port_device_capability continues the searching.
> >
> > Tomasz tested it and the patch does work well.
> >
> > Signed-off-by Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > Reported-by Tomasz Czernecki <czernecki@gmail.com>
> >
> > ---
> >
> > --- linux-2.6.27-rc7/drivers/pci/pcie/portdrv_core.c	2008-09-27
> > 09:35:32.000000000 +0800 +++
> > linux-2.6.27-rc7_aer/drivers/pci/pcie/portdrv_core.c	2008-09-27
> > 10:10:39.000000000 +0800 @@ -195,23 +195,25 @@ static int
> > get_port_device_capability(st
> >  	/* PME Capable - root port capability */
> >  	if (((reg16 >> 4) & PORT_TYPE_MASK) == PCIE_RC_PORT)
> >  		services |= PCIE_PORT_SERVICE_PME;
> > -
> > +
> >  	pos = PCI_CFG_SPACE_SIZE;
> >  	while (pos) {
> > -		pci_read_config_dword(dev, pos, &reg32);
> > -		switch (reg32 & 0xffff) {
> > +		if (pci_read_config_dword(dev, pos, &reg32))
> > +			break;
> > +
> > +		/* some broken boards return ~0 */
> > +		if (reg32 == 0xffffffff)
> > +			break;
> > +
> > +		switch (PCI_EXT_CAP_ID(reg32)) {
> >  		case PCI_EXT_CAP_ID_ERR:
> >  			services |= PCIE_PORT_SERVICE_AER;
> > -			pos = reg32 >> 20;
> >  			break;
> >  		case PCI_EXT_CAP_ID_VC:
> >  			services |= PCIE_PORT_SERVICE_VC;
> > -			pos = reg32 >> 20;
> > -			break;
> > -		default:
> > -			pos = 0;
> >  			break;
> >  		}
> > +		pos = PCI_EXT_CAP_NEXT(reg32);
> >  	}
> >
> >  	return services;
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/



-- 
Jesse Barnes, Intel Open Source Technology Center
