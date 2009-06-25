Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZFYUwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZFYUwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZFYUwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:52:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbZFYUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:52:08 -0400
Date: Thu, 25 Jun 2009 13:51:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Rientjes <rientjes@google.com>
cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       penberg@cs.helsinki.fi, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <alpine.DEB.2.00.0906251332060.3086@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.01.0906251339190.3605@localhost.localdomain>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.LFD.2.01.0906251259430.3605@localhost.localdomain> <alpine.LFD.2.01.0906251317570.3605@localhost.localdomain> <alpine.DEB.2.00.0906251332060.3086@chino.kir.corp.google.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, David Rientjes wrote:
>
> On Thu, 25 Jun 2009, Linus Torvalds wrote:
> 
> > It might make more sense to make a __GFP_WAIT allocation set the 
> > ALLOC_HARDER bit _if_ it repeats. 
> 
> This would make sense, but only for !__GFP_FS, since otherwise the oom 
> killer will free some memory on an allowed node when reclaim fails and we 
> don't otherwise want to deplete memory reserves.

So the reason I tend to like the kind of "incrementally try harder" 
approaches is two-fold:

 - it works well for balancing different choices against each other (like 
   on the freeing path, trying to see which kind of memory is most easily 
   freed by trying them all first in a "don't try very hard" mode)

 - it's great for forcing _everybody_ to do part of the work (ie when some 
   new thread comes in and tries to allocate, the new thread starts off 
   with the lower priority, and as such won't steal a page that an older 
   allocator just freed)

And I think that second case is true even for the oom killer case, and 
even for __GFP_FS.

So if people worry about oom, I would suggest that we should not think so 
hard about the GFP_NOFAIL cases (which are relatively small and rare), or 
about things like the above "try harder" when repeating model, but instead 
think about what actually happens during oom: the most common allocations 
will remain to the page allocations for user faults and/or page cache. In 
fact, they get *more* common as you near OOM situation, because you get 
into the whole swap/filemap thrashing situation where you have to re-read 
the same pages over and over again.

So don't worry about NOFS. Instead, look at what GFP_USER and GFP_HIGHUSER 
do. They set the __GFP_HARDWALL bit, and they _always_ check the end 
result and fail gracefully and quickly when the allocation fails.

End result? Realistically, I suspect the _best_ thing we can do is to just 
couple that bit with "we're out of memory", and just do something like

	if (!did_some_progress && (gfp_flags & __GFP_HARDWALL))
		goto nopage;

rather than anything else. And I suspect that if we do this, we can then 
afford to retry very aggressively for the allocation cases that aren't 
GFP_USER - and that may well be needed in order to make progress.

		Linus
