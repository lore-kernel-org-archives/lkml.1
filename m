Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbXIJRak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbXIJRak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXIJRac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:30:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:8608 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbXIJRab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,232,1186383600"; 
   d="scan'208";a="291940289"
Date: Tue, 11 Sep 2007 10:42:31 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Paul Mackerras <paulus@samba.org>, muli@il.ibm.com
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, akpm@osdl.org,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070911174231.GC24627@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18148.12140.21118.252581@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 03:37:48AM +1000, Paul Mackerras wrote:
> Keshavamurthy, Anil S writes:
> 
> > Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash
> > 
> > Populating pci_bus->sysdata way early in the pci discovery phase
> > sets NON-NULL value to pci_dev->sysdata which breaks the assumption
> > in the Intel IOMMU driver and crashes the system.
> > 
> > 
> > In the drivers/pci/probe.c, pci_dev->sysdata gets a copy of
> > its pci_bus->sysdata which is not required as
> > the same can be obtained from pci_dev->bus->sysdata. More over 
> > the left hand assignment of pci_dev->sysdata is never being used,
> 
> Wrong.  You needed to grep a bit more widely...
Ah..Thanks for pointing this out. sorry I had checked only i386 and x86_64.
> 
> > so their is no point is setting 
> > pci_dev->sysdata = pci_bus->sysdata;
> > 
> > This patch removes sysdata from pci_dev struct and creates a new
> > field called sys_data which is exclusively used 
> > by IOMMU driver to keep its per device context pointer.
> 
> This will break powerpc, because we use the pci_dev->sysdata field to
> point to a firmware device tree node.  Please figure out another way
> to solve your problem.

Yes, I agree that pci_dev->sysdata can;t be removed. Even we (IOMMU)
were dependent on this field but somehow this field is being overwritten
to point to pci_bus's->sysdata and hence IOMMU was failing. Earlier
it was overwritten to NULL and hence we were not failing but now it
is overwritten to non-NULL and hence we fail.

My therory is that we don;t need to copy pci_bus's->sysdata to 
pci_dev's->sysdata. Below patch solves my problem.
Any objection to below patch?

---
 drivers/pci/hotplug/fakephp.c |    1 -
 drivers/pci/probe.c           |    1 -
 2 files changed, 2 deletions(-)

Index: work/drivers/pci/hotplug/fakephp.c
===================================================================
--- work.orig/drivers/pci/hotplug/fakephp.c	2007-09-11 10:29:30.000000000 -0700
+++ work/drivers/pci/hotplug/fakephp.c	2007-09-11 10:35:22.000000000 -0700
@@ -243,7 +243,6 @@
 		return;
 
 	dev->bus = (struct pci_bus*)bus;
-	dev->sysdata = bus->sysdata;
 	for (devfn = 0; devfn < 0x100; devfn += 8) {
 		dev->devfn = devfn;
 		pci_rescan_slot(dev);
Index: work/drivers/pci/probe.c
===================================================================
--- work.orig/drivers/pci/probe.c	2007-09-11 10:29:30.000000000 -0700
+++ work/drivers/pci/probe.c	2007-09-11 10:35:22.000000000 -0700
@@ -994,7 +994,6 @@
 		return NULL;
 
 	dev->bus = bus;
-	dev->sysdata = bus->sysdata;
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
 	dev->devfn = devfn;



