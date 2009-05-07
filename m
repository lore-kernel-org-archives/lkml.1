Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbZEGVZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbZEGVZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZEGVZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:25:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZEGVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:25:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=owFjrNmB7uWqTgNIEZqrBcnn19Ru//Bhiap2gtlHOVcseAmXBE/rU8Vn7z6YiV4rS
	kl+6YorLcqblaDwdq9q0g==
Date: Thu, 7 May 2009 14:25:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <20090507135615.e7db550d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com> <200905072238.14558.rjw@sisk.pl> <20090507135615.e7db550d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Andrew Morton wrote:

> > > All of your tasks are in D state other than kthreads, right?  That means 
> > > they won't be in the oom killer (thus no zones are oom locked), so you can 
> > > easily do this
> > > 
> > > 	struct zone *z;
> > > 	for_each_populated_zone(z)
> > > 		zone_set_flag(z, ZONE_OOM_LOCKED);
> > > 
> > > and then
> > > 
> > > 	for_each_populated_zone(z)
> > > 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> > > 
> > > The serialization is done with trylocks so this will never invoke the oom 
> > > killer because all zones in the allocator's zonelist will be oom locked.
> > > 
> > > Why does this not work for you?
> > 
> > Well, it might work too, but why are you insisting?  How's it better than
> > __GFP_NO_OOM_KILL, actually?
> > 
> > Andrew, what do you think about this?
> 
> I don't think I understand the proposal.  Is it to provide a means by
> which PM can go in and set a state bit against each and every zone?  If
> so, that's still a global boolean, only messier.
> 

Why can't it be global while preallocating memory for hibernation since 
nothing but kthreads could allocate at this point and if the system is oom 
then the oom killer wouldn't be able to do anything anyway since it can't 
kill them?

The fact is that _all_ allocations here are implicitly __GFP_NO_OOM_KILL 
whether it specifies it or not since the oom killer would simply kill a 
task in D state which can't exit or free memory and subsequent allocations 
would make the oom killer a no-op because there's an eligible task with 
TIF_MEMDIE set.  The only thing you're saving with __GFP_NO_OOM_KILL is 
calling the oom killer in a first place and killing an unresponsive task 
but that would have to happen anyway when thawed since the system is oom 
(or otherwise lockup for GFP_KERNEL with order < PAGE_ALLOC_COSTLY_ORDER).
