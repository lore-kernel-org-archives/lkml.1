Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbZEGVqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbZEGVqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZEGVqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:46:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:53202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZEGVql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:46:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=XAUSmj2+SvJmHk6HE/NKKU803slYwkeJFbR1wXvvPdsjbI/QCmVpVPwo3wsWsQmwX
	6MZrONe4iXqTarz6FRSWg==
Date: Thu, 7 May 2009 14:46:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905072336.11383.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905071439370.24404@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090507135615.e7db550d.akpm@linux-foundation.org> <alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com> <200905072336.11383.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Rafael J. Wysocki wrote:

> > The fact is that _all_ allocations here are implicitly __GFP_NO_OOM_KILL 
> > whether it specifies it or not since the oom killer would simply kill a 
> > task in D state which can't exit or free memory and subsequent allocations 
> > would make the oom killer a no-op because there's an eligible task with 
> > TIF_MEMDIE set.  The only thing you're saving with __GFP_NO_OOM_KILL is 
> > calling the oom killer in a first place and killing an unresponsive task 
> 
> That's exactly what we're trying to do.  We don't want tasks to get killed just
> because we're freeing memory for hibernation image.
> 

Then, again, why can't you just lock out the oom killer as I suggested if 
__GFP_NO_OOM_KILL is actually implied for all allocations when 
preallocating?  It prevents adding an unnecessary gfp flag, sprinkling it 
around in the hibernation code, and a comment would actually explain why 
it's the right thing to do (i.e. no other threads other than kthreads 
could possibly be executing the oom killer and if they are oom then we'll 
have to kill a userspace task anyway when thawed).

> > but that would have to happen anyway when thawed since the system is oom 
> > (or otherwise lockup for GFP_KERNEL with order < PAGE_ALLOC_COSTLY_ORDER).
> 
> Are you sure?  The image memory is freed before thawing tasks.
> 

If you try to allocate any non-__GFP_NORETRY memory such as GFP_KERNEL 
with order < PAGE_ALLOC_COSTLY_ORDER and direct reclaim cannot free memory 
(and the oom killer is implicitly a no-op whether you specify 
__GFP_NO_OOM_KILL or not), then you could loop endlessly in the page 
allocator.  When allocating GFP_IMAGE you need to ensure that can't happen 
and __GFP_NORETRY may not be your best option because it could fail 
unnecessarily when reclaim could have helped.
