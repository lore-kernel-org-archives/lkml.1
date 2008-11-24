Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYKXVqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYKXVqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYKXVqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:46:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50498 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYKXVqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:46:16 -0500
X-IronPort-AV: E=McAfee;i="5100,188,5444"; a="13405965"
Message-ID: <492B20A6.8050905@qualcomm.com>
Date: Mon, 24 Nov 2008 13:46:14 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, Gregory Haskins <ghaskins@novell.com>,
       Derek Fults <dfults@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <4924C770.7050107@qualcomm.com> <4926158B.9020909@novell.com> <49271449.2030804@qualcomm.com> <20081121211800.GA16647@sgi.com> <4927AECA.2040707@qualcomm.com> <4927C055.8030009@cn.fujitsu.com>
In-Reply-To: <4927C055.8030009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Max Krasnyansky wrote:
>> Dimitri Sivanich wrote:
>>> kernel: CPU3 root domain e0000069ecb20000
>>> kernel: CPU3 attaching sched-domain:
>>> kernel:  domain 0: span 3 level NODE
>>> kernel:   groups: 3
>>> kernel: CPU2 root domain e000006884a00000
>>> kernel: CPU2 attaching sched-domain:
>>> kernel:  domain 0: span 2 level NODE
>>> kernel:   groups: 2
>>> kernel: CPU1 root domain e000006884a20000
>>> kernel: CPU1 attaching sched-domain:
>>> kernel:  domain 0: span 1 level NODE
>>> kernel:   groups: 1
>>> kernel: CPU0 root domain e000006884a40000
>>> kernel: CPU0 attaching sched-domain:
>>> kernel:  domain 0: span 0 level NODE
>>> kernel:   groups: 0
>>>
>>> Which is the way sched_load_balance is supposed to work. You need to set
>>> sched_load_balance=0 for all cpusets containing any cpu you want to disable
>>> balancing on, otherwise some balancing will happen.
>> It won't be much of a balancing in this case because this just one cpu per
>> domain.
>> In other words no that's not how it supposed to work. There is code in
>> cpu_attach_domain() that is supposed to remove redundant levels
>> (sd_degenerate() stuff). There is an explicit check in there for numcpus == 1.
>> btw The reason you got a different result that I did is because you have a
>> NUMA box where is mine is UMA. I was able to reproduce the problem though by
>> enabling multi-core scheduler. In which case I also get one redundant domain
>> level CPU, with a single CPU in it.
>> So we definitely need to fix this. I'll try to poke around tomorrow and figure
>> out why redundant level is not dropped.
>>
> 
> You were not using latest kernel, were you?
> 
> There was a bug in sd degenerate code, and it has already been fixed:
> 	http://lkml.org/lkml/2008/11/8/10
Ah, makes sense.
The funny part is that I did see the patch before but completely forgot 
about it :).

>>> So when we do that for just par3, we get the following:
>>> echo 0 > par3/cpuset.sched_load_balance
>>> kernel: cpusets: rebuild ndoms 3
>>> kernel: cpuset: domain 0 cpumask
>>> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
>>> 0000000,00000000,00000000,00000000,0
>>> kernel: cpuset: domain 1 cpumask
>>> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
>>> 0000000,00000000,00000000,00000000,0
>>> kernel: cpuset: domain 2 cpumask
>>> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
>>> 0000000,00000000,00000000,00000000,0
>>> kernel: CPU3 root domain default
>>> kernel: CPU3 attaching NULL sched-domain.
>>>
>>> So the def_root_domain is now attached for CPU 3.  And we do have a NULL
>>> sched-domain, which we expect for a cpu with load balancing turned off.  If
>>> we turn sched_load_balance off ('0') on each of the other cpusets (par0-2),
>>> each of those cpus would also have a NULL sched-domain attached.
>> Ok. This one is a bug in cpuset.c:generate_sched_domains(). Sched domain
>> generator in cpusets should not drop domains with single cpu in them when
>> sched_load_balance==0. I'll look at that tomorrow too.
>>
> 
> Do you mean the correct behavior should be as following?
> 	kernel: cpusets: rebuild ndoms 4
Yes.

> But why do you think this is a bug? In generate_sched_domains(), cpusets with
> sched_load_balance==0 will be skippped:
> 
> 	list_add(&top_cpuset.stack_list, &q);
> 	while (!list_empty(&q)) {
> 		...
> 		if (is_sched_load_balance(cp)) {
> 			csa[csn++] = cp;
> 			continue;
> 		}
> 		...
>   	}
> 
> Correct me if I misunderstood your point.
The problem is that all cpus in cpusets with sched_load_balance==0 end 
up in the default root_domain which causes lock contention.
We can fix it either in sched.c:partition_sched_domains() or in 
cpusets.c:generate_sched_domains(). I'd rather fix cpusets because 
sched.c fix will be sub-optimal. See my answer to Greg on the same 
thread. Basically the scheduler code would have to allocate a 
root_domain for each CPU even on transitional states. So I'd rather fix 
cpusets to generate domain for each non-overlapping cpuset regardless of 
the sched_load_balance flag.

Max
