Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbZKXSdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbZKXSdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933902AbZKXSdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:33:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:41191 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933901AbZKXSdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:33:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="470217601"
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <4B0C2547.8030408@gmail.com>
References: <1258995923.4531.715.camel@laptop>
	 <4B0B782A.4030901@linux.intel.com>	<1259051986.4531.1057.camel@laptop>
	 <20091124.093956.247147202.davem@davemloft.net>
	 <1259085412.2631.48.camel@ppwaskie-mobl2>  <4B0C2547.8030408@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 10:33:21 -0800
Message-Id: <1259087601.2631.56.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 10:26 -0800, Eric Dumazet wrote:
> Peter P Waskiewicz Jr a écrit :
>  That's the kind of thing PJ is trying to make available.
> > 
> > Yes, that's exactly what I'm trying to do.  Even further, we want to
> > allocate the ring SW struct itself and descriptor structures on other
> > NUMA nodes, and make sure the interrupt lines up with those allocations.
> > 
> 
> Say you allocate ring buffers on NUMA node of the CPU handling interrupt
> on a particular queue.
> 
> If irqbalance or an admin changes /proc/irq/{number}/smp_affinities,
> do you want to realloc ring buffer to another NUMA node ?
> 

That's why I'm trying to add the node_affinity mechanism that irqbalance
can use to prevent the interrupt being moved to another node.

> It seems complex to me, maybe optimal thing would be to use a NUMA policy to
> spread vmalloc() allocations to all nodes to get a good bandwidth...

That's exactly what we're doing in our 10GbE driver right now (isn't
pushed upstream yet, still finalizing our testing).  We spread to all
NUMA nodes in a semi-intelligent fashion when allocating our rings and
buffers.  The last piece is ensuring the interrupts tied to the various
queues all route to the NUMA nodes those CPUs belong to.  irqbalance
needs some kind of hint to make sure it does the right thing, which
today it does not.

I don't see how this is complex though.  Driver loads, allocates across
the NUMA nodes for optimal throughput, then writes CPU masks for the
NUMA nodes each interrupt belongs to.  irqbalance comes along and looks
at the new mask "hint," and then balances that interrupt within that
hinted mask.

Cheers,
-PJ

