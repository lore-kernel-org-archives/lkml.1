Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYFFNeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYFFNeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYFFNdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:33:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52377 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753063AbYFFNdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:33:51 -0400
Message-ID: <48493CBD.1000202@sgi.com>
Date: Fri, 06 Jun 2008 06:33:49 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>	 <20080605195604.41623687.akpm@linux-foundation.org>	 <20080606071707.GB9708@elte.hu>	 <20080606002957.6329a0ec.akpm@linux-foundation.org>	 <20080606024811.70db9ab2.akpm@linux-foundation.org>	 <20080606035413.37f340ef.akpm@linux-foundation.org>	 <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com>
In-Reply-To: <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, Jun 6, 2008 at 1:57 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>> Good
>>>
>>>       a9ad585c8a18f7ba754b85f5786976609b9d7d29
>>>       Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
>>>       Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:47
>>>       Parent: 543e21916497be5a4005fd5820264ce1de9bd56d (x86: restore pda nodenumber field)
>>>       Child:  78d49c6d890aee9cf8aea371011c9d7b0121b822 (x86: remove static boot_cpu_pda array v2)
>>>       Branch:
>>>       Follows: v2.6.26-rc2
>>>       Precedes: next-20080526
>>>
>>>           x86: remove the static 256k node_to_cpumask_map
>>>
>>> crash, as described earlier.
>> thanks for tracking it down! This was the origin of the commit:
>>
>>  # tip/x86/numa: a9ad585: x86: remove the static 256k node_to_cpumask_map
>>
>> which has been in -tip since May 12 and in linux-next for two weeks
>> AFAICS, which is beyond the point of being something freshly wrong.
>>
>> So i suspect something more subtle here. What compiler version are you
>> using? This crash is not something that has been found in testing before
>> - i use rather new compilers, gcc 4.2.2 most of the time. Previous
>> compilers miscompile the kernel seriously so it's not usable for our
>> regression testing grid.
>>
> 
> Hi,
> 
> I reproced it with gc 4.1.2. I think the error is somewhere in kernel/sched.c.
> 
> static int __build_sched_domains(const cpumask_t *cpu_map,
>                                  struct sched_domain_attr *attr)
> {
> ...
>         for (i = 0; i < MAX_NUMNODES; i++) {
> ...
>                 sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
> ...
> 
> This code is calling into the allocator with a spurious value of i,
> which causes SLAB to use an index (of 4 in my case) that is out of
> bounds for its nodelist array (at least it hasn't been initialized).
> 
> This bit of code (a bit further down, inside the same loop) is also dubious:
> 
>                         sg = kmalloc_node(sizeof(struct sched_group),
>                                           GFP_KERNEL, i);
>                         if (!sg) {
>                                 printk(KERN_WARNING
>                                 "Can not alloc domain group for node %d\n", j);
>                                 goto error;
>                         }
> 
> Where it passes i to kmalloc_node() but reports an allocation for node
> j. Which one is correct?
> 
> Hope this helps, will send an update if I find out more.
> 
> 
> Vegard
> 

Thanks Vegard for tracking this down.  My thoughts were along the same
wavelength... ;-)

Mike
