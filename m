Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZDWATf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZDWATf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZDWATN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:19:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38719 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbZDWATM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:19:12 -0400
Date: Thu, 23 Apr 2009 01:19:08 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 16/22] Do not setup zonelist cache when there is only
	one node
Message-ID: <20090423001907.GB26643@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-17-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0904221319120.14558@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904221319120.14558@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:24:26PM -0700, David Rientjes wrote:
> On Wed, 22 Apr 2009, Mel Gorman wrote:
> 
> > There is a zonelist cache which is used to track zones that are not in
> > the allowed cpuset or found to be recently full. This is to reduce cache
> > footprint on large machines. On smaller machines, it just incurs cost
> > for no gain. This patch only uses the zonelist cache when there are NUMA
> > nodes.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> > ---
> >  mm/page_alloc.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 7f45de1..e59bb80 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1467,8 +1467,11 @@ this_zone_full:
> >  		if (NUMA_BUILD)
> >  			zlc_mark_zone_full(zonelist, z);
> 
> If zonelist caching is never used for UMA machines, why should they ever 
> call zlc_mark_zone_full()?  It will always dereference 
> zonelist->zlcache_ptr and immediately return without doing anything.
> 
> Wouldn't it better to just add
> 
> 	if (num_online_nodes() == 1)
> 		continue;
> 

num_online_nodes() is actually a really heavy function. It calls hweight
on a bitmap which is probably why it's not happening already. There is a
nr_online_nodes later in the patchset though. With nr_online_nodes, it's
a good idea to avoid a function call so I've taken note to do that patch
in pass 2.

Thanks

> right before this call to zlc_mark_zone_full()?  This should compile out 
> the remainder of the loop for !CONFIG_NUMA kernels anyway.
> 
> >  try_next_zone:
> > -		if (NUMA_BUILD && !did_zlc_setup) {
> > -			/* we do zlc_setup after the first zone is tried */
> > +		if (NUMA_BUILD && !did_zlc_setup && num_online_nodes() > 1) {
> > +			/*
> > +			 * we do zlc_setup after the first zone is tried but only
> > +			 * if there are multiple nodes make it worthwhile
> > +			 */
> >  			allowednodes = zlc_setup(zonelist, alloc_flags);
> >  			zlc_active = 1;
> >  			did_zlc_setup = 1;
> > -- 
> > 1.5.6.5
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
