Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZJ0AUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZJ0AUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZJ0AUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:20:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:42720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbZJ0AUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:20:54 -0400
Message-ID: <4AE63CCC.3050203@kernel.org>
Date: Mon, 26 Oct 2009 17:20:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: only release that resource index is less than 3
References: <4AE2C827.8040905@kernel.org>	 <200910261032.58231.bjorn.helgaas@hp.com>	 <20091026101942.578f41b2@jbarnes-g45>  <4AE6135B.2070003@kernel.org> <1256601476.25492.47.camel@dc7800.home>
In-Reply-To: <1256601476.25492.47.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Mon, 2009-10-26 at 14:23 -0700, Yinghai Lu wrote:
> 
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/setup-bus.c
>> +++ linux-2.6/drivers/pci/setup-bus.c
>> @@ -322,33 +322,54 @@ static void pci_bridge_check_ranges(stru
>>  	}
>>  }
>>  
>> -/* Helper function for sizing routines: find first available
>> -   bus resource of a given type. Note: we intentionally skip
>> -   the bus resources which have already been assigned (that is,
>> -   have non-NULL parent resource). */
>> -static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
>> +void pci_bridge_release_not_used_res(struct pci_bus *bus)
>>  {
>>  	int i;
>>  	struct resource *r;
>>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>>  				  IORESOURCE_PREFETCH;
>>  
>> -	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
>> +	/* for pci bridges res only */
>> +	for (i = 0; i < 3; i++) {
> 
> I think the "i = 0; i < 3" part is to check the bridge apertures, i.e.,
> the I/O base/limit, the memory base/limit, and the prefetchable memory
> base/limit.  Right?  We need some way to indicate that more clearly than
> using a hard-coded "3".

yes. the 0x1c, 0x20, and 0x28

> 
>>  		r = bus->resource[i];
>> -		if (r == &ioport_resource || r == &iomem_resource)
>> -			continue;
>> -		if (r && (r->flags & type_mask) == type) {
>> +		if (r && (r->flags & type_mask)) {
>>  			if (!r->parent)
>> -				return r;
>> +				continue;
>>  			/*
>>  			 * if there is no child under that, we should release
>>  			 * and use it. don't need to reset it, pbus_size_* will
>>  			 * set it again
>>  			 */
>>  			if (!r->child && !release_resource(r))
> 
> We got this resource pointer out of a struct pci_bus, and we release it
> here.  We must have previously done a request_resource(),
> allocate_resource(), or similar.  Where does that happen?  Are the
> requests and releases nested correctly?
> 
> I would think that somewhere, we would be doing a request_resource() and
> assigning the resource to pci_bus->resource[x].  But there are very few
> assignments to the pci_bus resources:
>   setup_resource (only for "pci=use_crs")
>   pci_read_bridge_bases (just a copy from upstream bus resources)
>   pci_alloc_child_bus (copy from upstream bridge resources)
>   pci_create_bus (set to &ioport_resource or &iomem_resource)
> 
> My guess is that this release_resource() releases something we copied
> from the bridge in pci_alloc_child_bus().  But that doesn't seem right,
> because we aren't changing the bridge programming here.

in arch/x86/pci/i386.c::
pcibios_resource_survey() ==> pcibios_allocate_bus_resources()


YH
