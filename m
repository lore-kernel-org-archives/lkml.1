Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbXCZSau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbXCZSau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbXCZSau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:30:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45873 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753671AbXCZSat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:30:49 -0400
Date: Mon, 26 Mar 2007 11:30:47 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: balbir@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-Id: <20070326113047.faf591cb.pj@sgi.com>
In-Reply-To: <20070326115046.GK11794@in.ibm.com>
References: <20070325164746.GI11794@in.ibm.com>
	<4606B6CF.6040306@in.ibm.com>
	<20070326115046.GK11794@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
> Well, someone may have attached to this cpuset while we were waiting on the 
> mutex_lock(). So we need to do a atomic_read again to ensure it is still
> unused

pj replied:
> If we hold the task lock that now
> (thanks to your good work) guards this pointer, and if we decrement to
> zero the reference count on the cpuset to which it points 

I incorrectly described the locking, I think.

A cpusets reference count increases if either another task is attached
to it, or if a task already attached forks.

If we decrement to zero the count, we -know- that no more tasks are
attached to it.

If we hold the cpuset manage_mutex, then we -know- that attach_task can't
attach tasks to it.

But now that you mention it, that additional atomic_read of the count in
check_for_release() seems suspicious to me.  I'm afraid that the following
could happen:

    1) given cpusets A and A/B, with a single task attached to A (none to B)
    2) some other tasks issues a "rmdir A/B"
    3) near the end of the cpuset_rmdir() code, after we have removed A/B, we
	invoke check_for_release()
    4) just at that instant, the single task in A exits, decrementing the
	count on A to zero
    5) both the exiting task and the task doing the rmdir execute the
	cpuset_release_agent() and check_for_release() code.

Aha - yes, maybe that could happen, but it is OK !!

Multiple tasks all pounding on the same cpuset with this release logic
is not a problem. That just ends up being multiple tasks doing a 'rmdir'
on that cpuset from user space.  At most one of them succeeds in
removing the directory, and if it is removed, then the remaining get an
error that there is no such directory.

The race I worried about in last nights post is NOT a problem:
> Is there perhaps another race here?  Could it happen that:
>  1) the atomic_dec() lowers the count to say one (any value > zero)
>  2) after we drop the task lock, some other task or tasks decrement
>     the count to zero
>  3) we catch that zero when we atomic_read the count, and issue a spurious
>     check_for_release().

This is one of the advantages of not actually unlinking cpusets at this point,
when it seems they are no longer used.  We just fire off a user mode helper
thread to attempt a subsequent removal.  That separate thread will get the locking
correct, from the top down, and if the cpuset is still really and truly unused,
then and only then actually remove it.

Simultaneous spurious check_for_release() calls are not a problem!

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
