Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZKKDXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZKKDXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZKKDXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:23:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52847 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbZKKDXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:23:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v3
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0911101908180.14549@chino.kir.corp.google.com>
References: <20091111115217.FD56.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0911101908180.14549@chino.kir.corp.google.com>
Message-Id: <20091111121958.FD59.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 12:23:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 11 Nov 2009, KOSAKI Motohiro wrote:
> 
> > > >  {
> > > > -#ifdef CONFIG_NUMA
> > > >  	struct zone *zone;
> > > >  	struct zoneref *z;
> > > >  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> > > > -	nodemask_t nodes = node_states[N_HIGH_MEMORY];
> > > > +	int ret = CONSTRAINT_NONE;
> > > >  
> > > > -	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
> > > > -		if (cpuset_zone_allowed_softwall(zone, gfp_mask))
> > > > -			node_clear(zone_to_nid(zone), nodes);
> > > > -		else
> > > > +	/*
> > > > + 	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
> > > > + 	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
> > > > + 	 * feature. mempolicy is an only user of nodemask here.
> > > > + 	 */
> > > > +	if (nodemask) {
> > > > +		nodemask_t mask;
> > > > +		/* check mempolicy's nodemask contains all N_HIGH_MEMORY */
> > > > +		nodes_and(mask, *nodemask, node_states[N_HIGH_MEMORY]);
> > > > +		if (!nodes_equal(mask, node_states[N_HIGH_MEMORY]))
> > > > +			return CONSTRAINT_MEMORY_POLICY;
> > > > +	}
> > > 
> > > Although a nodemask_t was previously allocated on the stack, we should 
> > > probably change this to use NODEMASK_ALLOC() for kernels with higher 
> > > CONFIG_NODES_SHIFT since allocations can happen very deep into the stack.
> > 
> > No. NODEMASK_ALLOC() is crap. we should remove it. 
> 
> I've booted 1K node systems and have found it to be helpful to ensure that 
> the stack will not overflow especially in areas where we normally are deep 
> already, such as in the page allocator.

Linux doesn't support 1K nodes. (and only SGI huge machine use 512 nodes)

At least, NODEMASK_ALLOC should make more cleaner interface. current one
and struct nodemask_scratch are pretty ugly.


> > btw, CPUMASK_ALLOC was already removed.
> 
> I don't remember CPUMASK_ALLOC() actually being merged.  I know the 
> comment exists in nodemask.h, but I don't recall any CPUMASK_ALLOC() users 
> in the tree.



