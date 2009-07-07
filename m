Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZGGDiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZGGDiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 23:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZGGDhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 23:37:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZGGDhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 23:37:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cOOrWODBL6Sb5YdXAFWiC9Ff3Hy28CfjTVgmorjCu/WwpR9KuydDZ2Oe7HH4/dd9S
	AWBUKrYhvIuNXsGKw4eOg==
Date: Mon, 6 Jul 2009 20:37:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mitchell Erblich <erblichs@earthlink.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Re : .... get_page_from_freelist : MInority Suggestion to accept
 GFP_NOFAIL accept during boot
In-Reply-To: <3DE21B02-7ABA-4E56-961C-1DFB608DBE43@earthlink.net>
Message-ID: <alpine.DEB.2.00.0907062032450.29086@chino.kir.corp.google.com>
References: <61448F53-1F7A-47EF-AAF3-CB2A46AB8009@earthlink.net> <alpine.DEB.2.00.0907030155250.13657@chino.kir.corp.google.com> <3DE21B02-7ABA-4E56-961C-1DFB608DBE43@earthlink.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Mitchell Erblich wrote:

> David,
> 
> 		The web page http://lkml.indiana.edu/hypermail/linux/kernel/
> 
> 		Looking at the thread of emails on June 24 at 11:07:23
> 		upcoming kerneloops.org item: get_page_from_freelist
> 
> 		We have code from Arjan de Van
> 
> it's this warning in mm/page_alloc.c:
> 
> * __GFP_NOFAIL is not to be used in new code.
> *
> * All __GFP_NOFAIL callers should be fixed so that they
> * properly detect and handle allocation failures.
> *
> * We most definitely don't want callers attempting to
> * allocate greater than single-page units with
> * __GFP_NOFAIL.
> */
> WARN_ON_ONCE(order > 0);
> 

 [ That's actually Andrew's code and comment, which has since been changed 
   to

	WARN_ON_ONCE(order > 1);

   by Linus. ]

Your suggestion to revert this "deprecation" doesn't make sense, though, 
given the workarounds I mentioned earlier:

> On Jul 3, 2009, at 2:01 AM, David Rientjes wrote:
> 
> > I'm confused by your request because all allocations with orders under
> > PAGE_ALLOC_COSTLY_ORDER are inherently __GFP_NOFAIL and those that are not
> > can easily implement the same behavior in the caller:
> > 
> > 	struct page *page;
> > 	do {
> > 		page = alloc_pages(...);
> > 	} while (!page);
> > 
> > Hopefully something could be done to ensure the next call to alloc_pages()
> > would be more likely to succeed, but __GFP_NOFAIL doesn't provide that
> > anyway.

That means anything that less than or equal to PAGE_ALLOC_COSTLY_ORDER 
(order-3 allocations) will already loop endlessly, regardless of whether 
__GFP_NOFAIL is passed to the page allocator or not.  Secondly, you can 
use my code above to replicate the exact behavior of __GFP_NOFAIL in the 
caller.

In other words, the page allocator doesn't need to implement any special 
handling for __GFP_NOFAIL.
