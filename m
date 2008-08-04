Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYHDM6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYHDM6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYHDM55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:57:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51749 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751939AbYHDM54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:57:56 -0400
Message-ID: <4896FCD0.8050006@sgi.com>
Date: Mon, 04 Aug 2008 05:57:52 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>	<m1iqukwjjg.fsf@frodo.ebiederm.org>	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>	<m1wsj0nyx6.fsf@frodo.ebiederm.org>	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com> <m163qkjirc.fsf@frodo.ebiederm.org>
In-Reply-To: <m163qkjirc.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> 
>>>> Increase NR_IRQS to 512 for x86_64?
>>> x86_32 has it set to 1024 so 512 is too small.  I think your patch
>>> which essentially restores the old behavior is the right way to go for
>>> this merge window.  I just want to carefully look at it and ensure we
>>> are restoring the old heuristics.  On a lot of large machines we wind
>>> up having irqs for pci slots that are never filled with cards.
>> it seems 32bit summit need NR_IRQS=256, NR_IRQ_VECTOR=1024
> 
> Yes.  Which is 1024 irq sources/gsis only 1/4 used so it will fit into 256 irqs.
> 
> On x86_64 we have removed the confusing and brittle irq compression
> code.  So to handle that many irqs we would need 1024 irqs.
> 
> I expect modern big systems that can only run x86_64 are larger still.
> 
>>> You have noticed how much of those arrays I have collapsed into irq_cfg
>>> on x86_64.  We can ultimately do the same on x86_32.  The
>>> tricky one is irq_2_pin.  I believe the proper solution is to just
>>> dynamically allocate entries and place a pointer in irq_cfg.  Although
>>> we may be able to simply a place a single entry in irq_cfg.
> 
>> so there will be irq_desc and irq_cfg lists?
> Or we place irq_desc in irq_cfg.
> 
>> wonder if helper to get irq_desc and irq_cfg for one irq_no could be bottleneck?
> 
> Nah.  We lookup whatever it we need in the 256 entry vector_irq table.
> I expect we can do the container_of trick beyond that.
> 
> If the helper which we should only see on the slow path is a bottleneck
> we can easily turn organize irq_desc into a tree structure.  Ultimately
> I think we want drivers to have a struct irq *irq pointer but we need
> to get the arch backend working first.
> 
>> PS: cpumask_t domain in irq_cfg need to updated... it wast 512bytes
>> when NR_CPUS=4096
>> could change it to unsigned int. logical mode (flat, x2apic logical) it as mask
>> and (physical flat mode, and x2apic physical) it is cpu number.
> 
> Certainly there is the potential to simplify things.
> 
>>> I agree with your sentiment if we can actually allocate the irqs by
>>> demand instead of preallocating them based on worst case usage we
>>> should use much less memory.
>> yes.
>>
>>> I figure that keeping any type of nr_irqs around you are requiring
>>> us to estimate the worst case number of irqs we need to deal with.
>> need to comprise flexibility and performance..., or say waste some
>> space to get some performance...
> 
> The thing is there is no good upper bound of how many irqs we can see
> short of of NR_PCI_DEVICES*4096
> 
>>> The challenge is that we have hot plug devices with MSI-X capabilities
>>> on them.  Just one of those could add 4K irqs (worst case).  256 or
>>> so I have actually heard hardware guys talking about.
> 
>> good know. so one cpu handle one card? or need 16 cpus serve one
>> cards? or they got new cpu to NR_VECTORS  with 32bit?
> 
> Yes.  Currently for the current worst case it requires 16 cpus.
> The biggest I have heard a card using at this point is 256 irqs.
> At lot of the goal in those cards is so they can have 2 irqs per cpu.
> 1 rx irq and 1 tx irq.  Allowing them to implement per cpu queues.
> 
>> then need to keep struct irq_desc, can not put everything into it.
> 
> Yes.  But we can put all the arch specific code in irq_cfg, and put
> irq_desc in irq_cfg.
> 
>>> But even one msi vector on a pci card that doesn't have normal irqs could
>>> mess up a tightly sized nr_irqs based soley on acpi_madt probing.
>> v2 double that last_gsi_end
> 
> Which is usable, but no where near as nice as not having a fixed upper bound.
> 
> 
>>> Sorry I was referring to the MSI-X source vector number which is a 12
>>> bit index into an array of MSI-X vectors on the pci device, not the
>>> vector we receive the irq at on the pci card.
>> cpu is going to check that vectors in addition to vectors in IDT?
> 
> No. The destination cpu and destination vector number are encoded in
> the MSI message.  Each MSI-X source ``vector'' has a different MSI message.
> 
> So on my wish list is to stably encode the MSI interurrpt numbers.  And
> using a sparse irq address space I can.  As it only takes 28 bits to hold
> the complete bus + device + function + msi source [ 0-4095 ] 
> 
> Eric

Don't you need "domain" (node) in the bus:device:function:vector combination?
(Or [hack] use a lot bigger field for bus with the node encoded into it.)

Thanks,
Mike
