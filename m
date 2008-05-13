Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYEMVLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYEMVLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbYEMVLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:11:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:58772 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYEMVLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lhAr4icVTHQ/CLNBCc9DUXto7a2n3sz4vaXlN40S7voCYhp7luu2DGQj+dtVOZlyUpDmOFrsOdYytR5u/P3udLcwHsDnsDrPQbYLQ/V1vsTTYQ0z27P3RHBFT6FymZfjewei9JkI/S11YR4KGaIfrkSMV95OeBqoE5q9f1Jrz78=
Message-ID: <86802c440805131411w1e0c661j93ba1a1854f314d6@mail.gmail.com>
Date: Tue, 13 May 2008 14:11:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gary Hade" <garyhade@us.ibm.com>
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20080513210054.GB28815@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080512205746.GB7401@us.ibm.com>
	 <86802c440805121443r43cc7ceay4c05625f2878172e@mail.gmail.com>
	 <20080512223005.GC7401@us.ibm.com>
	 <86802c440805131048r2f027809pe972a5e27321c2b0@mail.gmail.com>
	 <20080513210054.GB28815@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 2:00 PM, Gary Hade <garyhade@us.ibm.com> wrote:
>
> On Tue, May 13, 2008 at 10:48:03AM -0700, Yinghai Lu wrote:
>  > On Mon, May 12, 2008 at 3:30 PM, Gary Hade <garyhade@us.ibm.com> wrote:
>  > > On Mon, May 12, 2008 at 02:43:44PM -0700, Yinghai Lu wrote:
>  > >  > On Mon, May 12, 2008 at 1:57 PM, Gary Hade <garyhade@us.ibm.com> wrote:
>  > >         <snip>
>  > >
>  > > > >  --- linux-2.6.26-rc2/arch/x86/pci/common.c.orig 2008-05-12 10:59:58.000000000 -0700
>  > >  > >  +++ linux-2.6.26-rc2/arch/x86/pci/common.c      2008-05-12 11:22:05.000000000 -0700
>  > >  > >  @@ -121,6 +121,21 @@ void __init dmi_check_skip_isa_align(voi
>  > >  > >         dmi_check_system(can_skip_pciprobe_dmi_table);
>  > >  > >   }
>  > >  > >
>  > >  > >  +static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
>  > >  > >  +{
>  > >  > >  +       struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
>  > >  > >  +
>  > >  > >  +       if (pci_probe & PCI_NOASSIGN_ROMS) {
>  > >  > >  +               if (rom_r->parent)
>  > >  > >  +                       return;
>  > >  > >  +               if (rom_r->start) {
>  > >  > >  +                       /* we deal with BIOS assigned ROM later */
>  > >  > >  +                       return;
>  > >  > >  +               }
>  > >  > >  +               rom_r->start = rom_r->end = rom_r->flags = 0;
>  > >  > >  +       }
>  > >  > >  +}
>  > >  > >  +
>  > >  > >   /*
>  > >  > >   *  Called after each bus is probed, but before its children
>  > >  > >   *  are examined.
>  > >  > >  @@ -128,7 +143,11 @@ void __init dmi_check_skip_isa_align(voi
>  > >  > >
>  > >  > >   void __devinit  pcibios_fixup_bus(struct pci_bus *b)
>  > >  > >   {
>  > >  > >  +       struct pci_dev *dev;
>  > >  > >  +
>  > >  > >         pci_read_bridge_bases(b);
>  > >  > >  +       list_for_each_entry(dev, &b->devices, bus_list)
>  > >  > >  +               pcibios_fixup_device_resources(dev);
>  > >  > >   }
>  > >  >
>  > >  > or put check
>  > >  > +       if (pci_probe & PCI_NOASSIGN_ROMS) {
>  > >  >
>  > >  > out of loop?
>  > >
>  > >  I could certainly do that but I had intended that the new
>  > >  pcibios_fixup_device_resources function act as a container where
>  > >  other kinds of fixups could be added later.  Do you (or others)
>  > >  think the additional cycles consumed by this approach are an
>  > >  issue here?
>  >
>  > ok, then wonder if we can don't assign roms for x86_64 by default.
>
>  No, I don't think so.  ..at least not by me! :)
>
>  There were some lkml/linux-pci visible discussions back in
>  November-December of last year where I floated the idea
>  of making PCI expansion ROM memory non-assignment the default:
>   http://marc.info/?l=linux-kernel&m=119742188215024&w=2
>   http://marc.info/?l=linux-kernel&m=119689499508369&w=2
>  I did not hear any objections so I went ahead and submitted
>  the change which entered mainline at 2.6.25-rc1 but it was
>  sternly evicted last week because of a reported regression
>  that it had caused:
>   http://marc.info/?l=linux-kernel&m=121029093331908&w=2
>  Attachments to http://bugs.freedesktop.org/show_bug.cgi?id=15523
>  indicate that a 2.6.25-rc2 x86_64 kernel was being used.
>
>
>  >
>  > can we use pci rom in 64 bit kernel?
>
>  Sorry, not sure if I understand this question.  I hope the
>  above answers it.

ok, i think the driver could reload fw in the option rom to reset the
controlller in pci card.
i don't think there is other usage for the option rom after OS loaded,
except option rom contain other run-time code...

so could disable them all, and use pci-quirks to enable that for the
device/driver need it.

YH
