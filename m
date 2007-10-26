Return-Path: <linux-kernel-owner+w=401wt.eu-S1763296AbXJZDPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296AbXJZDPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbXJZDO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:14:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46656 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756472AbXJZDO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:14:59 -0400
Date: Thu, 25 Oct 2007 20:14:55 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071025201455.acb4e72c.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710251937100.2989@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<20071025192945.82962eea.pj@sgi.com>
	<alpine.DEB.0.9999.0710251937100.2989@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Yes, when using cpusets for resource control.  If memory pressure is being 
> felt for that cpuset and additional mems are added to alleviate possible 
> OOM conditions, it is insufficient to allow tasks within that cpuset to 
> continue using memory policies that prohibit them from taking advantage of 
> the extra memory.

Well ... "resource control" is a tad thin for a decent "use case".

But ok ... that's a little more compelling.

The user space man pages for set_mempolicy(2) are now even more
behind the curve, by not mentioning that MPOL_INTERLEAVE's mask
might mean nothing, if (1) in a cpuset marked memory_spread_user,
(2) after the cpuset has changed 'mems'.

I wonder if there is any way to fix that.  Who does the man pages
for Linux system calls?

Hmmm ... that reminds me ... the period of time between when the
task issues the set_mempolicy(2) MPOL_INTERLEAVE call and when some
cpuset 'mems' change subsequently moves its memory placement is an
anomaly here. During that period of time, the MPOL_INTERLEAVE mask
-does- apply, even if a subset of the 'mems' in the tasks cpuset.
This could result in test cases missing some failures.  If they
test with a particular, carefully crafted MPOL_INTERLEAVE mask
that is a proper (strictly less than) subset of the nodes allowed
in the cpuset, they might not notice that their code is broken if
they happen to be in a memory_spread_user cpuset after a 'mems'
change has jammed the entire cpusets 'mems' into their interleave
mask.

Perhaps we should make it so that doing a set_mempolicy(2) call
to set MPOL_INTERLEAVE immediately changes the memory policy to
the cpusets mems_allowed.

A key advantage in doing this would be that the set_mempolicy user
documentation could simply state that the MPOL_INTERLEAVE mask is
ignored when in a cpuset marked memory_spread_user, instead interleaving
over all the memory nodes in the cpuset.  This would be quite a bit
simpler and clearer than saying that the cpusets nodes are used only
after subsequent cpuset 'mems' changes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
