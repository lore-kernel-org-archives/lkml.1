Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYF0EOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYF0EOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYF0EN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:13:56 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:62871 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbYF0ENz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:13:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANexXkh5LFnm/2dsb2JhbACuPg
X-IronPort-AV: E=Sophos;i="4.27,713,1204464600"; 
   d="scan'208";a="144183943"
Date: Fri, 27 Jun 2008 14:13:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] Replace inode flush semaphore with a completion
Message-ID: <20080627041351.GY29319@disturbed>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-3-git-send-email-david@fromorbit.com> <20080627023011.GC7703@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627023011.GC7703@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:30:11PM -0600, Matthew Wilcox wrote:
> On Thu, Jun 26, 2008 at 02:41:13PM +1000, Dave Chinner wrote:
> > Use the new completion flush code to implement the inode
> > flush lock. Removes one of the final users of semaphores
> > in the XFS code base.
> 
> Let's demonstrate converting this one to completions ...

Great. I need all the help I can get. ;)

> > --- a/fs/xfs/xfs_iget.c
> > +++ b/fs/xfs/xfs_iget.c
> > @@ -216,7 +216,7 @@ finish_inode:
> >  	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
> >  	init_waitqueue_head(&ip->i_ipin_wait);
> >  	atomic_set(&ip->i_pincount, 0);
> > -	initnsema(&ip->i_flock, 1, "xfsfino");
> > +	init_completion_flush(&ip->i_flush);
> 
> +	init_completion(&ip->i_flush);
> +	complete(&ip->i_flush);

Ok, that would work. Need commenting, though.

> >  int
> >  xfs_iflock_nowait(xfs_inode_t *ip)
> >  {
> > -	return (cpsema(&(ip->i_flock)));
> > +	return completion_flush_start_nowait(&ip->i_flush);
> 
> This is where you need a new function ...
> 
> +	return nowait_for_completion(&ip->i_flush);
> 
> Yes, we probably need a better name for the down_trylock() equivalent.

I suggested try_wait_for_completion() in a different email - it's
a difficult on to say "a wait_for_completion() call that doesn't
wait"....

I think I'll stick with the try_.... version to match other "try"
operations.


> >  int
> > @@ -3070,7 +3069,7 @@ xfs_iflush(
> >  	XFS_STATS_INC(xs_iflush_count);
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> > -	ASSERT(issemalocked(&(ip->i_flock)));
> > +	ASSERT(completion_flush_inprogress(&ip->i_flush));
> 
> is_complete()?

That's a little to general for my liking - I note that there
are already an existing is_complete() function in a driver.
completion_done() perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
