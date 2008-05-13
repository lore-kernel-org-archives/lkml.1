Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbYEMRsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbYEMRsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbYEMRsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:48:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:34973 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbYEMRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oGbjx5RoNyPb1Ef+97CyDb9L84T55VaZ7tGzGmCYf9VvwXGqZstE+48o+fZLKRAU0dQkx2HpmllGZRFd8dlP0ayek36KfY9pzoRpexVJRyVFGYnmqXszVBhwnU4+lZTV1fWnTjrI/3rRYF+IWy1n/8XtC1m5BTjx8vBtWTcUbmY=
Message-ID: <86802c440805131048r2f027809pe972a5e27321c2b0@mail.gmail.com>
Date: Tue, 13 May 2008 10:48:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gary Hade" <garyhade@us.ibm.com>
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20080512223005.GC7401@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080512205746.GB7401@us.ibm.com>
	 <86802c440805121443r43cc7ceay4c05625f2878172e@mail.gmail.com>
	 <20080512223005.GC7401@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 3:30 PM, Gary Hade <garyhade@us.ibm.com> wrote:
> On Mon, May 12, 2008 at 02:43:44PM -0700, Yinghai Lu wrote:
>  > On Mon, May 12, 2008 at 1:57 PM, Gary Hade <garyhade@us.ibm.com> wrote:
>         <snip>
>
> > >  --- linux-2.6.26-rc2/arch/x86/pci/common.c.orig 2008-05-12 10:59:58.000000000 -0700
>  > >  +++ linux-2.6.26-rc2/arch/x86/pci/common.c      2008-05-12 11:22:05.000000000 -0700
>  > >  @@ -121,6 +121,21 @@ void __init dmi_check_skip_isa_align(voi
>  > >         dmi_check_system(can_skip_pciprobe_dmi_table);
>  > >   }
>  > >
>  > >  +static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
>  > >  +{
>  > >  +       struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
>  > >  +
>  > >  +       if (pci_probe & PCI_NOASSIGN_ROMS) {
>  > >  +               if (rom_r->parent)
>  > >  +                       return;
>  > >  +               if (rom_r->start) {
>  > >  +                       /* we deal with BIOS assigned ROM later */
>  > >  +                       return;
>  > >  +               }
>  > >  +               rom_r->start = rom_r->end = rom_r->flags = 0;
>  > >  +       }
>  > >  +}
>  > >  +
>  > >   /*
>  > >   *  Called after each bus is probed, but before its children
>  > >   *  are examined.
>  > >  @@ -128,7 +143,11 @@ void __init dmi_check_skip_isa_align(voi
>  > >
>  > >   void __devinit  pcibios_fixup_bus(struct pci_bus *b)
>  > >   {
>  > >  +       struct pci_dev *dev;
>  > >  +
>  > >         pci_read_bridge_bases(b);
>  > >  +       list_for_each_entry(dev, &b->devices, bus_list)
>  > >  +               pcibios_fixup_device_resources(dev);
>  > >   }
>  >
>  > or put check
>  > +       if (pci_probe & PCI_NOASSIGN_ROMS) {
>  >
>  > out of loop?
>
>  I could certainly do that but I had intended that the new
>  pcibios_fixup_device_resources function act as a container where
>  other kinds of fixups could be added later.  Do you (or others)
>  think the additional cycles consumed by this approach are an
>  issue here?

ok, then wonder if we can don't assign roms for x86_64 by default.

can we use pci rom in 64 bit kernel?

YH
