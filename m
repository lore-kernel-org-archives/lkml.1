Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYI0M7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYI0M7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 08:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYI0M7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 08:59:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60948 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYI0M73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 08:59:29 -0400
Date: Sat, 27 Sep 2008 06:59:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 1/6 v3] PCI: export some functions and macros
Message-ID: <20080927125927.GL27204@parisc-linux.org>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F0@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F0@pdsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 04:27:44PM +0800, Zhao, Yu wrote:
> Export some functions and move some macros from c file to header file.

That's absolutely not everything this patch does.  You need to split
this into smaller pieces and explain what you're doing and why for each
of them.

> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index d807cd7..596efa6 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -1,3 +1,9 @@
> +#ifndef DRIVERS_PCI_H
> +#define DRIVERS_PCI_H

Do we really need header guards on this file?

> -/*
> - * If the type is not unknown, we assume that the lowest bit is 'enable'.
> - * Returns 1 if the BAR was 64-bit and 0 if it was 32-bit.
> +/**
> + * pci_read_base - read a PCI BAR
> + * @dev: the PCI device
> + * @type: type of the BAR
> + * @res: resource buffer to be filled in
> + * @pos: BAR position in the config space
> + *
> + * Returns 1 if the BAR is 64-bit, or 0 if 32-bit.
>   */
> -static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
> +int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,

The original intent here was to have a pci_read_base() that called
__pci_read_base() and then did things like translate physical BAR
addresses to virtual ones.  That patch is in the archives somewhere.
We ended up not including that patch because my user found out he could
get the address he wanted from elsewhere.  I'm not sure we want to
remove the __ at this point.

The eventual goal is to fix up the BARs at this point, but there's
several architectures that will break if we do this now.  It's on my
long-term todo list.

>                         struct resource *res, unsigned int pos)
>  {
>         u32 l, sz, mask;
> 
> -       mask = type ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
> +       mask = (type == pci_bar_rom) ? ~PCI_ROM_ADDRESS_ENABLE : ~0;

What's going on here?  Why are you adding pci_bar_rom?  For the rom we
use pci_bar_mem32.  Take a look at, for example, the MCHBAR in the 965
spec (313053.pdf).  That's something that uses the pci_bar_mem64 type
and definitely wants to use the PCI_ROM_ADDRESS_ENABLE mask.

> 
> -       if (type == pci_bar_unknown) {
> +       if (type == pci_bar_rom) {
> +               res->flags |= (l & IORESOURCE_ROM_ENABLE);
> +               l &= PCI_ROM_ADDRESS_MASK;
> +               mask = (u32)PCI_ROM_ADDRESS_MASK;
> +       } else {

This looks wrong too.

>         if (rom) {
> @@ -344,7 +340,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
>                 res->flags = IORESOURCE_MEM | IORESOURCE_PREFETCH |
>                                 IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
>                                 IORESOURCE_SIZEALIGN;
> -               __pci_read_base(dev, pci_bar_mem32, res, rom);
> +               pci_read_base(dev, pci_bar_mem32, res, rom);
>         }

And you don't even change the type here ... have you tested this code on
a system which has a ROM?

> 
> -       for(i=0; i<3; i++)
> -               child->resource[i] = &dev->resource[PCI_BRIDGE_RESOURCES+i];
> -

Er, this is rather important.  Why can you just delete it?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
