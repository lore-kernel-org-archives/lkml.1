Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbZEGVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbZEGVha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZEGVhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:37:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZEGVhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:37:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Thu, 7 May 2009 23:36:10 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090507135615.e7db550d.akpm@linux-foundation.org> <alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905072336.11383.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, David Rientjes wrote:
> On Thu, 7 May 2009, Andrew Morton wrote:
> 
> > > > All of your tasks are in D state other than kthreads, right?  That means 
> > > > they won't be in the oom killer (thus no zones are oom locked), so you can 
> > > > easily do this
> > > > 
> > > > 	struct zone *z;
> > > > 	for_each_populated_zone(z)
> > > > 		zone_set_flag(z, ZONE_OOM_LOCKED);
> > > > 
> > > > and then
> > > > 
> > > > 	for_each_populated_zone(z)
> > > > 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> > > > 
> > > > The serialization is done with trylocks so this will never invoke the oom 
> > > > killer because all zones in the allocator's zonelist will be oom locked.
> > > > 
> > > > Why does this not work for you?
> > > 
> > > Well, it might work too, but why are you insisting?  How's it better than
> > > __GFP_NO_OOM_KILL, actually?
> > > 
> > > Andrew, what do you think about this?
> > 
> > I don't think I understand the proposal.  Is it to provide a means by
> > which PM can go in and set a state bit against each and every zone?  If
> > so, that's still a global boolean, only messier.
> > 
> 
> Why can't it be global while preallocating memory for hibernation since 
> nothing but kthreads could allocate at this point and if the system is oom 
> then the oom killer wouldn't be able to do anything anyway since it can't 
> kill them?
> 
> The fact is that _all_ allocations here are implicitly __GFP_NO_OOM_KILL 
> whether it specifies it or not since the oom killer would simply kill a 
> task in D state which can't exit or free memory and subsequent allocations 
> would make the oom killer a no-op because there's an eligible task with 
> TIF_MEMDIE set.  The only thing you're saving with __GFP_NO_OOM_KILL is 
> calling the oom killer in a first place and killing an unresponsive task 

That's exactly what we're trying to do.  We don't want tasks to get killed just
because we're freeing memory for hibernation image.

> but that would have to happen anyway when thawed since the system is oom 
> (or otherwise lockup for GFP_KERNEL with order < PAGE_ALLOC_COSTLY_ORDER).

Are you sure?  The image memory is freed before thawing tasks.
