Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbZEGV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbZEGV5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZEGV5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:57:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757585AbZEGV5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:57:03 -0400
Date: Thu, 7 May 2009 14:50:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: rjw@sisk.pl, fengguang.wu@intel.com, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090507145041.9b59f4eb.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905072218.50782.rjw@sisk.pl>
	<alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
	<200905072238.14558.rjw@sisk.pl>
	<20090507135615.e7db550d.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 14:25:23 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

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

- globals are bad

- the standard way of controlling memory allocator behaviour is via
  the gfp_t.  Bypassing that is an unusual step and needs a higher
  level of justification, which I'm not seeing here.

- if we do this via an unusual global, we reduce the chances that
  another subsytem could use the new feature.

  I don't know what subsytem that might be, but I bet they're out
  there.  checkpoint-restart, virtual machines, ballooning memory
  drivers, kexec loading, etc.

> The fact is that _all_ allocations here are implicitly __GFP_NO_OOM_KILL 
> whether it specifies it or not since the oom killer would simply kill a 
> task in D state which can't exit or free memory and subsequent allocations 
> would make the oom killer a no-op because there's an eligible task with 
> TIF_MEMDIE set.  The only thing you're saving with __GFP_NO_OOM_KILL is 
> calling the oom killer in a first place and killing an unresponsive task 
> but that would have to happen anyway when thawed since the system is oom 
> (or otherwise lockup for GFP_KERNEL with order < PAGE_ALLOC_COSTLY_ORDER).

All the above is specific to the PM application only, when userspace
tasks are stopped.


It might well end up that stopping userspace (beforehand or before
oom-killing) is a hard requirement for reliably disabling the
oom-killer.  Because the __GFP_NO_OOM_KILL user will be safe, but
random other allocations from other tasks will not be.  So perhaps we
_do_ need a global, and random userspace processes should test and
sleep upon that global if they're heading in the direction of the
oom-killer.
