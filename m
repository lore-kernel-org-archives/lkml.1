Return-Path: <linux-kernel-owner+w=401wt.eu-S932557AbZKXTxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbZKXTxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbZKXTxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:53:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:28420 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758229AbZKXTxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:53:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="750050904"
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
In-Reply-To: <4B0C2D85.7020200@gmail.com>
References: <1258995923.4531.715.camel@laptop>
	 <4B0B782A.4030901@linux.intel.com>	<1259051986.4531.1057.camel@laptop>
	 <20091124.093956.247147202.davem@davemloft.net>
	 <1259085412.2631.48.camel@ppwaskie-mobl2>  <4B0C2547.8030408@gmail.com>
	 <1259087601.2631.56.camel@ppwaskie-mobl2>  <4B0C2D85.7020200@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 11:53:14 -0800
Message-Id: <1259092394.2631.64.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 11:01 -0800, Eric Dumazet wrote:
> Peter P Waskiewicz Jr a écrit :
> 
> > That's exactly what we're doing in our 10GbE driver right now (isn't
> > pushed upstream yet, still finalizing our testing).  We spread to all
> > NUMA nodes in a semi-intelligent fashion when allocating our rings and
> > buffers.  The last piece is ensuring the interrupts tied to the various
> > queues all route to the NUMA nodes those CPUs belong to.  irqbalance
> > needs some kind of hint to make sure it does the right thing, which
> > today it does not.
> 
> sk_buff allocations should be done on the node of the cpu handling rx interrupts.

Yes, but we preallocate the buffers to minimize overhead when running
our interrupt routines.  Regardless, whatever queue we're filling with
those sk_buff's has an interrupt vector attached.  So wherever the
descriptor ring/queue and its associated buffers were allocated, that is
where the interrupt's affinity needs to be set to.

> For rings, I am ok for irqbalance and driver cooperation, in case admin
>  doesnt want to change the defaults.
> 
> > 
> > I don't see how this is complex though.  Driver loads, allocates across
> > the NUMA nodes for optimal throughput, then writes CPU masks for the
> > NUMA nodes each interrupt belongs to.  irqbalance comes along and looks
> > at the new mask "hint," and then balances that interrupt within that
> > hinted mask.
> 
> So NUMA policy is given by the driver at load time ?

I think it would have to.  Nobody else has insight how the driver
allocated its resources.  So the driver can be told where to allocate
(see below), or the driver needs to indicate upwards how it allocated
resources.

> An admin might chose to direct all NIC trafic to a given node, because
> its machine has mixed workload. 3 nodes out of 4 for database workload,
> one node for network IO...
> 
> So if an admin changes smp_affinity, is your driver able to reconfigure itself
> and re-allocate all its rings to be on NUMA node chosen by admin ? This is
> what I qualify as complex.

No, we don't want to go this route of reallocation.  This, I agree, is
very complex, and can be very devastating.  We'd basically be resetting
the driver whenever an interrupt moved, so this could be a terrible DoS
vulnerability.

Jesse Brandeburg has a set of patches he's working on that will allow us
to bind an interface to a single node.  So in your example of 3 nodes
for DB workload and 1 for network I/O, the driver can be loaded and
directly bound to that 4th node.  Then the node_affinity mask would be
set by the driver for the CPU mask of that single node.  But in these
deployments, a sysadmin changing affinity that will fly directly in the
face of how resources are laid out is poor system administration.  I
know it will happen, but I don't know how far we need to protect the
sysadmin from shooting themselves in the foot in terms of performance
tuning.

Cheers,
-PJ

