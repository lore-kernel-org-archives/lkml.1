Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbZLOKWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbZLOKWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbZLOKWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:22:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:36663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727AbZLOKWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:22:10 -0500
Subject: Re: [patch 2/2] sched: Scale the nohz_tracker logic by making it
 per NUMA node
From: Peter Zijlstra <peterz@infradead.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <1260838815.15729.214.camel@localhost.localdomain>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.450920000@intel.com>  <1260829283.8023.124.camel@laptop>
	 <1260829958.15729.194.camel@localhost.localdomain>
	 <1260831496.8023.210.camel@laptop>
	 <1260838815.15729.214.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Dec 2009 11:21:56 +0100
Message-ID: <1260872516.4165.349.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 17:00 -0800, Pallipadi, Venkatesh wrote:
> On Mon, 2009-12-14 at 14:58 -0800, Peter Zijlstra wrote:
> > On Mon, 2009-12-14 at 14:32 -0800, Pallipadi, Venkatesh wrote:
> > > 
> > > The idea is to do idle balance only within the nodes.
> > > Eg: 4 node (and 4 socket) system with each socket having 4 cores.
> > > If there is a single active thread on such a system, say on socket 3.
> > > Without this change we have 1 idle load balancer (which may be in socket
> > > 0) which has periodic ticks and remaining 14 cores will be tickless.
> > > But this one idle load balancer does load balance on behalf of itself +
> > > 14 other idle cores.
> > > 
> > > With the change proposed in this patch, we will have 3 completely idle
> > > nodes/sockets. We will not do load balance on these cores at all.
> > 
> > That seems like a behavioural change, not balancing these 3 nodes at all
> > could lead to overload scenarios on the one active node, right?
> > 
> 
> Yes. You are right. This can result in some node level imbalance. The
> main problem that we were trying to solve is over-aggressive attempt to
> load balance idle CPUs. We have seen on a system with 64 logical CPUs,
> if there is only active thread, we have seen one other CPU (the idle
> load balancer) spending 3-5% time being non-idle just trying to do load
> balance on behalf of 63 idle CPUs on a continuous basis. Trying idle
> rebalance every jiffy across all nodes when balance across nodes has
> interval of 8 or 16 jiffies. There are other forms of rebalancing like
> fork and exec that will still balance across nodes. But, if there are no
> forks/execs, we will have the overload scenario you pointed out.
> 
> I guess we need to look at other alternatives to make this cross node
> idle load balancing more intelligent. However, first patch in this
> series  has its share of advantages in avoiding unneeded idle balancing.
> And with first patch, cross node issues will be no worse than current
> state. So, that is worth as a stand alone change as well. 

OK, I'll actually have a look at the patch now that I understand what
we're trying to do here ;-)

Thanks!

> > > Remaining one active socket will have one idle load balancer, which when
> > > needed will do idle load balancing on behalf of itself + 2 other idle
> > > cores in that socket.
> > 
> > > If there all sockets have atleast one busy core, then we may have more
> > > than one idle load balancer, but each will only do idle load balance on
> > > behalf of idle processors in its own node, so total idle load balance
> > > will be same as now.
> > 
> > How about things like Magny-Cours which will have multiple nodes per
> > socket, wouldn't that be best served by having the total socket idle,
> > instead of just half of it?
> > 
> 
> Yes. But, that will be same with general load balancing behavior and not
> just idle load balancing. That would probably need another level in
> scheduler domain?

Right, Andreas was supposed to look at doing that, not sure if he ever
got around to it though.
