Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbXIJRK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbXIJRK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbXIJRKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:10:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:23618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072AbXIJRKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:10:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,232,1186383600"; 
   d="scan'208";a="291929528"
Date: Tue, 11 Sep 2007 10:22:57 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, akpm@osdl.org,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070911172257.GB24627@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <20070909111619.GF31099@rhun.haifa.ibm.com> <20070910154358.GA24627@askeshav-devel.jf.intel.com> <20070909175140.GG4357@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909175140.GG4357@rhun.haifa.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 08:51:40PM +0300, Muli Ben-Yehuda wrote:
> On Mon, Sep 10, 2007 at 08:43:59AM -0700, Keshavamurthy, Anil S wrote:
> > On Sun, Sep 09, 2007 at 02:16:19PM +0300, Muli Ben-Yehuda wrote:
> > > On Sat, Sep 08, 2007 at 01:05:24PM -0700, Keshavamurthy, Anil S wrote:
> > > 
> > > > Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash
> > > 
> > > This patch feels like a huge hack. See below.
> >
> > You seem to be jumping to conclusion without going in detail. The
> > pci_dev struct contains pointer to sysdata, which in turn points to
> > the copy of its parent's bus sysdata.  So technically speaking we
> > can eliminate sysdata pointer from pci_dev struct which is what one
> > portion of this patch does.
> 
> ... provided nothing relies on this relationship or the existence of
> the pci_dev's sysdata. Have you audited every architecture's use of
> the sysdata pointers?
> 
> > > > This patch removes sysdata from pci_dev struct and creates a new
> > > > field called sys_data which is exclusively used by IOMMU driver to
> > > > keep its per device context pointer.
> > > 
> > > Hmpf, why is this needed? with the pci_sysdata work that recently went
> > > into mainline we have a void *iommu member in pci_sysdata which should
> > > be all that's needed. Please elaborate if it's not enough for your
> > > needs.
> 
> > I looked at your patch and it was not suitable because I need to
> > store iommu private pointer in pci_dev
> 
> Could you elaborate on why you need this? I'm assuming it's for the
> per-device IOMMU page tables?
Yes, it is for per-device IOMMU domain information which internally holds
info about the page tables.
> 
> > and not in the pci_bus. So I have added a new member sys_data in the
> > pci_dev struct. I can change the name from sys_dev to iomu_priv to
> > clear the confusion. Do let me know.
> 
> Well, you should be able to just use the pci_dev's ->sysdata (that's
> what it's there for after all!) but you might need to make it point to
> a structure if it's shared, the same way we did with the bus's
> ->sysdata. 
How about adding a new field as I don't care about KABI for mainline?

>I agree that just having it point to the bus's ->sysdata is
> not very useful *but* there may be code in the kernel that relies on
> it (Calgary did until very recently...) so it would have to be audited
> first.
I still wonder copying bus's->sysdata to pci_dev's-> sysdata is any useful?

-Anil
