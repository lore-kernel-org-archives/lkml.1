Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbXJ3X0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbXJ3X0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXJ3X0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:26:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXJ3X0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:26:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=tmFuNJPQ3I8dVYDmat58seJuyZfHH3zLMqCTn58/OC9dv74V3LW3MBDvbBRxaILEw
	41nLphc+Yz/LFoXtI0rNg==
Date: Tue, 30 Oct 2007 16:25:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071030161728.40f27300.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710301618590.19750@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
 <20071026194144.6042316a.pj@sgi.com> <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com> <20071027161955.e9d4d2db.pj@sgi.com> <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com> <20071028164637.8d1b45b0.pj@sgi.com>
 <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com> <20071028212745.57a7db67.pj@sgi.com> <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com> <20071028224533.df924291.pj@sgi.com> <alpine.DEB.0.9999.0710282352270.23978@chino.kir.corp.google.com>
 <20071029002602.34866d8c.pj@sgi.com> <alpine.DEB.0.9999.0710301548350.15640@chino.kir.corp.google.com> <20071030161728.40f27300.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Paul Jackson wrote:

> We've already got two Choices, one released and one in the oven.  Is
> there an actual, real world situation, motivating this third Choice?
> 

Let's put Choice C into the lower oven, then.

Of course there's actual and real world examples of this, because right 
now we're not meeting the full intent of the application.  Cpusets deal 
with cpus and memory, they don't have anything to do with affinity to 
particular I/O devices; that part is left up to the creator of the cpuset 
to sort out correctly based on their system topology.

If my application does tons of I/O on one particular device to which my 
memory has access, I can use MPOL_PREFERRED to prefer the memory be 
allocated on a node with the best affinity to my device.  If cpusets 
change my access to that node, I'm still using an MPOL_PREFERRED policy 
with a remapped node that no longer has affinity to that device because 
nodes_remap() doesn't take that into account.  My preference would be to 
fallback to MPOL_DEFAULT behavior, since it's certainly plausible that 
other cpusets share the same node, instead of unnecessarily filling up a 
node that I don't even prefer anymore.

Same situation exists of MPOL_INTERLEAVE policies where my NUMA 
optimization is no longer helpful because I'm interleaving over a set of 
nodes that was simply remapped and their affinity (which isn't guaranteed 
to be unifom) wasn't even taken into account.

But, with Choice C, my intent is still preserved in the mempolicy even 
though it's not effected because my access rights to the node has changed.  
If I get access to that node back later, and I haven't issued subsequent 
set_mempolicy() calls to change my policy, my MPOL_PREFERRED or 
MPOL_INTERLEAVE policy is again effected and I then benefit from my NUMA 
optimization once again.

		David
