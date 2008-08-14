Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYHNATz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYHNATz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYHNATq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:19:46 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:29374 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbYHNATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:19:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiADAOQVo0h5LAMbiGdsb2JhbACRcwEBAQ8gpHmBVQ
X-IronPort-AV: E=Sophos;i="4.32,204,1217773800"; 
   d="scan'208";a="181591993"
Date: Thu, 14 Aug 2008 10:19:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: [PATCH 4/6] Replace inode flush semaphore with a completion
Message-ID: <20080814001938.GC6119@disturbed>
Mail-Followup-To: Daniel Walker <dwalker@mvista.com>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org, matthew@wil.cx
References: <1214556284-4160-1-git-send-email-david@fromorbit.com> <1214556284-4160-5-git-send-email-david@fromorbit.com> <1218597077.6166.15.camel@dhcp32.mvista.com> <20080813075057.GZ6119@disturbed> <1218641641.6166.32.camel@dhcp32.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1218641641.6166.32.camel@dhcp32.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 08:34:01AM -0700, Daniel Walker wrote:
> On Wed, 2008-08-13 at 17:50 +1000, Dave Chinner wrote:
> 
> > Right now we have the case where no matter what type of flush
> > is done, the caller does not have to worry about unlocking
> > the flush lock - it will be done as part of the flush. You're
> > suggestion makes that conditional based on whether we did a
> > sync flush or not.
> > 
> > So, what happenѕ when you call:
> > 
> > xfs_iflush(ip, XFS_IFLUSH_DELWRI_ELSE_SYNC);
> > 
> > i.e. xfs_iflush() may do an delayed flush or a sync flush depending
> > on the current state of the inode. The caller has no idea what type
> > of flush was done, so will have no idea whether to unlock or not.
> 
> You wouldn't base the unlock on what iflush does, you would
> unconditionally unlock.

It's not really a flush lock at that point - it's a state lock.
We've already got one of those, and a set of state flags that it
protects.

Basically you're suggesting that we keep external state to the
completion that tracks whether a completion is in progress
or not. You can't use a mutex like you suggested to protect
state because you can't hold it while doing a wait_for_completion()
and then use it to clear the state flag before calling complete().
We can use the internal inode state flags and lock to keep
track of this. i.e:

xfs_iflock(
	xfs_inode_t	*ip)
{
	xfs_iflags_set(ip, XFS_IFLUSH_INPROGRESS);
	wait_for_completion(ip->i_flush_wq);
}

xfs_iflock_nowait(
	xfs_inode_t	*ip)
{
	if (xfs_iflags_test(ip, XFS_IFLUSH_INPROGRESS))
		return 1;
	xfs_iflags_set(ip, XFS_IFLUSH_INPROGRESS);
	wait_for_completion(ip->i_flush_wq);
	return 0;
}

xfs_ifunlock(
	xfs_inode_t	*ip)
{
	xfs_iflags_clear(ip, XFS_IFLUSH_INPROGRESS);
	complete(ip->i_flush_wq);
}

*However*, given that we already have this exact state in the
completion itself, I see little reason for adding the additional
locking overhead and the complexity of race conditions of keeping
this state coherent with the completion. Modifying the completion
API slightly to export this state is the simplest, easiest solution
to the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
