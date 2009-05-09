Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZEIVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZEIVXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZEIVW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 17:22:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4857 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZEIVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 17:22:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pPmRrf4e1viZEZjMVzZgzRU3M9MdFvKc+Quin0WMgqzyOBPbGxodhWCLEFTiMwsBF
	l7HD38v1ZoIzshh9BGfdQ==
Date: Sat, 9 May 2009 14:22:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905090155.44635.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905091415310.1124@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com> <200905090155.44635.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009, Rafael J. Wysocki wrote:

> > All of your tasks are in D state other than kthreads, right?  That means 
> > they won't be in the oom killer (thus no zones are oom locked), so you can 
> > easily do this
> > 
> > 	struct zone *z;
> > 	for_each_populated_zone(z)
> > 		zone_set_flag(z, ZONE_OOM_LOCKED);
> > 
> > and then
> > 
> > 	for_each_populated_zone(z)
> > 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> > 
> > The serialization is done with trylocks so this will never invoke the oom 
> > killer because all zones in the allocator's zonelist will be oom locked.
> 
> Well, that might have been a good idea if it actually had worked. :-(
> 
> > Why does this not work for you?
> 
> If I set image_size to something below "hard core working set" +
> totalreserve_pages, preallocate_image_memory() hangs the
> box (please refer to the last patch I sent,
> http://patchwork.kernel.org/patch/22423/).
> 

This has been changed in the latest mmotm with Mel's page alloactor 
patches (and I think yours should be based on mmotm).  Specifically, 
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch.

Before his patchset, zonelists that had ZONE_OOM_LOCKED set for at least 
one of their zones would unconditionally goto restart.  Now, if
order > PAGE_ALLOC_COSTLY_ORDER, it gives up and returns NULL.  Otherwise, 
it does goto restart.

So if your allocation has order > PAGE_ALLOC_COSTLY_ORDER, using the 
ZONE_OOM_LOCKED approach to locking out the oom killer will work just fine 
in mmotm.
