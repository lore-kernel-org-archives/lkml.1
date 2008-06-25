Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbYFYQ6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbYFYQ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYFYQ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:58:31 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41814 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbYFYQ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:58:29 -0400
Subject: Re: [PATCH 2/2] acpi based pci gap caluculation v2
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Alok kataria <alokkataria1@gmail.com>, "lenb@kernel.org" <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1214383095.9800.85.camel@yakui_zhao.sh.intel.com>
References: <1214333326.27577.28.camel@promb-2n-dhcp368.eng.vmware.com>
	 <1214362159.9800.28.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242117p4a442982hb459a6b76312f391@mail.gmail.com>
	 <1214372365.9800.42.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242304q43987059xb203dd1ac75b7583@mail.gmail.com>
	 <1214383095.9800.85.camel@yakui_zhao.sh.intel.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 25 Jun 2008 09:57:53 -0700
Message-Id: <1214413073.27577.67.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 01:38 -0700, Zhao Yakui wrote:
> On Tue, 2008-06-24 at 23:04 -0700, Alok kataria wrote:
> > Hi Yakui,
> >
> > On Tue, Jun 24, 2008 at 10:39 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> > > On Tue, 2008-06-24 at 21:17 -0700, Alok kataria wrote:
> > >> On Tue, Jun 24, 2008 at 7:49 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> > >> > On Tue, 2008-06-24 at 11:48 -0700, Alok Kataria wrote:
> > >> >> Evaluates the _CRS object under PCI0 looking for producer resources.
> > >> >> Then searches the e820 memory space for a gap within these producer resources.
> > >> >>
> > >> >> Allows us to find a gap for the unclaimed pci resources or MMIO resources
> > >> >> for hotplug devices within the BIOS allowed pci regions.
> > >> >>
> > >> > It seems reasonable.
> > >> > But if the resource obtained from the PCI0 _CRS method is incorrect, we
> > >> > will get the incorrect pci_mem_start.
> > >>
> > >> Hi Yakui,
> > >>
> > >> What do you mean by the PCI0 _CRS being incorrect ? Why would the BIOS
> > >> give a incorrect _CRS object ?
> > >> Also we don't just take the value given from the _CRS method, we still
> > >> read the e820_map to search for an unallocated resource. So even if
> > >> (by chance) the _CRS method returns incorrect value we would still
> > >> figure out if there is a collision with an already allocated resource.
> > > In the patch the address obtained from the _CRS object will be passed
> > > into the function of e820_search_gap. In such case maybe we will get the
> > > pci_mem_start different with the e820_setup_gap.
> >
> > True..the whole idea behind doing this patch was to get a correct
> > (different) value for pci_mem_start.
> > We read the _CRS object over here to make sure that we assign the
> > pci_mem_start from the address range which is reserved by the BIOS for
> > PCI devices.
> >
> > Also this reading of _CRS object would be done before we start
> > initializing the pci devices, i.e. before we start using the value of
> > pci_mem_start, so the original value assigned by pci_setup_gap is just
> > overwritten by this function. So that should be fine IMHO.
> > Also we would still want the call for e820_setup_gap because there can
> > be systems with no acpi support or acpi disabled
> >
> >
> > >
> > >> >
> > >> > At the same time after the patch is applied, pci_mem_start will be
> > >> > parsed in two different ways.
> > >>
> > >> Yes pci_mem_start would be initialized in 2 different ways but we
> > >> still have to parse the e820_map the old way because there could be
> > >> systems without ACPI.
> > >>
> > >> > If the result is different, maybe the
> > >> > incorrect pci_mem_start will be used.
> > >>
> > >> Yeah, The result is different in my case. Though my BIOS reserves
> > >> hotpluggable memory region, kernel doesn't respect that right now and
> > >> just parses the e820_map to calculate the gap and pci_mem_start value.
> > >> I have explained the problem in this mail.
> > >>
> > >> http://marc.info/?l=linux-acpi&m=121391675711763&w=2
> > >>
> > >> Maybe nobody has seen this problem yet, because there are no systems
> > >> out there with less than 4GB memory to start with and which allow
> > >> memory hotplug.
> > >>
> > >> But still i don't understand what do you mean by, we can get incorrect
> > >> pci_mem_start, in which case ?
> > >
> > > In the function of setup_arch the pci_mem_start will be parsed by
> > > searching the e820 table.  After the patch is applied, we will parse the
> > > pci_mem_start again in the function of pci_acpi_scan_init and it will
> > > override the value parsed in the function of setup_arch. If the
> > > pci_mem_start is incorrect in the second case, maybe it will have side
> > > effect.
> >
> > Yes it will override. But how can the value be incorrect in the second
> > case. As explained in my previous mail we still parse the e820_map to
> > check if we have unclaimed resources between start_address (that read
> > from  _CRS) to 2^32.  So even if this start_address is wrong we would
> > catch that during parsing e820_map. But again why would the _CRS
> > return incorrect values, are you talking about errors in BIOS ?
> The pci_mem_start is still gotten by parsing the E820 table.But the
> input parameter start_addr will be used in the function of
> e820_search_gap.
>   If the following is the resource start address returned by the PCI0
> _CRS object , maybe the different pci_mem_start will be gotten.
>     0xE0000000
>     0xE4000000
> 
>   At the same time if several start address is returned by the _CRS
> object, the e820 table will be parsed several times.

Yes we will parse e820 several times, but we don't initialize
pci_mem_start in every pass. 
It will be initialized only twice once via the e820_setup_gap code path
and once via pci_setup_gap.
And i think you agree that both of these are required ?

During the gap calculation the previous code or the code now in
e820_setup_gap does this...
	calculates a gap in e820_map from 0 to 2^32.
	Initializes pci_mem_start.

And now with this patch, the code in pci_setup_gap
does this...
	for each _CRS under PCI0
		search gap from start_addr of _CRS to 2^32 *[1].
	Initialize pci_mem_start with the biggest gap that we could
	find.

Essentially, what we are doing is just limiting the gap calculation to a
smaller address space depending on the ACPI information we get.

Now then, what problem do you see with this approach ?

*[1]
While writing this mail i figured out that, instead of searching from
start_addr of _CRS to 2^32 we should just search till *end_addr* of _CRS resource.
I will send a patch to that effect. 

Thanks,
Alok


> 
> Thanks.
>   Yakui
> 
> > Thanks,
> > Alok
> 

