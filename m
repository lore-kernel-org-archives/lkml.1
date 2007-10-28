Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXJ1RrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXJ1RrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXJ1RrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:47:11 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43680 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbXJ1RrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:47:10 -0400
Date: Sun, 28 Oct 2007 13:47:09 -0400
To: "George G. Davis" <gdavis@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix hang in posix_locks_deadlock()
Message-ID: <20071028174709.GC16905@fieldses.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026224707.GO13033@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 06:47:08PM -0400, J. Bruce Fields wrote:
> Hm.  After another look: assume we have four tasks, t1, t2, t3, and t4.
> Assume t1 and t2 share the same current->files (so they're the same
> "owner" for the purpose of posix_same_owner()).  Assume:
> 
> 	t1 is waiting on a conflicting lock held by t3.
> 	t2 is waiting on a conflicting lock held by t4.
> 
> Now suppose t4 requests a lock that conflicts with a lock held by t1 and
> t2.  The list_for_each_entry() above will search for a task with t1 or
> t2 as owner, which is waiting on a lock.  If it finds t1 first, the loop
> won't be noticed, so t4 will be put to sleep.  Now we have a loop; t3
> can release its lock (it no longer matters), and we'll have
> 
> 	t2 waiting on a conflicting lock held by t4, and
> 	t4 waiting on a conflicting lock held by t2.
> 
> If a new task t5 then requests a lock conflicting with the one held by
> t2, then the above function will go into an infinite loop.  I think.
> 
> Consider the directed graph with each vertex representing the set of all
> tasks sharing the same file table, and each edge representing the
> relationship "a task at this vertex is waiting on a lock held by a task
> on another vertex".  The existance of multiple tasks with the same file
> table means that we can no longer assume that each vertex has outdegree
> at most one, so we have to switch to an algorithm that works on an
> arbitrary directed graph.  That sounds painful.
> 
> Am I right about that, and about the example above?  It'd be interesting
> to code it up just to make sure.
> 
> If so, one can imagine various bandaids, but maybe we should just rip
> out the deadlock detection completely.... It's hard to imagine it being
> really useful anyway.

OK, well I cooked up a similar example, which was kind of fun, and
verified that I can indeed lock up the kernel this way.

The only way this can happen, though, is if you already have deadlocked
threads--that is to say, two threads that are each waiting on posix file
locks held by the other.  (Or a similar cycle of length more than 2.) So
hopefully your application is doing some other kind of deadlock
detection (e.g. by killing threads that block for too long); otherwise
it already has a bug.

--b.
