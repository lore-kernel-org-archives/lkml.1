Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZJFREI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZJFREI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZJFREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:04:08 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51068 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255AbZJFREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:04:07 -0400
Date: Tue, 6 Oct 2009 18:03:33 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 13/20] this_cpu_ops: page allocator conversion
Message-ID: <20091006170333.GE18185@csn.ul.ie>
References: <20091001212521.123389189@gentwo.org> <20091001212600.068637154@gentwo.org> <20091002151437.GP21906@csn.ul.ie> <alpine.DEB.1.10.0910021331020.26189@gentwo.org> <20091005094527.GB12681@csn.ul.ie> <alpine.DEB.1.10.0910051040270.16359@gentwo.org> <alpine.DEB.1.10.0910051055120.16359@gentwo.org> <20091006094544.GC18185@csn.ul.ie> <alpine.DEB.1.10.0910061230170.18309@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910061230170.18309@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 12:34:56PM -0400, Christoph Lameter wrote:
> On Tue, 6 Oct 2009, Mel Gorman wrote:
> 
> > > -	local_irq_save(flags);
> > > -	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> > >  	migratetype = get_pageblock_migratetype(page);
> > >  	set_page_private(page, migratetype);
> > >  	if (unlikely(wasMlocked))
> >
> > Why did you move local_irq_save() ? It should have stayed where it was
> > because VM counters are updated under the lock. Only the this_cpu_ptr
> > should be moving.
> 
> The __count_vm_event()?

and the __dec_zone_page_state within free_page_mlock(). However, it's already
atomic so it shouldn't be a problem.

> VM counters may be incremented in a racy way if
> convenient. x86 usually produces non racy code (and with this patchset
> will always produce non racy code) but f.e. IA64 has always had racy
> updates. I'd rather shorted the irq off section.
> 

The count_vm_event is now racier than it was and no longer symmetric with
the PGALLOC counting which still happens with IRQs disabled. The assymetry
could look very strange if there are a lot more frees than allocs for example
because the raciness between the counters is difference.

While I have no problem as such with the local_irq_save() moving (although
I would like PGFREE and PGALLOC to be accounted both with or without IRQs
enabled), I think it deserves to be in a patch all to itself and not hidden
in an apparently unrelated change.

> See the comment in vmstat.h.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
