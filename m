Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZDVUcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZDVUcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZDVUcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:32:25 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42250 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZDVUcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:32:25 -0400
Subject: Re: [PATCH 16/22] Do not setup zonelist cache when there is only
	one node
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904221319120.14558@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-17-git-send-email-mel@csn.ul.ie>
	 <alpine.DEB.2.00.0904221319120.14558@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 22 Apr 2009 16:32:19 -0400
Message-Id: <1240432339.22694.64.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 13:24 -0700, David Rientjes wrote:
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
> right before this call to zlc_mark_zone_full()?  This should compile out 
> the remainder of the loop for !CONFIG_NUMA kernels anyway.

Shouldn't it already do that?  NUMA_BUILD is defined as 0 when
!CONFIG_NUMA to avoid #ifdef's in the code while still allowing compiler
error checking in the dead code.

Lee

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
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

