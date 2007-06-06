Return-Path: <linux-kernel-owner+w=401wt.eu-S935835AbXFFV0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835AbXFFV0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935080AbXFFV0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:26:18 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:45909 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934493AbXFFV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:26:17 -0400
Date: Thu, 7 Jun 2007 00:26:09 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop x86 ->sysdata abuse; introduce pci_sysdata
Message-ID: <20070606212609.GS8541@rhun.ibm.com>
References: <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org> <20070604191346.GL4556@rhun.ibm.com> <20070604210551.GH20299@havoc.gtf.org> <20070605102905.GA3305@rhun.haifa.ibm.com> <20070606210329.GQ8541@rhun.ibm.com> <20070606212151.GA3304@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606212151.GA3304@havoc.gtf.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:21:51PM -0400, Jeff Garzik wrote:
> > Ok, patch fixed, works for me with Calgary. Andi, it looks like you
> > added the acpi.c NUMA bits originally, perhaps you could test and/or
> > ack them?
> 
> Just so there is no misunderstanding, I added the allocation bits.
> 
> No idea who added the direct usage of ->sysdata for NUMA info.

Andi Kleen did according to the git log. I'm trying to get access to a
NUMA system, but in the meantime perhaps Andi can just eyeball it and
ack.

> > diff -r 05804111dbee arch/i386/pci/common.c
> > --- a/arch/i386/pci/common.c	Tue Jun 05 11:34:51 2007 +0300
> > +++ b/arch/i386/pci/common.c	Wed Jun 06 22:36:53 2007 +0300
> > @@ -29,12 +29,14 @@ struct pci_raw_ops *raw_pci_ops;
> >  
> >  static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
> >  {
> > -	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
> > +	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
> > +				 devfn, where, size, value);
> >  }
> >  
> >  static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
> >  {
> > -	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
> > +	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
> > +				  devfn, where, size, value);
> >  }
> >  
> >  struct pci_ops pci_root_ops = {
> 
> Patch leakage?  I thought I had removed this portion, as being
> specific to PCI domains.

Nope, it was there in your original patch and I kept it since it's
obviously harmless (without CONFIG_PCI_DOMAINS pci_domain_nr() is
defined to 0).

> No objection, obviously, and it's obviously safe given that
> CONFIG_PCI_DOMAINS is not defined on x86/x86-64.
> 
> Nonetheless, it appears "off-topic" for NUMA/Calgary purposes.
> 
> ACK everything, but IMO the pci_domain_nr() bits should be in a
> separate patch.

Fair enough, I'll drop it out of this one.

Cheers,
Muli
