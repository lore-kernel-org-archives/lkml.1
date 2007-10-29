Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbXJ2RNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbXJ2RNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXJ2RNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:13:24 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:34477 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbXJ2RNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:13:23 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.9999.0710271212450.19199@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <1193411888.5032.9.camel@localhost>
	 <alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710271212450.19199@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 29 Oct 2007 12:23:08 -0400
Message-Id: <1193674988.5035.93.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 12:16 -0700, David Rientjes wrote:
> On Fri, 26 Oct 2007, David Rientjes wrote:
> 
> > Hacking and requiring an updated version of libnuma to allow empty 
> > nodemasks to be passed is a poor solution; if mempolicy's are supposed to 
> > be independent from cpusets, then what semantics does an empty nodemask 
> > actually imply when using MPOL_INTERLEAVE?  To me, it means the entire 
> > set_mempolicy() should be a no-op, and that's exactly how mainline 
> > currently treats it _as_well_ as libnuma.  So justifying this change in 
> > the man page is respectible, but passing an empty nodemask just doesn't 
> > make sense.
> > 
> 
> Another reason that passing an empty nodemask to set_mempolicy() doesn't 
> make sense is that libnuma uses numa_set_interleave_mask(&numa_no_nodes)
> to disable interleaving completely.
> 

David:  as we discussed when you contacted me off-list about this, the
libnuma API and the system call interface are two quite different APIs.
For example,  numa_set_interleave_mask(&numa_no_nodes) does not pass
MPOL_INTERLEAVE with an empty mask to set_mempolicy().  Rather it
"installs" an MPOL_DEFAULT policy which internally just deletes the
task's mempolicy, allowing fallback to system default policy.  I would
not propose to change this behavior, nor break libnuma in any way.

For other, who weren't involved in the off-list exchange, here's an
excerpt from my response to David:

[
At the libnuma level, I think we need an explicit
"numa_set_interleave_allowed()"--analogous to "numa_set_localalloc()".

The current "numa_alloc_interleaved()" should, I think, allocate on all
*allowed* nodes, rather than all nodes.  It can do this using the sys
call interface as defined.

Independent of cpuset-independent interleave, an application needs to
pass a valid subset of the current mems allowed to
"numa_alloc_interleaved_subset()".   An application can now obtain the
mems_allowed using the MPOL_F_MEMS_ALLOWED flag that I added, but we
need a libnuma wrapper for this as well.  [Yeah, this info can change at
any time, but that's always been the case....]

"numa_interleave_memory()" is essentially mbind(), I think [not looking
at the libnuma source code at this moment].  Maybe provide
"numa_interleave_memory_allowed(void *mem, size_t size)" ???

Finally, I think we need to add a query function:  
"nodemask_t numa_get_mems_allowed()" to return the mask of valid nodes
in the current context [cpuset].  This would just be a wrapper around
get_mempolicy() with the MPOL_F_MEMS_ALLOWED flag.
]

Couple of comments on the above:

1. "the sys call interface as defined" in the 2nd paragraph of the
except refers to my patch that uses null/empty nodemask to indicate "all
allowed".

2.  As this thread progresses, you've discussed relaxing the requirement
that applications pass a valid subset of mems_allowed.  I.e., something
that was illegal becomes legal.  An API change, I think.  But, a
backward compatible one, so that's OK, right? :-)

3. If we do change the semantics of the mempolicy system calls to allow
nodes outside of the cpuset, then maybe we don't need to query the mems
allowed.  I still find it useful, but not absolutely necessary--e.g., to
construct a nodemask that will be acceptable in the current cpuset.

4. I looked at libnuma source.  numa_interleave_memory() does use
mbind() which, again, does not complain about nodemasks that include
non-allowed nodes.

Another thing occurs to me:  perhaps numactl would need an additional
'nodes' specifier such as 'allowed'.  Alternatively, 'all' could be
redefined to me 'all allowed'.  This is independent of how you specify
'all allowed' to the system call.

Regards,
Lee

