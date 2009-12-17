Return-Path: <linux-kernel-owner+w=401wt.eu-S1764125AbZLQIdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764125AbZLQIdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764083AbZLQIdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:33:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:10724 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308AbZLQIdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:33:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,408,1257148800"; 
   d="scan'208";a="757031647"
Subject: Re: [PATH 1/5 -v2] acpi, IO memory pre-mapping and atomic accessing
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200912161054.19951.bjorn.helgaas@hp.com>
References: <1260429413.15264.393.camel@yhuang-dev.sh.intel.com>
	 <200912151047.14196.bjorn.helgaas@hp.com>
	 <1260926595.12561.1188.camel@yhuang-dev.sh.intel.com>
	 <200912161054.19951.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 16:33:07 +0800
Message-ID: <1261038787.13378.148.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 01:54 +0800, Bjorn Helgaas wrote: 
> On Tuesday 15 December 2009 06:23:15 pm Huang Ying wrote:
> > On Wed, 2009-12-16 at 01:47 +0800, Bjorn Helgaas wrote: 
> > > On Monday 14 December 2009 06:04:13 pm Huang Ying wrote:
> > > > On Sat, 2009-12-12 at 01:36 +0800, Bjorn Helgaas wrote: 
> > > > > I think your code would be simpler if acpi_pre_map_gar() returned a
> > > > > struct acpi_iomap pointer (from the caller's point of view, this would
> > > > > be an opaque cookie).  Then you could just supply that cookie to
> > > > > acpi_atomic_write(), and you wouldn't have to look it up again.  Maybe
> > > > > you could even get rid of the list and all the fancy RCU & kref stuff
> > > > > then, too.
> > > > 
> > > > The interface chosen is based on usage model, which is:
> > > > 
> > > > 1. In init function, all GARs needed are pre-mapped
> > > > 2. In atomic context, pre-mapped GARs are accessed
> > > > 3. In exit function, all GARs are post-unmapped
> > > > 
> > > > In 3), if struct acpi_iomap* is used as parameter for post-unmap
> > > > function, we need to record that pointer in another list. In 2), we need
> > > > find mapped address from GAR.
> > > 
> > > I understand that my proposal would require a slight change in your
> > > usage model.  I am suggesting that you make it follow the same pattern
> > > as pci_iomap(), e.g.:
> > > 
> > > 	void *pci_iomap(struct pci_dev *, int bar, unsigned long len);
> > > 	unsigned int ioread32(void *);
> > > 	void pci_iounmap(struct pci_dev *, void *);
> > > 
> > > 	void *acpi_map_generic_address(struct acpi_generic_address *);
> > > 	u64 acpi_read_atomic(void *);
> > > 	void acpi_unmap_generic_address(void *);
> > > 
> > > acpi_map_generic_address() would validate the GAR and do the ioremap().
> > > If the validation or ioremap() failed, it would return a NULL pointer.
> > > 
> > > This would require the caller of acpi_map_generic_address() to hang onto
> > > the pointer returned (just as callers of pci_iomap() must hang onto the
> > > pointer it returns).
> > > 
> > > The pointer would be supplied to acpi_read_atomic(), so it would not
> > > need to do acpi_check_gar() because we know it was done successfully
> > > in acpi_map_generic_address().  It wouldn't need to look up the GAR
> > > in the list because the list entry was passed in.  Since all the
> > > possible failure conditions were checked in acpi_map_generic_address(),
> > > acpi_read_atomic() doesn't need to return status and could simply
> > > return the u64 directly.
> > 
> > The usage model is different. Please take a look at
> > __apei_exec_read_register(). We need to get virtual address from
> > physical address in GAR. And many small-size GARs in ERST or EINJ may
> > share same page, so some kind of virtual space optimization is
> > necessary.
> 
> The sharing could be done with a reference count in the map/unmap
> path.
> 
> I don't have time to fully understand your patch series, but I suspect
> the issue is that you're interpreting opcodes, and those contain or
> reference generic_address structures, and you think it's easier just
> pass around the GAR pointer than it is to remember a (GAR, mapped-GAR)
> association made by pre_map_gar() and use the mapped-GAR when executing
> the "read" opcode.

So we need the (GAR, mapped-GAR) association anyway. Variable
acpi_iomaps in atomicio.c is such a association. When executing the
"read" opcode, we still need get mapped-GAR from the GAR. So I think
your proposal and my implementation is similar, with different naming
convention and you want to put the association in APEI code, and I want
to put it in ACPI code.

Best Regards,
Huang Ying


