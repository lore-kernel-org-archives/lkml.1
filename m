Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbYHELEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbYHELEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYHELAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:00:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44422 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYHELAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:00:10 -0400
Date: Tue, 5 Aug 2008 21:00:07 +1000
From: Simon Horman <horms@verge.net.au>
To: Sven Wegener <sven.wegener@stealer.net>,
       Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
Message-ID: <20080805110006.GA13409@verge.net.au>
References: <20080805101605.GA19382@verge.net.au> <1217932416.7758.4.camel@localhost> <20080805101605.GA19382@verge.net.au> <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217932416.7758.4.camel@localhost> <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 12:39:31PM +0200, Sven Wegener wrote:
> On Tue, 5 Aug 2008, Simon Horman wrote:
> 
> > Check the return value of device_create_bin_file in pci_create_bus,
> > unwind if neccessary, and propogate any errors to the caller.
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > --- 
> > 
> > drivers/pci/probe.c: In function `pci_create_bus':
> > drivers/pci/probe.c:66: warning: ignoring return value of `device_create_bin_file', declared with attribute warn_unused_result
> > drivers/pci/probe.c:74: warning: ignoring return value of `device_create_bin_file', declared with attribute warn_unused_result
> > 
> > # ia64-unknown-linux-gnu-gcc --version
> > ia64-unknown-linux-gnu-gcc (GCC) 3.4.5
> > Copyright (C) 2004 Free Software Foundation, Inc.
> > This is free software; see the source for copying conditions.  There is NO
> > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > 
> > Index: linux-2.6/drivers/pci/probe.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/probe.c	2008-08-05 19:58:43.000000000 +1000
> > +++ linux-2.6/drivers/pci/probe.c	2008-08-05 19:59:15.000000000 +1000
> > @@ -53,26 +53,37 @@ EXPORT_SYMBOL(no_pci_devices);
> >   * a per-bus basis.  This routine creates the files and ties them into
> >   * their associated read, write and mmap files from pci-sysfs.c
> >   */
> > -static void pci_create_legacy_files(struct pci_bus *b)
> > +static int pci_create_legacy_files(struct pci_bus *b)
> >  {
> > +	int error;
> > +
> >  	b->legacy_io = kzalloc(sizeof(struct bin_attribute) * 2,
> >  			       GFP_ATOMIC);
> > -	if (b->legacy_io) {
> > -		b->legacy_io->attr.name = "legacy_io";
> > -		b->legacy_io->size = 0xffff;
> > -		b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
> > -		b->legacy_io->read = pci_read_legacy_io;
> > -		b->legacy_io->write = pci_write_legacy_io;
> > -		device_create_bin_file(&b->dev, b->legacy_io);
> > -
> > -		/* Allocated above after the legacy_io struct */
> > -		b->legacy_mem = b->legacy_io + 1;
> > -		b->legacy_mem->attr.name = "legacy_mem";
> > -		b->legacy_mem->size = 1024*1024;
> > -		b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
> > -		b->legacy_mem->mmap = pci_mmap_legacy_mem;
> > -		device_create_bin_file(&b->dev, b->legacy_mem);
> > +	if (!b->legacy_io)
> > +		return -ENOMEM;
> > +
> > +	b->legacy_io->attr.name = "legacy_io";
> > +	b->legacy_io->size = 0xffff;
> > +	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
> > +	b->legacy_io->read = pci_read_legacy_io;
> > +	b->legacy_io->write = pci_write_legacy_io;
> > +	error = device_create_bin_file(&b->dev, b->legacy_io);
> > +	if (error)
> > +		return error;
> 
> I'd release the memory here and NULLify legacy_io.
> 
> > +
> > +	/* Allocated above after the legacy_io struct */
> > +	b->legacy_mem = b->legacy_io + 1;
> > +	b->legacy_mem->attr.name = "legacy_mem";
> > +	b->legacy_mem->size = 1024*1024;
> > +	b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
> > +	b->legacy_mem->mmap = pci_mmap_legacy_mem;
> > +	error = device_create_bin_file(&b->dev, b->legacy_mem);
> > +	if (error) {
> > +		device_remove_bin_file(&b->dev, b->legacy_io);
> > +		return error;
> 
> Here too.
> 
> Reason: If we fail to create the legacy_io file, legacy_mem will still be 
> NULL, because it has been not initialized at that point. But we will try 
> to remove it in pci_remove_legacy_files and in sysfs_remove_bin_file 
> we're going to derefence it and blow up.

Yes, sorry, my bad.



