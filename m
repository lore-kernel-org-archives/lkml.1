Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbZCPVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbZCPVCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbZCPVCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:02:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60186 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbZCPVCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:02:05 -0400
Date: Mon, 16 Mar 2009 15:01:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 5/6] PCI MSI: Refactor interrupt masking code
Message-ID: <20090316210145.GN14127@parisc-linux.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-6-git-send-email-matthew@wil.cx> <1236039372.8230.106.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236039372.8230.106.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 11:16:12AM +1100, Michael Ellerman wrote:
> I don't see why msi_set_mask_bit() or msi_mask_irq() need to return
> anything, their return values are never used AFAICT.

You're right.  Changed to void.

> > @@ -356,21 +361,15 @@ static int msi_capability_init(struct pci_dev *dev)
> >  	entry->msi_attrib.is_64 = is_64bit_address(control);
> >  	entry->msi_attrib.entry_nr = 0;
> >  	entry->msi_attrib.maskbit = is_mask_bit_support(control);
> > -	entry->msi_attrib.masked = 1;
> >  	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
> >  	entry->msi_attrib.pos = pos;
> > -	if (entry->msi_attrib.maskbit) {
> > -		unsigned int base, maskbits, temp;
> > -
> > -		base = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
> > -		entry->mask_pos = base;
> > -		/* All MSIs are unmasked by default, Mask them all */
> > -		pci_read_config_dword(dev, base, &maskbits);
> > -		temp = msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);
> > -		maskbits |= temp;
> > -		pci_write_config_dword(dev, base, maskbits);
> > -		entry->msi_attrib.maskbits_mask = temp;
> > -	}
> > +
> > +	entry->mask_pos = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
> > +	/* All MSIs are unmasked by default, Mask them all */
> > +	pci_read_config_dword(dev, entry->mask_pos, &entry->masked);
> > +	mask = msi_capable_mask(control);
> > +	msi_mask_irq(entry, mask, mask);
> 
> This looked a little weird at first, in that we're unconditionally doing
> the mask - but we're not, msi_mask_irq() checks for us. I guess it's no
> drama reading from mask_pos even if it's not implemented.

Hm, wasn't quite my intent.  Here's the replacement:

        entry->mask_pos = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
        /* All MSIs are unmasked by default, Mask them all */
        if (entry->msi_attrib.maskbit)
                pci_read_config_dword(dev, entry->mask_pos, &entry->masked);
        mask = msi_capable_mask(control);
        msi_mask_irq(entry, mask, mask);

So mask_pos still points somewhere bogus, but all uses of it are now guarded by msi_attrib.maskbit, which is OK.

> > @@ -435,11 +434,12 @@ static int msix_capability_init(struct pci_dev *dev,
> >  		entry->msi_attrib.is_msix = 1;
> >  		entry->msi_attrib.is_64 = 1;
> >  		entry->msi_attrib.entry_nr = j;
> > -		entry->msi_attrib.maskbit = 1;
> > -		entry->msi_attrib.masked = 1;
> >  		entry->msi_attrib.default_irq = dev->irq;
> >  		entry->msi_attrib.pos = pos;
> >  		entry->mask_base = base;
> > +		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
> > +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> > +		msix_mask_irq(entry, 1);
> 
> I was going to say "why bother with the readl". But checking the spec,
> the rest of the bits are reserved and we mustn't muck with them.

Yeah, we've got away with that until now.  I just checked PCIe 2.1
(out today), and, er, it seems we can't rely on that any longer.
Something about a "TPH Requester Capability" and a "Steering Tag".
I'm looking forward to learning more about those in the next few months.

> > @@ -568,18 +570,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
> >  	dev->msi_enabled = 0;
> >  
> >  	BUG_ON(list_empty(&dev->msi_list));
> > -	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
> > -	/* Return the the pci reset with msi irqs unmasked */
> > -	if (entry->msi_attrib.maskbit) {
> > -		u32 mask = entry->msi_attrib.maskbits_mask;
> > -		struct irq_desc *desc = irq_to_desc(dev->irq);
> > -		msi_set_mask_bits(desc, mask, ~mask);
> > -	}
> > -	if (entry->msi_attrib.is_msix)
> > -		return;
> 
> You loose this return case, but we should never have hit it AFAICS
> because of the check of !dev->msi_enabled earlier - so I think it's ok.

Yeah, I deleted it on purpose.


Thanks for the review!

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
