Return-Path: <linux-kernel-owner+w=401wt.eu-S965118AbXFFGmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118AbXFFGmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964819AbXFFGms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:42:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44777 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbXFFGms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:42:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=MLWKKADgNBoXuWRONJrEv6JjkOH2U1LP6gboUu5NUozWPaBNdQCrJ2CoEyfsFuSvi
	64bbmBE6Z9wDigQyFV0IA==
Date: Tue, 5 Jun 2007 23:42:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <1181110846.7348.154.camel@twins>
Message-ID: <alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <1181110846.7348.154.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Peter Zijlstra wrote:

> > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > --- a/kernel/cpuset.c
> > +++ b/kernel/cpuset.c
> > @@ -2431,12 +2431,6 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
> >  	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
> >  	if (node_isset(node, current->mems_allowed))
> >  		return 1;
> > -	/*
> > -	 * Allow tasks that have access to memory reserves because they have
> > -	 * been OOM killed to get memory anywhere.
> > -	 */
> > -	if (unlikely(test_thread_flag(TIF_MEMDIE)))
> > -		return 1;
> >  	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
> >  		return 0;
> >  
> 
> This seems a little pointless, since cpuset_zone_allowed_softwall() is
> only effective with ALLOC_CPUSET, and the ALLOC_NO_WATERMARKS
> allocations opened up by TIF_MEMDIE don't use that.
> 

That's the change.  Memory reserves on a per-zone level would now be used 
with respect to ALLOC_NO_WATERMARKS because TIF_MEMDIE tasks no longer 
have an explicit bypass for them.  If the node is not in the task's 
mems_allowed and it's a __GFP_HARDWALL allocation or if it's neither
PF_EXITING or in the nearest_exclusive_ancestor() of that task's cpuset, 
then we move on to the next zone in get_page_from_freelist().

The problem the patch addresses is that, as you mentioned, tasks with 
TIF_MEMDIE have an explicit bypass over using any memory reserves and can 
thus, depending on zonelist ordering, allocate first on nodes outside its 
mems_allowed even in the case of an exclusive cpuset before exhausting its 
own memory.  That behavior is wrong.

		David
