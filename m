Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZLNW6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZLNW6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbZLNW6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:58:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbZLNW6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:58:31 -0500
Subject: Re: [patch 2/2] sched: Scale the nohz_tracker logic by making it
 per NUMA node
From: Peter Zijlstra <peterz@infradead.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <1260829958.15729.194.camel@localhost.localdomain>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.450920000@intel.com>  <1260829283.8023.124.camel@laptop>
	 <1260829958.15729.194.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 23:58:16 +0100
Message-ID: <1260831496.8023.210.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 14:32 -0800, Pallipadi, Venkatesh wrote:
> On Mon, 2009-12-14 at 14:21 -0800, Peter Zijlstra wrote:
> > On Thu, 2009-12-10 at 17:27 -0800, venkatesh.pallipadi@intel.com wrote:
> > > Having one idle CPU doing the rebalancing for all the idle CPUs in
> > > nohz mode does not scale well with increasing number of cores and
> > > sockets. Make the nohz_tracker per NUMA node. This results in multiple
> > > idle load balancing happening at NUMA node level and idle load balancer
> > > only does the rebalance domain among all the other nohz CPUs in that
> > > NUMA node.
> > > 
> > > This addresses the below problem with the current nohz ilb logic
> > > * The lone balancer may end up spending a lot of time doing the
> > > * balancing on
> > >   behalf of nohz CPUs, especially with increasing number of sockets and
> > >   cores in the platform.
> > 
> > If the purpose is to keep sockets idle, doing things per node doesn't
> > seem like a fine plan, since we're having nodes <= socket machines these
> > days.
> 
> The idea is to do idle balance only within the nodes.
> Eg: 4 node (and 4 socket) system with each socket having 4 cores.
> If there is a single active thread on such a system, say on socket 3.
> Without this change we have 1 idle load balancer (which may be in socket
> 0) which has periodic ticks and remaining 14 cores will be tickless.
> But this one idle load balancer does load balance on behalf of itself +
> 14 other idle cores.
> 
> With the change proposed in this patch, we will have 3 completely idle
> nodes/sockets. We will not do load balance on these cores at all.

That seems like a behavioural change, not balancing these 3 nodes at all
could lead to overload scenarios on the one active node, right?

> Remaining one active socket will have one idle load balancer, which when
> needed will do idle load balancing on behalf of itself + 2 other idle
> cores in that socket.

> If there all sockets have atleast one busy core, then we may have more
> than one idle load balancer, but each will only do idle load balance on
> behalf of idle processors in its own node, so total idle load balance
> will be same as now.

How about things like Magny-Cours which will have multiple nodes per
socket, wouldn't that be best served by having the total socket idle,
instead of just half of it?

