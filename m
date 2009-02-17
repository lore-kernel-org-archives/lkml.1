Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZBQOdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZBQOdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZBQOda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:33:30 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:48130 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBQOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:33:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZiODLBcpAULsaOOJDhF/04F/SmNrZVwH4Rzdfh4WFNAWqftaRxEbYomILgo6UuyOj9
         KsCAhtVtU2ufSeUjqRKKkCm+sZlRefqIf5QshOnsX7G8L8KGhLGIxNHYWt2yOWe2HBom
         Usk+JkYJfnnfM+EYHfPrCY6s1i1rZI5a2q0RI=
Date: Tue, 17 Feb 2009 15:33:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>, rostedt@goodmis.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] Add tracepoints to track pagecache transition
Message-ID: <20090217143321.GB5888@nowhere>
References: <1234863220.4744.34.camel@laptop> <499A99BC.2080700@bk.jp.nec.com> <20090217201651.576E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217201651.576E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 08:38:20PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> 
> In my 1st impression, this patch description is a bit strange.
> 
> > The below patch adds instrumentation for pagecache.
> > 
> > I thought it would be useful to trace pagecache behavior for problem
> > analysis (performance bottlenecks, behavior differences between stable
> > time and trouble time).
> > 
> > By using those tracepoints, we can describe and visualize pagecache
> > transition (file-by-file basis) in kernel and  pagecache
> > consumes most of the memory in running system and pagecache hit rate
> > and writeback behavior will influence system load and performance.
> 
> Why do you think this tracepoint describe pagecache hit rate?
> and, why describe writeback behavior?
> 
> > 
> > I attached an example which is visualization of pagecache status using
> > SystemTap. 
> 
> it seems no attached. and SystemTap isn't used kernel developer at all.
> I don't think it's enough explanation.
> Can you make seekwatcher liked completed comsumer program?
> (if you don't know seekwatcher, see http://oss.oracle.com/~mason/seekwatcher/)
> 
> > That graph describes pagecache transition of File A and File B
> > on a file-by-file basis with the situation where regular I/O to File A
> > is delayed because of other I/O to File B. 
> 
> If you want to see I/O activity, you need to add tracepoint into block layer.
> 
> > We visually understand
> > pagecache for File A is narrowed down due to I/O pressure from File B.
> 
> confused. Can we assume the number of anon pages/files pages ratio don't chage?
> 
> 
> > Peter Zijlstra wrote:
> > > On Tue, 2009-02-17 at 18:00 +0900, Atsushi Tsuji wrote:
> > > 
> > >> The below patch adds instrumentation for pagecache.
> > > 
> > > And somehow you forgot to CC any of the mm people.. ;-)
> > 
> > Hi Peter,
> > 
> > Ah, sorry.
> > Thank you for adding to CC list.
> > 
> > >> +DECLARE_TRACE(filemap_add_to_page_cache,
> > >> +	TPPROTO(struct address_space *mapping, pgoff_t offset),
> > >> +	TPARGS(mapping, offset));
> > >> +DECLARE_TRACE(filemap_remove_from_page_cache,
> > >> +	TPPROTO(struct address_space *mapping),
> > >> +	TPARGS(mapping));
> > > 
> > > This is rather asymmetric, why don't we care about the offset for the
> > > removed page?
> > > 
> > 
> > Indeed.
> > I added the offset to the argument for the removed page and resend fixed patch.
> > 
> > Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
> > ---
> > diff --git a/include/trace/filemap.h b/include/trace/filemap.h
> 
> please add diffstat.
> 
> 
> > new file mode 100644
> > index 0000000..a17dc92
> > --- /dev/null
> > +++ b/include/trace/filemap.h
> > @@ -0,0 +1,13 @@
> > +#ifndef _TRACE_FILEMAP_H
> > +#define _TRACE_FILEMAP_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +DECLARE_TRACE(filemap_add_to_page_cache,
> > +	TPPROTO(struct address_space *mapping, pgoff_t offset),
> > +	TPARGS(mapping, offset));
> > +DECLARE_TRACE(filemap_remove_from_page_cache,
> > +	TPPROTO(struct address_space *mapping, pgoff_t offset),
> > +	TPARGS(mapping, offset));
> > +
> > +#endif
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 23acefe..23f75d2 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
> >  #include <linux/memcontrol.h>
> >  #include <linux/mm_inline.h> /* for page_is_file_cache() */
> > +#include <trace/filemap.h>
> >  #include "internal.h"
> >  
> >  /*
> > @@ -43,6 +44,8 @@
> >  
> >  #include <asm/mman.h>
> >  
> > +DEFINE_TRACE(filemap_add_to_page_cache);
> > +DEFINE_TRACE(filemap_remove_from_page_cache);
> >  
> >  /*
> >   * Shared mappings implemented 30.11.1994. It's not fully working yet,
> > @@ -120,6 +123,7 @@ void __remove_from_page_cache(struct page *page)
> >  	page->mapping = NULL;
> >  	mapping->nrpages--;
> >  	__dec_zone_page_state(page, NR_FILE_PAGES);
> > +	trace_filemap_remove_from_page_cache(mapping, page->index);
> 
> __remove_from_page_cache() is passed struct page.
> Why don't you use struct page
> 
> and, this mean
>   - the page have been removed from mapping.
>   - vmstate have been decremented.
>   - but, the page haven't been uncharged from memcg.
> 
> Why?
> 
> 
> >  	BUG_ON(page_mapped(page));
> >  	mem_cgroup_uncharge_cache_page(page);
> >  
> > @@ -475,6 +479,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
> >  		if (likely(!error)) {
> >  			mapping->nrpages++;
> >  			__inc_zone_page_state(page, NR_FILE_PAGES);
> > +			trace_filemap_add_to_page_cache(mapping, offset);
> 
> Why do you select this line?
> In general, trace point calling under spin lock grabbing is a bit problematic.
> 
> 
> >  		} else {
> >  			page->mapping = NULL;
> >  			mem_cgroup_uncharge_cache_page(page);
> > 
> 
> And, both function is freqentlly called one.
> I worry about performance issue. can you prove no degression?


It would be very hard to prove. Tracepoints are very cheap in that they only
add the overhead of a single branch check while off.

But are there some plans about writing a tracer or so for pagecache?

 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

