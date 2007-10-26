Return-Path: <linux-kernel-owner+w=401wt.eu-S1765316AbXJZWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765316AbXJZWrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXJZWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:47:11 -0400
Received: from mail.fieldses.org ([66.93.2.214]:58838 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbXJZWrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:47:09 -0400
Date: Fri, 26 Oct 2007 18:47:08 -0400
To: "George G. Davis" <gdavis@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix hang in posix_locks_deadlock()
Message-ID: <20071026224707.GO13033@fieldses.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026170750.GC13033@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 01:07:50PM -0400, bfields wrote:
> On Thu, Oct 18, 2007 at 02:57:59PM -0400, George G. Davis wrote:
> > On Wed, Oct 17, 2007 at 02:51:57PM -0400, George G. Davis wrote:
> > > ---
> > > Not sure if this is the correct fix but it does resolve the hangs we're
> > > observing in posix_locks_deadlock().
> > 
> > Please disregard the previous patch, it's not quite right - causes occasional
> > segfaults and clearly did not retain the posix_same_owner() checks implemented
> > in the original code.  Here's a new version which I believe retains the
> > intent of the original code:
> > 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 7f9a3ea..e012b27 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -702,14 +702,12 @@ static int posix_locks_deadlock(struct file_lock *caller_fl,
> >  {
> >  	struct file_lock *fl;
> >  
> > -next_task:
> >  	if (posix_same_owner(caller_fl, block_fl))
> >  		return 1;
> >  	list_for_each_entry(fl, &blocked_list, fl_link) {
> >  		if (posix_same_owner(fl, block_fl)) {
> > -			fl = fl->fl_next;
> > -			block_fl = fl;
> > -			goto next_task;
> > +			if (posix_same_owner(caller_fl, fl))
> > +				return 1;
> >  		}
> >  	}
> >  	return 0;
> 
> It may take multiple steps to identify a deadlock.  With the above
> you'll miss deadlocks like
> 
> 	process 1 is requesting a lock held by process 2
> 	process 2 is blocking on a lock held by process 3
> 	process 3 is blocking on a lock held by process 1.
> 
> Could you give more details about how you're causing
> posix_locks_deadlock to hang?  Is there a simple test-case you can post?

Hm.  After another look: assume we have four tasks, t1, t2, t3, and t4.
Assume t1 and t2 share the same current->files (so they're the same
"owner" for the purpose of posix_same_owner()).  Assume:

	t1 is waiting on a conflicting lock held by t3.
	t2 is waiting on a conflicting lock held by t4.

Now suppose t4 requests a lock that conflicts with a lock held by t1 and
t2.  The list_for_each_entry() above will search for a task with t1 or
t2 as owner, which is waiting on a lock.  If it finds t1 first, the loop
won't be noticed, so t4 will be put to sleep.  Now we have a loop; t3
can release its lock (it no longer matters), and we'll have

	t2 waiting on a conflicting lock held by t4, and
	t4 waiting on a conflicting lock held by t2.

If a new task t5 then requests a lock conflicting with the one held by
t2, then the above function will go into an infinite loop.  I think.

Consider the directed graph with each vertex representing the set of all
tasks sharing the same file table, and each edge representing the
relationship "a task at this vertex is waiting on a lock held by a task
on another vertex".  The existance of multiple tasks with the same file
table means that we can no longer assume that each vertex has outdegree
at most one, so we have to switch to an algorithm that works on an
arbitrary directed graph.  That sounds painful.

Am I right about that, and about the example above?  It'd be interesting
to code it up just to make sure.

If so, one can imagine various bandaids, but maybe we should just rip
out the deadlock detection completely.... It's hard to imagine it being
really useful anyway.

--b.
