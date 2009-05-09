Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZEIWkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZEIWkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 18:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZEIWkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 18:40:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZEIWkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 18:40:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=p9YZ2luFit3JlAbSx5GpSvqsdtexujs/EKZIIGhuBn3wP8/hk7OVWuFkmYqB2jEGG
	wMJ8HMnL0WzNZhXOI0DzA==
Date: Sat, 9 May 2009 15:39:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905092337.39906.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905091536250.6272@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905090155.44635.rjw@sisk.pl> <alpine.DEB.2.00.0905091415310.1124@chino.kir.corp.google.com> <200905092337.39906.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009, Rafael J. Wysocki wrote:

> > This has been changed in the latest mmotm with Mel's page alloactor 
> > patches (and I think yours should be based on mmotm).  Specifically, 
> > page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch.
> > 
> > Before his patchset, zonelists that had ZONE_OOM_LOCKED set for at least 
> > one of their zones would unconditionally goto restart.  Now, if
> > order > PAGE_ALLOC_COSTLY_ORDER, it gives up and returns NULL.  Otherwise, 
> > it does goto restart.
> > 
> > So if your allocation has order > PAGE_ALLOC_COSTLY_ORDER,
> 
> It doesn't.  All of my allocations are of order 0.
> 

All order 0 allocations are implicitly __GFP_NOFAIL and will loop 
endlessly unless they can't block.  So if you want to simply prohibit the 
oom killer from being invoked and not change the retry behavior, setting 
ZONE_OOM_LOCKED for all zones will do that.  If your machine hangs, it 
means nothing can be reclaimed and you can't free memory via oom killing, 
so there's nothing else the page allocator can do.
