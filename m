Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbZF3Il2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbZF3Il2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZF3IlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:41:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZF3IlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:41:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MDIRTWwo731JFeejPp5erBNjC0ga3usRfZr+5AZ7T4phSuVfTLqKkgoeWfq1Z7jjJ
	Uuyf5O7lRpVn9NbYp/pTA==
Date: Tue, 30 Jun 2009 01:41:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090630082415.GC11980@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0906300128510.16291@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie> <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com> <20090630074717.GA11980@wotan.suse.de>
 <alpine.DEB.2.00.0906300050530.11018@chino.kir.corp.google.com> <20090630082415.GC11980@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Nick Piggin wrote:

> > I'd agree with Mel's added check for TIF_MEMDIE upon returning from the 
> > oom killer, but only for __GFP_NOMEMALLOC.
> 
> NOMEMALLOC indeed should always be kept away from memalloc/memdie
> reserves. That's how it should have worked when I added it (but
> I may have forgotten TIF_MEMDIE, I can't remember).
> 

Yeah, so if test_thread_flag(TIF_MEMDIE) and __GFP_NOMEMALLOC, then it 
makes sense to return NULL immediately following the call to the oom 
killer for !__GFP_NOFAIL since retrying the allocation is pointless 
(reclaim failed already and TIF_MEMDIE doesn't help us on the next 
attempt) at that time.

> > The oom killer currently is a no-op if any eligible task has TIF_MEMDIE, 
> > so this would require adding an oom killer timeout so that if a task fails 
> > to exit after a predefined period, TIF_MEMDIE is cleared and the task is 
> > marked to no longer be selected (which would require an addition to 
> > task_struct) although it may have already completely depleted memory 
> > reserves.
> 
> It wouldn't have to be a timeout, it could be a call back to the
> oom killer.
> 

Calling the oom killer won't do anything since it will not kill another 
task while another has TIF_MEMDIE to protect those memory reserves and 
give the oom killed task a chance to exit.

Panicking when a thread with TIF_MEMDIE set cannot find any memory and the 
allocation is __GFP_NOFAIL makes sense, but only for order 0.
