Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbZEKUVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbZEKUVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZEKUVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:21:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61793 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZEKUVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:21:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=A2I828nBo8QPah6FUWPLO3WUl9M5N07ihWlJdAnMG3S9khcMl3KitAtnCZ1PmBFQR
	mOW5ILIsVzyozoUWQRnXg==
Date: Mon, 11 May 2009 13:21:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       San Mehat <san@android.com>, Arve Hjonnevag <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <1242071124.8109.35426.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905111313120.27577@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com> <20090511104310.B9C1.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905110143190.24726@chino.kir.corp.google.com>
 <1242057793.8109.34342.camel@localhost.localdomain> <alpine.DEB.2.00.0905111159130.23739@chino.kir.corp.google.com> <1242071124.8109.35426.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Dave Hansen wrote:

> So, there are three conditions that have to be met before we get to this
> behavior:
> 1. order > PAGE_ALLOC_COSTLY_ORDER
> 2. __GFP_NOFAIL set
> 3. no progress being made
> 
> The two hunks of this patch really do different things to me.
> Personally, I'd split them up.  
> 
> This patch's first hunk effectively says, "When we have __GFP_NOFAIL
> set, it is now OK to OOM tasks for 'order > PAGE_ALLOC_COSTLY_ORDER'".
> That's a little bit goofy to me.  Either OOMs help large-order allocs or
> they don't.  __GFP_NOFAIL doesn't change how effective an OOM is.
> 

Right, but the problem is that we don't know what the oom killer did 
(until you get to patches 10 and 11 in this series).  It would be easier 
to use the __GFP_REPEAT retry logic to determine whether to continue 
looping, but we currently bypass that because reclaim failed and we don't 
know what the oom killer did.  My later patches change that, so 
__GFP_REPEAT actually works in this case.

> Yeah, adding a new warning or enhancing the existing "page allocation
> failure" warning would be nice.
> 

Ok, it's a good idea that I never considered.

> Aren't you a bit worried that people will keep adding new 'goto nopage'
> cases in here?  Would it be more effective to just put a:
> 
>         if (gfp_mask & __GFP_NOFAIL)
>                 goto restart;
> 
> at the very end of the function?  That should keep people from screwing
> this up in the future a bit better.
> 

goto nopage is the only thing we have to worry about since the retry logic 
does get invoked otherwise (and any order less than 
PAGE_ALLOC_COSTLY_ORDER is actually implicitly __GFP_NOFAIL there, 
regardless of reclaim progress).  We do actually need to bypass that logic 
for a couple of cases (GFP_THISNODE and GFP_ATOMIC) where reclaim is 
inherently denied.  We lack BUG_ON()'s for such cases undoubtedly because 
of the performance impact in the very hot path.

> Thanks for going to the trouble of trying to sort all this code out a
> bit better.  I know it is a mess.  Could you try and beef up the
> descriptions a bit in the next pass?  Some of the stuff about where
> you're encountering these situations would be really helpful, especially
> with 'git blame' these days.  
> 

Ok, thanks for the comments.
