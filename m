Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYHMPeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYHMPeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHMPeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:34:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:48258 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbYHMPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:34:05 -0400
Subject: Re: [PATCH 4/6] Replace inode flush semaphore with a completion
From: Daniel Walker <dwalker@mvista.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, matthew@wil.cx
In-Reply-To: <20080813075057.GZ6119@disturbed>
References: <1214556284-4160-1-git-send-email-david@fromorbit.com>
	 <1214556284-4160-5-git-send-email-david@fromorbit.com>
	 <1218597077.6166.15.camel@dhcp32.mvista.com>
	 <20080813075057.GZ6119@disturbed>
Content-Type: text/plain; charset=utf-8
Date: Wed, 13 Aug 2008 08:34:01 -0700
Message-Id: <1218641641.6166.32.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 17:50 +1000, Dave Chinner wrote:

> Right now we have the case where no matter what type of flush
> is done, the caller does not have to worry about unlocking
> the flush lock - it will be done as part of the flush. You're
> suggestion makes that conditional based on whether we did a
> sync flush or not.
> 
> So, what happenѕ when you call:
> 
> xfs_iflush(ip, XFS_IFLUSH_DELWRI_ELSE_SYNC);
> 
> i.e. xfs_iflush() may do an delayed flush or a sync flush depending
> on the current state of the inode. The caller has no idea what type
> of flush was done, so will have no idea whether to unlock or not.

You wouldn't base the unlock on what iflush does, you would
unconditionally unlock.

> > And remove the unlocking from inside xfs_iflush(). Then use a flag to
> > indicate that the flush is in progress, and a
> > completion/wait_for_completion when another thread needs to wait on the
> > flush to complete if it's an async flush.
> 
> And if it's a delayed flush? If we just wait for completion, we'll
> have to wait for a long time before the xfsbufd times out the buffer
> and pushes it to disk. This is important - the log AIL push code
> does try-locks on the flush lock to determine if the inode is in a
> delayed write state or not, and does an async buffer push inѕtead
> of xfs_iflush() to get it to disk immediately.

You wouldn't wait for completion of the flush unless the code really
needed to wait. Seems like your indicating that waiting on the flush is
rare. 

> That is, there are three types of inode flushes (sync, async and
> delwri) and the flush lock is used in different ways to determine
> what action to take when writing back inodes. There's much more to
> this 'flush lock' than just locking ;)

What I was saying is instead of using the flush lock as an indicator,
use some other non-lock based method.. A set of state flags protected by
the iflush lock for instance ..

Daniel

