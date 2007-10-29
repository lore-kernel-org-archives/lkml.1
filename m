Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXJ2PKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXJ2PKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXJ2PKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:10:14 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:43711 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXJ2PKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:10:12 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
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
	 <1193433239.5032.95.camel@localhost>
	 <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	 <1193434278.5032.106.camel@localhost>
	 <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 29 Oct 2007 11:10:17 -0400
Message-Id: <1193670617.5035.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 14:39 -0700, David Rientjes wrote:
> On Fri, 26 Oct 2007, Lee Schermerhorn wrote:
> 
> > So, you pass the subset, you don't set the flag to indicate you want
> > interleaving over all available.  You must be thinking of some other use
> > for saving the subset mask that I'm not seeing here.  Maybe restoring to
> > the exact nodes requested if they're taken away and then re-added to the
> > cpuset?
> > 
> 
> Paul's motivation for saving the passed nodemask to set_mempolicy() is so 
> that the _intent_ of the application is never lost.  That's the biggest 
> advantage that this method has and that I totally agree with.  So whenever 
> the mems_allowed of a cpuset changes, the MPOL_INTERLEAVE nodemask of all 
> attached tasks becomes their intent (pol->passed_nodemask) AND'd with the 
> new mems_allowed.  That can be done on mpol_rebind_policy() and shouldn't 
> be an extensive change.
> 
> So MPOL_INTERLEAVE, and possibly other, mempolicies will always try to 
> accomodate the intent of the application but only as far as the task's 
> cpuset restriction allows them.
> 
> 		David

Maybe it's just me, but I think it's pretty presumptuous to think we can
infer the intent of the application from the nodemask w/o additional
flags such as Christoph proposed [cpuset relative]--especially for
subsets of the cpuset.  E.g., the application could intend the nodemask
to specify memories within a certain distance of a physical resource,
such as where a particular IO adapter or set thereof attach to the
platform.  

And even when the intent is to preserve the cpuset relative positions of
the nodes in the nodemask, this really only makes sense if the original
and modified cpusets have the same physical topology w/rt multi-level
NUMA interconnects.  This is something that has bothered me about
dynamic cpusets and current policy remapping.  We don't do a good job of
explaining the implications of changing cpuset topology on applications,
nor do we handle it very well in the code.  Paul addresses one of my
concerns in a later message in this thread, so I'll comment there.

Later,
Lee

