Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZFYUMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZFYUMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZFYUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:12:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbZFYUMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:12:23 -0400
Date: Thu, 25 Jun 2009 13:11:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090625194423.GB6472@mit.edu>
Message-ID: <alpine.LFD.2.01.0906251259430.3605@localhost.localdomain>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, Theodore Tso wrote:
> 
> Never mind, stupid question; I hit the send button before thinking
> about this enough.  Obviously we should try without GFP_ATOMIC so the
> allocator can try to release some memory.  So maybe the answer for
> filesystem code where the alternative to allocator failure is
> remounting the root filesystem read-only or panic(), should be:
> 
> 1)  Try to do the allocation GFP_NOFS.

Well, even with NOFS, the kernel will still do data writeout that can be 
done purely by swapping. NOFS is really about avoiding recursion from 
filesystems.

So you might want to try GFP_NOIO, which will mean that the kernel will 
try to free memory that needs no IO at all. This also protects from 
recursion in the IO path (ie block layer request allocation etc).

That said, GFP_ATOMIC may be better than both in practice, if only because 
it might be better at balancing memory usage (ie too much "NOIO" might 
result in the kernel aggressively dropping clean page-cache pages, since 
it cannot drop dirty ones).

Note the "might". It probably doesn't matter in practice, since the bulk 
of all allocations should always hopefully be GFP_KERNEL or GFP_USER.

> 2)  Then try GFP_ATOMIC

The main difference between NOIO and ATOMIC is

 - ATOMIC never tries to free _any_ kind of memory, since it doesn't want 
   to take the locks, and cannot enable interrupts.

 - ATOMIC has the magic "high priority" bit set that means that you get to 
   dip into critical memory resources in order to satisfy the memory 
   request.

Whether these are important to you or not, I dunno. I actually suspect 
that we might want a combination of "high priority + allow memory 
freeing", which would be

	#define GFP_CRITICAL (__GFP_HIGH | __GFP_WAIT)

and might be useful outside of interrupt context for things that _really_ 
want memory at all costs.

		Linus
