Return-Path: <linux-kernel-owner+w=401wt.eu-S934068AbXLNWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbXLNWv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXLNWvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:51:17 -0500
Received: from phunq.net ([64.81.85.152]:54788 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751563AbXLNWvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:51:16 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 03/29] mm: slb: add knowledge of reserve pages
Date: Fri, 14 Dec 2007 14:51:09 -0800
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071214153907.770251000@chello.nl> <20071214154439.242195000@chello.nl>
In-Reply-To: <20071214154439.242195000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141451.09500.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 07:39, Peter Zijlstra wrote:
> Restrict objects from reserve slabs (ALLOC_NO_WATERMARKS) to
> allocation contexts that are entitled to it. This is done to ensure
> reserve pages don't leak out and get consumed.

Tighter definitions of "leak out" and "get consumed" would be helpful 
here.  As I see it, the chain of reasoning is:

  * Any MEMALLOC mode allocation must have come from a properly
   throttled path and  has a finite lifetime that must eventually
   produce writeout  progress.

  * Since the transaction that made the allocation was throttled and
    must have a finite lifetime, we  know that it must eventually return
    the resources it consumed to the appropriate resource pool.

Now, I think what you mean by "get consumed" and "leak out" is: "become 
pinned by false sharing with other allocations that do not guarantee 
that they will be returned to the resource pool".  We can say "pinned" 
for short.

So you are attempting to prevent slab pages from becoming pinned by 
users that do not obey the reserve management rules, which I think your 
approach achieves.  However...

Note that false sharing of slab pages is still possible between two 
unrelated writeout processes, both of which obey rules for their own 
writeout path, but the pinned combination does not.  This still leaves 
a hole through which a deadlock may slip.

My original solution was simply to allocate a full page when drawing 
from the memaloc reserve, which may use a tad more reserve, but makes 
it possible to prove the algorithm correct.

Regards,

Daniel
