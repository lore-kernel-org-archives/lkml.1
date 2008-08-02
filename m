Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYHBBJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYHBBJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 21:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYHBBJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 21:09:41 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:10329 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYHBBJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 21:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QvXkhbaj7SZh2zBl5W1BMK29hxMVpzrcXFyqRq8QMKQDv3Jsv1CLj4TQHyl5PzDf60
         SUVVuPew3TQcbtDxwCPMJyY2Y1s5H3PNxQcPLA4Rp3bQxCUaPOCJUedroP/OJ+73iIU1
         QXpu/u10Tkjmsd/zxwv9mm8HJrx48zAi1vUNI=
Message-ID: <86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
Date: Fri, 1 Aug 2008 18:09:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1wsj0nyx6.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1iqukwjjg.fsf@frodo.ebiederm.org>
	 <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	 <m1wsj0nyx6.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 3:38 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>> On Fri, Aug 1, 2008 at 1:46 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>>>
>>>> Please check dyn_array support for x86
>>>
>>> YH you have not addressed any of my core concerns and this exceeds my review
>> limit.
>>
>> i mean drivers/serial/8250.c
>
> Still not based on UART_NR.  Although Alan said he would take a look at it
> next week, because he thinks this is important work.

change that to list?

>
>>> Unfortunately I don't feel like this is a productive process.
>>>
>>> My core concerns are:
>>> - You have not separated out and separately pushed the regression patch.  So
>> that we can
>>> fix the current rc release.  Simply tuning NR_IRQS is all I feel comfortable
>> with for
>>>  fixing things in the post merge window period.
>>
>> Increase NR_IRQS to 512 for x86_64?
>
> x86_32 has it set to 1024 so 512 is too small.  I think your patch
> which essentially restores the old behavior is the right way to go for
> this merge window.  I just want to carefully look at it and ensure we
> are restoring the old heuristics.  On a lot of large machines we wind
> up having irqs for pci slots that are never filled with cards.

it seems 32bit summit need NR_IRQS=256, NR_IRQ_VECTOR=1024

>
>>> - The generic code has no business with dealing with NR_IRQS sized arrays.
>>> Since we don't have a generic problem I don't see why we should have a generic
>> dyn_array solution.
>> besides
>>
>> arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct
>> irq_pin_list), pin_map_size, 16, NULL);
>> arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(balance_irq_affinity,
>> sizeof(struct balance_irq_affinity), nr_irqs, PAGE_SIZE,
>> irq_affinity_init_work);
>> arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(irq_vector, sizeof(u8),
>> nr_irqs, PAGE_SIZE, irq_vector_init_work);
>> arch/x86/kernel/io_apic_64.c:DEFINE_DYN_ARRAY(irq_cfg, sizeof(struct
>> irq_cfg), nr_irqs, PAGE_SIZE, init_work);
>> arch/x86/kernel/io_apic_64.c:DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct
>> irq_pin_list), pin_map_size, sizeof(struct irq_pin_list), NULL);
>
> You have noticed how much of those arrays I have collapsed into irq_cfg
> on x86_64.  We can ultimately do the same on x86_32.  The
> tricky one is irq_2_pin.  I believe the proper solution is to just
> dynamically allocate entries and place a pointer in irq_cfg.  Although
> we may be able to simply a place a single entry in irq_cfg.

so there will be irq_desc and irq_cfg lists?

wonder if helper to get irq_desc and irq_cfg for one irq_no could be bottleneck?

PS: cpumask_t domain in irq_cfg need to updated... it wast 512bytes
when NR_CPUS=4096
could change it to unsigned int. logical mode (flat, x2apic logical) it as mask
and (physical flat mode, and x2apic physical) it is cpu number.

>
>> kernel/sched.c:DEFINE_PER_CPU_DYN_ARRAY_ADDR(per_cpu__kstat_irqs,
>> per_cpu__kstat.irqs, sizeof(unsigned int), nr_irqs, sizeof(unsigned
>> long), NULL);
>>
>> and kstat.irqs is the killer... every cpu will have that. [NR_CPUS][NR_IRQS]...
>
> Yes.  See my patch in the referenced lkml link.
>
>>> - The dyn_array infrastructure does not provide for per numa node allocation
>> of
>>>  irq_desc structures, limiting NUMA scalability.
>>
>> you plan to move irq_desc when irq_affinity is set to cpus on other node?
>> something like DEFINE_PER_NODE_DYN_ARRAY ?
>
> Not when irq_affinity is set.  But rather allocate it with the on the
> node where the device that generates the irq and the node where the
> irq controller the irq goes through is located on.  Which is where we
> should be handling the irq if we want performance.
>
>>> - You appear to be papering over problems instead of digging in and actually
>> fixing them.
>>
>> use dyn_array is less intrusive at this point. and dyn_array related
>> code is not big.
>> just NR_IRQS to nr_irqs to make the patches more bigger. actually it is simple.
>>
>> with acpi_madt probing, nr_irqs is much small. like 48 or 98. and
>> current one is MACRO 224 or 256.
>
> I agree with your sentiment if we can actually allocate the irqs by
> demand instead of preallocating them based on worst case usage we
> should use much less memory.

yes.

>
> I figure that keeping any type of nr_irqs around you are requiring
> us to estimate the worst case number of irqs we need to deal with.

need to comprise flexibility and performance..., or say waste some
space to get some performance...

>
> The challenge is that we have hot plug devices with MSI-X capabilities
> on them.  Just one of those could add 4K irqs (worst case).  256 or
> so I have actually heard hardware guys talking about.
good know. so one cpu handle one card? or need 16 cpus serve one
cards? or they got new cpu to NR_VECTORS  with 32bit?

then need to keep struct irq_desc, can not put everything into it.

>
> But even one msi vector on a pci card that doesn't have normal irqs could
> mess up a tightly sized nr_irqs based soley on acpi_madt probing.

v2 double that last_gsi_end

>
>>> YH Here is what I was suggesting when the topic of killing NR_IRQs came up a
>> week or so
>>> ago.
>>> http://lkml.org/lkml/2008/7/10/439
>>> http://lkml.org/lkml/2008/7/10/532
>>>
>>> Which essentially boils down to:
>>> - Removing NR_IRQS from the non-irq infrastructure code.
>>> - Add a config option for architectures that are not going to use an array
>>> - In the genirq code have a lookup function that goes from irq number to
>> irq_desc *.
>>
>> so we need one pointer array with that lookup function? what is the
>> pointer array index size?
>> or use list in that lookup function?
>
> Please read the articles I mentioned.  My first approximation would
> be a linked list.  irq is always defined as "unsigned int irq"
>
>> how about percpu kstat.irqs?
>
> Again in the referenced articles is my old patch that turns kstat.irqs
> inside out.  Allowing us to handle that case with a normal percpu
> allocation per irq.  Ultimately I think that is smaller.
so it is
kstat_irqs[cpu][NR_IRQS] ==> irq_desc..kstat_irqs[nr_cpus]
>
>>> The rest we should be able to handle in a arch dependent fashion.
>>>
>>> When we are done we should be able to create a stable irq number for msi
>> interrupts
>>> that is something like: bus:dev:fun:vector_no which is 8+5+3+12=28 bits long.
>>
>> how about irq migration from one cpu to another with different vector_no ?
>
> Sorry I was referring to the MSI-X source vector number which is a 12
> bit index into an array of MSI-X vectors on the pci device, not the
> vector we receive the irq at on the pci card.

cpu is going to check that vectors in addition to vectors in IDT?

YH
