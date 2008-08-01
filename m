Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbYHAWrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbYHAWrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758819AbYHAWnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:43:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36713 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760738AbYHAWnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:43:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	<m1iqukwjjg.fsf@frodo.ebiederm.org>
	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
Date: Fri, 01 Aug 2008 15:38:45 -0700
In-Reply-To: <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 1 Aug 2008 14:30:55 -0700")
Message-ID: <m1wsj0nyx6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Fri, Aug 1, 2008 at 1:46 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>>
>>> Please check dyn_array support for x86
>>
>> YH you have not addressed any of my core concerns and this exceeds my review
> limit.
>
> i mean drivers/serial/8250.c

Still not based on UART_NR.  Although Alan said he would take a look at it
next week, because he thinks this is important work.

>> Unfortunately I don't feel like this is a productive process.
>>
>> My core concerns are:
>> - You have not separated out and separately pushed the regression patch.  So
> that we can
>> fix the current rc release.  Simply tuning NR_IRQS is all I feel comfortable
> with for
>>  fixing things in the post merge window period.
>
> Increase NR_IRQS to 512 for x86_64?

x86_32 has it set to 1024 so 512 is too small.  I think your patch
which essentially restores the old behavior is the right way to go for
this merge window.  I just want to carefully look at it and ensure we
are restoring the old heuristics.  On a lot of large machines we wind
up having irqs for pci slots that are never filled with cards.

>> - The generic code has no business with dealing with NR_IRQS sized arrays.
>> Since we don't have a generic problem I don't see why we should have a generic
> dyn_array solution.
> besides
>
> arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct
> irq_pin_list), pin_map_size, 16, NULL);
> arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(balance_irq_affinity,
> sizeof(struct balance_irq_affinity), nr_irqs, PAGE_SIZE,
> irq_affinity_init_work);
> arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(irq_vector, sizeof(u8),
> nr_irqs, PAGE_SIZE, irq_vector_init_work);
> arch/x86/kernel/io_apic_64.c:DEFINE_DYN_ARRAY(irq_cfg, sizeof(struct
> irq_cfg), nr_irqs, PAGE_SIZE, init_work);
> arch/x86/kernel/io_apic_64.c:DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct
> irq_pin_list), pin_map_size, sizeof(struct irq_pin_list), NULL);

You have noticed how much of those arrays I have collapsed into irq_cfg
on x86_64.  We can ultimately do the same on x86_32.  The
tricky one is irq_2_pin.  I believe the proper solution is to just
dynamically allocate entries and place a pointer in irq_cfg.  Although
we may be able to simply a place a single entry in irq_cfg.

> kernel/sched.c:DEFINE_PER_CPU_DYN_ARRAY_ADDR(per_cpu__kstat_irqs,
> per_cpu__kstat.irqs, sizeof(unsigned int), nr_irqs, sizeof(unsigned
> long), NULL);
>
> and kstat.irqs is the killer... every cpu will have that. [NR_CPUS][NR_IRQS]...

Yes.  See my patch in the referenced lkml link.

>> - The dyn_array infrastructure does not provide for per numa node allocation
> of
>>  irq_desc structures, limiting NUMA scalability.
>
> you plan to move irq_desc when irq_affinity is set to cpus on other node?
> something like DEFINE_PER_NODE_DYN_ARRAY ?

Not when irq_affinity is set.  But rather allocate it with the on the
node where the device that generates the irq and the node where the
irq controller the irq goes through is located on.  Which is where we
should be handling the irq if we want performance.

>> - You appear to be papering over problems instead of digging in and actually
> fixing them.
>
> use dyn_array is less intrusive at this point. and dyn_array related
> code is not big.
> just NR_IRQS to nr_irqs to make the patches more bigger. actually it is simple.
>
> with acpi_madt probing, nr_irqs is much small. like 48 or 98. and
> current one is MACRO 224 or 256.

I agree with your sentiment if we can actually allocate the irqs by
demand instead of preallocating them based on worst case usage we
should use much less memory.

I figure that keeping any type of nr_irqs around you are requiring
us to estimate the worst case number of irqs we need to deal with.

The challenge is that we have hot plug devices with MSI-X capabilities
on them.  Just one of those could add 4K irqs (worst case).  256 or
so I have actually heard hardware guys talking about.

But even one msi vector on a pci card that doesn't have normal irqs could
mess up a tightly sized nr_irqs based soley on acpi_madt probing.

>> YH Here is what I was suggesting when the topic of killing NR_IRQs came up a
> week or so
>> ago.
>> http://lkml.org/lkml/2008/7/10/439
>> http://lkml.org/lkml/2008/7/10/532
>>
>> Which essentially boils down to:
>> - Removing NR_IRQS from the non-irq infrastructure code.
>> - Add a config option for architectures that are not going to use an array
>> - In the genirq code have a lookup function that goes from irq number to
> irq_desc *.
>
> so we need one pointer array with that lookup function? what is the
> pointer array index size?
> or use list in that lookup function?

Please read the articles I mentioned.  My first approximation would
be a linked list.  irq is always defined as "unsigned int irq"

> how about percpu kstat.irqs?

Again in the referenced articles is my old patch that turns kstat.irqs
inside out.  Allowing us to handle that case with a normal percpu
allocation per irq.  Ultimately I think that is smaller.

>> The rest we should be able to handle in a arch dependent fashion.
>>
>> When we are done we should be able to create a stable irq number for msi
> interrupts
>> that is something like: bus:dev:fun:vector_no which is 8+5+3+12=28 bits long.
>
> how about irq migration from one cpu to another with different vector_no ?

Sorry I was referring to the MSI-X source vector number which is a 12
bit index into an array of MSI-X vectors on the pci device, not the
vector we receive the irq at on the pci card.

Eric
