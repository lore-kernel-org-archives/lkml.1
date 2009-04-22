Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZDVUeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZDVUeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZDVUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:34:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49921 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZDVUed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:34:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kticdTxqoKuvAhaz1tn8vOcGNEM6TZXfZwou4mH0kS6vnWvaIwXsO6D6qGJJvmksA
	SnHx504TxdE8ohnuEg4cw==
Date: Wed, 22 Apr 2009 13:34:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Mel Gorman <mel@csn.ul.ie>,
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
Subject: Re: [PATCH 16/22] Do not setup zonelist cache when there is only
 one node
In-Reply-To: <1240432339.22694.64.camel@lts-notebook>
Message-ID: <alpine.DEB.2.00.0904221333040.14558@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-17-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0904221319120.14558@chino.kir.corp.google.com> <1240432339.22694.64.camel@lts-notebook>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Lee Schermerhorn wrote:

> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 7f45de1..e59bb80 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1467,8 +1467,11 @@ this_zone_full:
> > >  		if (NUMA_BUILD)
> > >  			zlc_mark_zone_full(zonelist, z);
> > 
> > If zonelist caching is never used for UMA machines, why should they ever 
> > call zlc_mark_zone_full()?  It will always dereference 
> > zonelist->zlcache_ptr and immediately return without doing anything.
> > 
> > Wouldn't it better to just add
> > 
> > 	if (num_online_nodes() == 1)
> > 		continue;
> > 
> > right before this call to zlc_mark_zone_full()?  This should compile out 
> > the remainder of the loop for !CONFIG_NUMA kernels anyway.
> 
> Shouldn't it already do that?  NUMA_BUILD is defined as 0 when
> !CONFIG_NUMA to avoid #ifdef's in the code while still allowing compiler
> error checking in the dead code.
> 

Yeah, but adding the check on num_online_nodes() also prevents needlessly 
calling zlc_mark_zone_full() on CONFIG_NUMA kernels when running on an UMA 
machine.
