Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZLNWc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZLNWc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZLNWcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:32:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:29867 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZLNWcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:32:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,397,1257148800"; 
   d="scan'208";a="756112016"
Subject: Re: [patch 2/2] sched: Scale the nohz_tracker logic by making it
 per NUMA node
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <1260829283.8023.124.camel@laptop>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.450920000@intel.com>  <1260829283.8023.124.camel@laptop>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 14:32:38 -0800
Message-Id: <1260829958.15729.194.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 14:21 -0800, Peter Zijlstra wrote:
> On Thu, 2009-12-10 at 17:27 -0800, venkatesh.pallipadi@intel.com wrote:
> > Having one idle CPU doing the rebalancing for all the idle CPUs in
> > nohz mode does not scale well with increasing number of cores and
> > sockets. Make the nohz_tracker per NUMA node. This results in multiple
> > idle load balancing happening at NUMA node level and idle load balancer
> > only does the rebalance domain among all the other nohz CPUs in that
> > NUMA node.
> > 
> > This addresses the below problem with the current nohz ilb logic
> > * The lone balancer may end up spending a lot of time doing the
> > * balancing on
> >   behalf of nohz CPUs, especially with increasing number of sockets and
> >   cores in the platform.
> 
> If the purpose is to keep sockets idle, doing things per node doesn't
> seem like a fine plan, since we're having nodes <= socket machines these
> days.

The idea is to do idle balance only within the nodes.
Eg: 4 node (and 4 socket) system with each socket having 4 cores.
If there is a single active thread on such a system, say on socket 3.
Without this change we have 1 idle load balancer (which may be in socket
0) which has periodic ticks and remaining 14 cores will be tickless.
But this one idle load balancer does load balance on behalf of itself +
14 other idle cores.

With the change proposed in this patch, we will have 3 completely idle
nodes/sockets. We will not do load balance on these cores at all.
Remaining one active socket will have one idle load balancer, which when
needed will do idle load balancing on behalf of itself + 2 other idle
cores in that socket.

If there all sockets have atleast one busy core, then we may have more
than one idle load balancer, but each will only do idle load balance on
behalf of idle processors in its own node, so total idle load balance
will be same as now.

Thanks,
Venki

