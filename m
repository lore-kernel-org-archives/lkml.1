Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZLSBVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZLSBVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 20:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZLSBVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 20:21:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:46293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbZLSBVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 20:21:48 -0500
Message-ID: <4B2C2A63.9000408@kernel.org>
Date: Fri, 18 Dec 2009 17:20:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/12] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res
 -v2
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC1B.9090104@kernel.org> <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain> <4B2C1DA9.4030907@kernel.org> <alpine.LFD.2.00.0912181635170.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912181635170.3712@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 18 Dec 2009, Yinghai Lu wrote:
>> ok, please check attached is right or not
>>  
>> +static void __release_child_resources(struct resource *r)
>> +{
>> +	struct resource *tmp, *p;
>> +	resource_size_t size;
>> +
>> +	p = r->child;
>> +	r->child = NULL;
>> +	while (p) {
>> +		tmp = p;
>> +		p = p->sibling;
>> +
>> +		tmp->parent = NULL;
>> +		tmp->sibling = NULL;
>> +		__release_child_resources(tmp);
>> +
>> +		printk(KERN_DEBUG "release child resource %pR\n", tmp);
>> +		/* need to restore size, and keep flags */
>> +		size = resource_size(tmp);
>> +		tmp->start = 0;
>> +		tmp->end = size - 1;
>> +	}
>> +}
> 
> Ok, this looks mostly right. I do worry about the alignment information: 
> you lose that thing for any resource that had IORESOURCE_STARTALIGN set 
> when you do this thing. That's pretty fundamental to the whole resource 
> code, I suspect we should just finally add a 'alignment' field to the 
> resource struct, so that alignment doesn't get lost when a resource is 
> allocated.
> 
> (Do a "git grep IORESOURCE_.*ALIGN" to see the kind of stuff I'm talking 
> about, and look at he PCI 'setup-bus.c' code that sets that STARTALIGN 
> thing).
> 
> So a preliminary ack on the resource.c parts. The rest I'm still a bit 
> dubious about, and the whole "we've lost alignment on the resources" is 
> probably indicative of how none of the resource code has ever really been 
> designed for this kind of "tear down and build back up again" behavior.

arch/powerpc/kernel/pci_of_scan.c:              flags |= IORESOURCE_SIZEALIGN;
drivers/pci/probe.c:            res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
drivers/pci/probe.c:                            IORESOURCE_SIZEALIGN;
drivers/pci/setup-bus.c:        b_res->flags |= IORESOURCE_STARTALIGN;
drivers/pci/setup-bus.c:        b_res->flags |= IORESOURCE_STARTALIGN;
drivers/pci/setup-bus.c:        b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
drivers/pci/setup-bus.c:        b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
drivers/pci/setup-bus.c:                b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
drivers/pci/setup-bus.c:                b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
drivers/pci/setup-bus.c:                b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
drivers/pci/setup-res.c:                res->flags &= ~IORESOURCE_STARTALIGN;
drivers/staging/b3dfg/b3dfg.c:                          != (IORESOURCE_MEM | IORESOURCE_SIZEALIGN)) {
include/linux/ioport.h:#define IORESOURCE_SIZEALIGN     0x00020000      /* size indicates alignment */
include/linux/ioport.h:#define IORESOURCE_STARTALIGN    0x00040000      /* start field is alignment */
kernel/resource.c:      switch (res->flags & (IORESOURCE_SIZEALIGN | IORESOURCE_STARTALIGN)) {
kernel/resource.c:      case IORESOURCE_SIZEALIGN:
kernel/resource.c:      case IORESOURCE_STARTALIGN:

looks like IORESOURCE_SIZEALIGN is only used by bridge.

and next round. pbus_size_mem will add that back again.

YH

