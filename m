Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZEDQpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZEDQpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZEDQoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:44:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbZEDQox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:44:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IwHz/9AdqVWX9ctTkwTZprTUNdj+YJqWOZ/YPDAbeokpWqvrdhcS7ydGxEYj7r87N
	vo+FxIM5GjwLpZJ6Sqb0Q==
Date: Mon, 4 May 2009 09:44:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Wu Fengguang <fengguang.wu@intel.com>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905041702.23291.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905040939400.10707@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905040210.10153.rjw@sisk.pl> <alpine.DEB.2.00.0905031734190.24114@chino.kir.corp.google.com> <200905041702.23291.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Rafael J. Wysocki wrote:

> > > Index: linux-2.6/mm/page_alloc.c
> > > ===================================================================
> > > --- linux-2.6.orig/mm/page_alloc.c
> > > +++ linux-2.6/mm/page_alloc.c
> > > @@ -1620,7 +1620,8 @@ nofail_alloc:
> > >  		}
> > >  
> > >  		/* The OOM killer will not help higher order allocs so fail */
> > > -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> > > +		if (order > PAGE_ALLOC_COSTLY_ORDER ||
> > > +				(gfp_mask & __GFP_NO_OOM_KILL)) {
> > >  			clear_zonelist_oom(zonelist, gfp_mask);
> > >  			goto nopage;
> > >  		}
> > 
> > This is inconsistent because __GFP_NO_OOM_KILL now implies __GFP_NORETRY 
> > (the "goto nopage" above), but only for allocations with __GFP_FS set and 
> > __GFP_NORETRY clear.
> 
> Well, what would you suggest?
> 

A couple things:

 - rebase this on mmotm so that it doesn't conflict with Mel Gorman's page
   allocator speedup changes, and

 - avoid the final call to get_page_from_freelist() for 
   !(gfp_mask & __GFP_NO_OOM_KILL) by adding a check for it alongside 
   (gfp_mask & __GFP_FS) and !(gfp_mask & __GFP_NORETRY) because it should
   really only catch parallel oom killings which won't happen in your 
   suspend case since it uses ALLOC_WMARK_HIGH.

The latter is important to avoid unnecessary dependencies among low-level 
__GFP_* flags (although all __GFP_NO_OOM_KILL allocations should really 
all be passing __GFP_NORETRY too to avoid relying too heavily on direct 
reclaim).
