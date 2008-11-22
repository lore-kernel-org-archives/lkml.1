Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYKVHDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYKVHDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYKVHDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:03:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33562 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYKVHDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:03:43 -0500
X-IronPort-AV: E=McAfee;i="5300,2777,5441"; a="13386960"
Message-ID: <4927AECA.2040707@qualcomm.com>
Date: Fri, 21 Nov 2008 23:03:38 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Gregory Haskins <ghaskins@novell.com>, Derek Fults <dfults@sgi.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <4924C770.7050107@qualcomm.com> <4926158B.9020909@novell.com> <49271449.2030804@qualcomm.com> <20081121211800.GA16647@sgi.com>
In-Reply-To: <20081121211800.GA16647@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dimitri Sivanich wrote:
> Hi Greg and Max,
> 
> On Fri, Nov 21, 2008 at 12:04:25PM -0800, Max Krasnyansky wrote:
>> Hi Greg,
>>
>> I attached debug instrumentation patch for Dmitri to try. I'll clean it up and
>>  add things you requested and will resubmit properly some time next week.
>>
> 
> We added Max's debug patch to our kernel and have run Max's Trace 3 scenario, but we do not see a NULL sched-domain remain attached, see my comments below.
> 
> 
> mount -t cgroup cpuset -ocpuset /cpusets/
> 
> for i in 0 1 2 3; do mkdir par$i; echo $i > par$i/cpuset.cpus; done
> 
> kernel: cpusets: rebuild ndoms 1
> kernel: cpuset: domain 0 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
Oops. I did not realize your NR_CPUS is so large. Unfortunately all your masks
got truncated.
I'll update the patch to print cpu list instead of the masks.

> echo 0 > cpuset.sched_load_balance
> kernel: cpusets: rebuild ndoms 4
> kernel: cpuset: domain 0 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
> kernel: cpuset: domain 1 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
> kernel: cpuset: domain 2 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
> kernel: cpuset: domain 3 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
> kernel: CPU0 root domain default
> kernel: CPU0 attaching NULL sched-domain.
> kernel: CPU1 root domain default
> kernel: CPU1 attaching NULL sched-domain.
> kernel: CPU2 root domain default
> kernel: CPU2 attaching NULL sched-domain.
> kernel: CPU3 root domain default
> kernel: CPU3 attaching NULL sched-domain.

> kernel: CPU3 root domain e0000069ecb20000
> kernel: CPU3 attaching sched-domain:
> kernel:  domain 0: span 3 level NODE
> kernel:   groups: 3
> kernel: CPU2 root domain e000006884a00000
> kernel: CPU2 attaching sched-domain:
> kernel:  domain 0: span 2 level NODE
> kernel:   groups: 2
> kernel: CPU1 root domain e000006884a20000
> kernel: CPU1 attaching sched-domain:
> kernel:  domain 0: span 1 level NODE
> kernel:   groups: 1
> kernel: CPU0 root domain e000006884a40000
> kernel: CPU0 attaching sched-domain:
> kernel:  domain 0: span 0 level NODE
> kernel:   groups: 0
> 
> Which is the way sched_load_balance is supposed to work. You need to set
> sched_load_balance=0 for all cpusets containing any cpu you want to disable
> balancing on, otherwise some balancing will happen.
It won't be much of a balancing in this case because this just one cpu per
domain.
In other words no that's not how it supposed to work. There is code in
cpu_attach_domain() that is supposed to remove redundant levels
(sd_degenerate() stuff). There is an explicit check in there for numcpus == 1.
btw The reason you got a different result that I did is because you have a
NUMA box where is mine is UMA. I was able to reproduce the problem though by
enabling multi-core scheduler. In which case I also get one redundant domain
level CPU, with a single CPU in it.
So we definitely need to fix this. I'll try to poke around tomorrow and figure
out why redundant level is not dropped.

> So in addition to the top (root) cpuset, we need to set it to '0' in the
> parX cpusets. That will turn off load balancing to the cpus in question
> (thereby attaching a NULL sched domain). 
As I explained above we should not have to disable load balancing in cpusets
with a single CPU.

> So when we do that for just par3, we get the following:
> echo 0 > par3/cpuset.sched_load_balance
> kernel: cpusets: rebuild ndoms 3
> kernel: cpuset: domain 0 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
> kernel: cpuset: domain 1 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
> kernel: cpuset: domain 2 cpumask
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
> 0000000,00000000,00000000,00000000,0
> kernel: CPU3 root domain default
> kernel: CPU3 attaching NULL sched-domain.
> 
> So the def_root_domain is now attached for CPU 3.  And we do have a NULL
> sched-domain, which we expect for a cpu with load balancing turned off.  If
> we turn sched_load_balance off ('0') on each of the other cpusets (par0-2),
> each of those cpus would also have a NULL sched-domain attached.
Ok. This one is a bug in cpuset.c:generate_sched_domains(). Sched domain
generator in cpusets should not drop domains with single cpu in them when
sched_load_balance==0. I'll look at that tomorrow too.

Max
