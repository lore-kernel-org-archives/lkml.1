Return-Path: <linux-kernel-owner+w=401wt.eu-S1422796AbXBALHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796AbXBALHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXBALHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:07:55 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53239 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbXBALHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:07:51 -0500
Date: Thu, 1 Feb 2007 16:43:07 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Message-ID: <20070201111307.GA24723@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <patchbomb.1170193181@tetsuo.zabbo.net> <p73abzzpo75.fsf@bingen.suse.de> <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com> <200701311821.59579.ak@suse.de> <FA06EB13-4BF6-4E3A-B223-6494079F541F@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA06EB13-4BF6-4E3A-B223-6494079F541F@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 11:23:39AM -0800, Zach Brown wrote:
> On Jan 31, 2007, at 9:21 AM, Andi Kleen wrote:
> 
> >On Wednesday 31 January 2007 18:15, Zach Brown wrote:
> >>
> >>On Jan 31, 2007, at 12:58 AM, Andi Kleen wrote:
> >>
> >>>Do you have any numbers how this compares cycle wise to just doing
> >>>clone+syscall+exit in user space?
> >>
> >>Not yet, no.  Release early, release often, and all that.  I'll throw
> >>something together.
> >
> >So what was the motivation for doing this then?
> 
> Most fundamentally?  Providing AIO system call functionality at a  
> much lower maintenance cost.  The hope is that the cost of adopting  
> these fibril things will be lower than the cost of having to touch a  
> code path that wants AIO support.
> 
> I simply don't believe that it's cheap to update code paths to  
> support non-blocking state machines.  As just one example of a  
> looming cost, consider the retry-based buffered fs AIO patches that  
> exist today.  Their requirement to maintain these precisely balanced  
> code paths that know to only return -EIOCBRETRY once they're at a  
> point where retries won't access current-> seems.. unsustainable to  
> me.  This stems from the retries being handled off in the aio kernel  
> threads which have their own task_struct.  fs/aio.c goes to the  
> trouble of migrating ->mm from the submitting task_struct, but  
> nothing else.  Continually adjusting this finely balanced  
> relationship between paths that return -EIOCBRETY and the fields of  
> task_struct that fs/aio.c knows to share with the submitting context  
> seems unacceptably fragile.

Wooo ...hold on ... I think this is swinging out of perspective :)

I have said some of this before, but let me try again.

As you already discovered when going down the fibril path, there are
two kinds of accesses to current-> state, (1) common state
for a given call chain (e.g. journal info etc), and (2) for 
various validations against the caller's process (uid, ulimit etc). 

(1) is not an issue when it comes to execution in background threads
(the VFS already uses background writeback for example).

As for (2), such checks need to happen upfront at the time of IO submission,
so again are not an issue.

This is aside from access to the caller's address space, a familiar
concept which the AIO threads use. If there is any state that
relates to address space access, then it belongs in the ->mm struct, rather
than in current (and we should fix that if we find anything which isn't
already there).

I don't see any other reason why IO paths should be assuming that they are
running in the original caller's context, midway through doing the IO. If
that were the case background writeouts and readaheads could be fragile as
well (or ptrace). The reason it isn't is because of this conceptual division of
responsibility.

Sure, having explicit separation of submission checks as an interface
would likely make this clearer and cleaner, but I'm just
pointing out that usage of current-> state isn't and shouldn't be arbitrary
when it comes to filesystem IO paths. We should be concerned in any case
if that starts happening.

Of course, this is fundamentally connected to the way filesystem IO is
designed to work, and may not necessarily apply to all syscal

When you want to make any and every syscall asynchronous, then indeed
the challenge is magnified and that is where it could get scary. But that
isn't the problem the current AIO code is trying to tackle.

> 
> Even with those buffered IO patches we still only get non-blocking  
> behaviour at a few specific blocking points in the buffered IO path.   
> It's nothing like the guarantee of non-blocking submission returns  
> that the fibril-based submission guarantees.

This one is a better reason, and why I have thought of fibrils (or the
equivalent alternative of enhancing kernel theads to become even lighter)
as an interesting fallback option to implement AIO for cases which we
haven't (maybe some of which are too complicated) gotton around to
supporting natively. Especially if it could be coupled with some clever
tricks to keep stack space to be minimal (I have wondered whether any of
the ideas from similar user-level efforts like Cappricio, or laio would help).

> 
> >  It's only point
> >is to have smaller startup costs for AIO than clone+fork without
> >fixing the VFS code to be a state machine, right?
> 
> Smaller startup costs and fewer behavioural differences.  Did that  
> message to Nick about ioprio and io_context resonate with you at all?
> 
> >I'm personally unclear if it's really less work to teach a lot of
> >code in the kernel about a new thread abstraction than changing VFS.
> 
> Why are we limiting the scope of moving to a state machine just to  
> the VFS?  If you look no further than some hypothetical AIO iscsi/aoe/ 
> nbd/whatever target you obviously include networking.  Probably splice 
> () if you're aggressive :).
> 
> Let's be clear.  I would be thrilled if AIO was implemented by native  
> non-blocking handler implementations.  I don't think it will happen.   
> Not because we don't think it sounds great on paper, but because it's  
> a hugely complex endeavor that would take development and maintenance  
> effort away from the task of keeping basic functionality working.
> 
> So the hope with fibrils is that we lower the barrier to getting AIO  
> syscall support across the board at an acceptable cost.
> 
> It doesn't *stop* us from migrating very important paths (storage,  
> networking) to wildly optimized AIO implementations.  But it also  
> doesn't force AIO support to wait for that.
> 
> >Your patches don't look that complicated yet but you openly
> >admitted you waved away many of the more tricky issues (like
> >signals etc.) and I bet there are yet-unknown side effects
> >of this too that will need more changes.
> 
> To quibble, "waved away" implies that they've been dismissed.  That's  
> not right.  It's a work in progress, so yes, there will be more  
> fiddly details discovered and addressed over time.  The hope is that  
> when it's said and done it'll still be worth merging.  If at some  
> point it gets to be too much, well, at least we'll have this work to  
> reference as a decisive attempt.
> 
> >I'm not sure the fibrils thing will be that much faster than
> >a possibly somewhat fast pathed for this case clone+syscall+exit.
> 
> I'll try and get some numbers for you sooner rather than later.
> 
> Thanks for being diligent, this is exactly the kind of hard look I  
> want this work to get.

BTW, I like the way you are approaching this with a cautiously
critical eye cognizant of lurking details/issues, despite the obvious
(and justified) excitement/eureka feeling.  AIO _is_ hard !

Regards
Suparna

> 
> - z
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

