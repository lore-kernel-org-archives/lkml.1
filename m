Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZCFTDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZCFTDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZCFTDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:03:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZCFTDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:03:05 -0500
Subject: Re: [Patch] mm tracepoints
From: Larry Woodman <lwoodman@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <1236361106.6326.595.camel@laptop>
References: <1233306324.11332.11.camel@nigel-laptop>
	 <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090306105627.3EF0.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com>
	 <20090306110423.GD21168@elte.hu>
	 <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com>
	 <20090306135547.GB21907@elte.hu>
	 <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090306171016.GA32128@elte.hu>  <1236361106.6326.595.camel@laptop>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 14:06:14 -0500
Message-Id: <1236366374.1476.79.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 18:38 +0100, Peter Zijlstra wrote:
> On Fri, 2009-03-06 at 18:10 +0100, Ingo Molnar wrote:
> > Looks pretty good and useful to me. I've Cc:-ed more mm folks, 
> > it would be nice to hear their opinion about these tracepoints.
> > 
> > Andrew, Nick, Peter, what do you think?
> 
> Bit sad we use the struct mm_struct * as mm identifier (little %lx vs %p
> confusion there too), but I suppose there simply isn't anything better.
> 
> Exposing kernel pointers like that might upset some of the security
> folks, not sure if I care though.
> 
> I'm missing the fault_filemap_read counterpart of fault_anon_pgin.

filemap_fault handles both the initial fault when the pte is zero and
pagein when the page has been reclaimed.  It was impossible to implement
them as separate handlers in __do_fault() without changing the
underlying MM code.

> 
> Once you have anon/filemap symmetric, you might consider folding these
> and doing the anon argument thing you do elsewhere.
> 
> Initially I was thinking we lacked the kswapd vs direct reclaim
> information on the pgout data, but since we log the pid:comm for each
> event...

They are separate, trace_mm_kswapd_runs() and
trace_mm_directreclaim_reclaimall().
trace_mm_directreclaim_reclaimzone() is for the zone_reclaim path where
we do local zone reclamation rather than falling off to the next zone in
the zone list.

> 
> Which brings us to mm_pdflush_*, we can already see its pdflush from
> pid:comm, then again, it fits the naming style. Same for
> mm_directreclaim*() - we already know its direct, since its not kswapd
> doing it.
> 

Like I said above there are 2 direct reclaim paths: one is teh call to
try_to_free_pages() out of __alloc_pages_internal() and the other is the
call to shrink_zone() out of __zone_reclaim().  I made a distinction
between these because the first calls shrink_zone for each zone in the
zone list when memory is really low(below min) where the second calls
shrink_zone for the local zone to prevent memory allocation from a
remote node.

> Finally, we have page_free, but not page_alloc? Oh, it is there, just
> not in the obvious place.

In order to get the zone free information it has to be in down in
get_page_from_freelist.

> 
> 
> Things missing, we trace unmap, but not mmap, mprotect, mlock?
> 
I was concentrating more on the operations that traced a page moving
throughout the system.  mmap and mprotect operate on the virtual address
space instead of the pages mapped in that address space.


Larry


