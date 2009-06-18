Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZFRVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZFRVE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZFRVEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:04:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:33291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZFRVET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:04:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,246,1243839600"; 
   d="scan'208";a="467666351"
Date: Thu, 18 Jun 2009 14:04:18 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Matthew Wilcox <matthew@wil.cx>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       a.beregalov@gmail.com, lenb@kernel.org
Subject: Re: linux-next: Tree for June 17 (pci/slot)
Message-ID: <20090618140418.2e078701@jbarnes-g45>
In-Reply-To: <20090618010357.GC29472@ldl.fc.hp.com>
References: <20090617155354.075c60ae.sfr@canb.auug.org.au>
	<4A39194B.2060200@oracle.com>
	<20090617163604.GT19977@parisc-linux.org>
	<20090617102901.6e39aac2@jbarnes-g45>
	<4A392B48.7060206@oracle.com>
	<20090617161001.734321be@jbarnes-g45>
	<20090618003808.GA29472@ldl.fc.hp.com>
	<20090618004612.GB29472@ldl.fc.hp.com>
	<20090618010357.GC29472@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 19:03:57 -0600
Alex Chiang <achiang@hp.com> wrote:

> * Alex Chiang <achiang@hp.com>:
> > diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> > index ba6af16..0be4efd 100644
> > --- a/drivers/pci/Makefile
> > +++ b/drivers/pci/Makefile
> > @@ -2,10 +2,11 @@
> >  # Makefile for the PCI bus specific drivers.
> >  #
> >  
> > -obj-y		+= access.o bus.o probe.o remove.o pci.o
> > quirks.o slot.o \
> > -			pci-driver.o search.o pci-sysfs.o rom.o
> > setup-res.o \ +obj-y		+= access.o bus.o probe.o
> > remove.o pci.o quirks.o \
> > +			pci-driver.o search.o rom.o setup-res.o \
> >  			irq.o
> >  obj-$(CONFIG_PROC_FS) += proc.o
> > +obj-$(CONFIG_SYSFS) += slot.o pci-sysfs.o
> 
> Sigh, this won't work because the PCI core blithely assumes we have
> sysfs:
> 
> drivers/built-in.o: In function `pci_bus_add_device':
> /kio/work/achiang/kernels/linux-2.6/drivers/pci/bus.c:89: undefined
> reference to `pci_create_sysfs_dev_files' drivers/built-in.o: In
> function
> `pci_stop_dev': /kio/work/achiang/kernels/linux-2.6/drivers/pci/remove.c:24:
> undefined reference to `pci_remove_sysfs_dev_files'
> 
> So, here is v3 that actually does build with !CONFIG_SYSFS. It
> touches a bit more now, but I believe it is still appropriate
> because neither pci_slot.ko nor any of the drivers in
> drivers/pci/hotplug/ are useful without sysfs.
> 
> From: Alex Chiang <achiang@hp.com>
> 
> PCI: drivers/pci/slot.c should depend on CONFIG_SYSFS
> 
> There is no way to interact with a physical PCI slot without
> sysfs, so encode the dependency and prevent this build error:
> 
> 	drivers/pci/slot.c: In function 'pci_hp_create_module_link':
> 	drivers/pci/slot.c:327: error: 'module_kset' undeclared
> 
> This patch _should_ make pci-sysfs.o depend on CONFIG_SYSFS too,
> but we cannot (yet) because the PCI core merrily assumes the
> existence of sysfs:
> 
> 	drivers/built-in.o: In function `pci_bus_add_device':
> 	drivers/pci/bus.c:89: undefined reference to
> `pci_create_sysfs_dev_files' drivers/built-in.o: In function
> `pci_stop_dev': drivers/pci/remove.c:24: undefined reference to
> `pci_remove_sysfs_dev_files'
> 
> So do the minimal bit for now and figure out how to untangle it
> later.

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
