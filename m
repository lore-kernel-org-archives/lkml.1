Return-Path: <linux-kernel-owner+w=401wt.eu-S1751283AbZLUNMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbZLUNMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbZLUNMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:12:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZLUNMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:12:38 -0500
Subject: Re: [patch 2/2] sched: Scale the nohz_tracker logic by making it
 per NUMA node
From: Peter Zijlstra <peterz@infradead.org>
To: venkatesh.pallipadi@intel.com
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20091211013056.450920000@intel.com>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.450920000@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 14:11:46 +0100
Message-ID: <1261401106.4314.137.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 17:27 -0800, venkatesh.pallipadi@intel.com wrote:
> plain text document attachment
> (0002-sched-Scale-the-nohz_tracker-logic-by-making-it-per.patch)
> Having one idle CPU doing the rebalancing for all the idle CPUs in
> nohz mode does not scale well with increasing number of cores and
> sockets. Make the nohz_tracker per NUMA node. This results in multiple
> idle load balancing happening at NUMA node level and idle load balancer
> only does the rebalance domain among all the other nohz CPUs in that
> NUMA node.
> 
> This addresses the below problem with the current nohz ilb logic
> * The lone balancer may end up spending a lot of time doing the
> * balancing on
>   behalf of nohz CPUs, especially with increasing number of sockets and
>   cores in the platform.

Right, so I think the whole NODE idea here is wrong, it all seems to
work out properly if you simply pick one sched domain larger than the
one that contains all of the current socket and contains an idle unit.

Except that the sched domain stuff is not properly aware of bigger
topology things atm.

The sched domain tree should not view node as the largest structure and
we should remove that current random node split crap we have.

Instead the sched domains should continue to express the topology, like
nodes within 1 hop, nodes within 2 hops, etc.

Then this nohz idle balancing should pick the socket level (which might
be larger than the node level), and walks up the domain tree, until we
reach a level where it has a whole idle group.

This means that we'll always span at least 2 sockets, which means we'll
gracefully deal with the overload scenario.


