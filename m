Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZESJcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZESJcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZESJco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:32:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZESJcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:32:43 -0400
Date: Tue, 19 May 2009 11:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] Intel-IOMMU, intr-remap: source-id checking
Message-ID: <20090519093227.GF31404@elte.hu>
References: <1241676996-27406-1-git-send-email-weidong.han@intel.com> <1241676996-27406-2-git-send-email-weidong.han@intel.com> <1241720381.27006.8582.camel@localhost.localdomain> <715D42877B251141A38726ABF5CABF2C01A6DD4900@pdsmsx503.ccr.corp.intel.com> <20090511132027.GC32693@elte.hu> <715D42877B251141A38726ABF5CABF2C054568FA16@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715D42877B251141A38726ABF5CABF2C054568FA16@pdsmsx503.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Han, Weidong <weidong.han@intel.com> wrote:

> Ingo Molnar wrote:
> > * Han, Weidong <weidong.han@intel.com> wrote:
> > 
> >> Siddha, Suresh B wrote:
> >>> On Wed, 2009-05-06 at 23:16 -0700, Han, Weidong wrote:
> >>>> @@ -634,6 +694,44 @@ static int ir_parse_ioapic_scope(struct
> >>>>  			       acpi_dmar_header *header, " 0x%Lx\n",
> >>>>  			       scope->enumeration_id, drhd->address);
> >>>> 
> >>>> +			bus = pci_find_bus(drhd->segment, scope->bus);
> >>>> +			path = (struct acpi_dmar_pci_path *)(scope + 1); +			count =
> >>>> (scope->length - +				 sizeof(struct acpi_dmar_device_scope))
> >>>> +				/ sizeof(struct acpi_dmar_pci_path);
> >>>> +
> >>>> +			while (count) {
> >>>> +				if (pdev)
> >>>> +					pci_dev_put(pdev);
> >>>> +
> >>>> +				if (!bus)
> >>>> +					break;
> >>>> +
> >>>> +				pdev = pci_get_slot(bus,
> >>>> +					PCI_DEVFN(path->dev, path->fn));
> >>>> +				if (!pdev)
> >>>> +					break;
> >>> 
> >>> ir_parse_ioapic_scope() happens very early in the boot. So, I
> >>> don't think we can do the pci related discovery here.
> >>> 
> >> 
> >> Thanks for your pointing it out. It should enable the source-id
> >> checking for io-apic's after the pci subsystem is up. I will
> >> change it.
> > 
> > Note, there's ways to do early PCI quirks too, check
> > arch/x86/kernel/early-quirks.c. It's done by reading the PCI
> > configuration space directly via a careful early-capable subset of
> > the PCI config space APIs.
> > 
> > But it's a method of last resort.
> > 
> 
> Thanks for your reminder. It can use direct PCI access here as follows. It's easy and clean. I think it's better than adding the source-id checking for io-apic's after the pci subsystem is up. I will send out updated patches after some tests.
>  
> @@ -634,6 +695,24 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
>                                " 0x%Lx\n", scope->enumeration_id,
>                                drhd->address);
> 
> +                       bus = scope->bus;
> +                       path = (struct acpi_dmar_pci_path *)(scope + 1);
> +                       count = (scope->length -
> +                                sizeof(struct acpi_dmar_device_scope))
> +                               / sizeof(struct acpi_dmar_pci_path);
> +
> +                       while (--count > 0) {
> +                               /* Access PCI directly due to the PCI
> +                                * subsystem isn't initialized yet.
> +                                */
> +                               bus = read_pci_config_byte(bus, path->dev,
> +                                       path->fn, PCI_SECONDARY_BUS);
> +                               path++;
> +                       }
> +
> +                       ir_ioapic[ir_ioapic_num].bus = bus;
> +                       ir_ioapic[ir_ioapic_num].devfn =
> +                                       PCI_DEVFN(path->dev, path->fn);

looks good IMO, beyond the obligatory comment-style nitpick [*] :-) 
Also, the function above seems to be way too large - please split it 
into a couple of natural helper functions.

Thanks,

	Ingo

[*]

Please use the customary comment style:

  /*
   * Comment .....
   * ...... goes here:
   */

specified in Documentation/CodingStyle.



