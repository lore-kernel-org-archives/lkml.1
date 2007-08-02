Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXHBMFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXHBMFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXHBMFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:05:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33857 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXHBMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:05:16 -0400
Date: Thu, 2 Aug 2007 13:05:15 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
Message-ID: <20070802120515.GL21089@ftp.linux.org.uk>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> <alpine.LFD.0.999.0708012051100.3582@woody.linux-foundation.org> <E1IGV6D-0000rM-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IGV6D-0000rM-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 09:27:57AM +0200, Miklos Szeredi wrote:
> > Quite frankly, I suspect you would be better off just instrumenting 
> > "sparse" instead, and matching up the size of the allocation with the type 
> > it gets assigned to.
> 
> But that just can't be done, because kmalloc() doesn't tell us the
> _intent_ of the allocation.

Of course it can be done.  When argument has form sizeof(...), attach
the information about target of pointer to the resulting void *; have
? : between pointer to object and that one warn if types do not match,
? : between void * and that one lose that information, ? : between
two such warn when types do not match.  On assigment-type operations
(assignment, passing argument to function, initializer, return) when
the type of target is pointer to object (and not void *) warn if
types do not match.  Have typeof lose that information.

Not even hard to implement; just let us finish cleaning the lazy examination
logics up first (~5-6 patches away).

FWIW, I object against the original proposal, no matter how you name it.
Reason: we are introducing more magical constructs that have to be known
to human reader in order to parse the damn code.

Folks, this is serious.  _We_ might be used to having in effect a C dialect
with extensions implemented by preprocessor.  That's fine, but for a fresh
reader it becomes a problem; sure, they can dig in include/linux/*.h and
to some extent they clearly have to.  However, it doesn't come for free
and we really ought to keep that in mind - amount of local idioms (and
anything that doesn't look like a normal function call with normal arguments
_does_ become an idiom to be learnt before one can fluently RTFS) is a thing
to watch out for.

IOW, whenever we add to that pile we ought to look hard at whether it's worth
the trouble.
