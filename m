Return-Path: <linux-kernel-owner+w=401wt.eu-S933218Ab0AGACF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab0AGACF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145Ab0AGACE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:02:04 -0500
Received: from ozlabs.org ([203.10.76.45]:38851 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933109Ab0AGACB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:02:01 -0500
Date: Thu, 7 Jan 2010 11:01:06 +1100
From: Anton Blanchard <anton@samba.org>
To: David Rientjes <rientjes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
Message-ID: <20100107000106.GD12742@kryten>
References: <20100106045509.245662398@samba.org>
 <20100106045509.245662398@samba.org>
 <20100106045525.476396870@samba.org>
 <201001061706.26845.rusty@rustcorp.com.au>
 <alpine.DEB.2.00.1001061454580.11653@chino.kir.corp.google.com>
 <20100106233151.GC12742@kryten>
 <alpine.DEB.2.00.1001061545210.19882@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001061545210.19882@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi David,

> This seems to be the same semantics that NUMA_NO_NODE was defined for, 
> it's not necessarily a special case.
> 
> Regardless, the result of cpumask_of_node(NUMA_NO_NODE) should be 
> undefined as it currently is unless you want to obsolete NUMA_NO_NODE 
> entirely which is much more work.  In other words, special-casing a nid of 
> -1 to mean no affinity is inappropriate if NUMA_NO_NODE represents an 
> invalid nid.
> 
> If x86 pci buses want to use -1 to imply that meaning, that's fine, but it 
> shouldn't be coded in a generic interface such as cpumask_of_node().  Does 
> that make sense?

I wasn't using the example to strengthen the case of the -1 behaviour, but to
highlight that a complete fix would be more work and risk not making it back
to -stable.

I'm all for removing the special case as a followon patch.

> > Speaking of invalid node ids, I also noticed the scheduler isn't using
> > node iterators:
> > 
> >         for (i = 0; i < nr_node_ids; i++) {
> > 
> > which should be fixed at some stage too since it doesn't allow us to
> > allocate the node structures sparsely.
>
> That loop has nothing to do with the allocation of a node structure, it's 
> quite plausible that it checks for various states such as node_online(i) 
> while looping and doing something else interesting for those that are 
> offline.  Keep in mind that this isn't equivalent to using for_each_node() 
> since that only iterates over N_POSSIBLE which is architecture specific.

Yeah I understand it isn't the same thing, but the scheduler oopses in
a number of places with CPUMASK_OFFSTACK and sparse node ids, so things
that can be switched to node iterators should and node_online() checks
should be added elsewhere.

Anton
