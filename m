Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZF2Xfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZF2Xfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZF2Xfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:35:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8803 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbZF2Xfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:35:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hMHBVyhpmA+YTs6zYr1oWemwCKf5toSFuwpwJ98pSXW4XctfpuJ2hDZPqg5dhqwsn
	geT4nMnng5KBDqJbetUrw==
Date: Mon, 29 Jun 2009 16:35:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090629153007.GD5065@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com>
References: <4A426825.80905@cs.helsinki.fi> <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
 <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org>
 <20090629153007.GD5065@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Mel Gorman wrote:

> page-allocator: Ensure that processes that have been OOM killed exit the page allocator
> 
> Processes that have been OOM killed set the thread flag TIF_MEMDIE. A
> process such as this is expected to exit the page allocator but in the
> event it happens to have set __GFP_NOFAIL, it potentially loops forever.
> 

That's not the expected behavior for TIF_MEMDIE, although your patch 
certainly changes that.

Your patch is simply doing

	if (test_thread_flag(TIF_MEMDIE))
		gfp_mask |= __GFP_NORETRY;

in the slowpath.

TIF_MEMDIE is supposed to allow allocations to succeed, not automatically 
fail, so that it can quickly handle its SIGKILL without getting blocked in 
the exit path seeking more memory.

> This patch checks TIF_MEMDIE when deciding whether to loop again in the
> page allocator. Such a process will now return NULL after direct reclaim
> and OOM killing have both been considered as options. The potential
> problem is that a __GFP_NOFAIL allocation can still return failure so
> callers must still handle getting returned NULL.
> 

All __GFP_NOFAIL allocations should ensure that alloc_pages() never 
returns NULL.  Although it's unfortunate, that's the requirement that 
callers have been guaranteed and until they are fixed, the page allocator 
should respect it.

I disagree with this change because it unconditionally fails allocations 
when a task has been oom killed, a scenario which should be the _highest_ 
priority for allocations to succeed since it leads to future memory 
freeing.

Additionally, this will fail all GFP_ATOMIC allocations for oom killed 
tasks if allocating without watermarks fails although pdflush may 
concurrently be doing writeback or other allocation attempts are invoking 
direct reclaim.
