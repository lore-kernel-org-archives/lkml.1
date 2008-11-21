Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYKUVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYKUVSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 16:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYKUVSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 16:18:05 -0500
Received: from relay1.sgi.com ([192.48.179.29]:41518 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750822AbYKUVSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 16:18:04 -0500
Date: Fri, 21 Nov 2008 15:18:00 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Gregory Haskins <ghaskins@novell.com>, Max Krasnyansky <maxk@qualcomm.com>
Cc: Derek Fults <dfults@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081121211800.GA16647@sgi.com>
References: <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <4924C770.7050107@qualcomm.com> <4926158B.9020909@novell.com> <49271449.2030804@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49271449.2030804@qualcomm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Max,

On Fri, Nov 21, 2008 at 12:04:25PM -0800, Max Krasnyansky wrote:
> Hi Greg,
> 
> I attached debug instrumentation patch for Dmitri to try. I'll clean it up and
>  add things you requested and will resubmit properly some time next week.
> 

We added Max's debug patch to our kernel and have run Max's Trace 3 scenario, but we do not see a NULL sched-domain remain attached, see my comments below.


 mount -t cgroup cpuset -ocpuset /cpusets/

for i in 0 1 2 3; do mkdir par$i; echo $i > par$i/cpuset.cpus; done

kernel: cpusets: rebuild ndoms 1
kernel: cpuset: domain 0 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpusets: rebuild ndoms 1
kernel: cpuset: domain 0 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpusets: rebuild ndoms 1
kernel: cpuset: domain 0 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpusets: rebuild ndoms 1
kernel: cpuset: domain 0 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0

echo 0 > cpuset.sched_load_balance
kernel: cpusets: rebuild ndoms 4
kernel: cpuset: domain 0 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpuset: domain 1 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpuset: domain 2 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpuset: domain 3 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: CPU0 root domain default
kernel: CPU0 attaching NULL sched-domain.
kernel: CPU1 root domain default
kernel: CPU1 attaching NULL sched-domain.
kernel: CPU2 root domain default
kernel: CPU2 attaching NULL sched-domain.
kernel: CPU3 root domain default
kernel: CPU3 attaching NULL sched-domain.
kernel: CPU3 root domain e0000069ecb20000
kernel: CPU3 attaching sched-domain:
kernel:  domain 0: span 3 level NODE
kernel:   groups: 3
kernel: CPU2 root domain e000006884a00000
kernel: CPU2 attaching sched-domain:
kernel:  domain 0: span 2 level NODE
kernel:   groups: 2
kernel: CPU1 root domain e000006884a20000
kernel: CPU1 attaching sched-domain:
kernel:  domain 0: span 1 level NODE
kernel:   groups: 1
kernel: CPU0 root domain e000006884a40000
kernel: CPU0 attaching sched-domain:
kernel:  domain 0: span 0 level NODE
kernel:   groups: 0


Which is the way sched_load_balance is supposed to work.  You need to set sched_load_balance=0 for all cpusets containing any cpu you want to disable balancing on, otherwise some balancing will happen.

So in addition to the top (root) cpuset, we need to set it to '0' in the parX cpusets.  That will turn off load balancing to the cpus in question (thereby attaching a NULL sched domain).  So when we do that for just par3, we get the following:

echo 0 > par3/cpuset.sched_load_balance
kernel: cpusets: rebuild ndoms 3
kernel: cpuset: domain 0 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpuset: domain 1 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: cpuset: domain 2 cpumask
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0
0000000,00000000,00000000,00000000,0
kernel: CPU3 root domain default
kernel: CPU3 attaching NULL sched-domain.

So the def_root_domain is now attached for CPU 3.  And we do have a NULL sched-domain, which we expect for a cpu with load balancing turned off.  If we turn sched_load_balance off ('0') on each of the other cpusets (par0-2), each of those cpus would also have a NULL sched-domain attached.
