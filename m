Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbXIIRvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbXIIRvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 13:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbXIIRvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 13:51:45 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:14857 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbXIIRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 13:51:43 -0400
Date: Sun, 9 Sep 2007 20:51:40 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: akpm@osdl.org, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070909175140.GG4357@rhun.haifa.ibm.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <20070909111619.GF31099@rhun.haifa.ibm.com> <20070910154358.GA24627@askeshav-devel.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910154358.GA24627@askeshav-devel.jf.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 08:43:59AM -0700, Keshavamurthy, Anil S wrote:
> On Sun, Sep 09, 2007 at 02:16:19PM +0300, Muli Ben-Yehuda wrote:
> > On Sat, Sep 08, 2007 at 01:05:24PM -0700, Keshavamurthy, Anil S wrote:
> > 
> > > Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash
> > 
> > This patch feels like a huge hack. See below.
>
> You seem to be jumping to conclusion without going in detail. The
> pci_dev struct contains pointer to sysdata, which in turn points to
> the copy of its parent's bus sysdata.  So technically speaking we
> can eliminate sysdata pointer from pci_dev struct which is what one
> portion of this patch does.

... provided nothing relies on this relationship or the existence of
the pci_dev's sysdata. Have you audited every architecture's use of
the sysdata pointers?

> > > This patch removes sysdata from pci_dev struct and creates a new
> > > field called sys_data which is exclusively used by IOMMU driver to
> > > keep its per device context pointer.
> > 
> > Hmpf, why is this needed? with the pci_sysdata work that recently went
> > into mainline we have a void *iommu member in pci_sysdata which should
> > be all that's needed. Please elaborate if it's not enough for your
> > needs.

> I looked at your patch and it was not suitable because I need to
> store iommu private pointer in pci_dev

Could you elaborate on why you need this? I'm assuming it's for the
per-device IOMMU page tables?

> and not in the pci_bus. So I have added a new member sys_data in the
> pci_dev struct. I can change the name from sys_dev to iomu_priv to
> clear the confusion. Do let me know.

Well, you should be able to just use the pci_dev's ->sysdata (that's
what it's there for after all!) but you might need to make it point to
a structure if it's shared, the same way we did with the bus's
->sysdata. I agree that just having it point to the bus's ->sysdata is
not very useful *but* there may be code in the kernel that relies on
it (Calgary did until very recently...) so it would have to be audited
first.

Cheers,
Muli

