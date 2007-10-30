Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXJ3WyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXJ3WyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXJ3WyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:54:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5383 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbXJ3WyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:54:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=kM/qQJfPckcWTN8zRf0sarHB8tF8lzvVhWYb210lyMsVTO7vugfCfrSxmKBF9rySM
	xPIzzojDDwLBLaWy8PUoQ==
Date: Tue, 30 Oct 2007 15:53:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071029002602.34866d8c.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710301548350.15640@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
 <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com> <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com> <20071027161955.e9d4d2db.pj@sgi.com>
 <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com> <20071028164637.8d1b45b0.pj@sgi.com> <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com> <20071028212745.57a7db67.pj@sgi.com> <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
 <20071028224533.df924291.pj@sgi.com> <alpine.DEB.0.9999.0710282352270.23978@chino.kir.corp.google.com> <20071029002602.34866d8c.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Paul Jackson wrote:

> >     Policies such as MPOL_INTERLEAVE always get AND'd with
> >     pol->cpuset_mems_allowed.
> 
> Not AND'd - Folded, as in bitmap_remap().
> 
> >     If that yields numa_no_nodes, MPOL_DEFAULT is used instead.
> 
> Not an issue with Folding.
> 
> >     Policies such as MPOL_PREFERRED are respected if the node
> >     is set in pol->cpuset_mems_allowed, otherwise MPOL_DEFAULT
> >     is used.
> 
> Not an issue with Folding.
> 
> >     If an application attempts to setup a memory policy for
> >     an MPOL_PREFERRED node that it doesn't have access to or
> >     an MPOL_INTERLEAVE nodemask that is empty when AND'd with
> >     pol->cpuset_mems_allowed, -EINVAL is returned and no new
> >     policy is effected.
> 
> Not issues with Folding.
> 
> >     If an application gains nodes in pol->cpuset_mems_allowed that
> >     now include the nodes from MPOL_INTERLEAVE or MPOL_PREFERRED,
> >     that policy is then effected once again.  Otherwise,
> >     MPOL_DEFAULT is still used.
> 
> Not issues with Folding.
> 
> With folding, an application that layed out an elaborate memory
> policy configuration covering say 16 nodes can run in a 4 node
> cpuset, where whatever would have been on node N gets folded down
> to node N % 4.
> 

Missing the point; this is an alternative to the previous choices; Choice 
C explicitly removes all remaps ("folding") from mempolicies.  The 
nodemask passed to set_mempolicy() will always have exactly one meaning: 
the system nodes that the policy is intended for.

Cpusets, which are built upon mempolicies, can obviously take access to 
some of those nodes away.  That's why the existing mempolicies are AND'd 
with the cpuset's mems_allowed to represent the current nodemask that the 
mempolicy is effecting.  If none of them are available because of cpusets, 
the mempolicy is invalidated and MPOL_DEFAULT is used.  If access to some 
nodes from the mempolicy's nodemask become available once again, the 
policy is again effected.

I'm arguing that remapping a policy's nodemask, although that is what 
currently is done, is troublesome because it can use a policy such as 
MPOL_PREFERRED to work on a node for which it was never intended.

		David
