Return-Path: <linux-kernel-owner+w=401wt.eu-S933972AbZKXTBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbZKXTBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbZKXTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:01:36 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:54369 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922AbZKXTBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:01:35 -0500
Message-ID: <4B0C2D85.7020200@gmail.com>
Date: Tue, 24 Nov 2009 20:01:25 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: David Miller <davem@davemloft.net>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance
 hints
References: <1258995923.4531.715.camel@laptop>	 <4B0B782A.4030901@linux.intel.com>	<1259051986.4531.1057.camel@laptop>	 <20091124.093956.247147202.davem@davemloft.net>	 <1259085412.2631.48.camel@ppwaskie-mobl2>  <4B0C2547.8030408@gmail.com> <1259087601.2631.56.camel@ppwaskie-mobl2>
In-Reply-To: <1259087601.2631.56.camel@ppwaskie-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Nov 2009 20:01:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter P Waskiewicz Jr a écrit :

> That's exactly what we're doing in our 10GbE driver right now (isn't
> pushed upstream yet, still finalizing our testing).  We spread to all
> NUMA nodes in a semi-intelligent fashion when allocating our rings and
> buffers.  The last piece is ensuring the interrupts tied to the various
> queues all route to the NUMA nodes those CPUs belong to.  irqbalance
> needs some kind of hint to make sure it does the right thing, which
> today it does not.

sk_buff allocations should be done on the node of the cpu handling rx interrupts.

For rings, I am ok for irqbalance and driver cooperation, in case admin
 doesnt want to change the defaults.

> 
> I don't see how this is complex though.  Driver loads, allocates across
> the NUMA nodes for optimal throughput, then writes CPU masks for the
> NUMA nodes each interrupt belongs to.  irqbalance comes along and looks
> at the new mask "hint," and then balances that interrupt within that
> hinted mask.

So NUMA policy is given by the driver at load time ?

An admin might chose to direct all NIC trafic to a given node, because
its machine has mixed workload. 3 nodes out of 4 for database workload,
one node for network IO...

So if an admin changes smp_affinity, is your driver able to reconfigure itself
and re-allocate all its rings to be on NUMA node chosen by admin ? This is
what I qualify as complex.
