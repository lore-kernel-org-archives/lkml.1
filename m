Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYJ3JLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYJ3JLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYJ3JLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:11:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50753 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYJ3JLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:11:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=O9y7p/sT0QOZCLk18AtJqe5t2RJGWIqVUmumsu5cqzjQ4xvRuxCPW7h5qqlpD2zVL
	Tx+dSHdL6GOKMZu1OtfZQ==
Date: Thu, 30 Oct 2008 02:10:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] mm: make page writeback obey cpuset constraints
In-Reply-To: <1225356120.7803.5.camel@twins>
Message-ID: <alpine.DEB.2.00.0810300203360.29917@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>  <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com>  <1225215134.15763.27.camel@lappy.programming.kicks-ass.net>  <alpine.DEB.1.10.0810281216570.30390@chino.kir.corp.google.com>
 <1225356120.7803.5.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Peter Zijlstra wrote:

> On Tue, 2008-10-28 at 12:18 -0700, David Rientjes wrote:
> > On Tue, 28 Oct 2008, Peter Zijlstra wrote:
> > 
> > > > +	is_subset = cpuset_populate_dirty_limits(dl, &dirtyable_memory,
> > > > +						 &nr_mapped, nodes);
> > > > +	if (!is_subset) {
> > > > +		dl->nr_dirty = global_page_state(NR_FILE_DIRTY);
> > > > +		dl->nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> > > > +		dl->nr_writeback = global_page_state(NR_WRITEBACK);
> > > > +		dirtyable_memory = determine_dirtyable_memory();
> > > > +		nr_mapped = global_page_state(NR_FILE_MAPPED) +
> > > > +			global_page_state(NR_ANON_PAGES);
> > > > +	} else
> > > > +		dirtyable_memory -= highmem_dirtyable_memory(nodes,
> > > > +							dirtyable_memory);
> > > 
> > > Why not fold that all into cpuset_populate_dirty_limits() ?
> > > 
> > 
> > cpuset_populate_dirty_limits() is a no-op on !CONFIG_CPUSETS kernels.
> 
> Right, humm. Maybe introduce a populate_dirty_limits() and differentiate
> that between CONFIG_CPUSETS and not, and make it do everything.
> 
> That would get rid of this fudge I think, no?
> 

I agree it would look much cleaner and I actually did that originally, but 
it requires adding #ifdef's for CONFIG_CPUSETS to mm/page-writeback.c 
since highmem_dirtyable_memory() is static.

There's actually nothing cpuset-specific about 
cpuset_populate_dirty_limits() and it could be used for !CONFIG_CPUSETS 
kernels, but there's a performance benefit of using the global ZVC values 
for the page stats as opposed to iterating over each node and adding their 
respective values.  So is_subset is only non-zero when the passed nodemask 
excludes system nodes (the cpuset case), and we must iterate the node ZVC 
values.

So perhaps the solution is to introduce populate_nodemask_dirty_limits() 
and populate_global_dirty_limits() both in mm/page-writeback.c?
