Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZI3Xu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZI3Xu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZI3Xu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:50:59 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:45330 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754771AbZI3Xu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:50:58 -0400
Date: Wed, 30 Sep 2009 19:45:22 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a
 kmem_cache_cpu
In-Reply-To: <20090930220541.GA31530@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0909301941570.11850@gentwo.org>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie> <1253624054-10882-3-git-send-email-mel@csn.ul.ie> <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com> <20090922135453.GF25965@csn.ul.ie> <84144f020909221154x820b287r2996480225692fad@mail.gmail.com>
 <20090922185608.GH25965@csn.ul.ie> <20090930144117.GA17906@csn.ul.ie> <alpine.DEB.1.10.0909301053550.9450@gentwo.org> <20090930220541.GA31530@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009, Mel Gorman wrote:

> > SLUB avoids that issue by having a "current" page for a processor. It
> > allocates from the current page until its exhausted. It can use fast path
> > logic both for allocations and frees regardless of the pages origin. The
> > node fallback is handled by the page allocator and that one is only
> > involved when a new slab page is needed.
> >
>
> This is essentially the "unqueued" nature of SLUB. It's objective "I have this
> page here which I'm going to use until I can't use it no more and will depend
> on the page allocator to sort my stuff out". I have to read up on SLUB up
> more to see if it's compatible with SLQB or not though. In particular, how
> does SLUB deal with frees from pages that are not the "current" page? SLQB
> does not care what page the object belongs to as long as it's node-local
> as the object is just shoved onto a LIFO for maximum hotness.

Frees are done directly to the target slab page if they are not to the
current active slab page. No centralized locks. Concurrent frees from
processors on the same node to multiple other nodes (or different pages
on the same node) can occur.

> > SLAB deals with it in fallback_alloc(). It scans the nodes in zonelist
> > order for free objects of the kmem_cache and then picks up from the
> > nearest node. Ugly but it works. SLQB would have to do something similar
> > since it also has the per node object bins that SLAB has.
> >
>
> In a real sense, this is what the patch ends up doing. When it fails to
> get something locally but sees that the local node is memoryless, it
> will check the remote node lists in zonelist order. I think that's
> reasonable behaviour but I'm biased because I just want the damn machine
> to boot again. What do you think? Pekka, Nick?

Look at fallback_alloc() in slab. You can likely copy much of it. It
considers memory policies and cpuset constraints.
