Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZLPBXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZLPBXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbZLPBXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:23:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:37032 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534AbZLPBXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:23:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,402,1257148800"; 
   d="scan'208";a="476488161"
Subject: Re: [PATH 1/5 -v2] acpi, IO memory pre-mapping and atomic accessing
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200912151047.14196.bjorn.helgaas@hp.com>
References: <1260429413.15264.393.camel@yhuang-dev.sh.intel.com>
	 <200912111036.15063.bjorn.helgaas@hp.com>
	 <1260839053.12561.1098.camel@yhuang-dev.sh.intel.com>
	 <200912151047.14196.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 09:23:15 +0800
Message-ID: <1260926595.12561.1188.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 01:47 +0800, Bjorn Helgaas wrote: 
> On Monday 14 December 2009 06:04:13 pm Huang Ying wrote:
> > On Sat, 2009-12-12 at 01:36 +0800, Bjorn Helgaas wrote: 
> > > I think your code would be simpler if acpi_pre_map_gar() returned a
> > > struct acpi_iomap pointer (from the caller's point of view, this would
> > > be an opaque cookie).  Then you could just supply that cookie to
> > > acpi_atomic_write(), and you wouldn't have to look it up again.  Maybe
> > > you could even get rid of the list and all the fancy RCU & kref stuff
> > > then, too.
> > 
> > The interface chosen is based on usage model, which is:
> > 
> > 1. In init function, all GARs needed are pre-mapped
> > 2. In atomic context, pre-mapped GARs are accessed
> > 3. In exit function, all GARs are post-unmapped
> > 
> > In 3), if struct acpi_iomap* is used as parameter for post-unmap
> > function, we need to record that pointer in another list. In 2), we need
> > find mapped address from GAR.
> 
> I understand that my proposal would require a slight change in your
> usage model.  I am suggesting that you make it follow the same pattern
> as pci_iomap(), e.g.:
> 
> 	void *pci_iomap(struct pci_dev *, int bar, unsigned long len);
> 	unsigned int ioread32(void *);
> 	void pci_iounmap(struct pci_dev *, void *);
> 
> 	void *acpi_map_generic_address(struct acpi_generic_address *);
> 	u64 acpi_read_atomic(void *);
> 	void acpi_unmap_generic_address(void *);
> 
> acpi_map_generic_address() would validate the GAR and do the ioremap().
> If the validation or ioremap() failed, it would return a NULL pointer.
> 
> This would require the caller of acpi_map_generic_address() to hang onto
> the pointer returned (just as callers of pci_iomap() must hang onto the
> pointer it returns).
> 
> The pointer would be supplied to acpi_read_atomic(), so it would not
> need to do acpi_check_gar() because we know it was done successfully
> in acpi_map_generic_address().  It wouldn't need to look up the GAR
> in the list because the list entry was passed in.  Since all the
> possible failure conditions were checked in acpi_map_generic_address(),
> acpi_read_atomic() doesn't need to return status and could simply
> return the u64 directly.

The usage model is different. Please take a look at
__apei_exec_read_register(). We need to get virtual address from
physical address in GAR. And many small-size GARs in ERST or EINJ may
share same page, so some kind of virtual space optimization is
necessary.

> > > > +/* In NMI handler, should set silent = 1 */
> > > > +static int acpi_check_gar(struct acpi_generic_address *reg,
> > > > +			  u64 *paddr, int silent)
> > > > +{
> > > > +	u32 width;
> > > > +
> > > > +	/* Handle possible alignment issues */
> > > > +	memcpy(paddr, &reg->address, sizeof(*paddr));
> > > > +	if (!*paddr) {
> > > > +		if (!silent)
> > > > +			pr_info(
> > > > +			"Invalid physical address in GAR, firmware bug?\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	width = reg->bit_width;
> > > > +	if ((width != 8) && (width != 16) && (width != 32) && (width != 64)) {
> > > > +		if (!silent)
> > > > +			pr_info(
> > > > +			"Invalid bit width in GAR, firmware bug?\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY &&
> > > > +	    reg->space_id != ACPI_ADR_SPACE_SYSTEM_IO) {
> > > > +		if (!silent)
> > > > +			pr_info(
> > > > +			"Invalid address space type in GAR, firmware bug?\n");
> > > 
> > > Error messages with constant text are nearly useless because they
> > > don't give much of a clue about where to look for a problem.
> > > Personally, for something this, I would just return failure and
> > > never print anything.  If a map fails, the caller should notice
> > > and you then have a good idea of where to look.
> > 
> > The checking here is for bug in firmware not software. I think it is
> > necessary for the user to know where the bugs may come from, and it is
> > hard to express the bug in return code.
> 
> Yes, I understand that this is checking for firmware bugs.  My point
> is that when a user sees this in his dmesg log:
> 
> 	Invalid bit width in GAR, firmware bug?
> 
> we have no context, and even a kernel developer can't figure out what
> to do.  We could ask for a copy of the FADT and DSDT, but even then,
> we don't know *which* GAR structure to look at, so we'll probably have
> to add some instrumentation and ask the user to reproduce the problem.
> 
> If the check were in the caller, it could at least say something like:
> 
> 	ACPI: couldn't map generic address [io 0xcf8] for PCI config access
> 
> which would give us more useful information.

En... Yes, some information about the invalid GAR is helpful. But the
GAR information is available in acpi_check_gar too, so we can output
something as follow in acpi_check_gar:

    Invalid bit width in GAR [mem 0x8029ff8 24], firmware bug?

Your message looks like a software issue instead of firmware bug. This
may confuse the user and developer.

Best Regards,
Huang Ying


