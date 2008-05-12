Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYELWaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYELWaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbYELWaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:30:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33234 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYELWaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:30:07 -0400
Date: Mon, 12 May 2008 15:30:05 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Gary Hade <garyhade@us.ibm.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Message-ID: <20080512223005.GC7401@us.ibm.com>
References: <20080512205746.GB7401@us.ibm.com> <86802c440805121443r43cc7ceay4c05625f2878172e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805121443r43cc7ceay4c05625f2878172e@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 02:43:44PM -0700, Yinghai Lu wrote:
> On Mon, May 12, 2008 at 1:57 PM, Gary Hade <garyhade@us.ibm.com> wrote:
	<snip>
> >  --- linux-2.6.26-rc2/arch/x86/pci/common.c.orig 2008-05-12 10:59:58.000000000 -0700
> >  +++ linux-2.6.26-rc2/arch/x86/pci/common.c      2008-05-12 11:22:05.000000000 -0700
> >  @@ -121,6 +121,21 @@ void __init dmi_check_skip_isa_align(voi
> >         dmi_check_system(can_skip_pciprobe_dmi_table);
> >   }
> >
> >  +static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
> >  +{
> >  +       struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
> >  +
> >  +       if (pci_probe & PCI_NOASSIGN_ROMS) {
> >  +               if (rom_r->parent)
> >  +                       return;
> >  +               if (rom_r->start) {
> >  +                       /* we deal with BIOS assigned ROM later */
> >  +                       return;
> >  +               }
> >  +               rom_r->start = rom_r->end = rom_r->flags = 0;
> >  +       }
> >  +}
> >  +
> >   /*
> >   *  Called after each bus is probed, but before its children
> >   *  are examined.
> >  @@ -128,7 +143,11 @@ void __init dmi_check_skip_isa_align(voi
> >
> >   void __devinit  pcibios_fixup_bus(struct pci_bus *b)
> >   {
> >  +       struct pci_dev *dev;
> >  +
> >         pci_read_bridge_bases(b);
> >  +       list_for_each_entry(dev, &b->devices, bus_list)
> >  +               pcibios_fixup_device_resources(dev);
> >   }
> 
> or put check
> +       if (pci_probe & PCI_NOASSIGN_ROMS) {
> 
> out of loop?

I could certainly do that but I had intended that the new
pcibios_fixup_device_resources function act as a container where
other kinds of fixups could be added later.  Do you (or others)
think the additional cycles consumed by this approach are an
issue here?

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

