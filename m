Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYHMHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYHMHvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYHMHvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:51:05 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:14240 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbYHMHvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:51:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANwtokh5LAMb/2dsb2JhbAC3CoFV
X-IronPort-AV: E=Sophos;i="4.32,200,1217773800"; 
   d="scan'208";a="181031853"
Date: Wed, 13 Aug 2008 17:50:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: [PATCH 4/6] Replace inode flush semaphore with a completion
Message-ID: <20080813075057.GZ6119@disturbed>
Mail-Followup-To: Daniel Walker <dwalker@mvista.com>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org, matthew@wil.cx
References: <1214556284-4160-1-git-send-email-david@fromorbit.com> <1214556284-4160-5-git-send-email-david@fromorbit.com> <1218597077.6166.15.camel@dhcp32.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1218597077.6166.15.camel@dhcp32.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 08:11:17PM -0700, Daniel Walker wrote:
> On Fri, 2008-06-27 at 18:44 +1000, Dave Chinner wrote:
> > Use the new completion flush code to implement the inode
> > flush lock. Removes one of the final users of semaphores
> > in the XFS code base.
> > 
> > Version 2:
> > o make flock functions static inlines
> > o use new completion interfaces
> 
> I was looking over this lock in XFS .. The iflock/ifunlock seem to be
> very much like mutexes in most of the calling locations.

Semaphores, not mutexes. The unlock most commonly happens in a
different context (i.e. I/O completion).

> Where the lock
> happens at the start, and the unlock happens when the function calls
> bottom out. It seems like a better way to go would be to change from,
> 
> xfs_ilock(uqp, XFS_ILOCK_EXCL);
> xfs_iflock(uqp);
> error = xfs_iflush(uqp, XFS_IFLUSH_SYNC);
> 
> Where xfs_iflush eventually does the unlock to,
> 
> xfs_ilock(uqp, XFS_ILOCK_EXCL);
> xfs_iflock(uqp);
> error = xfs_iflush(uqp, XFS_IFLUSH_SYNC);
> xfs_ifunlock(uqp);

Firstly, sync flushes are rare. Async are common.

Right now we have the case where no matter what type of flush
is done, the caller does not have to worry about unlocking
the flush lock - it will be done as part of the flush. You're
suggestion makes that conditional based on whether we did a
sync flush or not.

So, what happenѕ when you call:

xfs_iflush(ip, XFS_IFLUSH_DELWRI_ELSE_SYNC);

i.e. xfs_iflush() may do an delayed flush or a sync flush depending
on the current state of the inode. The caller has no idea what type
of flush was done, so will have no idea whether to unlock or not.

> And remove the unlocking from inside xfs_iflush(). Then use a flag to
> indicate that the flush is in progress, and a
> completion/wait_for_completion when another thread needs to wait on the
> flush to complete if it's an async flush.

And if it's a delayed flush? If we just wait for completion, we'll
have to wait for a long time before the xfsbufd times out the buffer
and pushes it to disk. This is important - the log AIL push code
does try-locks on the flush lock to determine if the inode is in a
delayed write state or not, and does an async buffer push inѕtead
of xfs_iflush() to get it to disk immediately.

That is, there are three types of inode flushes (sync, async and
delwri) and the flush lock is used in different ways to determine
what action to take when writing back inodes. There's much more to
this 'flush lock' than just locking ;)

> That seems vastly more complex than your current patch, but I think it
> will be much cleaner ..

Doesn't seem that way to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
