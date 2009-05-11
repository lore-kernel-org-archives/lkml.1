Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbZEKTqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbZEKTqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZEKTpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:45:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41608 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZEKTpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:45:51 -0400
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       San Mehat <san@android.com>, Arve Hjonnevag <arve@android.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0905111159130.23739@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com>
	 <20090511104310.B9C1.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0905110143190.24726@chino.kir.corp.google.com>
	 <1242057793.8109.34342.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0905111159130.23739@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 12:45:24 -0700
Message-Id: <1242071124.8109.35426.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 12:09 -0700, David Rientjes wrote:
> On Mon, 11 May 2009, Dave Hansen wrote:
> > Could you explain a little more about why you think this scenario works
> > for you?  Are large contiguous areas of memory pinned by the task
> > getting which you want to get killed?  Why wasn't swapping effective
> > against this task?  Was the task itself taking up a large portion of
> > total memory?
> 
> We frequently do cpuset-constrained oom kills where the lionshare of 
> memory on a set of nodes is allocated by a single task or a group of 
> threads all sharing the same memory.  Swapping is largely effective but at 
> this point in the code path it's obviously not making any progress in 
> freeing pages.

So, there are three conditions that have to be met before we get to this
behavior:
1. order > PAGE_ALLOC_COSTLY_ORDER
2. __GFP_NOFAIL set
3. no progress being made

The two hunks of this patch really do different things to me.
Personally, I'd split them up.  

This patch's first hunk effectively says, "When we have __GFP_NOFAIL
set, it is now OK to OOM tasks for 'order > PAGE_ALLOC_COSTLY_ORDER'".
That's a little bit goofy to me.  Either OOMs help large-order allocs or
they don't.  __GFP_NOFAIL doesn't change how effective an OOM is.

> So this change fixes two issues:
> 
>  - __GFP_NOFAIL allocations should not be allowed to return NULL, and
> 
>  - we should prevent looping endlessly in the page allocator if reclaim
>    cannot free the requisite amount of memory.
> 
> There is no reason that the oom killer would not be able to kill a task 
> that could free 64K of contiguous memory, especially for those that 
> mlock() their memory.  You could argue that any __GFP_NOFAIL allocation 
> above order 3 is insane and should not kill tasks, but that's an issue 
> higher up the stack.  If you'd like to identify such instances, we could 
> emit a warning message here and a stack trace.

Yeah, adding a new warning or enhancing the existing "page allocation
failure" warning would be nice.

Aren't you a bit worried that people will keep adding new 'goto nopage'
cases in here?  Would it be more effective to just put a:

        if (gfp_mask & __GFP_NOFAIL)
                goto restart;

at the very end of the function?  That should keep people from screwing
this up in the future a bit better.

Thanks for going to the trouble of trying to sort all this code out a
bit better.  I know it is a mess.  Could you try and beef up the
descriptions a bit in the next pass?  Some of the stuff about where
you're encountering these situations would be really helpful, especially
with 'git blame' these days.  

-- Dave

