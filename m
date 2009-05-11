Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbZEKVce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbZEKVce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbZEKVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:32:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45894 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685AbZEKVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:32:25 -0400
Date: Mon, 11 May 2009 22:32:22 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
Message-ID: <20090511213222.GA13076@csn.ul.ie>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com> <20090511162900.f372edd1.minchan.kim@barrios-desktop> <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com> <28c262360905110212j9867b79wd8d90b16f6f196be@mail.gmail.com> <28c262360905110421g1b079f2cr798ca95adfb8ee45@mail.gmail.com> <20090511133840.GA11624@csn.ul.ie> <28c262360905110700p68f3de35xf0a1d52d2ccfd968@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262360905110700p68f3de35xf0a1d52d2ccfd968@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:00:44PM +0900, Minchan Kim wrote:
> Hi, Mel.
> 
> On Mon, May 11, 2009 at 10:38 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > On Mon, May 11, 2009 at 08:21:21PM +0900, Minchan Kim wrote:
> >> On Mon, May 11, 2009 at 6:12 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> >> > On Mon, May 11, 2009 at 5:40 PM, David Rientjes <rientjes@google.com> wrote:
> >> >> On Mon, 11 May 2009, Minchan Kim wrote:
> >> >>
> >> >>> Hmm.. if __alloc_pages_may_oom fail to allocate free page due to order > PAGE_ALLOC_COSTRY_ORDER,
> >> >>>
> >> >>> It will go to nopage label in __alloc_pages_slowpath.
> >> >>> Then it will show the page allocation failure warning and will return.
> >> >>> Retrying depends on caller.
> >> >>>
> >> >>
> >> >> Correct.
> >> >>
> >> >>> So, I think it won't loop forever.
> >> >>> Do I miss something ?
> >> >>>
> >> >>
> >> >> __GFP_NOFAIL allocations shouldn't fail, that's the point of the gfp flag.
> >> >> So failing without attempting to free some memory is the wrong thing to
> >> >> do.
> >> >
> >> > Thanks for quick reply.
> >> > I was confused by your description.
> >> > I thought you suggested we have to prevent loop forever.
> >> >
> >> >>
> >> >>> In addition, the OOM killer can help for getting the high order pages ?
> >> >>>
> >> >>
> >> >> Sure, if it selects a task that will free a lot of memory, which is it's
> >> >> goal.
> >> >>
> >> >
> >> > How do we know any task have a lot of memory ?
> >> > If we select wrong task and kill one ?
> >> >
> >> > I have a concern about innocent task.
> >>
> >> Now, I look over __out_of_memory.
> >> For selecting better tasks in case of PAGE_ALLOC_COSTRY_ORDER, How
> >> about increasing score of task which have VM_HUGETLB vma in badness ?
> >>
> >
> > That is unjustified. It penalises a process even if it only allocated one
> > hugepage and it is not a reflection of how much memory the process is using
> > or how badly behaved it is.
> > Even worse, if the huge page was allocated from the static hugepage pool then
> > the hugepages are freed to the hugepage pool and not the page allocator when
> > the process is killed. This means that killing a process using hugepages
> > does not necessarily help applications requiring more memory unless they
> > also want hugepages. However, a hugepage allocation will not trigger the
> > OOM killer so killing processes using hugepages still does not help.
> 
> Thanks for pointing me.
> In fact, I expect your great answer. :)
> 
> So, how do we prevent innocent task killing for allocation of high order page ?

Not by targetting users of hugepages anyway, that's for sure. My expectation
normally for a high-order allocation failing is for the caller to recover
from the situation gracefully. In the event it can't, the caller is running
a major risk and I would question why it's __GFP_NOFAIL.

I recognise that this is not much of an answer. I haven't read all the
related threads so I don't know what application is depending so heavily on
high-order allocations succeeding that it warrented __GFP_NOFAIL and couldn't
be addressed in some other fashion like vmalloc().

Killing a process allocating huges will only help another process requiring
hugepages. Unless dynamic hugepage pool resizing was used, the pages freed
are not usable for normal high-order allocations so teaching the OOM
killer to target those processes is unlikely to help solve whatever
problem is being addressed.

> I think it is trade off. but at least, we have been prevent it until now.
> 
> But this patch increases the probability of innocent task killing.

I think any increase in probability is minimal. When it gets down to it, there
should be zero costly-high-order allocations that are also __GFP_NOFAIL. If
anything, the patch would show up as OOM-kill pointing out what caller needs to
be fixed as opposed to having apparently infinite loops in the page allocator.

> Is GFP_NOFAIL's early bailout more important than killing of innocent task ?
> 

In my opinion, yes, in the sense that a OOM-kill report is easier to diagnose
than an infinite loop.

> I am not sure.
> 
> > --
> > Mel Gorman
> > Part-time Phd Student                          Linux Technology Center
> > University of Limerick                         IBM Dublin Software Lab
> >
> 
> 
> 
> -- 
> Kinds regards,
> Minchan Kim
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
