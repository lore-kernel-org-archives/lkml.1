Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbXISU3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbXISU3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXISU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:29:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbXISU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:29:03 -0400
Date: Wed, 19 Sep 2007 13:28:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Chuck Ebbert <cebbert@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
In-Reply-To: <20070919195633.GA23595@elte.hu>
Message-ID: <alpine.LFD.0.999.0709191306530.16478@woody.linux-foundation.org>
References: <20070913112427.GA20686@elte.hu> <20070914083246.GA20514@elte.hu>
 <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
 <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu>
 <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu>
 <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu>
 <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org>
 <20070919195633.GA23595@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2007, Ingo Molnar wrote:
> 
> in CFS we dont have a per-nice-level rbtree, so we cannot move it dead 
> last within the same priority group - but we can move it dead last in 
> the whole tree. (then they'd be put even after nice +19 tasks.) People 
> might complain about _that_.

Yeah, with reasonably good reason.

The sched_yield() behaviour is actually very well-defined for RT tasks 
(now, whether it's a good interface to use or not is still open to debate, 
but at least it's a _defined_ interface ;), and I think we should at least 
try to approximate that behaviour for normal tasks, even if they aren't 
RT.

And the closest you can get is basically to say something that is close to

	"sched_yield()" on a non-RT process still means that all
	other runnable tasks in that same nice-level will be scheduled 
	before the task is scheduled again.

and I think that would be the optimal approximation of the RT behaviour.

Now, quite understandably we might not be able to actually get that 
*exact* behaviour (since we mix up different nice levels), but I think 
from a QoI standpoint we should really have that as a "target" behaviour.

So I think it should be moved back in the RB-tree, but really preferably 
only back to behind all other processes at the same nice-level.

So I think we have two problems with yield():

 - it really doesn't have very nice/good semantics in the first place for 
   anything but strict round-robin RT tasks.

   We can't do much about this problem, apart from trying to make people 
   use proper locking and other models that do *not* depend on yield().

 - Linux has made the problem a bit worse by then having fairly arbitrary 
   and different semantics over time.

   This is where I think it would be a good idea to try to have the above 
   kind of "this is the ideal behaviour - we don't guarantee it being 
   precise, but at least we'd have some definition of what people should 
   be able to expect is the "best" behaviour.

So I don't think a "globally last" option is at all the best thing, but I 
think it's likely better than what CFS does now. And if we then have some 
agreement on what would be considered a further _improvement_, then that 
would be a good thing - maybe we're not perfect, but at least having a 
view of what we want to do is a good idea.

Btw, the "enqueue at the end" could easily be a statistical thing, not an 
absolute thing. So it's possible that we could perhaps implement the CFS 
"yield()" using the same logic as we have now, except *not* calling the 
"update_stats()" stuff:

	__dequeue_entity(..);
	__enqueue_entity(..);

and then just force the "fair_key" of the to something that 
*statistically* means that it should be at the end of its nice queue.

I dunno.

		Linus
