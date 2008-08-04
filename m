Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbYHDU17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbYHDU17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763768AbYHDU1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:27:41 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45034 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760338AbYHDU1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:27:39 -0400
Message-ID: <48976638.6010800@sgi.com>
Date: Mon, 04 Aug 2008 13:27:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/04] x86: add get_irq_cfg in io_apic_64.c
References: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>	 <1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>	 <1217844601-4298-3-git-send-email-yhlu.kernel@gmail.com>	 <48971A1E.5040704@sgi.com> <86802c440808041112h29204f5at447b0279e1b6d4eb@mail.gmail.com>
In-Reply-To: <86802c440808041112h29204f5at447b0279e1b6d4eb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

course

Yinghai Lu wrote:
> On Mon, Aug 4, 2008 at 8:02 AM, Mike Travis <travis@sgi.com> wrote:
>> Yinghai Lu wrote:
>...
>>>
>>> +struct irq_cfg;
>>> +
>>>  struct irq_cfg {
>>> +     unsigned int irq;
>>> +     struct irq_cfg *next;
>>>       cpumask_t domain;
>>>       cpumask_t old_domain;
>>        ^^^^^^^^^
>> One thought here... most interrupts cannot be serviced by any cpu in
>> the system, but instead need to be serviced by the cpu attached to
>> the ioapic or on the local node.  So defining some subset of cpumask_t
>> would save a lot of space.  For example:
>>
>>        nodecpumask_t {
>>                int     node;
>>                DEFINE_BITMAP(..., MAX_CPUS_PER_NODE);
>>        };
>>
>> And of course, providing some utilities to convert nodecpumask_t <==>
>> cpumask_t.
>>
>> ("node" might not be the proper abstraction... maybe "irqcpumask_t"?)
> union irq_cpumask_t {
>             int     cpu;
>             unsigned long mask;
> };
> 
> also thinking if we can have dyn_cpumask_t etc if NR_CPU=4096, but
> nr_cpus or nr_cpu_ids=32 in running time.
> with that distributions could have NR_CPU=4096 as default config...
> 
> YH

Believe it or not, 64 might not be enough.  The Nahelem 8 core (16 HT's)
has two QPI connects.  In theory, you could put together a node with 4
cpu sockets and 2 of the new io inf's on a single board.  That's 64 cpus
and 4 PCIe busses (plus all the legacy stuff).  The Intel microarch
could very well support 8 cores in the next gen processors.

Btw, I meant the above to be a struct so node and bitmap are both
present.  This causes a contiguous subset of cpu ids to be in the
bitmask.  Of course, this would rely on the cpus being "discovered"
in topology order, possibly with holes (not clear if that's really
necessary.)

So a system with 8 nodes and 32 processors each, node 2's cpus would be
64..95 and the nodecpumask would be { 2, 0xffffffff00000000 } (assuming
max cpus per node == 64.)

Another angle thrown around was using a 128 bit cpu mask struct,
with some number of upper bits defining the remainder, which could be a
bit mask field, a pointer to a bitmask, a bitmask subset (as above),
etc.  Then all the cpus_* ops would be modified to accept the alternate
types of cpu mask sets, compiling out (optimizing) those not present on
a particular arch.

[One last point, we (SGI) are counting on _this_ release to have
NR_CPUS=4096 in the default distro config.  Sufficient to say, some
of our customers will not accept "special" built kernels, but instead
require standard, certified, licensable kernels built by the distros.
(This is for the "Enterprise" Editions, Desktop distros course probably
won't go as high.)]

Thanks,
Mike
