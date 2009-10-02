Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZJBJup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZJBJup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbZJBJup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:50:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbZJBJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:50:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GUJ1IYq5Zgu5VDZn0uhQb0Z3ma6hw/uodE2Ni5Hv26GRfSCoA25HtZSbVHUwo2Y08
	a4JNmEeUqfek9Lql/NwFA==
Date: Fri, 2 Oct 2009 02:50:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Neil Brown <neilb@suse.de>
cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 04/31] mm: tag reseve pages
In-Reply-To: <19141.34038.274185.392663@notabene.brown>
Message-ID: <alpine.DEB.1.00.0910020243190.22702@chino.kir.corp.google.com>
References: <1254405917-15796-1-git-send-email-sjayaraman@suse.de> <alpine.DEB.1.00.0910011407390.32006@chino.kir.corp.google.com> <19141.34038.274185.392663@notabene.brown>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Neil Brown wrote:

> Normally if zones are above their watermarks, page->reserve will not
> be set.
> This is because __alloc_page_nodemask (which seems to be the main
> non-inline entrypoint) first calls get_page_from_freelist with
> alloc_flags set to ALLOC_WMARK_LOW|ALLOC_CPUSET.
> Only if this fails does __alloc_page_nodemask call
> __alloc_pages_slowpath which potentially sets ALLOC_NO_WATERMARKS in
> alloc_flags.
> 
> So page->reserved being set actually tells us:
>   PF_MEMALLOC or GFP_MEMALLOC were used, and
>   a WMARK_LOW allocation attempt failed very recently
> 
> which is close enough to "the emergency reserves were used" I think.
> 

There're a couple cornercases for GFP_ATOMIC, though:

 - it isn't restricted by cpuset, so ALLOC_CPUSET will never get set for 
   the slowpath allocs and may very well allow the allocation to succeed 
   in zones far above their min watermark.

 - it allows for allocating beyond the min watermark in allowed zones
   simply by setting ALLOC_HARDER; these types of "reserve" allocations
   wouldn't be marked as page->reserve with your patches if
   ALLOC_NO_WATERMARKS wasn't set because of the allocation context.

The second one is debatable whether it fits your definition of reserve or 
not, but there's an inconsistency if it doesn't because the allocation may 
succeed in "no watermark" context (for example, in hard irq context) even 
though that privilege wasn't necessary to successfully allocate: perhaps 
it only needed ALLOC_HARDER.
