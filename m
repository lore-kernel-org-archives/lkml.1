Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYFZBSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYFZBSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYFZBS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:18:28 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40897 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756571AbYFZBS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:18:26 -0400
Subject: Re: [PATCH 2/2] acpi based pci gap caluculation v2
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Alok kataria <alokkataria1@gmail.com>, "lenb@kernel.org" <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1214442046.7055.9.camel@yakui_zhao.sh.intel.com>
References: <1214333326.27577.28.camel@promb-2n-dhcp368.eng.vmware.com>
	 <1214362159.9800.28.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242117p4a442982hb459a6b76312f391@mail.gmail.com>
	 <1214372365.9800.42.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242304q43987059xb203dd1ac75b7583@mail.gmail.com>
	 <1214383095.9800.85.camel@yakui_zhao.sh.intel.com>
	 <1214413073.27577.67.camel@promb-2n-dhcp368.eng.vmware.com>
	 <1214442046.7055.9.camel@yakui_zhao.sh.intel.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 25 Jun 2008 18:18:23 -0700
Message-Id: <1214443103.27577.120.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 18:00 -0700, Zhao Yakui wrote:
> On Wed, 2008-06-25 at 09:57 -0700, Alok Kataria wrote:
> > On Wed, 2008-06-25 at 01:38 -0700, Zhao Yakui wrote:
> > > On Tue, 2008-06-24 at 23:04 -0700, Alok kataria wrote:

> > > The pci_mem_start is still gotten by parsing the E820 table.But the
> > > input parameter start_addr will be used in the function of
> > > e820_search_gap.
> > >   If the following is the resource start address returned by the PCI0
> > > _CRS object , maybe the different pci_mem_start will be gotten.
> > >     0xE0000000
> > >     0xE4000000
> > >
> > >   At the same time if several start address is returned by the _CRS
> > > object, the e820 table will be parsed several times.
> >
> > Yes we will parse e820 several times, but we don't initialize
> > pci_mem_start in every pass.
> > It will be initialized only twice once via the e820_setup_gap code path
> > and once via pci_setup_gap.
> > And i think you agree that both of these are required ?
> Agree with what you said and IMO it is OK.
> >
> > During the gap calculation the previous code or the code now in
> > e820_setup_gap does this...
> >       calculates a gap in e820_map from 0 to 2^32.
> >       Initializes pci_mem_start.
> >
> > And now with this patch, the code in pci_setup_gap
> > does this...
> >       for each _CRS under PCI0
> >               search gap from start_addr of _CRS to 2^32 *[1].
> >       Initialize pci_mem_start with the biggest gap that we could
> >       find.
> Yes. But maybe the pci_mem_start obtained in pci_setup_gap will be
> different with that obtained in e820_setup_gap on some bogus BIOS.
> If the pci_mem_start obtained in pci_setup_gap can meet the requirement,
> it is also reasonable.

Ok, so the whole problem crops up from what if the BIOS itself is bogus.
Ok in that case too we take proper care that pci_mem_start is within the
expected limits, i.e. we make sure that 
1. pci_mem_start is not initialized to an already allocated resource
address and..
2. pci_mem_start is within the lower 32bit of address space. 

I assume you also agree that all the checks are in place. 
Also it would be great if you could ACK both the patches as well.

Thanks for the review.
Alok

> > Essentially, what we are doing is just limiting the gap calculation to a
> > smaller address space depending on the ACPI information we get.
> >
> > Now then, what problem do you see with this approach ?
> > *[1]
> > While writing this mail i figured out that, instead of searching from
> > start_addr of _CRS to 2^32 we should just search till *end_addr* of _CRS resource.
> > I will send a patch to that effect.
> If this, IMO it will be OK.
> > Thanks,
> > Alok
> >
> >
> > >
> > > Thanks.
> > >   Yakui
> > >
> > > > Thanks,
> > > > Alok
> > >
> >
> 

