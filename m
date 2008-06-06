Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYFFONg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYFFONg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbYFFONH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:13:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59433 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758429AbYFFONE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:13:04 -0400
Message-ID: <484945EC.3020508@sgi.com>
Date: Fri, 06 Jun 2008 07:13:00 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>	 <20080605195604.41623687.akpm@linux-foundation.org>	 <20080606071707.GB9708@elte.hu>	 <20080606002957.6329a0ec.akpm@linux-foundation.org>	 <20080606024811.70db9ab2.akpm@linux-foundation.org>	 <20080606035413.37f340ef.akpm@linux-foundation.org>	 <20080606115759.GA29321@elte.hu>	 <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com>	 <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com>
In-Reply-To: <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, Jun 6, 2008 at 3:33 PM, Mike Travis <travis@sgi.com> wrote:
>> Vegard Nossum wrote:
>>> I reproced it with gc 4.1.2. I think the error is somewhere in kernel/sched.c.
>>>
>>> static int __build_sched_domains(const cpumask_t *cpu_map,
>>>                                  struct sched_domain_attr *attr)
>>> {
>>> ...
>>>         for (i = 0; i < MAX_NUMNODES; i++) {
>>> ...
>>>                 sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
>>> ...
>>>
>>> This code is calling into the allocator with a spurious value of i,
>>> which causes SLAB to use an index (of 4 in my case) that is out of
>>> bounds for its nodelist array (at least it hasn't been initialized).
>>>
>>> This bit of code (a bit further down, inside the same loop) is also dubious:
>>>
>>>                         sg = kmalloc_node(sizeof(struct sched_group),
>>>                                           GFP_KERNEL, i);
>>>                         if (!sg) {
>>>                                 printk(KERN_WARNING
>>>                                 "Can not alloc domain group for node %d\n", j);
>>>                                 goto error;
>>>                         }
>>>
>>> Where it passes i to kmalloc_node() but reports an allocation for node
>>> j. Which one is correct?
>>>
> 
> Hm, I think I'm wrong and the code is correct. However...
> 
>>> Hope this helps, will send an update if I find out more.
>>>
>>>
>>> Vegard
>>>
>> Thanks Vegard for tracking this down.  My thoughts were along the same
>> wavelength... ;-)
> 
> I applied this patch
> @@ -7133,6 +7133,14 @@ static int __build_sched_domains(const
> cpumask_t *cpu_map,
>                 cpus_clear(*covered);
> 
>                 cpus_and(*nodemask, *nodemask, *cpu_map);
> +
> +               printk("node %d\n", i);
> +               for (j = 0; j < NR_CPUS; ++j)
> +                       printk("%c", cpu_isset(j, *nodemask) ? 'X' : '.');
> +               printk("\n");
> +
> +               printk("empty = %d\n", cpus_empty(*nodemask));
> +
>                 if (cpus_empty(*nodemask)) {
>                         sched_group_nodes[i] = NULL;
>                         continue;
> 
> and it shows some really strange output, maybe it makes sense to you:
> 
> (the X means cpu is in the node)
> 
> Total of 2 processors activated (11976.24 BogoMIPS).
> node 0
> XX..............................................................................
> ................................................................................
> ................................................................................
> ...............
> empty = 0
> node 1
> XX..............................................................................
> ................................................................................
> ................................................................................
> ...............
> empty = 0
> l3 = cachep->nodelists[0] (size-64) = ffff81003f824340
> node 2
> ................................................................................
> ................................................................................
> ................................................................................
> ...............
> empty = 1
> node 3
> ................................................................................
> ................................................................................
> ................................................................................
> ...............
> empty = 1
> node 4
> X...............................................................................
> ................................................................................
> ................................................................................
> ...............
> empty = 0
> 
> This is a P4 3.0GHz with 1 physical CPU (but HT, so two logical CPUs).
> Yet node 4 is claimed to have a cpu too. That's bogus!
> 
> (But I don't think it's an error in sched.c any more, probably the
> code that sets up the node maps.)
> 
> 
> Vegard
> 

Could you send me the full console log and your config file?  The setup of
the node_to_cpumask map is dependent on the early discovery (usually in the
apic code) and there's been some changes in that area recently.

Thanks,
Mike
