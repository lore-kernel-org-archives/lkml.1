Return-Path: <linux-kernel-owner+w=401wt.eu-S1763040AbZEGWQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763040AbZEGWQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZEGWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:16:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZEGWQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:16:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=n+s8L9ERoU8h/8NeqwuRjy2Le5EYsHBvwPS14pcWCe7gqU7ZC7PpdFeyCs2wpHpUi
	MijNBfiU4/+tWq/dKhmUg==
Date: Thu, 7 May 2009 15:16:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: rjw@sisk.pl, fengguang.wu@intel.com, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <20090507145041.9b59f4eb.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905071508190.2164@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com> <200905072238.14558.rjw@sisk.pl> <20090507135615.e7db550d.akpm@linux-foundation.org>
 <alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com> <20090507145041.9b59f4eb.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Andrew Morton wrote:

> - the standard way of controlling memory allocator behaviour is via
>   the gfp_t.  Bypassing that is an unusual step and needs a higher
>   level of justification, which I'm not seeing here.
> 

The standard way of controlling the oom killer behavior for a zone is via 
the ZONE_OOM_LOCKED bit.

> - if we do this via an unusual global, we reduce the chances that
>   another subsytem could use the new feature.
> 
>   I don't know what subsytem that might be, but I bet they're out
>   there.  checkpoint-restart, virtual machines, ballooning memory
>   drivers, kexec loading, etc.
> 

There's two separate issues here: the use of ZONE_OOM_LOCKED to control 
whether or not to invoke the oom killer for a specific zone (which is 
already its only function), and the fact that in this case we're doing it 
for all zones.  It seems like you're concerned with the latter, but the 
distinction in the hibernation case is that no memory freeing would be 
possible as the result of the oom killer for _all_ zones, so it makes 
sense to lock them all out.

> > The fact is that _all_ allocations here are implicitly __GFP_NO_OOM_KILL 
> > whether it specifies it or not since the oom killer would simply kill a 
> > task in D state which can't exit or free memory and subsequent allocations 
> > would make the oom killer a no-op because there's an eligible task with 
> > TIF_MEMDIE set.  The only thing you're saving with __GFP_NO_OOM_KILL is 
> > calling the oom killer in a first place and killing an unresponsive task 
> > but that would have to happen anyway when thawed since the system is oom 
> > (or otherwise lockup for GFP_KERNEL with order < PAGE_ALLOC_COSTLY_ORDER).
> 
> All the above is specific to the PM application only, when userspace
> tasks are stopped.
> 

I'm not arguing that the only way we can ever implement __GFP_NO_OOM_KILL 
is for the entire system: we can set ZONE_OOM_LOCKED for only the zones in 
the zonelist that are passed to the page allocator.  For this particular 
purpose, that is naturally all zones; for other future use cases it may be 
chosen only to lock out the zones we're allowed to allocate from in that 
context.

> It might well end up that stopping userspace (beforehand or before
> oom-killing) is a hard requirement for reliably disabling the
> oom-killer.

Yes, globally, but future use cases may disable only specific zones such 
as with memory hot-remove.
