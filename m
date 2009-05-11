Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbZEKUMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbZEKUMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbZEKULy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:11:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34995 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbZEKULx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:11:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=og5RHKOSrnZEJBjpcvC3izS2Va1YPCw2Fn4tuGBQhfr+t/GaV5yvKuFwSsaA89O/M
	a2eMjeXJbx7NPyBvo70eQ==
Date: Mon, 11 May 2009 13:11:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905100103.23815.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905111249170.23739@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905092337.39906.rjw@sisk.pl> <alpine.DEB.2.00.0905091536250.6272@chino.kir.corp.google.com> <200905100103.23815.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009, Rafael J. Wysocki wrote:

> > All order 0 allocations are implicitly __GFP_NOFAIL and will loop 
> > endlessly unless they can't block.  So if you want to simply prohibit the 
> > oom killer from being invoked and not change the retry behavior, setting 
> > ZONE_OOM_LOCKED for all zones will do that.  If your machine hangs, it 
> > means nothing can be reclaimed and you can't free memory via oom killing, 
> > so there's nothing else the page allocator can do.
> 
> But I want it to give up in this case instead of looping forever.
> 
> Look.  I have a specific problem at hand that I want to solve and the approach
> you suggested _clearly_ _doesn't_ _work_.  I have also tried to explain to you
> why it doesn't work, but you're ingnoring it, so I really don't know what else
> I can say.
> 
> OTOH, the approach suggested by Andrew _does_ _work_ regardless of your
> opinion about it.  It's been tested and it's done the job 100% of the time.  Go
> figure.  And please stop beating the dead horse.
> 

Which implementation are you talking about?  You've had several:

	http://marc.info/?l=linux-kernel&m=124121728429113
	http://marc.info/?l=linux-kernel&m=124131049223733
	http://marc.info/?l=linux-kernel&m=124165031723627
	http://marc.info/?l=linux-kernel&m=124146681311494

The issue with your approach is that it doesn't address the problem; the 
problem is _not_ specific to individual page allocations it is specific to 
the STATE OF THE MACHINE.

If all userspace tasks are uninterruptible when trying to reserve this 
memory and, thus, oom killing is negligent and not going to help, that 
needs to be addressed in the page allocator.  It is a bug for the 
allocator to continuously retry the allocation unless __GFP_NOFAIL is set 
if oom killing will not free memory.

Adding a new __GFP_NO_OOM_KILL flag to address that isn't helpful since it 
has nothing at all to do with the specific allocation.  It may certainly 
be the easiest way to implement your patchset without doing VM work, but 
it's not going to fix the problem for others.

I just posted a patch series[*] that would fix this problem for you 
without even locking out the oom killer or adding any unnecessary gfp 
flags.  It is based on mmotm since it has Mel's page allocator speedups.  
Any change you do to the allocator at this point should be based on that 
to avoid nasty merge conflicts later, so try my series out and see how it 
works.

Now, I won't engage in your personal attacks because (i) nobody else 
cares, and (ii) it's not going to be productive.  I'll let my code do the 
talking.

 [*] http://lkml.org/lkml/2009/5/10/118
