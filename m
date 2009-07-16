Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbZGPXoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbZGPXoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933628AbZGPXoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:44:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54093 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933621AbZGPXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:43:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] profile: Suppress warning about large allocations when profile=1 is specified
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20090716103719.GA22499@csn.ul.ie>
References: <20090716100305.9D16.A69D9226@jp.fujitsu.com> <20090716103719.GA22499@csn.ul.ie>
Message-Id: <20090717084206.A8FA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 17 Jul 2009 08:43:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 16, 2009 at 10:12:20AM +0900, KOSAKI Motohiro wrote:
> > > When profile= is used, a large buffer is allocated early at boot. This
> > > can be larger than what the page allocator can provide so it prints a
> > > warning. However, the caller is able to handle the situation so this patch
> > > suppresses the warning.
> > 
> > I'm confused.
> > 
> > Currently caller doesn't handle error return.
> > 
> > ----------------------------------------------------------
> > asmlinkage void __init start_kernel(void)
> > {
> > (snip)
> >         init_timers();
> >         hrtimers_init();
> >         softirq_init();
> >         timekeeping_init();
> >         time_init();
> >         sched_clock_init();
> >         profile_init();           <-- ignore return value
> > ------------------------------------------------------------
> > 
> > and, if user want to use linus profiler, the user should choice select
> > proper bucket size by boot parameter.
> > Currently, allocation failure message tell user about specified bucket size
> > is wrong.
> > I think this patch hide it.
> > 
> 
> Look at what profile_init() itself is doing. You can't see it from the
> patch context but when alloc_pages_exact() fails, it calls vmalloc(). If
> that fails, profiling is just disabled. There isn't really anything the
> caller of profile_init() can do about it and the page allocator doesn't
> need to scream about it.

Indeed. Thanks correct me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> 
> > 
> > > 
> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > ---
> > >  kernel/profile.c |    5 +++--
> > >  1 files changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/profile.c b/kernel/profile.c
> > > index 69911b5..419250e 100644
> > > --- a/kernel/profile.c
> > > +++ b/kernel/profile.c
> > > @@ -117,11 +117,12 @@ int __ref profile_init(void)
> > >  
> > >  	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
> > >  
> > > -	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
> > > +	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL|__GFP_NOWARN);
> > >  	if (prof_buffer)
> > >  		return 0;
> > >  
> > > -	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
> > > +	prof_buffer = alloc_pages_exact(buffer_bytes,
> > > +					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
> > >  	if (prof_buffer)
> > >  		return 0;
> > 
> > 
> > 
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab



