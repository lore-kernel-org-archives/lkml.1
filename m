Return-Path: <linux-kernel-owner+w=401wt.eu-S1765256AbXJZVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765256AbXJZVOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXJZVOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:14:18 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:43292 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXJZVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:14:17 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <1193412644.5032.13.camel@localhost>
	 <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	 <20071026120037.7b95a136.pj@sgi.com>
	 <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 17:13:58 -0400
Message-Id: <1193433239.5032.95.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 13:45 -0700, David Rientjes wrote:
> On Fri, 26 Oct 2007, Paul Jackson wrote:
> 
> > Without at least this sort of change to MPOL_INTERLEAVE nodemasks,
> > allowing either empty nodemasks (Lee's proposal) or extending them
> > outside the current cpuset (what I'm cooking up now), there is no way
> > for a task that is currently confined to a single node cpuset to say
> > anything about how it wants be interleaved in the event that it is
> > subsequently moved to a larger cpuset.  Currently, such a task is only
> > allowed to pass exactly one particular nodemask to set_mempolicy
> > MPOL_INTERLEAVE calls, with exactly the one bit corresponding to its
> > current node.  No useful information can be passed via an API that only
> > allows a single legal value.
> > 
> 
> Well, passing a single node to set_mempolicy() for MPOL_INTERLEAVE doesn't 
> make a whole lot of sense in the first place.  I prefer your solution of 
> allowing set_mempolicy(MPOL_INTERLEAVE, NODE_MASK_ALL) to mean "interleave 
> me over everything I'm allowed to access."  NODE_MASK_ALL would be stored 
> in the struct mempolicy and used later on mpol_rebind_policy().

You don't need to save the entire mask--just note that NODE_MASK_ALL was
passed--like with my internal MPOL_CONTEXT flag.  This would involve
special casing NODE_MASK_ALL in the error checking, as currently
set_mempolicy() complains loudly if you pass non-allowed nodes--see
"contextualize_policy()".  [mbind() on the other hand, appears to allow
any nodemask, even outside the cpuset.  guess we catch this during
allocation.]  This is pretty much the spirit of my patch w/o the API
change/extension [/improvement :)]

For some systems [not mine], the nodemasks can get quite large.  I have
a patch, that I've tested  atop Mel Gorman's "onezonelist" patches that
replaces the nodemasks embedded in struct mempolicy with pointers to
dynamically allocated ones.  However, it's probably not much of a win,
memorywise, if most of the uses are for interleave and bind
policies--both of which would always need the nodemasks in addition to
the pointers.

Now, if we could replace the 'cpuset_mems_allowed' nodemask with a
pointer to something stable, it might be a win.

Lee


