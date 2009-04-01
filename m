Return-Path: <linux-kernel-owner+w=401wt.eu-S1763747AbZDALyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763747AbZDALyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZDALyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:54:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbZDALyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:54:05 -0400
Date: Wed, 1 Apr 2009 07:53:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on
 inode->dirtied_when checks (try #2)
Message-ID: <20090401075320.0f49b5bf@barsoom.rdu.redhat.com>
In-Reply-To: <20090401065618.GB10423@localhost>
References: <1238544239-31882-1-git-send-email-jlayton@redhat.com>
	<20090331172031.b2971f1e.akpm@linux-foundation.org>
	<20090331205018.228ea5f8@tleilax.poochiereds.net>
	<20090331180730.049d42e7.akpm@linux-foundation.org>
	<20090401065618.GB10423@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 14:56:18 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Tue, Mar 31, 2009 at 06:07:30PM -0700, Andrew Morton wrote:
> > On Tue, 31 Mar 2009 20:50:18 -0400 Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > > On Tue, 31 Mar 2009 17:20:31 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Tue, 31 Mar 2009 20:03:59 -0400
> > > > Jeff Layton <jlayton@redhat.com> wrote:
> > > > 
> > > > > +		 * It's not sufficient to just do a time_after() check on
> > > > > +		 * dirtied_when. That assumes that dirtied_when will always
> > > > > +		 * change within a period of jiffies that encompasses half the
> > > > > +		 * machine word size (2^31 jiffies on 32-bit arch). That's not
> > > > > +		 * necessarily the case if an inode is being constantly
> > > > > +		 * redirtied. Since dirtied_when can never be in the future,
> > > > > +		 * we can assume that if it appears to be so then it is
> > > > > +		 * actually in the distant past.
> > > > 
> > > > so this really is a 32-bit-only thing.
> > > > 
> > > > I guess that isn't worth optimising for though.
> > > > 
> > > 
> > > Yeah, it's pretty much impossible to hit this on a 64-bit machine.
> > > 
> > > > otoh, given that all three comparisons are the same:
> > > > 
> > > > +			time_after(inode->dirtied_when, *older_than_this) &&
> > > > +			time_before_eq(inode->dirtied_when, jiffies))
> > > > 
> > > > (although one is inverted (i think?)), it might end up nicer if this was all done
> > > > in a little helper function?
> > > > 
> > > > That way we only need to comment what's going on at a single site, and
> > > > we could omit the additional test if !CONFIG_64BIT.
> > > 
> > > Ok, that seems reasonable.
> > > 
> > > At one point I had a macro similar to time_in_range(), but dropped it
> > > primarily because time_after_but_before_eq() wasn't easy on the eyes.
> > > Thoughts on better names?
> > 
> > I was thinking
> > 
> > 	bool inode_dirtied_after(...);
> > 
> > and just leave the innards using time_after() and time_before_eq()?
> 
> Andrew, here is the updated patch. Note that the first chunk for
> redirty_tail() was not absolutely necessary and so removed.
> 
> Thanks,
> Fengguang
> ---
> Subject: writeback: guard against jiffies wraparound on inode->dirtied_when checks
> From:	Jeff Layton <jlayton@redhat.com>
> 
> The dirtied_when value on an inode is supposed to represent the first
> time that an inode has one of its pages dirtied. This value is in units
> of jiffies. It's used in several places in the writeback code to
> determine when to write out an inode.
> 
> The problem is that these checks assume that dirtied_when is updated
> periodically. If an inode is continuously being used for I/O it can be
> persistently marked as dirty and will continue to age. Once the time
> difference between dirtied_when and the jiffies value it is being
> compared to is greater than or equal to half the maximum of the jiffies
> type, the logic of the time_*() macros inverts and the opposite of what
> is needed is returned. On 32-bit architectures that's just under 25 days
> (assuming HZ == 1000).
> 
> As the least-recently dirtied inode, it'll end up being the first one
> that pdflush will try to write out. sync_sb_inodes() does this check:
> 
> 	/* Was this inode dirtied after sync_sb_inodes was called? */
>  	if (time_after(inode->dirtied_when, start))
>  		break;
> 
> ...but now dirtied_when appears to be in the future. sync_sb_inodes()
> bails out without attempting to write any dirty inodes. When this
> occurs, pdflush will stop writing out inodes for this superblock.
> Nothing can unwedge it until jiffies moves out of the problematic
> window.
> 
> Fix this problem by changing the checks against dirtied_when to also
> check whether it appears to be in the future. If it does, then we
> consider the value to be far in the past.
> 
> This should shrink the problematic window of time to such a small
> period(30s) as not to matter.
> 
> Acked-by: Ian Kent <raven@themaw.net>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |   26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> --- mm.orig/fs/fs-writeback.c
> +++ mm/fs/fs-writeback.c
> @@ -196,7 +196,7 @@ static void redirty_tail(struct inode *i
>  		struct inode *tail_inode;
>  
>  		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
> -		if (!time_after_eq(inode->dirtied_when,
> +		if (time_before(inode->dirtied_when,
>  				tail_inode->dirtied_when))
>  			inode->dirtied_when = jiffies;
>  	}

I think we need a similar change in this function in order to maintain
the list order.

Consider this case:

We have an s_dirty list with a head inode that appears to be in the
future. We start writeback and clear out s_dirty (all of the inodes are
moved to s_io). A new inode is dirtied, and goes onto the empty s_dirty
list with a dirtied_when value that equals now. The inode with the
dirtied_when value that looks like it's in the future is redirtied while
being written and redirty_tail is called. It goes back on the list
without resetting dirtied_when even though it's actually older than the
inode at the tail.

There is another option too that I'll throw out here...

We could just make dirtied_when a 64 bit value on 32 bit machines and
use jiffies_64 there. On the upside there is no "problematic
window" with that. The downside is that struct inode would grow by 4
bytes on 32 bit arches, and checking jiffies_64 on such an arch is
more computationally intensive. We'd also have to change the size of
older_than_this value in the writeback_control struct too if we want to
go this route...


> @@ -220,6 +220,21 @@ static void inode_sync_complete(struct i
>  	wake_up_bit(&inode->i_state, __I_SYNC);
>  }
>  
> +static bool inode_dirtied_after(struct inode *inode, unsigned long t)
> +{
> +	bool ret = time_after(inode->dirtied_when, t);
> +#ifndef CONFIG_64BIT
> +	/*
> +	 * For inodes being constantly redirtied, dirtied_when can get stuck.
> +	 * It _appears_ to be in the future, but is actually in distant past.
> +	 * This test is necessary to prevent such wrapped-around relative times
> +	 * from permanently stopping the whole pdflush writeback.
> +	 */
> +	ret = ret && time_before_eq(inode->dirtied_when, jiffies);
> +#endif
> +	return ret;
> +}
> +
>  /*
>   * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
>   */
> @@ -231,7 +246,7 @@ static void move_expired_inodes(struct l
>  		struct inode *inode = list_entry(delaying_queue->prev,
>  						struct inode, i_list);
>  		if (older_than_this &&
> -			time_after(inode->dirtied_when, *older_than_this))
> +				inode_dirtied_after(inode, *older_than_this))
>  			break;
>  		list_move(&inode->i_list, dispatch_queue);
>  	}
> @@ -492,8 +507,11 @@ void generic_sync_sb_inodes(struct super
>  			continue;		/* blockdev has wrong queue */
>  		}
>  
> -		/* Was this inode dirtied after sync_sb_inodes was called? */
> -		if (time_after(inode->dirtied_when, start))
> +		/*
> +		 * Was this inode dirtied after sync_sb_inodes was called?
> +		 * This keeps sync from extra jobs and livelock.
> +		 */
> +		if (inode_dirtied_after(inode, start))
>  			break;
>  
>  		/* Is another pdflush already flushing this queue? */


-- 
Jeff Layton <jlayton@redhat.com>
